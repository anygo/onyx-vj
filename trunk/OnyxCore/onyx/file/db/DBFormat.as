package onyx.file.db {
	
	import flash.display.BitmapData;
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	
	import onyx.file.FileFormat;

	/**
	 * 	
	 */
	public final class DBFormat extends FileFormat {
		
		/**
		 * 	@constructor
		 */
		public function DBFormat(bytes:ByteArray = null):void {
			super(bytes);
		}
		
		/**
		 * 	
		 */
		public function addFile(filename:String, thumbnail:BitmapData):void {
			
			var fileBytes:ByteArray	= new ByteArray();
			fileBytes.endian		= Endian.LITTLE_ENDIAN;
			
			// temporary total size bytes
			fileBytes.writeUnsignedInt(0);
			
			// size in bytes of the filename
			fileBytes.writeUnsignedInt(filename.length);
			
			// write image data
			fileBytes.writeBytes(thumbnail.getPixels(thumbnail.rect));
			
			// update the length
			fileBytes.position = 0;
			fileBytes.writeUnsignedInt(fileBytes.length);
			
			// add it
			bytes.writeBytes(fileBytes);
		}
	}
}