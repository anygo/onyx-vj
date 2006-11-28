package {
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.external.ExternalInterface;
	import flash.system.Security;
	
	import ui.UIManager;
	import ui.core.UIObject;

	[SWF(width="1024", height="768", backgroundColor="#141515", frameRate='24')]
	public class Onyx2 extends UIObject {
		
		/**
		 * 	@constructor
		 */
		public function Onyx2():void {
			
			Security.allowDomain('www.onyx-vj.com');
			
			// no scale please thanks
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;

			UIManager.initialize(stage);
		
		}
		
	}
}