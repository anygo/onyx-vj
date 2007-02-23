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
		 * 	@constructor
		 */
		public function FileQuery(folder:String, callback:Function):void {
			this.path		= folder;
			this.callback	= callback;
		}
		
		public function load():void {
		}
	}
}