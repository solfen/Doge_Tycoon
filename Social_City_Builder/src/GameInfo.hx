package;

// class that store informations of the game in statics var so that it can be acces anywhere
// the player stats will most likely be here
class GameInfo
{
	public static var preloadAssets:Array<String> = [
		'assets/UI/SplashScreen/IconsSplash.jpg',
	];
 	public static var loadAssets:Array<String> = [
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
	'assets/UI/PopInMarket/PopInMarketNbArticleActivel.png',
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
	'assets/UI/SplashScreen/Title.png',
 	];
 	public static var buildMenuArticles:Dynamic = {
 		"niches": [
 			{
 				img: 'PopInBuiltArticlePreviewNiche',
 				hardPrice: 3,
 				ressources: [
 					{"img":"IconDogeflooz","price":"1000"},
 					{"img":"IconDogeflooz","price":"1000"},
 					{"img":"IconDogeflooz","price":"1000"},
 				]
 			},
 		],
 		"spacechips": [
 			 {
 				img: 'PopInBuiltArticlePreviewHangar1',
 				hardPrice: 3,
 				ressources: [
 					{"img":"IconDogeflooz","price":"1000"},
 					{"img":"IconDogeflooz","price":"1000"},
 					{"img":"IconDogeflooz","price":"1000"},
 				]
 			},
 			{
 				img: 'PopInBuiltArticlePreviewHangar2',
 				hardPrice: 3,
 				ressources: [
 					{"img":"IconDogeflooz","price":"1000"},
 					{"img":"IconDogeflooz","price":"1000"},
 					{"img":"IconDogeflooz","price":"1000"},
 				]
 			},
 			{
 				img: 'PopInBuiltArticlePreviewHangar3',
 				hardPrice: 3,
 				ressources: [
 					{"img":"IconDogeflooz","price":"1000"},
 					{"img":"IconDogeflooz","price":"1000"},
 					{"img":"IconDogeflooz","price":"1000"},
 				]
 			}, 			
 			{
 				img: 'PopInBuiltArticlePreviewHangar4',
 				hardPrice: 3,
 				ressources: [
 					{"img":"IconDogeflooz","price":"1000"},
 					{"img":"IconDogeflooz","price":"1000"},
 					{"img":"IconDogeflooz","price":"1000"},
 				]
 			},
 			{
 				img: 'PopInBuiltArticlePreviewHangar5',
 				hardPrice: 3,
 				ressources: [
 					{"img":"IconDogeflooz","price":"1000"},
 					{"img":"IconDogeflooz","price":"1000"},
 					{"img":"IconDogeflooz","price":"1000"},
 				]
 			},
 			
 		],
 		"utilitaires": [
 			{
 				img: 'PopInBuiltArticlePreviewCasino',
 				hardPrice: 3,
 				ressources: [
 					{"img":"IconDogeflooz","price":"1000"},
 					{"img":"IconDogeflooz","price":"1000"},
 					{"img":"IconDogeflooz","price":"1000"},
 				]
 			},
 			{
 				img: 'PopInBuiltArticlePreviewEglise',
 				hardPrice: 3,
 				ressources: [
 					{"img":"IconDogeflooz","price":"1000"},
 					{"img":"IconDogeflooz","price":"1000"},
 					{"img":"IconDogeflooz","price":"1000"},
 				]
 			},
 			{
 				img: 'PopInBuiltArticlePreviewEntrepot',
 				hardPrice: 3,
 				ressources: [
 					{"img":"IconDogeflooz","price":"1000"},
 					{"img":"IconDogeflooz","price":"1000"},
 					{"img":"IconDogeflooz","price":"1000"},
 				]
 			},
 		],
 	};
 	public static var userWidth:Float=1920;
 	public static var userHeight:Float=1000;
 	public static var fric:Float = 15000;
 	public static var hardMoney:Float = 150;
 	public static var dogeNumber:Float = 20;
 	public static var dogeMaxNumber:Float = 25;
 	public static var stockPercent:Float = 50;
}