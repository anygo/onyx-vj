package ui.window {
	
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	
	import ui.core.UIObject;
	import ui.text.Style;
	import ui.text.TextField;
	import ui.text.TextInput;
	import flash.text.TextFieldAutoSize;
	
	public class Window extends UIObject {
		
		private static var _windows:Array		= [];
		
		private var _title:TextField			= new TextField(80, 16);
		private var _background:WindowAsset	= new WindowAsset();
		
		public function Window():void {
			
			_windows.push(this);

			_title.autoSize		= TextFieldAutoSize.LEFT;
			_title.x				= 2;
			_title.y				= 1;
			
			addChild(_background);
			addChild(_title);
			
		}
		
		public function set title(t:String):void {
			_title.text = t;
		}

		public function get title():String {
			return _title.text;
		}
		
		public override function set width(w:Number):void {
			_background.width = w;
		}

		public override function set height(h:Number):void {
			_background.height = h;
		}
		
		public function set draggable(drag:Boolean):void {
			addEventListener(MouseEvent.MOUSE_DOWN, _dragMouseDown);
		}
		
		private function _dragMouseDown(event:MouseEvent):void {
			/* check to see if thet mouse is hitting the title bar */
			if (mouseY < 13) {
				startDrag();
				addEventListener(MouseEvent.MOUSE_UP, _dragMouseUp);
			}
		}
		
		private function _dragMouseUp(event:MouseEvent):void {
			stopDrag();
			removeEventListener(MouseEvent.MOUSE_UP, _dragMouseUp);
		}

	}
}

/**
 * 
 * 	HELPER CLASS
 * 
 **/

import flash.display.Sprite;
import flash.geom.Rectangle;

class WindowAsset extends Sprite {
	
	public function WindowAsset():void {
		
		graphics.lineStyle(0,0x5c7181, 1, true);

		graphics.beginFill(0x2b3842);
		graphics.drawRoundRectComplex(0,10,100,90,0,0,2,2);
		graphics.endFill();
		
		graphics.beginFill(0x000000);
		graphics.drawRoundRectComplex(0,0,100,10,2,2,0,0);
		graphics.endFill();

		scale9Grid = new Rectangle(20,20,76,76);

	}
	
}