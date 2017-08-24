# Train.js (Client Script for /train.php)
# (c) RunStorage Technologies
console.log "Init train.js"
console.warn "This script may not be compatible entirely with all browsers."

# Get objects from DOM
dom_objects = [
  # Objects for Method!Chooser
  "train_method_chooser",
  "train_method_type",
  "train_method_speak",
  "train_method_libs",
  "train_method_image",
  # Objects for Method!Type
  "train_type",
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
  "train_speak",
  "train_speak_status",
  "train_speak_question",
  "train_speak_word_m",
  "train_speak_form",
  "train_speak_form_word_f",
  "train_speak_form_btn",
  "train_speak_result",
  "train_speak_result_alert",
  "train_speak_result_correct",
  "train_speak_result_word_f",
  "train_speak_result_word_m",
  "train_speak_result_confirm",
  # Objects for Method!Libs
  "train_libs",
  "train_libs_input",
  "train_libs_question",
  "train_libs_form",
  "train_libs_form_input",
  "train_libs_form_btn",
  "train_libs_result",
  "train_libs_result_alert",
  "train_libs_result_correct",
  "train_libs_result_alert_text",
  "train_libs_result_story",
  "train_libs_result_btn",
  # Objects for Method!Image
  "train_image"
]
get_objects dom_objects

