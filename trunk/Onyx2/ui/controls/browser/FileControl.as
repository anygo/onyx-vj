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
	
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.filters.DropShadowFilter;
	import flash.net.URLRequest;
	import flash.text.TextFormat;
	
	import onyx.external.files.File;
	
	import ui.assets.AssetCamera;
	import ui.controls.*;
	import ui.text.Style;
	import ui.text.TextField;
	
	public final class FileControl extends UIControl {
		
		private var _label:TextField	= new TextField(46, 35);
		private var _button:ButtonClear	= new ButtonClear(46, 35);
		private var _loader:Loader		= new Loader();
		
		public var path:String;
		
		public function FileControl(path:String, thumbpath:String, directory:String):void {
			
			this.path = path;
			
			_label.align	= 'center';
			_label.wordWrap = true;
			
			var format:TextFormat = _label.getTextFormat();
			var substr:int = Math.max(path.lastIndexOf('\\')+1,path.lastIndexOf('/')+1);
			format.leading = 1;
			
			_label.defaultTextFormat = format;
			_label.text = path.substring(substr, path.length);
			_label.filters = [new DropShadowFilter(1,45, 0x000000,1,0,0,1)];
			
			graphics.beginFill(0x647789);
			graphics.drawRect(0,0,48,37);
			graphics.endFill();

			_loader.load(new URLRequest(thumbpath));
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, _handler);
			_loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, _handler);
			_loader.x = 1;
			_loader.y = 1;
			
			doubleClickEnabled = true;

			addChild(_loader);
			addChild(_label);
			addChild(_button);

			cacheAsBitmap = true;
		}
		
		private function _handler(event:Event):void {
			var loader:LoaderInfo = event.currentTarget as LoaderInfo;
			loader.removeEventListener(Event.COMPLETE, _handler);
			loader.removeEventListener(IOErrorEvent.IO_ERROR, _handler);
		}
		
		override public function dispose():void {
			
			removeChild(_loader);
			removeChild(_label);
			removeChild(_button);
			
			_loader.unload();
			_loader = null;
			_button = null;
			_label = null;
			path = null;
		}
	}
}