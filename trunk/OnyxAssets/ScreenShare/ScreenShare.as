package {
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	
	import onyx.core.IDisposable;
	import onyx.layer.IStageAllowable;
	import flash.geom.Matrix;

	public class ScreenShare extends Sprite implements IDisposable, IStageAllowable {
		
		private var _bmp:BitmapData		= new BitmapData(320,240,true,0x00000000);
		private var _bitmap:Bitmap		= new Bitmap(_bmp);
		private var _stage:Stage;
		
		public function ScreenShare():void {
			addChild(_bitmap);
		}
		
		public function set stage(stage:Stage):void {
			_stage = stage;
			
			addEventListener(Event.ENTER_FRAME, _onEnterFrame);
		}
		
		private function _onEnterFrame(event:Event):void {
			var matrix:Matrix = new Matrix();
			matrix.translate(-_stage.mouseX + 160, -_stage.mouseY + 120);
			matrix.scale(.8, .8);
			_bmp.fillRect(_bmp.rect, 0x00000000);
			_bmp.draw(_stage, matrix);
		}

		public function dispose():void {
			_bmp = null;
			removeEventListener(Event.ENTER_FRAME, _onEnterFrame);
		}

	}
}
