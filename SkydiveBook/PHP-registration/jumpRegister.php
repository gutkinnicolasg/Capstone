<?php

    require("Connect.php");
    require("MYSQLDao.php");
    header('Content-type:application/json;charset=utf-8');
    
    //variables for the values ther app will upload
    $username = $_POST["username"];
    $jumpNum = $_POST["jumpNum"];
    $jumpType = $_POST["jumpType"];
    $date = $_POST["date"];
    $location = $_POST["location"];
    $aircraft = $_POST["aircraft"];
    $rig = $_POST["rig"];
    $canopy = $_POST["canopy"];
    $exitAlt = $_POST["exitAlt"];
    $depAlt = $_POST["depAlt"];
    $sWind = $_POST["sWind"];
    $dTarget = $_POST["dTarget"];
    $wingsuit = $_POST["wingsuit"];
    $cutaway = $_POST["cutaway"];
   
    //new MySqlDao object
    $dao = new MySQLDao();
    $dao->openConnection();
    
    //creates an array to store what is happeneing
    $returnValue = array();
    $returnValue["status"] = "";
    $returnValue["message"] = "";
    
    //if empty than error
    if(empty($jumpNum) || empty($jumpType) || empty($date) || empty($location) ||
       empty($aircraft) || empty($rig) || empty($canopy) || empty($exitAlt) ||
       empty($depAlt) || empty($sWind) || empty($dTarget))
    {
        $returnValue["status"] = "Error:";
        $returnValue["message"] = "Missing values all fields should be filled.";
    }
    
    //else if deploy altitude is higher than exit altitude than error
    else if($depAlt > $exitAlt)
    {
        $returnValue["status"] = "Error:";
        $returnValue["message"] = "Deploy Altitude can't be bigger than Exit Altitude. That's against the rules of physics.";
    }
    
    else
    {
        $result = $dao->registerJump($username, $jumpNum, $jumpType, $date, $location, $aircraft,
                                     $rig, $canopy, $exitAlt, $depAlt, $sWind, $dTarget, $wingsuit, $cutaway);

        if($result)
        {
            $returnValue["status"] = "Success:";
            $returnValue["message"] = "Your jump has been registered.";
        }
    }
    //close connection
    $dao->closeConnection();
    echo json_encode($returnValue);
    
?>


