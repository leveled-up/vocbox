<?php
// Database Script

// TABLE "USERS"
// [ID] [NAME] [EMAIL] [GOOGLE_INFO] [LAST_SIGN_IN]
//CREATE TABLE `users` ( `id` VARCHAR(32) NOT NULL , `name` TEXT NOT NULL , `email` TEXT NOT NULL , `google_info` LONGTEXT NOT NULL , `last_sign_in` INT NOT NULL , PRIMARY KEY (`id`)) ENGINE = MyISAM COMMENT = 'TABE USERS: [ID] [NAME] [EMAIL] [GOOGLE_INFO] [LAST_SIGN_IN]';

// QUERY: get info of specific user id
function query_user_info($user_id) {

  $user = encode($user_id);
  $query = "SELECT * FROM users WHERE id = '$user' LIMIT 1";
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

// QUERY: Update last sign in
function query_user_update_lastsignin($user_info) {

  $last_sign_in = time();
  $user_id = get_user_id_from_mail($user_info->email);

  $query = "UPDATE users SET last_sign_in = '$last_sign_in' WHERE id = '$user_id'";
  return $query;
  
}

// TABLE "LIBRARIES"
// [ID] [OWNER] [LANGS] [STATS] [COMMENT]
// CREATE TABLE `libraries` ( `id` INT NOT NULL AUTO_INCREMENT , `owner` VARCHAR(32) NOT NULL , `langs` VARCHAR(5) NOT NULL , `stats` LONGTEXT NOT NULL , `comment` LONGTEXT NOT NULL , PRIMARY KEY (`id`)) ENGINE = MyISAM COMMENT = 'TABLE \"LIBRARIES\" [ID] [OWNER] [LANGS] [STATS] [COMMENT]';

// QUERY: create new library
function query_library_create($user, $lang, $comment) {

  $owner = encode($user->id);
  $langs = encode(join("-", $lang));
  $comment = encode($comment);
  if($comment == "")
    $comment = "No comment.";

  $query = "INSERT INTO libraries VALUES ('', '$owner', '$langs', '{}', '$comment')";
  return $query;

}

// QUERY: list libraries of user
function query_library_list($user) {

  $owner = encode($user->id);

  $query = "SELECT * FROM libraries WHERE owner = '$owner'";
  return $query;

}

// QUERY: get details about a library
function query_library_info($library, $user) {

  $owner = encode($user->id);
  $libary = encode($library);

  $query = "SELECT * FROM libraries WHERE owner = '$owner' AND id = '$library' LIMIT 1";
  return $query;

}

// QUERY: update stats of a library
function query_library_statsupdate($libary, $user, $stats) {

  $owner = encode($user->id);
  $libary = encode($library);
  $stats = encode($stats);

  $query = "UPDATE libraries SET stats = '$stats' WHERE owner = '$owner' AND id = '$library'";
  return $query;

}

// QUERY: delete an entire library
function query_library_delete($library, $user) {

  $owner = encode($user->id);
  $libary = encode($library);

  $query = "DELETE FROM libraries WHERE owner = '$owner' AND id = '$library'";
  return $query;

}
