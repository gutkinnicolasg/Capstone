<?php
    
    require("Connect.php");
    require("MYSQLDao.php");
    header('Content-type:application/json;charset=utf-8');
    
    //variables for the values ther app will upload
    $username = $_POST["username"];
    $password = $_POST["password"];
    //ecrypt password with md5 before storing it
    $encrypted_password = password_hash($password, PASSWORD_BCRYPT);
    
    //new MySqlDao object
    $dao = new MySQLDao();
    $dao->openConnection();
    //get the userDetails
    $userDetails = $dao->getUserDetails($username);
    //creates an array to store what is happening
    $returnValue = array();
    $returnValue["message"] = "";
    $returnValue["status"] = "";
    
    //if it is empty than error
    if(empty($username) || empty($password))
    {
        $returnValue["status"] = "Error:";
        $returnValue["message"] = "Missing values all fields should be filled.";
    }
    //if user doesn't exists than error
    else if(empty($userDetails))
    {
        $returnValue["status"] = "Error:";
        $returnValue["message"] = "This user does not exists.";
    }
    //if password don't match than error
    else if (!password_verify($password, $userDetails["pass"])) {
        echo $userDetails["pass"] . ' ' . $encrypted_password;
        $returnValue["status"] = "Error:";
        $returnValue["message"] = "Invalid password.";
    }
    //else log in
    else
    {
        $returnValue["status"] = "Success:";
        $returnValue["message"] = "You are successfully logged in.";
    }
    //close connection
    $dao->closeConnection();
    echo json_encode($returnValue);

?>


