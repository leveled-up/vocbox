# Useful Functions for VocBox Client Scripts
console.log "Init util.js"

# HttpClient Class
# client = new HttpClient()
# client.get 'http://some/thing?with=arguments', (response) -> [...]
HttpClient = () ->
    # HTTP Get Function
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

    # Init Done
    true

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

# Alias for encodeURIComponent
urlencode = (string) ->
  encodeURIComponent string

# Generate storageFilename
guid = () ->
   s4() + s4() + '-' + s4() + '-' + s4() + '-' + s4() + '-' + s4() + s4() + s4()

# Generate storageFilename Helper
s4 = () ->
   Math.floor (1 + Math.random()) * 0x10000
      .toString 16
      .substring 1

# Generate Filename From Input Filename
getStorageFilename = (filename, server_dir) ->
   server_dir + "/" + guid() + "-" + guid() + "." + filename.split('.').pop()

# Function for Formatting File Sizes
formatFilesize = (bytes) ->
   sizes = ['B', 'KiB', 'MiB', 'GiB', 'TiB', 'PiB']
   return '0 Byte' if bytes == 0

   i = parseInt Math.floor(Math.log(bytes) / Math.log(1024))
   size = Math.round(bytes / Math.pow(1024, i), 2) + ' ' + sizes[i]
   return size

# Function for Formatting Seconds in to Human Readable Format
formatSeconds = (secs) ->
   distance = secs * 1000

   # Time calculations for hours, minutes and seconds
   hours = Math.floor (distance / (1000 * 60 * 60))
   minutes = Math.floor (distance % (1000 * 60 * 60)) / (1000 * 60)
   seconds = Math.floor ((distance % (1000 * 60)) / 1000)

   # Return the result as String
   formattedTime = ""
   formattedTime += hours + "h " if hours > 0
   formattedTime += minutes + "m " if minutes > 0
   formattedTime += seconds + "s "
   return formattedTime

# Vibration API for Mobile
vibration = () ->

  duration = 200
  if navigator.vibrate?
    navigator.vibrate duration
    true
  else
    false
