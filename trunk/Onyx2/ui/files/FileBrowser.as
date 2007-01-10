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
package ui.files {
	
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.media.Camera;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import onyx.core.Console;
	import onyx.settings.Settings;
	
	import ui.assets.AssetCamera;
	
	/**
	 * 	Stores a cache of directories - so re-querying will not be necessary
	 */
	final public class FileBrowser {

		/**
		 * 	@private
		 */
		private static var _cache:Object = [];
		
		/**
		 * 	@private
		 */
		private static var _callback:Function;
		
		/**
		 * 
		 */
		private static var _current:String;

		/**
		 * 	Queries the filesystem
		 */
		public static function query(folder:String, callback:Function, refresh:Boolean = false):void {
			
			_callback = callback;
			
			if (folder == '..') {
				var items:Array = _current.split('/');
				items.splice(items.length - 2, 2);
				folder = items.join('/') + '/';
			}
			
			_current = folder;

			// check for cache
			if (refresh || !_cache[folder]) {
				
				var loader:URLLoader = new URLLoader();
				loader.addEventListener(Event.COMPLETE, _onLoadHandler);
				loader.addEventListener(IOErrorEvent.IO_ERROR, _onLoadHandler);
				
				loader.load(new URLRequest(folder + 'files.xml'));
				
			} else {
				
				var cachedFolder:FolderList = _cache[folder];
				_callback(cachedFolder);
			}
			
		}

		/**
		 * 	@private
		 */
		private static function _onLoadHandler(event:Event):void {

			// error			
			if (event is IOErrorEvent) {
				
				Console.output((event as IOErrorEvent).text);

			// success
			} else {
	
				var loader:URLLoader = event.currentTarget as URLLoader;
	
				// declare the node
				var node:XML;
	
				// load the data into an xml doc			
				var xml:XML = new XML(loader.data);
				
				// create the Folder
				var rootpath:String = xml.query.@path.toString();
				var list:FolderList = new FolderList(rootpath);
	
				// get the children
				var files:XMLList = xml.query.file;
				var dirs:XMLList = xml.query.folder;
				
				// parse for files Folder
				for each (node in dirs) {
					name = node.@name;
					name = (name == '..') ? name : rootpath + name;
					list.folders.push(new Folder(name));
				}

				list.folders.push(new Folder('cameras'));
				
				// parse for files Folder
				for each (node in files) {
					
					// get name of the node
					var name:String = String(node.name()).toLowerCase();
					
					var thumb:String = node.@thumb;
					list.files.push(
						new File(rootpath + node.@name, (thumb) ? rootpath + thumb : '')
					);
					
				}
				
				// save the cache
				_cache[list.path] = list;
	
				// call the callback
				_callback(list);
			}
		}
		
		/**
		 * 	@private
		 */
		private static function _getCameras():void {
			
			var list:FolderList = new FolderList('cameras');
			
			var cameras:Array = Camera.names;
			
			var folder:Folder = new Folder(Settings.INITIAL_APP_DIRECTORY);
			list.folders.push(folder);
			
			for each (var name:String in cameras) {
				var file:File = new File(name + '.cam', new AssetCamera());
				list.files.push(file);
			}

			// save the cache
			_cache[list.path] = list;
		}
		
		/**
		 * 	Returns a folder list of cameras
		 */
		public static function getCameras():FolderList {
			return _cache.cameras;
		}
		
		// load initial cameras
		_getCameras();
	}
}