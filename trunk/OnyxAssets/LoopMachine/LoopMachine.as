package {
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	
	import onyx.constants.*;
	import onyx.controls.*;
	import onyx.core.*;
	import onyx.events.ControlEvent;
	import onyx.layer.ILayer;
	import flash.display.BitmapData;
	import flash.display.Bitmap;
	import onyx.display.IDisplay;

	[SWF(width='320', height='240', frameRate='24')]
	public class LoopMachine extends MovieClip implements IControlObject {
		
		/**
		 * 
		 */
		private var _bitmap:Bitmap		= new Bitmap();
		
		/**
		 * 
		 */
		public var maxframes:int		= 240;
		
		/**
		 * 
		 */
		private var _currentFrame:int	= 0;
		
		/**
		 * 	@private
		 */
		private var _controls:Controls;
		
		/**
		 * 	@private
		 */
		private var _layer:IDisplay		= Onyx.displays[0];
		
		/**
		 * 	@private
		 */
		private var _frames:Array		= [];
		
		/**
		 * 	@constructor
		 */
		public function LoopMachine():void {
			_controls = new Controls(this,
				new ControlDisplay('layer', 'layer'),
				new ControlBoolean('record', 'record', 1),
				new ControlInt('maxframes', 'frames', 120, 640, 240)
			);
			
			addChild(_bitmap);
		}
		
		/**
		 * 
		 */
		public function set record(value:Boolean):void {
			if (value && _layer) {
				addEventListener(Event.ENTER_FRAME, _record);
				_currentFrame = 0;
			} else {
				removeEventListener(Event.ENTER_FRAME, _record);
			}
		}
		
		/**
		 * 	@private
		 */
		private function _record(event:Event):void {
			if (_currentFrame >= maxframes) {
				_controls.getControl('record').value = false;
			}

			_frames[_currentFrame++] = _layer.rendered.clone();
		}

		/**
		 * 
		 */
		public function get record():Boolean {
			return hasEventListener(Event.ENTER_FRAME);
		}
		
		/**
		 * 
		 */
		override public function get totalFrames():int {
			return _frames.length + 1;
		}
		
		/**
		 * 
		 */
		public function get layer():IDisplay {
			return _layer;
		}
		
		/**
		 * 
		 */
		public function set layer(value:IDisplay):void {
			_layer = value;
		}
		
		/**
		 * 
		 */
		override public function gotoAndStop(frame:Object, scene:String = null):void {
			if (frame is int) {
				var num:int = frame as int;
				var bmp:BitmapData = _frames[num];
				
				if (bmp) {
					_bitmap.bitmapData = bmp;
				}
			}
		}
		
		public function get controls():Controls {
			return _controls;
		}
		
		public function dispose():void {
			removeEventListener(Event.ENTER_FRAME, _record);

			for each (var bitmapData:BitmapData in _frames) {
				bitmapData.dispose();
			}

			_frames = null;
			_layer = null;
		}
		
		public function render():RenderTransform {
			return null;
		}
	}
}
