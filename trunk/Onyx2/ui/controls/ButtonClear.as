package ui.controls {
	
	import flash.display.Shape;
	import flash.display.SimpleButton;
	import flash.events.MouseEvent;
	
	public final class ButtonClear extends SimpleButton {

		final public function ButtonClear(width:int, height:int, show:Boolean = true):void {
			
			if (show) {
//				upState	  = new OverState(width, height);
				overState = new OverState(width, height);
				downState = new DownState(width, height);
			}
			hitTestState = new HitState(width, height);
			
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

final class OverState extends Shape {
	
	final public function OverState(width:int, height:int):void {

		graphics.beginFill(0xAAAAAA, .2);
		graphics.drawRect(0, 0, width, height);
		graphics.endFill();
		
		cacheAsBitmap = true;

	}
}

final class DownState extends Shape {
	
	final public function DownState(width:int, height:int):void {

		graphics.beginFill(0xCCCCCC, .2);
		graphics.drawRect(0, 0, width, height);
		graphics.endFill();
		
		cacheAsBitmap = true;

	}
}