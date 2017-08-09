# Cloud Functions Code for VocBox 2
# (c) 2017 RunStorage Technologies
# ----------------------------------------

# Imports
functions = require 'firebase-functions'
express = require 'express'

# Initialize Express
app = express()
app.get "/", (request, response) ->
  response.send("<h1>Hi</h1>");

# Export Express App as Cloud Function
exports.app = functions.https.onRequest app
