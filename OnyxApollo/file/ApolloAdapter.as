package file {
	
	import flash.filesystem.File;
	import flash.utils.ByteArray;
	
	import onyx.file.FileAdapter;
	import onyx.file.FileFilter;
	import onyx.file.FileQuery;
	/**
	 * 	Apollo File Adapter
	 */
	public final class ApolloAdapter extends FileAdapter {
		
		/**
		 * 
		 */
		public function ApolloAdapter():void {
			super('app-resource:/');
		}

		/**
		 * 
		 */
		override public function getFileName(path:String):String {
			var index:int = path.lastIndexOf('/')+1;
			return (index) ? path.substr(index) : path;
		}
		
		/**
		 * 	Queries a directory
		 */
		override public function query(path:String, callback:Function, filter:FileFilter = null):FileQuery {
			return new ApolloQuery(path, callback, filter);
		}
		
		/**
		 * 	Saves contents
		 */
		override public function save(path:String, callback:Function, contents:ByteArray):void {
		}
	}
}