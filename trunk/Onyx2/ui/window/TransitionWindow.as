package ui.window {
	
	import onyx.application.Onyx;
	import onyx.controls.ControlRange;
	import onyx.events.TransitionEvent;
	import onyx.layer.Layer;
	
	import ui.controls.DropDown;
	
	public final class TransitionWindow extends Window {

		private var data:Array = [{ name: 'None' }];
		private var dropdown:DropDown;
		
		private var control:ControlRange = new ControlRange('transition', 'Transition', data, 0);
		
		public function TransitionWindow():void {
			
			control.target = this;
			
			title = 'TRANSITIONS';
			x = 6;
			y = 526;
			width = 190;
			height = 50;
			
			Onyx.addEventListener(TransitionEvent.TRANSITION_CREATED, _onTransitionCreate);
			
			dropdown = new DropDown(control, true, 100, 18, 'left', 'name');
			dropdown.y = 14;
			addChild(dropdown);
		}
		
		public function get transition():* {
			return Layer.transitionClass;
		}
		
		public function set transition(value:*):void {
			Layer.transitionClass = (value is Class) ? value : null;
		}
		
		public function _onTransitionCreate(event:TransitionEvent):void {
			data.push(event.definition);
			
			if (Onyx.transitions.length === 1) {
				Layer.transitionClass = event.definition;
			}
		}
		
		override public function dispose():void {
			Onyx.removeEventListener(TransitionEvent.TRANSITION_CREATED, _onTransitionCreate);
		}
		
	}
}