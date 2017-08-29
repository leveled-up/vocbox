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

    <pre><a href="#">https://<?=$_SERVER["SERVER_NAME"]?>/share/<?=$_GET["library"]?></a></pre>

    <br />
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
$user_details = json_decode($user_info_["google_info"], true);

if(!isset($_GET["into"])) {
  // user hasn't selected into which library should be imported

  foreach($words as $word)
    $output .= "\n{$word[word_f]} - {$word[word_m]}";

  basic_template();
  ?>
  <h2>Import #<?=$import_library?></h2>

  <p>
    <div class="row">
      <div class="col-sm-6">
        <img src="<?=$user_details["picture"]?>" alt="Profile Picture" />
      </div>
      <div class="col-sm-6">
        <h3><?=$user_details["given_name"]?></h3>
      </div>
    </div>
  </p>
  <p>
    You clicked a link to import library #<?=$import_library?> into your account. Please confirm below.

    <span id="show_pre_span">
      <br />
      <a href="#" id="show_pre">
        <i class="fa fa-arrow-right"></i>
        Show words to import
      </a>
    </span>
    <pre id="pre" style="display: none;"><?=$output?></pre>
    <br />
    Please select the library into which the import should happen below:
    <br />
  </p>

  <form action="" method="get">

    <select name="into" id="into" class="form-control" required="required">
      <option value="" selected disabled>Choose Library</option>
      <?php
        $libraries_list_query = query_library_list($user);
        $libraries_list = query($libraries_list_query, false);

        if(count($libraries_list) < 1)
          echo "<option value=\"\" selected disabled>No Libraries</option>";
        else
          foreach($libraries_list as $library)
            echo "
              <option value=\"{$library[id]}\">
                  <b>".language_pair_to_text($library["langs"])."</b> - {$library[comment]}
              </option>";
      ?>
    </select>

    <br /> <br />
    <button type="submit" class="btn btn-primary">
      <i class="fa fa-check"></i>
      Confirm
    </button>
  </form>

  <br /> <br />

  <!-- Scripts -->
  <script src="/util.js"></script>
  <script src="/share.js"></script>
  <?php
  exit();
}

// import words
// Read Parameter
$into_library = $_GET["into"];
if(!is_numeric($into_library))
  exit("Error 404: The library ID (_into) provided cannot exist.");

foreach($words as $key => $word) {

  $query = query_words_by_word_f($word["word_f"], $into_library, $user);
  $result = query($query);
  if(count($result) > 0)
    unset($words[$key]);
  else {
    $word_ = array($word["word_m"], $word["word_f"]);
    $c = json_decode($word["info"], true);
    if(isset($c["comment"]))
      $word_[] = $c["comment"];
    $create_query = query_words_create($into_library, $user, $word_);
    $create_result = query($create_query);
  }

}

redirect("/library/$into_library");
