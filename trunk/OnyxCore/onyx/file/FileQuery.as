package onyx.file {
	
	import flash.events.EventDispatcher;

	public class FileQuery extends EventDispatcher {
		
		/**
		 * 	the path to load
		 */
		public var path:String;
		
		/**
		 * 	The function to call back
		 */
		public var callback:Function;
		
		/**
		 * 	The folder list stored
		 */
		public var folderList:FolderList;
		
		/**
		 * 	The filter to apply to the callback
		 */
		public var filter:FileFilter;
				
		/**
		 * 	@constructor
		 */
		public function FileQuery(folder:String, callback:Function, filter:FileFilter = null):void {
			this.path		= folder;
			this.callback	= callback;
			this.filter		= filter;
		}
		
		public function load():void {
		}
	}
}