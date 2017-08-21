<?php
// Auth Helper

// Get Google Info from Auth Token
function get_user_info_from_token($bearer) {

  $auth_baseurl = "https://www.googleapis.com/oauth2/v1/userinfo";
  if($bearer == "")
    exit("Error 403: \$bearer was not provided.");

  $token = urlencode($bearer);
  $params = "?alt=json&access_token=".$token;

  $auth_url = $auth_baseurl.$params;
  $result = file_get_contents($auth_url);

  if($result == "" OR $result == FALSE)
    exit("Error 500: Connecting to www.googleapis.com failed.");

  $result_obj = json_decode($result, false);
  if($result_obj->id == "")
    return false;

  $return = array(
    "gstring" => $result,
    "auth" => $result_obj
  );
  return (object)$return;

}


// Get User ID from email
function get_user_id_from_mail($mail) {

  return md5($mail);

}
