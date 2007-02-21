package ui.window {
	
	import flash.display.Bitmap;
	import flash.events.EventDispatcher;
	
	import onyx.core.Onyx;
	import onyx.events.LayerEvent;
	
	import ui.layer.UILayer;
	import flash.events.Event;
	import onyx.controls.Control;
	import onyx.events.ControlEvent;
	
	public final class Preview extends Window {
		
		public function Preview():void {
			
			title		= 'preview';
			draggable	= true;
			
			width		= 210;
			height		= 190;
			
		}
		
		public function register(layer:UILayer):void {
						
			var bmp:Bitmap		= new Bitmap(layer.preview.bitmapData);
//			trace(bmp);
/*			var control:Control	= layer.layer.controls.getControl('blendMode')
			control.addEventListener(ControlEvent.CHANGE, _onBlendChange);

			bmp.x = 10;
			bmp.y = 20;
			
			addChildAt(bmp, 0);
*/

		}
		
		private function _onBlendChange(event:Event):void {
			// trace(event);
		}
	}
}