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
	function Get-128YearLeapDays([int]$year)
	{
		[int] $remainder = 0
		[int] $pastdays = 31 * [math]::DivRem($year,128,[ref]$remainder) +
			[math]::Floor($remainder/4)
		[int] $yearlength = 365+[int](!($year % 4) -and ($year % 128))
		return $pastdays,$yearlength
	}
	function Get-ContinuousLeapDays([int]$year)
	{
		[int] $remainder = 0
		[int] $pastdays = (97 * [math]::DivRem($year+1,400,[ref]$remainder)) +
			(24 * [math]::DivRem($remainder,100,[ref]$remainder)) +
			[math]::Floor($remainder/4)
		[int] $yearlength = 365+[int]([datetime]::IsLeapYear($year+1))
		return $pastdays,$yearlength
	}
	function Get-RommeLeapDays([int]$year)
	{
		[int] $remainder = 0
		[int] $pastdays = (97 * [math]::DivRem($year,400,[ref]$remainder)) +
			(24 * [math]::DivRem($remainder,100,[ref]$remainder)) +
			[math]::Floor($remainder/4)
		[int] $yearlength = 365+[int]([datetime]::IsLeapYear($year))
		return $pastdays,$yearlength
	}
		$origin = [datetime]'1792-09-22'
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
	if($Date -lt $origin) {Stop-ThrowError.ps1 ('Dates prior to {0:MMMM d, yyyy} are not yet supported.' -f $origin) -NotImplemented}
	[int] ${jour de l'année}, [int] ${l'année} = ($Date.Date - $origin).TotalDays, 1
	if(${jour de l'année} -gt 364)
	{
		[int] $lastyear = [math]::DivRem(${jour de l'année},365,[ref]${jour de l'année})
		[int] ${past leap days}, [int] ${last year length} = switch($Method)
		{
			128Year {Get-128YearLeapDays $lastyear}
			Coninuous {Get-ContinuousLeapDays $lastyear}
			Equinox {Stop-ThrowError.ps1 'Equinox isn''t supported yet' -NotImplemented}
			Romme {Get-RommeLeapDays $lastyear}
		}
		${jour de l'année} -= ${past leap days}
		if(${jour de l'année} -gt -1) {${l'année} = $lastyear +1; ${jour de l'année}++}
		else {${l'année} = $lastyear; ${jour de l'année} += ${last year length} +1}
	}
	[int] ${jour du mois} = 1
	[int] $mois = 1+[math]::DivRem(${jour de l'année}-1,30,[ref]${jour du mois})
	${jour du mois}++
	${jour de decade} = 1
	$decade = 1+[math]::DivRem(${jour de l'année}-1,10,[ref]${jour de decade})
	${jour de decade}++
	[pscustomobject]@{
		Year = ${l'année}
		Annee = ConvertTo-RomanNumeral.ps1 ${l'année}
		AnneeUnicode = ConvertTo-RomanNumeral.ps1 ${l'année} -Unicode
		Month = $mois
		MonthName = $months[$mois]
		Mois = ${les mois}[$mois]
		Day = ${jour du mois}
		DayOfYear = ${jour de l'année}
		Jour = ${les jours}[${jour de l'année}-1]
		DayName = $days[${jour de l'année}-1]
		Decade = $decade
		DayOfDecade = ${jour de decade}
		DecadeOrdinal = ${les jours du decade}[${jour de decade}-1]
		DecimalTime = '{0:0:00:00}' -f [math]::Floor($Date.TimeOfDay.Ticks / 8640000)
		GregorianDate = $Date
	} |Add-Member ScriptMethod ToString -Force -PassThru `
		{"$($this.Jour) ($($this.DayName)), $($this.Day) $($this.Mois) ($($this.MonthName)) $($this.AnneeUnicode)"}
}
