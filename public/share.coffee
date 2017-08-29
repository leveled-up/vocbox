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

share_btn.addEventListener "click", () ->

  if navigator.share?
    navigator.share({
      #title: document.title,
      #text: "Hello World",
      url: share_url
    }).then () ->
      console.log 'Successful share'
    .catch (error) ->
      console.log 'Error sharing:', error
  else
    window.location.href = twitter_url
