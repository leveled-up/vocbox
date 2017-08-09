# Cloud Functions Code for VocBox 2
# (c) 2017 RunStorage Technologies
# ----------------------------------------

# Imports
functions = require 'firebase-functions'
express = require 'express'
url_utility = require 'url'
filesystem = require 'fs'

# VocNox Utility & Useful Functions
util = require './utility'

# Get Possible Requests
actions = require './actions.json'

# Initialize Express
app = express()
app.get "/*", (request, response) ->
  # Get & Process Request URL
  request_url = url_utility.parse request.url
  request_pathname = request_url.pathname
  if actions[request_pathname]?
    request_action = actions[request_pathname]
  else
    request_action = null

  # If requested "/" rewrite to "/index"
  request_action = "/index" if request_url.pathname == "/"

  # Log Request to Firebase Console
  console.log "req.url = " + request.url + "; req_action = " + request_action + ";"

  # If Action is found, run it
  if request_action?
    action_module = require './' + request_action.substr(1) + '_handler'
    console.log "Module available. (200)" + './' + request_action.substr(1) + '_handler'
    test()
    action_module.app request, response
  else
    console.log "Module not found. (404)"
    response.status 404
    response.send util.file_get_contents "404.html"

test = () ->
  console.log "Test"

# Export Express App as Cloud Function
exports.app = functions.https.onRequest app
