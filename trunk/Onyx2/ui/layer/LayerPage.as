package ui.layer {
	
	public final class LayerPage {
		
		public var name:String;
		public var controls:Array;
		
		public function LayerPage(name:String,... args:Array):void {
			this.name = name;
			this.controls = args;
		}
	}
}