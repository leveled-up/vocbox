<?php
// Library Manager
include("core/core.inc.php");

// Read Parameter
$current_libary = $_GET["library"];
echo $current_libary;
if(!is_numeric($current_libary))
  exit("Error 404: The library ID provided cannot exist.");

// Get Info from Database
$library_info_query = query_library_info($current_library, $user);
$library_info = query($library_info_query);
if(!isset($library_info["id"]))
  exit("Error 404: The library {$current_library} was not found this user.");

// Prepare Stats
function library_make_info_panel($info, $label) {
    return "
    <div class=\"col-sm-6\">
      <center>
        <h3>$info</h3>
        <span>$label</span>
      </center>
    </div>";
}

// Stats: {words_added: int, words_trained: int, words_trained_correct: int}
$stats = json_decode($library_info["stats"], true);
$stats_possible_values = array(
  "words_added" => "words added",
  "words_trained" => "words trained",
  "words_trained_correct" => "words correct",
  "last_training_time" => "last training"
);

foreach($stats_possible_values as $stats_key => $stats_label)
  if(isset($stats[$stats_key])) {
      if($stats_key == "last_training_time")
        $stats[$stats_key] = date("m/d/Y", $stats[$stats_key]);
      $stats_echo .= library_make_info_panel($stats[$stats_key], $stats_label);
    }

if(!isset($stats_echo))
  $stats_echo = "
  <center>
    <b>
      This library is so brand new, we don't have any stats. <a href=\"/add_words/{$library_info[id]}\">Get Started</a>
    </b>
  </center>";

// Prepare & Print Page
$languages_text = language_pair_to_text($library_info["langs"]);
basic_template();
?>
<h2><?=$languages_text?> (#<?=$library_info["id"]?>)</h2>

<div class="row">
  <?=$stats_echo?>
</div>
