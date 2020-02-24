<?php

    class MySQLDao {
    //PHP file that contains all the queries
        var $dbhost = null;
        var $dbuser = null;
        var $dbpass = null;
        var $conn = null;
        var $dbname = null;
        var $result = null;
        
        //constructor initiliazes
        function __construct() {
            $this->dbhost = Connection::$dbhost;
            $this->dbuser = Connection::$dbuser;
            $this->dbpass = Connection::$dbpass;
            $this->dbname = Connection::$dbname;
        }
        //opens a connection with that database
        public function openConnection() {
            $this->conn = new mysqli($this->dbhost, $this->dbuser, $this->dbpass, $this->dbname);
            //if a connection error occurs print out error message
            if(mysqli_connect_errno()) {
                echo ("Error! Could not establish connection with database");
            }
        }
        //getter method for connection
        public function getConnection() {
            return $this->conn;
        }
        //method to close connection
        public function closeConnection() {
            if($this->conn != null) {
                $this->conn->close();
            }
        }
        //returns all of the users row information from the 'users' Table in the database
        //that match the username
        //-used for the registration to check if user already exists
        public function getUserDetails($username) {
            $returnValue = array();
            $sql = "SELECT * FROM users WHERE username = '".$username."'";
            $result = $this->conn->query($sql);
            
            if($result != null && (mysqli_num_rows($result) >= 1)) {
                $row = $result->fetch_array(MYSQLI_ASSOC);
                if(!empty($row)) {
                    $returnValue = $row;
                }
            }
            return $returnValue;
        }

        //creates a new row in the 'user' Table and adds the information
        public function registerUser($firstName, $lastName, $username, $password) {
            $sql = "INSERT INTO `users` (`username`, `pass`, `fname`, `lname`) VALUES ('$username', '$password', '$firstName', '$lastName')";
            $result = $this->conn->query($sql);
            return $result;
        }
        
        //creates a new row in the 'jumpLog' Table and adds the information
        public function registerJump($username, $jumpNum, $jumpType, $date, $location, $aircraft,
                                     $rig, $canopy, $exitAlt, $depAlt, $sWind, $dTarget, $wingsuit, $cutaway) {
            $sql = "INSERT INTO `jumpLog` (`username`, `jumpNum`, `jumpType`, `date`, `location`, `aircraft`, `rig`, `canopy`, `exitAlt`, `depAlt`, `sWind`, `dTarget`, `wingsuit`, `cutaway`) VALUES ('$username', '$jumpNum', '$jumpType', '$date', '$location', '$aircraft', '$rig', '$canopy', '$exitAlt', '$depAlt', '$sWind', '$dTarget', '$wingsuit', '$cutaway')";
            $result = $this->conn->query($sql);
            return $result;
        }

        //creates the information to be displayed by the profile
        //Under Construction
        public function getProfileDetails($username) {
            $returnValue = array();
            $returnValue["name"] = $this->getFullName($username);
            $returnValue["tJumps"] = $this->getTotalJumps($username);
            $returnValue["tSport"] = $this->getTotalSportJumps($username);
            $returnValue["tBase"] = $this->getTotalBaseJumps($username);
            $returnValue["tTandem"] = $this->getTotalTandemJumps($username);
            $returnValue["tStudent"] = $this->getTotalStudentJumps($username);
            $returnValue["tCutaway"] = $this->getTotalCutaway($username);
            $returnValue["tWingsuit"] = $this->getTotalWingsuit($username);
            $returnValue["tFFD"] = $this->getTotalFFD($username);
            $returnValue["tFFT"] = $this->getTotalFFT($username);
            return $returnValue;
        }
        //getsFullName
        public function getFullName($username) {
            $sql = "SELECT fname, lname FROM users WHERE username = '".$username."'";
            $result = $this->conn->query($sql);
            $returnValue = mysqli_fetch_array($result);
            return $returnValue[0] . " " . $returnValue[1];
        }
        //gets Total Jumps
        public function getTotalJumps($username) {
            $sql = "SELECT MAX(jumpNum) FROM jumpLog WHERE username = '".$username."'";
            $result = $this->conn->query($sql);
            $returnValue = mysqli_fetch_array($result);
            return $returnValue[0];
        }
        //gets Total Sport Jumps
        public function getTotalSportJumps($username) {
            $sql = "SELECT * FROM jumpLog WHERE jumpType = 'Sport' AND username = '".$username."'";
            $result = $this->conn->query($sql);
            $returnValue = mysqli_num_rows($result);
            return $returnValue;
        }
        //gets Total B.A.S.E Jumps
        public function getTotalBaseJumps($username) {
            $sql = "SELECT * FROM jumpLog WHERE jumpType = 'B.A.S.E' AND username = '".$username."'";
            $result = $this->conn->query($sql);
            $returnValue = mysqli_num_rows($result);
            return $returnValue;
        }
        //gets Total Tandem Jumps
        public function getTotalTandemJumps($username) {
            $sql = "SELECT * FROM jumpLog WHERE jumpType = 'Tandem' AND username = '".$username."'";
            $result = $this->conn->query($sql);
            $returnValue = mysqli_num_rows($result);
            return $returnValue;
        }
        //gets Total Student Jumps
        public function getTotalStudentJumps($username) {
            $sql = "SELECT * FROM jumpLog WHERE jumpType = 'Student' AND username = '".$username."'";
            $result = $this->conn->query($sql);
            $returnValue = mysqli_num_rows($result);
            return $returnValue;
        }
        //gets Total Cutaways
        public function getTotalCutaway($username) {
            $sql = "SELECT * FROM jumpLog WHERE cutaway = 'true' AND username = '".$username."'";
            $result = $this->conn->query($sql);
            $returnValue = mysqli_num_rows($result);
            return $returnValue;
        }
        //gets Total Wingsuit
        public function getTotalWingsuit($username) {
            $sql = "SELECT * FROM jumpLog WHERE wingsuit = 'true' AND username = '".$username."'";
            $result = $this->conn->query($sql);
            $returnValue = mysqli_num_rows($result);
            return $returnValue;
        }
        //gets Total Free Fall Distance
        public function getTotalFFD($username) {
            $sql1 = "SELECT SUM(exitAlt) FROM jumpLog WHERE username = '".$username."'";
            $sql2 = "SELECT SUM(depAlt) FROM jumpLog WHERE username = '".$username."'";
            $result1 = $this->conn->query($sql1);
            $result2 = $this->conn->query($sql2);
            $value1 = mysqli_fetch_array($result1);
            $value2 = mysqli_fetch_array($result2);
            $returnValue = $value1[0] - $value2[0];
            return $returnValue;
            
        }
        //get Total Free Fall Time
        // 12 sec for the first 1000 feet then 6 sec for every 1000 feet after
        public function getTotalFFT($username) {
            $FFD = $this->getTotalFFD($username);
            $totalRJ = $this->getTotalRJ($username);
            //handles the first 1000 feet
            $fTime = $totalRJ * 12;
            $newFFD = $FFD - ($totalRJ * 1000);
            //handles the remaining 1000 feet
            $result = $fTime + (($newFFD / 1000) * 6);
            return $result;
        }
        //get Total Registered Jumps
        public function getTotalRJ($username) {
            $sql = "SELECT COUNT(jumpNum) FROM jumpLog WHERE username = '".$username."'";
            $result = $this->conn->query($sql);
            $returnValue = mysqli_num_rows($result);
            return $returnValue;
        }
        //returns jump info
        public function getJumpList($username) {
            $returnValue = array();
            $sql = "SELECT * FROM jumpLog WHERE username = '".$username."'";
            $result = $this->conn->query($sql);
            $returnValue = mysqli_fetch_all($result, MYSQLI_ASSOC);
            return $returnValue;
        }
        
        
    }

?>


