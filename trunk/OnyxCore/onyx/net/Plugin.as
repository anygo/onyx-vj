package onyx.net {

	import onyx.core.IDisposable;
	
	public final class Plugin implements IDisposable {
		
		public var name:String;
		public var definition:Class;
		public var description:String;
		
		public function Plugin(name:String, definition:Class, description:String):void {
			this.name = name;
			this.definition = definition;
			this.description = description;
		}
		
		public function dispose():void {
		}
	}
}