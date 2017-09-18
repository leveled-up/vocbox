# VocBox Sign In
console.log "Init auth.js"

# DOM Object
dom_objects = [
  "auth_index",
  "auth_index_signin_btn",
  "auth_index_signin_span",
  "auth_index_signin_state_span"
]
get_objects dom_objects

# Authentication
auth = firebase.auth()
auth_state = 0

# Check if currentUser <> null
auth.onAuthStateChanged (user) ->
  if user?
    # User is logged in
    # Get User Details
    console.log "User seems to be logged in. Getting User Details."

    gtokencookie = getCookie "__gtoken"
    if gtokencookie?
      console.log "Sign In Successful: __gtoken=" + gtokencookie

      # Set User Details Cookie for Functions
      console.log "User signed in successfully"
      hide_object auth_index_signin_btn
      auth_index_signin_state_span.innerHTML = "Signing in. This may take up to 10s if you are signing in for the first time."
      show_object auth_index_signin_span

      window.location.reload()
    else
      firebase.auth().signOut().then () ->
        console.log 'Signed Out'

  else
    # User is logged out
    # Handle Sign In
    console.log "User is logged out."
    console.log auth.currentUser

    # Show Sign In Button & add EventListener
    auth_index_signin_btn.addEventListener "click", () ->

      # Handle Sign In Flow
      console.log "User requested Sign In. Initializing."

      hide_object auth_index_signin_btn
      auth_index_signin_state_span.innerHTML = "Waiting. Please sign in to Google inside the new browser window. If this is not possible, please click <a href=\"\">here</a> to reload the page."
      show_object auth_index_signin_span

      provider = new firebase.auth.GoogleAuthProvider()
      firebase.auth().signInWithPopup(provider).then((result) =>

        # Auth Success
        token = result.credential.accessToken
        document.cookie = "__gtoken=" + token
        console.log "Sign In Successful: __gtoken=" + token

      ).catch((error) =>

        # Auth Failed
        error_details = {
          errorCode: error.code,
          errorMessage: error.message,
          email: error.email,
          credential: error.credential
        }

        console.log "Sign in failed" + JSON.stringify error_details
        alert "Sign in Failed"

        hide_object auth_index_signin_btn
        auth_index_signin_state_span.innerHTML = "Signing in failed, please click <a href=\"\">here</a> to reload the page."
        show_object auth_index_signin_span
      )
