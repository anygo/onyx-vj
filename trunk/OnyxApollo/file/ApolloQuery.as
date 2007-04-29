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
package file {
	
	import flash.display.Loader;
	import flash.events.*;
	import flash.filesystem.*;
	import flash.utils.*;
	
	import onyx.constants.*;
	import onyx.core.Console;
	import onyx.file.*;
	import onyx.utils.string.getExtension;

	/**
	 * 	Queries via the apollo filesystem
	 */
	public final class ApolloQuery extends FileQuery {
		
		/**
		 * 	@constructor
		 */
		public function ApolloQuery(path:String, callback:Function):void {

			super(path, callback);

		}

		/**
		 * 	Starts a filesystem query
		 */		
		override public function load(filter:FileFilter):void {
			
			super.filter = filter;

			// first check for a thumbs.onx
			// var db:flash.filesystem.File	= new flash.filesystem.File(path + '\\thumbs.onx');
			// var dbStream:FileStream			= new FileStream();

			// dbStream.addEventListener(Event.COMPLETE,			_onDBComplete);
			// dbStream.addEventListener(IOErrorEvent.IO_ERROR,	_onDBComplete);

			// open file asynchronously
			// dbStream.openAsync(db, FileMode.READ);

			// get our filesys path
			var folder:flash.filesystem.File = new flash.filesystem.File(path);
			
			// get directory
			folder.addEventListener(FileListEvent.DIRECTORY_LISTING, _onDirectoryList);
			folder.listDirectoryAsync();

		}
		
		override public function save(bytes:ByteArray):void {
			
			var f:flash.filesystem.File = new flash.filesystem.File('app-resource:/save/' + path);
			trace(f.nativePath);
			var stream:FileStream = new FileStream();
			stream.open(f, FileMode.WRITE);
			stream.writeBytes(bytes);
		}
		
		private function _onDBComplete(event:Event):void {
			
			var stream:FileStream			= event.currentTarget as FileStream;
			stream.removeEventListener(IOErrorEvent.IO_ERROR,	_onDBComplete);
			stream.removeEventListener(Event.COMPLETE,			_onDBComplete);

			// TBD: read the file here

			stream.close();
			
			// we have no file, so we need to create a new listing
			if (!(event is ErrorEvent)) {
			}

			// get our filesys path
			var folder:flash.filesystem.File = new flash.filesystem.File(path);
			
			// get directory
			folder.addEventListener(FileListEvent.DIRECTORY_LISTING, _onDirectoryList);
			folder.listDirectoryAsync();

		}

		/**
		 *	@private
		 *	Handler for when diretory is queried
		 */
		private function _onDirectoryList(event:FileListEvent):void {

			var folder:flash.filesystem.File = event.currentTarget as flash.filesystem.File;

			// clean reference
			folder.removeEventListener(FileListEvent.DIRECTORY_LISTING, _onDirectoryList);

			// create our onyx folder object
			var list:FolderList = new FolderList(path);
			var directory:Array = event.files;

			// push the parent diretory
			list.folders.push(new onyx.file.Folder(folder.parent.url));
			
			// loop through files and folders
			for each (var fileObj:flash.filesystem.File in directory) {
				
				var path:String = fileObj.url;

				// push directories and folders					
				if (fileObj.isDirectory) {
					
					list.folders.push(new onyx.file.Folder(path));
				
				// push files
				} else {
					
					// check to see if it's a db file
					if (!fileObj.url == 'thumbs.onx') {
						
					} else {
						
						// check to see if it's in the database already, if not, load it
						switch (getExtension(path)) {
							case 'jpg':
							case 'swf':
								list.files.push(
									new onyx.file.File(path, new Loader())
								);
								break;
						}
					}
					
				}
			}

			// we're done, send it over			
			super.folderList = list;
			dispatchEvent(new Event(Event.COMPLETE));
		}
	}
}