<?php

    require("Connect.php");
    require("MYSQLDao.php");
    header('Content-type:application/json;charset=utf-8');
    
    //variables for the values ther app will upload
    $firstName = $_POST["firstName"];
    $lastName = $_POST["lastName"];
    $username = $_POST["username"];
    $password = $_POST["password"];
    //ecrypt password with md5 before storing it
    $encrypted_password = password_hash($password, PASSWORD_BCRYPT);
    //new MySqlDao object
    $dao = new MySQLDao();
    $dao->openConnection();
    //get the userDetails
    $userDetails = $dao->getUserDetails($username);
    //creates an array to store what is happeneing
    $returnValue = array();
    $returnValue["status"] = "";
    $returnValue["message"] = "";
    
    //if it is empty than error
    if(empty($firstName) || empty($lastName) || empty($username) || empty($password))
    {
        $returnValue["status"] = "Error:";
        $returnValue["message"] = "Missing values all fields should be filled.";
    }
    //user already exists than error
    else if(!empty($userDetails))
    {
        $returnValue["status"] = "Error:";
        $returnValue["message"] = "User already exists.";
    }
    //if result isn't empty than successfull registration
    $result = $dao->registerUser($firstName, $lastName, $username, $encrypted_password);
    if($result)
    {
        $returnValue["status"] = "Success:";
        $returnValue["message"] = "You have been registered. Enjoy.";
    }
    //close connection
    $dao->closeConnection();
    echo json_encode($returnValue);
    
?>

