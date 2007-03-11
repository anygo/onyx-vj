package {
	
	import flash.display.Sprite;
	
	import onyx.controls.ControlLayer;
	import onyx.controls.Controls;
	import onyx.controls.IControlObject;
	import onyx.core.IRenderObject;
	import onyx.core.RenderTransform;
	import onyx.layer.ILayer;

	public class LayerCopy extends Sprite implements IRenderObject, IControlObject {
		
		private var _controls:Controls;
		private var _layer:ILayer;
		
		public function LayerCopy():void {
			 _controls = new Controls(this,
			 	new ControlLayer('layer', 'layer')
			 );
		}
		
		public function get layer():ILayer {
			return _layer;
		}
		
		public function set layer(value:ILayer):void {
			this._layer = value;
		}
		
		public function get controls():Controls {
			return _controls;
		}
		
		public function render():RenderTransform {
			
			var transform:RenderTransform = new RenderTransform();
			transform.content = _layer ? _layer.rendered : null;
			
			return transform;
		}
		
		public function dispose():void {
			_controls.dispose();
			_controls	= null;
			_layer		= null;
		}
	}
}
