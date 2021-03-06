package;

import buildings.Building;

// class that store informations of the game in statics var so that it can be acces anywhere
class GameInfo
{
 	public static var ressources:Map<String,Dynamic> = [
 		'poudre0' => {
 			name: 'PLPP Yellow', //plpp stands for perlimpinpin
 			previewImg: 'PopInMarketArticlePreviewYellowMineral.png',
 			iconImg: 'IconYellowMineral.png',
 			userPossesion: 15000,
 			buyCost: 10,
 			sellCost: 5,
 			lastQuantityBuy: 0,
 			lastQuantitySell: 0
 		},
 		'poudre1' => {
 			name: 'PLPP Green',
 			previewImg: 'PopInMarketArticlePreviewGreenMineral.png',
 			iconImg: 'IconGreenMineral.png',
 			userPossesion: 15000,
 			buyCost: 25,
 			sellCost: 10,
 			lastQuantityBuy: 0,
 			lastQuantitySell: 0
 		},
 		'poudre2' => {
 			name: 'PLPP Cyan',
 			previewImg: 'PopInMarketArticlePreviewCyanMineral.png',
 			iconImg: 'IconCyanMineral.png',
 			userPossesion: 15000,
 			buyCost: 50,
 			sellCost: 25,
 			lastQuantityBuy: 0,
 			lastQuantitySell: 0
 		},
 		'poudre3' => { 
 			name: 'PLPP Blue',
 			previewImg: 'PopInMarketArticlePreviewBlueMineral.png',
 			iconImg: 'IconBlueMineral.png',
 			userPossesion: 15000,
 			buyCost: 100,
 			sellCost: 40,
 			lastQuantityBuy: 0,
 			lastQuantitySell: 0
 		}, 		
 		'poudre4' => {
 			name: 'PLPP Purple',
 			previewImg: 'PopInMarketArticlePreviewPurpleMineral.png',
 			iconImg: 'IconPurpleMineral.png',
 			userPossesion: 15000,
 			buyCost: 300,
 			sellCost: 200,
 			lastQuantityBuy: 0,
 			lastQuantitySell: 0
 		},
 		'poudre5' => {
 			name: 'PLPP Red',
 			previewImg: 'PopInMarketArticlePreviewRedMineral.png',
 			iconImg: 'IconRedMineral.png',
 			userPossesion: 15000,
 			buyCost: 1000,
 			sellCost: 700,
 			lastQuantityBuy: 0,
 			lastQuantitySell: 0
 		},
 		'fric' => {
 			name: 'Dogeflooz',
 			previewImg: 'PopInShopArticlePreview2Dogeflooz.png',
 			iconImg: 'IconDogeflooz.png',
 			userPossesion: 5000,
 		},
 		'hardMoney' => {
 			name: "Os D'or",
 			previewImg: 'PopInShopArticlePreview2Os.png',
 			iconImg: 'IconOsDor.png',
 			userPossesion: 15000,
 		},
 		'doges' => {
 			name: "Doges",
 			previewImg: 'PopInShopArticlePreview2Os.png',
 			iconImg: 'IconDoge.png',
 			userPossesion: 15,
 		}
 	];
 	public static var questsArticles:Map<String, Array<Dynamic>> = [
 		'current'=> [
 			{
 				dog: 'Niche',
 				dogX: -0.55,
 				dogY: 0.16,
 				title: 'Première niche',
 				description: "Pas de niches, pas d'employés.Pas d'employés, pas\nde fusées.Pas de fusées... pas de fusées.\nOuvrez-donc le menu de construction.\nPuis achetez et construisez une niche !",
 				condition: {"building":Building.NICHE | Building.LVL_1, "numberToHave" : 1 },
 				rewards: [
 					{"name":"fric","quantity":"100"},
 					{"name":"poudre0","quantity":"10"},
 				],
 				bdd_id: "1"
 			},
 			{
 				dog: 'Workshop',
 				dogX: -0.55,
 				dogY: 0.16,
 				title: 'Premier atelier',
 				description: "Les ateliers servent à construire les fusées.\nPour l'instant vos pauvres employés s'ennuient à mourir.\nSoyez gentil et donnez leur du travail !\nPour rappel, les bâtiments peuvent être\nachetés depuis le menu de construction",
 				condition: {"building":Building.HANGAR_JAUNE | Building.LVL_1, "numberToHave" : 0 },
 				rewards: [
 					{"name":"fric","quantity":"1000"},
 					{"name":"poudre0","quantity":"100"},
 				],
 				bdd_id: "4"
 			},
 			{
 				dog: 'Workshop',
 				dogX: -0.55,
 				dogY: 0.16,
 				title: "Première fusée",
 				description: "Construire votre première fusée est maintenant possible !\nCliquez sur votre atelier et commencez la\n construction de la fusée. N'oubliez pas de fouet..\n*hum* motiver vos employés en cliquant sur\n l’icône dans l'atelier",
 				condition: {"rocketsConstructedNb":1},
 				rewards: [
 					{"name":"fric","quantity":"2000"},
 					{"name":"poudre0","quantity":"200"},
 				],
 				bdd_id: "5"
 			},
 			{
 				dog: 'Astro',
 				dogX: -0.8,
 				dogY: 0.16,
 				title: "La conquête de l'espace !",
 				description: "Votre première fusée est prête à partir !\nVous n'avez plus qu'a appuyer sur le gros\nbouton vert pour la lancer. Ça ne devrait pas être\ntrop compliqué non ?",
 				condition: {"rocketsLaunchedNb": 1 },
 				rewards: [
 					{"name":"fric","quantity":"3000"},
 					{"name":"poudre0","quantity":"300"},
 				],
 				bdd_id: "6"
 			},
 			{
 				dog: 'Casino',
 				dogX: -0.95,
 				dogY: 0.16,
 				title: "Black jack and...",
 				condition: {"building":Building.CASINO | Building.LVL_1, "numberToHave" : 1 },
 				description: "Vos employés veulent se détendre, vous voulez\n vous remplir les poches.\nUn casino semble le parfait compromis",
 				rewards: [
 					{"name":"fric","quantity":"4000"},
 				],
 				bdd_id: "7"
 			},
 			{
 				dogX: -0.55,
 				dogY: 0.16,
 				dog: 'Musee',
 				title: "La culture ça rapporte",
 				condition: {"building":Building.MUSEE | Building.LVL_1, "numberToHave" : 1 },
 				description: "Les artefacts que vous trouvez sur les planètes\nsont incroyablement rares Et comme ce qui est\nrare est cher, les billets ne sont pas donnés. Entre la\nboutique de souvenirs et les entrées, vous allez\nencaisser sec !",
 				rewards: [
 					{"name":"fric","quantity":"4000"},
 				],
 				bdd_id: "8"
 			}
 		],
 		'finished' => [

 		]
 	];
 	public static var shopArticles:Map<String,Map<String,Dynamic>> = [
 		'soft' => [
	 		'Dogeflooz1' => {
	 			name: 'Dogeflooz x5000',
	 			previewImg: 'PopInShopArticlePreview2Dogeflooz.png',
	 			text: "Besoin d'un petit coup de boost ?\nUn peu juste pour le loyer ce mois ci ?\nLe pack NoobDoge est fait pour vous !",
	 			price: 01
	 		},
	 		'Dogeflooz2' => {
	 			name: 'Dogeflooz2 x50 000',
	 			previewImg: 'PopInShopArticlePreview3Dogeflooz.png',
	 			text: "Il y a des choses qui ne s'achètent pas\nPour tout le reste, il y a le Dogeflooz",
	 			price: 05,
	 		},
	 		'Dogeflooz3' => {
	 			name: 'Dogeflooz2 x500 000',
	 			previewImg: 'PopInShopArticlePreview4Dogeflooz.png',
	 			text: "Une banque qui appartient a son\nDogeFlooz ça change tout",
	 			price: 25,
	 		}, 		
	 		'Dogeflooz4' => {
	 			name: 'Dogeflooz2 x5 000 000',
	 			previewImg: 'PopInShopArticlePreview5Dogeflooz.png',
	 			text: "En panne de slogans connus,\nrevenez plus tard",
	 			price: 99,
	 		}
 		],
 		'hard' => [
	 		"Os1" => {
	 			name: "Os d'or",
	 			previewImg: 'PopInShopArticlePreview2Os.png',
	 			text: "Tout ce qui brille n'est pas de l'or\nMais ces os le sont bien",
	 			price: 1,
	 		}, 		
	 		"Os2" => {
	 			name: "Os d'or x50",
	 			previewImg: 'PopInShopArticlePreview3Os.png',
	 			text: "Avec tout cet or, vous allez conquérir\nle monde, que dis-je l'espace !",
	 			price: 5,
	 		}, 		
	 		"Os3" => {
	 			name: "Os d'or x500",
	 			previewImg: 'PopInShopArticlePreview4Os.png',
	 			text: "Aucune description ne pourra définir\nprécisément la qualité de ce pack",
	 			price: 25,
	 		}, 		
	 		"Os4" => {
	 			name: "Os d'or x5000",
	 			previewImg: 'PopInShopArticlePreview5Os.png',
	 			text: "Ce pack ce passe d'une description\ncar il se suffit à lui même",
	 			price: 99,
	 		},
 		]
 	];
 	public static var buildMenuArticles:Dynamic = {
 		"niches": [
 			{
 				isAvailable : true,
 				isOneshot : false,
 				buildingID: Building.NICHE,
 				previewImg: 'PopInBuiltArticlePreviewNiche.png',
 				title: 'Niche en Bois',
 				description: "L'association des travailleurs canins (l'ATC) impose un logement de fonction.\nDonc pour faire court niches = employés.",
 				hardPrice: 3,
 				ressources: [
 					{"name":"fric","quantity":500},
 				]
 			},
 		],
 		"spacechips": [
 			{

 				isAvailable : true,
 				isOneshot : false,
 				buildingID: Building.HANGAR_JAUNE,
 				previewImg: 'PopInBuiltArticlePreviewHangar1.png',
 				title: 'Atelier Destination SprungField',
 				description: 'Boite magique où les fusées sont assemblées avec amour et bonne humeur.\nToute les rumeur au sujet des coups de fouet électrique ne sont que calomnies.',
 				hardPrice: 3,
 				ressources: [
 					{"name":"fric","quantity":1000},
 					{"name":"poudre0","quantity":50},
 				]
 			},
 			{
 				isAvailable : true,
 				isOneshot : false,
 				buildingID: Building.HANGAR_VERT,
 				previewImg: 'PopInBuiltArticlePreviewHangar2.png',
 				title: 'Atelier Destination Modor',
 				description: "Cet atelier construit des fusées grâce au pouvoir de l’amitié et à des techniques\n de management éprouvés.",
 				hardPrice: 3,
 				ressources: [
 					{"name":"fric","quantity":5000},
 					{"name":"poudre0","quantity":100},
 					{"name":"poudre1","quantity":50},
 				]
 			},
 			{
 				isAvailable : true,
 				isOneshot : false,
 				buildingID: Building.HANGAR_CYAN,
 				previewImg: 'PopInBuiltArticlePreviewHangar3.png',
 				title: 'Atelier Destination Namok',
 				description: "Dans cet atelier les employés sont les plus heureux au monde.\nLes semaines de 169 heures ne sont bien sur qu'un mythe.",
 				hardPrice: 3,
 				ressources: [
 					{"name":"fric","quantity":10000},
 					{"name":"poudre0","quantity":500},
 					{"name":"poudre1","quantity":250},
 					{"name":"poudre2","quantity":50},
 				]
 			}, 			
 			{
 				isAvailable : true,
 				isOneshot : false,
 				buildingID: Building.HANGAR_BLEU,
 				previewImg: 'PopInBuiltArticlePreviewHangar4.png',
 				title: 'Atelier Destination Terre',
 				description: "Dans cet atelier, aucun incident n'a jamais été rapporté à la direction\net ce n'est absolument pas par crainte de représailles.",
 				hardPrice: 3,
 				ressources: [
 					{"name":"fric","quantity":20000},
 					{"name":"poudre1","quantity":1500},
 					{"name":"poudre2","quantity":250},
 				]
 			},
 			{
 				isAvailable : true,
 				isOneshot : false,
 				buildingID: Building.HANGAR_VIOLET,
 				previewImg: 'PopInBuiltArticlePreviewHangar5.png',
 				title: 'Atelier Destination Wundërland',
 				description: "Les soupçons des conséquences mortelles liés à la manipulation\n des moteurs à Dogetonium ont été réfutés par le professeur Van-Du.",
 				hardPrice: 3,
 				ressources: [
 					{"name":"fric","quantity":50000},
 					{"name":"poudre0","quantity":10000},
 					{"name":"poudre3","quantity":250},
 				]
 			},
 			{
 				isAvailable : true,
 				isOneshot : false,
 				buildingID: Building.HANGAR_ROUGE,
 				previewImg: 'PopInBuiltArticlePreviewHangar6.png',
 				title: 'Atelier Destination StarWat',
 				description: "Cet atelier utilise uniquement des huiles écologiques.\nQui ne sont en aucun cas faites a partir de travailleurs retraités.",
 				hardPrice: 3,
 				ressources: [
 					{"name":"fric","quantity":75000},
 					{"name":"poudre0","quantity":2500},
 					{"name":"poudre1","quantity":1750},
 					{"name":"poudre2","quantity":1000},
 					{"name":"poudre3","quantity":250},
 					{"name":"poudre4","quantity":250},
 				]
 			},
 		],
 		"utilitaires": [
 			{
 				isAvailable : true,
 				isOneshot : true,
 				buildingID: Building.CASINO,
 				previewImg: 'PopInBuiltArticlePreviewCasino.png',
 				title: 'Casino',
 				description: "Un établissement haut de gamme qui ne propose que des jeux honnêtes\npermettant à nos fiers travailleurs de se détendre.",
 				hardPrice: 3,
 				ressources: [
 					{"name":"fric","quantity":10000},
 				]
 			},
 			{
				isAvailable : true,
				isOneshot : true,
				buildingID: Building.EGLISE,
 				previewImg: 'PopInBuiltArticlePreviewEglise.png',
 				title: 'Église',
 				description: "Une modeste chapelle où nos employés implorent le grand manitou\nde nous accorder des finances prospères.",
 				hardPrice: 3,
 				ressources: [
 					{"name":"fric","quantity":10000},
 				]
 			},
 			{
				isAvailable : true,
				isOneshot : true,
				buildingID: Building.MUSEE,
 				previewImg: 'PopInBuiltArticlePreviewMusee.png',
 				title: 'Musée',
 				description: "Le Mussée est l'endroit ou vous présentez vos artefacts aliens au monde.\nEt en plus ça rapporte un max",
 				hardPrice: 3,
 				ressources: [
 					{"name":"fric","quantity":20000},
 				]
 			}, 
 			{
				isAvailable : false,
				isOneshot : false,
				buildingID: Building.ENTREPOT,
 				previewImg: 'PopInBuiltArticlePreviewEntrepot.png',
 				title: 'Entrepôt',
 				description: "Les Entrepôts servent à stocker toutes les ressources physiques,\net absolument pas à faire un trafic de substances douteuses.",
 				hardPrice: 3,
 				ressources: [
 					{"name":"fric","quantity":1000},
 				]
 			},
 			{
				isAvailable : false,
				isOneshot : false,
				buildingID: Building.LABO,
 				previewImg: 'PopInBuiltArticlePreviewLabo.png',
 				title: 'Labo',
 				description: "Les labos servent à faire avancer la recherche.\nNos chiens ont une idée de ce qu'il font ne vous en faites pas.",
 				hardPrice: 3,
 				ressources: [
 					{"name":"fric","quantity":150000},
 				]
 			}	
 		],
 	};
 	public static var workshopsModels:Map<Int,Dynamic> = [
 		Building.HANGAR_JAUNE=> {
 			destination:'SprungField',
 			previewImg: 'IconSpringfield.png',
 			spaceships: ['JauneLv1','JauneLv2','JauneLv3']
 		},
 		Building.HANGAR_VERT=> {
 			destination:'Modor',
 			previewImg: 'IconPlaneteMilieu.png',
 			spaceships: ['VertLv1','VertLv2','VertLv3']
 		},
 		Building.HANGAR_CYAN=> {
 			destination:'Namok',
 			previewImg: 'IconNamek.png',
 			spaceships: ['CyanLv1','CyanLv2','CyanLv3']
 		},
 		Building.HANGAR_BLEU=> {
 			destination:'Terre',
 			previewImg: 'IconTerre.png',
 			spaceships: ['BleuLv1','BleuLv2','BleuLv3']
 		},
 		Building.HANGAR_VIOLET=> {
 			destination:'Wundërland',
 			previewImg: 'IconWonderland.png',
 			spaceships: ['VioletLv1','VioletLv2','VioletLv3']
 		},
 		Building.HANGAR_ROUGE=> {
 			destination:'StarWat',
 			previewImg: 'IconPlaneteDesEtoiles.png',
 			spaceships: ['OrangeLv1','OrangeLv2','OrangeLv3']
 		},
 	];
 	public static var workshopConfigs:Map<String,Dynamic> = new Map(); // is beeing generated in game

