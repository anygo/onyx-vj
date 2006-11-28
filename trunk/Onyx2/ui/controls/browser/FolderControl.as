package ui.controls.browser {
	
	import ui.controls.UIControl;
	import ui.text.TextField;
	import ui.assets.AssetFolder;
	import ui.controls.ButtonClear;
	import flash.display.Bitmap;
	import ui.assets.AssetFolderUp;

	public final class FolderControl extends UIControl {
		
		private var _label:TextField = new TextField(95,10);
		private var _img:Bitmap;
		private var _btn:ButtonClear = new ButtonClear(95,10);
		
		public function FolderControl(path:String):void {
			
			if (path === '..') {
				_img = new AssetFolderUp();
				_label.text = 'up one level';
			} else {
				_img = new AssetFolder();
				_label.text = path;
			}
			
			_img.y = 1;
			_label.x = 9;
			
			addChild(_label);
			addChild(_img);
			addChild(_btn);
			
		}
	}
}