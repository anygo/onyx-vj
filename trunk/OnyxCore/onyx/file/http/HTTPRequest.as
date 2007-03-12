package onyx.file.http {
	
	import flash.display.Loader;
	import flash.net.*;
	
	import onyx.file.FileRequest;
	
	/**
	 * 	An HTTP Request (similar to URLLoader)
	 */
	public final class HTTPRequest extends FileRequest {
		
		/**
		 * 	@private
		 */
		private var loader:URLLoader;
		
		/**
		 * 
		 */
		private var _data:Object;
		
		/**
		 * 	@constructor
		 */
		public function HTTPRequest():void {
			loader = new URLLoader();
			loader.dataFormat = URLLoaderDataFormat.BINARY;
		}
		
		/**
		 * 	Loads a file
		 */
		override public function load(path:String):void {
			loader.load(new URLRequest(path));
		}
		
		/**
		 * 
		 */
		public function get data():Object {
			return loader.data;
		}				
	}
}