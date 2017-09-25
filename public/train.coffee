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
  "train_speak_result_listen",
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
  "train_image",
  "train_image_input",
  "train_image_img",
  "train_image_form",
  "train_image_form_input",
  "train_image_form_btn",
  "train_image_result",
  "train_image_result_alert",
  "train_image_result_correct",
  "train_image_result_alert_text",
  "train_image_result_btn"
]
get_objects dom_objects

# Variables
throbber_small = "<img src=\"https://www.runstorageapis.com/img/throbber_small.svg\" alt=\"\" />&nbsp; "

# **** #DB ****
# Variables
console.log "Init Train.js/DB"
db_baseurl = "/train/" + library_id + "?"
db_actions = {
  get_next_word: "action:get_next_word=",
  register: "action:results=",
  wikipedia: "action:wikipedia_proxy=",
  imginfo: "action:image_info_proxy="
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
  #train_libs_question.innerHTML = throbber_small + "Loading..."

  # Show Method!Type
  show_object train_libs
  #train_libs_new_question()
  train_libs_form_input.focus()

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
  train_image_new_img()

  # Show Method!Type
  show_object train_image
  train_image_form_input.focus()

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
  word_info = JSON.parse train_type_word.info
  if word_info.comment?
    train_type_result_word_m.innerHTML += " <span style=\"font-weight: normal; font-style: italic;\">(Comment: " +word_info.comment + ")</span>"

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

  word_info = JSON.parse train_speak_word.info
  if word_info.comment?
    train_speak_result_word_m.innerHTML += " <span style=\"font-weight: normal; font-style: italic;\">(Comment: " + word_info.comment + ")</span>"


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

# Listen to Voice Example
train_speak_result_listen.addEventListener "click", () ->

  console.log "Starting Synthesis"
  
  speech_synthesis train_speak_word.word_f, forein_lang[1], () ->
    console.log "Synthesis Done."

# DEPRECATED *** #Method!Libs ***
# Generate next question
train_libs_new_question = () ->

  # Log Event
  console.log "Requested train_libs_new_question()"

  # Prepare Inputs
  train_libs_question.innerHTML = throbber_small + "Loading..."
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
    if not result.query.pages[Object.keys(result.query.pages)[0]].title?
      console.warn "Error in JSON result."
    else
      result_ = result.query.pages[Object.keys(result.query.pages)[0]].title
      console.log "Success: Page is " + result_

      # Get Page Summary
      console.log "Get article description..."
      article_url = wikipedia_baseurl + urlencode(wikipedia_params.summary_oa) + urlencode urlencode result_
      console.log "Wikipedia Article Summary. Requesting: " + article_url
      wikipedia_client.get article_url, (result_soa) ->

        # Log Event
        console.log "Request Result: " + result_soa
        result = JSON.parse result_soa
        if not result.query.pages[Object.keys(result.query.pages)[0]].extract?
          console.warn "Error in JSON result."
          alert "Error 500: Error requesting Wikipedia."
        else
          extract = result.query.pages[Object.keys(result.query.pages)[0]].extract
          window.train_libs_wikipedia_extract = extract
          console.log "Success. Summary: " + extract
          words = extract.split " "

          # Request Natural Language Processing
          console.log "Request analyzeTextSyntax() for " + extract
          analyzeTextSyntax extract, (response_atx) ->

            # Log Event
            console.log "analyzeTextSyntax() Result: " + JSON.stringify response_atx

            # JSON Decode
            result = response_atx
            if result.length < 1
              # Error
              console.warn "Error."
              alert "Error 500: Failed Natural Language Processing."

            else
              # Success
              console.log "Success analyzeTextSyntax()"

              # Create words array
              window.train_libs_words = []
              window.train_libs_words_c = []
              words.forEach (item, index) ->
                console.warn "Debug: " + item + ", " + index
                window.train_libs_words[item] = result[index]
                window.train_libs_words_c.push [item, result[index]]

              console.log "Words: " + JSON.stringify window.train_libs_words

              # Set sentence requirements
              rand = Math.floor Math.random() * 4
              switch rand
                when 0
                  requirements = "one noun, one verb and one adjective"
                  window.train_libs_req = ["NOUN", "VERB", "ADJ"]
                when 1
                  requirements = "one noun and one adjective"
                  window.train_libs_req = ["NOUN", "ADJ"]
                when 2
                  requirements = "one noun and one verb"
                  window.train_libs_req = ["NOUN", "VERB"]
                when 3
                  requirements = "one noun"
                  window.train_libs_req = ["NOUN"]

              # Prepare GUI

              train_libs_question.innerHTML = "Please build a sentence in " + forein_lang[0] + " which contains at least " + requirements + "."

              # get suggestion
              get_next_word (word) ->

                # Log Event
                console.log "Loaded Word: " + JSON.stringify word

                # Continue
                window.train_libs_word = word
                train_libs_question.innerHTML += " You may use something related to <i>" + word.word_m + "</i>."

                # Show GUI
                hide_object train_libs_result
                show_object train_libs_input
                train_libs_form.reset()
                train_libs_form_input.focus()

train_libs_check_result = () ->

  # Log Event
  console.log "Requested train_libs_check_result()"

  # Process Response
  train_libs_form_btn_original_text = train_libs_form_btn.innerHTML
  train_libs_form_btn.innerHTML = "Submitting..."
  input = train_libs_form_input.value.split " "

  analyzeTextSyntax input, (result) ->

    # Log Event
    console.log "Result: " + JSON.stringify result

    # Check Result
    if not result
      # Error
      console.warn "Error."
      alert "Error 500: Natural Language Processing failed. (train_libs_check_result/2)"
    else
      # Success
      console.log "Success."
      input_ = result
      count = 0
      result_ = []
      train_libs_req.forEach (item) ->

        # Check if Exists
        if input_.indexOf(item) < 0
          console.warn "User failed."
        else
          console.log item + " found."
          count++
          console.log "input[]: " + input_[input_.indexOf(item)] + ", " + input_.indexOf(item)
          console.log "Debug input: " + JSON.stringify input
          result_.push [item, input[input_.indexOf(item)]]

      console.log "Debug result_: " + JSON.stringify result_
      console.log "Debug input_: " + JSON.stringify input_

      if count == train_libs_req.length
        # User Succeeded, Create Story
        train_libs_result_alert.className = "alert alert-success"
        train_libs_result_correct.innerHTML = "Exactly"
        train_libs_result_alert_text.innerHTML = "Your answer works."

        train_libs_result_story.innerHTML = throbber_small + train_libs_wikipedia_extract
        extract = train_libs_words_c
        console.log "Debug: Extract: " + JSON.stringify extract
        extract_ = []
        # result_ = {"NOUN": "world", "ADJ": "beautiful"}
        console.log JSON.stringify result_
        # extract = {["world", "NOUN"], ["beautiful", "ADJ"]}
        extract.forEach (item, index) ->
          if result_.indexOf(item) < 0
            console.log item + ", " + index
            extract_[result_[result_.indexOf(item)]] = result_.indexOf(item)
          else
            console.log item + ", " + index + "2"
            extract_[index] = item

        extract_f = []
        extract_.forEach (item, index) ->
          console.log index
          extract_f.push index

        console.log "Story JSON: " + JSON.stringify extract_f
        story = extract_.join " "
        console.log "Story: " + story
        train_libs_result_story.innerHTML = story

      else
        # User failed
        train_libs_alert.className = "alert alert-danger"
        train_libs_result_correct.innerHTML = "Nope"
        train_libs_result_alert_text.innerHTML = "That was not correct."
        train_libs_result_story.innerHTML = "Your answer wasn't correct. <i>No story.</i>"

      # Update GUI
      hide_object train_libs_input
      show_object train_libs_result

# **** #Method!Libs ****
create_voclibs_text = (lang_f, text, callback) ->

  client = new HttpClient()
  wikipedia_url = "https://www.runstorageapis.com/vocbox/wikipedia?input=" + urlencode(text) + "&lang=" + lang_f

  console.log "Requesting " + wikipedia_url
  client.get wikipedia_url, (response) ->

    console.log "Received: " + response
    result = JSON.parse response
    if result.text? and result.link?
      result_ = result.text + " <i>(<a href=\"" + result.link + "\">Source</a>)</i>"
      callback result_
    else
      callback false

train_libs_check_result = () ->

  # Log Event
  console.log "Check Result Libs"

  # Show Working
  train_libs_form_btn.innerHTML = "Processing..."

  # Check & create text
  create_voclibs_text forein_lang[1], train_libs_form_input.value, (result) ->

    console.log "Response: " + result
    if not result
      alert "500: Processing Failed."
    else
      register_results "0", 1, (success) ->

        if not success
          console.log "Error"
          alert "500: Database Error"
        else
          console.log "Success"
          train_libs_result_story.innerHTML = result
          hide_object train_libs_input
          show_object train_libs_result

# Form Event Listener to Call Answer Submit
train_libs_form.addEventListener "submit", (evt) ->

  # Prevent action=X
  evt.preventDefault()

  # Call answer submit function
  train_libs_check_result()

# Form Btn Event Listener to Submit Form
train_libs_form_btn.addEventListener "click", () ->

  # Call answer submit function
  #train_libs_check_result()

# Confirm Btn to Activate new Session
train_libs_result_btn.addEventListener "click", () ->

  train_libs_form_btn.innerHTML = "Submit"
  train_libs_form_input.value = ""
  hide_object train_libs_result
  show_object train_libs_input
  train_libs_form_input.focus()

# **** #Method!Image ****
# Get New Image
train_image_new_img = () ->

  # Log Event
  console.log "Requested train_image_new_img()"

  # Get Random Number
  limit = 5000
  rand = Math.floor Math.random() * (limit+1)
  console.log "Image selected: img-" + rand

  # URLs
  img_baseurl = "https://storage.googleapis.com/vocbox-test.appspot.com/vision_images/_d/"
  img_filename = "img-" + rand + ".jpg"
  img_url = img_baseurl + img_filename
  console.log "Image URL: " + img_url
  train_image_img.src = img_url

  info_param = db_actions.imginfo + rand
  info_url = db_baseurl + info_param
  console.log "Info URL: " + info_url

  window.train_image_img_id = rand

  # Prepare & Show GUI
  hide_object train_image_result
  show_object train_image_input

  train_image_form.reset()
  train_image_form_input.focus()

  # TODO: speech recognition code here (eventually)

  # Request word info
  db_client.get info_url, (result) ->

    console.log "Result (img-" + train_image_img_id + ".json): " + result
    result = JSON.parse result

    if forein_lang[1] == "en"
      # Forein Lang is English, no Translation Required
      console.log "forein_lang = en, no translation"
      window.train_img_words_correct = result.labels
    else
      # Translate Labels
      console.log "forein_lang != en, translation required"
      window.train_img_words_correct = []
      result.labels.forEach (label) ->

        # Log Event
        console.log "Translation Requested for " + label

        # Translate
        translate label, "en", forein_lang[1], (response) ->

          # Log Event
          console.log "Translation Done. Response: " + response

          # Chech response
          if not response
            # Error
            console.warn "Translation failed."
          else
            # Success, Push to Array
            console.log "Success, train_img_words_correct[] = " + response
            train_img_words_correct.push response.toLowerCase()

# Check Response
train_image_check_result = () ->

  # Log Event
  console.log "Requested train_image_check_result()"

  # Prepare GUI
  train_image_form_btn_original_text = train_image_form_btn.innerHTML
  train_image_form_btn.innerHTML = "Submitting..."

  # Prepare Input
  input = train_image_form_input.value.toLowerCase()
  console.log "User Input: " + input
  correct_words = 0
  train_img_words_correct.forEach (word) ->

    # Check if word exists in response
    console.log "Searching for " + word

    correct_words++ if input.indexOf(word) >= 0

  # Check results
  list_of_words = train_img_words_correct.join ", "
  train_image_result_alert_text.innerHTML = "The image contains <i>" + list_of_words + "</i>."
  if correct_words > 0
    # Correct
    train_image_result_alert.className = "alert alert-success"
    train_image_result_correct.innerHTML = "Exactly"
    console.log "Correct."
    correct = true
  else
    # Wrong
    train_image_result_alert.className = "alert alert-danger"
    train_image_result_correct.innerHTML = "Nope"
    console.log "User failed."
    correct = false

  # Send Results to DB
  register_results "0", correct, (success) ->

    hide_object train_image_input
    show_object train_image_result
    train_image_form_btn.innerHTML = train_image_form_btn_original_text

    if not success
      console.warn "register_results() failed."
      alert "Error 500: Sending data to Server failed."
      return false
    else
      console.log "Success."
      return true

# Form Event Listener to Call Answer Submit
train_image_form.addEventListener "submit", (evt) ->

  # Prevent action=X
  evt.preventDefault()

  # Call answer submit function
  train_image_check_result()

# Form Btn Event Listener to Submit Form
train_image_form_btn.addEventListener "click", () ->

  # Call answer submit function
  train_image_check_result()

# Confirm Btn to Activate new Session
train_image_result_btn.addEventListener "click", () ->

  # Call Init function
  train_image_new_img()
