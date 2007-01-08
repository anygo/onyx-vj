package ui.controls.layer
{
	import ui.controls.ButtonClear;
	import flash.display.SimpleButton;

	public final class LayerPageButton extends SimpleButton {
		
		public var index:int

		final public function LayerPageButton(index:int):void {
			
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