package;

import buildings.Building;
// class that store informations of the game in statics var so that it can be acces anywhere
// the player stats will most likely be here
class GameInfo
{
 	public static var ressources:Map<String,Dynamic> = [
 		'poudre0' => {
 			name: 'PLPP Yellow', //plpp stands for perlimpinpin
 			previewImg: 'assets/UI/Icons/PreviewRessources/PopInMarketArticlePreviewYellowMineral.png',
 			iconImg: 'assets/UI/Icons/IconsRessources/IconYellowMineral.png',
 			userPossesion: 15000,
 			buyCost: 10,
 			sellCost: 5,
 			lastQuantityBuy: 0,
 			lastQuantitySell: 0
 		},
 		'poudre1' => {
 			name: 'PLPP Green',
 			previewImg: 'assets/UI/Icons/PreviewRessources/PopInMarketArticlePreviewGreenMineral.png',
 			iconImg: 'assets/UI/Icons/IconsRessources/IconGreenMineral.png',
 			userPossesion: 15000,
 			buyCost: 25,
 			sellCost: 10,
 			lastQuantityBuy: 0,
 			lastQuantitySell: 0
 		},
 		'poudre2' => {
 			name: 'PLPP Cyan',
 			previewImg: 'assets/UI/Icons/PreviewRessources/PopInMarketArticlePreviewCyanMineral.png',
 			iconImg: 'assets/UI/Icons/IconsRessources/IconCyanMineral.png',
 			userPossesion: 15000,
 			buyCost: 50,
 			sellCost: 25,
 			lastQuantityBuy: 0,
 			lastQuantitySell: 0
 		},
 		'poudre3' => { 
 			name: 'PLPP Blue',
 			previewImg: 'assets/UI/Icons/PreviewRessources/PopInMarketArticlePreviewBlueMineral.png',
 			iconImg: 'assets/UI/Icons/IconsRessources/IconBlueMineral.png',
 			userPossesion: 15000,
 			buyCost: 100,
 			sellCost: 40,
 			lastQuantityBuy: 0,
 			lastQuantitySell: 0
 		}, 		
 		'poudre4' => {
 			name: 'PLPP Purple',
 			previewImg: 'assets/UI/Icons/PreviewRessources/PopInMarketArticlePreviewPurpleMineral.png',
 			iconImg: 'assets/UI/Icons/IconsRessources/IconPurpleMineral.png',
 			userPossesion: 15000,
 			buyCost: 300,
 			sellCost: 200,
 			lastQuantityBuy: 0,
 			lastQuantitySell: 0
 		},
 		'poudre5' => {
 			name: 'PLPP Red',
 			previewImg: 'assets/UI/Icons/PreviewRessources/PopInMarketArticlePreviewRedMineral.png',
 			iconImg: 'assets/UI/Icons/IconsRessources/IconRedMineral.png',
 			userPossesion: 15000,
 			buyCost: 1000,
 			sellCost: 700,
 			lastQuantityBuy: 0,
 			lastQuantitySell: 0
 		},
 		'fric' => {
 			name: 'Dogeflooz',
 			previewImg: 'assets/UI/Icons/PreviewRessources/PopInShopArticlePreview2Dogeflooz.png',
 			iconImg: 'assets/UI/Icons/IconsRessources/IconDogeflooz.png',
 			userPossesion: 15000,
 		},
 		'hardMoney' => {
 			name: "Os D'or",
 			previewImg: 'assets/UI/Icons/PreviewRessources/PopInShopArticlePreview2Os.png',
 			iconImg: 'assets/UI/Icons/IconsRessources/IconOsDor.png',
 			userPossesion: 15000,
 		}
 	];
 	public static var questsArticles:Dynamic = {
 		'current':[
 			{
 				previewImg: 'IconDogNiche',
 				title: 'Première niche',
 				description: "Pas de niches, pas d'employés.Pas d'employés, pas\nde fusées.Pas de fusées... pas de fusées.\nOuvrez-donc le menu de construction.\nPuis achetez et construisez une niche !",
 				rewards: [
 					{"name":"fric","quantity":"100"},
 					{"name":"poudre0","quantity":"10"},
 				]
 			},
 			{
 				previewImg: 'IconDogWorkshop',
 				title: 'Premier atelier',
 				description: "Les ateliers servent à construire les fussées.\nPour l'instant vos pauvres employés s'ennuient à mourir.\nSoyez gentil et donnez leur du travail !\nPour rappel, les batiments peuvent être\nachetés depuis le menu de construction",
 				rewards: [
 					{"name":"fric","quantity":"1000"},
 					{"name":"poudre0","quantity":"10"},
 				]
 			},
 			{
 				previewImg: 'IconDogWorkshop',
 				title: "Première fusée",
 				description: "Construire votre première fusée est maintenant possible !\nCliquez sur votre atelier et comencez la\n construction de la fusée. N'oubliez pas de fouett..\n*hum* motiver vos employés en cliquant sur\n l'icone dans le atelier",
 				rewards: [
 					{"name":"fric","quantity":"1000"},
 					{"name":"poudre0","quantity":"10"},
 				]
 			},
 			{
 				previewImg: 'IconDogAstro',
 				title: "La conquète de l'espace !",
 				description: "Votre première fusée est prète à partir !\nVous n'avez plus qu'a appuyer sur le gros\nboutton vert pour la lancer. Ca ne devrait pas être\ntrop compliqué non ?",
 				rewards: [
 					{"name":"fric","quantity":"1000"},
 					{"name":"poudre0","quantity":"10"},
 				]
 			},
 			{
 				previewImg: 'IconDogCasino',
 				title: "Black jack and...",
 				description: "Vos employés veulent se détendre, vous voulez\n vous remplir les poches.\nUn casino semble le parfait compromis",
 				rewards: [
 					{"name":"fric","quantity":"1000"},
 					{"name":"poudre0","quantity":"10"},
 				]
 			},
 			{
 				previewImg: 'IconDogMusee',
 				title: "La culture ça rapporte",
 				description: "Les artefacts que vous trouvez sur les planètes\nsont incroyablement rares Et comme ce qui est\nrare est cher, les billets ne sont pas donnés. Entre la\nboutique de souvenirs et les entrées, vous allez\nencaisser sec !",
 				rewards: [
 					{"name":"fric","quantity":"1000"},
 					{"name":"poudre0","quantity":"10"},
 				]
 			},
 		],
 		finished:{

 		}
 	}
 	public static var buildMenuArticles:Dynamic = {
 		"niches": [
 			{
 				buildingID: Building.NICHE,
 				previewImg: 'assets/UI/Icons/Buildings/PopInBuiltArticlePreviewNiche.png',
 				title: 'Niche en Bois',
 				description: "L'association des travailleurs canins (l'ATC) impose un logement de fonction.\nDonc pour faire court niches = employés.",
 				hardPrice: 3,
 				ressources: [
 					{"name":"fric","quantity":1000},
 					{"name":"poudre0","quantity":10},
 					{"name":"poudre1","quantity":25},
 				]
 			},
 		],
 		"spacechips": [
 			{

 				buildingID: Building.HANGAR_JAUNE,
 				previewImg: 'assets/UI/Icons/Buildings/PopInBuiltArticlePreviewHangar1.png',
 				title: 'Atelier Destination SprungField',
 				description: 'Boite magique où les fusées sont assemblées avec amour et bonne humeur.\nToute les rumeur au sujet des coups de fouet électrique ne sont que calomnies.',
 				hardPrice: 3,
 				ressources: [
 					{"name":"fric","quantity":1000},
 					{"name":"poudre2","quantity":10},
 					{"name":"poudre1","quantity":25},
 				]
 			},
 			{
 				buildingID: Building.HANGAR_VERT,
 				previewImg: 'assets/UI/Icons/Buildings/PopInBuiltArticlePreviewHangar2.png',
 				title: 'Atelier Destination Modor',
 				description: "Cet atelier construit des fusées grâce au pouvoir de l’amitié et à des techniques\n de management éprouvés.",
 				hardPrice: 3,
 				ressources: [
 					{"name":"fric","quantity":1000},
 					{"name":"poudre0","quantity":10},
 					{"name":"poudre5","quantity":250},
 				]
 			},
 			{
 				buildingID: Building.HANGAR_CYAN,
 				previewImg: 'assets/UI/Icons/Buildings/PopInBuiltArticlePreviewHangar3.png',
 				title: 'Atelier Destination Namok',
 				description: "Dans cet atelier les employés sont les plus heureux au monde.\nLes semaines de 169 heures ne sont bien sur qu'un mythe.",
 				hardPrice: 3,
 				ressources: [
 					{"name":"fric","quantity":1000},
 					{"name":"poudre3","quantity":10},
 					{"name":"poudre4","quantity":25},
 				]
 			}, 			
 			{
 				buildingID: Building.HANGAR_BLEU,
 				previewImg: 'assets/UI/Icons/Buildings/PopInBuiltArticlePreviewHangar4.png',
 				title: 'Atelier Destination Terre',
 				description: "Dans cet atelier, aucun incident n'a jamais été rapporté à la direction\net ce n'est absolument pas par crainte de représailles.",
 				hardPrice: 3,
 				ressources: [
 					{"name":"fric","quantity":1000},
 					{"name":"poudre0","quantity":10},
 					{"name":"poudre1","quantity":25},
 				]
 			},
 			{
 				buildingID: Building.HANGAR_VIOLET,
 				previewImg: 'assets/UI/Icons/Buildings/PopInBuiltArticlePreviewHangar5.png',
 				title: 'Atelier Destination Wundërland',
 				description: "Les soupçons des conséquences mortelles liés à la manipulation\n des moteurs à Dogetonium ont été réfutés par le professeur Van-Du.",
 				hardPrice: 3,
 				ressources: [
 					{"name":"fric","quantity":1000},
 					{"name":"poudre0","quantity":10},
 					{"name":"poudre1","quantity":25},
 				]
 			},
 			{
 				buildingID: Building.HANGAR_ROUGE,
 				previewImg: 'assets/UI/Icons/Buildings/PopInBuiltArticlePreviewHangar6.png',
 				title: 'Atelier Destination StarWat',
 				description: "Cet atelier utilise uniquement des huiles écologiques.\nQui ne sont en aucun cas faites a partir de travailleurs retraités.",
 				hardPrice: 3,
 				ressources: [
 					{"name":"fric","quantity":1000},
 					{"name":"poudre0","quantity":10},
 					{"name":"poudre1","quantity":25},
 				]
 			},
 			
 		],
 		"utilitaires": [
 			{
 				buildingID: Building.CASINO,
 				previewImg: 'assets/UI/Icons/Buildings/popInBuiltArticlePreviewCasino.png',
 				title: 'Casino',
 				description: "Un établissement haut de gamme qui ne propose que des jeux honnêtes\npermettant à nos fiers travailleurs de se détendre.",
 				hardPrice: 3,
 				ressources: [
 					{"name":"fric","quantity":1000},
 					{"name":"poudre0","quantity":10},
 					{"name":"poudre1","quantity":25},
 				]
 			},
 			{
				buildingID: Building.EGLISE,
 				previewImg: 'assets/UI/Icons/Buildings/PopInBuiltArticlePreviewEglise.png',
 				title: 'Église',
 				description: "Une modeste chapelle où nos employés implorent le grand manitou\nde nous accorder des finances prospères.",
 				hardPrice: 3,
 				ressources: [
 					{"name":"fric","quantity":1000},
 					{"name":"poudre0","quantity":10},
 					{"name":"poudre1","quantity":25},
 				]
 			},
 			{
				buildingID: Building.EGLISE,
 				previewImg: 'assets/UI/Icons/Buildings/PopInBuiltArticlePreviewEntrepot.png',
 				title: 'Entrepot',
 				description: "Les Entrepôts servent à stocker toutes les ressources physiques,\net absolument pas à faire un trafic de substances douteuses.",
 				hardPrice: 3,
 				ressources: [
 					{"name":"fric","quantity":1000},
 					{"name":"poudre0","quantity":10},
 					{"name":"poudre1","quantity":25},
 				]
 			},
 		],
 	};
 	public static var buildings:Map<String,Dynamic> = [ //temp, à changer avec le merge lucien
 		'hangarNamok'=> {
 			destination:'Namok',
 			previewImg: 'assets/UI/Icons/Planet/IconNamek.png',
 			level: 1,
 			ressources: [
 				{"name":"fric","quantity":"1000"},
 				{"name":"poudre0","quantity":"10"},
 				{"name":"poudre1","quantity":"25"},
 			],

 		}
 	];


