package ui {
	
	import flash.display.Stage;
	import flash.display.StageQuality;
	import flash.events.KeyboardEvent;
	
	import onyx.application.Onyx;
	import onyx.events.DisplayEvent;
	import onyx.events.LayerEvent;
	import onyx.external.files.*;
	
	import ui.assets.*;
	import ui.core.ui_internal;
	import ui.layer.UILayer;
	import ui.window.*;
	import onyx.layer.Layer;

	public class UIManager {

		private static var _root:Stage;
		
		// initialize
		public static function initialize(root:Stage):void {
			
			// store the root
			_root = root;
			
			// low quality
			root.stage.quality = StageQuality.LOW;
			
			// add our windows
			_loadWindows(Console, PerfMonitor, Browser, Filters, TransitionWindow);
			
			// listen for windows created
			Onyx.addEventListener(LayerEvent.LAYER_CREATED, _onLayerCreate);
			Onyx.addEventListener(DisplayEvent.DISPLAY_CREATED, _onDisplayCreate);

			// initializes onyx
			Onyx.initialize(root);
			
			// listen for keys
			root.addEventListener(KeyboardEvent.KEY_DOWN, _onKeyPress);
			
//			var layer:Layer = new Layer();
		}
		
		// add windows
		private static function _loadWindows(... windowsToLoad:Array):void {

			for each (var window:Class in windowsToLoad) {
				_root.addChild(new window());
			}

		}
		
		/**
		 * 
		 */
		private static function _onDisplayCreate(event:DisplayEvent):void {
			var display:SettingsWindow = new SettingsWindow(event.display);
			_root.addChild(display);
		}
		
		// when a layer is created
		private static function _onLayerCreate(event:LayerEvent):void {
			
			var uilayer:UILayer = new UILayer(event.layer);
			uilayer.moveLayer();

			_root.addChild(uilayer);
			
		}
		
		private static function _onKeyPress(event:KeyboardEvent):void {
			
			var layer:UILayer;
			
			switch (event.keyCode) {
				case 37:
					layer = UILayer.getLayerAt(UILayer.selectedLayer.index - 1);
					if (layer) {
						UILayer.selectLayer(layer);
					}
					
					break;
				case 39:
					layer = UILayer.getLayerAt(UILayer.selectedLayer.index + 1);
					if (layer) {
						UILayer.selectLayer(layer);
					}

					break;
				case 38:
				case 40:
					trace('key');
					break;
			}
		}
		
	}
}