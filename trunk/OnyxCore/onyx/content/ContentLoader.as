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
package onyx.content {
	
	import flash.display.*;
	import flash.events.*;
	import flash.media.*;
	import flash.net.*;
	
	import onyx.core.*;
	import onyx.display.Display;
	import onyx.events.LayerContentEvent;
	import onyx.layer.LayerSettings;
	import onyx.net.*;
	import onyx.plugin.IContentObject;
	import onyx.transition.Transition;
	import onyx.utils.StringUtil;

	[Event(name='complete',			type='flash.events.Event')]
	[Event(name='security_error',	type='flash.events.SecurityErrorEvent')]
	[Event(name='io_error',			type='flash.events.IOErrorEvent')]
	[Event(name='progress',			type='flash.events.ProgressEvent')]

	/**
	 * 	Loads different content based on the file url
	 */
	public final class ContentLoader extends EventDispatcher {
		
		/**
		 * 	@private
		 */
		private var _settings:LayerSettings;
		
		/**
		 * 	@private
		 * 	Transition to load with
		 */
		private var _transition:Transition;
		
		/**
		 * 	@private
		 */
		private var _request:URLRequest;
		
		/**
		 * 	@private
		 */
		private var _loaded:Boolean;
		
		/**
		 * 	@private
		 */
		private var _path:String;
		
		/**
		 * 
		 */
		public function ContentLoader(request:URLRequest):void {
			_request = request;
		}
		
		/**
		 * 	Loads a file
		 */
		public function load(settings:LayerSettings, transition:Transition):void {
			
			_settings = settings || new LayerSettings();
			_transition = transition;
			
			var path:String			= _request.url;
			var extension:String	= StringUtil.getExtension(path);
		
			// do different stuff based on the extension
			switch (extension) {
				
				case 'flv':
					var stream:Stream = new Stream(path);
					stream.addEventListener(Event.COMPLETE, _onStreamComplete);
					
					break;
				case 'cam':
				
					var names:Array = Camera.names;
					var name:String = path.substr(0, path.length - 4);
					
					_dispatchContent(ContentCamera, Camera.getCamera(String(names.indexOf(name))), new Event(Event.COMPLETE));
					
					break;
					
				case 'mp3':
				
					var sound:Sound		= new Sound();
					sound.addEventListener(Event.COMPLETE, _onSoundHandler);
					sound.addEventListener(IOErrorEvent.IO_ERROR, _onSoundHandler);
					sound.addEventListener(ProgressEvent.PROGRESS, _onLoadProgress);
					sound.load(_request);
					break;

				// load a loader if we're any other type of file
				case 'jpg':
				case 'jpeg':
				case 'png':
				case 'swf':
				
					var def:Loader = ContentManager.hasDefinition(_request.url);
				
					var loader:Loader  = def || new Loader();
					loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, _onLoadHandler);
					loader.contentLoaderInfo.addEventListener(Event.COMPLETE, _onLoadHandler);
					loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, _onLoadProgress);
					loader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, _onLoadHandler);
					
					if (def) {
						_createLoaderContent(loader.contentLoaderInfo);
					} else {
						loader.load(_request);
					}
					
					break;
			}

		}
		
		/**
		 * 	@private
		 * 	Handles events when a sound object retrieves it's ID3 information
		 */
		private function _onSoundHandler(event:Event):void {
			var sound:Sound = event.currentTarget as Sound;
			sound.removeEventListener(Event.COMPLETE, _onSoundHandler);
			sound.removeEventListener(IOErrorEvent.IO_ERROR, _onSoundHandler);
			sound.removeEventListener(ProgressEvent.PROGRESS, _onLoadProgress);
			
			_dispatchContent(ContentMP3, sound, event);
		}
		
		/**
		 * 	@private
		 * 	Dispatched when a stream receives meta data
		 */
		private function _onStreamComplete(event:Event):void {
			
			var stream:Stream = event.currentTarget as Stream;
			stream.removeEventListener(Event.COMPLETE, _onStreamComplete);
			
			_dispatchContent(ContentFLV, stream, event);

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
				
				_createLoaderContent(info, event);
				
			}
			
		}
		
		/**
		 * 	@private
		 */
		private function _createLoaderContent(info:LoaderInfo, event:Event = null):void {
			var loader:Loader	= info.loader;
			var type:Class = (loader.content is MovieClip) ? ContentMC : (loader.content is IContentObject) ? ContentCustom : ContentSprite;

			_dispatchContent(type, loader, event || new Event(Event.COMPLETE));
		}
		
		/**
		 * 	@private
		 */
		private function _dispatchContent(contentType:Class, reference:Object, event:Event):void {
			
			if (event is ErrorEvent) {
				dispatchEvent(event);
			} else {
				var dispatch:LayerContentEvent = new LayerContentEvent(Event.COMPLETE);
				dispatch.contentType	= contentType;
				dispatch.reference		= reference;
				dispatch.settings		= _settings;
				dispatch.transition 	= _transition;
				dispatch.request		= _request;
				dispatchEvent(dispatch);
			}
		}
		
		/**
		 * 	Dispose
		 */
		public function dispose():void {

			// dispose
			_settings = null;
			_transition = null;
			_request = null;

		}
	}
}

import flash.display.Loader;
import onyx.content.ContentLoader;

/**
 * 	Content registration
 */
class Registration {
	
	public var refCount:int;
	public var loader:ContentLoader;
	public var type:Class;
	public var content:Object;
	
	public function get loaded():Boolean {
		return (type !== null);
	}
	
	public function dispose():void {
		loader	= null;
		type	= null;
		content = null;
	}
	
}