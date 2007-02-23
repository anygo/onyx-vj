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
package onyx.file {
	
	import flash.display.Loader;
	import flash.events.*;
	import flash.media.Camera;
	import flash.net.*;
	
	import onyx.core.*;
	
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
		private static var _current:String;
		
		/**
		 * 	@private
		 */
		private static var _adapter:FileAdapter;
		
		/**
		 * 
		 */
		public static function initialize(adapter:FileAdapter):void {
			_adapter = adapter;
		}

		/**
		 * 	Queries the filesystem
		 */
		public static function query(folder:String, callback:Function, refresh:Boolean = false):void {
			
			if (folder == '..') {
				var items:Array = _current.split('/');
				items.splice(items.length - 2, 2);
				folder = items.join('/') + '/';
			}
			
			_current = folder;

			// check for cache
			if (refresh || !_cache[folder]) {
				
				var query:FileQuery = _adapter.query(folder, callback);
				query.addEventListener(Event.COMPLETE,						_onLoadHandler);
				query.addEventListener(IOErrorEvent.IO_ERROR,				_onLoadHandler);
				query.addEventListener(SecurityErrorEvent.SECURITY_ERROR,	_onLoadHandler);
				query.load();
				
			} else {
				
				var cachedFolder:FolderList = _cache[folder];
				callback(cachedFolder);
				
			}
			
		}
		
		/**
		 * 	@private
		 */
		private static function _onLoadHandler(event:Event):void {
			var query:FileQuery = event.currentTarget as FileQuery;
			query.removeEventListener(Event.COMPLETE,						_onLoadHandler);
			query.removeEventListener(IOErrorEvent.IO_ERROR,				_onLoadHandler);
			query.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,	_onLoadHandler);
			
			_cache[query.path] = query.folderList;
			
			query.callback.apply(null, [query.folderList]);
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
				var file:File = new File(name + '.cam', null);
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