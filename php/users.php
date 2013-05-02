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
		$this->db = new mysqli('localhost', '******', '******', '******');
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
			case 'GET':
				$this->get_user(); break;
			case 'POST':
				$this->login(); break;
			default: header('HTTP/1.1 405 Method Not Allowed');
            			break;
		}
	}

	/**
	* Gateway function for all GET user service calls. This function examines the
	* contents of the URL and directs the call to the corresponding method.
	*/
	function get_user()
	{
		$array = explode("/", trim($_SERVER['REQUEST_URI'], "/"));

		if (is_numeric($array[1]))
		{
			$this->get_name($array[1]);
		}
		else if ($array[1] == '')
		{
			$this->get_all_users();
		}
		else
		{
			header('HTTP/1.1 405 Method Not Allowed');
		}
	}

	/**
	* Service call for retrieving a list of all users.
	* Input: none
	* Output: JSON-formatted user information
	*/
	function get_all_users()
	{
		$stmt = $this->db->prepare("SELECT id, name, email FROM users");
		$stmt->execute();
		$stmt->bind_result($id, $name, $email);

		// Loop through returned results and write to array
		$json = array();
		while ($row = $stmt->fetch())
		{
			$user_array = array();
			$user_array['id'] = $id;
			$user_array['name'] = $name;
			$user_array['email'] = $email;
			$json[]['user'] = $user_array;
		}

		$stmt->close();

		// Wrap array of users in a parent questions object so array can be easily retrieved
		$json_users = array();
		$json_users['users'] = $json;

		// Encode array in JSON
		$encoded_json = json_encode($json_users);

		$this->sendResponse(200, $encoded_json);
	}

	/**
	* Service call for retrieving the name of a user given their id.
	* Input: a user id
	* Output: JSON-formatted status and user name
	*/
	function get_name($user_id)
	{
		$stmt = $this->db->prepare("SELECT name FROM users WHERE id=?");
		$stmt->bind_param("d", $user_id);
		$stmt->execute();
		$stmt->bind_result($name);
		$stmt->fetch();
		$user_name = $name;
		$stmt->close();

		// Format the return JSON with the user's name
		$json_response = "{\"status\":\"success\", \"name\":\"".$user_name."\"}";

		$this->sendResponse(200, $json_response);
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
		$stmt = $this->db->prepare("SELECT id, name FROM users WHERE email=? AND password=?");
		$username = $json_array->{'username'};
		$password = $json_array->{'password'};
		$stmt->bind_param('ss', $username, $password);
		$stmt->execute();
		$stmt->bind_result($id, $name);
		$stmt->fetch();
		$user_id = $id;
		$user_name = $name;
		$stmt->close();

		// Set the default status to failed. If a user id was found, then change status to success.
		$status = "failed";
		if ($user_id > 0)
		{
			$status = "success";
		}

		// Format the return response with status and user id (if status is failed, user_id will be 0)
		$json_response = "{\"status\":\"".$status."\", \"user_id\":".$user_id.", \"user_name\":\"".$user_name."\"}";

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