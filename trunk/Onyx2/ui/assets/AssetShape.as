package ui.assets {

	import flash.display.Shape;
	
	/**
	 * 	Stores shape
	 */
	public final class AssetShape extends Shape {
		
		/**
		 * 	@constructor
		 */
		public function AssetShape(width:int, height:int, line:uint = 0x45525c, bgcolor:uint = 0x0e0f0f):void {
	
			graphics.lineStyle(0, line);
			graphics.beginFill(bgcolor);
			graphics.drawRect(0,0,width,height);
			graphics.endFill();

		}
	}
}