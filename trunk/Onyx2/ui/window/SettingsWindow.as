package ui.window {

	import onyx.display.Display;
	
	import ui.controls.SliderV2;
	import ui.core.UIObject;

	public final class SettingsWindow extends Window {
		
		private var _controlXY:SliderV2;
		private var _controlScale:SliderV2;
		
		public function SettingsWindow(display:Display):void {
			
			title = 'SETTINGS WINDOW';
			
			_controlXY		= new SliderV2(display.controls.y, display.controls.x);
			_controlScale	= new SliderV2(display.controls.scaleY, display.controls.scaleX, false, 100);
			
			_controlXY.y	= 15;
			_controlScale.y = 27;
			
			addChild(_controlXY);
			addChild(_controlScale);
			
			width = 190;
			
			x = 200;
			y = 526;
			
		}
	}
}