<?php
include("core/core.inc.php");

if(isset($_POST["new_library_form_langs_m"])) {

  // Form has been Submitted, Create Library
  $postvalues = array(
    "new_library_form_langs_m",
    "new_library_form_langs_f",
    "new_library_form_comment"
  );

  foreach($postvalues as &$postvalue)
    if($_POST[$postvalue] == "" and $postvalue != "new_library_form_comment")
      exit("You must fill all fields.");
    else
      $postvalue = $_POST[$postvalue];

  // Languages
  $languages = languages_supported();
  if(!in_array($postvalues[0], $languages) or !in_array($postvalues[1], $languages))
    exit("The language selected is not supported yet.");
  if($postvalues[0] == $postvalues[1])
    exit("You must choose two different languages.");

  $lang = array($postvalues[0], $postvalues[1]);

  // Comment
  if($postvalues[2] == "")
    $postvalues[2] = "No comment.";
  $comment = $postvalues[2];

  // Database Request
  $library_create_query = query_library_create($user, $lang, $comment);
  $library_create = query($library_create_query);

  // Redirect to Home Page
  redirect("/");

}

// Create Options for Language Select
$languages = languages_supported_text();
foreach($languages as $lang_code => $lang_text)
  $lang_select .= "<option value=\"$lang_code\">$lang_text</option>";

basic_template();
?>
<h2>Create a new library</h2>
<p>
  Here you may create a new library. If your language is not supported or you have other questions, feel free to <?=$contact_us?>.
</p>

<form method="post" action="" id="new_library_form">
  <p>
    What's your <b>mother tongue</b>?
    <br /> <br />
  </p>

  <select name="new_library_form_langs_m" id="new_library_form_langs_m" class="form-control">
      <!--<option>Languages here</option>-->
      <option value="" selected disabled>Choose Language</option>
      <?=$lang_select?>
  </select>

  <p>
    <br /> <br />
    What's the <b>forein language</b> you want to learn?
    <br /> <br />
  </p>

  <select name="new_library_form_langs_f" id="new_library_form_langs_f" class="form-control">
      <!--<option>Languages here</option>-->
      <option value="" selected disabled>Choose Language</option>
      <?=$lang_select?>
  </select>

  <p>
    <br /> <br />
    Is there anything you'd like to add (e.g. a <b>personal comment</b>)?
    <br /> <br />
  </p>

  <input name="new_library_comment" id="new_library_comment" class="form-control" placeholder="No comment." />

  <br /> <br />
  <button name="new_library_submit_btn" id="new_library_submit_btn" class="btn btn-primary">
    <i class="fa fa-check"></i>
    Submit
  </button>

</form>
