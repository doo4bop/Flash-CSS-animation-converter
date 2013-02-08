﻿package com.d4b.cssconverter{	import flash.display.MovieClip;	import flash.filesystem.*;	import flash.events.Event;	import flash.events.MouseEvent;	import flash.net.URLLoader;	import flash.net.URLRequest;	import com.adobe.serialization.json.JSON;	public class BuildAnimation extends MovieClip	{		private const PATH:String = 'd4b_css_animations/';		private const CSSPATH:String = 'css/';		private const CSS_FILE:String = 'd4b_animation.css';		private const TEMPLATES:String = 'templates/';		private const BASE_FILES:String = TEMPLATES + 'basefiles';		public var bundleFiles:File;		public var chapterID:Number;		public var bannerName:String;		public var bundlePath:String;		public var panel:Panel;		public var gui	:Gui;		public function BuildAnimation()		{			gui.visible = false;			loadTemplates();		}			//TODO: improve templates loading logic		public function loadTemplates()		{			trace("TEMPLATES", TEMPLATES + "index" );			var indexLoader:URLLoader = new URLLoader();			indexLoader.addEventListener(Event.COMPLETE, indexLoaderResponse);			indexLoader.load(new URLRequest( TEMPLATES +"index"));			var animationLoader:URLLoader = new URLLoader();			animationLoader.addEventListener(Event.COMPLETE, animationLoaderResponse);			animationLoader.load(new URLRequest( TEMPLATES + "animation"));			var imageLoader:URLLoader = new URLLoader();			imageLoader.addEventListener(Event.COMPLETE, imageLoaderResponse);			imageLoader.load(new URLRequest( TEMPLATES + "image"));			var animaLoader:URLLoader = new URLLoader();			animaLoader.addEventListener(Event.COMPLETE, animationBaseResponse);			animaLoader.load(new URLRequest( TEMPLATES + "animation_base"));		}		function animationLoaderResponse(e:Event):void		{			Templates.animation = e.target.data;			checkTemplates();		}		function indexLoaderResponse(e:Event):void		{			Templates.index = e.target.data;			checkTemplates();		}		function imageLoaderResponse(e:Event):void		{			Templates.image = e.target.data;			checkTemplates();		}		function animationBaseResponse(e:Event):void		{			Templates.animation_base = e.target.data;		}		public function checkTemplates()		{			if (! ! Templates.animation && ! ! Templates.image && ! ! Templates.index)			{				gui.visible = true;				init();			}		}		public function init()		{			createDestinationFolder();			gui.addEventListener( Gui.BATCH_CLICKED, saveBundle);		}		private function createDestinationFolder()		{			var file:File = File.documentsDirectory;			file = file.resolvePath(PATH);			if (! file.isDirectory)			{				file.createDirectory();			}		}		public function saveBundle( e:Event = null)		{			if (!!Config.log){				Config.log(':: CONVERTER :: Started');			}			bannerName = Config.animationName;			bundlePath = PATH + bannerName;			Templates.path = bundlePath;						createBundleDir();			moveAssets();			Panel(panel).addEventListener( Panel.IMAGES_BUILDED, createHtml);			Panel(panel).addEventListener( Panel.TRANSITION_DONE, writeCSS);			Panel(panel).batch();		}		public function moveAssets()		{			var file:File = File.applicationDirectory;			file = file.resolvePath(BASE_FILES);			file.copyTo( bundleFiles, true );		}		public function createBundleDir()		{			bundleFiles = File.documentsDirectory;			bundleFiles = bundleFiles.resolvePath(bundlePath);			if (bundleFiles.isDirectory)			{				bundleFiles.deleteDirectory(true);			}			bundleFiles.createDirectory();		}		public function createHtml(e:Event=null)		{			var indexdata:Object = {};			indexdata['animation-images'] = Panel(panel).imagesMarkup;			var indexMarkup:String = Templates.populate(Templates.index,indexdata);			var file:File = File.documentsDirectory;			file = file.resolvePath(bundlePath + '/index.html');			var fileStream:FileStream = new FileStream();			fileStream.open(file, FileMode.WRITE);			fileStream.writeUTFBytes( indexMarkup );			fileStream.close();						if (!!Config.log){				Config.log(':: HTML created');			}		}		public function writeCSS( e:Event = null)		{			var cssdata:Object = {};			cssdata.width = Math.round( stage.stageWidth );			cssdata.height = Math.round( stage.stageHeight );						var bannerclass:String = Templates.populate( Templates.animation_base, cssdata );			var animationCSS:String = bannerclass + Panel(panel).animationCSS;			var file:File = File.documentsDirectory;			file = file.resolvePath(bundlePath + '/css/'+ CSS_FILE);			var fileStream:FileStream = new FileStream();			fileStream.open(file, FileMode.WRITE);			fileStream.writeUTFBytes( animationCSS );			fileStream.close();					if (!!Config.log){				Config.log(':: CSS created');			}						if (!!Config.log){				Config.log('Animation saved in: \n	' + bundleFiles.url );			}		}	}}