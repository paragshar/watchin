<?php
$request_uri = $_SERVER['REQUEST_URI'];
$url = str_replace('/watchin/public/request.php', 'http://192.168.1.8:3000', $request_uri);
//print_r($url);
$data = file_get_contents('php://input');
//print_r($data);
//print_r("Method :".$_SERVER['REQUEST_METHOD']);
//$url = 'http://192.168.1.5:8000/api/v1/customer/42/?format=json';

$ch = curl_init($url);
$options = array(
    CURLOPT_URL            => $url,
    CURLOPT_RETURNTRANSFER => true,
    CURLOPT_HEADER         => true,

);
//curl_setopt_array( $ch, $options );

curl_setopt($ch, CURLOPT_POSTFIELDS, $data);
curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
//curl_setopt($ch, CURLOPT_PUT, false);
curl_setopt($ch, CURLOPT_CUSTOMREQUEST, $_SERVER['REQUEST_METHOD']);

curl_setopt($ch, CURLOPT_HTTPHEADER, array('Content-Type: application/json'));

$response = curl_exec($ch);

//print_r($response);
$http_status = curl_getinfo($ch,CURLINFO_HTTP_CODE);
curl_close($ch);

//echo "<br/>";
//print_r('code : '.$http_status);
//echo "<br/>";
echo($response);
?>