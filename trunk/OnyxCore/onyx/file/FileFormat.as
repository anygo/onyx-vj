package onyx.file {

	import flash.utils.ByteArray;
	
	/**
	 * 	Base class for file formats
	 */
	public class FileFormat {
		
		/**
		 * 	The bytes
		 */
		protected var bytes:ByteArray;
		
		/**
		 * 	@constructor
		 */
		public function FileFormat(bytes:ByteArray = null):void {

			this.bytes = bytes || new ByteArray();

		}
		
		/**
		 * 	Returns bytes associated
		 */
		public function getBytes():ByteArray {
			return bytes;
		}
		
	}
}