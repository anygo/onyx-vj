package filters {
	
	import flash.display.BitmapData;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	
	import onyx.core.POINT;
	import onyx.core.getBaseBitmap;
	import onyx.filter.Filter;
	import onyx.filter.IBitmapFilter;
	import flash.geom.Point;
	import flash.filters.BlurFilter;

	public final class PasteFilter extends Filter implements IBitmapFilter {
		
		private var _source:BitmapData;
		private var _transform:ColorTransform;
		private var _count:int					= 0;
		private var _frameDelay:int				= 2;
		
		public function PasteFilter():void {
			super(
				false
			)
		}
		
		override public function initialize():void {
			_source		= getBaseBitmap();
			_transform	= new ColorTransform();
		}
		
		public function applyFilter(bitmapData:BitmapData, bounds:Rectangle):BitmapData {
			
			// _source.fillRect(_source.rect, 0x00000000);
			_source.applyFilter(_source, _source.rect, new Point(0,0), new BlurFilter());
			
			var boxX:int		= 160 * Math.random();
			var boxY:int		= 120 * Math.random();
			
			var rect:Rectangle	= new Rectangle(boxX, boxY, 160, 120);
			var matrix:Matrix	= new Matrix();
			matrix.translate(-boxX, -boxY);
			matrix.scale(Math.random() * 2, Math.random() * 2);
			
			var transform:ColorTransform	= new ColorTransform(1,1,1,Math.random());
			
			_source.draw(bitmapData, matrix, transform, 'multiply', rect);
			
			bitmapData.draw(_source);
			
			return bitmapData;
		}
	}
}