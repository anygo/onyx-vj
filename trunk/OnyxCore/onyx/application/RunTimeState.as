package onyx.application {
	
	import onyx.layer.Layer;
	
	public final class RunTimeState implements IApplicationState {

		public function initialize(...args):void {
			Onyx.createLocalDisplay(5);
		}
		
		public function terminate():void {
		}
		
	}
}