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
      alert "Error 500: Loading word failed."
      return false

    # Log & Return
    console.log "Success. returning {result.word}"
    return word

  # Init Done.
  true

# **** #DB: register results ****
register_results = (word_id, correct) ->

  # Log Event
  console.log "register_results() for " + word_id + " as correct=" + correct

  # Create Request
  if correct
    correct = "1"
  else
    correct = "0"

  request_params = {
    word_id: word_id,
    correct: correct
  }
  request_action = db_actions.register + urlencode JSON.stringify request_params
  request_url = db_baseurl + request_action
  console.log "Request URL: " + request_url

  # Run Request
  db_client.get request_url, (response) ->

    # Log Event
    console.log "register_results().callback() Result: " + response

    # Process Result
    result = JSON.parse response
    if not result.success
      console.warn "register_results() failed."
      alert "Error 500: Saving information failed."
      return false
    else
      console.log "Success."
      return true

  # Init Done.
  true

# **** #Method!Chooser ****
# Add EventListeners for Method!Chooser

# Method:Type
train_method_type.addEventListener "click", () ->

  # Log to Console
  console.log "User selected Method:Type"

  # Hide Method!Chooser
  hide_object train_method_chooser

  # Init Type
  console.log "Init Method!Type"

  # Show Method!Type
  show_object train_type

  # Return false to prevent a.href
  false

# Method:Speak
train_method_speak.addEventListener "click", () ->

  # Log to Console
  console.log "User selected Method:Speak"

  # Hide Method!Chooser
  hide_object train_method_chooser

  # Init Type
  console.log "Init Method!Speak"

  # Show Method!Type
  show_object train_speak

  # Return false to prevent a.href
  false

# Method:Libs
train_method_libs.addEventListener "click", () ->

  # Log to Console
  console.log "User selected Method:Libs"

  # Hide Method!Chooser
  hide_object train_method_chooser

  # Init Type
  console.log "Init Method!Libs"

  # Show Method!Type
  show_object train_libs

  # Return false to prevent a.href
  false

# Method:Image
train_method_image.addEventListener "click", () ->

  # Log to Console
  console.log "User selected Method:Image"

  # Hide Method!Chooser
  hide_object train_method_chooser

  # Init Type
  console.log "Init Method!Image"

  # Show Method!Type
  show_object train_image

  # Return false to prevent a.href
  false
