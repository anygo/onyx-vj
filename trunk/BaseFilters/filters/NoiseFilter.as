package filters {
	
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import flash.geom.Point;
	
	import onyx.controls.*;
	import onyx.filter.Filter;
	import onyx.filter.IBitmapFilter;
	import flash.geom.Rectangle;
	
	public final class NoiseFilter extends Filter implements IBitmapFilter {
		
		private var _amount:Number		= .25;
		private var _greyscale:Boolean	= true;
		
		public function NoiseFilter():void {
			
			super('Noise Filter');

			_controls.addControl(
				new ControlInt('amount','Amount', 0, 100, 4),
				new ControlRange('greyscale', 'GreyScale', [false, true], 0)
			);
		}
		
		public function applyFilter(bmp:BitmapData, bounds:Rectangle):BitmapData {
			
			var noise:BitmapData = new BitmapData(bmp.width, bmp.height, false, 0x000000);
			noise.noise(Math.random() * 100, 0, _amount * 255, 7, _greyscale);
			
			bmp.draw(noise, new Matrix(), null, 'overlay');
			
			noise.dispose();

			return bmp;
		}
		
		public function set amount(a:int):void {
			_amount = a / 100;
		}

		public function get amount():int{
			return _amount * 100;
		}

		public function get greyscale():Boolean {
			return _greyscale;
		}

		public function set greyscale(b:Boolean):void {
			_greyscale = b;
		}
		
		override public function dispose():void {
		}
		
		override public function initialize():void {
		}
		

	}
}