package {
	
	import flash.display.Sprite;
	
	import onyx.controls.ControlLayer;
	import onyx.controls.Controls;
	import onyx.controls.IControlObject;
	import onyx.core.IRenderObject;
	import onyx.core.RenderTransform;
	import onyx.layer.ILayer;

	public class LayerCopy extends Sprite implements IRenderObject, IControlObject {
		
		/**
		 * 	@private
		 */
		private var _controls:Controls;

		/**
		 * 	@private
		 */
		private var _layer:ILayer;
		
		/**
		 * 	@constructor
		 */
		public function LayerCopy():void {
			 _controls = new Controls(this,
			 	new ControlLayer('layer', 'layer')
			 );
		}
		
		/**
		 * 	The layer to render
		 */
		public function get layer():ILayer {
			return _layer;
		}
		
		/**
		 * 	The layer to render
		 */
		public function set layer(value:ILayer):void {
			this._layer = value;
		}
		
		/**
		 * 	Return controls
		 */
		public function get controls():Controls {
			return _controls;
		}
		
		/**
		 * 	Render, called from Onyx
		 */
		public function render():RenderTransform {
			
			var transform:RenderTransform = new RenderTransform();
			transform.content = _layer ? _layer.rendered : null;
			
			return transform;
		}
		
		/**
		 * 	Dispose, called from onyx
		 */
		public function dispose():void {
			_controls.dispose();
			_controls	= null;
			_layer		= null;
		}
	}
}
