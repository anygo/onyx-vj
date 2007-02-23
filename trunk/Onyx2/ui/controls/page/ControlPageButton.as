package ui.controls.page {
	
	import flash.display.SimpleButton;
	
	import ui.controls.ButtonClear;

	public final class ControlPageButton extends SimpleButton {
		
		public var index:int

		final public function ControlPageButton(index:int):void {
			
			this.index = index;

			hitTestState = new HitState(34, 14);
			
		}
		
	}
}

import flash.display.Shape;

final class HitState extends Shape {
	
	final public function HitState(width:int, height:int):void {

		graphics.beginFill(0);
		graphics.drawRect(0, 0, width, height);
		graphics.endFill();
		
		cacheAsBitmap = true;

	}
}