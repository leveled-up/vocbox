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
    <div class=\"col-sm-3\">
      <div class=\"panel panel-default\">
        <div class=\"panel-body\">
          <center>
            <h3>$info</h3>
            <span>$label</span>
          </center>
        </div>
      </div>
    </div>";
}

// Stats: {words_added: int, words_trained: int, words_trained_correct: int, last_training_time: int}
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
        $stats[$stats_key] = date("d/m/Y", $stats[$stats_key]);
      $stats_echo .= library_make_info_panel($stats[$stats_key], $stats_label);
    }

if(!isset($stats_echo))
  $stats_echo = "
  <center>
  This library is so brand new, we don't have any stats. <a href=\"/add/{$library_info[id]}\">Get Started</a>
    <b>
    </b>
  </center>";

// Prepare & Print Page
$languages_text = language_pair_to_text($library_info["langs"]);
$languages_text_array = explode(" - ", $languages_text);
basic_template();
?>
<h2><?=$languages_text?> (#<?=$library_info["id"]?>)</h2>

<p>
  This is your <b><?=$languages_text?></b> library. All words can be found by clicking <i>List of Words</i> below the stats. If this is not the library you ment to open, get back by <a href="/">clicking here</a>.

  <br /> <br />
</p>

<!-- Main Navigation -->
<div class="btn-group">
  <a href="/add/<?=$library_info["id"]?>" id="library_btn_add" class="btn btn-default">
    <i class="fa fa-plus"></i>
    Add Words
  </a>
  <a href="/train/<?=$library_info["id"]?>" id="library_btn_train" class="btn btn-default">
    <i class="fa fa-arrow-up"></i>
    Training
  </a>
</div>

<!-- Library Stats -->
<div class="row">
  <br /> <br />

  <?=$stats_echo?>

  <br /> <br />
</div>

<!-- List of Words -->
<div id="library_listwords">
  <span id="library_listwords_btn_span" style="">
    <center>
      <a href="#library_listwords" id="library_listwords_btn">
        <i class="fa fa-arrow-down"></i>
        List of Words
      </a>
    </center>
  </span>
  <span id="library_listwords_spinner" style="display: none;">
    <center>
      <img src="https://www.runstorageapis.com/img/throbber_small.svg" alt="" />
      &nbsp; One moment, please.
    </center>
  </span>
  <span id="library_listwords_table_span" style="display: none;">
    <table id="library_listwords_table" class="table table-striped">
      <thead>
        <th><?=$languages_text_array[1]?></th>
        <th><?=$languages_text_array[0]?></th>
        <th>Category</th>
        <th>Actions</th>
      </thead>
      <tbody id="library_listwords_table_tbody">
        <tr>
          <td>
            <b id="library_listwords_table_error">Unknown Error.</b>
          </td>
          <td></td>
          <td></td>
          <td></td>
        </tr>
      </tbody>
    </table>
  </span>
</div>

<!-- Bottom <br> for Mobile Scrolling -->
<div>
  <br /> <br />
</div>

<!-- Scripts -->
<script>
  // Library ID for library.js
  var library_id;
  library_id = <?=$library_info["id"]?>;
</script>
<script src="/util.js"></script>
<script src="/library.js"></script>
