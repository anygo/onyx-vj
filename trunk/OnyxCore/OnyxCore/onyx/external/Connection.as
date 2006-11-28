package onyx.external {
	
	import flash.net.NetConnection;

	public class Connection extends NetConnection {
		
		internal static const DEFAULT_CONNECTION:Connection = new Connection();
		
		public function Connection():void {
			if (DEFAULT_CONNECTION) throw new Error('error');
				connect(null);
		}
	}
}