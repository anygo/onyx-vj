package onyx.core {
	
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.utils.*;
	
	import onyx.controls.IControlObject;
	import onyx.events.TempoEvent;
	import onyx.controls.Controls;
	import onyx.controls.ControlInt;
	
	[Event(name='click', type='onyx.events.TempoEvent')]
	
	/**
	 * 	Tempo
	 */
	public final class Tempo extends EventDispatcher implements IControlObject {
		
		/**
		 * 	@private
		 */
		private static var _instance:Tempo	= new Tempo();
		
		/**
		 * 	Dispatcher
		 */
		public static function getInstance():Tempo {
			return _instance;
		}
		
		/**
		 * 	@private
		 */
		private var _tempo:int				= 500;
		
		/**
		 * 	@private
		 */
		private var _timer:Timer;
		
		/**
		 * 	@private
		 */
		private var _last:int;
		
		/**
		 * 
		 */
		private var _controls:Controls;
		
		/**
		 * 	@constructor
		 */
		public function Tempo():void {
			if (_instance) {
				throw new Error('Singleton Error.');
			} else {
				_timer		= new Timer(20);
				_controls	= new Controls(this,
					new ControlInt('tempo', 'tempo', 40, 1000, 500)
				);
			}
		}
		
		/**
		 * 	Stars the meter
		 */
		public function start():void {
			_timer.start();
			_timer.addEventListener(TimerEvent.TIMER, _onTimer);
			_last = getTimer();
			dispatchEvent(new TempoEvent());
		}
		
		/**
		 * 	Stops the meter
		 */
		public function stop():void {
			_timer.stop();
			_timer.removeEventListener(TimerEvent.TIMER, _onTimer);
		}
		
		/**
		 * 	@private
		 * 	Check to see if tempo has fired
		 */
		private function _onTimer(event:TimerEvent):void {
			
			var time:int = getTimer() - _last;
			
			if (time >= _tempo) {
				_last = getTimer() + (time - _tempo);
				dispatchEvent(new TempoEvent());
			}
		}
		
		/**
		 * 	Sets tempo
		 */
		public function set tempo(value:int):void {
			
			// offset by 3 cause it's a little slow sometimes
			_tempo = _controls.getControl('tempo').setValue(value - 6);
			start();
		}
		
		/**
		 * 	Gets tempo
		 */
		public function get tempo():int {
			return _tempo;
		}
		
		/**
		 * 	Override event listener to start automatically
		 */
		override public function addEventListener(type:String, listener:Function, useCapture:Boolean=false, priority:int=0.0, useWeakReference:Boolean=false):void {
			super.addEventListener(type, listener, useCapture, priority, useWeakReference);
			start();
		}
		
		
		/**
		 * 	If nothing is listening, stop
		 */
		override public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void {
			super.removeEventListener(type, listener, useCapture);
			if (!super.hasEventListener(TempoEvent.CLICK)) {
				stop();
			}
		}
		
		/**
		 * 	Disposes
		 */
		public function dispose():void {
		}
		
		/**
		 * 
		 */
		public function get controls():Controls {
			return _controls;
		}
		
	}
}