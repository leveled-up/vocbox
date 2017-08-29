# Helper Script for /share.php

dom_objects = [
  "show_pre",
  "show_pre_span"
  "pre"
]
get_objects dom_objects

# EventListener
show_pre.addEventListener "click", () ->

  console.log "User clicked show_pre."
  hide_object show_pre_span
  show_object pre
