package onyx.transition {
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.EventDispatcher;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	
	import onyx.core.getBaseBitmap;
	import onyx.core.onyx_internal;
	import onyx.layer.IContent;
	import onyx.layer.ILayer;
	
	use namespace onyx_internal;
	
	/**
	 * 	Transition
	 */
	public class Transition extends EventDispatcher {
		
		/** @private **/
		onyx_internal var _duration:int;

		/** @private **/
		private var _startTime:int;

		/** @private **/
		onyx_internal var oldContent:IContent;

		/** @private **/
		onyx_internal var newContent:IContent;
		
		/** stores name of the transition **/
		public var name:String;
		
		/** stores layer **/
		private var _layer:ILayer;
		
		/**
		 * 	Constructor
		 */
		public function Transition(name:String, duration:int = 2000):void {
			this.name = name;
			_duration = duration;
		}
		
		/**
		 * 	@private
		 */
		onyx_internal final function initializeTransition(oldContent:IContent, newContent:IContent, layer:ILayer):void {
			
			_layer = layer;
			
			this.oldContent = oldContent;
			this.newContent = newContent;
			
			_startTime = getTimer();

			// initialize();
		}
		
		/**
		 * 	@private
		 */
		onyx_internal final function calculateTransition(bitmapData:BitmapData):void {

			var time:Number = (getTimer() - _startTime) / _duration;

			// first draw the new content
			var oldbmp:BitmapData = oldContent.draw();
			bitmapData.copyPixels(oldbmp, oldbmp.rect, new Point(0,0));
			
			// apply transition
			applyTransition(bitmapData, newContent.draw(), Math.min(time,1));
			
			if (time >= 1) {
				dispose();
			}
		}

		public function initialize():void {
		}
		
		public function applyTransition(oldContent:BitmapData, newContent:BitmapData, time:Number):void {
		}

		/**
		 * 	Sets duration
		 */		
		final public function set duration(value:int):void {
			_duration = value;
		}
		
		/**
		 * 	Gets duration
		 */
		final public function get duration():int {
			return _duration;
		}
		
		/**
		 * 	Destroys
		 */
		public function dispose():void {
			_layer.endTransition(this);
			
			this.oldContent	= null;
			this.newContent	= null;
			_layer			= null;
		}
		
		override public function toString():String {
			return name;
		}
	}
}