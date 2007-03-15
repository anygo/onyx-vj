package file {
	
	import flash.display.Loader;
	import flash.events.*;
	import flash.filesystem.*;
	
	import mx.events.FileEvent;
	
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
		public function ApolloQuery(path:String, callback:Function, filter:FileFilter = null):void {

			super(path, callback, filter);

		}

		/**
		 * 	Starts a filesystem query
		 */		
		override public function load():void {

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