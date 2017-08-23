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
  "add_type_comment_span",
  # Objects for Method!Speak
  "add_speak",
  "add_speak_back",
  "add_speak_status",
  "add_speak_form",
  "add_speak_form_btn",
  "add_speak_word_m",
  "add_speak_word_f",
  "add_speak_show_comment",
  "add_speak_comment_btn",
  "add_speak_comment",
  "add_speak_comment_span"
  # Objects for Method!Scan
  "add_scan",
  "add_scan_back",
  "add_scan_status",
  "add_scan_upload_select_span",
  "add_scan_upload_div",
  "add_scan_file_button",
  "add_scan_confirm_span",
  "add_scan_confirm_btn",
  "add_scan_confirm_pre",
  "add_scan_done",
  "add_scan_done_back"
]
get_objects dom_objects

# Variables
throbber_small = "<img src=\"https://www.runstorageapis.com/img/throbber_small.svg\" alt=\"\" /> "

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

  # Focus Field
  add_type_word_f.focus()

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

  # Check for Empty Values
  if word_m == "" or word_f == ""
    console.log "Empty value detected."
    alert "You must fill both fields in typing mode."
    return

  send_word_to_db word_m, word_f, comment, (success) ->

    # Log Event
    console.log "send_word_to_db() callback fired."

    # process Result
    if success
      console.log "Success"

      # Reset Form
      add_type_form.reset()
      show_object add_type_show_comment
      hide_object add_type_comment_span
      add_type_word_f.focus()
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
  show_object add_type_comment_span

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
  speech_recognition_lang = forein_lang[1]
  translation_trg_lang = mother_lang[1]

  add_speak_status.innerHTML = "Preparing Speech Recognition..."

  # Start Speech Recognition
  speech_recognition speech_recognition_lang, (status, transcript) ->

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
        add_speak_status.innerHTML = "Nothing Recognized."
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
            add_speak_status.innerHTML = "Translation Error. Please contact us."

          else
            # Success
            console.log "Translation Success: " + response
            add_speak_word_m.value = response
            add_speak_status.innerHTML = "Translation: " + response
            add_speak_status.innerHTML = "Correct?"

# Speak Form Submit EventListener
add_speak_form.addEventListener "submit", (evt) ->

  # Prevent Form Submit
  evt.preventDefault()

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

# up.. in function if empty transcript return
  if word_m == "" or word_f == ""
    console.warn "Empty value."
    add_speak_form_btn.innerHTML = add_speak_form_btn_original_text
    return

  send_word_to_db word_m, word_f, comment, (success) ->

    # Log Event
    console.log "send_word_to_db() callback fired."

    # process Result
    if success
      console.log "Success"

      # Reset Form
      add_speak_form.reset()
      show_object add_speak_show_comment
      hide_object add_speak_comment_span
    else
      console.warn "Failed"
      alert "Error 500: We weren't able to save your input"

    # Remove "Saving..."
    add_speak_form_btn.innerHTML = add_speak_form_btn_original_text

    # Start Next Speech Recognition
    if success
      speech_recognition_add()

  # Init Done
  true

# Show Comment Input Box
add_speak_comment_btn.addEventListener "click", () ->

  # Log Event
  console.log "Requested Comment Input"

  # Show Element
  hide_object add_speak_show_comment
  show_object add_speak_comment_span

# Return To Method Selection Button
add_speak_back.addEventListener "click", () ->

  # Log Event
  console.log "Requested add_speak_back()."

  # Reload Page
  window.location.reload()

# **** #Method!Scan ****
# File Upload: Listen for file selection
add_scan_file_button.addEventListener "change", (e) ->

    # Get File
    add_scan_file = e.target.files[0]
    window.add_scan_upload_filename = add_scan_file.name
    window.add_scan_upload_size = add_scan_file.size

    if window.add_scan_upload_size > 15 * 1024 * 1024
      alert "The maximal file size for image scanning is 5 MiB"
      return false

    # Show Progress Div
    add_scan_status.innerHTML = throbber_small + "Preparing upload of " + add_scan_upload_filename + "..."

    # Create a storage ref
    storageFilename = getStorageFilename add_scan_file.name, "vision_images"
    storageRef = firebase.storage().ref storageFilename

    # Upload file
    add_scan_update_progress 0
    hide_object add_scan_upload_select_span
    window.add_scan_upload_start_time = Date.now() / 1000
    task = storageRef.put add_scan_file

    # Update progress bar
    task.on "state_changed", (snapshot) =>
        add_scan_update_progress ( snapshot.bytesTransferred / snapshot.totalBytes ) * 100, snapshot.bytesTransferred, snapshot.totalBytes, window.add_scan_upload_start_time
    , (err) =>
        add_scan_upload_error err
    , () =>
        add_scan_upload_success storageFilename, window.add_scan_upload_filename, window.add_scan_upload_size

