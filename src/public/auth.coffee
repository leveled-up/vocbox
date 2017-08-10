# Authentication

firebase.auth().onAuthStateChanged (authData) ->
  if authData
    console.log "User " + authData.uid + " is logged in."
  else
    window.location.href = "/" if window.location != "/"
    console.log "User is logged out."
    action_user_content.innerHTML = "You're not signed in. <a href=\"#\" onclick=\"auth_sign_in()\">Sign in</a>"

# Sign In w/ Google
auth_sign_in = () ->
  provider = new firebase.auth.GoogleAuthProvider()
  firebase.auth().signInWithPopup(provider).then((result) =>

    token = result.credential.accessToken
    user = result.user
    console.log "Signed in with " + user.email
    user_details = {
        name: user.displayName,
        email: user.email,
        photoUrl: user.photoURL,
        emailVerified: user.emailVerified,
        uid: user.uid,
        functions_token: user.getToken()
      }

    document.cookie "__session=" + JSON.stringify user_details

  ).catch((error) =>

    errorCode = error.code;
    errorMessage = error.message;
    email = error.email;
    credential = error.credential;
    console.log "Sign in failed; Error " + errorCode

  )
