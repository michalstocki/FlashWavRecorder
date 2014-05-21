<?php
$save_folder = dirname(__FILE__) . "/audio";
if(! file_exists($save_folder)) {
  if(! mkdir($save_folder)) {
    die("failed to create save folder $save_folder");
  }
 }

function valid_wav_file($file) {
  $handle = fopen($file, 'r');
  $header = fread($handle, 4);
  list($chunk_size) = array_values(unpack('V', fread($handle, 4)));
  $format = fread($handle, 4);
  fclose($handle);
  return $header == 'RIFF' && $format == 'WAVE' && $chunk_size == (filesize($file) - 8);
}

$key = 'filename';
$tmp_name = $_FILES["upload_file"]["tmp_name"][$key];
$upload_name = $_FILES["upload_file"]["name"][$key];
$type = $_FILES["upload_file"]["type"][$key];
$filename = "$save_folder/$upload_name";
$saved = 0;
if($type == 'audio/wav' && preg_match('/^[a-zA-Z0-9_\-]+\.wav$/', $upload_name) && valid_wav_file($tmp_name)) {
  $saved = move_uploaded_file($tmp_name, $filename) ? 1 : 0;
}

if($_POST['format'] == 'json') {
  header('Content-type: application/json');
  print "{\"saved\": $saved}";
} else {
  print $saved ? "Saved" : 'Not saved';
}

exit;
?>
