package onyx.external.files {
	
	public final class File {
		
		public var path:String;
		public var thumbnail:String;
		
		public function File(path:String, thumbnail:String):void {
			
			this.path = path;
			this.thumbnail = thumbnail;
			
		}
		
	}
}