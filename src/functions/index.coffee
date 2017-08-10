# Cloud Functions Code for VocBox 2
# (c) 2017 RunStorage Technologies
# ----------------------------------------

# Import Requirements
functions = require 'firebase-functions'
express = require 'express'
url_utility = require 'url'
filesystem = require 'fs'

# Read File to String
file_get_contents = (file_path) ->
  filesystem.readFileSync file_path, "utf8"


exports.test = functions.https.onRequest express().get "/test", (request, response) ->
  # Get & Process Request URL
  request_url = url_utility.parse request.url
  request_pathname = request_url.pathname.substr(1).split("/")[1]
  response.send "<h1>Hello world!</h1>" + request_pathname
