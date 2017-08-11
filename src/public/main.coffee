# CoffeeScript for VocBox ClientSide

# Get Elements From DOM
dom_objects = [
  "index",
  "index_signin",
  "index_signin_btn1",
  "index_signin_error",
  "index_signin_error_msg",
  "index_libraries",
  "index_libraries_btn_add"
  "index_libraries_table"
]

dom_objects.forEach (dom_object) ->
  console.log "Getting action_" + dom_object + " from DOM."
  window[dom_object] = document.getElementById "action_" + dom_object

# Authentication
auth = firebase.auth()

# Check if currentUser <> null
auth.onAuthStateChanged (user) ->
  if user?
    # User is logged in
    # Get User Details
    console.log "User seems to be logged in. Getting User Details."
    user_details = {
        name: user.displayName,
        email: user.email,
        photoUrl: user.photoURL,
        emailVerified: user.emailVerified,
        uid: user.uid
      }

    # Set User Details Cookie for Functions
    user_details_cookie = "__session=" + JSON.stringify user_details
    console.log "Setting/Updating user cookie: " + user_details_cookie
    document.cookie = user_details_cookie
    console.log "User signed in successfully"

  else
    # User is logged out
    # Handle Sign In
    console.log "User is logged out."
    console.log auth.currentUser
    window.location.href = "/" if window.location.pathname != "/"

    # Show Sign In Button & add EventListener
    index_signin_btn1.addEventListener "click", () ->

      # Handle Sign In Flow
      console.log "User requested Sign In. Initializing."
      provider = new firebase.auth.GoogleAuthProvider()
      firebase.auth().signInWithPopup(provider).then((result) =>

        # Auth Success
        token = result.credential.accessToken
        document.cookie = "__gtoken=" + token
        console.log "Sign In Successful: __gtoken=" + token
        window.location.reload()

      ).catch((error) =>

        # Auth Failed
        error_details = {
          errorCode: error.code,
          errorMessage: error.message,
          email: error.email,
          credential: error.credential
        }

        console.log "Sign in failed" + JSON.stringify error_details
        index_signin_error_msg = error_details.errorMessage if error_details.errorMessage?
        index_signin_error.style = ""

      )

    index_signin.style = ""


# After this Point the user_details is always != null
# Show List of Libraries & Add Button
if auth.currentUser?
  database = firebase.database()

  # Prepare Table
  libraries_table_count = index_libraries_table.rows.length
  libraries_table_indexes = libraries_table_count-1
  list_entries_count = 0

  # Add Listener
  libraries_list_ref = database.ref 'users/' + user_details.uid + '/libraries'
  libraries_list_ref.on 'value', (snapshot) ->
    index_libraries_table.deleteRow 0 if list_entries_count == 0
    list_entries_count++

    libraries_snapshot = snapshot.val()
    console.log JSON.stringify libraries_snapshot
