# Helper Script for /share.php

dom_objects = [
  "show_pre",
  "show_pre_span"
  "pre",
  "share_btn"
]
get_objects dom_objects

# EventListener
if show_pre?
  show_pre.addEventListener "click", () ->

    console.log "User clicked show_pre."
    hide_object show_pre_span
    show_object pre

# Web Share API
if share_btn?
  share_btn.addEventListener "click", () ->

    console.log "Requested Share"
    if navigator.share
      navigator.share {
          title: '',
          text: 'Import Vocabulary from VocBox',
          url: this.href,
      }

      .then () -> 
        console.log 'Successful share'

      .catch (error) ->
        console.log 'Error sharing', error

    return false
