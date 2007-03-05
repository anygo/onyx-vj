/** 
 * Copyright (c) 2003-2006, www.onyx-vj.com
 * All rights reserved.	
 * 
 * Redistribution and use in source and binary forms, with or without modification,
 * are permitted provided that the following conditions are met:
 * 
 * -  Redistributions of source code must retain the above copyright notice, this 
 *    list of conditions and the following disclaimer.
 * 
 * -  Redistributions in binary form must reproduce the above copyright notice, 
 *    this list of conditions and the following disclaimer in the documentation 
 *    and/or other materials provided with the distribution.
 * 
 * -  Neither the name of the www.onyx-vj.com nor the names of its contributors 
 *    may be used to endorse or promote products derived from this software without 
 *    specific prior written permission.
 * 
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND 
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED 
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. 
 * IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, 
 * INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
 * NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
 * PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, 
 * WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE 
 * POSSIBILITY OF SUCH DAMAGE.
 * 
 */
package ui.controls.browser {
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.filters.DropShadowFilter;
	import flash.net.URLRequest;
	import flash.text.TextFormat;
	
	import onyx.file.*;
	
	import ui.assets.AssetCamera;
	import ui.controls.*;
	import ui.styles.*;
	import ui.text.TextField;
	
	/**
	 * 	Thumbnail for file
	 */
	public final class FileControl extends UIControl {
		
		private var _label:TextField	= new TextField(46, 35,	TEXT_DEFAULT_CENTER);
		private var _button:ButtonClear	= new ButtonClear(47, 36);
		private var _loader:Loader;

		/**
		 * 	@private
		 */		
		private var _file:File;
		
		/**
		 * 	@constructor
		 */
		public function FileControl(file:File):void {
			
			super(null);
			
			_file = file;
			
			var path:String = file.path;
			
			// add label
			_label.wordWrap = true;
			
			var format:TextFormat = _label.getTextFormat();
			var substr:int = Math.max(path.lastIndexOf('\\')+1,path.lastIndexOf('/')+1);
			
			_label.defaultTextFormat = format;
			_label.text = path.substring(substr, path.length);
			_label.filters = [new DropShadowFilter(1,45, 0x000000,1,0,0,1)];
			_label.cacheAsBitmap = true;

			if (_file.thumbnail) {
				
				if (_file.thumbnail is Bitmap) {
					var thumbnail:DisplayObject = addChild(_file.thumbnail as Bitmap);
				} else if (_file.thumbnail is String) {
					_loader = new Loader();
					_loader.load(new URLRequest(_file.thumbnail as String));
					_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, _handler);
					_loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, _handler);
					_loader.x = 1;
					_loader.y = 1;
	
					addChild(_loader);
				}
			}
			
			doubleClickEnabled = true;

			addChild(_label);
			addChild(_button);

			
			// draw border
			graphics.beginFill(0x647789);
			graphics.drawRect(0,0,48,37);
			graphics.endFill();
			cacheAsBitmap = true;
		}
		
		/**
		 * 	@private
		 * 	Remove handlers
		 */
		private function _handler(event:Event):void {
			var info:LoaderInfo = event.currentTarget as LoaderInfo;
			info.removeEventListener(Event.COMPLETE, _handler);
			info.removeEventListener(IOErrorEvent.IO_ERROR, _handler);
		}
		
		/**
		 * 	Returns path
		 */
		public function get path():String {
			return _file.path;
		}
		
		/**
		 * 	Destroys control
		 */
		override public function dispose():void {
			
			removeChild(_label);
			removeChild(_button);
			
			_button = null;
			_label = null;
			_file = null;
		}
	}
}