package ui.controls.filter {
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.utils.getTimer;
	
	import onyx.filter.Filter;
	import onyx.filter.Filter;
	import onyx.layer.Layer;
	
	import ui.assets.AssetLayerFilter;
	import ui.controls.ButtonClear;
	import ui.controls.UIControl;
	import ui.core.UIObject;
	import ui.layer.UILayer;
	import ui.text.Style;
	import ui.text.TextField;

	public final class LayerFilter extends UIObject {
		
		public var filter:Filter;
		private var _layer:Layer;

		private var _label:TextField			= new TextField(72,10);
		private var _btnDelete:ButtonClear		= new ButtonClear(9,9);
		private var _btnMoveUp:ButtonClear		= new ButtonClear(9,9);
		private var _btnMoveDown:ButtonClear	= new ButtonClear(9,9);
		private var _bg:AssetLayerFilter		= new AssetLayerFilter();
		
		public function LayerFilter(filter:Filter, layer:Layer):void {
			
			this.filter = filter;
			_layer = layer;
			_draw();
			
			doubleClickEnabled = true;
			
			_btnMoveUp.addEventListener(MouseEvent.MOUSE_DOWN, _onMoveUp, false, -1);
			_btnMoveDown.addEventListener(MouseEvent.MOUSE_DOWN, _onMoveDown, false, -1);
			_btnDelete.addEventListener(MouseEvent.MOUSE_DOWN, _onDeleteDown, false, -1);
			
		}
		
		private function _onDeleteDown(event:MouseEvent):void {
			_layer.removeFilter(filter);
		}
		
		private function _onMoveDown(event:MouseEvent):void {
			filter.moveUp();
		}
		
		private function _onMoveUp(event:MouseEvent):void {
			filter.moveDown();
		}
		
		private function _draw():void {
			
			_label.text			= filter.name;
			_label.y			= 2;
			_label.x			= 2;
			
			_btnDelete.x 		= 81;
			_btnDelete.y 		= 2;
			
			_btnMoveUp.x 		= 73;
			_btnMoveUp.y 		= 2;

			_btnMoveDown.x 		= 64;
			_btnMoveDown.y 		= 2;
			
			addChild(_bg);
			addChild(_label);
			addChild(_btnDelete);
			addChild(_btnMoveUp);
			addChild(_btnMoveDown);
			
		}
		
		public function get index():int {
			return filter.index;
		}
		
		override public function dispose():void {
			_btnMoveUp.removeEventListener(MouseEvent.MOUSE_DOWN,		_onMoveUp);
			_btnMoveDown.removeEventListener(MouseEvent.MOUSE_DOWN,		_onMoveDown);
			_btnDelete.removeEventListener(MouseEvent.MOUSE_DOWN,		_onDeleteDown);
			
			filter = null;
			_layer = null;
			
			super.dispose();
		}
		
		override public function toString():String {
			return '[UI: ' + filter.toString() + ']';
		}
		
	}
}