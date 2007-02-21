package filters {
	
	import flash.display.BitmapData;
	import flash.filters.BlurFilter;
	import flash.filters.DisplacementMapFilter;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import onyx.constants.POINT;
	import onyx.core.*;
	import onyx.filter.*;

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
		
		public function applyFilter(bitmapData:BitmapData, stack:RenderStack):void {
			
			// _source.fillRect(_source.rect, 0x00000000);
			_source.applyFilter(_source, _source.rect, new Point(0,0), new BlurFilter(4,4));
			
			var transform:ColorTransform	= new ColorTransform(1,1,1,.2);
			var orig:ColorTransform			= new ColorTransform(1,1,1,.8);
			
			_source.draw(bitmapData, null, transform, 'overlay', null);
			
			bitmapData.draw(_source, null, orig);
		}
	}
}