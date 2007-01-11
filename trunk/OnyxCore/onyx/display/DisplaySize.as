package onyx.display {
	
	public class DisplaySize {
		
		public static const SIZES:Array = [
			new DisplaySize('320x240', 1),
			new DisplaySize('640x480', 2)
		]
		
		public var name:String;
		public var scale:Number;
		
		public function DisplaySize(name:String, scale:Number):void {
			this.name = name;
			this.scale = scale;
		}
		
	}
}