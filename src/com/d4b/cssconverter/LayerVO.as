﻿package com.d4b.cssconverter{	public class LayerVO	{		public var image:Object = {			"source": "",			"type": "static",			"width": 100,			"height": 100		};				public var frames:Array = [];				public var classname:String;				public function set source ( val:String){			image.source = val;		}				public function setDimensions ( width:Number, height:Number){			image.width = width;			image.height = height;		}				public function LayerVO()		{					}	}}