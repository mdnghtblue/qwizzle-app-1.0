<?php

if ($_POST['submit'])
{
	$db = new mysqli('localhost', '******', '******', '******');
	$db->autocommit(TRUE);

	$stmt = $db->prepare("INSERT INTO users (name, email, password) VALUES (?, ?, ?)");
	$stmt->bind_param("sss", $_POST['name'], $_POST['email'], $_POST['password']);
	$stmt->execute();
	$stmt->close();

	$db->close();

echo "submitted!";

}


?>

<form method="post" action="create_account.php">

Name: <input type="text" name="name" /><br/>
Email Address: <input type="text" name="email"/><br/>
Password: <input type="password" name="password"/><br/>
<input type="submit" name="submit" value="Submit"/>

</form>


<?


?>

