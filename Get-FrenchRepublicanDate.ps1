<#
.Synopsis
	Returns a date and time converted to the French Republican Calendar.

.Parameter Date
	The Gregorian calendar date and time to convert.

.Parameter Method
	Which method to use to calculate leap years, of the competing choices.

.Inputs
	System.DateTime containing the Gregorian date and time to convert.

.Outputs
	System.Management.Automation.PSCustomObject containing a French Republican Calendar
	date and time in these properties:

	* Year: the numeric year
	* Annee: the Roman numeral year
	* AnneeUnicode: the Unicode Roman numeral year
	* Month: the numeric month
	* MonthName: the English month name
	* Mois: the French month name
	* Day: the numeric day of the month
	* DayOfYear: the numeric day of the year
	* Jour: the French name of the day of the year
	* DayName: the English name of the day of the year
	* Decade: the number of the 10-day "week" of the year
	* DayOfDecade: the numeric day of the 10-day "week"
	* DecadeOrdinal: the name of the day of the 10-day "week"
	* DecimalTime: the decimal time (10 hours/day, 100 minutes/hour, 100 seconds/minute)
	* GregorianDate: the original Gregorian date, as provided

.Link
	https://wikipedia.org/wiki/French_Republican_calendar

.Link
	https://wikipedia.org/wiki/Equinox

.Link
	https://www.timeanddate.com/calendar/seasons.html

.Link
	https://www.projectpluto.com/calendar.htm

.Link
	https://github.com/Bill-Gray/lunar/blob/master/date.cpp#L340

.Link
	http://rosettacode.org/wiki/French_Republican_calendar

.Link
	http://www.windhorst.org/calendar/

.Link
	Stop-ThrowError.ps1

.Example
	Get-FrenchRepublicanDate.ps1 2020-07-08

	Year          : 228
	Annee         : CCXXVIII
	AnneeUnicode  : ⅭⅭⅩⅩⅧ
	Month         : 10
	MonthName     : Harvest
	Mois          : Messidor
	Day           : 21
	DayOfYear     : 291
	Jour          : Menthe
	DayName       : Mint
	Decade        : 30
	DayOfDecade   : 1
	DecadeOrdinal : Primidi
	DecimalTime   : 0:00:00
	GregorianDate : 2020-07-08 00:00:00
#>

