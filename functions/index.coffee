# Cloud Functions For VocBox
# Imports
functions = require 'firebase-functions'
express = require 'express'
admin = require 'firebase-admin'
admin.initializeApp functions.config().firebase
request = require 'request-promise'
Language = require '@google-cloud/language'
Vision = require '@google-cloud/vision'

# Variables
apiKey = functions.config().firebase.apiKey
translateBaseUrl = "https://www.googleapis.com/language/translate/v2"
gcsImageBaseUrl = "gs://vocbox-test.appspot.com/vision_images/"

# Helper Functions
urlencode = (string) ->
  encodeURIComponent string

createTranslateUrl = (source, target, payload) ->
  "?model=nmt&key=" + apiKey + "&source=" + source + "&target=" + target + "&q=" + urlencode payload

# Translate Function
exports.translate = functions.https.onRequest (req, res) ->
  # Create $_GET equivalent
  _get = req.query
  console.log "Requested translate/" + JSON.stringify _get

  # Create Request URL
  translateParameters = createTranslateUrl _get.src, _get.trg, _get.q
  translateUrl = translateBaseUrl + translateParameters
  console.log "Translation Request: " + translateUrl

  # Run Request
  request(translateUrl, { resolveWithFullResponse: true }).then (response) ->
    console.log "Translation Status Code: " + response.statusCode
    console.log "Translation Result: " + response.body
    translatedJSON = JSON.parse response.body
    translatedText = translatedJSON.data.translations[0]
    console.log JSON.stringify translatedText
    #res.send translatedText
    res.send response.body

# Natural Language Processing Function
exports.analyzeTextSyntax = functions.https.onRequest (req, res) ->
  # Create $_GET equivalent
  _get = req.query
  console.log "Requested analyzeTextSyntax/" + JSON.stringify _get

  # Init Client Library
  language = Language()

  # Create Request
  text = _get.q
  request_params = {
    document: {
      content: text,
      type: 'PLAIN_TEXT'
    }
  }
  # 'content' : text;; analyzeSyntax({document: request_params})

  # Run Request
  language.analyzeSyntax(request_params)
    .then (results) ->
      # If Success Process & Return Results
      console.log "analyzeSyntax() succeeded: " + JSON.stringify results
      syntax = results[0].tokens
      syntax_lang = results[0].language
      syntax_result = {}

      #syntax.forEach (part) ->
      #  console.log "Test Success: " + JSON.stringify syntax_result
      #  syntax_result.push part.partOfSpeech.tag
      #console.log JSON.stringify syntax_result
      syntax_result = syntax

      # Make Result JSON
      result = {
        success: true,
        text: text,
        language: syntax_lang,
        result: syntax_result
      }
      result_json = JSON.stringify result

      # Send result
      console.log result_json
      #res.set "Cache-Control", "public, max-age=300, s-maxage=600"
      res.send result_json

    .catch (err) ->
      # If Fail, Return Error
      console.log "Error" if err?
      error = {
        success: false,
        text: text,
        error: err,
        result: []
      }
      error_json = JSON.stringify error

      # Send Error Info
      console.error error_json
      res.send error_json

# Vision Function
exports.annotateImage = functions.https.onRequest (req, res) ->
  # Create $_GET equivalent
  _get = req.query
  console.log "Requested annotateImage/" + JSON.stringify _get

  # Init Vision Client
  vision = Vision()

  # Prepare request
  fileName = gcsImageBaseUrl + _get.q
  if _get.mode == "labelDetection" or _get.mode == "textDetection"
    mode = _get.mode
  else
    res.send JSON.stringify { success: false }
    console.error "Invalid Mode"

  console.log "Requesting " + mode + " for " + fileName
  request = {
      source: {
        gcsImageUri: fileName
      }
  }

  # Run Request
  if mode == "labelDetection"
    vision.labelDetection(request)
      .then (results) ->
        labels = results[0].labelAnnotations
        labelsDescriptions = []

        labels.forEach (label) ->
          labelsDescriptions.push label.description

        labelsDescriptionsReturn = {
          success: true,
          labels: labelsDescriptions
        }
        labelsJSON = JSON.stringify labelsDescriptionsReturn

        console.log labelsJSON
        res.send labelsJSON

      .catch (err) ->
        error = {
          success: false,
          error: err
          labels: []
        }
        errorJSON = JSON.stringify error

        res.send errorJSON
        console.error 'ERROR:' + errorJSON

  else if mode == "textDetection"
    vision.textDetection(request)
      .then (results) ->
        resultDescription = results[0].textAnnotations[0].description

        result = {
          success: true,
          description: resultDescription
        }
        resultReturn = JSON.stringify result

        console.log resultReturn
        res.send resultReturn

      .catch (err) ->
        error = {
          success: false,
          error: err,
          description: ""
        }
        errorJSON = JSON.stringify error

        res.send errorJSON
        console.error 'ERROR:' + errorJSON
