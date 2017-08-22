<?php
// Library Manager
include("core/core.inc.php");

// Read Parameter
$current_library = $_GET["library"];
if(!is_numeric($current_library))
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
      <div class=\"panel panel-default\">
        <div class=\"panel-body\">
          <h3>$info</h3>
          <span>$label</span>
        </div>
      </div>
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

<p>
  This is your <b><?=$languages_text?></b> library. All words can be found by clicking <i>List of Words</i> below the stats.

  <br /> <br />
</p>

<div class="btn-group">
  <a href="/add/<?=$library_info["id"]?>" id="library_btn_add" class="btn btn-default">
    <i class="fa fa-plus"></i>
    Add Words
  </a>
  <a href="/train/<?=$library_info["id"]?>" id="library_btn_train" class="btn btn-default">
    <i class="fa fa-arrow-up"></i>
    Train
  </a>
</div>

<div class="row">
  <?=$stats_echo?>
</div>

<center>
  <a href="#" id="library_btn_listwords">
    <i class="fa fa-arrow-down"></i>
    List of Words
  </a>
</center>