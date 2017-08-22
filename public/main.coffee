# Main.js Client Script
console.log "Init main.js"
console.warn "For VocBox to work Properly, Further Includes are Required."
console.warn "Some features require a WebKit browser."

# Cloud Functions Client Functions
console.log "Init Cloud Functions Client"
# Variables
cf_baseurl = "https://us-central1-vocbox-test.cloudfunctions.net/"

# Uniform Cloud Functions Client
call_cf = (function_name, parameters, callback) ->

  # Log Request
  console.log "Requesting Cloud Function " + function_name + "()."
  console.log "BaseURL: " + cf_baseurl
  console.log "Parameters: " + JSON.stringify parameters

  # Construct request_url
  console.log "Constructing Request URL."
  request_url = "?"
  parameters.forEach (value) ->
    request_url += value[0] + "=" + urlencode(value[1]) + "&"
  request_url = cf_baseurl + function_name + request_url
  console.log "Request URL: " + request_url


  # Init HttpClient
  console.log "Init HttpClient()."
  client = new HttpClient()
  console.log "Creating Request."
  client.get request_url, (response) ->

    # Log Response
    console.log "Response: " + response
    console.log "Callback()"

    # Fire Callback
    callback response

# Translate Client
translate = (text, source_lang, target_lang, callback) ->

  # Log Event
  console.log "Requested Translation of " + text

  # Create Parameter Object
  console.log "Constructing Parameters"
  parameters = [
    ["q", text],
    ["src", source_lang],
    ["trg", target_lang]
  ]
  console.log "Parameters: " + JSON.stringify parameters

  # Call Cloud Function
  console.log "Calling Cloud Function"
  call_cf "translate", parameters, (response) ->

    # Proccess Result
    result = JSON.parse response
    if result.translatedText?
      # Success
      console.log "Translation: " + response
      console.log "Callback()"

      callback response
    else
      # Failed
      console.warn "Failed. Callback(false)"
      callback false

annotateImage = (fileName, callback) ->


analyzeTextSyntax = () ->
  # Object.keys(obj).forEach(function(key) {
  #        console.log(key);
  #    });
