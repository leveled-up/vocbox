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

# addEventListener('submit', function(evt){
#    evt.preventDefault();
