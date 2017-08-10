# Authentication

firebase.auth().onAuth (authData) =>
  if authData
    console.log "User " + authData.uid + " is logged in with " + authData.provider
  else
    console.log "User is logged out"
    auth_sign_in()

# Sign In w/ Google
auth_sign_in = () ->
  provider = new firebase.auth.GoogleAuthProvider()
  firebase.auth().signInWithPopup(provider).then((result) =>

    token = result.credential.accessToken
    user = result.user
    console.log "Signed in with " + user

  ).catch((error) =>

    errorCode = error.code;
    errorMessage = error.message;
    email = error.email;
    credential = error.credential;
    console.log "Sign in failed; Error " + errorCode

  )
