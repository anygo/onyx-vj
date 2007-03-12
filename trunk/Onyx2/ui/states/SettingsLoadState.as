package ui.states {
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import onyx.core.Console;
	import onyx.filter.Filter;
	import onyx.plugin.Plugin;
	import onyx.states.ApplicationState;
	import onyx.states.StateManager;

	/**
	 * 	Load settings
	 */
	public final class SettingsLoadState extends ApplicationState {

		/**
		 * 	Path
		 */
		public static const PATH:String = 'settings.xml';

		/**
		 * 	@private
		 */
		private var displayState:DisplayStartState;

		/**
		 * 
		 */
		override public function initialize(... args:Array):void {
			
			displayState = args[0];
			
			var loader:URLLoader = new URLLoader();
			loader.addEventListener(Event.COMPLETE,			_onLoad);
			loader.addEventListener(IOErrorEvent.IO_ERROR,	_onLoad);
			loader.load(new URLRequest(PATH));
		}
		
		/**
		 * 	@private
		 */
		private function _onLoad(event:Event):void {
			var loader:URLLoader = event.currentTarget as URLLoader;
			loader.removeEventListener(IOErrorEvent.IO_ERROR,	_onLoad);
			loader.removeEventListener(Event.COMPLETE,			_onLoad);
			
			try {
				var xml:XML = new XML(loader.data);
				parse(xml);
			} catch (e:Error) {
				Console.output(e);
			}
		}

		/**
		 * 	@private
		 * 	Parses the settings
		 */
		private function parse(xml:XML):void {
			
			for each (var filter:XML in xml.filters.order.filter) {
				var plugin:Plugin = Filter.getDefinition(filter.@name);
				plugin.index = filter.@index;
			}
			
			// kill myself
			StateManager.removeState(this);
		}
		
		override public function terminate():void {

			// remove the startup image
			StateManager.removeState(displayState);

		}
	}
}