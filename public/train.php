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
    $result = query($word_get_query[0], false);
    $result_ = query($word_get_query[1], false);
    if(count($result) > 0)
      break;
  }

  if(count($result) < 1)
    exit("{\"success\": false}");

  unset($result[0]["owner"]);
  unset($result[0][1]);
  $json = array(
    "success" => true,
    "word" => $result[0]
  );

  header("Content-type: application/json");
  exit(json_encode($json, JSON_PRETTY_PRINT));

}
elseif(isset($_GET["action:results"])) {

  // save info about training, if user tricks this, he/she's just tricking him/herself
  $param = json_decode($_GET["action:results"], false);
  if($param->word_id == "" OR $param->correct == "")
    exit("{\"success\": false}");
  $word_id = $param->word_id;
  if(!is_numeric($word_id))
    exit("{\"success\": false}");
  $correct = $param->correct;
  if($correct != "1" and $correct != "0")
    exit("{\"success\": false}");

  if($word_id != "0") {
    $word_details_query = query_words_getbyid($library_info["id"], $user, $word_id);
    $result = query($word_details_query);

    if(!isset($result["id"]))
      exit("{\"success\": false}");


    if($correct == "1") {

      $cats = $result["category"]+1;
      if($result["category"] >= $library_info["categories"]) {
        // new category
        $query_cat_update = query_library_categoriesupdate($library_info["id"], $user, $cats);
        $query_cat_result = query($query_cat_update);
      }
      // category ++
      $query_cat_update_ = query_words_categoryupdate($library_info["id"], $user, $word_id, $cats);
      $query_cat_result_ = query($query_cat_update_);

    } else {
      // wrong => set category to 1
      $cats = 1;
      $query_cat_update_ = query_words_categoryupdate($library_info["id"], $user, $word_id, $cats);
      $query_cat_result_ = query($query_cat_update_);

    }
  }

  // Update stats
  // Stats: {words_added: int, words_trained: int, words_trained_correct: int, last_training_time: int}
  $stats = json_decode($library_info["stats"], true);
  // workaround against +2
  $x = .5;
  if($word_id == "0")
    $x = 1;

  $stats["words_trained"] = $stats["words_trained"]+$x;
  if($correct == "1")
    $stats["words_trained_correct"] = $stats["words_trained_correct"]+$x;
  else
    if(!isset($stats["words_trained_correct"]))
      $stats["words_trained_correct"] = 0;
  $stats["last_training_time"] = time();
  $stats = json_encode($stats);
  $stats_update_query = query_library_statsupdate($library_info["id"], $user, $stats);
  $stats_update_result = query($stats_update_query);

  // exit
  exit("{\"success\": true}");
}
elseif(isset($_GET["action:wikipedia_proxy"])) {

  $request = $_GET["action:wikipedia_proxy"];
  exit(file_get_contents("https://en.wikipedia.org/w/api.php?$request"));

}
elseif(isset($_GET["action:image_info_proxy"])) {

  $request = $_GET["action:image_info_proxy"];
  exit(file_get_contents("https://storage.googleapis.com/vocbox-test.appspot.com/vision_images/_d/img-$request.json"));

}
elseif(isset($_GET["action:yt_justnow"])) {

  $languages_array = explode("-", $library_info["langs"]);
  $forein_lang = $languages_array[1];
  $json = file_get_contents("https://justnow-api-s2.runstorageapis.com/$forein_lang.json");
  $result = json_decode($json, true);

  echo "<table class=\"table table-striped\">";
    foreach($result["items"] as $count => $item) {
      $count_ = $count+1;
      echo "<tr>
              <td>#$count_</td>
              <td>
                <b>{$item[channel]} - <a href=\"{$item[link]}\" target=\"_blank\">{$item[title]}</a></b>
              </td>
            </tr>";
    }
  echo "</table><br/>
    <center>
      <a href=\"https://www.youtube.com/feed/trending\">
	     <img src=\"https://developers.google.com/youtube/images/developed-with-youtube-sentence-case-dark.png\" height=\"80px\" />
      </a>
    </center>";
  exit();

}
elseif(isset($_GET["action:summarize"])) {

  $languages_array = explode("-", $library_info["langs"]);
  $lang = $languages_array[1];
  $request = "action=query&generator=random&grnnamespace=0&prop=extracts&exintro=&explaintext=&titles=&format=json";

  for ($i = 1; $i <= 3; $i++) {
    $json = file_get_contents("https://$lang.wikipedia.org/w/api.php?$request");
    $data = json_decode($json, true);
    $result[] = array_shift($data["query"]["pages"]);
  }

  $options[] = array(md5($result[0]["title"]), $result[0]["title"]);
  $options[] = array(md5($result[1]["title"]), $result[1]["title"]);
  $options[] = array(md5($result[2]["title"]), $result[2]["title"]);
  shuffle($options);
  foreach($options as $option)
    $options_[$option[0]] = $option[1];

  $return = array(
    "correct" => md5($result[0]["title"]),
    "title" => $result[0]["title"],
    "text" => $result[0]["extract"],
    "options" => $options_
  );

  exit(json_encode($return, JSON_PRETTY_PRINT));

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
<h2>Train <?=$forein_lang_text?></h2>

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
  <!-- Method:Image -->
  <div class="col-sm-3">
    <div class="panel panel-default">
      <div class="panel-body">
        <center>
          <a href="#" id="train_method_image">
            <h3>Describe</h3>
            <span>We'll show you pictures, which you need to describe in <?=$forein_lang_text?>.</span>
            <span style="color: grey;">
              <br />
              Watch out! It might be difficult.
            </span>
          </a>
        </center>
      </div>
    </div>
  </div>
  <?php if($forein_lang != "ru") { ?>
  <!-- Method:Libs -->
  <div class="col-sm-3">
    <div class="panel panel-default">
      <div class="panel-body">
        <center>
          <a href="#" id="train_method_libs">
            <h3>VocLibs <span style="color: grey;">Beta</span></h3>
            <span>We'll play a game. We ask you to tell us some sentences in <?=$forein_lang_text?> and we'll create a nice text.</span>
            <span style="color: grey;">
              <br />
              This feature is still in Beta.
            </span>
          </a>
        </center>
      </div>
    </div>
  </div>
  <?php } else {
    echo "<a href=\"#\" id=\"train_method_libs\" style=\"display: none;\"></a>";
  } ?>
  <!-- Method:Watch -->
  <div class="col-sm-3">
    <div class="panel panel-default">
      <div class="panel-body">
        <center>
          <a href="#" id="train_method_watch">
            <h3>Watch</h3>
            <span>You'll train by watching the latest and greatest YouTube videos in <?=$forein_lang_text?>.</span>
          </a>
        </center>
      </div>
    </div>
  </div>
  <!-- Method:Summary -->
  <div class="col-sm-3">
    <div class="panel panel-default">
      <div class="panel-body">
        <center>
          <a href="#" id="train_method_summary" style="color: grey; pointer-events: none;">
            <h3>Summarize</h3>
            <span>You'll listen to a text in <?=$forein_lang_text?>, which you need to summarize by choosing a headline. (Private Beta)</span>
          </a>
        </center>
      </div>
    </div>
  </div>
  <!-- Method:Surprise -->
  <div class="col-sm-3">
    <div class="panel panel-default">
      <div class="panel-body">
        <center>
          <a href="#" id="train_method_surprise" style="color: grey; pointer-events: none;">
            <h3>Surprise</h3>
            <span>You'll see a random word in <?=$forein_lang_text?> and its translation. You can listen to it and save it into your library. (Private Beta)</span>
          </a>
        </center>
      </div>
    </div>
  </div>
</div>

<!-- Train Method!Type -->
<div id="train_type" style="display: none;">
  <p>
    Here, you can train the good old way, just by reading the <?=$mother_lang_text?> words and then typing the <?=$forein_lang_text?> words.
    If you're looking for a more modern way to train vocabulary, please <a href="?">click here</a>.

    <br />
  </p>
  <span id="train_type_question" style="">
    <center>
      What's
      <b>
        <span id="train_type_word_m">train_type_word_m</span>
      </b>
      in <?=$forein_lang_text?>?
    </center>
    <br /> <br />

    <form action="#" method="" id="train_type_form">
      <b>
        <input id="train_type_form_word_f" class="form-control" placeholder="<?=$forein_lang_text?> Word" />
      </b>
      <br />

      <center>
        <button type="submit" id="train_type_form_btn" class="btn btn-success">Submit</button>
      </center>
    </form>

    <br /> <br />
  </span>
  <span id="train_type_result" style="display: none;">
    <div id="train_type_result_alert" class="alert alert-success">
      <b>
        <span id="train_type_result_correct">Exactly/Nope</span>!
      </b>
      The correct answer is: The <?=$forein_lang_text?>
      <b>
        <span id="train_type_result_word_f">train_type_result_positive_word_f</span>
      </b>
      means
      <b>
        <span id="train_type_result_word_m">train_type_result_word_m</span>
      </b>.
    </div>
    <br />

    <center>
      <a href="#" id="train_type_result_confirm" class="btn btn-success">Confirm</a>
    </center>
  </span>
</div>

<!-- Train Method!Speak -->
<div id="train_speak" style="display: none;">
  <p>
    Here, you can train <?=$forein_lang_text?>, by listening to <?=$mother_lang_text?> words and then speaking the <?=$forein_lang_text?> words.
    You can get back by <a href="?">clicking here</a>. <i>Text will be translated by Google.</i>

    <br />
  </p>
  <span id="train_speak_question" style="">
    <center>
      What's
      <b>
        <span id="train_speak_word_m">train_speak_word_m</span>
      </b>
      in <?=$forein_lang_text?>?

      <br />

      <span id="train_speak_status" style="color: grey;">train_speak_status</span>
    </center>
    <br /> <br />

    <form action="#" method="" id="train_speak_form">
      <b>
        <input id="train_speak_form_word_f" class="form-control" placeholder="<?=$forein_lang_text?> Word" />
      </b>
      <br />

      <center>
        <button type="submit" id="train_speak_form_btn" class="btn btn-success btn-lg">Submit</button>
      </center>
    </form>
  </span>
  <span id="train_speak_result" style="display: none;">
    <div id="train_speak_result_alert" class="alert alert-success">
      <b>
        <span id="train_speak_result_correct">Exactly/Nope</span>!
      </b>
      The correct answer is: The <?=$forein_lang_text?>
      <b>
        <span id="train_speak_result_word_f">train_speak_result_positive_word_f</span>
      </b>
      means
      <b>
        <span id="train_speak_result_word_m">train_speak_result_word_m</span>
      </b>.
      <a id="train_speak_result_listen" href="#" class="alert-link">
        Play <i class="fa fa-volume-up"></i>
      </a>
    </div>
    <br />

    <center>
      <a href="#" id="train_speak_result_confirm" class="btn btn-success btn-lg">Confirm</a>
    </center>
  </span>
</div>

<!-- Train Method!Libs -->
<div id="train_libs" style="display: none;">
  <p>
    VocLibs is a slightly different training method. You're not going to always train exactly the words from your library, but it's going to fun. Need to train exactly your words? <a href="?">Click here</a>.

    <br />
  </p>

  <span id="train_libs_input" style="">
    <center>
      <span style="color: grey;">
        <span id="train_libs_question">Please enter a complete <?=$forein_lang_text?> sentence below. </span>
        <br /> <br />
      </span>
    </center>

    <form action="#" method="" id="train_libs_form">

      <input id="train_libs_form_input" class="form-control" placeholder="<?=$forein_lang_text?> Sentence" />

      <br />

      <center>
        <button type="submit" id="train_libs_form_btn" class="btn btn-success">Submit</button>
      </center>
    </form>
  </span>
  <span id="train_libs_result" style="display: none;">
    <div id="train_libs_result_alert" class="alert alert-success">
      <b>
        <span id="train_libs_result_correct">Yes</span>!
      </b>

      <span id="train_libs_result_alert_text">The new text is ready for you to read.</span>
    </div>
    <br />

    <center>
      <div class="well">
        <span id="train_libs_result_story">train_libs_story</span>
      </div>
    </center>
    <br /> <br />

    <center>
      <a href="#" id="train_libs_result_btn" class="btn btn-success">Confirm</a>
    </center>
  </span>
</div>

<!-- Train Method!Image -->
<div id="train_image" style="display: none;">
  <p>
    Here you are going to train <?=$forein_lang_text?> by describing images in full sentences. If this is not the method you wanted, please <a href="?">click here</a>. <i>Image Labels will be translated by Google.</i>
    <br /> <br />
  </p>
  <span id="train_image_input">
      <center>
        <img id="train_image_img" alt="Loading..." width="90%" />
      </center>
      <br /> <br />

      <form action="#" method="" id="train_image_form">

        <input id="train_image_form_input" class="form-control" placeholder="<?=$forein_lang_text?> sentence" />
        <br /> <br />

        <center>
          <a href="#" id="train_image_form_btn" class="btn btn-success">Confirm</a>
        </center>
      </form>
  </span>

  <span id="train_image_result" style="display: none;">
    <div id="train_image_result_alert" class="alert alert-success">
      <b>
        <span id="train_image_result_correct">Exactly/Nope</span>!
      </b>

      <span id="train_image_result_alert_text">train_image_result_alert_text</span>
    </div>
    <br /> <br />

    <center>
      <a href="#" id="train_image_result_btn" class="btn btn-success">Confirm</a>
    </center>
  </span>
</div>

<!-- Train Method!Watch -->
<div id="train_watch" style="display: none;">
  <p>
    Here you are going to train <?=$forein_lang_text?> by watching the <?=$forein_lang_text?> YouTube Trends. If this is not the method you wanted, please <a href="?">click here</a> to get back.
    <br /> <br />
  </p>
  <div id="train_watch_alert" class="alert alert-success">
    If you want to train exactly your words, you'll be able to perform a YouTube search for <a id="train_watch_alert_word_f" href="#" class="alert-link" target="_blank">train_watch_alert_word_f</a> by clicking the word.
    <a href="#" id="train_watch_alert_refresh" class="alert-link"><i class="fa fa-refresh"></i></a>
  </div>
  <span id="train_watch_table">
    <center>
      <img src="https://www.runstorageapis.com/img/throbber_small.svg" /> &nbsp;
      Loading...
    </center>
  </span>
</div>

<!-- Train Method!Summary -->
<div id="train_summary" style="display: none;">
  <p>
    Here you are going to train <?=$forein_lang_text?> by listening to text and selecting the appropriate title. If this is not the method you wanted, please <a href="?">click here</a> to get back.
    <br /> <br />
  </p>
  <span></span>
</div>

<!-- Scripts -->
<script>
  // Library ID and Languages for train.js
  var library_id, forein_lang, mother_lang;
  library_id = <?=$library_info["id"]?>;
  forein_lang = ["<?=$forein_lang_text?>", "<?=$forein_lang?>"];
  mother_lang = ["<?=$mother_lang_text?>", "<?=$mother_lang?>"];
</script>
<script src="/util.js"></script>
<script src="/speech.js"></script>
<script src="/main.js"></script>
<script src="/train.js"></script>
