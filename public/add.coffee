# Add.js (Client Script for /add.php)
# (c) RunStorage Technologies
console.log "Init add.js"
console.warn "This script may not be compatible entirely with all browsers."

# Get objects from DOM
dom_objects = [
  # Objects for Method!Chooser
  "add_method_chooser",
  "add_method_type",
  "add_method_speak",
  "add_method_scan",
  # Objects for Method!Type
  "add_type",
  "add_type_back",
  "add_type_form",
  "add_type_form_btn",
  "add_type_word_m",
  "add_type_word_f",
  "add_type_show_comment",
  "add_type_comment_btn",
  "add_type_comment",
  # Objects for Method!Speak
  "add_speak",
  "add_speak_status",
  "add_speak_form",
  "add_speak_form_btn",
  "add_speak_word_m",
  "add_speak_word_f",
  "add_speak_show_comment",
  "add_speak_comment_btn",
  "add_speak_comment",
  # Objects for Method!Scan
  "add_scan"
]
get_objects dom_objects

# **** #Method!Chooser ****
# Add EventListeners for Method!Chooser

# Method:Type
add_method_type.addEventListener "click", () ->

  # Log to Console
  console.log "User selected Method:Type"

  # Hide Method!Chooser
  hide_object add_method_chooser

  # Init Type
  console.log "Init Method!Type"

  # Show Method!Type
  show_object add_type

  # Return false to prevent a.href
  false

# Method:Speak
add_method_speak.addEventListener "click", () ->

  # Log to Console
  console.log "User selected Method:Speak"

  # Hide Method!Chooser
  hide_object add_method_chooser

  # Init Speak
  console.log "Init Method!Speak"

  # Show Method!Speak
  show_object add_speak

  # Speech Recognition
  speech_recognition_add()

  # Return false to prevent a.href
  false


# Method:Scan
add_method_scan.addEventListener "click", () ->

  # Log to Console

  console.log "User selected Method:Scan"

  # Hide Method!Chooser
  hide_object add_method_chooser

  # Init Scan
  console.log "Init Method!Scan"

  # Show Method!Type
  show_object add_scan

  # Return false to prevent a.href
  false

# **** #Method!Type ****
# Type Form Submit EventListener
add_type_form.addEventListener "submit", (evt) ->

  # Prevent Form Submit
  evt.preventDefault()

  # Log Event
  console.log "Submit add_type_form()."

  # Show Working State
  add_type_form_btn_original_text = add_type_form_btn.innerHTML
  add_type_form_btn.innerHTML = "Saving..."

  # Send to DB
  # send_word_to_db = (word_m, word_f, comment, callback) ->
  word_m = add_type_word_m.value
  word_f = add_type_word_f.value
  comment = add_type_comment.value

  send_word_to_db word_m, word_f, comment, (success) ->

    # Log Event
    console.log "send_word_to_db() callback fired."

    # process Result
    if success
      console.log "Success"
      add_type_form.reset()
    else
      console.warn "Failed"
      alert "Error 500: We weren't able to save your input"

    # Remove "Saving..."
    add_type_form_btn.innerHTML = add_type_form_btn_original_text

# Show Comment Input Box
add_type_comment_btn.addEventListener "click", () ->

  # Log Event
  console.log "Requested Comment Input"

  # Show Element
  hide_object add_type_show_comment
  show_object add_type_comment

# Return To Method Selection Button
add_type_back.addEventListener "click", () ->

  # Log Event
  console.log "Requested add_type_back()."

  # Reload Page
  window.location.reload()

