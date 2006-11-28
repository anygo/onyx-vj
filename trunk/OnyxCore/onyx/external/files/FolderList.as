package onyx.external.files {

	public final class FolderList {
		
		public var path:String;
		public var files:Array	= [];
		public var folders:Array	= [];
		
		public function FolderList(path:String):void {
			this.path = path;
		}
	}
}