# Useful Functions for VocBox Client Scripts
console.log "Init util.js"

# HttpClient Class
# client = new HttpClient()
# client.get 'http://some/thing?with=arguments', (response) -> [...]
HttpClient = () ->
    this.get = (aUrl, aCallback) ->
        console.log "Preparing HTTP GET to " + aUrl
        anHttpRequest = new XMLHttpRequest()
        anHttpRequest.onreadystatechange = () ->
            console.log "State Changed. Status: " + anHttpRequest.status
            if anHttpRequest.readyState == 4 and anHttpRequest.status == 200
                console.log "Status 200, Calling Callback."
                aCallback anHttpRequest.responseText

        anHttpRequest.open "GET", aUrl, true
        console.log "Calling " + aUrl
        anHttpRequest.send null

# DOM Object Getting Function
# get_objects ["dom1", "dom2", ...]
get_objects = (dom_objects) ->
  console.log "Getting Objects From DOM."
  console.log JSON.stringify dom_objects

  dom_objects.forEach (dom_object) ->
    console.log "Getting " + dom_object + " from DOM."
    window[dom_object] = document.getElementById dom_object

# Get Cookie By name
getCookie = (name) ->
  console.log "Requested getting contents of " + name + " cookie."
  console.log "Current Cookies: " + document.cookie

  value = "; " + document.cookie
  parts = value.split "; " + name + "="
  return parts.pop().split(";").shift() if parts.length == 2

# Hide DOM object using CSS
# (!) This may delete other CSS
hide_object = (dom_object) ->
  console.log "Requested hide_object() for " + dom_object.id
  dom_object.style = "display: none;"

# Show DOM object using CSS
# (!) This may delete other CSS
show_object = (dom_object) ->
  console.log "Requested show_object() for " + dom_object.id
  dom_object.style = ""
