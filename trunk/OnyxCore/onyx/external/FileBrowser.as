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
package onyx.external {
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import onyx.external.files.*;
	
	final public class FileBrowser {
		
		// loads xml
		private static var _loader:URLLoader = new URLLoader();

		// stores the cache
		private static var _cache:Object = [];
		
		private static var _callback:Function;

		public static function query(folder:String, callback:Function, refresh:Boolean = false):void {
			
			// check for cache
			if (refresh || !_cache[folder]) {
				
				_callback = callback;
			
				_loader.addEventListener(Event.COMPLETE, _onLoad);
				_loader.load(new URLRequest(folder + 'files.xml'));
				
			} else {
				
				var cachedFolder:FolderList = _cache[folder];
				_callback(cachedFolder);
			}
			
		}
		
		private static function _onLoad(event:Event):void {
			
			_parseXML();
			
		}

		private static function _parseXML():void {

			// declare the node
			var node:XML;

			// load the data into an xml doc			
			var xml:XML = new XML(_loader.data);
			
			// create the Folder
			var rootpath:String = xml.query.@path.toString();
			var folder:FolderList = new FolderList(rootpath);

			// get the children
			var files:XMLList = xml.query.file;
			var dirs:XMLList = xml.query.folder;
			
			// parse for files Folder
			for each (node in dirs) {
				folder.folders.push(new Folder(node.@name));
			}

			// parse for files Folder
			for each (node in files) {
				
				// get name of the node
				var name:String = String(node.name()).toLowerCase();
				
				var thumb:String = node.@thumb;
				folder.files.push(new File(rootpath + node.@name, (thumb) ? rootpath + thumb : ''));

			}
			
			// save the cache
			_cache[folder.path] = folder;

			// call the callback
			_callback(folder);

		}
	}
}