package filters {
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.filters.BlurFilter;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import onyx.controls.Control;
	import onyx.controls.ControlInt;
	import onyx.controls.ControlRange;
	import onyx.controls.Controls;
	import onyx.core.getBaseBitmap;
	import onyx.filter.Filter;
	import onyx.filter.IBitmapFilter;

	public final class Repeater extends Filter implements IBitmapFilter {
		
		public var amount:int			= 2;

		private var _step:Boolean		= false;
		private var _currentStep:int	= 0;
		private var _bmp:BitmapData		= getBaseBitmap();
		
		public function Repeater():void {
			
			super('Repeater');
			
			_controls.addControl(
				new ControlInt('amount', 'amount', 1, 42, 2),
				new ControlRange('step', 'step', [false, true], 0)
			)
		}
		
		public function set step(value:Boolean):void {
			
			_step = value;
			
			_bmp.copyPixels(content.source, content.source.rect, new Point(0,0));
			
		}
		
		public function get step():Boolean {
			return _step;
		}
		
		/**
		 * 
		 */
		public function applyFilter(bitmapData:BitmapData, bounds:Rectangle):BitmapData {
			
			var amount:int = amount;
			var square:int = amount * amount;
			
			var scaleX:Number = Math.ceil(bitmapData.width / amount);
			var scaleY:Number = Math.ceil(bitmapData.height / amount);
			
			var newbmp:BitmapData = new BitmapData(scaleX, scaleY, true, 0x00000000);
			var matrix:Matrix = new Matrix();
			matrix.scale(1 / amount, 1 / amount);
			
			newbmp.draw(bitmapData, matrix);
			
			if (_step) {
				
				_currentStep = (_currentStep+1) % (amount);

				_bmp.copyPixels(newbmp, newbmp.rect, new Point((_currentStep % amount) * scaleX, Math.floor(_currentStep / amount) * scaleY));
				
				return _bmp;

			} else {
				
				if (amount > 0) {
					for (var count:int = 0; count < square; count++) {
						bitmapData.copyPixels(
							newbmp, 
							newbmp.rect, 
							new Point((count % amount) * scaleX, 
							Math.floor(count / amount) * scaleY)
						);
					}
				}
			}

			return bitmapData;
		}
		
		/**
		 * 	clone
		 */
		override public function clone():Filter {
			var filter:Repeater = new Repeater();
			filter._step = _step;
			filter._currentStep = _currentStep;
			
			return filter;
		}
		
		/**
		 * 	Disposes the filter
		 */
		override public function dispose():void {
			if (_bmp) {
				_bmp.dispose();
			}
			super.dispose();
		}
	}
}