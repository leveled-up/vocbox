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
// [ID] [OWNER] [LANGS] [STATS] [CATEGORIES] [COMMENT] [SETTINGS]

// QUERY: create new library
function query_library_create($user, $lang, $comment) {

  $owner = encode($user->id);
  $langs = encode(join("-", $lang));
  $comment = encode($comment);
  if($comment == "")
    $comment = "No comment.";

  $query = "INSERT INTO libraries VALUES ('', '$owner', '$langs', '{}', '1', '$comment', '{}')";
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
  $library = encode($library);

  $query = "SELECT * FROM libraries WHERE owner = '$owner' AND id = '$library' LIMIT 1";
  return $query;

}

// QUERY: update stats of a library
function query_library_statsupdate($library, $user, $stats) {

  $owner = encode($user->id);
  $library = encode($library);
  $stats = encode($stats);

  $query = "UPDATE libraries SET stats = '$stats' WHERE owner = '$owner' AND id = '$library'";
  return $query;

}

// QUERY: update settings of a library
function query_library_settingsupdate($library, $user, $settings) {

  $owner = encode($user->id);
  $library = encode($library);
  $settings = encode($settings);

  $query = "UPDATE libraries SET settings = '$settings' WHERE owner = '$owner' AND id = '$library'";
  return $query;

}

// QUERY: update categories count of a library
function query_library_categoriesupdate($library, $user, $cats) {

  $owner = encode($user->id);
  $library = encode($library);
  $cats = encode($cats);

  $query = "UPDATE libraries SET categories = '$cats' WHERE owner = '$owner' AND id = '$library'";
  return $query;

}

// QUERY: delete an entire library
function query_library_delete($library, $user) {

  $owner = encode($user->id);
  $library = encode($library);

  $query = "DELETE FROM libraries WHERE owner = '$owner' AND id = '$library'";
  return $query;

}

// TABLE "WORDS"
// [ID] [OWNER] [LIBRARY] [WORD_M] [WORD_F] [CATEGORY] [INFO] (info=JSON) [RAND_ID]

// QUERY: create word
function query_words_create($library, $user, $word) {

  $owner = encode($user->id);
  $library = encode($library);
  $word_m = encode($word[0]);
  $word_f = encode($word[1]);
  if(isset($word[2]))
    $info = json_encode(array(
      "comment" => $word[2]
    ));
  else
    $info = "{}";
  $info = encode($info);

  $query = "INSERT INTO words VALUES ('', '$owner', '$library', '$word_m', '$word_f', '1', '$info', FLOOR(RAND()*1000000))";
  return $query;

}

// QUERY: get all words of library
function query_words_list($library, $user) {

  $owner = encode($user->id);
  $library = encode($library);

  $query = "SELECT * FROM words WHERE owner = '$owner' AND library = '$library' ORDER BY category ASC";
  return $query;

}

// QUERY: get all words of library
function query_words_getbyid($library, $user, $word) {

  $owner = encode($user->id);
  $library = encode($library);
  $word = encode($word);

  $query = "SELECT * FROM words WHERE owner = '$owner' AND library = '$library' AND id = '$word'";
  return $query;

}

// QUERY: word picking query
function query_words_get($library, $user, $categories) {

  $owner = encode($user->id);
  $library = encode($library);

  if(!is_numeric($categories))
    return false;

  if(rand(10,50) >= 20)
    $sort = " category ASC,";

  // NOTE:  AND category = '$category'  has been removed, due to it causing bugs when empty categories exist
  $query = array("SELECT * FROM words WHERE library = '$library' AND owner = '$owner' ORDER BY$sort rand_id DESC LIMIT 1", "UPDATE words SET rand_id = FLOOR(RAND()*1000000) WHERE library = '$library' AND owner = '$owner' ORDER BY$sort rand_id DESC LIMIT 1");
  return $query;

}

// QUERY: delete word
function query_words_delete($library, $user, $word_id) {

  $owner = encode($user->id);
  $library = encode($library);
  $word_id = encode($word_id);

  $query = "DELETE FROM words WHERE owner = '$owner' AND library = '$library' AND id = '$word_id'";
  return $query;

}

// QUERY: update category of a word
function query_words_categoryupdate($library, $user, $word_id, $cats) {

  $owner = encode($user->id);
  $library = encode($library);
  $word_id = encode($word_id);
  $cats = encode($cats);

  $query = "UPDATE words SET category = '$cats' WHERE owner = '$owner' AND library = '$library' AND id = '$word_id'";
  return $query;

}

// QUERY: get id's of words in library (for counting words)
function query_words_getids($library, $user) {

  $owner = encode($user->id);
  $library = encode($library);

  $query = "SELECT id FROM words WHERE owner = '$owner' AND library = '$library'";
  return $query;

}

// QUERY: read words of other user
function query_words_other_user($library) {

  $library = encode($library);

  $query = "SELECT * FROM words WHERE library = '$library'";
  return $query;

}

// QUERY: get word by word_f
function query_words_by_word_f($word_f, $library, $user) {

  $owner = encode($user->id);
  $library = encode($library);
  $word_f = encode($word_f);

  $query = "SELECT id FROM words WHERE owner = '$owner' AND library = '$library' AND word_f = '$word_f'";
  return $query;

}
