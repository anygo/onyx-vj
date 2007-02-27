package {
	
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.MouseEvent;
	import flash.filters.BlurFilter;
	import flash.geom.*;
	
	import onyx.content.*;
	import onyx.controls.ControlColor;
	import onyx.controls.Controls;
	import onyx.controls.IControlObject;
	import onyx.core.IDisposable;
	import onyx.core.RenderTransform;
	import onyx.plugin.*;
	import flash.display.DisplayObjectContainer;

	/**
	 * 	Drawing clip
	 * 	Control click on a layer the preview box to send mouse events to this file
	 */
	[SWF(width='320', height='240', frameRate='24')]
	public class DrawingClip extends Sprite implements IContentObject, IControlObject {
		
		public var color:uint	= 0xFFFFFF;
		
		private var _source:BitmapData		= new BitmapData(320,240,true, 0x00000000);
		private var _controls:Controls;
		
		public function DrawingClip():void {
			_controls = new Controls(this, 
				new ControlColor('color', 'color')
			);
			addEventListener(MouseEvent.MOUSE_DOWN, _onMouseDown);
		}
		
		public function initialize(root:DisplayObjectContainer, content:IContent):void {
		}
		
		private function _onMouseDown(event:MouseEvent):void {
			addEventListener(MouseEvent.MOUSE_MOVE, _onMouseMove);
			addEventListener(MouseEvent.MOUSE_UP, _onMouseUp);

			_draw(event.localX, event.localY);
		}

		private function _onMouseMove(event:MouseEvent):void {
			_draw(event.localX, event.localY);
		}
		
		private function _draw(x:int, y:int):void {
			graphics.beginFill(color);
			graphics.drawCircle(x, y, 3);
			graphics.endFill();
		}

		/**
		 * 	@private
		 */
		public function render():RenderTransform {
			
			var transform:RenderTransform = RenderTransform.getTransform(this);
			transform.content = _source;

			_source.scroll(2,1);
			_source.draw(this);

			graphics.clear();
			
			return transform;
		}
		
		private function _onMouseUp(event:MouseEvent):void {
			removeEventListener(MouseEvent.MOUSE_MOVE, _onMouseMove);
			removeEventListener(MouseEvent.MOUSE_UP, _onMouseUp);
		}
		
		public function get controls():Controls {
			return _controls;
		}
		
		public function dispose():void {

			_source.dispose();
			_source = null;
			
			removeEventListener(MouseEvent.MOUSE_MOVE, _onMouseMove);
			removeEventListener(MouseEvent.MOUSE_DOWN, _onMouseDown);
			removeEventListener(MouseEvent.MOUSE_UP, _onMouseUp);

			_controls.dispose();
			graphics.clear();

		}
	}
}