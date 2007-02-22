package onyx.filter {
	
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import onyx.controls.*;
	import onyx.core.Tempo;
	import onyx.events.TempoEvent;
	import onyx.tween.*;
	import onyx.tween.easing.*;
	
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
		public function TempoFilter(unique:Boolean, ... controls:Array):void {
			
			super(unique);
			controls.unshift(new ControlBoolean('snapTempo', 'Use Tempo'));
			super.controls.addControl.apply(null, controls);
		}
		
		/**
		 * 	Whether or not the filter snaps to beat
		 */
		public function set snapTempo(value:Boolean):void {
			
			// remove timer stuff
			if (timer) {
				timer.removeEventListener(TimerEvent.TIMER, onTrigger);
				timer.stop();
				timer = null;
			}
			
			// remove tempo stuff
			var tempo:Tempo = Tempo.getInstance();
			tempo.removeEventListener(TempoEvent.CLICK, onTrigger);
			
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
		public function get snapTempo():Boolean {
			return _snapTempo;
		}
		
		/**
		 * 	initialize
		 */		
		override public function initialize():void {

			if (_snapTempo) {

				var tempo:Tempo = Tempo.getInstance();
				tempo.addEventListener(TempoEvent.CLICK, onTrigger);
				
			} else {
				
				timer = new Timer(delay);
				timer.start();
				timer.addEventListener(TimerEvent.TIMER, onTrigger);
				
			}
		}
		
		/**
		 * 
		 */
		protected function onTrigger(event:Event):void {
		}

		/**
		 * 	Dispose
		 */
		override public function dispose():void {
			
			super.dispose();
			
			// stop the timer
			if (timer) {
				timer.stop();
				timer.removeEventListener(TimerEvent.TIMER, onTrigger);
				timer = null;
			}
			
			var tempo:Tempo = Tempo.getInstance();
			tempo.removeEventListener(TempoEvent.CLICK, onTrigger);
		}
	}
}