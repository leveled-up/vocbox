<?php
// Get Random Article Summary from Wikipedia

$lang = $_GET["lang"];
$langs = array("zh", "en", "fr", "de", "it", "ja", "ko", "pt", "es");
if(strlen($lang) != 2 OR !in_array($lang, $langs))
  exit("500x0");

$url = "https://$lang.wikipedia.org/w/api.php?action=query&generator=random&grnnamespace=0&prop=extracts&exintro=&explaintext=&titles=&format=json";

$result = file_get_contents($url);
$result = json_decode($result, true);
$result__ = array_shift($result["query"]["pages"]);
$result = $result__["extract"];
$title = rawurlencode($result__["title"]);
$wikipedia_link = "https://$lang.wikipedia.org/wiki/$title";

if($result == "")
  exit("500x1");

$wikipedia_text = $result;

// NLP Processing
$text = urlencode($result);
$baseurl = "https://us-central1-vocbox-test.cloudfunctions.net/analyzeTextSyntax";
$url = "$baseurl?q=$text";

$result = file_get_contents($url);
$result = json_decode($result, true);
if(!$result["success"])
  exit("500x2");
$result = $result["result"];
foreach($result as $value)
  $result_[] = array($value["text"]["content"], $value["partOfSpeech"]["tag"]);

$wikipedia_nlp = $result_;

// NLP user input
$text = urlencode($_GET["input"]);
$url = "$baseurl?q=$text";

$result = file_get_contents($url);
$result = json_decode($result, true);
if(!$result["success"])
  exit("500x3");
$result = $result["result"];
unset($result_);
foreach($result as $value)
  $result_[] = array($value["text"]["content"], $value["partOfSpeech"]["tag"]);

$input_nlp = $result_;

// process user input and wikipedia (create text)
$allowed_tags = array("NOUN", "VERB", "ADJ");
foreach($input_nlp as &$word) {

  if(!in_array($word[1], $allowed_tags))
    unset($word);

  if(!in_array($word[1], $tags_))
    $tags_[] = $word[1];

  foreach($wikipedia_nlp as &$wikipedia_word)
    if($wikipedia_word[1] == $word[1]) {
      $wikipedia_word = $word[0];
      break;
    }
}

foreach($wikipedia_nlp as &$word)
  if(is_array($word))
    $word = $word[0];

$result = join($wikipedia_nlp, " ");
$result = json_encode(array("text" => $result, "link" => $wikipedia_link));

header("Cache-control: no-store");
header("Access-Control-Allow-Origin: *");
header("Content-type: application/json");
exit($result);