 	public static var artefacts:Map<String,Map<String,Dynamic>> = [
 		'SprungField' => [
 			"701943576599156" => {name:'Skate',userPossesion:0,img:'IconArtefactsSimpsons1.png', currentFriendPossesion:0 },
 			"1446334055683188" => {name:'Bière',userPossesion:0,img:'IconArtefactsSimpsons2.png', currentFriendPossesion:0 },
 			"906211629440719" => {name:'Donut',userPossesion:0,img:'IconArtefactsSimpsons3.png', currentFriendPossesion:0 },
 		],
 		'Mordor' => [
 			"1077843055562367" => {name:'Cheveux',userPossesion:1,img:'IconArtefactsLotr1.png', currentFriendPossesion:0 },
 			"827350023985146" => {name:'Sting',userPossesion:0,img:'IconArtefactsLotr2.png', currentFriendPossesion:0 },
 			"751634398282728" => {name:'Précieux',userPossesion:1,img:'IconArtefactsLotr3.png', currentFriendPossesion:0 },
 		],
 		'Namok' => [
 			"1604447719812726" => {name:'Armure',userPossesion:1,img:'IconArtefactsDbz1.png', currentFriendPossesion:0 },
 			"1018587388159080" => {name:'Kinto-un',userPossesion:1,img:'IconArtefactsDbz2.png', currentFriendPossesion:0 },
 			"1579505662314572" => {name:'Dragon Ball',userPossesion:1,img:'IconArtefactsDbz3.png', currentFriendPossesion:0 },
 		],
 		'Terre' => [
 			"1114090838608010" => {name:'Casserole',userPossesion:1,img:'IconArtefactsTerre1.png', currentFriendPossesion:0 },
 			"1697360473825549" => {name:'Bote',userPossesion:1,img:'IconArtefactsTerre2.png', currentFriendPossesion:0 },
 			"965436526822282" => {name:'Smartphone',userPossesion:0,img:'IconArtefactsTerre3.png', currentFriendPossesion:0 },
 		],
 		'Wundërland' => [
 			"1597297313857163" => {name:'Chapeau',userPossesion:1,img:'IconArtefactsWonderland1.png', currentFriendPossesion:0 },
 			"1619119738302355" => {name:'Tasse',userPossesion:1,img:'IconArtefactsWonderland2.png', currentFriendPossesion:0 },
 			"1440535986251958" => {name:'Potion',userPossesion:0,img:'IconArtefactsWonderland3.png', currentFriendPossesion:0 },
 		],
 		'StarWat' => [
 			"629502290483631" => {name:'Casque',userPossesion:1,img:'IconArtefactsStarwars1.png', currentFriendPossesion:0 },
 			"1008605342490512" => {name:'Sabre',userPossesion:10,img:'IconArtefactsStarwars2.png', currentFriendPossesion:0 },
 			"1419846531672062" => {name:'Blaster',userPossesion:0,img:'IconArtefactsStarwars3.png', currentFriendPossesion:0 },
 		]
 	];
 	public static var planetsRessources: Map<String, Dynamic> = [
	 	'SprungField' => [
	 		{name:'poudre0',maxNb: 100, minNb: 150},
	 		{name:'poudre1',maxNb: 100, minNb: 150},
	 		{name:'poudre2',maxNb: 100, minNb: 150},
	 	],
	 	'Mordor' => [
	 		{name:'poudre2',maxNb: 100, minNb: 150},
	 		{name:'poudre2',maxNb: 100, minNb: 150},
	 		{name:'poudre2',maxNb: 100, minNb: 150},
	 	],
	 	'Namok' => [
	 		{name:'poudre2',maxNb: 100, minNb: 150},
	 		{name:'poudre2',maxNb: 100, minNb: 150},
	 		{name:'poudre2',maxNb: 100, minNb: 150},
	 	],
	 	'Terre' => [
	 		{name:'poudre2',maxNb: 100, minNb: 150},
	 		{name:'poudre2',maxNb: 100, minNb: 150},
	 		{name:'poudre2',maxNb: 100, minNb: 150},
	 	],
	 	'Wundërland' => [
	 		{name:'poudre2',maxNb: 100, minNb: 150},
	 		{name:'poudre2',maxNb: 100, minNb: 150},
	 		{name:'poudre2',maxNb: 100, minNb: 150},
	 	],
	 	'StarWat' => [
	 		{name:'poudre2',maxNb: 100, minNb: 150},
	 		{name:'poudre2',maxNb: 100, minNb: 150},
	 		{name:'poudre2',maxNb: 100, minNb: 150},
	 	]
 	];
 	public static var buildingsGameplay: Map<Int,Dynamic> = [
 		Building.CASINO | Building.LVL_1 => { userPossesion:0 },
 		Building.CASINO | Building.LVL_2 => { userPossesion:0 },
 		Building.CASINO | Building.LVL_3 => { userPossesion:0 },

 		Building.EGLISE | Building.LVL_1 => { userPossesion:0 },
 		Building.EGLISE | Building.LVL_2 => { userPossesion:0 },
 		Building.EGLISE | Building.LVL_3 => { userPossesion:0 },

 		Building.HANGAR_BLEU | Building.LVL_1 => { userPossesion:0 },
 		Building.HANGAR_BLEU | Building.LVL_2 => { userPossesion:0 },
 		Building.HANGAR_BLEU | Building.LVL_3 => { userPossesion:0 },
 		Building.HANGAR_CYAN | Building.LVL_1 => { userPossesion:0 },
 		Building.HANGAR_CYAN | Building.LVL_2 => { userPossesion:0 },
 		Building.HANGAR_CYAN | Building.LVL_3 => { userPossesion:0 },
 		Building.HANGAR_JAUNE | Building.LVL_1 => { userPossesion:0 },
 		Building.HANGAR_JAUNE | Building.LVL_2 => { userPossesion:0 },
 		Building.HANGAR_JAUNE | Building.LVL_3 => { userPossesion:0 },
 		Building.HANGAR_ROUGE | Building.LVL_1 => { userPossesion:0 },
 		Building.HANGAR_ROUGE | Building.LVL_2 => { userPossesion:0 },
 		Building.HANGAR_ROUGE | Building.LVL_3 => { userPossesion:0 },
 		Building.HANGAR_VERT | Building.LVL_1 => { userPossesion:0 },
 		Building.HANGAR_VERT | Building.LVL_2 => { userPossesion:0 },
 		Building.HANGAR_VERT | Building.LVL_3 => { userPossesion:0 },
 		Building.HANGAR_VIOLET | Building.LVL_1 => { userPossesion:0 },
 		Building.HANGAR_VIOLET | Building.LVL_2 => { userPossesion:0 },
 		Building.HANGAR_VIOLET | Building.LVL_3 => { userPossesion:0 },

 		Building.LABO | Building.LVL_1 => { userPossesion:0 },
 		Building.LABO | Building.LVL_2 => { userPossesion:0 },
 		Building.LABO | Building.LVL_3 => { userPossesion:0 },

 		Building.NICHE | Building.LVL_1 => { userPossesion:0, dogesPerSecond : 0.1, dogesMaxGain: 5},
 		Building.NICHE | Building.LVL_2 => { userPossesion:0, dogesPerSecond : 0.2, dogesMaxGain: 10},
 		Building.NICHE | Building.LVL_3 => { userPossesion:0, dogesPerSecond : 0.3 , dogesMaxGain: 20},

 		Building.PAS_DE_TIR | Building.LVL_1 => { userPossesion:0 },
 		Building.PAS_DE_TIR | Building.LVL_2 => { userPossesion:0 },
 		Building.PAS_DE_TIR | Building.LVL_3 => { userPossesion:0 },

 		Building.ENTREPOT | Building.LVL_1 => { userPossesion:0 },
 		Building.ENTREPOT | Building.LVL_2 => { userPossesion:0 },
 		Building.ENTREPOT | Building.LVL_3 => { userPossesion:0 },

 		Building.MUSEE | Building.LVL_1 => { userPossesion:0 },
 		Building.MUSEE | Building.LVL_2 => { userPossesion:0 },
 		Building.MUSEE | Building.LVL_3 => { userPossesion:0 }
 	];
 	public static var rockets: Dynamic = {
 		"rocketsConstructedNb" : 0,
 		"rocketsLaunchedNb" : 0,
 		"currentRocket" : null,
 		"currentRocketID" : "",
 		"currentRocketLaunchTime" : 0 //timestamp,
 	}
 	public static var rocketsConfig : Map<String, Dynamic> = [
 		"JauneLv1" => {
 			name: "Fusée jaune Niveau 1",
 			previewImg: "IconFuseeJaune1.png",
			ressources: [
				{"name":"fric","quantity":"1000"},
				{"name":"doges","quantity":"10"},
				{"name":"poudre0","quantity":"10"},
			],
			constructionTime: 10, //sec
			clickBonus: 0.01,
			timeToDestination: 5, //sec
			destination: "Namok"
 		},
 		"JauneLv2" => {
 			name: "Fusée jaune niveau 2",
 			previewImg: "IconFuseeJaune2.png",
			ressources: [
				{"name":"fric","quantity":"10000"},
				{"name":"doges","quantity":"100"},
				{"name":"poudre0","quantity":"100"},
			],
			constructionTime: 60, //sec
			clickBonus: 0.005,
			timeToDestination: 600, //sec
			destination: "Namok"
 		},
 		"JauneLv3" => {
 			name: "Fusée jaune niveau 3",
 			previewImg: "IconFuseeJaune3.png",
			ressources: [
				{"name":"fric","quantity":"99999"},
				{"name":"doges","quantity":"999"},
				{"name":"poudre0","quantity":"999"},
			],
			constructionTime: 120, //sec
			clickBonus: 0.0025,
			timeToDestination: 600, //sec
			destination: "Namok"
 		},
 		"VertLv1" => {
 			name: "Fusée verte Niveau 1",
 			previewImg: "IconFuseeVert1.png",
			ressources: [
				{"name":"fric","quantity":"1000"},
				{"name":"poudre0","quantity":"50"},
				{"name":"doges","quantity":"20"},
				{"name":"poudre1","quantity":"25"},
			],
			constructionTime: 60, //sec
			clickBonus: 0.01,
			timeToDestination: 60, //sec
			destination: "Namok"
 		},
 		"VertLv2" => {
 			name: "Fusée verte niveau 2",
 			previewImg: "IconFuseeVert2.png",
			ressources: [
				{"name":"fric","quantity":"5000"},
				{"name":"poudre0","quantity":"500"},
				{"name":"doges","quantity":"200"},
				{"name":"poudre1","quantity":"250"},
			],
			constructionTime: 60, //sec
			clickBonus: 0.005,
			timeToDestination: 600, //sec
			destination: "Namok"
 		},
 		"VertLv3" => {
 			name: "Fusée verte niveau 3",
 			previewImg: "IconFuseeVert3.png",
			ressources: [
				{"name":"fric","quantity":"5000"},
				{"name":"poudre0","quantity":"500"},
				{"name":"doges","quantity":"200"},
				{"name":"poudre1","quantity":"250"},
			],
			constructionTime: 60, //sec
			clickBonus: 0.0025,
			timeToDestination: 600, //sec
			destination: "Namok"
 		},
 		"CyanLv1" => {
 			name: "Fusée cyan Niveau 1",
 			previewImg: "IconFuseeCyan1.png",
			ressources: [
				{"name":"fric","quantity":"1000"},
				{"name":"poudre0","quantity":"10"},
				{"name":"poudre1","quantity":"25"},
			],
			constructionTime: 60, //sec
			clickBonus: 0.01,
			timeToDestination: 600, //sec
			destination: "Namok"
 		},
 		"CyanLv2" => {
 			name: "Fusée cyan niveau 2",
 			previewImg: "IconFuseeCyan2.png",
			ressources: [
				{"name":"fric","quantity":"1000"},
				{"name":"poudre0","quantity":"10"},
				{"name":"poudre1","quantity":"25"},
			],
			constructionTime: 60, //sec
			clickBonus: 0.005,
			timeToDestination: 600, //sec
			destination: "Namok"
 		},
 		"CyanLv3" => {
 			name: "Fusée cyan niveau 3",
 			previewImg: "IconFuseeCyan3.png",
			ressources: [
				{"name":"fric","quantity":"1000"},
				{"name":"poudre0","quantity":"10"},
				{"name":"poudre1","quantity":"25"},
			],
			constructionTime: 60, //sec
			clickBonus: 0.0025,
			timeToDestination: 600, //sec
			destination: "Namok"
 		},
 		"BleuLv1" => {
 			name: "Fusée bleue Niveau 1",
 			previewImg: "IconFuseeBleu1.png",
			ressources: [
				{"name":"fric","quantity":"1000"},
				{"name":"poudre0","quantity":"10"},
				{"name":"poudre1","quantity":"25"},
			],
			constructionTime: 60, //sec
			clickBonus: 0.01,
			timeToDestination: 600, //sec
			destination: "Namok"
 		},
 		"BleuLv2" => {
 			name: "Fusée bleue niveau 2",
 			previewImg: "IconFuseeBleu2.png",
			ressources: [
				{"name":"fric","quantity":"1000"},
				{"name":"poudre0","quantity":"10"},
				{"name":"poudre1","quantity":"25"},
			],
			constructionTime: 60, //sec
			clickBonus: 0.005,
			timeToDestination: 600, //sec
			destination: "Namok"
 		},
 		"BleuLv3" => {
 			name: "Fusée bleue niveau 3",
 			previewImg: "IconFuseeBleu3.png",
			ressources: [
				{"name":"fric","quantity":"1000"},
				{"name":"poudre0","quantity":"10"},
				{"name":"poudre1","quantity":"25"},
			],
			constructionTime: 60, //sec
			clickBonus: 0.0025,
			timeToDestination: 600, //sec
			destination: "Namok"
 		},
 		"VioletLv1" => {
 			name: "Fusée violette Niveau 1",
 			previewImg: "IconFuseeViolet1.png",
			ressources: [
				{"name":"fric","quantity":"1000"},
				{"name":"poudre0","quantity":"10"},
				{"name":"poudre1","quantity":"25"},
			],
			constructionTime: 60, //sec
			clickBonus: 0.01,
			timeToDestination: 600, //sec
			destination: "Namok"
 		},
 		"VioletLv2" => {
 			name: "Fusée violette niveau 2",
 			previewImg: "IconFuseeViolet2.png",
			ressources: [
				{"name":"fric","quantity":"1000"},
				{"name":"poudre0","quantity":"10"},
				{"name":"poudre1","quantity":"25"},
			],
			constructionTime: 60, //sec
			clickBonus: 0.005,
			timeToDestination: 600, //sec
			destination: "Namok"
 		},
 		"VioletLv3" => {
 			name: "Fusée violette niveau 3",
 			previewImg: "IconFuseeViolet3.png",
			ressources: [
				{"name":"fric","quantity":"1000"},
				{"name":"poudre0","quantity":"10"},
				{"name":"poudre1","quantity":"25"},
			],
			constructionTime: 60, //sec
			clickBonus: 0.0025,
			timeToDestination: 600, //sec
			destination: "Namok"
 		},
 		"OrangeLv1" => {
 			name: "Fusée rouge niveau 1",
 			previewImg: "IconFuseeOrange1.png",
			ressources: [
				{"name":"fric","quantity":"1000"},
				{"name":"poudre0","quantity":"10"},
				{"name":"poudre1","quantity":"25"},
			],
			constructionTime: 60, //sec
			clickBonus: 0.01,
			timeToDestination: 600, //sec
			destination: "Namok"
 		},
 		"OrangeLv2" => {
 			name: "Fusée rouge niveau 2",
 			previewImg: "IconFuseeOrange2.png",
			ressources: [
				{"name":"fric","quantity":"1000"},
				{"name":"poudre0","quantity":"10"},
				{"name":"poudre1","quantity":"25"},
			],
			constructionTime: 60, //sec
			clickBonus: 0.005,
			timeToDestination: 600, //sec
			destination: "Namok"
 		},
 		"OrangeLv3" => {
 			name: "Fusée rouge niveau 3",
 			previewImg: "IconFuseeOrange3.png",
			ressources: [
				{"name":"fric","quantity":"1000"},
				{"name":"poudre0","quantity":"10"},
				{"name":"poudre1","quantity":"25"},
			],
			constructionTime: 60, //sec
			clickBonus: 0.0025,
			timeToDestination: 600, //sec
			destination: "Namok"
 		}
 	];
 	public static var friendsList : Array<Dynamic> = [ // prérempli pour les tests hors ligne mais overridé à la connexion FB
 		/*{id:00000000148, name: "Riton le raton", img: "www.caca.com"}*/
 		{ id : "818989511510138", name : "Pif", img : "https://fbcdn-profile-a.akamaihd.net/hprofile-ak-xfp1/v/t1.0-1/c19.0.63.64/p64x64/10354686_10150004552801856_220367501106153455_n.jpg?oh=c3889da5f90a3d6d757926d55803d8ac&oe=55FC1A7E&__gda__=1445923720_0fdf1c1f2cf88430f8f1e4a08dd9eebf"},
 		{ id : "5", name : "Pif", img : "https://fbcdn-profile-a.akamaihd.net/hprofile-ak-xfp1/v/t1.0-1/c19.0.63.64/p64x64/10354686_10150004552801856_220367501106153455_n.jpg?oh=c3889da5f90a3d6d757926d55803d8ac&oe=55FC1A7E&__gda__=1445923720_0fdf1c1f2cf88430f8f1e4a08dd9eebf"},
 		{ id : "818989511510138", name : "Pif", img : "https://fbcdn-profile-a.akamaihd.net/hprofile-ak-xfp1/v/t1.0-1/c19.0.63.64/p64x64/10354686_10150004552801856_220367501106153455_n.jpg?oh=c3889da5f90a3d6d757926d55803d8ac&oe=55FC1A7E&__gda__=1445923720_0fdf1c1f2cf88430f8f1e4a08dd9eebf"},
 		{ id : "818989511510138", name : "Pif", img : "https://fbcdn-profile-a.akamaihd.net/hprofile-ak-xfp1/v/t1.0-1/c19.0.63.64/p64x64/10354686_10150004552801856_220367501106153455_n.jpg?oh=c3889da5f90a3d6d757926d55803d8ac&oe=55FC1A7E&__gda__=1445923720_0fdf1c1f2cf88430f8f1e4a08dd9eebf"},
 		{ id : "818989511510138", name : "Pif", img : "https://fbcdn-profile-a.akamaihd.net/hprofile-ak-xfp1/v/t1.0-1/c19.0.63.64/p64x64/10354686_10150004552801856_220367501106153455_n.jpg?oh=c3889da5f90a3d6d757926d55803d8ac&oe=55FC1A7E&__gda__=1445923720_0fdf1c1f2cf88430f8f1e4a08dd9eebf"},
 		{ id : "818989511510138", name : "Pif", img : "https://fbcdn-profile-a.akamaihd.net/hprofile-ak-xfp1/v/t1.0-1/c19.0.63.64/p64x64/10354686_10150004552801856_220367501106153455_n.jpg?oh=c3889da5f90a3d6d757926d55803d8ac&oe=55FC1A7E&__gda__=1445923720_0fdf1c1f2cf88430f8f1e4a08dd9eebf"},
 		{ id : "818989511510138", name : "Pif", img : "https://fbcdn-profile-a.akamaihd.net/hprofile-ak-xfp1/v/t1.0-1/c19.0.63.64/p64x64/10354686_10150004552801856_220367501106153455_n.jpg?oh=c3889da5f90a3d6d757926d55803d8ac&oe=55FC1A7E&__gda__=1445923720_0fdf1c1f2cf88430f8f1e4a08dd9eebf"}
 	];

