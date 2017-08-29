<?php
// Share & Import
include("core/core.inc.php");

if(isset($_GET["create"])) {
  // get import link
  basic_template();
  ?>
  <h2>Share #<?=$_GET["library"]?></h2>

  <p>
    You can share this library by giving the following link to others:

    <pre>
      <a href="#">https://<?=$_SERVER["SERVER_NAME"]?>/share/<?=$_GET["library"]?></a>
    </pre>

    <a href="/library/<?=$_GET["library"]?>" class="btn btn-primary">
      <i class="fa fa-check"></i>
      Back
    </a>
  </p>

  <?php
  exit();
}

// Read Parameter
$import_library = $_GET["library"];
if(!is_numeric($import_library))
  exit("Error 404: The library ID provided cannot exist.");

// Get Words & get User Info
$query_words = query_words_other_user($import_library);
$words = query($query_words, false);

if(count($words) < 1)
  exit("<H1>Sorry!</H1>This library doesn't exist or is empty.");

$user_id_ = $words[0]["owner"];
$user_info_query = query_user_info($user_id_);
$user_info_ = query($user_info_query);
$user_details = json_decode($user_info_["google_info"]);

if(!isset($_GET["into"])) {
  // user hasn't selected into which library should be imported

  $ouput = "Words:";
  foreach($words as $word)
    $output .= "{$word[word_f]} - {$word[word_m]}";

}
