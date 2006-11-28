package ui.windows {
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.utils.Timer;
	import onyx.display.Display;
	import onyx.core.Engine;
	import flash.events.TimerEvent;
	import flash.geom.Matrix;
	
	public final class Preview extends Window {
		
		private var _preview:Bitmap	= new Bitmap(new BitmapData(224,168, false));
		private var _timer:Timer		= new Timer(82);
		private var _matrix:Matrix	= new Matrix();
		private var _display:Display;
		
		public function Preview():void {
			
			// set display options

			title = 'output';

			width = 334;
			height = 220;

			x = 689;
			y = 545;

			_preview.x = 5;
			_preview.y = 30;
			
			// assign the display we're previewing
			_display = Engine.getDisplayAt(0);

			// assign the timer to update the preview
			_timer.addEventListener(TimerEvent.TIMER, _onTimer);
			_timer.start();
			
			// set the matrix width
			_matrix.scale(_preview.width / _display.width, _preview.height / _display.height);
			
			// add the preview bitmap
			addChild(_preview);
			
		}
		
		private function _onTimer(event:TimerEvent):void {

			var bmp:BitmapData = _preview.bitmapData;
			bmp.draw(_display, _matrix);
		}
		
	}
}