# **** #DB ****
# Variables
console.log "Init Train.js/DB"
db_baseurl = "/train/" + library_id + "?"
db_actions = {
  get_next_word: "action:get_next_word=",
  register: "action:results=",
  wikipedia: "action:wikipedia_proxy="
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
    callback result.word

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
  console.log train_type_new_word()

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
  train_speak_status.innerHTML = "Loading..."

  # Show Method!Type
  show_object train_speak

  # Load new word + start speech
  console.log train_speak_new_word()

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
# Variables
train_type_form_btn_original_text = train_type_form_btn.innerHTML

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

    hide_object train_type_question
    console.log train_type_form_btn_original_text
    train_type_form_btn.innerHTML = train_type_form_btn_original_text
    show_object train_type_result

    if not success
      console.warn "register_results() failed."
      alert "Error 500: Sending data to Server failed."
      return false
    else
      console.log "Success."
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

# **** #Method!Speak ****
# Variables
train_speak_form_btn_original_text = train_speak_form_btn.innerHTML

# New Word Function
train_speak_new_word = () ->

  # Log Event
  console.log "train_speak_new_word()"
  train_speak_status.innerHTML = "Loading..."

  # Get New Word
  get_next_word (word) ->

    # Log Event
    console.log "Loaded Word: " + JSON.stringify word

    # Continue
    window.train_speak_word = word
    show_object train_speak_question
    hide_object train_speak_result
    train_speak_word_m.innerHTML = word.word_m

    # Focus Input
    # NOTE: no focus (prevent mobile keyboard)
    train_speak_form_word_f.blur()
    train_speak_form.reset()

    # Speech Synthesis & Recognition Langs
    speech_synthesis_lang = mother_lang[1]
    speech_recognition_lang = forein_lang[1]

    # Speech Synthesis
    console.log "Init Speech Synthesis."
    train_speak_status.innerHTML = "Talking."
    # speech_synthesis = (text, language, callback)
    speech_synthesis word.word_m, speech_synthesis_lang, (e) ->

      # Log Event
      console.log "Synthesis done."

      # Speech Recognition
      console.log "Init Speech Recognition."
      train_speak_status.innerHTML = "Enable microphone access and start talking."
      # speech_recognition = (language, callback)
      speech_recognition speech_recognition_lang, (status, transcript) ->

        # Log Event
        console.log "Speech Recognition State Change: " + status
        console.log "transcript: " + transcript

        # Process Results
        switch status
          # Init Complete
          when 0
            train_speak_status.innerHTML = "Please allow microphone access and start speaking."
          # New Transcript, not Final
          when 1
            train_speak_status.innerHTML = transcript
          # Nothing Recognized
          when 3
            train_speak_status.innerHTML = "Nothing Recognized."
          # Error
          when 4
            train_speak_status.innerHTML = "Nothing Recognized."
          # New Transcript, isFinal
          when 2
            # Insert into Form
            console.log "Final transcript: " + transcript
            train_speak_status.innerHTML = "Is <i>" + transcript + "</i> correct?"
            train_speak_form_word_f.value = transcript

  # Init Done
  true

# Question, On Answer Submit
train_speak_answer_submit = () ->

  # Log Event
  console.log "train_speak_answer_submit()"

  # Validate Correctness of Input
  train_speak_form_btn.innerHTML = "Submitting..."
  word_f = train_speak_form_word_f.value.toLowerCase()
  console.log "input.word_f: " + word_f

  if train_speak_word.word_f.toLowerCase() == word_f
    # Log Event & Set Info for DB
    console.log "Word answered correctly."
    correct = true

    # Set Result GUI
    train_speak_result_alert.className = "alert alert-success"
    train_speak_result_correct.innerHTML = "Exactly"

  else
    # Log Event & Set Info for DB
    console.warn "Word answered incorrectly."
    correct = false

    # Set Result GUI
    train_speak_result_alert.className = "alert alert-danger"
    train_speak_result_correct.innerHTML = "Nope"

  # Set Result GUI words
  train_speak_result_word_f.innerHTML = train_speak_word.word_f
  train_speak_result_word_m.innerHTML = train_speak_word.word_m

  # Send Results to DB
  register_results train_speak_word.id, correct, (success) ->

    hide_object train_speak_question
    console.log train_speak_form_btn_original_text
    train_speak_form_btn.innerHTML = train_speak_form_btn_original_text
    show_object train_speak_result

    if not success
      console.warn "register_results() failed."
      alert "Error 500: Sending data to Server failed."
      return false
    else
      console.log "Success."
      return true

  # Init Done
  true

# Form Event Listener to Call Answer Submit
train_speak_form.addEventListener "submit", (evt) ->

  # Prevent action=X
  evt.preventDefault()

  # Call answer submit function
  train_speak_answer_submit()

# Form Btn Event Listener to Submit Form
train_speak_form_btn.addEventListener "click", () ->

  # Call answer submit function
  train_speak_answer_submit()


# Confirm Btn to Activate new Session
train_speak_result_confirm.addEventListener "click", () ->

  # Call Init function
  train_speak_new_word()

# **** #Method!Libs ****
# Generate next question
train_libs_new_question = () ->

  # Log Event
  console.log "Requested train_libs_new_question()"

  # Prepare Inputs
  train_libs_question.innerHTML = "Loading..."
  train_libs_form.reset()
  train_libs_input.focus()

  # Get Random Text from Wikipedia
  wikipedia_client = new HttpClient()
  wikipedia_baseurl = db_baseurl + db_actions.wikipedia
  console.log "Wikipedia Proxy URL: " + wikipedia_baseurl
  wikipedia_params = {
    random_article: "action=query&generator=random&grnnamespace=0&format=json",
    summary_oa: "format=json&action=query&prop=extracts&exintro=&explaintext=&titles="
  }

  # Get Random Article
  random_article_url = wikipedia_baseurl + urlencode wikipedia_params.random_article
  console.log "Wikipedia Rand Article. Requesting: " + random_article_url
  wikipedia_client.get random_article_url, (result_ra) ->

    # Log Event
    console.log "Request Result: " + result_ra

    # Decode Result
    result = JSON.parse result_ra
    if not result.query.pages[0].title?
      console.warn "Error in JSON result."
    else
      console.log "Success: Page is " + result.query.pages[0].title


"train_libs_input",
"train_libs_question",
"train_libs_form",
"train_libs_form_input",
"train_libs_form_btn",
"train_libs_result",
"train_libs_result_alert",
"train_libs_result_correct",
"train_libs_result_alert_text",
"train_libs_result_story",
"train_libs_result_btn",
