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
# actions.urls is JSON of "URL": "MODULE_WITH_ACTION_FUNCTION",
# then in express check if available then load module and call module.app(req,res)

# Initialize Express
app = express()
app.get "/*", (request, response) ->
  # Get & Process Request URL
  request_url = url_utility.parse req.url
  request_action = actions[request_url.pathname]

  # If requested "/" rewrite to "/index"
  request_action = "/index" if request_url.pathname == "/"

  # If Action is found, run it
  if request_action?
    action_module = require './' + request_action.substr 1 + '_handler'
    action_module.app request, response
  else
    response.status 404
    response.send file_get_contents "404.html"

# Export Express App as Cloud Function
exports.app = functions.https.onRequest app
