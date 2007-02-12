package onyx.jobs {

	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.Dictionary;
	
	import onyx.core.Console;
	import onyx.core.IDisposable;
	import onyx.display.Display;
	import onyx.jobs.onx.LayerLoadSettings;
	import onyx.layer.Layer;
	import onyx.layer.LayerSettings;
	import onyx.transition.Transition;
	
	public final class LoadONXJob implements IDisposable {
		
		/**
		 * 	@private
		 * 	The beginning layer to start loading on
		 */
		private var _origin:Layer
		
		/**
		 * 	@private
		 * 	The transition to load in
		 */
		private var _transition:Transition;
		
		/**
		 * 	@constructor
		 */
		public function LoadONXJob(request:URLRequest, layer:Layer, transition:Transition):void {
			
			_origin = layer;
			_transition = transition;
			
			var urlLoader:URLLoader = new URLLoader();
			urlLoader.addEventListener(Event.COMPLETE,						_onURLHandler);
			urlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR,	_onURLHandler);
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR,				_onURLHandler);
			urlLoader.load(request);
			
		}
		
		/**
		 * 	@private
		 */
		private function _onURLHandler(event:Event):void {
			
			var loader:URLLoader = event.currentTarget as URLLoader;
			loader.removeEventListener(Event.COMPLETE,						_onURLHandler);
			loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,	_onURLHandler);
			loader.removeEventListener(IOErrorEvent.IO_ERROR,				_onURLHandler);
			
			// success
			if (event is IOErrorEvent) {
				// error
			} else {
				
				try {
					
					var xml:XML			= new XML(loader.data);

					var display:Display = _origin.parent as Display;
					var layers:Array	= display.layers;
					var index:int		= layers.indexOf(_origin);
					var jobs:Array		= [];
					
					// loop through layers and apply settings
					for each (var layerXML:XML in xml.layer) {
						
						var layer:Layer				= layers[index++];
						
						// valid layer, load it
						if (layer) {
							
							var settings:LayerSettings	= new LayerSettings();
							settings.loadFromXML(layerXML);
							
							var job:LayerLoadSettings	= new LayerLoadSettings();
							job.layer					= layer;
							job.settings				= settings;
							
							jobs.push(job);
							
						// break out
						} else {
							break;
						}
					}

					if (_transition) {
						_loadStagger(jobs);
					} else {
						_loadImmediately(jobs);
					}
					
				} catch(e:Error) {
					Console.output(e.message)
				}
				
			}
		}
		
		/**
		 * 
		 */
		private function _loadImmediately(jobs:Array):void {
			
			for each (var job:LayerLoadSettings in jobs) {
				
				var layer:Layer				= job.layer;
				var settings:LayerSettings	= job.settings;

				layer.load(new URLRequest(settings.path), settings);

			}
			dispose();
		}
		
		/**
		 * 
		 */
		private function _loadStagger(jobs:Array):void {
			new StaggerONXJob(_transition, jobs);
			dispose();
		}
		
		/**
		 * 	Dispose
		 */
		public function dispose():void {
			_origin = null;
			_transition = null;
		}
	}
}