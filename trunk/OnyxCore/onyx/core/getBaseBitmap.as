package onyx.core {
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;	
	
	public function getBaseBitmap():BitmapData {
		return _bitmap.clone()
	}
}