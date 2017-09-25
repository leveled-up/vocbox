# Speech Recognition and Synthesis
# (using WebSpeechAPI, Chrome might be required)
console.log "Init speech.js"
console.warn "Some browsers may not fully support this module. (https://chrome.com)"

# Speech Recognition
speech_recognition = (language, callback) ->

  # Init
  console.log "Init speech_recognition(), language=" + language
  console.warn "This is only supported by WebKit. Others e.g. Firefox will Fail."
  recognizer = new webkitSpeechRecognition()
  recognizer.lang = language
  recognizer.interimResults = true

  # Fires when Results are available
  recognizer.onresult = (event) ->
      # Words have been recognized
      if event.results.length > 0
        # Get Transcript
        result = event.results[event.results.length-1]
        transcript = result[0].transcript
        console.log "Recognized: " + transcript

        # Callback (new transcript available = 1)
        console.log "Callback(1)"
        callback 1, transcript

        if result.isFinal
          # Callback (final transcript = 2)
          console.log "Callback(2)"
          callback 2, transcript

      # Nothing Recognized
      else
        # Callback (nothing recognized = 3)
        console.warn "Nothing recognized."
        console.log "Callback(3)"
        callback 3, ""

  # Fires if Speech Recognition fails
  recognizer.onerror = (event) ->
    # Callback (recognition error = 4)
    console.warn "Recognition error."
    console.log "Callback(4)"
    callback 4, ""

  # Callback (after Init, allow microphone = 0)
  console.log "Init done. Callback(0)"
  callback 0, ""

  # Start init'ed $recognizer
  recognizer.start()


# Speech Synthesis
speech_synthesis = (text, language, callback) ->

  # Init Synthesis
  console.log "Init speech_synthesis(), text=" + text + ", language=" + language
  console.warn "This is only supported by some browsers e.g. Chrome, Firefox, ..."
  msg = new SpeechSynthesisUtterance()
  voices = window.speechSynthesis.getVoices()

  # **** Unchanged Settings ****
  # Note: some voices don't support altering params
  #msg.voice = voices[10]
  msg.voiceURI = 'native'
  # Volume in Percent (0 to 1)
  msg.volume = 1
  # Rate 0.10 to 1
  msg.rate = 1
  # Pitch 0 to 2
  msg.pitch = 1
  # **** Changing Settings ****
  # Language
  language = 'en-US' if language = 'en'
  msg.lang = language
  # Text
  msg.text = text
  # On End Callback
  msg.onend = (e) ->
    console.log "Synthesis complete. Callback()"
    callback()

  # Init Complete, start Synthesis
  console.log "Init Complete. Stating Synthesis."
  speechSynthesis.speak msg
