package ui.controls {
	
	import flash.display.Shape;
	import flash.display.Sprite;
	
	import onyx.controls.Control;
	import onyx.events.ControlEvent;
	
	import ui.core.UIObject;
	import ui.text.Style;
	import ui.text.TextField;
	import onyx.core.IDisposable;

	public class UIControl extends UIObject implements IDisposable {
		
		public function addLabel(name:String, width:int = 36, height:int = 9):void {
			
			var label:TextField = new TextField(width, height);
			label.align = 'center';
			label.text = name;
			label.y = -11;

			addChild(label);
			
		}
		
		public function set background(value:Boolean):void {
			if (value) {
				var shape:ControlShape = new ControlShape();
				addChildAt(shape, 0);
			}
		}
	}
}

import flash.display.Shape;

final class ControlShape extends Shape {
	
	public function ControlShape():void {

		graphics.lineStyle(0, 0x45525c);
		graphics.beginFill(0x192025);
		graphics.drawRect(0,0,36,9);
		graphics.endFill();
		
		cacheAsBitmap = true;

	}
	
}