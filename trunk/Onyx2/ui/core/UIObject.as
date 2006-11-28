package ui.core {
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	import flash.utils.getTimer;
	
	import onyx.core.IDisposable;

	public class UIObject extends Sprite {
		
		private static var _doubleObject:UIObject;
		private static var _doubleTime:int;
		
		protected function addChildren(... args:Array):void {
			
			var len:int = args.length;
			for (var count:int = 0; count < len; count+=3) {
				args[count].x = args[count+1];
				args[count].y = args[count+2];
				addChild(args[count]);
			}
			
		}
		
		public function UIObject():void {

			addEventListener(MouseEvent.MOUSE_DOWN, moveToTop);

		}
		
		public override function set doubleClickEnabled(s:Boolean):void {
			if (s) {
				addEventListener(MouseEvent.MOUSE_DOWN, _mouseDown, true, 0, true);
			} else {
				removeEventListener(MouseEvent.MOUSE_DOWN, _mouseDown, true);
			}
		}
		
		private function _mouseDown(event:MouseEvent):void {

			if (_doubleObject == this && getTimer() - _doubleTime < 250) {
				event.stopPropagation();
				dispatchEvent(new MouseEvent(MouseEvent.DOUBLE_CLICK));
			}
			
			_doubleObject = this;
			_doubleTime = getTimer();
		}
		
		public function dispose():void {
			
			clearChildren();
			
			removeEventListener(MouseEvent.MOUSE_DOWN, moveToTop);

		}
		
		public function clearChildren():void {
			
			var numChildren:int = numChildren;
			for (var count:int = 0; count < numChildren; count++) {
				var child:DisplayObject = getChildAt(0);
				removeChild(child);
				
				if (child is IDisposable) {
					(child as IDisposable).dispose();
				}
			}
		}
		
		public function highlight(color:uint, amount:Number):void {
			
			var transform:ColorTransform = new ColorTransform();
			
			var r:int = ((color & 0xFF0000) >> 16) * amount;
			var g:int = ((color & 0x00FF00) >> 8) * amount;
			var b:int = ((color & 0x0000FF)) * amount;
			
			var newcolor:int = r << 16 ^ g << 8 ^ b;
			
			transform.color = newcolor;
			transform.redMultiplier = 1-amount;
			transform.greenMultiplier = 1-amount;
			transform.blueMultiplier = 1-amount;
			
			this.transform.colorTransform = transform;
			
		}
		
		public function moveToTop(event:MouseEvent = null):void {
			if (parent) {
				parent.setChildIndex(this, parent.numChildren - 1);
			}
		}	
	}
}