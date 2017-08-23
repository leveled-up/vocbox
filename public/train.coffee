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
  "train_type_question",
  "train_type_word_m",
  "train_type_form",
  "train_type_form_word_f",
  "train_type_form_btn",
  "train_type_result",
  "train_type_result_alert",
  "train_type_result_correct",
  "train_type_result_word_f",
  "train_type_result_word_m",
  "train_type_result_confirm",
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
get_next_word = (callback) ->

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
      callback false
      return

    # Log & Return
    console.log "Success. returning {result.word}"
    callback word

  # Init Done.
  true

# **** #DB: register results ****
register_results = (word_id, correct, callback) ->

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
      callback false
      return false
    else
      console.log "Success."
      callback true
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
  train_type_new_word()

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


# **** #Method!Type ****
# New Word Function
train_type_new_word = () ->

  # Log Event
  console.log "train_type_new_word()"

  # Get New Word
  get_next_word (word) ->

    # Log Event
    console.log "Loaded Word: " + JSON.stringify word

    # Continue
    window.train_type_word = word
    show_object train_type_question
    hide_object train_type_result
    train_type_word_m.innerHTML = word.word_m

    # Focus Input
    train_type_form.reset()
    train_type_form_word_f.focus()

  # Init Done
  true

# Question, On Answer Submit
train_type_answer_submit = () ->

  # Log Event
  console.log "train_type_answer_submit()"

  # Validate Correctness of Input
  train_type_form_btn_original_text = train_type_form_btn.innerHTML
  train_type_form_btn.innerHTML = "Submitting..."
  word_f = train_type_form_word_f.value.toLowerCase()
  console.log "input.word_f: " + word_f

  if train_type_word.word_f.toLowerCase() == word_f
    # Log Event & Set Info for DB
    console.log "Word answered correctly."
    correct = true

    # Set Result GUI
    train_type_result_alert.className = "alert alert-success"
    train_type_result_correct.innerHTML = "Exactly"

  else
    # Log Event & Set Info for DB
    console.warn "Word answered incorrectly."
    correct = false

  # Set Result GUI
  train_type_result_alert.className = "alert alert-danger"
  train_type_result_correct.innerHTML = "Nope"

  # Set Result GUI words
  train_type_result_word_f.innerHTML = train_type_word.word_f
  train_type_result_word_m.innerHTML = train_type_word.word_m

  # Send Results to DB
  register_results train_type_word.id, correct, (success) ->

    if not success
      console.warn "register_results() failed."
      alert "Error 500: Sending data to Server failed."
      return false
    else
      console.log "Success."
      train_type_form_btn.innerHTML = train_type_form_btn_original_text
      hide_object train_type_question
      show_object train_type_result
      return true

  # Init Done
  true

# Form Event Listener to Call Answer Submit
train_type_form.addEventListener "submit", (evt) ->

  # Prevent action=X
  evt.preventDefault()

  # Call answer submit function
  train_type_answer_submit()

# Form Btn Event Listener to Submit Form
train_type_form_btn.addEventListener "click", () ->

  # Call answer submit function
  train_type_answer_submit()


# Confirm Btn to Activate new Session
train_type_result_confirm.addEventListener "click", () ->

  # Call Init function
  train_type_new_word()
