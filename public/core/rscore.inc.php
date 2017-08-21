<?php
// RunStorage Software Core (PHP)
// (c) 2017 RunStorage Technologies
// Version 1.0

// set configuration
// Database Setup
$db_setup["database_prefix"] = "";
$db_setup["database_host"] = "";
$db_setup["database_user"] = "";
$db_setup["database_pass"] = "";

$db_setup["database_id"] = "";

// Mail Setup
$mail_setup["base_url"] = "https://mail.runstorageapis.com/mail";

// Error Setup
$error_setup["template_url"] = "https://www.runstorageapis.com/static/errors/error-template.v1.html";
$error_setup["mail_address"] = "support@runstorage.io";
$error_setup["messages_list_url"] = "https://www.runstorageapis.com/static/errors/error-msg.v1.json";

// Project Setup
$project_name = "VocBox";
$project_domain = "vocbox.one";


// initialize variables
$con = null;

// connect to database using $db_setup
function database_connect() {

    global $db_setup;
    global $con;

    // MYSQL connection data
  	$hostname = $db_setup["database_host"];
  	$database = $db_setup["database_prefix"].$db_setup["database_id"];
  	$username = $db_setup["database_user"];
  	$dbpassword = base64_decode($db_setup["database_pass"]);

  	// MYSQL create connection
  	$con = mysqli_connect($hostname, $username, $dbpassword, $database);
    if(!$con)
      error_msg(900);

    return true;

}

// mysqli_real_escape_string without $con, supporting urlencode
function encode($string, $urlencode = false) {

    global $con;

    $result = mysqli_real_escape_string($con, $string);
    if($urlencode)
      $result = urlencode($result);

  	return $result;

}

// execute mysqli query without $con
function query($query, $simple_result = true) {

    global $con;

  	$result = mysqli_query($con, $query);
  	if(!$result)
      error_msg(901);

    $return = array();

  	while($row = mysqli_fetch_array($result))
      $return[] = $row;

    if(count($return) < 2 AND $simple_result)
  	  return $return[0];
    else
      return $return;

}


// switch database
function select_db ($db_id) {

    global $con;
    global $db_setup;

    if(!mysqli_select_db($con, "{$db_setup[database_prefix]}$db_id"))
      error_msg(900);

    return true;
}

// generate a unique id
function generate_id ($length = 0) {

	   $id = md5(uniqid(rand(), true));

     if($length > 0)
      $id = substr($id, 0, $length);

     return $id;

}

// checks if a string is alphanumeric
function is_alphanumeric ($string) {

    return ctype_alnum($string);

}

// redirects the user's browser to the URL given in $url
function redirect ($url) {

    header("Location: $url");
    exit;

}

// sends an HTTP Post request to $url with the data provided in $data
function http_post ($url, $data) {

    $options = array(
      'http' => array(
          'header'  => "Content-type: application/x-www-form-urlencoded\r\n",
          'method'  => 'POST',
          'content' => http_build_query($data)
      )
    );

    $context  = stream_context_create($options);
    $result = file_get_contents($url, false, $context);

    if(!$result)
       return false;

    return $result;
}

// sends an email using the setup in $mail_setup
function send_mail ($to, $subject, $body) {

    global $mail_setup;

    // set request parameters
    $url = $mail_setup["base_url"];
    // $data[ma] sets the output to machine readable
    $data = array(
      "to" => $to,
      "subject" => $subject,
      "body" => $body,
      "ma" => true
    );

    if(!http_post($url, $data))
      error_msg(902);

    return true;
}

// sends an error message to the user using $error_setup and the code given in $err_code
function error_msg ($err_code) {

    global $error_setup;

    $template = file_get_contents($error_setup["template_url"]);
    if($template == "")
      $template = "<h1>Error #%CODE%</h1><p>An error occurred. Please contact us at %MAIL%.<br>%MSG%</p>";

    $error_list = file_get_contents($error_setup["messages_list_url"]);
    $error_list = json_decode($error_list, true);

    if(!isset($error_list[$err_code]))
      $msg = "There was an error while loading the error messages list";
    else
      $msg = $error_list[$err_code];

    $error_info = array("host" => $_SERVER["SERVER_NAME"], "request" => $_SERVER["REQUEST_URI"], "GET" => $_GET, "POST" => $_POST);
    $error_info = "ERR:$err_code,".base64_encode(json_encode($error_info)).";";

    $page = str_replace("%CODE%", $err_code, $template);
    $page = str_replace("%MAIL%", "<a href=\"mailto:{$error_setup[mail_address]}\">{$error_setup[mail_address]}</a>", $page);
    $page = str_replace("%MSG%", $msg, $page);
    $page = str_replace("%EINFO%", $error_info, $page);

    if($page == "")
      $page = "<h1>Error #$err_code</h1>";

    header("Content-type: text/html");
    exit($page);

}

// make number of bytes human-readable
function format_filesize ($bytes, $precision = 2) {

    $units = array('B', 'KiB', 'MiB', 'GiB', 'TiB');

    $bytes = max($bytes, 0);
    $pow = floor(($bytes ? log($bytes) : 0) / log(1024));
    $pow = min($pow, count($units) - 1);

    // Uncomment one of the following alternatives
    // $bytes /= pow(1024, $pow);
     $bytes /= (1 << (10 * $pow));

    return round($bytes, $precision) . ' ' . $units[$pow];
}
