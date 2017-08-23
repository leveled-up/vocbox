# Train.js (Client Script for /train.php)
# (c) RunStorage Technologies
console.log "Init train.js"
console.warn "This script may not be compatible entirely with all browsers."

# Get objects from DOM
dom_objects = [
  # Objects for Method!Chooser
  "add_method_chooser",
  "add_method_type",
  "add_method_speak",
  "add_method_libs",
  "add_method_image",
  # Objects for Method!Type
  "add_type",
  # Objects for Method!Speak
  "add_speak",
  # Objects for Method!Libs
  "add_libs",
  # Objects for Method!Image
  "add_image"
]
get_objects dom_objects

# **** #DB ****
# Variables
console.log "Init Train.js/DB"
db_baseurl = "/train/" + library_id + "?"
db_actions = {
  get_next_word: "action:get_next_word=",
  register: "action:results="
}
db_client = new HttpClient()

# **** #DB: get next word ****
get_next_word = () ->

  # Log Event
  console.log "get_next_word(). Prepraring request to ?actions:get_next_word"

  # Create Request URL
  request_action = db_actions.get_next_word + "1"
  request_url = db_baseurl + request_action
  console.log "Request URL: " + request_url

  # Prepare HttpClient
  console.log "Requesting DB."
  db_client.get request_url, (response) ->

    # Log Event
    console.log "Request Response: " + response

    # Process Results
    result = JSON.parse response
    if not result.success
      console.warn "Failed."
      return false

    # Log & Return
    console.log "Success. returning {result.word}"
    return word

# **** #DB: register results ****
register_results = (word_id, correct) ->

  # Log Event
  console.log "register_results() for " + word_id + " as correct=" + correct

  # Create Response
  