 	public static var userWidth:Float=1920;
 	public static var userHeight:Float=1000;
 	public static var dogeNumber:Float = 20;
 	public static var dogeMaxNumber:Float = 25;
 	public static var stockPercent:Float = 50;
 	public static var building_2_build: Int = 0;
 	public static var can_map_update: Bool = true; 	

 	public static var BUILDINGS_IMG_FOLDER_PATH: String = "assets/Buildings/";
	public static var BUILDINGS_IMG_EXTENSION: String = ".png";

	public static var BUILDINGS_CONFIG: Map<Int, Dynamic> = [
		/* img format : "XXX_NN.png" */

		Building.CASINO | Building.LVL_1 => {
			width: 3,
			height: 3,
			vertical_dir: 0,
			building_time: 30,
			frames_nb: 25,
			img: "CasinoLv1"
		},
		Building.CASINO | Building.LVL_2 => {
			width: 3,
			height: 3,
			vertical_dir: 0,
			building_time: 60,
			frames_nb: 18,
			img: "CasinoLv2"
		},
		Building.CASINO | Building.LVL_3 => {
			width: 3,
			height: 3,
			vertical_dir: 0,
			building_time: 90,
			frames_nb: 12,
			img: "CasinoLv3"
		},
		Building.EGLISE | Building.LVL_1 => {
			width: 3,
			height: 3,
			vertical_dir: 0,
			building_time: 30,
			frames_nb: 13,
			img: "EgliseLv1"
		},
		Building.EGLISE | Building.LVL_2 => {
			width: 3,
			height: 3,
			vertical_dir: 0,
			building_time: 0,
			frames_nb: 16,
			img: "EgliseLv2"
		},
		Building.EGLISE | Building.LVL_3 => {
			width: 3,
			height: 3,
			vertical_dir: 0,
			building_time: 90,
			frames_nb: 16,
			img: "EgliseLv3"
		},
		Building.HANGAR_BLEU | Building.LVL_1 => {
			width: 4,
			height: 2,
			vertical_dir: -1,
			building_time: 30,
			frames_nb: 1,
			img: "HangarBleuLv1"
		},
		Building.HANGAR_BLEU | Building.LVL_2 => {
			width: 4,
			height: 2,
			vertical_dir: -1,
			building_time: 60,
			frames_nb: 1,
			img: "HangarBleuLv2"
		},
		Building.HANGAR_BLEU | Building.LVL_3 => {
			width: 4,
			height: 2,
			vertical_dir: -1,
			building_time: 90,
			frames_nb: 1,
			img: "HangarBleuLv3"
		},
		Building.HANGAR_CYAN | Building.LVL_1 => {
			width: 4,
			height: 2,
			vertical_dir: -1,
			building_time: 30,
			frames_nb: 1,
			img: "HangarCyanLv1"
		},
		Building.HANGAR_CYAN | Building.LVL_2 => {
			width: 4,
			height: 2,
			vertical_dir: -1,
			building_time: 60,
			frames_nb: 1,
			img: "HangarCyanLv2"
		},
		Building.HANGAR_CYAN | Building.LVL_3 => {
			width: 4,
			height: 2,
			vertical_dir: -1,
			building_time: 90,
			frames_nb: 1,
			img: "HangarCyanLv3"
		},
		Building.HANGAR_JAUNE | Building.LVL_1 => {
			width: 4,
			height: 2,
			vertical_dir: -1,
			building_time: 30,
			frames_nb: 1,
			img: "HangarJauneLv1"
		},
		Building.HANGAR_JAUNE | Building.LVL_2 => {
			width: 4,
			height: 2,
			vertical_dir: -1,
			building_time: 60,
			frames_nb: 1,
			img: "HangarJauneLv2"
		},
		Building.HANGAR_JAUNE | Building.LVL_3 => {
			width: 4,
			height: 2,
			vertical_dir: -1,
			building_time: 90,
			frames_nb: 1,
			img: "HangarJauneLv3"
		},
		Building.HANGAR_ROUGE | Building.LVL_1 => {
			width: 4,
			height: 2,
			vertical_dir: -1,
			building_time: 30,
			frames_nb: 1,
			img: "HangarRougeLv1"
		},
		Building.HANGAR_ROUGE | Building.LVL_2 => {
			width: 4,
			height: 2,
			vertical_dir: -1,
			building_time: 60,
			frames_nb: 1,
			img: "HangarRougeLv2"
		},
		Building.HANGAR_ROUGE | Building.LVL_3 => {
			width: 4,
			height: 2,
			vertical_dir: -1,
			building_time: 90,
			frames_nb: 1,
			img: "HangarRougeLv3"
		},
		Building.HANGAR_VERT | Building.LVL_1 => {
			width: 4,
			height: 2,
			vertical_dir: -1,
			building_time: 30,
			frames_nb: 1,
			img: "HangarVertLv1"
		},
		Building.HANGAR_VERT | Building.LVL_2 => {
			width: 4,
			height: 2,
			vertical_dir: -1,
			building_time: 60,
			frames_nb: 1,
			img: "HangarVertLv2"
		},
		Building.HANGAR_VERT | Building.LVL_3 => {
			width: 4,
			height: 2,
			vertical_dir: -1,
			building_time: 90,
			frames_nb: 1,
			img: "HangarVertLv3"
		},
		Building.HANGAR_VIOLET | Building.LVL_1 => {
			width: 4,
			height: 2,
			vertical_dir: -1,
			building_time: 30,
			frames_nb: 1,
			img: "HangarVioletLv1"
		},
		Building.HANGAR_VIOLET | Building.LVL_2 => {
			width: 4,
			height: 2,
			vertical_dir: -1,
			building_time: 60,
			frames_nb: 1,
			img: "HangarVioletLv2"
		},
		Building.HANGAR_VIOLET | Building.LVL_3 => {
			width: 4,
			height: 2,
			vertical_dir: -1,
			building_time: 90,
			frames_nb: 1,
			img: "HangarVioletLv3"
		},
		Building.LABO | Building.LVL_1 => {
			width: 2,
			height: 2,
			vertical_dir: 0,
			building_time: 30,
			frames_nb: 1,
			img: "LaboLv1"
		},
		Building.LABO | Building.LVL_2 => {
			width: 2,
			height: 2,
			vertical_dir: 0,
			building_time: 60,
			frames_nb: 1,
			img: "LaboLv2"
		},
		Building.LABO | Building.LVL_3 => {
			width: 3,
			height: 3,
			vertical_dir: 0,
			building_time: 90,
			frames_nb: 1,
			img: "LaboLv3"
		},
		Building.NICHE | Building.LVL_1 => {
			width: 1,
			height: 1,
			vertical_dir: 0,
			building_time: 30,
			frames_nb: 11,
			img: "NicheLv1"
		},
		Building.NICHE | Building.LVL_2 => {
			width: 1,
			height: 1,
			vertical_dir: 0,
			building_time: 60,
			frames_nb: 33,
			img: "NicheLv2"
		},
		Building.NICHE | Building.LVL_3 => {
			width: 1,
			height: 1,
			vertical_dir: 0,
			building_time: 90,
			frames_nb: 18,
			img: "NicheLv3"
		},
		Building.PAS_DE_TIR | Building.LVL_1 => {
			width: 5,
			height: 5,
			vertical_dir: 0,
			building_time: 30,
			frames_nb: 23,
			img: "PasdetirLv1"
		},
		Building.PAS_DE_TIR | Building.LVL_2 => {
			width: 5,
			height: 5,
			vertical_dir: 0,
			building_time: 60,
			frames_nb: 12,
			img: "PasdetirLv2"
		},
		Building.PAS_DE_TIR | Building.LVL_3 => {
			width: 5,
			height: 5,
			vertical_dir: 0,
			building_time: 90,
			frames_nb: 7,
			img: "PasdetirLv3"
		},
		Building.ENTREPOT | Building.LVL_1 => {
			width: 2,
			height: 2,
			vertical_dir: 0,
			building_time: 30,
			frames_nb: 4,
			img: "EntrepotLv1"
		},
		Building.ENTREPOT | Building.LVL_2 => {
			width: 2,
			height: 2,
			vertical_dir: 0,
			building_time: 60,
			frames_nb: 4,
			img: "EntrepotLv2"
		},
		Building.ENTREPOT | Building.LVL_3 => {
			width: 2,
			height: 2,
			vertical_dir: 0,
			building_time: 90,
			frames_nb: 4,
			img: "EntrepotLv3"
		},
		Building.MUSEE | Building.LVL_1 => {
			width: 2,
			height: 2,
			vertical_dir: 0,
			building_time: 30,
			frames_nb: 1,
			img: "MuseeLv1"
		},
		Building.MUSEE | Building.LVL_2 => {
			width: 2,
			height: 2,
			vertical_dir: 0,
			building_time: 60,
			frames_nb: 1,
			img: "MuseeLv2"
		},
		Building.MUSEE | Building.LVL_3 => {
			width: 3,
			height: 2,
			vertical_dir: 1,
			building_time: 90,
			frames_nb: 1,
			img: "MuseeLv3"
		},
	];
}