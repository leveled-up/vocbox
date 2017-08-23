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
