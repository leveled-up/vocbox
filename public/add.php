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

// If Data is Sent to Script from Add.js, Proccess it
if(isset($_GET["action:insert"])) {

  $insert = $_GET["action:insert"];
  $insert = json_decode($insert, true);
  if($insert[0] == "" or $insert[1] == "")
    exit("1");

  if(count($insert) > 3 or count($inser) < 2)
    exit("2");

  if(isset($insert[2]))
    if($insert[2] == "")
      unset($insert[2]);

  $insert_query = query_words_create($library_info["id"], $user, $insert);
  $insert_result = query($insert_query);

  // exit
  exit("0");
}

// Languages
$languages_text = language_pair_to_text($library_info["langs"]);
$languages_text_array = explode(" - ", $languages_text);
$forein_lang_text = $languages_text_array[1];
$mother_lang_text = $languages_text_array[0];

// Prepare & Show Page
basic_template();
?>
<h2>Add words</h2>

<!-- Prepared HTML -->

<!-- Add Method!Chooser -->
<div id="add_method_chooser" style="">
  <!-- Method Info -->
  <p>
    Please choose the method you'd like to use to add words below.
    <br /> <br />
  </p>
  <!-- Method:Type -->
  <div class="col-sm-3">
    <div class="panel panel-default">
      <div class="panel-body">
        <center>
          <a href="#" id="add_method_type">
            <h3>Type</h3>
            <span>You can add words the good old way, just by typing.</span>
          </a>
        </center>
      </div>
    </div>
  </div>
  <!-- Method:Speak -->
  <div class="col-sm-3">
    <div class="panel panel-default">
      <div class="panel-body">
        <center>
          <a href="#" id="add_method_speak">
            <h3>Speak</h3>
            <span>You can speak the <?=$forein_lang_text?> words, we'll auto-complete the <?=$mother_lang_text?> words.</span>
          </a>
        </center>
      </div>
    </div>
  </div>
  <!-- Method:Scan -->
  <div class="col-sm-3">
    <div class="panel panel-default">
      <div class="panel-body">
        <center>
          <a href="#" id="add_method_scan">
            <h3>Scan</h3>
            <span>You can scan the <?=$forein_lang_text?> words with your camera, we'll auto-complete the <?=$mother_lang_text?> words.</span>
          </a>
        </center>
      </div>
    </div>
  </div>
</div>

<!-- Add Method!Type -->
<div id="add_type" style="display: none;">
Type
</div>

<!-- Add Method!Speak -->
<div id="add_speak" style="display: none;">
Speak
</div>

<!-- Add Method!Scan -->
<div id="add_scan" style="display: none;">
Scan
</div>

<!-- Scripts -->
<script>
  // Library ID for add.js
  var library_id;
  library_id = <?=$library_info["id"]?>;
</script>
<script src="/util.js"></script>
<script src="/speech.js"></script>
<script src="/main.js"></script>
<script src="/add.js"></script>
