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
    #translatedJSON = JSON.parse response.body
    #translatedText = translatedJSON.data.translations[0].translatedText
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
  document = {
    'content': text,
    type: 'PLAIN_TEXT'
  }

  # Run Request
  language.analyzeSyntax({ document: document })
    # On Completion
    .then (results) ->
      # If Success Process & Return Results
      syntax = results[0];
      console.log "Success"
      console.log JSON.stringify results[0].tokens[0].partOfSpeech
      console.log JSON.stringify results
      syntax_result = {}

      syntax.tokens.forEach (part) ->
        console.log part.partOfSpeech.tag
        syntax_result.push part

      # Make Result JSON
      result = {
        success: true,
        text: text,
        error_code: 0,
        result: syntax_result
      }
      result_json = JSON.stringify result

      # Send result
      console.log result_json
      #res.set "Cache-Control", "public, max-age=300, s-maxage=600"
      res.send result_json
      #
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
  vision = Vision();

  # Prepare request
  fileName = gcsImageBaseUrl + _get.q
  if _get.mode == "labelDetection" or _get.mode == "textDetection"
    mode = _get.mode
  else
    res.send JSON.stringify { success: false }
    console.error "Invalid Mode"

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
        console.log 'Labels:'
        labels.forEach (label) ->
          console.log label.description
          res.send label.description

      .catch (err) ->
        res.send 'Error'
        console.error 'ERROR:' + err
        
  elseif mode == "textDetection"
    vision.textDetection(image)
      .then (results) ->
        result = JSON.stringify results
        console.log result
        res.send result

      .catch (err) ->
        res.send 'Error'
        console.error 'ERROR:' + err
