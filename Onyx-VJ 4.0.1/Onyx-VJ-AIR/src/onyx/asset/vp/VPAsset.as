/**
 * Copyright (c) 2003-2010 "Onyx-VJ Team" which is comprised of:
 *
 * Daniel Hai
 * Stefano Cottafavi
 * Bruce Lane
 *
 * All rights reserved.
 *
 * Licensed under the CREATIVE COMMONS Attribution-Noncommercial-Share Alike 3.0
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at: http://creativecommons.org/licenses/by-nc-sa/3.0/us/
 *
 * Please visit http://www.onyx-vj.com for more information
 * 
 */
package onyx.asset.vp {
	
	import flash.display.*;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.media.*;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.text.*;
	
	import onyx.asset.*;
	
	/**
	 * 
	 */
	public final class VPAsset extends AssetFile {
		
		/**
		 * 	@private
		 */
		private var url:String;
		private var thumbUrl:String;
		private var assetName:String;
		private var ext:String;
		
		/**
		 * 
		 */
		public function VPAsset( name:String, url:String, thumb_url:String='', extension:String ):void {
			this.url = url;
			this.thumbUrl = thumb_url;
			this.assetName = name;
			this.ext = extension;
			if ( thumbUrl.length > 0)
			{
				// create a thumbnail loader
				var loader:URLLoader = new URLLoader();
				loader.addEventListener(Event.COMPLETE, onLoadHandler);
				loader.addEventListener(IOErrorEvent.IO_ERROR, onLoadHandler);
				
				loader.load(new URLRequest(thumbUrl));
			}
			else
			{
				this.thumbnail.bitmapData		= new VideoPongThumbnail();
			}
			
			const source:BitmapData			= this.thumbnail.bitmapData;
			const label:TextField			= new TextField();
			const format:TextFormat			= new TextFormat('Pixel', 7, 0xFFFFFF);
			//const format:TextFormat			= new TextFormat(new AssetDefaultFont().fontName, 7, 0xFFFFFF);
			format.leading					= 3;
			label.autoSize					= TextFieldAutoSize.LEFT;
			label.wordWrap					= true;
			label.width						= 44;
			//label.embedFonts				= true;
			label.defaultTextFormat			= format;
			
			label.text						= name.toUpperCase();
			
			source.draw(label);
		}
		/**
		 * 
		 */
		private function onLoadHandler(event:Event):void 
		{
			
			var loader:URLLoader = event.currentTarget as URLLoader;
			loader.removeEventListener(Event.COMPLETE, onLoadHandler);
			loader.removeEventListener(IOErrorEvent.IO_ERROR, onLoadHandler);
			
			if ( event is ErrorEvent ) 
			{
				trace("load error");
			}
			else
			{
				this.thumbnail.bitmapData = loader.data;
			}
		}
		
		/**
		 * 
		 */
		override public function get name():String {
			return assetName;
		}
		
		/**
		 * 
		 */
		override public function get path():String {
			return 'vdpong://' + name;
		}
		
		/**
		 * 
		 */
		public function get url():String {
			return assetUrl;	
		}
		
		/**
		 * 
		 */
		override public function get isDirectory():Boolean {
			return false;
		}
		
		/**
		 * 
		 */
		override public function get extension():String {
			trace(url.substr( url.lastIndexOf( '.' ) ));
			return 'swf';//url.substr( url.lastIndexOf( '.' ) ) returns .net/...;
		}
		
		/**
		 * 
		 */
		public function toString():String {
			return '[VPAsset: ' + path + ']';
		}
	}
}