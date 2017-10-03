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
  exit("0");
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
<h2>Add words</h2>

<!-- Prepared HTML -->

<!-- Add Method!Chooser -->
<div id="add_method_chooser" style="">
  <!-- Method Info -->
  <p>
    Please choose the method you'd like to use to add words below. If you don't want to add words, you can get back to your library by <a href="/library/<?=$library_info["id"]?>">clicking here</a>.
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
  <!-- Method:Import -->
  <div class="col-sm-3">
    <div class="panel panel-default">
      <div class="panel-body">
        <center>
          <a href="#" id="add_method_import" style="color: grey; pointer-events: none;">
            <h3>Import</h3>
            <span>You can import <?=$forein_lang_text?> words via a sharing link or by choosing public libraries with key vocabulary.</span>
          </a>
        </center>
      </div>
    </div>
  </div>
</div>

<!-- Add Method!Type -->
<div id="add_type" style="display: none;">
  <p>
    Below you can type your words the old-fashioned way. If you'd like to use a more modern way to add words, please <a href="#" id="add_type_back">click here</a>.
    <br /> <br />
  </p>

  <form action="#" method="" id="add_type_form">
    <b>
      <input id="add_type_word_f" class="form-control" placeholder="<?=$forein_lang_text?> Word" />
    </b>
    <br />

    <b>
      <input id="add_type_word_m" class="form-control" placeholder="<?=$mother_lang_text?> Word" />
    </b>
    <br />

    <span id="add_type_show_comment" style="">
      <center>
        <a href="#" id="add_type_comment_btn">Add Comment</a>
      </center>
    </span>

    <span id="add_type_comment_span" style="display: none;">
      <input id="add_type_comment" class="form-control" placeholder="Comment" />
      <br />
    </span>

    <br />

    <center>
      <button type="submit" id="add_type_form_btn" class="btn btn-success">Submit</button>
    </center>
  </form>
</div>

<!-- Add Method!Speak -->
<div id="add_speak" style="display: none;">
  <p>
    <span id="add_speak_status" style="color: grey;">Not the method you wanted? To get back, <a href="#" id="add_speak_back">click here</a>.</span>
    <i>Text will be translated by Google.</i>
    <br /> <br />
  </p>

  <form action="#" method="" id="add_speak_form">
    <b>
      <input id="add_speak_word_f" class="form-control" placeholder="<?=$forein_lang_text?> Word" />
    </b>
    <br />

    <b>
      <input id="add_speak_word_m" class="form-control" placeholder="<?=$mother_lang_text?> Word (auto)" />
    </b>
    <br />

    <span id="add_speak_show_comment" style="">
      <center>
        <a href="#" id="add_speak_comment_btn">Add Comment</a>
      </center>
    </span>

    <span id="add_speak_comment_span" style="display: none;">
      <input id="add_speak_comment" class="form-control" placeholder="Comment" />
      <br />
    </span>

    <br />

    <center>
      <button speak="submit" id="add_speak_form_btn" class="btn btn-success btn-lg">Submit</button>
    </center>
  </form>
</div>

<!-- Add Method!Scan -->
<div id="add_scan" style="display: none;">
  <p>
    <span id="add_scan_status" style="color: grey;">Please click below to take a photo or select one from your gallery. Not the method you wanted? Get back by <a href="#" id="add_scan_back">clicking here</a>. <i>Text will be translated by Google.</i></span>
    <br /> <br />
  </p>

  <span id="add_scan_upload_select_span" style="">
    <div id="add_scan_upload_div">
      <label class="btn btn-default btn-file">
          Select Photo <input type="file" value="upload" id="add_scan_file_button" class="form-control" style="display:none;" />
      </label>
    </div>
  </span>

  <span id="add_scan_confirm_span" style="display: none;">
    <pre id="add_scan_confirm_pre">

    </pre>

    <a href="#" id="add_scan_confirm_btn" class="btn btn-success">Submit</a>
  </span>

  <span id="add_scan_done" style="display: none;">
    <b>
      Everything worked. <a href="#" id="add_scan_done_back">Back</a>
    </b>
  </span>
</div>

<!-- Scripts -->
<script>
  // Library ID, and Languages for add.js
  var library_id, forein_lang, mother_lang;
  library_id = <?=$library_info["id"]?>;
  forein_lang = ["<?=$forein_lang_text?>", "<?=$forein_lang?>"];
  mother_lang = ["<?=$mother_lang_text?>", "<?=$mother_lang?>"];
</script>
<script src="https://vocbox-test.firebaseapp.com/__/firebase/4.2.0/firebase-app.js"></script>
<script src="https://vocbox-test.firebaseapp.com/__/firebase/4.2.0/firebase-storage.js"></script>
<script src="https://vocbox-test.firebaseapp.com/__/firebase/init.js"></script>
<script src="/util.js"></script>
<script src="/speech.js"></script>
<script src="/main.js"></script>
<script src="/add.js"></script>
