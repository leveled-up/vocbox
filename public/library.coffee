# Library.js (Client Script for /library.php)
console.log "Init library.js"

# Get DOM objects using util.js
dom_objects = [
  "library_listwords",
  "library_listwords_btn_span",
  "library_listwords_btn",
  "library_listwords_spinner",
  "library_listwords_table_span",
  "library_listwords_table",
  "library_listwords_table_tbody",
  "library_listwords_table_error"
]
get_objects dom_objects

# Create EventListener
library_listwords_btn.addEventListener "click", () ->
  # Log Event
  console.log "User clicked library_listwords_btn()."

  # Hide/Show DOM object
  console.log "Hiding / Showing <span> objects."
  hide_object library_listwords_btn_span
  show_object library_listwords_spinner

  # Prepare Request for Words List
  console.log "Init HttpClient()."
  request_url = "/list?library=" + library_id
  client = new HttpClient()

  # Request List
  console.log "Sending Request."
  client.get request_url, (response) ->
    # Fill Table with Response
    console.log "Received Response: " + response
    if response != ""
      library_listwords_table_tbody.innerHTML = response
    else
      console.warn "Response is empty. Showing Error to User."
      library_listwords_table_error.innerHTML = "Error 500: Loading words failed."

    # Show Table
    console.log "Hiding / Showing <span> objects."
    hide_object library_listwords_spinner
    show_object library_listwords_table_span

    # Done.
    console.log "Done showing List of Words."

# Functions for List Words
get_info_data_from_word_id = (word_id) ->

  # Read Info Data From <span>
  info_data_object_id = "info_" + word_id
  get_objects [ info_data_object_id ]
  info_data = window[info_data_object_id].innerHTML

  # Return Info Data as object
  JSON.parse info_data

btn_info_word_click = (word_id) ->

  # Create Info Alert Text
  info = get_info_data_from_word_id word_id
  alert_text = "The word selected is in category " + info.category + "."
  if info.info.comment?
    alert_text += " Comment: " + info.info.comment

  # Spawn Alert
  alert alert_text

btn_delete_word_click = (word_id) ->

  # Create Confirm Text
  confirm_text = "You are about to permanently delete this word. It can't be restored."

  # Spawn Confirm
  return confirm confirm_text
  
