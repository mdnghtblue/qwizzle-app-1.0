<?php

include "qwizzle.php";
include "users.php";
include "request.php";

// Retrieve the request URI to determine which type of service to use
$array = explode("/", trim($_SERVER['REQUEST_URI'], "/"));

$service_name = $array[0];

if ($service_name == "qwizzle")
{
	$service = new Qwizzle;
	$service->serve();
}
else if ($service_name == "user")
{
	$service = new Users;
	$service->serve();
}
else if ($service_name == "request")
{
	$service = new Request;
	$service->serve();
}

?>