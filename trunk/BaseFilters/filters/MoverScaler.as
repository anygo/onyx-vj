package filters {
	
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import onyx.controls.*;
	import onyx.filter.Filter;
	import onyx.tween.*;
	import onyx.tween.easing.*;

	public final class MoverScaler extends Filter {
		
		private var _timer:Timer;
		public var mindelay:Number	= .4;
		public var maxdelay:Number	= 1;
		public var scaleMin:Number	= 1;
		public var scaleMax:Number	= 1.5;
		
		public function MoverScaler():void {

			super(
				true,
				new ControlNumber('mindelay',	'Min Delay', .1, 50, .4),
				new ControlNumber('maxdelay',	'Min Delay', .1, 50, 1),
				new ControlNumber('scaleMin', 'scale min', 1, 4, 1),
				new ControlNumber('scaleMax', 'scale max', 1, 4, 3)
			);
			
		}
		
		/**
		 * 	initialize
		 */		
		override public function initialize():void {
			_timer = new Timer(100);
			_timer.start();
			_timer.addEventListener(TimerEvent.TIMER, _onTimer);
		}
		
		/**
		 * 	@private
		 */
		private function _onTimer(event:TimerEvent):void {

			var delay:int = (((maxdelay - mindelay) * Math.random()) + mindelay) * 1000; 
			_timer.delay = delay;
			
			var scale:Number	= ((scaleMax - scaleMin) * Math.random()) + scaleMin;
			var ratio:Number	= (scale - 1);
			var x:int			= (scale - 1) * -320 * Math.random();
			var y:int			= (scale - 1) * -240 * Math.random();
			
			new Tween(
				content, 
				Math.max(delay * Math.random(), 32),
				new TweenProperty('x', content.x, x),
				new TweenProperty('y', content.y, y),
				new TweenProperty('scaleX', content.scaleX, scale),
				new TweenProperty('scaleY', content.scaleY, scale)
			);
		}

		/**
		 * 	Dispose
		 */
		override public function dispose():void {
			if (_timer) {
				_timer.stop();
				_timer.removeEventListener(TimerEvent.TIMER, _onTimer);
				_timer = null;
			}
			super.dispose();
		}
		
	}

}