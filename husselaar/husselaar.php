<html>
<head>
<title>Husselaar</title>
</head>
<body>
<?php
// Retrieve text
$tekst = isset($_POST['tekst']) ? $_POST['tekst'] : "";
// Remove HTML stuff, this script only supports plain text.
$tekst = strip_tags($tekst);
if($tekst == ""){
	?>
Vaak zijn zinnen nog goed leesbaar als van alle woorden alleen de eerste en laatste letter blijven staan en de rest van de letters door elkaar gehusseld wordt. Probeer hieronder!
<form method='post' action='husselaar.php'>
<textarea cols='100' rows='30' name='tekst'></textarea><br>
<input type='submit' value='Hussel!'>
</form>
<?php
} else {
	$woorden = explode(" ", $tekst);
	$nieuwetekst = "";
	for($i = 0; $i < count($woorden); $i++){
		$lengte = strlen($woorden[$i]);
		$husselgrootte = $lengte - 2;
		$middengedeelte = substr($woorden[$i], 1, $husselgrootte);
		$nieuwwoord = array(substr($woorden[$i], 0, 1));
		//echo $middengedeelte;
		for($j = 0; $j < $husselgrootte; $j++){
			$midlengte = strlen($middengedeelte);
			$positie = rand(0, $midlengte-1);
			$nieuwwoord[$j+1] = substr($middengedeelte, $positie, 1);
			//Debug-code:
			//echo "Oud middengedeelte: $middengedeelte<br>";
			//echo substr($middengedeelte, $positie, 1); //debug
			//echo "Eerste helft: ".substr($middengedeelte, 0, $positie)."<br>";
			//echo "Tweede helft: ".substr($middengedeelte, $positie + 1, $midlengte-1)."<br><br>";
			$middengedeelte =
				substr($middengedeelte, 0, $positie).
				substr($middengedeelte, $positie + 1, $midlengte - $positie + 1);
		}
		if($lengte != 1){
			$nieuwwoord[$lengte] = substr($woorden[$i], $lengte - 1, 1);
		}
		$nieuwetekst .= implode($nieuwwoord)." ";
	}
	echo $nieuwetekst;
}
?>
</body>
</html>
