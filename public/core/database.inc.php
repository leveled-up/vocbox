<?php
// Database Script

// TABLE "USERS"
// [ID] [NAME] [EMAIL] [GOOGLE_INFO] [LAST_SIGN_IN]
//CREATE TABLE `users` ( `id` VARCHAR(32) NOT NULL , `name` TEXT NOT NULL , `email` TEXT NOT NULL , `google_info` LONGTEXT NOT NULL , `last_sign_in` INT NOT NULL , PRIMARY KEY (`id`)) ENGINE = MyISAM COMMENT = 'TABE USERS: [ID] [NAME] [EMAIL] [GOOGLE_INFO] [LAST_SIGN_IN]';

// QUERY: get info of specific user id
function query_user_info($user_id) {

  $user = encode($user_id);
  $query = "SELECT * FROM users WHERE id = '$user'";
  echo $query;
  return $query;

}

// QUERY: create new user from google info
function query_user_create($user_info) {

  $q[] = $user_info->auth->given_name; // [NAME]
  $q[] = $user_info->auth->email; // [EMAIL]
  $q[] = $user_info->gstring; // [GOOGLE_INFO]
  $id = get_user_id_from_mail($user_info->auth->email);
  $last_sign_in = time();

  foreach($q as $vq)
    $query .= "'".encode($vq)."', ";

  $query = "INSERT INTO users VALUES ( '$id', $query'$last_sign_in' )";
  return $query;

}
