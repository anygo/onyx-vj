package ui.controls {
	
	public class UIOptions {
		
		public static const DEFAULT:UIOptions	= new UIOptions();
		
		public var background:Boolean;
		public var labelAlign:String;
		public var width:int;
		public var height:int;
		public var label:Boolean;
		
		public function UIOptions(background:Boolean = true, label:Boolean = true, labelAlign:String = 'center', width:int = 44, height:int = 10):void {
			this.label = label;
			this.labelAlign = labelAlign;
			this.background = background;
			this.width = width;
			this.height = height;
		}
	
	}
}