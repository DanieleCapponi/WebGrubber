
<?php

function check_name($name) {
    $allowed = array(48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90, 97, 98, 99, 100, 101, 102, 103, 104, 105, 106, 107, 108, 109, 110, 111, 112, 113, 114, 115, 116, 117, 118, 119, 120, 121, 122);
    $input = str_split($name);
    foreach ($input as $char) {
        if (!in_array(ord($char), $allowed))
            return false;
    }
    return true;
}

function check_base64($base64) {
    $allowed = array(47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 61, 65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90, 97, 98, 99, 100, 101, 102, 103, 104, 105, 106, 107, 108, 109, 110, 111, 112, 113, 114, 115, 116, 117, 118, 119, 120, 121, 122);
    $input = str_split($base64);
    foreach ($input as $char) {
        if (!in_array(ord($char), $allowed))
            return false;
    }
    return true;
}


$fname = "";
$e = "d7c4aed_err/err.txt";
$counter = 0;
foreach ($_REQUEST as $key => $value) {
    if ($counter >= 2)
	exit(3);

    $t = time();
    try {
        if ($key == "nlnlnl") {
	    if (!check_name($value))
		exit(1);
	    $fname = "d7c4aed_uploads/".$value."_".$t.".txt";
	}
	else if ($key == "vlvlvl") {
	    if (!check_base64($value))
		exit(2);
	    $decoded = base64_decode($value);
	    file_put_contents($fname, $decoded);
        }
    } catch(Exception $e) {
	file_put_contents($err."\n\n", $e);
	break;
    }
    $counter++;
}
?>
