<?php

/**
* Class that represents a Qwizzle object. The methods in this class
* perform database transactions relating to qwizzles.
*/
class Qwizzle
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
				$this->get_qwizzle(); break;
			case 'PUT':
				$this->create_qwizzle(); break;
			case 'POST':
				$this->take_qwizzle(); break;
			default: header('HTTP/1.1 405 Method Not Allowed');
            			break;
		}
	}

	/**
	* Gateway function for all GET qwizzle service calls. This function examines the
	* contents of the URL and directs the call to the corresponding method.
	*/
	function get_qwizzle()
	{
		$array = explode("/", trim($_SERVER['REQUEST_URI'], "/"));

		if ($array[1] == 'questions')
		{
			$this->get_qwizzle_questions($array[2]);
		}
		else if ($array[1] == 'answers')
		{
			$this->get_qwizzle_answers($array[2], $array[3]);
		}
		else if ($array[1] == 'taken')
		{
			$this->get_qwizzles_taken_by_user($array[2]);
		}
		else if (is_numeric($array[1]))
		{
			$this->get_qwizzles_by_user($array[1]);
		}
		else
		{
			header('HTTP/1.1 405 Method Not Allowed');
		}
	}

	/**
	* Service call for retrieving questions from a qwizzle id.
	* Input: a qwizzle id
	* Output: JSON-formatted list of qwizzle questions
	*/
	function get_qwizzle_questions($qwz_id)
	{
		// Get qwizzle questions with a qwizzle_id
		$stmt = $this->db->prepare("SELECT q_id, question FROM questions WHERE qwizzle_id=? ORDER BY q_id");
		$stmt->bind_param('d', $qwz_id);
		$stmt->execute();
		$stmt->bind_result($q_id, $question);

		// Loop through returned results and write to array
		$json = array();
		while ($row = $stmt->fetch())
		{
			$question_array = array();
			$question_array['id'] = $q_id;
			$question_array['text'] = $question;
			$json[]['question'] = $question_array;
		}

		$stmt->close();

		// Wrap array of questions in a parent questions object so array can be easily retrieved
		$json_questions = array();
		$json_questions['questions'] = $json;

		// Encode array in JSON
		$encoded_json = json_encode($json_questions);

		$this->sendResponse(200, $encoded_json);
	}

	/**
	* Service call for retrieving answers from a user id and qwizzle id.
	* Input: a user id and qwizzle id
	* Output: JSON-formatted list of qwizzle answers
	*/
	function get_qwizzle_answers($user_id, $qwz_id)
	{
		// Get qwizzle answers with a user_id and qwizzle_id
		$stmt = $this->db->prepare("select a.answer from answers a, qwizzle_answers q where a.answer_id=q.id and q.user_id=? and q.qwizzle_id=?");
		$stmt->bind_param('dd', $user_id, $qwz_id);
		$stmt->execute();
		$stmt->bind_result($answer);

		// Loop through returned results and write to array
		$json = array();
		while ($row = $stmt->fetch())
		{
			$json[]['answer'] = $answer;
		}

		$stmt->close();

		// Wrap array of answers in a parent answers object so array can be easily retrieved
		$json_answers = array();
		$json_answers['answers'] = $json;

		// Encode array in JSON
		$encoded_json = json_encode($json_answers);

		$this->sendResponse(200, $encoded_json);
	}

	/**
	* Service call for retrieving a list of qwizzles created by a specified user.
	* Input: a user id
	* Output: JSON-formatted list of qwizzles
	*/
	function get_qwizzles_by_user($user_id)
	{
		// Get qwizzles created by user
		$stmt = $this->db->prepare("SELECT id, creator, title, creation_date FROM qwizzles WHERE creator=?");
		$stmt->bind_param('d', $user_id);
		$stmt->execute();
		$stmt->bind_result($id, $creator, $title, $date);

		$json = array();

		// Loop through returned results and write to array
		while ($row = $stmt->fetch())
		{
			$qwizzle = array();
			$qwizzle['id'] = $id;
			$qwizzle['creator'] = $creator;
			$qwizzle['title'] = $title;
			$qwizzle['date'] = $date;
			$json[]['qwizzle'] = $qwizzle;
		}

		// Wrap array of qwizzles in a parent qwizzles object so array can be easily retrieved
		$json_qwizzles = array();
		$json_qwizzles['qwizzles'] = $json;

		$stmt->close();

		// Encode array in JSON
		$encoded_json = json_encode($json_qwizzles);

		$this->sendResponse(200, $encoded_json);
	}

	/**
	* Service call for retrieving qwizzles taken by a specified user.
	* Input: a user id
	* Output: JSON-formatted list of qwizzles
	*/
	function get_qwizzles_taken_by_user($user_id)
	{
		// Get qwizzles taken by user
		$stmt = $this->db->prepare("SELECT q.id, q.creator, q.title, q.creation_date, u.name FROM qwizzles q, users u where q.id in (SELECT qwizzle_id FROM qwizzle_answers where user_id=?) and q.creator=u.id");
		$stmt->bind_param('d', $user_id);
		$stmt->execute();
		$stmt->bind_result($id, $creator, $title, $date, $creator_name);

		$json = array();

		// Loop through returned results and write to array
		while ($row = $stmt->fetch())
		{
			$qwizzle = array();
			$qwizzle['id'] = $id;
			$qwizzle['creator'] = $creator;
			$qwizzle['creator_name'] = $creator_name;
			$qwizzle['title'] = $title;
			$qwizzle['date'] = $date;
			$json[]['qwizzle'] = $qwizzle;
		}

		// Wrap array of qwizzles in a parent qwizzles object so array can be easily retrieved
		$json_qwizzles = array();
		$json_qwizzles['qwizzles'] = $json;

		$stmt->close();

		// Encode array in JSON
		$encoded_json = json_encode($json_qwizzles);

		$this->sendResponse(200, $encoded_json);
	}

	/**
	* Service call for creating a qwizzle.
	* Input: JSON-formatted qwizzle with qwizzle questions
	* Output: JSON-formatted status and qwizzle id
	*/
	function create_qwizzle()
	{
		// Retrieve input JSON
		$json_array = json_decode(file_get_contents('php://input'));

		// Insert qwizzle
		$stmt = $this->db->prepare("INSERT INTO qwizzles (creator, title) VALUES (?, ?)");
		$creator = $json_array->{'creator'};
		$title = $json_array->{'title'};
		$stmt->bind_param('ss', $creator, $title);
		$stmt->execute();
		$qwz_id = $this->db->insert_id;
		$stmt->close();

		// Insert qwizzle questions
		$questions = $json_array->{'questions'};
		foreach ($questions as $value)
		{
			$stmt = $this->db->prepare("INSERT INTO questions (question, qwizzle_id) VALUES (?, ?)");
			$question = $value->question;
			$rs = $stmt->bind_param('sd', $question, $qwz_id);
			$stmt->execute();
			$stmt->close();
		}

		// Format return response
		$json_response = "{\"status\":\"successful\",\"qwizzle_id\":".$qwz_id."}";

		$this->sendResponse(200, $json_response);
	}

	/**
	* Service call for taking a qwizzle.
	* Input: JSON-formatted list of answers, with user id and qwizzle id
	* Output: JSON-formatted status
	*/
	function take_qwizzle()
	{
		// Retrieve input JSON
		$json_array = json_decode(file_get_contents('php://input'));

		// Insert parent qwizzle_answer
		$stmt = $this->db->prepare("INSERT INTO qwizzle_answers (user_id, qwizzle_id) VALUES (?, ?)");
		$user_id = $json_array->{'user_id'};
		$qwizzle_id = $json_array->{'qwizzle_id'};
		$stmt->bind_param('dd', $user_id, $qwizzle_id);
		$stmt->execute();
		$ans_id = $this->db->insert_id;
		$stmt->close();

		// Insert qwizzle answers
		$answers = $json_array->{'answers'};
		foreach ($answers as $value)
		{
			$stmt = $this->db->prepare("INSERT INTO answers (answer, q_id, answer_id) VALUES (?, ?, ?)");
			$answer = $value->answer;
			$question_id = $value->question_id;
			$rs = $stmt->bind_param('sdd', $answer, $question_id, $ans_id);
			$stmt->execute();
			$stmt->close();
		}

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