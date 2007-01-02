package onyx.events {

	import flash.events.Event;
	
	import onyx.net.Plugin;
	
	public class PluginEvent extends Event {

		public static const PLUGIN_LOADED:String = 'plugin_loaded';

		public var plugin:Plugin;
		public var pluginType:Class;
		
		public function PluginEvent(plugin:Plugin, pluginType:Class):void {
			
			this.plugin = plugin;
			this.pluginType = pluginType;
			
			super(PLUGIN_LOADED);
			
		}
		
		override public function clone():Event {
			return new PluginEvent(plugin, pluginType);
		}
		
	}
}