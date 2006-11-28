package ui.window
{
	import flash.events.Event;
	import flash.utils.getTimer;
	
	import onyx.application.Onyx;
	import onyx.controls.ControlInt;
	import onyx.events.ControlEvent;
	
	import ui.text.TextField;
	
	public final class PerfMonitor extends Window {
		
		private var _lasttime:int = getTimer();
		private var _framerate:ControlInt;
		
		private var _target:TextField = new TextField(55,9);
		private var _label:TextField = new TextField(55,9);
		
		public function PerfMonitor():void {
			
			_framerate = Onyx.controls.framerate;
			_framerate.addEventListener(ControlEvent.CONTROL_CHANGED, _frameRateChange);

			_draw();
			
			_applyEventHandlers();
		}
		
		private function _draw():void {
			
			title = 'PERFORMANCE';
			
			x = 760;
			y = 494;
			
			width = 60;
			height = 30;

			addChildren(
				_target,	2, 12,
				_label,	2, 21
			);
			
			// _frameRateChange();

		}
		
		private function _frameRateChange(event:ControlEvent = null):void {
			_target.text = 'target: ' + _framerate.value;
		}
		
		private function _applyEventHandlers():void {
			
			addEventListener(Event.ADDED, _onAdded);
		}
		
		private function _onAdded(event:Event):void {

			addEventListener(Event.ENTER_FRAME, _onEnterFrame);
			_lasttime = getTimer();

		}
		
		private function _onRemoved(event:Event):void {

			removeEventListener(Event.ENTER_FRAME, _onEnterFrame);

		}
		
		private function _onEnterFrame(event:Event):void {
			
			_label.text = 'actual: ' + Math.round((1000 / (getTimer() - _lasttime))).toString();
			_lasttime = getTimer();
			
		}
		
		override public function dispose():void {
			
			removeEventListener(Event.ENTER_FRAME, _onEnterFrame);
			removeEventListener(Event.ADDED, _onAdded);
			_framerate.removeEventListener(ControlEvent.CONTROL_CHANGED, _frameRateChange);

			_framerate = null;
			_target = null;
			_label = null;
			_lasttime = NaN;
	
			super.dispose();
		}
	}
}