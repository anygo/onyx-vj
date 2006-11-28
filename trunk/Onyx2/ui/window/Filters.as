package ui.window {
	
	import flash.events.MouseEvent;
	
	import onyx.application.Onyx;
	import onyx.events.FilterEvent;
	
	import ui.controls.filter.LibraryFilter;
	import ui.core.DragManager;
	import ui.core.UIObject;
	import ui.events.DragEvent;
	import ui.layer.UILayer;
	
	public final class Filters extends Window {
		
		private static const ITEMS_PER_ROW:int	= 16;
		private static const ITEM_LENGTH:int	= 85;
		
		private var _library:Array = [];
		
		public function Filters():void {
			
			title = 'FILTERS';
			
			x = 408;
			y = 302;
			
			width = 194;
			height = 220;

			Onyx.addEventListener(FilterEvent.FILTER_CREATED, _onFilterCreate);
			
		}
		
		private function _onFilterCreate(event:FilterEvent):void {
			
			// create library ui item
			var lib:LibraryFilter = new LibraryFilter(event.definition);
			var index:int = lib.index;
			lib.x = 3 + (Math.floor(index / ITEMS_PER_ROW) * ITEM_LENGTH);
			lib.y = (index % ITEMS_PER_ROW) * 15 + 13;
			
			// add to the array
			_library.push(lib);
			
			// handle events
			lib.addEventListener(MouseEvent.MOUSE_DOWN, _onMouseDown);
			lib.addEventListener(MouseEvent.DOUBLE_CLICK, _onDoubleClick);
			lib.doubleClickEnabled = true;
			
			addChild(lib);
			
		}
		
		// double click auto-loads
		private function _onDoubleClick(event:MouseEvent):void {
			
			var control:LibraryFilter = event.target as LibraryFilter;
			UILayer.selectedLayer.addFilter(control.filter);
			
		}
		
		// when we start dragging
		private function _onMouseDown(event:MouseEvent):void {
			
			var control:LibraryFilter = event.currentTarget as LibraryFilter;
			DragManager.startDrag(control, UILayer.layers, _onDragOver, _onDragOut, _onDragDrop);
			
		}
		
		// drag functions
		private function _onDragOver(event:DragEvent):void {
			var obj:UIObject = event.currentTarget as UIObject;
			obj.highlight(0x800800, .15);
		}
		
		private function _onDragOut(event:DragEvent):void {
			var obj:UIObject = event.currentTarget as UIObject;
			obj.highlight(0, 0);
		}
		
		private function _onDragDrop(event:DragEvent):void {
			var uilayer:UILayer = event.currentTarget as UILayer
			var origin:LibraryFilter = event.origin as LibraryFilter;
			uilayer.highlight(0, 0);

			UILayer.selectLayer(uilayer);
			UILayer.selectedLayer.addFilter(origin.filter);
		}
	}
}