# Update Upload Progress
add_scan_update_progress = (percent, bytesTransferred, totalBytes, upload_start_time) ->
   # Calculate Upload Speed
   time_now = Date.now() / 1000
   upload_speed_ = bytesTransferred / ( time_now - upload_start_time )
   upload_speed = formatFilesize upload_speed_

   # Calculate ETA
   bytesRemaining = totalBytes - bytesTransferred
   secondsRemaining_ = bytesRemaining / upload_speed_
   secondsRemaining = Math.round secondsRemaining_
   uploadETA = formatSeconds secondsRemaining

   # Get Basic Upload Info
   size_data_done = formatFilesize bytesTransferred
   size_data_complete = formatFilesize totalBytes

   # Update Details
   if bytesTransferred > 10
     add_scan_status.innerHTML = throbber_small + size_data_done + " (" + Math.round(percent) + "%) of " + size_data_complete + " uploaded with " + upload_speed + "/s (" + uploadETA + " remaining)"

   console.log "Update Upload Progess => " + percent + " done, " + upload_speed + "ps, ETA: " + secondsRemaining + "s"

# Upload Error
add_scan_upload_error = (err) ->

  # Log Error
  console.warn "Upload Error"

  # Log to User
  add_scan_status.innerHTML = "The upload failed. Please contact us."

# When Upload Succeeds
add_scan_upload_success = (storageFilename, upload_filename, upload_size) ->

  # Log Event
  console.log "Upload Succeeded"
  console.log upload_filename + " (" + upload_size + "B) uploaded as " + storageFilename

  # Continue Processing
  add_scan_status.innerHTML = throbber_small + "Upload successfully completed."
  add_scan_status.innerHTML = throbber_small + "Processing image with OCR..."

  # Prepare storageFilename
  console.log "Preparing Storage Filename... Old: " + storageFilename
  storageFilename_ = storageFilename.replace "vision_images/", ""
  console.log "New: " + storageFilename_

  # Scan Image
  annotateImage storageFilename_, "textDetection", (response) ->

    if response == false
      # Failed
      console.warn "Error Processing Image"
      add_scan_status.innerHTML = "There was an error processing your image. Please contact us."
    else
      # Success
      console.log "Scanning Succeeded."
      add_scan_status.innerHTML = throbber_small + "The image was analyzed successfully."

      # Take a look at result.
      text = response[0]
      console.log "Text detected: " + text
      lines_array = text.split "\n"

      lines_array_ = []
      lines_array.forEach (item) ->
        if item != ""
          lines_array_.push item

      if lines_array_.length < 1
        console.warn "Nothing detected."
        add_scan_status.innerHTML = "We couldn't detect any text in the image."
        return

      # Go on with lines_array
      result_ = []
      lines_array_.forEach (item) ->

        # Prepare translation
        text_ = item
        recognition_lang = forein_lang[1]
        translation_trg_lang = mother_lang[1]
        result_pre = ""

        translate text_, recognition_lang, translation_trg_lang, (response_) ->

          # Translation Complete
          if response_ == false
            # Log Error
            console.warn "Error Translating"
            add_scan_status.innerHTML = "Translation Error. Please contact us."
            return

          else
            # Success
            console.log "Translation Success: " + response_
            translation_result = {
              word_m: response_,
              word_f: text_
            }
            result_.push translation_result

            # if result_.length == lines_array_.length
            result_pre = ""
            result_.forEach (item_) ->
              result_pre += item_.word_f + " - " + item_.word_m + "\n"

            # Show objects
            if result_.length == lines_array_.length
              add_scan_status.innerHTML = "Please confirm the scan by clicking below."
              add_scan_confirm_pre.innerHTML = result_pre
              show_object add_scan_confirm_span
            else
              add_scan_status.innerHTML = throbber_small + "Translation in progress..."

            # Make result_ public
            window.add_span_result_ = result_

        # Translation Done
      # forEach Done

# Scan Confirm Button
add_scan_confirm_btn.addEventListener "click", () ->

  # Log Event
  console.log "User confirmed. Inserting Values"

  # Insert Values
  add_span_result_.forEach (item) ->
    send_word_to_db item.word_m, item.word_f, "", (success) ->
      if success
        console.log item.word_f + " successfully inserted."
      else
        console.warn "Error saving word " + item.word_f
        add_scan_status.innerHTML = "The word " + item.word_f + "could not be saved."

  # Done, Clear Fields
  hide_object add_scan_confirm_span
  show_object add_scan_done

# Return To Method Selection Button (Scan Done)
add_scan_done_back.addEventListener "click", () ->

  add_scan_back_()

# Return To Method Selection Button
add_scan_back.addEventListener "click", () ->

  add_scan_back_()

# Return to Method Selection
add_scan_back_ = () ->
  # Log Event
  console.log "Requested add_scan_back()."

  # Reload Page
  window.location.reload()
