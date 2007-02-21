package filters {
	
	import flash.display.*;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;
	
	import onyx.controls.*;
	import onyx.core.*;
	import onyx.filter.*;

	public final class MirrorFilter extends Filter implements IBitmapFilter {
		
		public function MirrorFilter():void {
			super(
				true
			);
		}
		
		public function applyFilter(bitmapData:BitmapData, stack:RenderStack):void {
			var rect:Rectangle = bitmapData.rect;
			rect.width /= 2;

			var matrix:Matrix = new Matrix();
			matrix.a	= -1;
			matrix.tx	= rect.width * 2;
			
			bitmapData.draw(bitmapData, matrix, null, null, rect);


		}
		
	}
}