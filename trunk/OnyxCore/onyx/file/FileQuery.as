package onyx.file {
	
	import flash.events.EventDispatcher;
	import flash.utils.ByteArray;

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
		 * 
		 */
		public var bytes:ByteArray;
		
		/**
		 * 
		 */
		// public var job:FileJob;
		
		[Event(name='complete', type='flash.events.Event')]
				
		/**
		 * 	@constructor
		 */
		public function FileQuery(folder:String, callback:Function):void {
			this.path		= folder;
			this.callback	= callback;
		}
		
		public function save(bytes:ByteArray):void {
		}
		
		public function load(file:FileFilter):void {
		}
		
		public function dispose():void {
			callback	= null;
			folderList	= null;
			filter		= null;
			bytes		= null;
		}
	}
}