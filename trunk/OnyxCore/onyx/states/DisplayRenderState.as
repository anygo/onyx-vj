package onyx.states {
	
	import flash.events.Event;
	
	import onyx.constants.*;
	import onyx.display.Display;
	import onyx.display.IDisplay;
	
	public final class DisplayRenderState extends ApplicationState {

		private var display:IDisplay;
		
		public function DisplayRenderState(display:Display):void {
			this.display = display;
		}
		
		override public function initialize():void {
			STAGE.addEventListener(Event.ENTER_FRAME, _frame);
		}
		
		private function _frame(event:Event):void {
			display.render();
		}
		
		override public function pause():void {
			STAGE.removeEventListener(Event.ENTER_FRAME, _frame);
		}
		
		override public function terminate():void {
			display = null;
		}
	}
}