 	public static var facebookID:String = '818989511510138';
 	public static var loaderCompletion:Float = 0; // when we're loading the game we need to know the % of completion
 	public static var dogeMaxNumber:Float = 25;
 	public static var isUpgradeMode:Bool = false;
 	public static var isDestroyMode:Bool = false;
 	public static var stockPercent:Float = 50;
 	public static var faithPercent:Float = 0;
 	public static var faithLossSpeed:Float = 0.001;
 	public static var prayerEffect:Float = 0.005;
 	public static var museeSoftSpeed:Float = 10;
 	public static var musseVisiteGain:Float = 1;
 	public static var churchClicks:Int = 0;
 	public static var museumClicks:Int = 0;
 	public static var ftueLevel :Int = -1;
 	public static var buildingsToLoad :Int = 9000;
 	public static var buildingsLoaded :Int = 0;

 	public static var building_2_build: Int;
 	public static var building_2_build_bdd_id: String = "";
 	public static var shipToLaunch: String;
 	public static var can_map_update: Bool = true; 	
 	public static var is_building_context_pop_open: Bool = false;

 	public static var BUILDINGS_IMG_FOLDER_PATH: String = "assets/Buildings/";
	public static var BUILDINGS_IMG_EXTENSION: String = ".png";
	public static var BUILDINGS_CONFIG: Map<Int, Dynamic> = [
		/* img format : "XXX_NN.png" */

		Building.CASINO | Building.LVL_1 => {
			width: 3,
			height: 3,
			building_time: 30,
			frames_nb: 25,
			img: "CasinoLv1"
		},
		Building.CASINO | Building.LVL_2 => {
			width: 3,
			height: 3,
			building_time: 60,
			frames_nb: 18,
			img: "CasinoLv2"
		},
		Building.CASINO | Building.LVL_3 => {
			width: 3,
			height: 3,
			building_time: 90,
			frames_nb: 12,
			img: "CasinoLv3"
		},
		Building.EGLISE | Building.LVL_1 => {
			width: 3,
			height: 3,
			building_time: 30,
			frames_nb: 13,
			img: "EgliseLv1"
		},
		Building.EGLISE | Building.LVL_2 => {
			width: 3,
			height: 3,
			building_time: 60,
			frames_nb: 16,
			img: "EgliseLv2"
		},
		Building.EGLISE | Building.LVL_3 => {
			width: 3,
			height: 3,
			building_time: 90,
			frames_nb: 16,
			img: "EgliseLv3"
		},
		Building.HANGAR_BLEU | Building.LVL_1 => {
			width: 4,
			height: 2,
			building_time: 30,
			frames_nb: 1,
			img: "HangarBleuLv1"
		},
		Building.HANGAR_BLEU | Building.LVL_2 => {
			width: 4,
			height: 2,
			building_time: 60,
			frames_nb: 1,
			img: "HangarBleuLv2"
		},
		Building.HANGAR_BLEU | Building.LVL_3 => {
			width: 4,
			height: 2,
			building_time: 90,
			frames_nb: 1,
			img: "HangarBleuLv3"
		},
		Building.HANGAR_CYAN | Building.LVL_1 => {
			width: 4,
			height: 2,
			building_time: 30,
			frames_nb: 1,
			img: "HangarCyanLv1"
		},
		Building.HANGAR_CYAN | Building.LVL_2 => {
			width: 4,
			height: 2,
			building_time: 60,
			frames_nb: 1,
			img: "HangarCyanLv2"
		},
		Building.HANGAR_CYAN | Building.LVL_3 => {
			width: 4,
			height: 2,
			building_time: 90,
			frames_nb: 1,
			img: "HangarCyanLv3"
		},
		Building.HANGAR_JAUNE | Building.LVL_1 => {
			width: 4,
			height: 2,
			building_time: 30,
			frames_nb: 1,
			img: "HangarJauneLv1"
		},
		Building.HANGAR_JAUNE | Building.LVL_2 => {
			width: 4,
			height: 2,
			building_time: 60,
			frames_nb: 1,
			img: "HangarJauneLv2"
		},
		Building.HANGAR_JAUNE | Building.LVL_3 => {
			width: 4,
			height: 2,
			building_time: 90,
			frames_nb: 1,
			img: "HangarJauneLv3"
		},
		Building.HANGAR_ROUGE | Building.LVL_1 => {
			width: 4,
			height: 2,
			building_time: 30,
			frames_nb: 1,
			img: "HangarRougeLv1"
		},
		Building.HANGAR_ROUGE | Building.LVL_2 => {
			width: 4,
			height: 2,
			building_time: 60,
			frames_nb: 1,
			img: "HangarRougeLv2"
		},
		Building.HANGAR_ROUGE | Building.LVL_3 => {
			width: 4,
			height: 2,
			building_time: 90,
			frames_nb: 1,
			img: "HangarRougeLv3"
		},
		Building.HANGAR_VERT | Building.LVL_1 => {
			width: 4,
			height: 2,
			building_time: 30,
			frames_nb: 1,
			img: "HangarVertLv1"
		},
		Building.HANGAR_VERT | Building.LVL_2 => {
			width: 4,
			height: 2,
			building_time: 60,
			frames_nb: 1,
			img: "HangarVertLv2"
		},
		Building.HANGAR_VERT | Building.LVL_3 => {
			width: 4,
			height: 2,
			building_time: 90,
			frames_nb: 1,
			img: "HangarVertLv3"
		},
		Building.HANGAR_VIOLET | Building.LVL_1 => {
			width: 4,
			height: 2,
			building_time: 30,
			frames_nb: 1,
			img: "HangarVioletLv1"
		},
		Building.HANGAR_VIOLET | Building.LVL_2 => {
			width: 4,
			height: 2,
			building_time: 60,
			frames_nb: 1,
			img: "HangarVioletLv2"
		},
		Building.HANGAR_VIOLET | Building.LVL_3 => {
			width: 4,
			height: 2,
			building_time: 90,
			frames_nb: 1,
			img: "HangarVioletLv3"
		},
		Building.LABO | Building.LVL_1 => {
			width: 2,
			height: 2,
			building_time: 30,
			frames_nb: 1,
			img: "LaboLv1"
		},
		Building.LABO | Building.LVL_2 => {
			width: 2,
			height: 2,
			building_time: 60,
			frames_nb: 1,
			img: "LaboLv2"
		},
		Building.LABO | Building.LVL_3 => {
			width: 3,
			height: 3,
			building_time: 90,
			frames_nb: 1,
			img: "LaboLv3"
		},
		Building.NICHE | Building.LVL_1 => {
			width: 1,
			height: 1,
			building_time: 30,
			frames_nb: 11,
			img: "NicheLv1"
		},
		Building.NICHE | Building.LVL_2 => {
			width: 1,
			height: 1,
			building_time: 60,
			frames_nb: 33,
			img: "NicheLv2"
		},
		Building.NICHE | Building.LVL_3 => {
			width: 1,
			height: 1,
			building_time: 90,
			frames_nb: 18,
			img: "NicheLv3"
		},
		Building.PAS_DE_TIR | Building.LVL_1 => {
			width: 5,
			height: 5,
			building_time: 5,
			frames_nb: 23,
			img: "PasdetirLv1"
		},
		Building.PAS_DE_TIR | Building.LVL_2 => {
			width: 5,
			height: 5,
			building_time: 60,
			frames_nb: 12,
			img: "PasdetirLv2"
		},
		Building.PAS_DE_TIR | Building.LVL_3 => {
			width: 5,
			height: 5,
			building_time: 90,
			frames_nb: 7,
			img: "PasdetirLv3"
		},
		Building.ENTREPOT | Building.LVL_1 => {
			width: 2,
			height: 2,
			building_time: 30,
			frames_nb: 4,
			img: "EntrepotLv1"
		},
		Building.ENTREPOT | Building.LVL_2 => {
			width: 2,
			height: 2,
			building_time: 60,
			frames_nb: 4,
			img: "EntrepotLv2"
		},
		Building.ENTREPOT | Building.LVL_3 => {
			width: 2,
			height: 2,
			building_time: 90,
			frames_nb: 4,
			img: "EntrepotLv3"
		},
		Building.MUSEE | Building.LVL_1 => {
			width: 2,
			height: 2,
			building_time: 30,
			frames_nb: 1,
			img: "MuseeLv1"
		},
		Building.MUSEE | Building.LVL_2 => {
			width: 2,
			height: 2,
			building_time: 60,
			frames_nb: 1,
			img: "MuseeLv2"
		},
		Building.MUSEE | Building.LVL_3 => {
			width: 2,
			height: 3,
			building_time: 90,
			frames_nb: 1,
			img: "MuseeLv3"
		},
	];
}