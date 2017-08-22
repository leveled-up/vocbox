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

    # Proccess Result
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


# **** #Method!Speak ****

# **** #Method!Scan ****

# **** Save Word ****
send_word_to_db = (word_m, word_f, comment, callback) ->

  # Log Event
  console.log "Requested Saving Word to DB."

  # Proccess Input
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
