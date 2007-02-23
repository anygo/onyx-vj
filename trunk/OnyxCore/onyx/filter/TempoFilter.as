package onyx.filter {
	
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import onyx.controls.*;
	import onyx.core.Tempo;
	import onyx.core.onyx_ns;
	import onyx.events.TempoEvent;
	import onyx.tween.*;
	import onyx.tween.easing.*;
	
	use namespace onyx_ns;
	
	public class TempoFilter extends Filter {
		
		/**
		 * 	@private
		 */
		protected var timer:Timer;
		
		/**
		 * 	@private
		 */
		protected var delay:int				= 100;
		
		/**
		 * 	@private
		 */
		private var _snapTempo:Boolean		= true;
		

		/**
		 * 	@constructor
		 */
		final public function TempoFilter(unique:Boolean, ... controls:Array):void {
			
			super(unique);
			controls.unshift(new ControlBoolean('snapTempo', 'Use Tempo'));
			super.controls.addControl.apply(null, controls);
		}
		
		/**
		 * 	Whether or not the filter snaps to beat
		 */
		final public function set snapTempo(value:Boolean):void {
			
			// remove timer stuff
			if (timer) {
				timer.removeEventListener(TimerEvent.TIMER, _onTimer);
				timer.stop();
				timer = null;
			}
			
			// remove tempo stuff
			var tempo:Tempo = Tempo.getInstance();
			tempo.removeEventListener(TempoEvent.CLICK, _onTempo);
			
			// set value
			_snapTempo = value;
			
			// re-init
			if (content) {
				initialize();
			}
		}
		
		/**
		 * 
		 */
		final public function get snapTempo():Boolean {
			return _snapTempo;
		}
		
		/**
		 * 	initialize
		 */		
		override public function initialize():void {
			
			if (_snapTempo) {

				var tempo:Tempo = Tempo.getInstance();
				tempo.addEventListener(TempoEvent.CLICK, _onTempo);
				
			} else {
				
				timer = new Timer(delay);
				timer.start();
				timer.addEventListener(TimerEvent.TIMER, _onTimer);
				
			}
			
		}
		
		/**
		 * 	@private
		 */
		final private function _onTempo(event:TempoEvent):void {
			onTrigger(event.beat);
		}
		
		
		/**
		 * 	@private
		 */
		final private function _onTimer(event:TimerEvent):void {
			onTrigger((event.currentTarget as Timer).currentCount);
		}

		/**
		 * 
		 */
		protected function onTrigger(beat:int):void {
			trace('BEAT');
		}

		/**
		 * 	Dispose
		 */
		override public function dispose():void {
			
			super.dispose();
			
			// stop the timer
			if (timer) {
				timer.stop();
				timer.removeEventListener(TimerEvent.TIMER, _onTimer);
				timer = null;
			}
			
			var tempo:Tempo = Tempo.getInstance();
			tempo.removeEventListener(TempoEvent.CLICK, _onTempo);
		}
	}
}