package onyx.controls {
	
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;

	dynamic public final class Controls extends Dictionary {
		
		private var _target:Object;
		
		public function Controls(target:Object, ... controls:Array):void {
			
			super(true);
			
			_target = target;

			for each (var control:Control in controls) {
				control.target = _target;
				this[control.property] = control;
			}
			
		}
		
		public function addControl(... controls:Array):void {
			for each (var control:Control in controls) {
				control.target = _target;
				this[control.property] = control;
			}
		}
	
		public function setValue(name:String, value:*):void {
			var control:Control = this[name];
			control.value = value;
		}
		
		public function update():void {
			for each (var control:Control in this) {
				control.update();
			}
		}
		
		public function dispose():void {
			_target = null;
		}
		
		public function toString():String {
			var items:Array = [];
			
			for each (var i:Object in this) {
				items.push(i.toString());
			}
			
			return '[Controls: ' + items.join(',') + ']';
		}
		
	}
}