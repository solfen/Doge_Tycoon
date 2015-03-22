package;

import sprites.Building;
// class that store informations of the game in statics var so that it can be acces anywhere
// the player stats will most likely be here
class GameInfo
{
	public static var preloadAssets:Array<String> = [
		'assets/UI/SplashScreen/IconsSplash.jpg',
	];
 	public static var loadAssets:Array<String> = [

 		/*
		 ____                 ___       __                                
		/\  _`\           __ /\_ \     /\ \  __                           
		\ \ \L\ \  __  __/\_\\//\ \    \_\ \/\_\    ___      __     ____  
		 \ \  _ <'/\ \/\ \/\ \ \ \ \   /'_` \/\ \ /' _ `\  /'_ `\  /',__\ 
		  \ \ \L\ \ \ \_\ \ \ \ \_\ \_/\ \L\ \ \ \/\ \/\ \/\ \L\ \/\__, `\
		   \ \____/\ \____/\ \_\/\____\ \___,_\ \_\ \_\ \_\ \____ \/\____/
		    \/___/  \/___/  \/_/\/____/\/__,_ /\/_/\/_/\/_/\/___L\ \/___/ 
		                                                     /\____/      
		                                                     \_/__/
		*/
		"./assets/Buildings/CasinoLv1.png",
		"./assets/Buildings/CasinoLv2.png",
		"./assets/Buildings/CasinoLv3.png",
		"./assets/Buildings/EgliseLv1.png",
		"./assets/Buildings/EgliseLv2.png",
		"./assets/Buildings/EgliseLv3.png",
		"./assets/Buildings/Hangar1Lv1.png",
		"./assets/Buildings/Hangar1Lv2.png",
		"./assets/Buildings/Hangar1Lv3.png",
		"./assets/Buildings/Hangar2Lv1.png",
		"./assets/Buildings/Hangar2Lv2.png",
		"./assets/Buildings/Hangar2Lv3.png",
		"./assets/Buildings/Hangar3Lv1.png",
		"./assets/Buildings/Hangar3Lv2.png",
		"./assets/Buildings/Hangar3Lv3.png",
		"./assets/Buildings/Hangar4Lv1.png",
		"./assets/Buildings/Hangar4Lv2.png",
		"./assets/Buildings/Hangar4Lv3.png",
		"./assets/Buildings/Hangar5Lv1.png",
		"./assets/Buildings/Hangar5Lv2.png",
		"./assets/Buildings/Hangar5Lv3.png",
		"./assets/Buildings/Hangar6Lv1.png",
		"./assets/Buildings/Hangar6Lv2.png",
		"./assets/Buildings/Hangar6Lv3.png",
		"./assets/Buildings/Labo1.png",
		"./assets/Buildings/Labo2.png",
		"./assets/Buildings/Labo3.png",
		"./assets/Buildings/NicheLv1.png",
		"./assets/Buildings/NicheLv2.png",
		"./assets/Buildings/NicheLv3.png",
		"./assets/Buildings/PasDeTir1.png",
		"./assets/Buildings/PasDeTir2.png",
		"./assets/Buildings/PasDeTir3.png",
	 	/*
		oooooooooo.     .oooooo.     .oooooo.     .oooooo..o 
		`888'   `Y8b   d8P'  `Y8b   d8P'  `Y8b   d8P'    `Y8 
		 888      888 888      888 888           Y88bo.      
		 888      888 888      888 888            `"Y8888o.  
		 888      888 888      888 888     ooooo      `"Y88b 
		 888     d88' `88b    d88' `88.    .88'  oo     .d8P 
		o888bood8P'    `Y8bood8P'   `Y8bood8P'   8""88888P'  */
		'assets/Dogs/DogCasino.png',
		'assets/Dogs/DogChurch.png',
		'assets/Dogs/DogHangarWorkshop.png',
		'assets/Dogs/DogMusee.png',
		'assets/Dogs/DogNiche.png',
		'assets/Dogs/DogPasDeTir.png',
		/*
		ooooo   ooooo ooooo     ooo oooooooooo.   
		`888'   `888' `888'     `8' `888'   `Y8b  
		 888     888   888       8   888      888 
		 888ooooo888   888       8   888      888 
		 888     888   888       8   888      888 
		 888     888   `88.    .8'   888     d88' 
		o888o   o888o    `YbodP'    o888bood8P'
		*/
		'assets/UI/Bulles/HudBulle.png',
		'assets/UI/Cursor/curseur_down.png',
		'assets/UI/Cursor/curseur_up.png',
		'assets/UI/Hud/HudBuildFill.png',
		'assets/UI/Hud/HudBuildFillBar.png',
		'assets/UI/Hud/HudIconBuild.png',
		'assets/UI/Hud/HudIconBuildActive.png',
		'assets/UI/Hud/HudIconBuildNormal.png',
		'assets/UI/Hud/HudIconDestroyActive.png',
		'assets/UI/Hud/HudIconDestroyNormal.png',
		'assets/UI/Hud/HudIconInventory.png',
		'assets/UI/Hud/HudIconInventoryActive.png',
		'assets/UI/Hud/HudIconInventoryNormal.png',
		'assets/UI/Hud/HudIconMarketActive.png',
		'assets/UI/Hud/HudIconMarketNormal.png',
		'assets/UI/Hud/HudIconObservatoryActive.png',
		'assets/UI/Hud/HudIconObservatoryNormal.png',
		'assets/UI/Hud/HudIconOptionActive.png',
		'assets/UI/Hud/HudIconOptionNormal.png',
		'assets/UI/Hud/HudIconPop.png',
		'assets/UI/Hud/HudIconQuestActive.png',
		'assets/UI/Hud/HudIconQuestNormal.png',
		'assets/UI/Hud/HudIconShopActive.png',
		'assets/UI/Hud/HudIconShopNormal.png',
		'assets/UI/Hud/HudInventoryFill.png',
		'assets/UI/Hud/HudInventoryFillBar.png',
		'assets/UI/Hud/HudMoneyHard.png',
		'assets/UI/Hud/HudMoneySoft.png',
		'assets/UI/Hud/HudPopFill.png',
		'assets/UI/Hud/HudPopFillBar.png',
		/*
	      .o.       ooooooooo.   ooooooooooooo oooooooooooo oooooooooooo   .oooooo.         .o.       ooooooooooooo  .oooooo..o 
	     .888.      `888   `Y88. 8'   888   `8 `888'     `8 `888'     `8  d8P'  `Y8b       .888.      8'   888   `8 d8P'    `Y8 
	    .8"888.      888   .d88'      888       888          888         888              .8"888.          888      Y88bo.      
	   .8' `888.     888ooo88P'       888       888oooo8     888oooo8    888             .8' `888.         888       `"Y8888o.  
	  .88ooo8888.    888`88b.         888       888    "     888    "    888            .88ooo8888.        888           `"Y88b 
	 .8'     `888.   888  `88b.       888       888       o  888         `88b    ooo   .8'     `888.       888      oo     .d8P 
	o88o     o8888o o888o  o888o     o888o     o888ooooood8 o888o         `Y8bood8P'  o88o     o8888o     o888o     8""88888P'  */
		'assets/UI/Icons/Artefacts/IconArtefactsDbz1.png',
		'assets/UI/Icons/Artefacts/IconArtefactsDbz2.png',
		'assets/UI/Icons/Artefacts/IconArtefactsDbz3.png',
		'assets/UI/Icons/Artefacts/IconArtefactsLotr1.png',
		'assets/UI/Icons/Artefacts/IconArtefactsLotr2.png',
		'assets/UI/Icons/Artefacts/IconArtefactsLotr3.png',
		'assets/UI/Icons/Artefacts/IconArtefactsSimpsons1.png',
		'assets/UI/Icons/Artefacts/IconArtefactsSimpsons2.png',
		'assets/UI/Icons/Artefacts/IconArtefactsSimpsons3.png',
		'assets/UI/Icons/Artefacts/IconArtefactsStarwars1.png',
		'assets/UI/Icons/Artefacts/IconArtefactsStarwars2.png',
		'assets/UI/Icons/Artefacts/IconArtefactsStarwars3.png',
		'assets/UI/Icons/Artefacts/IconArtefactsTerre1.png',
		'assets/UI/Icons/Artefacts/IconArtefactsTerre2.png',
		'assets/UI/Icons/Artefacts/IconArtefactsTerre3.png',
		'assets/UI/Icons/Artefacts/IconArtefactsWonderland1.png',
		'assets/UI/Icons/Artefacts/IconArtefactsWonderland2.png',
		'assets/UI/Icons/Artefacts/IconArtefactsWonderland3.png',
		'assets/UI/Icons/Buildings/PopInBuiltArticlePreviewCasino.png',
		'assets/UI/Icons/Buildings/PopInBuiltArticlePreviewEglise.png',
		'assets/UI/Icons/Buildings/PopInBuiltArticlePreviewEntrepot.png',
		'assets/UI/Icons/Buildings/PopInBuiltArticlePreviewHangar1.png',
		'assets/UI/Icons/Buildings/PopInBuiltArticlePreviewHangar2.png',
		'assets/UI/Icons/Buildings/PopInBuiltArticlePreviewHangar3.png',
		'assets/UI/Icons/Buildings/PopInBuiltArticlePreviewHangar4.png',
		'assets/UI/Icons/Buildings/PopInBuiltArticlePreviewHangar5.png',
		'assets/UI/Icons/Buildings/PopInBuiltArticlePreviewHangar6.png',
		'assets/UI/Icons/Buildings/PopInBuiltArticlePreviewLabo.png',
		'assets/UI/Icons/Buildings/PopInBuiltArticlePreviewMusee.png',
		'assets/UI/Icons/Buildings/PopInBuiltArticlePreviewNiche.png',
		'assets/UI/Icons/Dogs/IconDogAstro.png',
		'assets/UI/Icons/Dogs/IconDogCasino.png',
		'assets/UI/Icons/Dogs/IconDogChurch.png',
		'assets/UI/Icons/Dogs/IconDogMusee.png',
		'assets/UI/Icons/Dogs/IconDogNiche.png',
		'assets/UI/Icons/Dogs/IconDogWorkshop.png',
		'assets/UI/Icons/Fusee/Bleu3.png',
		'assets/UI/Icons/Fusee/IconFuseeBleu1.png',
		'assets/UI/Icons/Fusee/IconFuseeBleu2.png',
		'assets/UI/Icons/Fusee/IconFuseeCyan1.png',
		'assets/UI/Icons/Fusee/IconFuseeCyan2.png',
		'assets/UI/Icons/Fusee/IconFuseeCyan3.png',
		'assets/UI/Icons/Fusee/IconFuseeFB1.png',
		'assets/UI/Icons/Fusee/IconFuseeFB2.png',
		'assets/UI/Icons/Fusee/IconFuseeFB3.png',
		'assets/UI/Icons/Fusee/IconFuseeJaune1.png',
		'assets/UI/Icons/Fusee/IconFuseeJaune2.png',
		'assets/UI/Icons/Fusee/IconFuseeJaune3.png',
		'assets/UI/Icons/Fusee/IconFuseeOrange1.png',
		'assets/UI/Icons/Fusee/IconFuseeOrange2.png',
		'assets/UI/Icons/Fusee/IconFuseeOrange3.png',
		'assets/UI/Icons/Fusee/IconFuseeVert1.png',
		'assets/UI/Icons/Fusee/IconFuseeVert2.png',
		'assets/UI/Icons/Fusee/IconFuseeVert3.png',
		'assets/UI/Icons/Fusee/IconFuseeViolet1.png',
		'assets/UI/Icons/Fusee/IconFuseeViolet2.png',
		'assets/UI/Icons/Fusee/IconFuseeViolet3.png',
		'assets/UI/Icons/IconsRessources/IconBlueMineral.png',
		'assets/UI/Icons/IconsRessources/IconCyanMineral.png',
		'assets/UI/Icons/IconsRessources/IconDogeflooz.png',
		'assets/UI/Icons/IconsRessources/IconGreenMineral.png',
		'assets/UI/Icons/IconsRessources/IconOsDor.png',
		'assets/UI/Icons/IconsRessources/IconPurpleMineral.png',
		'assets/UI/Icons/IconsRessources/IconRedMineral.png',
		'assets/UI/Icons/IconsRessources/IconYellowMineral.png',
		'assets/UI/Icons/Planet/IconNamek.png',
		'assets/UI/Icons/Planet/IconPlaneteDesEtoiles.png',
		'assets/UI/Icons/Planet/IconPlaneteMilieu.png',
		'assets/UI/Icons/Planet/IconSpringfield.png',
		'assets/UI/Icons/Planet/IconTerre.png',
		'assets/UI/Icons/Planet/IconWonderland.png',
		'assets/UI/Icons/PreviewRessources/PopInMarketArticlePreviewBlueMineral.png',
		'assets/UI/Icons/PreviewRessources/PopInMarketArticlePreviewCyanMineral.png',
		'assets/UI/Icons/PreviewRessources/PopInMarketArticlePreviewGreenMineral.png',
		'assets/UI/Icons/PreviewRessources/PopInMarketArticlePreviewPurpleMineral.png',
		'assets/UI/Icons/PreviewRessources/PopInMarketArticlePreviewRedMineral.png',
		'assets/UI/Icons/PreviewRessources/PopInMarketArticlePreviewYellowMineral.png',
		'assets/UI/Icons/PreviewRessources/PopInShopArticlePreview2Dogeflooz.png',
		'assets/UI/Icons/PreviewRessources/PopInShopArticlePreview2Os.png',
		'assets/UI/Icons/PreviewRessources/PopInShopArticlePreview3Dogeflooz.png',
		'assets/UI/Icons/PreviewRessources/PopInShopArticlePreview3Os.png',
		'assets/UI/Icons/PreviewRessources/PopInShopArticlePreview4Dogeflooz.png',
		'assets/UI/Icons/PreviewRessources/PopInShopArticlePreview4Os.png',
		'assets/UI/Icons/PreviewRessources/PopInShopArticlePreview5Dogeflooz.png',
		'assets/UI/Icons/PreviewRessources/PopInShopArticlePreview5Os.png',
		'assets/UI/PopIn/ContourNotAfford.png',
		'assets/UI/PopIn/ContourRessourceInsuffisant.png',
		'assets/UI/PopIn/Overlay.png',
		'assets/UI/PopIn/PopInArticleLock.png',
		'assets/UI/PopIn/PopInBackground.png',
		'assets/UI/PopIn/PopInCloseButtonActivel.png',
		'assets/UI/PopIn/PopInCloseButtonNormal.png',
		'assets/UI/PopIn/PopInScrollBackground.png',
		'assets/UI/PopIn/PopInScrollOverlay.png',
		'assets/UI/PopIn/PopInScrollingBar.png',
		'assets/UI/PopIn/PopInScrollingTruc.png',
		'assets/UI/PopInBuilt/PopInBuiltArticleEmptyRessource.png',
		'assets/UI/PopInBuilt/PopInBuiltBgArticle.png',
		'assets/UI/PopInBuilt/PopInBuiltHardActive.png',
		'assets/UI/PopInBuilt/PopInBuiltHardNormal.png',
		'assets/UI/PopInBuilt/PopInBuiltSoftActive.png',
		'assets/UI/PopInBuilt/PopInBuiltSoftNormal.png',
		'assets/UI/PopInBuilt/PopInBuiltSoftNotDispo.png',
		'assets/UI/PopInBuilt/PopInHeaderFusees.png',
		'assets/UI/PopInBuilt/PopInHeaderNiches.png',
		'assets/UI/PopInBuilt/PopInHeaderUtilitaires.png',
		'assets/UI/PopInBuilt/PopInOngletFuseeActive.png',
		'assets/UI/PopInBuilt/PopInOngletFuseeNormal.png',
		'assets/UI/PopInBuilt/PopInOngletNicheActive.png',
		'assets/UI/PopInBuilt/PopInOngletNicheNormal.png',
		'assets/UI/PopInBuilt/PopInOngletUtilitairesActive.png',
		'assets/UI/PopInBuilt/PopInOngletUtilitairesNormal.png',
		'assets/UI/PopInBuilt/PopInTitleConstruction.png',
		'assets/UI/PopInInventory/PopInInventoryArticleBg.png',
		'assets/UI/PopInInventory/PopInInventoryBackground.png',
		'assets/UI/PopInInventory/PopInInventoryCloseButtonActive.png',
		'assets/UI/PopInInventory/PopInInventoryCloseButtonNormal.png',
		'assets/UI/PopInInventory/PopInInventoryScrollingBar.png',
		'assets/UI/PopInInventory/PopInInventoryScrollingTruc.png',
		'assets/UI/PopInInventory/PopInInventoryTitle.png',
		'assets/UI/PopInMarket/PopInHeaderBuy.png',
		'assets/UI/PopInMarket/PopInHeaderSell.png',
		'assets/UI/PopInMarket/PopInMarketBgArticle.png',
		'assets/UI/PopInMarket/PopInMarketNbArticleActive.png',
		'assets/UI/PopInMarket/PopInMarketNbArticleNormal.png',
		'assets/UI/PopInMarket/PopInMarketValidActive.png',
		'assets/UI/PopInMarket/PopInMarketValidNormal.png',
		'assets/UI/PopInMarket/PopInOngletBuyActive.png',
		'assets/UI/PopInMarket/PopInOngletBuyNormal.png',
		'assets/UI/PopInMarket/PopInOngletSellActive.png',
		'assets/UI/PopInMarket/PopInOngletSellNormal.png',
		'assets/UI/PopInMarket/PopInTitleMarket.png',
		'assets/UI/PopInObservatory/PopInObservatoryArticle.png',
		'assets/UI/PopInObservatory/PopInScrollOverlay.png',
		'assets/UI/PopInObservatory/PopInScrollingBar.png',
		'assets/UI/PopInObservatory/PopInScrollingTruc.png',
		'assets/UI/PopInObservatory/PopInTitleObservatory.png',
		'assets/UI/PopInQuest/PopInQuestBgArticle.png',
		'assets/UI/PopInQuest/PopInQuestOngletEnCoursActive.png',
		'assets/UI/PopInQuest/PopInQuestOngletEnCoursNormal.png',
		'assets/UI/PopInQuest/PopInQuestOngletFinishActive.png',
		'assets/UI/PopInQuest/PopInQuestOngletFinishNormal.png',
		'assets/UI/PopInQuest/PopInTitleQuest.png',
		'assets/UI/PopInSocial/PopInShop/PopInHeaderDogflooz.png',
		'assets/UI/PopInSocial/PopInShop/PopInHeaderOsDOr.png',
		'assets/UI/PopInSocial/PopInShop/PopInMarketValidActive.png',
		'assets/UI/PopInSocial/PopInShop/PopInMarketValidNormal.png',
		'assets/UI/PopInSocial/PopInShop/PopInOngletHardActive.png',
		'assets/UI/PopInSocial/PopInShop/PopInOngletHardNormal.png',
		'assets/UI/PopInSocial/PopInShop/PopInOngletSoftActive.png',
		'assets/UI/PopInSocial/PopInShop/PopInOngletSotNormal.png',
		'assets/UI/PopInSocial/PopInShop/PopInShopBgArticle.png',
		'assets/UI/PopInSocial/PopInShop/PopInShopButtonConfirmActive.png',
		'assets/UI/PopInSocial/PopInShop/PopInShopButtonConfirmNormal.png',
		'assets/UI/PopInSocial/PopInShop/PopInTitleShop.png',
		'assets/UI/PopInSocial/PopInSocialArticleBg.png',
		'assets/UI/PopInSocial/PopInSocialBg.png',
		'assets/UI/PopInSocial/PopInSocialButtonDownActivel.png',
		'assets/UI/PopInSocial/PopInSocialButtonDownNormal.png',
		'assets/UI/PopInSocial/PopInSocialButtonTradeActivel.png',
		'assets/UI/PopInSocial/PopInSocialButtonTradeNormal.png',
		'assets/UI/PopInSocial/PopInSocialButtonUpActive.png',
		'assets/UI/PopInSocial/PopInSocialButtonUpNormal.png',
		'assets/UI/PopInSocial/PopInSocialButtonVisitActive.png',
		'assets/UI/PopInSocial/PopInSocialButtonVisitNormal.png',
		'assets/UI/PopInSocial/PopInSocialPhotoBorders.png',
		'assets/UI/PopInWorkshop/FuseeNotReady/PopInWorkshopFuseeNotReadyBlue1.png',
		'assets/UI/PopInWorkshop/FuseeNotReady/PopInWorkshopFuseeNotReadyBlue2.png',
		'assets/UI/PopInWorkshop/FuseeNotReady/PopInWorkshopFuseeNotReadyBlue3.png',
		'assets/UI/PopInWorkshop/FuseeNotReady/PopInWorkshopFuseeNotReadyCyan1.png',
		'assets/UI/PopInWorkshop/FuseeNotReady/PopInWorkshopFuseeNotReadyCyan2.png',
		'assets/UI/PopInWorkshop/FuseeNotReady/PopInWorkshopFuseeNotReadyCyan3.png',
		'assets/UI/PopInWorkshop/FuseeNotReady/PopInWorkshopFuseeNotReadyFb1.png',
		'assets/UI/PopInWorkshop/FuseeNotReady/PopInWorkshopFuseeNotReadyFb2.png',
		'assets/UI/PopInWorkshop/FuseeNotReady/PopInWorkshopFuseeNotReadyFb3.png',
		'assets/UI/PopInWorkshop/FuseeNotReady/PopInWorkshopFuseeNotReadyRed1.png',
		'assets/UI/PopInWorkshop/FuseeNotReady/PopInWorkshopFuseeNotReadyRed2.png',
		'assets/UI/PopInWorkshop/FuseeNotReady/PopInWorkshopFuseeNotReadyRed3.png',
		'assets/UI/PopInWorkshop/FuseeNotReady/PopInWorkshopFuseeNotReadyVert1.png',
		'assets/UI/PopInWorkshop/FuseeNotReady/PopInWorkshopFuseeNotReadyVert2.png',
		'assets/UI/PopInWorkshop/FuseeNotReady/PopInWorkshopFuseeNotReadyVert3.png',
		'assets/UI/PopInWorkshop/FuseeNotReady/PopInWorkshopFuseeNotReadyViolet1.png',
		'assets/UI/PopInWorkshop/FuseeNotReady/PopInWorkshopFuseeNotReadyViolet2.png',
		'assets/UI/PopInWorkshop/FuseeNotReady/PopInWorkshopFuseeNotReadyViolet3.png',
		'assets/UI/PopInWorkshop/FuseeNotReady/PopInWorkshopFuseeNotReadyYellow.png',
		'assets/UI/PopInWorkshop/FuseeNotReady/PopInWorkshopFuseeNotReadyYellow2.png',
		'assets/UI/PopInWorkshop/FuseeNotReady/PopInWorkshopFuseeNotReadyYellow3.png',
		'assets/UI/PopInWorkshop/FuseeReady/PopInWorkshopFuseeReadyBlue1.png',
		'assets/UI/PopInWorkshop/FuseeReady/PopInWorkshopFuseeReadyBlue2.png',
		'assets/UI/PopInWorkshop/FuseeReady/PopInWorkshopFuseeReadyBlue3.png',
		'assets/UI/PopInWorkshop/FuseeReady/PopInWorkshopFuseeReadyCyan1.png',
		'assets/UI/PopInWorkshop/FuseeReady/PopInWorkshopFuseeReadyCyan2.png',
		'assets/UI/PopInWorkshop/FuseeReady/PopInWorkshopFuseeReadyCyan3.png',
		'assets/UI/PopInWorkshop/FuseeReady/PopInWorkshopFuseeReadyFb1.png',
		'assets/UI/PopInWorkshop/FuseeReady/PopInWorkshopFuseeReadyFb2.png',
		'assets/UI/PopInWorkshop/FuseeReady/PopInWorkshopFuseeReadyFb3.png',
		'assets/UI/PopInWorkshop/FuseeReady/PopInWorkshopFuseeReadyRed1.png',
		'assets/UI/PopInWorkshop/FuseeReady/PopInWorkshopFuseeReadyRed2.png',
		'assets/UI/PopInWorkshop/FuseeReady/PopInWorkshopFuseeReadyRed3.png',
		'assets/UI/PopInWorkshop/FuseeReady/PopInWorkshopFuseeReadyVert1.png',
		'assets/UI/PopInWorkshop/FuseeReady/PopInWorkshopFuseeReadyVert2.png',
		'assets/UI/PopInWorkshop/FuseeReady/PopInWorkshopFuseeReadyVert3.png',
		'assets/UI/PopInWorkshop/FuseeReady/PopInWorkshopFuseeReadyViolet0.png',
		'assets/UI/PopInWorkshop/FuseeReady/PopInWorkshopFuseeReadyViolet1.png',
		'assets/UI/PopInWorkshop/FuseeReady/PopInWorkshopFuseeReadyViolet3.png',
		'assets/UI/PopInWorkshop/FuseeReady/PopInWorkshopFuseeReadyYellow1.png',
		'assets/UI/PopInWorkshop/FuseeReady/PopInWorkshopFuseeReadyYellow2.png',
		'assets/UI/PopInWorkshop/FuseeReady/PopInWorkshopFuseeReadyYellow3.png',
		'assets/UI/PopInWorkshop/PopInTitleWorkshop.png',
		'assets/UI/PopInWorkshop/PopInWorkshopArticleBG.png',
		'assets/UI/PopInWorkshop/PopInWorkshopBgPlanet.png',
		'assets/UI/PopInWorkshop/PopInWorkshopCancelButtonActive.png',
		'assets/UI/PopInWorkshop/PopInWorkshopCancelButtonNormal.png',
		'assets/UI/PopInWorkshop/PopInWorkshopDestroyButtonActive.png',
		'assets/UI/PopInWorkshop/PopInWorkshopDestroyButtonNormal.png',
		'assets/UI/PopInWorkshop/PopInWorkshopHeader.png',
		'assets/UI/PopInWorkshop/PopInWorkshopLaunchButtonActive.png',
		'assets/UI/PopInWorkshop/PopInWorkshopLaunchButtonNormal.png',
		'assets/UI/PopInWorkshop/PopInWorkshopLoadFill1.png',
		'assets/UI/PopInWorkshop/PopInWorkshopLoadFill2.png',
		'assets/UI/PopInWorkshop/PopInWorkshopLoadFillBar.png',
		'assets/UI/PopInWorkshop/PopInWorkshopLoadIcon.png',
		'assets/UI/PopInWorkshop/PopInWorkshopParticule.png',
		'assets/UI/PopInWorkshop/PopInWorkshopTextBG.png',
		'assets/UI/PopInWorkshop/hammer/PopInWorkshopHammerIdle01.png',
		'assets/UI/PopInWorkshop/hammer/PopInWorkshopHammerIdle02.png',
		'assets/UI/PopInWorkshop/hammer/PopInWorkshopHammerIdle03.png',
		'assets/UI/PopInWorkshop/hammer/PopInWorkshopHammerIdle04.png',
		'assets/UI/PopInWorkshop/hammer/PopInWorkshopHammerIdle05.png',
		'assets/UI/PopInWorkshop/hammer/PopInWorkshopHammerIdle06.png',
		'assets/UI/PopInWorkshop/hammer/PopInWorkshopHammerIdle07.png',
		'assets/UI/PopInWorkshop/hammer/PopInWorkshopHammerIdle08.png',
		'assets/UI/PopInWorkshop/hammer/PopInWorkshopHammerIdle09.png',
		'assets/UI/PopInWorkshop/hammer/PopInWorkshopHammerIdle10.png',
		'assets/UI/PopInWorkshop/hammer/PopInWorkshopHammerOnClick01.png',
		'assets/UI/PopInWorkshop/hammer/PopInWorkshopHammerOnClick02.png',
		'assets/UI/PopInWorkshop/hammer/PopInWorkshopHammerOnClick03.png',
		'assets/UI/PopInWorkshop/hammer/PopInWorkshopHammerOnClick04.png',
		'assets/UI/PopInWorkshop/hammer/PopInWorkshopHammerOnClick05.png',
		'assets/UI/PopInWorkshop/hammer/PopInWorkshopHammerOnClick06.png',
		'assets/UI/SplashScreen/LoadingFill01.png',
		'assets/UI/SplashScreen/LoadingFill02.png',
		'assets/UI/SplashScreen/LoadingFill03.png',
		'assets/UI/SplashScreen/LoadingFillBar.png',
		'assets/UI/SplashScreen/Planet.png',
		'assets/UI/SplashScreen/PlanetGlow/PlanetGlow01.png',
		'assets/UI/SplashScreen/PlanetGlow/PlanetGlow02.png',
		'assets/UI/SplashScreen/PlanetGlow/PlanetGlow03.png',
		'assets/UI/SplashScreen/PlanetGlow/PlanetGlow04.png',
		'assets/UI/SplashScreen/PlanetGlow/PlanetGlow05.png',
		'assets/UI/SplashScreen/PlanetGlow/PlanetGlow06.png',
		'assets/UI/SplashScreen/PlanetGlow/PlanetGlow07.png',
		'assets/UI/SplashScreen/PlanetGlow/PlanetGlow08.png',
		'assets/UI/SplashScreen/PlanetGlow/PlanetGlow09.png',
		'assets/UI/SplashScreen/PlanetGlow/PlanetGlow10.png',
		'assets/UI/SplashScreen/PlanetGlow/PlanetGlow11.png',
		'assets/UI/SplashScreen/PlanetLight.png',
		'assets/UI/SplashScreen/Title.png'
 	];
 	public static var ressources:Map<String,Dynamic> = [
 		'poudre0' => {
 			name: 'PLPP Yellow', //plpp stands for perlimpinpin
 			previewImg: 'assets/UI/Icons/PreviewRessources/PopInMarketArticlePreviewYellowMineral.png',
 			iconImg: 'assets/UI/Icons/IconsRessources/IconYellowMineral.png',
 			userPossion: 5,
 			buyCost: 10,
 			sellCost: 5,
 			lastQuantityBuy: 0,
 			lastQuantitySell: 0
 		},
 		'poudre1' => {
 			name: 'PLPP Green',
 			previewImg: 'assets/UI/Icons/PreviewRessources/PopInMarketArticlePreviewGreenMineral.png',
 			iconImg: 'assets/UI/Icons/IconsRessources/IconGreenMineral.png',
 			userPossion: 3,
 			buyCost: 25,
 			sellCost: 10,
 			lastQuantityBuy: 0,
 			lastQuantitySell: 0
 		},
 		'poudre2' => {
 			name: 'PLPP Cyan',
 			previewImg: 'assets/UI/Icons/PreviewRessources/PopInMarketArticlePreviewCyanMineral.png',
 			iconImg: 'assets/UI/Icons/IconsRessources/IconCyanMineral.png',
 			userPossion: 5,
 			buyCost: 50,
 			sellCost: 25,
 			lastQuantityBuy: 0,
 			lastQuantitySell: 0
 		},
 		'poudre3' => { 
 			name: 'PLPP Blue',
 			previewImg: 'assets/UI/Icons/PreviewRessources/PopInMarketArticlePreviewBlueMineral.png',
 			iconImg: 'assets/UI/Icons/IconsRessources/IconBlueMineral.png',
 			userPossion: 5,
 			buyCost: 100,
 			sellCost: 40,
 			lastQuantityBuy: 0,
 			lastQuantitySell: 0
 		}, 		
 		'poudre4' => {
 			name: 'PLPP Purple',
 			previewImg: 'assets/UI/Icons/PreviewRessources/PopInMarketArticlePreviewPurpleMineral.png',
 			iconImg: 'assets/UI/Icons/IconsRessources/IconPurpleMineral.png',
 			userPossion: 5,
 			buyCost: 300,
 			sellCost: 200,
 			lastQuantityBuy: 0,
 			lastQuantitySell: 0
 		},
 		'poudre5' => {
 			name: 'PLPP Red',
 			previewImg: 'assets/UI/Icons/PreviewRessources/PopInMarketArticlePreviewRedMineral.png',
 			iconImg: 'assets/UI/Icons/IconsRessources/IconRedMineral.png',
 			userPossion: 5,
 			buyCost: 1000,
 			sellCost: 700,
 			lastQuantityBuy: 0,
 			lastQuantitySell: 0
 		},
 		'fric' => {
 			name: 'Dogeflooz',
 			previewImg: 'assets/UI/Icons/PreviewRessources/PopInShopArticlePreview2Dogeflooz.png',
 			iconImg: 'assets/UI/Icons/IconsRessources/IconDogeflooz.png',
 			userPossion: 15000,
 		},
 		'hardMoney' => {
 			name: "Os D'or",
 			previewImg: 'assets/UI/Icons/PreviewRessources/PopInShopArticlePreview2Os.png',
 			iconImg: 'assets/UI/Icons/IconsRessources/IconOsDor.png',
 			userPossion: 150,
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
 				previewImg: 'assets/UI/Icons/Buildings/PopInBuiltArticlePreviewNiche.png',
 				title: 'Niche en Bois',
 				description: "L'association des travailleurs canins (l'ATC) impose un logement de fonction.\nDonc pour faire court niches = employés.",
 				hardPrice: 3,
 				ressources: [
 					{"name":"fric","quantity":"1000"},
 					{"name":"poudre0","quantity":"10"},
 					{"name":"poudre1","quantity":"25"},
 				]
 			},
 		],
 		"spacechips": [
 			{
 				previewImg: 'assets/UI/Icons/Buildings/PopInBuiltArticlePreviewHangar1.png',
 				title: 'Atelier Destination SprungField',
 				description: 'Boite magique où les fusées sont assemblées avec amour et bonne humeur.\nToute les rumeur au sujet des coups de fouet électrique ne sont que calomnies.',
 				hardPrice: 3,
 				ressources: [
 					{"name":"fric","quantity":"1000"},
 					{"name":"poudre2","quantity":"10"},
 					{"name":"poudre1","quantity":"25"},
 				]
 			},
 			{
 				previewImg: 'assets/UI/Icons/Buildings/PopInBuiltArticlePreviewHangar2.png',
 				title: 'Atelier Destination Modor',
 				description: "Cet atelier construit des fusées grâce au pouvoir de l’amitié et à des techniques\n de management éprouvés.",
 				hardPrice: 3,
 				ressources: [
 					{"name":"fric","quantity":"1000"},
 					{"name":"poudre0","quantity":"10"},
 					{"name":"poudre5","quantity":"250"},
 				]
 			},
 			{
 				previewImg: 'assets/UI/Icons/Buildings/PopInBuiltArticlePreviewHangar3.png',
 				title: 'Atelier Destination Namok',
 				description: "Dans cet atelier les employés sont les plus heureux au monde.\nLes semaines de 169 heures ne sont bien sur qu'un mythe.",
 				hardPrice: 3,
 				ressources: [
 					{"name":"fric","quantity":"1000"},
 					{"name":"poudre3","quantity":"10"},
 					{"name":"poudre4","quantity":"25"},
 				]
 			}, 			
 			{
 				previewImg: 'assets/UI/Icons/Buildings/PopInBuiltArticlePreviewHangar4.png',
 				title: 'Atelier Destination Terre',
 				description: "Dans cet atelier, aucun incident n'a jamais été rapporté à la direction\net ce n'est absolument pas par crainte de représailles.",
 				hardPrice: 3,
 				ressources: [
 					{"name":"fric","quantity":"1000"},
 					{"name":"poudre0","quantity":"10"},
 					{"name":"poudre1","quantity":"25"},
 				]
 			},
 			{
 				previewImg: 'assets/UI/Icons/Buildings/PopInBuiltArticlePreviewHangar5.png',
 				title: 'Atelier Destination Wundërland',
 				description: "Les soupçons des conséquences mortelles liés à la manipulation\n des moteurs à Dogetonium ont été réfutés par le professeur Van-Du.",
 				hardPrice: 3,
 				ressources: [
 					{"name":"fric","quantity":"1000"},
 					{"name":"poudre0","quantity":"10"},
 					{"name":"poudre1","quantity":"25"},
 				]
 			},
 			{
 				previewImg: 'assets/UI/Icons/Buildings/PopInBuiltArticlePreviewHangar6.png',
 				title: 'Atelier Destination StarWat',
 				description: "Cet atelier utilise uniquement des huiles écologiques.\nQui ne sont en aucun cas faites a partir de travailleurs retraités.",
 				hardPrice: 3,
 				ressources: [
 					{"name":"fric","quantity":"1000"},
 					{"name":"poudre0","quantity":"10"},
 					{"name":"poudre1","quantity":"25"},
 				]
 			},
 			
 		],
 		"utilitaires": [
 			{
 				previewImg: 'assets/UI/Icons/Buildings/popInBuiltArticlePreviewCasino.png',
 				title: 'Casino',
 				description: "Un établissement haut de gamme qui ne propose que des jeux honnêtes\npermettant à nos fiers travailleurs de se détendre.",
 				hardPrice: 3,
 				ressources: [
 					{"name":"fric","quantity":"1000"},
 					{"name":"poudre0","quantity":"10"},
 					{"name":"poudre1","quantity":"25"},
 				]
 			},
 			{
 				previewImg: 'assets/UI/Icons/Buildings/PopInBuiltArticlePreviewEglise.png',
 				title: 'Église',
 				description: "Une modeste chapelle où nos employés implorent le grand manitou\nde nous accorder des finances prospères.",
 				hardPrice: 3,
 				ressources: [
 					{"name":"fric","quantity":"1000"},
 					{"name":"poudre0","quantity":"10"},
 					{"name":"poudre1","quantity":"25"},
 				]
 			},
 			{
 				previewImg: 'assets/UI/Icons/Buildings/PopInBuiltArticlePreviewEntrepot.png',
 				title: 'Entrepot',
 				description: "Les Entrepôts servent à stocker toutes les ressources physiques,\net absolument pas à faire un trafic de substances douteuses.",
 				hardPrice: 3,
 				ressources: [
 					{"name":"fric","quantity":"1000"},
 					{"name":"poudre0","quantity":"10"},
 					{"name":"poudre1","quantity":"25"},
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
 	

	public static var BUILDINGS_CONFIG: Map<Int, Dynamic<String>> = [
		/* img format : "XXX_NN.png" */

		Building.CASINO | Building.LVL_1 => {
			width: "3",
			height: "3",
			vertical_dir: "0",
			building_time: "30",
			frames_nb: "1",
			img: "./assets/Buildings/CasinoLv1.png"
		},
		Building.CASINO | Building.LVL_2 => {
			width: "3",
			height: "3",
			vertical_dir: "0",
			building_time: "60",
			frames_nb: "1",
			img: "./assets/Buildings/CasinoLv2.png"
		},
		Building.CASINO | Building.LVL_3 => {
			width: "3",
			height: "3",
			vertical_dir: "0",
			building_time: "90",
			frames_nb: "1",
			img: "./assets/Buildings/CasinoLv3.png"
		},
		Building.EGLISE | Building.LVL_1 => {
			width: "3",
			height: "3",
			vertical_dir: "0",
			building_time: "30",
			frames_nb: "1",
			img: "./assets/Buildings/CasinoLv1.png"
		},
		Building.EGLISE | Building.LVL_2 => {
			width: "3",
			height: "3",
			vertical_dir: "0",
			building_time: "60",
			frames_nb: "1",
			img: "./assets/Buildings/CasinoLv2.png"
		},
		Building.EGLISE | Building.LVL_3 => {
			width: "3",
			height: "3",
			vertical_dir: "0",
			building_time: "90",
			frames_nb: "1",
			img: "./assets/Buildings/CasinoLv3.png"
		},
		Building.HANGAR_1 | Building.LVL_1 => {
			width: "3",
			height: "2",
			vertical_dir: "-1",
			building_time: "30",
			frames_nb: "1",
			img: "./assets/Buildings/Hangar1Lv1.png"
		},
		Building.HANGAR_1 | Building.LVL_2 => {
			width: "3",
			height: "2",
			vertical_dir: "-1",
			building_time: "60",
			frames_nb: "1",
			img: "./assets/Buildings/Hangar1Lv2.png"
		},
		Building.HANGAR_1 | Building.LVL_3 => {
			width: "3",
			height: "2",
			vertical_dir: "-1",
			building_time: "90",
			frames_nb: "1",
			img: "./assets/Buildings/Hangar1Lv3.png"
		},
		Building.HANGAR_2 | Building.LVL_1 => {
			width: "3",
			height: "2",
			vertical_dir: "-1",
			building_time: "30",
			frames_nb: "1",
			img: "./assets/Buildings/Hangar1Lv1.png"
		},
		Building.HANGAR_2 | Building.LVL_2 => {
			width: "3",
			height: "2",
			vertical_dir: "-1",
			building_time: "60",
			frames_nb: "1",
			img: "./assets/Buildings/Hangar1Lv2.png"
		},
		Building.HANGAR_2 | Building.LVL_3 => {
			width: "3",
			height: "2",
			vertical_dir: "-1",
			building_time: "90",
			frames_nb: "1",
			img: "./assets/Buildings/Hangar1Lv3.png"
		},
		Building.HANGAR_3 | Building.LVL_1 => {
			width: "3",
			height: "2",
			vertical_dir: "-1",
			building_time: "30",
			frames_nb: "1",
			img: "./assets/Buildings/Hangar1Lv1.png"
		},
		Building.HANGAR_3 | Building.LVL_2 => {
			width: "3",
			height: "2",
			vertical_dir: "-1",
			building_time: "60",
			frames_nb: "1",
			img: "./assets/Buildings/Hangar1Lv2.png"
		},
		Building.HANGAR_3 | Building.LVL_3 => {
			width: "3",
			height: "2",
			vertical_dir: "-1",
			building_time: "90",
			frames_nb: "1",
			img: "./assets/Buildings/Hangar1Lv3.png"
		},
		Building.HANGAR_4 | Building.LVL_1 => {
			width: "3",
			height: "2",
			vertical_dir: "-1",
			building_time: "30",
			frames_nb: "1",
			img: "./assets/Buildings/Hangar1Lv1.png"
		},
		Building.HANGAR_4 | Building.LVL_2 => {
			width: "3",
			height: "2",
			vertical_dir: "-1",
			building_time: "60",
			frames_nb: "1",
			img: "./assets/Buildings/Hangar1Lv2.png"
		},
		Building.HANGAR_4 | Building.LVL_3 => {
			width: "3",
			height: "2",
			vertical_dir: "-1",
			building_time: "90",
			frames_nb: "1",
			img: "./assets/Buildings/Hangar1Lv3.png"
		},
		Building.HANGAR_5 | Building.LVL_1 => {
			width: "3",
			height: "2",
			vertical_dir: "-1",
			building_time: "30",
			frames_nb: "1",
			img: "./assets/Buildings/Hangar1Lv1.png"
		},
		Building.HANGAR_5 | Building.LVL_2 => {
			width: "3",
			height: "2",
			vertical_dir: "-1",
			building_time: "60",
			frames_nb: "1",
			img: "./assets/Buildings/Hangar1Lv2.png"
		},
		Building.HANGAR_5 | Building.LVL_3 => {
			width: "3",
			height: "2",
			vertical_dir: "-1",
			building_time: "90",
			frames_nb: "1",
			img: "./assets/Buildings/Hangar1Lv3.png"
		},
		Building.HANGAR_6 | Building.LVL_1 => {
			width: "3",
			height: "2",
			vertical_dir: "-1",
			building_time: "30",
			frames_nb: "1",
			img: "./assets/Buildings/Hangar1Lv1.png"
		},
		Building.HANGAR_6 | Building.LVL_2 => {
			width: "3",
			height: "2",
			vertical_dir: "-1",
			building_time: "60",
			frames_nb: "1",
			img: "./assets/Buildings/Hangar1Lv2.png"
		},
		Building.HANGAR_6 | Building.LVL_3 => {
			width: "3",
			height: "2",
			vertical_dir: "-1",
			building_time: "90",
			frames_nb: "1",
			img: "./assets/Buildings/Hangar1Lv3.png"
		},
		Building.LABO | Building.LVL_1 => {
			width: "2",
			height: "2",
			vertical_dir: "0",
			building_time: "30",
			frames_nb: "1",
			img: "./assets/Buildings/CasinoLv1.png"
		},
		Building.LABO | Building.LVL_2 => {
			width: "2",
			height: "2",
			vertical_dir: "0",
			building_time: "60",
			frames_nb: "1",
			img: "./assets/Buildings/CasinoLv2.png"
		},
		Building.LABO | Building.LVL_3 => {
			width: "3",
			height: "2",
			vertical_dir: "1",
			building_time: "90",
			frames_nb: "1",
			img: "./assets/Buildings/CasinoLv3.png"
		},
		Building.NICHE | Building.LVL_1 => {
			width: "1",
			height: "1",
			vertical_dir: "0",
			building_time: "30",
			frames_nb: "1",
			img: "./assets/Buildings/CasinoLv1.png"
		},
		Building.NICHE | Building.LVL_2 => {
			width: "1",
			height: "1",
			vertical_dir: "0",
			building_time: "60",
			frames_nb: "1",
			img: "./assets/Buildings/CasinoLv2.png"
		},
		Building.NICHE | Building.LVL_3 => {
			width: "1",
			height: "1",
			vertical_dir: "0",
			building_time: "90",
			frames_nb: "1",
			img: "./assets/Buildings/CasinoLv3.png"
		},
		Building.PAS_DE_TIR | Building.LVL_1 => {
			width: "5",
			height: "5",
			vertical_dir: "0",
			building_time: "30",
			frames_nb: "1",
			img: "./assets/Buildings/CasinoLv1.png"
		},
		Building.PAS_DE_TIR | Building.LVL_2 => {
			width: "5",
			height: "5",
			vertical_dir: "0",
			building_time: "60",
			frames_nb: "1",
			img: "./assets/Buildings/CasinoLv2.png"
		},
		Building.PAS_DE_TIR | Building.LVL_3 => {
			width: "5",
			height: "5",
			vertical_dir: "0",
			building_time: "90",
			frames_nb: "1",
			img: "./assets/Buildings/CasinoLv3.png"
		}
	];

	/*	config[ CASINO | LVL_1 ] = 		{ width: 3, height: 3, vertical_dir: 0, img_i: 0 }; // + (buildingTime -> à récup sur le serveur)
		config[ CASINO | LVL_2 ] = 		{ width: 3, height: 3, vertical_dir: 0, img_i: 1 };
		config[ CASINO | LVL_3 ] = 		{ width: 3, height: 3, vertical_dir: 0, img_i: 2 };
		config[ EGLISE | LVL_1 ] = 		{ width: 3, height: 3, vertical_dir: 0, img_i: 3 };
		config[ EGLISE | LVL_2 ] = 		{ width: 3, height: 3, vertical_dir: 0, img_i: 4 };
		config[ EGLISE | LVL_3 ] = 		{ width: 3, height: 3, vertical_dir: 0, img_i: 5 };
		config[ HANGAR_1 | LVL_1 ] = 	{ width: 3, height: 2, vertical_dir: -1, img_i: 6 };
		config[ HANGAR_1 | LVL_2 ] = 	{ width: 3, height: 2, vertical_dir: -1, img_i: 7 };
		config[ HANGAR_1 | LVL_3 ] = 	{ width: 3, height: 2, vertical_dir: -1, img_i: 8 };
		config[ HANGAR_2 | LVL_1 ] = 	{ width: 3, height: 2, vertical_dir: -1, img_i: 9 };
		config[ HANGAR_2 | LVL_2 ] = 	{ width: 3, height: 2, vertical_dir: -1, img_i: 10 };
		config[ HANGAR_2 | LVL_3 ] = 	{ width: 3, height: 2, vertical_dir: -1, img_i: 11 };
		config[ HANGAR_3 | LVL_1 ] = 	{ width: 3, height: 2, vertical_dir: -1, img_i: 12 };
		config[ HANGAR_3 | LVL_2 ] = 	{ width: 3, height: 2, vertical_dir: -1, img_i: 13 };
		config[ HANGAR_3 | LVL_3 ] = 	{ width: 3, height: 2, vertical_dir: -1, img_i: 14 };
		config[ HANGAR_4 | LVL_1 ] = 	{ width: 3, height: 2, vertical_dir: -1, img_i: 15 };
		config[ HANGAR_4 | LVL_2 ] = 	{ width: 3, height: 2, vertical_dir: -1, img_i: 16 };
		config[ HANGAR_4 | LVL_3 ] = 	{ width: 3, height: 2, vertical_dir: -1, img_i: 17 };
		config[ HANGAR_5 | LVL_1 ] = 	{ width: 3, height: 2, vertical_dir: -1, img_i: 18 };
		config[ HANGAR_5 | LVL_2 ] = 	{ width: 3, height: 2, vertical_dir: -1, img_i: 19 };
		config[ HANGAR_5 | LVL_3 ] = 	{ width: 3, height: 2, vertical_dir: -1, img_i: 20 };
		config[ HANGAR_6 | LVL_1 ] = 	{ width: 3, height: 2, vertical_dir: -1, img_i: 21 };
		config[ HANGAR_6 | LVL_2 ] = 	{ width: 3, height: 2, vertical_dir: -1, img_i: 22 };
		config[ HANGAR_6 | LVL_3 ] = 	{ width: 3, height: 2, vertical_dir: -1, img_i: 23 };
		config[ LABO | LVL_1 ] = 		{ width: 2, height: 2, vertical_dir: 0, img_i: 24 };
		config[ LABO | LVL_2 ] = 		{ width: 2, height: 2, vertical_dir: 0, img_i: 25 };
		config[ LABO | LVL_3 ] = 		{ width: 3, height: 2, vertical_dir: 1, img_i: 26 };
		config[ NICHE | LVL_1 ] = 		{ width: 1, height: 1, vertical_dir: 0, img_i: 27 };
		config[ NICHE | LVL_2 ] = 		{ width: 1, height: 1, vertical_dir: 0, img_i: 28 };
		config[ NICHE | LVL_3 ] = 		{ width: 1, height: 1, vertical_dir: 0, img_i: 29 };
		config[ PAS_DE_TIR | LVL_1 ] = 	{ width: 5, height: 3, vertical_dir: 0, img_i: 30 };
		config[ PAS_DE_TIR | LVL_2 ] = 	{ width: 5, height: 3, vertical_dir: 0, img_i: 31 };
		config[ PAS_DE_TIR | LVL_3 ] = 	{ width: 5, height: 3, vertical_dir: 0, img_i: 32 };
		*/
}