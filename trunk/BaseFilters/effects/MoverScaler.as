package effects {
	
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import onyx.controls.*;
	import onyx.core.Tempo;
	import onyx.events.TempoEvent;
	import onyx.filter.TempoFilter;
	import onyx.tween.*;
	import onyx.tween.easing.*;

	public final class MoverScaler extends TempoFilter {
		
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
		 * 
		 */
		override protected function onTrigger(beat:int, event:Event):void {
			
			if (event is TimerEvent) {
				delay = (((maxdelay - mindelay) * Math.random()) + mindelay) * 1000;
			}
			
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
			super.dispose();
		}
	}
}