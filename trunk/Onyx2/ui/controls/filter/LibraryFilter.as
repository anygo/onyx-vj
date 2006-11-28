package ui.controls.filter {

	import onyx.filter.Filter;
	import onyx.filter.Filter;
	
	import ui.assets.AssetLayerFilterInactive;
	import ui.controls.ButtonClear;
	import ui.controls.UIControl;
	import ui.text.Style;
	import ui.text.TextField;
	
	public final class LibraryFilter extends UIControl {
		
		private var _filter:Class;
		private var _label:TextField = new TextField(70,12);
		private var _btn:ButtonClear = new ButtonClear(90,12);
		private var _bg:AssetLayerFilterInactive = new AssetLayerFilterInactive();
		
		public function LibraryFilter(filter:Class):void {
			
			_filter = filter;
			_draw();
			
		}
		
		private function _draw():void {
			
			_label.text		= _filter.name;
			_label.y			= 2;
			_label.x			= 2;
			
			addChild(_bg);
			addChild(_label);
			addChild(_btn);
		}
		
		public function get index():int {
			return _filter.index;
		}
		
		public function get filter():Filter {
			return new _filter();
		}
	}
}