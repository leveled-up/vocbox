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

// If Data is Sent to Script from Train.js, Proccess it
if(isset($_GET["action:get_next_word"])) {
  // get next word for training from DB
  $word_get_query = query_words_get($library_info["id"], $user, $library_info["categories"]);
  $result = array();
  for ($i = 1; $i <= 5; $i++) {
    $result = query($word_get_query, false);
    if(count($result) > 0)
      break;
  }

  if(count($result) < 1)
    exit("{\"success\": false}");

  unset($result[0]["owner"]);
  $json = array(
    "success" => true,
    "word" => $result[0]
  );

  exit(json_encode($json));

}
elseif(isset($_GET["action:results"])) {

  // save info about training, if user tricks this, he/she's just tricking him/herself
  /*$insert = $_GET["action:insert"];
  $insert = json_decode($insert, true);
  if($insert[0] == "" or $insert[1] == "")
    exit("1");

  if(count($insert) > 3 or count($insert) < 2)
    exit("2");

  if(isset($insert[2]))
    if($insert[2] == "")
      unset($insert[2]);

  $insert_query = query_words_create($library_info["id"], $user, $insert);
  $insert_result = query($insert_query);

  // Update stats
  $stats = json_decode($library_info["stats"], true);
  $stats["words_added"]++;
  $stats = json_encode($stats);
  $stats_update_query = query_library_statsupdate($library_info["id"], $user, $stats);
  $stats_update_result = query($stats_update_query);

  // exit
  exit("0");*/
}

// Languages
$languages_text = language_pair_to_text($library_info["langs"]);
$languages_text_array = explode(" - ", $languages_text);
$forein_lang_text = $languages_text_array[1];
$mother_lang_text = $languages_text_array[0];
$languages_array = explode("-", $library_info["langs"]);
$forein_lang = $languages_array[1];
$mother_lang = $languages_array[0];

// Prepare & Show Page
basic_template();
?>
<h2>Train <?=$forein_lang_text?> (#<?=$library_info["id"]?>)</h2>

<!-- Prepared HTML -->

<!-- Train Method!Chooser -->
<div id="train_method_chooser" style="">
  <!-- Method Info -->
  <p>
    Please choose the method you'd like to use to train below. If you don't want to train right now, you can get back to your library by <a href="/library/<?=$library_info["id"]?>">clicking here</a>.
    <br /> <br />
  </p>
  <!-- Method:Type -->
  <div class="col-sm-3">
    <div class="panel panel-default">
      <div class="panel-body">
        <center>
          <a href="#" id="train_method_type">
            <h3>Type</h3>
            <span>You can train words the good old way, just by looking at the <?=$mother_lang_text?> words and then typing the <?=$forein_lang_text?> words.</span>
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
          <a href="#" id="train_method_speak">
            <h3>Speak</h3>
            <span>We'll play the <?=$mother_lang_text?> words, then you can speak the <?=$forein_lang_text?> words.</span>
          </a>
        </center>
      </div>
    </div>
  </div>
  <!-- Method:Libs -->
  <div class="col-sm-3">
    <div class="panel panel-default">
      <div class="panel-body">
        <center>
          <a href="#" id="train_method_libs">
            <h3>VocLibs</h3>
            <span>We'll play a game. We ask you to tell us some sentences in <?=$forein_lang_text?> and we'll create a nice text.</span>
          </a>
        </center>
      </div>
    </div>
  </div>
</div>
<!-- Method:Image -->
<div class="col-sm-3">
  <div class="panel panel-default">
    <div class="panel-body">
      <center>
        <a href="#" id="train_method_image">
          <h3>Describing</h3>
          <span>We'll show you pictures, which you need to describe in <?=$forein_lang_text?>.</span>
        </a>
      </center>
    </div>
  </div>
</div>
</div>

<!-- Train Method!Type -->
<div id="train_type" style="display: none;">
  Type
</div>

<!-- Train Method!Speak -->
<div id="train_speak" style="display: none;">
  Speak
</div>

<!-- Train Method!Libs -->
<div id="train_libs" style="display: none;">
  Voc Libs
</div>

<!-- Train Method!Image -->
<div id="train_image" style="display: none;">
  Describing
</div>

<!-- Scripts -->
<script>
  // Library ID, and Languages for add.js
  var library_id, forein_lang, mother_lang;
  library_id = <?=$library_info["id"]?>;
  forein_lang = ["<?=$forein_lang_text?>", "<?=$forein_lang?>"];
  mother_lang = ["<?=$mother_lang_text?>", "<?=$mother_lang?>"];
</script>
<script src="/util.js"></script>
<script src="/speech.js"></script>
<script src="/main.js"></script>
<script src="/train.js"></script>
