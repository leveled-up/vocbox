# Cloud Functions Code for VocBox 2
# (c) 2017 RunStorage Technologies
# ----------------------------------------

# Import Requirements
functions = require 'firebase-functions'
express = require 'express'
url_utility = require 'url'
filesystem = require 'fs'

# Useful Functions
# Read File to String
file_get_contents = (file_path) ->
  filesystem.readFileSync file_path, "utf8"

# Make Page from Template
tpl2html = (template_file, values) ->
  # Load Template File
  tpl = file_get_contents "./" + template_file + ".tpl"
  # Render it
  values.forEach (item, index) ->
    tpl_index = index+1
    tpl = tpl.replace "$" + tpl_index, item
  # Return
  return tpl

# Send Error 404
error_404 = () ->
  file_get_contents "./404.html"

# Set Possible Requests
actions = {
  index: (req, res) -> index_handler(req, res),
  p404: (req, res) -> p404_handler(req, res)
}

# Initialize Express
app = express()

# Create Express App
app.get "/*", (request, response) ->

  # Get & Process Request URL
  request_url = url_utility.parse request.url
  request_pathname = request_url.pathname.substr 1
  # ^^ explode use [0] and rest add to array to pass to function e.g; index
  if request_pathname == ""
    request_pathname = "index"

  # Start Function
  if actions[request_pathname]?
      actions[request_pathname] request, response
  else
      request_pathname = "p404"
      actions[request_pathname] request, response

  # Log Request
  console.log "Requested " + request.url + "; Responded with " + request_pathname + "()"

# Export Express App as Cloud Function
exports.app = functions.https.onRequest app

# ---------------------------------------------------------
# Page Handlers
# ---------------------------------------------------------

# Home Page
index_handler = (req, res) ->
  values = [
    "Home",
    "<section class=\"page-header\">
      <h1 class=\"project-name\">Test</h1>
      <h2 class=\"project-tagline\">Hello world!</h2>
    </section>",
    "/main.js"
  ]
  res.send tpl2html "index", values

# 404 Error Page
p404_handler = (req, res) ->
  res.status 404
  res.send error_404()
