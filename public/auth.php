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
$redirect_url = "/";
if(isset($_GET["redirect"]))
  $redirect_url = $_GET["redirect"];

if(isset($_COOKIE["__gtoken"]) or isset($_POST["__gtoken"])) {

  // Include Database Access
  include("core/rscore.inc.php");
  database_connect();
  include("core/database.inc.php");

  // Get User ID & Info
  include("core/auth.inc.php");
  $__gtoken = $_COOKIE["__gtoken"];
  if($__gtoken == "")
    $__gtoken = $_POST["__gtoken"];
  if($__gtoken == "")
    exit("Error 400: __gtoken must be passed via _COOKIE or _POST.");

  $user_info = get_user_info_from_token($__gtoken);
  if($user_info == FALSE)
    exit("Error 403: __gtoken was invalid. Could not revalidate with www.googleapis.com.");
  if($user_info->auth->verified_email != TRUE)
    exit("Error 403: Your e-mail needs to be verified to sign in to VocBox.");

  $user_id = get_user_id_from_mail($user_info->auth->email);

  // Get User Info from Database
  $user_info_query = query_user_info($user_id);
  $user_info_query_result = query($user_info_query);
  if(!isset($user_info_query_result->id)) {
    // User does not exist in Database: Sign Up required.

    $user_create_query = query_user_create($user_info);
    $user_create_query_result = query($user_create_query);

    $user_info_query_result = query($user_info_query);

    if(!isset($user_info_query_result->id))
      exit("Error 500: Creation of user failed.");

  }

  $user = $user_info_query_result;
  $_SESSION["user"] = $user;

  header("Location: $redirect_url");
  exit;
}

// Else Redirect User To Sign In
echo file_get_contents("template/basic.tpl");
?>
<h2>Welcome to VocBox</h2>
<p>To use VocBox we kindly request you to sign in with <i>Google</i>, so we can identify you, if you come back.</p>
<div id="auth_index">
  <a href="#" id="auth_index_signin_btn">
    <img src="https://www.runstorageapis.com/img/vocbox/btn_google_signin_dark_normal_web.png" alt="Sign in w/ Google" />
  </a>
</div>

<br /> <br />
<address>&copy; RunStorage Technologies &middot; Google is a registered trademark of Google, Inc.</address>

<!-- Scripts -->
<script src="https://vocbox-test.firebaseapp.com/__/firebase/4.2.0/firebase-app.js"></script>
<script src="https://vocbox-test.firebaseapp.com/__/firebase/4.2.0/firebase-auth.js"></script>
<script src="https://vocbox-test.firebaseapp.com/__/firebase/init.js"></script>
<script src="/util.js"></script>
<script src="/auth.js"></script>
