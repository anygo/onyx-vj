package ui.controls {
	
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import onyx.core.IDisposable;
	
	import ui.core.UIObject;

	public class ScrollPane extends UIObject {
		
		private var _clickX:Number;
		private var _width:int;
		private var _height:int;
		
		public function ScrollPane(width:int, height:int):void {
			_width = width;
			_height = height;
			
			addEventListener(Event.ADDED, _onCalculate);
			addEventListener(Event.REMOVED, _onCalculate);
			addEventListener(MouseEvent.MOUSE_OVER, _onMouseOver);
			
			scrollRect = new Rectangle(0,0, width, height);
		}
		
		private function _onCalculate(event:Event):void {
			
			var bounds:Rectangle = getBounds(null);
			if (bounds.height > _height) {
				_displayScrollBar();
			}
		}
		
		private function _onMouseOver(event:MouseEvent):void {
			addEventListener(MouseEvent.MOUSE_OUT, _onMouseOut);
			addEventListener(MouseEvent.MOUSE_WHEEL, _onMouseWheel);
		}
		
		private function _onMouseOut(event:MouseEvent):void {
			removeEventListener(MouseEvent.MOUSE_OUT, _onMouseOut);
			removeEventListener(MouseEvent.MOUSE_WHEEL, _onMouseWheel);
		}
		
		private function _onMouseWheel(event:MouseEvent):void {
			trace(1);
		}
		
		private function _displayScrollBar():void {
		}
		
		public function set backgroundColor(value:uint):void {
			graphics.clear();
			graphics.beginFill(value);
			graphics.lineStyle(0, 0x647789);
			graphics.drawRect(-4,-4,_width+4,_height+4);
			graphics.endFill();
		}
		
		override public function dispose():void {
			removeEventListener(Event.ADDED, _onCalculate);
			removeEventListener(Event.REMOVED, _onCalculate);
			removeEventListener(MouseEvent.MOUSE_OVER, _onMouseOver);
			removeEventListener(MouseEvent.MOUSE_OUT, _onMouseOut);
			removeEventListener(MouseEvent.MOUSE_WHEEL, _onMouseWheel);

		}
		
	}
}

import flash.display.Sprite;

final class ScrollBar extends Sprite {
	
	public function ScrollBar():void {
	}
	
}