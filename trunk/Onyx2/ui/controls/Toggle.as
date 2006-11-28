package ui.controls {
	
	import flash.events.MouseEvent;
	
	public final class Toggle extends UIControl {
		
		private var _enabled:Boolean		= false;
		private var _toggle:ToggleState;

		public function Toggle(width:int = 36, height:int = 10):void {
			
			addChild(new ButtonClear(width,height));
			
			addEventListener(MouseEvent.MOUSE_DOWN, _onMouseDown);
			
		}
		
		private function _onMouseDown(event:MouseEvent):void {
			enabled = !_enabled;
		}
		
		/**
		 * 	@method		Sets whether it's enabled or not
		 */
		public function set enabled(value:Boolean):void {
			
			if (value) {
				_toggle = new ToggleState();
				addChildAt(_toggle, 0);
				
			} else {
				if (_toggle) {
					removeChild(_toggle);
				}
			}
			
			_enabled = value;
			
		}
		
		public function get enabled():Boolean {
			return _enabled;
		}
	}
	
}


import flash.display.Shape;

final class ToggleState extends Shape {
	
	final public function ToggleState():void {
		
		graphics.beginFill(0xECE6CA, .3);
		graphics.drawRect(0,0,36,10);
		graphics.endFill();
		
		cacheAsBitmap = true;
	}

}