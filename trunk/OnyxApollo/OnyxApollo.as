package {
	
	import file.*;
	
	import flash.display.*;
	
	import onyx.constants.*;
	import onyx.controls.*;
	
	import ui.core.UIManager;


	[SWF(width="1024", height="768", backgroundColor="#141515", frameRate='24')]
	public class OnyxApollo extends Sprite {
		
		/**
		 * 	@constructor
		 */
		public function OnyxApollo():void {
			
			STAGE.quality = StageQuality.LOW;
			
			// init
			UIManager.initialize(stage, new ApolloAdapter());
		}
		
	}
}