<?php

/**
* Class that represents a Request object. The methods in this class
* perform database transactions relating to qwizzle requests.
*/
class Request
{
	private $db;

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
				$this->get_requests(); break;
			case 'PUT':
				$this->send_request(); break;
			case 'DELETE':
				$this->delete_request(); break;
			default: header('HTTP/1.1 405 Method Not Allowed');
            			break;

		}

	}

	/**
	* Service call for retrieving requests with a user id.
	* Input: the user id
	* Output: JSON-formatted list of qwizzle requests
	*/
	function get_requests()
	{
		// Retrieve the user id from the request URI
		$array = explode("/", trim($_SERVER['REQUEST_URI'], "/"));
		$user_id = $array[1];

		// Get the list of requests with sender id and sender name from the requests table
		$stmt = $this->db->prepare("SELECT q.id, q.creator, q.title, q.creation_date, r.sender_id, u.name FROM qwizzles q, requests r, users u where q.id = r.qwizzle_id and r.sender_id = u.id and r.user_id = ?");
		$stmt->bind_param('d', $user_id);
		$stmt->execute();
		$stmt->bind_result($id, $creator, $title, $date, $sender_id, $sender_name);

		// Loop through the returned results and write to array
		$json = array();
		while ($row = $stmt->fetch())
		{
			$qwizzle = array();
			$qwizzle['id'] = $id;
			$qwizzle['creator'] = $creator;
			$qwizzle['title'] = $title;
			$qwizzle['date'] = $date;
			$qwizzle['sender_id'] = $sender_id;
			$qwizzle['sender_name'] = $sender_name;
			$json[]['request'] = $qwizzle;
		}

		// Wrap array of requests in a parent requests object so array can be easily retrieved
		$json_requests = array();
		$json_requests['requests'] = $json;

		$stmt->close();

		// Encode array in JSON
		$encoded_json = json_encode($json_requests);

		$this->sendResponse(200, $encoded_json);
	}

	/**
	* Service call for sending a qwizzle request to another user.
	* Input: JSON-formatted user id, sender id, and qwizzle id
	* Output: JSON-formatted status and request id
	*/
	function send_request()
	{
		// Retrieve the input JSON
		$json_array = json_decode(file_get_contents('php://input'));

		// Insert the request in the requests table
		$stmt = $this->db->prepare("INSERT INTO requests (user_id, sender_id, qwizzle_id) VALUES (?, ?, ?)");

		$sender_id = $json_array->{'sender_id'};
		$qwizzle_id = $json_array->{'qwizzle_id'};

		$user_id = $json_array->{'user_id'};
		$request_ids = array();
		foreach($user_id as $id)
		{
			$stmt->bind_param("ddd", $id->id, $sender_id, $qwizzle_id);
			$stmt->execute();
			$request_ids[] = $this->db->insert_id;
		}
		$stmt->close();

		// Format the return response with the request_id
		$json = array();
		$json['status'] = "successful";
		$json['request_ids'] = $request_ids;

		$json_response = json_encode($json);

		$this->sendResponse(200, $json_response);
	}


	/**
	* Service call for deleting a qwizzle request with a specified request id.
	* Input: a request id
	* Output: JSON-formatted status
	*/
	function delete_request()
	{
		// Retrieve the user id from the request URI
		$array = explode("/", trim($_SERVER['REQUEST_URI'], "/"));
		$request_id = $array[1];

		$stmt = $this->db->prepare("DELETE FROM requests where id=?");
		$stmt->bind_param("d", $request_id);
		$stmt->execute();
		$stmt->close();

		$json_response = "{\"status\":\"successful\"}";

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