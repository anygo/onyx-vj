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
		 * 	Store multiplier
		 */
		public static const DEFAULT_FACTOR:Object	= { 
			multiplier: .001,
			factor:		25,
			toFixed:	2
		};
		
		/**
		 * 	@private
		 */
		protected var timer:Timer;
		
		/**
		 * 	@private
		 */
		protected var _delay:int					= 100;
		
		/**
		 * 	@private
		 */
		private var _snapTempo:Boolean				= true;
		
		/**
		 * 	@private
		 */
		private var _snapControl:ControlBoolean		= new ControlBoolean('snapTempo', 'Use Tempo');

		
		/**
		 * 	@private
		 */
		private var _delayControl:ControlInt		= new ControlInt('delay', 'delay', 1, 5000, 0, DEFAULT_FACTOR);

		/**
		 * 	@constructor
		 */
		final public function TempoFilter(unique:Boolean, ... controls:Array):void {
			
			super(unique);
			controls.unshift(
				_snapControl,
				_delayControl
			);
			super.controls.addControl.apply(null, controls);
		}
		
		/**
		 * 
		 */
		final public function set delay(value:int):void {
			_delay = _delayControl.setValue(value);
			if (timer) {
				timer.delay = _delay;
			}
		}
		
		/**
		 * 	Sets delay
		 */
		final public function get delay():int {
			return _delay;
		}
		
		/**
		 * 	Whether or not the filter snaps to beat
		 */
		final public function set snapTempo(value:Boolean):void {
			
			// remove timer stuff
			if (timer) {
				timer.removeEventListener(TimerEvent.TIMER, onTimer);
				timer.stop();
				timer = null;
			}
			
			// remove tempo stuff
			var tempo:Tempo = Tempo.getInstance();
			tempo.removeEventListener(TempoEvent.CLICK, onTempo);
			
			// set value
			_snapTempo = _snapControl.setValue(value);
			
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
				tempo.addEventListener(TempoEvent.CLICK, onTempo);
				
			} else {
				
				timer = new Timer(_delay);
				timer.start();
				timer.addEventListener(TimerEvent.TIMER, onTimer);
				
			}
			
		}
		
		/**
		 * 	@private
		 */
		protected function onTempo(event:TempoEvent):void {
			onTrigger(event.beat, event);
		}
		
		/**
		 * 	@private
		 */
		protected function onTimer(event:TimerEvent):void {
			onTrigger((event.currentTarget as Timer).currentCount, event);
		}

		/**
		 * 
		 */
		protected function onTrigger(beat:int, event:Event):void {
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
				timer.removeEventListener(TimerEvent.TIMER, onTimer);
				timer = null;
			}
			
			var tempo:Tempo = Tempo.getInstance();
			tempo.removeEventListener(TempoEvent.CLICK, onTempo);
			
			_snapControl	= null;
			_delayControl	= null;
		}
	}
}