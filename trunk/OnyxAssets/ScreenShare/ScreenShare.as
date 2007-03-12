package {
	
	import cursor.*;
	
	import flash.display.*;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.ColorMatrixFilter;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	
	import onyx.constants.*;
	import onyx.content.IContent;
	import onyx.controls.*;
	import onyx.core.IRenderObject;
	import onyx.core.RenderTransform;

	/**
	 * 
	 */
	[SWF(width='320', height='240', frameRate='24')]
	public class ScreenShare extends Sprite implements IControlObject, IRenderObject {

		/**
		 * 	@private
		 */
		private var _mouseX:int;

		/**
		 * 	@private
		 */
		private var _mouseY:int;

		/**
		 * 	@private
		 */
		private var _scale:Number			= 1;

		/**
		 * 	@private
		 */
		private var _backgroundColor:uint 	= 0x000000;

		/**
		 * 	@private
		 */
		private var _controls:Controls;
		
		/**
		 * 	@constructor
		 */
		public function ScreenShare():void {
			_controls = new Controls(this,
				new ControlInt('scale', 'scale', 1, 200, 100),
				new ControlColor('backgroundColor', 'Background Color')
			);
			

			_mouseX = STAGE.mouseX;
			_mouseY = STAGE.mouseY;
			
			STAGE.addEventListener(MouseEvent.MOUSE_DOWN, _onMouseDown);
			STAGE.addEventListener(MouseEvent.MOUSE_MOVE, _onMouseMove);
		}
		
		/**
		 * 	@private
		 */
		private function _onMouseDown(event:MouseEvent):void {
			STAGE.addEventListener(MouseEvent.MOUSE_UP, _onMouseUp);
			
			_mouseX = STAGE.mouseX;
			_mouseY = STAGE.mouseY;
			
			STAGE.removeEventListener(MouseEvent.MOUSE_MOVE, _onMouseMove);
		}
		
		/**
		 * 	@private
		 */
		private function _onMouseUp(event:MouseEvent):void {
			STAGE.removeEventListener(MouseEvent.MOUSE_UP, _onMouseUp);
			STAGE.addEventListener(MouseEvent.MOUSE_MOVE, _onMouseMove);
		}
		
		/**
		 * 	@private
		 */
		private function _onMouseMove(event:MouseEvent):void {
			_mouseX = STAGE.mouseX;
			_mouseY = STAGE.mouseY;
		}
			
		/**
		 * 	@private
		 */
		public function render():RenderTransform {
			
			var transform:RenderTransform = new RenderTransform();
			transform.content	= STAGE;
			transform.rect		= new Rectangle(0,0,320,240);

			var offsetX:int		= STAGE.mouseX - 160;
			var offsetY:int		= STAGE.mouseY - 120;
			
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
			
			STAGE.removeEventListener(MouseEvent.MOUSE_DOWN, _onMouseDown);
			STAGE.removeEventListener(MouseEvent.MOUSE_MOVE, _onMouseMove);

		}
	}
}