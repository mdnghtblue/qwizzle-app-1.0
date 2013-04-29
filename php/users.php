<?php

/** 
* Class that represents a Users object. The methods in this class
* perform database transactions relating to users.
*/
class Users
{

	/**
	* Constructor. Initializes the database connection.
	*/
	function __construct()
	{
		$this->db = new mysqli('localhost', '[username]', '[password]', '[database]');
		$this->db->autocommit(TRUE);
	}

	/**
	* Destructor. Closes the database connection.
	*/
	function __destruct()
	{
		$this->db->close();
	}

	/**
	* This function determines which service call to invoke depending on the 
	* HTTP request method. 
	*/
	function serve()
	{
		$method = $_SERVER['REQUEST_METHOD'];

		switch ($method)
		{
			case 'POST': 
				$this->login(); break;
			default: header('HTTP/1.1 405 Method Not Allowed');
            			break;
		}
	}
	
	/**
	* Service call for authenticating a user with a username and password.
	* Input: JSON-formatted username and password
	* Output: JSON-formatted status and user id
	*/
	function login()
	{
		// Retrieve the input JSON
		$json_array = json_decode(file_get_contents('php://input'));
		
		// Search the users table for a matching username/password combination
		$stmt = $this->db->prepare("SELECT id FROM users WHERE email=? AND password=?");
		$username = $json_array->{'username'};
		$password = $json_array->{'password'};
		$stmt->bind_param('ss', $username, $password);
		$stmt->execute();
		$stmt->bind_result($id);
		$stmt->fetch();
		$user_id = $id;
		$stmt->close();
		
		// Set the default status to failed. If a user id was found, then change status to success.
		$status = "failed";
		if ($user_id > 0)
		{
			$status = "success";
		}
		
		// Format the return response with status and user id (if status is failed, user_id will be 0)
		$json_response = "{\"status\":\"".$status."\", \"user_id\":".$user_id."}";

		$this->sendResponse(200, $json_response);
	}
	
	/**
	* Helper method to send a HTTP response code/message
	*/
	function sendResponse($status = 200, $body = '', $content_type = 'text/html')
	{
    		$status_header = 'HTTP/1.1 ' . $status . ' ' . 'OK';
    		header($status_header);
    		header('Content-type: ' . $content_type);
    		echo $body;
	}
}

?>