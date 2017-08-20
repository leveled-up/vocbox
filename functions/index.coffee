# Cloud Functions For VocBox
# Imports
functions = require 'firebase-functions'
express = require 'express'
admin = require'firebase-admin'
admin.initializeApp functions.config().firebase
request = require 'request'

# Variables
apiKey = functions.config().firebase.apiKey
translateBaseUrl = "https://www.googleapis.com/language/translate/v2"

# Helper Functions
urlencode = (string) ->
  encodeURIComponent string

createTranslateUrl = (source, target, payload) ->
  "?key=" + apiKey + "&source=" + source + "&target=" + target + "&q=" + urlencode payload

# Translate Function
translateApp = express().get "/*" (req, res) ->
  # Create $_GET equivalent
  _get = req.query

  # Create Request URL
  translateParameters = createTranslateUrl _get.src, _get.trg, _get.q
  translateUrl = translateBaseUrl + translateParameters

  # Run Request
 request(translateUrl, { resolveWithFullResponse: true }).then (response) ->
   console.log response.statusCode

exports.translates = functions.https.onRequest translateApp
