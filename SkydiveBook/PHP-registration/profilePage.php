<?php
    
    require("Connect.php");
    require("MYSQLDao.php");
    header('Content-type:application/json;charset=utf-8');
    
    //new MySqlDao object
    $dao = new MySQLDao();
    $dao->openConnection();
    
    //variables for the values
    $username = $_POST["username"];
    $returnValue["results"] = $dao->getProfileDetails($username);
    $returnValue["message"] = "";
    
    //if profileDetails is empty display error message
    if(empty($returnValue)) {
        $returnValue["status"] = "Error:";
        $returnValue["message"] = "We apologize something went wrong on our end.";
    }
    else {
        $returnValue["status"] = "Success:";
    }
    //close connection
    $dao->closeConnection();
    echo json_encode($returnValue);
    
    ?>