#Requires -Version 3
[CmdletBinding()] Param(
[Parameter(Position=0,ValueFromPipeline=$true)][datetime] $Date = (Get-Date),
[ValidateSet('Equinox','Romme','Continuous','128Year')][string] $Method = 'Romme'
)
Begin
{
	function Measure-LeapDays
	{
		[CmdletBinding()] Param(
		[Parameter(Position=0,Mandatory=$true)][int] $ToYear,
		[Parameter(Position=1,Mandatory=$true)][ScriptBlock] $Condition,
		[Parameter(Position=2)][int] $FromYear = 1
		)
		Write-Verbose "ToYear: $ToYear, Condition: { $Condition }, FromYear: $FromYear"
		if($FromYear -ge $ToYear) {return 0}
		else {return ($FromYear..($ToYear-1) |where $Condition |measure).Count}
	}
	${les mois} = 'Vendémiaire','Brumaire','Frimaire','Nivôse','Pluviôse','Ventôse',
		'Germinal','Floréal','Prairial','Messidor','Thermidor','Fructidor','Sansculottides'
	$months = 'Grape Harvest','Fog','Frost','Snowy','Rainy','Windy',
		'Germination','Flowering','Meadow','Harvest','Heat','Fruit','Complementary Days'
	${les jours du decade} = 'Primidi','Duodi','Tridi','Quartidi','Quintidi','Sextidi','Septidi','Octidi','Nonidi','Décadi'
	${les jours} =
		'Raisin','Safran','Châtaigne','Colchique','Cheval','Balsamine','Carotte','Amaranthe','Panais','Cuve',
		'Pomme de terre','Immortelle','Potiron','Réséda','Âne','Belle de nuit','Citrouille','Sarrasin','Tournesol','Pressoir',
		'Chanvre','Pêche','Navet','Amaryllis','Bœuf','Aubergine','Piment','Tomate','Orge','Tonneau',
		'Pomme','Céleri','Poire','Betterave','Oie','Héliotrope','Figue','Scorsonère','Alisier','Charrue',
		'Salsifis','Mâcre','Topinambour','Endive','Dindon','Chervis','Cresson','Dentelaire','Grenade','Herse',
		'Bacchante','Azerole','Garance','Orange','Faisan','Pistache','Macjonc','Coing','Cormier','Rouleau',
		'Raiponce','Turneps','Chicorée','Nèfle','Cochon','Mâche','Chou-fleur','Miel','Genièvre','Pioche',
		'Cire','Raifort','Cèdre','Sapin','Chevreuil','Ajonc','Cyprès','Lierre','Sabine','Hoyau',
		'Érable à sucre','Bruyère','Roseau','Oseille','Grillon','Pignon','Liège','Truffe','Olive','Pelle',
		'Tourbe','Houille','Bitume','Soufre','Chien','Lave','Terre végétale','Fumier','Salpêtre','Fléau',
		'Granit','Argile','Ardoise','Grès','Lapin','Silex','Marne','Pierre à chaux','Marbre','Van',
		'Pierre à plâtre','Sel','Fer','Cuivre','Chat','Étain','Plomb','Zinc','Mercure','Crible',
		'Lauréole','Mousse','Fragon','Perce-neige','Taureau','Laurier-thym','Amadouvier','Mézéréon','Peuplier','Coignée',
		'Ellébore','Brocoli','Laurier','Avelinier','Vache','Buis','Lichen','If','Pulmonaire','Serpette',
		'Thlaspi','Thimelé','Chiendent','Trainasse','Lièvre','Guède','Noisetier','Cyclamen','Chélidoine','Traîneau',
		'Tussilage','Cornouiller','Violier','Troène','Bouc','Asaret','Alaterne','Violette','Marceau','Bêche',
		'Narcisse','Orme','Fumeterre','Vélar','Chèvre','Épinard','Doronic','Mouron','Cerfeuil','Cordeau',
		'Mandragore','Persil','Cochléaria','Pâquerette','Thon','Pissenlit','Sylvie','Capillaire','Frêne','Plantoir',
		'Primevère','Platane','Asperge','Tulipe','Poule','Bette','Bouleau','Jonquille','Aulne','Couvoir',
		'Pervenche','Charme','Morille','Hêtre','Abeille','Laitue','Mélèze','Ciguë','Radis','Ruche',
		'Gainier','Romaine','Marronnier','Roquette','Pigeon','Lilas','Anémone','Pensée','Myrtille','Greffoir',
		'Rose','Chêne','Fougère','Aubépine','Rossignol','Ancolie','Muguet','Champignon','Hyacinthe','Râteau',
		'Rhubarbe','Sainfoin','Bâton d''or','Chamerisier','Ver à soie','Consoude','Pimprenelle','Corbeille d''or','Arroche','Sarcloir',
		'Statice','Fritillaire','Bourrache','Valériane','Carpe','Fusain','Civette','Buglosse','Sénevé','Houlette',
		'Luzerne','Hémérocalle','Trèfle','Angélique','Canard','Mélisse','Fromental','Martagon','Serpolet','Faux',
		'Fraise','Bétoine','Pois','Acacia','Caille','Œillet','Sureau','Pavot','Tilleul','Fourche',
		'Barbeau','Camomille','Chèvrefeuille','Caille-lait','Tanche','Jasmin','Verveine','Thym','Pivoine','Chariot',
		'Seigle','Avoine','Oignon','Véronique','Mulet','Romarin','Concombre','Échalote','Absinthe','Faucille',
		'Coriandre','Artichaut','Girofle','Lavande','Chamois','Tabac','Groseille','Gesse','Cerise','Parc',
		'Menthe','Cumin','Haricot','Orcanète','Pintade','Sauge','Ail','Vesce','Blé','Chalémie',
		'Épeautre','Bouillon blanc','Melon','Ivraie','Bélier','Prêle','Armoise','Carthame','Mûre','Arrosoir',
		'Panic','Salicorne','Abricot','Basilic','Brebis','Guimauve','Lin','Amande','Gentiane','Écluse',
		'Carline','Câprier','Lentille','Aunée','Loutre','Myrte','Colza','Lupin','Coton','Moulin',
		'Prune','Millet','Lycoperdon','Escourgeon','Saumon','Tubéreuse','Sucrion','Apocyn','Réglisse','Échelle',
		'Pastèque','Fenouil','Épine vinette','Noix','Truite','Citron','Cardère','Nerprun','Tagette','Hotte',
		'Églantier','Noisette','Houblon','Sorgho','Écrevisse','Bigarade','Verge d''or','Maïs','Marron','Panier',
		'La Fête de la Vertu','La Fête du Génie','La Fête du Travail','La Fête de l''Opinion','La Fête des Récompenses','La Fête de la Révolution'
	$days =
		'Grape','Saffron','Chestnut','Crocus','Horse','Impatiens','Carrot','Amaranth','Parsnip','Vat',
		'Potato','Strawflower','Winter squash','Mignonette','Donkey','Four o''clock flower','Pumpkin','Buckwheat','Sunflower','Wine-Press',
		'Hemp','Peach','Turnip','Amaryllis','Ox','Eggplant','Chili pepper','Tomato','Barley','Barrel',
		'Apple','Celery','Pear','Beetroot','Goose','Heliotrope','Common fig','Black Salsify','Chequer Tree','Plough',
		'Salsify','Water chestnut','Jerusalem artichoke','Endive','Turkey','Skirret','Watercress','Leadworts','Pomegranate','Harrow',
		'Baccharis','Azarole','Madder','Orange','Pheasant','Pistachio','Tuberous pea','Quince','Service tree','Roller',
		'Rampion','Turnip','Chicory','Medlar','Pig','Lamb''s lettuce','Cauliflower','Honey','Juniper','Pickaxe',
		'Wax','Horseradish','Cedar tree','Fir','Roe deer','Gorse','Cypress Tree','Ivy','Savin Juniper','Grub-hoe',
		'Sugar Maple','Heather','Reed plant','Sorrel','Cricket','Pine nut','Cork','Truffle','Olive','Shovel',
		'Peat','Coal','Bitumen','Sulphur','Dog','Lava','Topsoil','Manure','Saltpeter','Flail',
		'Granite','Clay','Slate','Sandstone','Rabbit','Flint','Marl','Limestone','Marble','Winnowing basket',
		'Gypsum','Salt','Iron','Copper','Cat','Tin','Lead','Zinc','Mercury','Sieve',
		'Spurge-laurel','Moss','Butcher''s Broom','Snowdrop','Bull','Laurustinus','Tinder polypore','Daphne mezereum','Poplar','Axe',
		'Hellebore','Broccoli','Bay laurel','Filbert','Cow','Box Tree','Lichen','Yew tree','Lungwort','Billhook',
		'Pennycress','Rose Daphne','Couch grass','Common Knotgrass','Hare','Woad','Hazel','Cyclamen','Celandine','Sleigh',
		'Coltsfoot','Dogwood','Matthiola','Privet','Billygoat','Wild Ginger','Italian Buckthorn','Violet','Goat Willow','Spade',
		'Narcissus','Elm','Common fumitory','Hedge mustard','Goat','Spinach','Doronicum','Pimpernel','Chervil','Twine',
		'Mandrake','Parsley','Scurvy-grass','Daisy','Tuna','Dandelion','Wood Anemone','Maidenhair fern','Ash tree','Dibber',
		'Primrose','Plane Tree','Asparagus','Tulip','Hen','Chard','Birch','Daffodil','Alder','Hatchery',
		'Periwinkle','Hornbeam','Morel','Beech Tree','Bee','Lettuce','Larch','Hemlock','Radish','Hive',
		'Judas tree','Romaine lettuce','Horse chestnut','Arugula or Rocket','Pigeon','Lilac','Anemone','Pansy','Bilberry','Grafting knife',
		'Rose','Oak Tree','Fern','Hawthorn','Nightingale','Common Columbine','Lily of the valley','Button mushroom','Hyacinth','Rake',
		'Rhubarb','Sainfoin','Wallflower','Fan Palm tree','Silkworm','Comfrey','Salad burnet','Basket of Gold','Orache','Garden hoe',
		'Thrift','Fritillary','Borage','Valerian','Carp','Spindle (shrub)','Chive','Bugloss','Wild mustard','Shepherd''s crook',
		'Alfalfa','Daylily','Clover','Angelica','Duck','Lemon balm','Oat grass','Martagon lily','Wild Thyme','Scythe',
		'Strawberry','Woundwort','Pea','Acacia','Quail','Carnation','Elderberry','Poppy plant','Linden or Lime tree','Pitchfork',
		'Cornflower','Camomile','Honeysuckle','Bedstraw','Tench','Jasmine','Verbena','Thyme','Peony','Hand Cart',
		'Rye','Oat','Onion','Speedwell','Mule','Rosemary','Cucumber','Shallot','Wormwood','Sickle',
		'Coriander','Artichoke','Clove','Lavender','Chamois','Tobacco','Redcurrant','Hairy Vetchling','Cherry','Park',
		'Mint','Cumin','Bean','Alkanet','Guinea fowl','Sage Plant','Garlic','Tare','Wheat','Shawm',
		'Spelt','Common mullein','Melon','Ryegrass','Ram','Horsetail','Mugwort','Safflower','Blackberry','Watering can',
		'Switchgrass','Common Glasswort','Apricot','Basil','Ewe','Marshmallow','Flax','Almond','Gentian','Lock',
		'Carline thistle','Caper','Lentil','Inula','Otter','Myrtle','Rapeseed','Lupin','Cotton','Mill',
		'Plum','Millet','Puffball','Six-row Barley','Salmon','Tuberose','Winter Barley','Apocynum','Liquorice','Ladder',
		'Watermelon','Fennel','Barberry','Walnut','Trout','Lemon','Teasel','Buckthorn','Mexican Marigold','Harvesting basket',
		'Wild Rose','Hazelnut','Hops','Sorghum','Crayfish','Bitter orange','Goldenrod','Maize or Corn','Sweet Chestnut','Pack Basket',
		'Celebration of Virtue','Celebration of Talent','Celebration of Labour','Celebration of Convictions','Celebration of Honors (Awards)','Celebration of the Revolution'
}
Process
{ # 1792-09-22 = 1 Vendémiaire Ⅰ
	if($Date -lt [datetime]'1792-09-22') {Stop-ThrowError.ps1 'Dates prior to September 22, 1792 are not yet supported.' -NotImplemented}
	[int] $lastleapt = if([datetime]::IsLeapYear($Date.Year) -and $Date.DayOfYear -gt 59) {$Date.Year} else {$Date.Year -1}
	[int] $gregleaps = Measure-LeapDays $lastleapt {[datetime]::IsLeapYear($_)} 1796
	[datetime] $d = $Date.AddDays(-265).AddYears(-1791)
	[ScriptBlock] $isLeapYear =
		switch($Method)
		{ #TODO: implement equinox
			128Year {{!($_ % 4) -and ($_ % 128)}}
			Continuous {{[datetime]::IsLeapYear($_+1)}}
			Equinox {Stop-ThrowError.ps1 'Equinox isn supported yet' -NotImplemented}
			Romme {{$_ -gt 0 -and [datetime]::IsLeapYear($_)}}
		}
	[int] $lastyearlength = if($isLeapYear.InvokeWithContext($null,[psvariable[]]@(New-Object psvariable '_',($d.Year-1)),$null)) {366} else {365}
	[int] $yearlength = if($isLeapYear.InvokeWithContext($null,[psvariable[]]@(New-Object psvariable '_',($d.Year)),$null)) {366} else {365}
	[int] $frcleaps = Measure-LeapDays ($d.Year-1) $isLeapYear
	[int] ${l'année} = $d.Year
	Write-Verbose "day of year $($d.DayOfYear) • year length $yearlength • FRC leaps $frcleaps • Gregorian leaps $gregleaps"
	[int] ${jour de l'année} = $d.DayOfYear + $frcleaps - $gregleaps
	if(${jour de l'année} -lt 1) {${l'année}--; ${jour de l'année} = $lastyearlength + ${jour de l'année}}
	elseif(${jour de l'année} -gt $yearlength) {${l'année}++; ${jour de l'année} -= $yearlength}
	[int] $mois = [math]::Floor((${jour de l'année}-1)/30)
	[pscustomobject]@{
		Year = ${l'année}
		Annee = ConvertTo-RomanNumeral.ps1 ${l'année}
		AnneeUnicode = ConvertTo-RomanNumeral.ps1 ${l'année} -Unicode
		Month = $mois +1
		MonthName = $months[$mois]
		Mois = ${les mois}[$mois]
		Day = 1 + ((${jour de l'année} -1) % 30)
		DayOfYear = ${jour de l'année}
		Jour = ${les jours}[${jour de l'année}-1]
		DayName = $days[${jour de l'année}-1]
		Decade = 1 + [math]::Floor((${jour de l'année} -1) / 10)
		DayOfDecade = 1 + ((${jour de l'année} -1) % 10)
		DecadeOrdinal = ${les jours du decade}[(${jour de l'année} -1) % 10]
		DecimalTime = '{0:0:00:00}' -f [math]::Floor($Date.TimeOfDay.Ticks / 8640000)
		GregorianDate = $Date
	}
}
