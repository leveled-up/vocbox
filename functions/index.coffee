# Cloud Functions For VocBox
# Imports
functions = require 'firebase-functions'
express = require 'express'
admin = require 'firebase-admin'
admin.initializeApp functions.config().firebase
request = require 'request-promise'
Language = require '@google-cloud/language'

# Variables
apiKey = functions.config().firebase.apiKey
translateBaseUrl = "https://www.googleapis.com/language/translate/v2"

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
      console.log JSON.stringify results[0].tokens[0]
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