# **** #Method!Speak ****
# Speech Recognition Handler Function
speech_recognition_add = () ->

  # Log Event
  console.log "speech_recognition_add() requested."

  # Prepare
  speech_synthesis_lang = "en"
  speech_recognition_lang = forein_lang[1]
  translation_trg_lang = mother_lang[1]

  # Synthesis Question N° 1
  synthesis_questions_1 = [
    "What's the " + forein_lang[0] + " word?",
  #  "Say the " + forein_lang[0] + " word, please?",
    "The " + forein_lang[0] + " word, please?",
  #  "Can you please say the " + forein_lang[0] + " word now?"
  ]
  synthesis_questions_1_count = synthesis_questions_1.length-1
  synthesis_question_1_id = Math.floor Math.random() * synthesis_questions_1_count
  synthesis_question_1 = synthesis_questions_1[synthesis_question_1_id]
  console.log "Synthesis Question 1: " + synthesis_question_1

  # Synthesis Question N° 2
  synthesis_questions_2 = [
    "ok?",
  #  "Is this right?",
    "Correct?"
  ]
  synthesis_questions_2_count = synthesis_questions_2.length-1
  synthesis_question_2_id = Math.floor Math.random() * synthesis_questions_2_count
  synthesis_question_2 = synthesis_questions_2[synthesis_question_2_id]
  console.log "Synthesis Question 2: " + synthesis_question_2

  # Synthesis N°1
  add_speak_status.innerHTML = synthesis_question_1
  console.log "Starting Speech Synthesis."

  # Start Speech Synthesis N°1
  speech_synthesis synthesis_question_1, speech_synthesis_lang, (e) ->

    # Log Event
    console.log "Synthesis Done. Start Speech Recognition."
    add_speak_status.innerHTML = "Preparing Speech Recognition..."

    # Start Speech Recognition N°1
    speech_recognition speech_synthesis_lang, (status, transcript) ->

      # Log Event
      console.log "Speech Recognition State Changed: " + status
      console.log "transcript: " + transcript

      # Process Results
      switch status
        # Init Complete
        when 0
          add_speak_status.innerHTML = "Please allow microphone access and start speaking."
        # New Transcript, not Final
        when 1
          add_speak_status.innerHTML = transcript
        # Nothing Recognized
        when 3
          add_speak_status.innerHTML = "Nothing Recognized."
        # Error
        when 4
          add_speak_status.innerHTML = "An error occurred. Please check your browser (Chrome Required) and/or contact us."
        # New Transcript, isFinal
        when 2
          # Insert into Form
          add_speak_word_f.value = transcript

          # Translation
          add_speak_status.innerHTML = "Translating \"" + transcript + "\""
          console.log "Translation started."

          translate transcript, speech_recognition_lang, translation_trg_lang, (response) ->

            # Translation Complete
            if response == false
              # Log Error
              console.warn "Error Translating"
              add_speak_status.innerHTML = "Translation Error"

            else
              # Success
              console.log "Translation Success: " + response
              add_speak_word_m.value = response
              add_speak_status.innerHTML = "Translation: " + response

              # Speech Synthesis N° 2
              add_speak_status.innerHTML = synthesis_question_2
              console.log "Starting Speech Synthesis (2)."

              # Start Speech Synthesis N°2
              speech_synthesis synthesis_question_2, speech_synthesis_lang, (e_) ->

                # Log Event
                console.log "Synthesis Done. Start Speech Recognition."

                # Start Speech Recognition N°2
                speech_recognition speech_synthesis_lang, (status, transcript) ->

                  # Log Event
                  console.log "Speech Recognition State Changed: " + status
                  console.log "transcript: " + transcript

                  # Check if Result is Yes, Then Submit Form
                  positive_replies = [
                    "yes", "yep", "ok", "yeah", "true", "definitely"
                  ]

                  transcript_ = transcript.replace(/\W/g, '').toLowerCase()
                  transcript_ispositive = positive_replies.indexOf transcript_

                  if transcript_ispositive >= 0
                    # Auto Submit
                    console.log "Auto Submit."
                    add_speak_form_submit_event()

                  else
                    # No Submit
                    console.log "No Submit."


# Speak Form Submit EventListener
add_speak_form.addEventListener "submit", (evt) ->

  # Prevent Form Submit
  evt.preventDefault()

  add_speak_form_submit_event()

# Submit Function
add_speak_form_submit_event = () ->

  # Log Event
  console.log "Form Submit"

  # Show Working State
  add_speak_form_btn_original_text = add_speak_form_btn.innerHTML
  add_speak_form_btn.innerHTML = "Saving..."

  # Send to DB
  # send_word_to_db = (word_m, word_f, comment, callback) ->
  word_m = add_speak_word_m.value
  word_f = add_speak_word_f.value
  comment = add_speak_comment.value

  send_word_to_db word_m, word_f, comment, (success) ->

    # Log Event
    console.log "send_word_to_db() callback fired."

    # process Result
    if success
      console.log "Success"
      add_speak_form.reset()
    else
      console.warn "Failed"
      alert "Error 500: We weren't able to save your input"

    # Remove "Saving..."
    add_speak_form_btn.innerHTML = add_speak_form_btn_original_text

    # Start Next Speech Recognition
    if success
      speech_recognition_add()

# Show Comment Input Box
add_speak_comment_btn.addEventListener "click", () ->

  # Log Event
  console.log "Requested Comment Input"

  # Show Element
  hide_object add_speak_show_comment
  show_object add_speak_comment

# **** #Method!Scan ****

# **** Save Word ****
send_word_to_db = (word_m, word_f, comment, callback) ->

  # Log Event
  console.log "Requested Saving Word to DB."

  # process Input
  parameters = [
    word_m,
    word_f
  ]
  if comment != "" and comment?
    parameters.push comment

  # Format Request
  console.log "Preparing Request."
  db_save_baseurl = "/add/" + library_id + "?action:insert="
  db_save_params = urlencode JSON.stringify parameters
  request_url = db_save_baseurl + db_save_params
  console.log "Request URL: " + request_url

  # Send Request
  console.log "Init HttpClient()."
  client = new HttpClient()
  console.log "Creating Request."
  client.get request_url, (response) ->

    # Log Event
    console.log "Request Done. Response: " + response

    # Check if Successful
    if response == "0"
      # Success
      console.log "Success DB Insert"
      callback true
    else
      # Failed
      console.warn "DB Insert Failed"
      callback false
