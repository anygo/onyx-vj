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
package onyx.layer {
	
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.MovieClip;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.media.Camera;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import onyx.content.*;
	import onyx.controls.Controls;
	import onyx.core.Console;
	import onyx.core.IDisposable;
	import onyx.display.Display;
	import onyx.events.LayerContentEvent;
	import onyx.net.Connection;
	import onyx.net.Stream;

	[Event(name='complete',			type='flash.events.Event')]
	[Event(name='security_error',	type='flash.events.SecurityErrorEvent')]
	[Event(name='io_error',			type='flash.events.IOErrorEvent')]
	[Event(name='progress',			type='flash.events.ProgressEvent')]

	/**
	 * 	Loads different content based on the file url
	 */
	internal final class ContentLoader extends EventDispatcher {
		
		private var _props:LayerProperties;
		private var _settings:LayerSettings;
		
		/**
		 * 	@Constructor
		 */
		public function ContentLoader():void {
		}
		
		public function load(request:URLRequest, extension:String, props:LayerProperties, settings:LayerSettings):void {
			
			var path:String = request.url;
			
			_props = props;
			_settings = settings || new LayerSettings();
		
			// do different stuff based on the extension
			switch (extension) {
				case 'flv':
					var stream:Stream = new Stream(path);
					stream.addEventListener(Event.COMPLETE, _onStreamComplete);
					
					break;
				case 'cam':
				
					var names:Array = Camera.names;
					var name:String = path.substr(0, path.length - 4);
					
					var content:IContent = new ContentCamera(Camera.getCamera(names.indexOf(name) as String), _props);
					
					_dispatchContent(content, new Event(Event.COMPLETE));
					
					break;
				// load a loader if we're any other type of file
				case 'jpg':
				case 'jpeg':
				case 'png':
				case 'swf':
				case 'onx':
				
					var loader:Loader  = new Loader();
					loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, _onLoadHandler);
					loader.contentLoaderInfo.addEventListener(Event.COMPLETE, _onLoadHandler);
					loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, _onLoadProgress);
					loader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, _onLoadHandler);
					loader.load(request);
					
					break;
			}

		}
		
		/**
		 * 	@private
		 * 	Dispatched when a stream receives meta data
		 */
		private function _onStreamComplete(event:Event):void {
			
			var stream:Stream = event.currentTarget as Stream;
			stream.removeEventListener(Event.COMPLETE, _onStreamComplete);
			
			_dispatchContent(new ContentFLV(stream, _props), event);


		}
		
		/**
		 * 	@private
		 * 	Progress handler, forward the event
		 */
		private function _onLoadProgress(event:ProgressEvent):void {
			dispatchEvent(event);
		}
		
		/**
		 * 	@private
		 * 	Handler for loaded loaders
		 */
		private function _onLoadHandler(event:Event):void {
			
			var info:LoaderInfo = event.currentTarget as LoaderInfo;
			info.removeEventListener(IOErrorEvent.IO_ERROR, _onLoadHandler);
			info.removeEventListener(Event.COMPLETE, _onLoadHandler);
			info.removeEventListener(ProgressEvent.PROGRESS, _onLoadProgress);
			info.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, _onLoadHandler);
			
			if (!(event is ErrorEvent)) {
				
				var loader:Loader	= info.loader;
				var content:IContent;
				
				if (loader.content is MovieClip) {
					content = new ContentMC(loader, _props);
				} else {
					content = new ContentSprite(loader, _props)
				}
			}
			
			_dispatchContent(content, event);
			
		}
		
		/**
		 * 	@private
		 */
		private function _dispatchContent(content:IContent, event:Event):void {
			
			_props = null;
			
			if (event is ErrorEvent) {
				dispatchEvent(event);
			} else {
				var dispatch:LayerContentEvent = new LayerContentEvent(Event.COMPLETE);
				dispatch.content = content;
				dispatch.settings = _settings;
				dispatchEvent(dispatch);
			}

			_settings = null;
		}
	}
}