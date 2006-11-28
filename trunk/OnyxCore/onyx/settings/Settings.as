package onyx.settings {
	
	import onyx.core.StaticDispatcher;
	
	public final class Settings extends StaticDispatcher {
		
		public static var PATH_SETTINGS_FILE:String			= 'settings.xml';
		public static var INITIAL_DISPLAYS_TO_LOAD:uint		= 5;
		public static var MUTE_AUDIO:Boolean				= true;
		public static var COPY_LAYER_FILTERS:Boolean		= false;
		
		public static const INITIAL_APP_DIRECTORY:String	= 'video/';
		public static const PLUGINS_DIRECTORY:String		= 'plug-ins/';
		public static const PLUGINS_XML:String				= 'filter.xml';
	
	}
}