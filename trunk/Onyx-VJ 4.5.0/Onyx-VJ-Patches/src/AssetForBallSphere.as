package {
	
	import flash.display.BitmapData;
	
	[ExcludeSDK]
	
	//[Embed(source='../assets/ekkoballsphere50.png')]
	[Embed(source='../assets/ballsphere.png')]
	public final class AssetForBallSphere extends BitmapData {
		
		/**
		 * 
		 */
		public function AssetForBallSphere() {
			super(50, 50);
		}
		
	}
}