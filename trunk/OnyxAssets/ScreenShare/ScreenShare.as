package {
	
	import cursor.*;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.ColorMatrixFilter;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	
	import onyx.content.IContent;
	import onyx.controls.*;
	import onyx.core.RenderTransform;
	import onyx.plugin.IContentObject;
	import flash.display.DisplayObjectContainer;

	/**
	 * 
	 */
	[SWF(width='320', height='240', frameRate='24')]
	public class ScreenShare extends Sprite implements IControlObject, IContentObject {
		
		private var _stage:DisplayObjectContainer;
		private var _mouseX:int;
		private var _mouseY:int;
		private var _scale:Number			= 1;
		private var _cursor:Cursor			= new Cursor();
		private var _backgroundColor:uint 	= 0x000000;
		
		private var _controls:Controls;
		
		public function ScreenShare():void {
			_controls = new Controls(this,
				new ControlInt('scale', 'scale', 1, 200, 100),
				new ControlColor('backgroundColor', 'Background Color')
			);
		}
		
		public function initialize(stage:DisplayObjectContainer, content:IContent):void {
			
			_stage	= stage;
			
			_mouseX = stage.mouseX;
			_mouseY = stage.mouseY;
			
			_stage.addEventListener(MouseEvent.MOUSE_DOWN, _onMouseDown);
			_stage.addEventListener(MouseEvent.MOUSE_MOVE, _onMouseMove, false);
		}
		
		/**
		 * 	@private
		 */
		private function _onMouseDown(event:MouseEvent):void {
			_stage.addEventListener(MouseEvent.MOUSE_UP, _onMouseUp);
			
			_mouseX = _stage.mouseX;
			_mouseY = _stage.mouseY;
			
			_stage.removeEventListener(MouseEvent.MOUSE_MOVE, _onMouseMove);
		}
		
		/**
		 * 	@private
		 */
		private function _onMouseUp(event:MouseEvent):void {
			_stage.removeEventListener(MouseEvent.MOUSE_UP, _onMouseUp);
			_stage.addEventListener(MouseEvent.MOUSE_MOVE, _onMouseMove);
		}
		
		/**
		 * 	@private
		 */
		private function _onMouseMove(event:MouseEvent):void {
			_mouseX = _stage.mouseX;
			_mouseY = _stage.mouseY;
		}
			
		/**
		 * 	@private
		 */
		public function render():RenderTransform {
			
			var transform:RenderTransform = new RenderTransform();
			transform.content	= _stage;
			transform.rect		= new Rectangle(0,0,320,240);

			var offsetX:int		= _stage.mouseX - 160;
			var offsetY:int		= _stage.mouseY - 120;
			var matrix:Matrix	= new Matrix();
			matrix.translate(-offsetX, -offsetY);
			transform.matrix	= matrix;

			return transform;
		}
		
		/**
		 * 
		 */
		public function set backgroundColor(value:uint):void {
			_backgroundColor = controls.getControl('backgroundColor').setValue(value);
		}
		
		/**
		 * 
		 */
		public function get backgroundColor():uint {
			return _backgroundColor;
		}

		/**
		 * 	Returns scale
		 */
		public function set scale(value:int):void {
			_scale = value / 100;
		}
		
		/**
		 * 
		 */
		public function get scale():int {
			return _scale * 100;
		}
		
		/**
		 * 	Returns custom controls
		 */
		public function get controls():Controls {
			return _controls;
		}

		/**
		 * 	dispose
		 */
		public function dispose():void {
			_controls.dispose();
			_controls = null;
		}
	}
}