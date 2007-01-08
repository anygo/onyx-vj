package onyx.jobs {

	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import onyx.layer.Layer;
	import onyx.display.Display;
	import onyx.layer.LayerSettings;
	
	public final class LoadONXJob {
		
		private var _origin:Layer
		
		public function LoadONXJob(request:URLRequest, layer:Layer):void {
			
			if (layer.parent is Display) {
				_origin = layer;
				
				var urlLoader:URLLoader = new URLLoader();
				urlLoader.addEventListener(Event.COMPLETE,			_onURLHandler);
				urlLoader.addEventListener(IOErrorEvent.IO_ERROR,	_onURLHandler);
				urlLoader.load(request);
			}
		}
		
		/**
		 * 	@private
		 */
		private function _onURLHandler(event:Event):void {
			
			trace(event);
			
			var loader:URLLoader = event.currentTarget as URLLoader;
			loader.removeEventListener(Event.COMPLETE, _onURLHandler);
			loader.removeEventListener(IOErrorEvent.IO_ERROR, _onURLHandler);
			
			// success
			if (!(event is IOErrorEvent)) {
				try {
					
					var xml:XML			= new XML(loader.data);
					var display:Display = _origin.parent as Display;
					var layers:Array	= display.layers;
					var index:int		= layers.indexOf(_origin);
					
					// loop through layers and apply settings
					for each (var layerXML:XML in xml.layer) {
						
						var layer:Layer				= layers[index++];
						
						// valid layer, load it
						if (layer) {
							var settings:LayerSettings	= new LayerSettings();
							settings.loadFromXML(layerXML);
							layer.load(new URLRequest(settings.path), settings);
							
							trace(settings.path);
							
						// break out
						} else {
							break;
						}
					}
					
				} catch(e:Error) {
				}
				
			}
			
			_origin = null;

		}
		
	}
}