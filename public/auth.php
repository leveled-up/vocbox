<?php
// Auth Script

// If user is Signed In, Sign Out
session_start();
if(isset($_SESSION["user"])) {

  session_destroy();
  unset($_COOKIE["__gtoken"]);
  include("core/core.inc.php");

}

// Sign In Flow
// If Sign In Token has been Sent, Sign In/Up
if(isset($_COOKIE["__gtoken"]) or isset($_POST["__gtoken"])) {

  // Test
  exit(file_get_contents("https://www.googleapis.com/oauth2/v1/userinfo?alt=json&access_token=".$_COOKIE["__gtoken"]));

  header("Location: /");
  exit;
}

// Else Redirect User To Sign In
echo file_get_contents("template/basic.tpl");
?>
<h2>Welcome to VocBox</h2>
<p>To use VocBox we kindly ask to sign in with Google, so we can identify you, if you come back.</p>
<div id="auth_index">
  <a href="#" id="auth_index_signin_btn">
    <img src="https://www.runstorageapis.com/img/vocbox/btn_google_signin_dark_normal_web.png" alt="Sign in w/ Google" />
  </a>
</div>

<!-- Scripts -->
<script src="https://vocbox-test.firebaseapp.com/__/firebase/4.2.0/firebase-app.js"></script>
<script src="https://vocbox-test.firebaseapp.com/__/firebase/4.2.0/firebase-auth.js"></script>
<script src="https://vocbox-test.firebaseapp.com/__/firebase/init.js"></script>
<script src="/util.js"></script>
<script src="/auth.js"></script>
