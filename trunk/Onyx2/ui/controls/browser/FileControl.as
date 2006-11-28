package ui.controls.browser {
	
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.filters.DropShadowFilter;
	import flash.net.URLRequest;
	import flash.text.TextFormat;
	
	import onyx.external.files.File;
	
	import ui.assets.AssetCamera;
	import ui.controls.*;
	import ui.text.Style;
	import ui.text.TextField;
	
	public final class FileControl extends UIControl {
		
		private var _label:TextField	= new TextField(46, 35);
		private var _button:ButtonClear	= new ButtonClear(46, 35);
		private var _loader:Loader		= new Loader();
		
		public var path:String;
		
		public function FileControl(path:String, thumbpath:String, directory:String):void {
			
			this.path = path;
			
			_label.align	= 'center';
			_label.wordWrap = true;
			
			var format:TextFormat = _label.getTextFormat();
			var substr:int = Math.max(path.lastIndexOf('\\')+1,path.lastIndexOf('/')+1);
			format.leading = 1;
			
			_label.defaultTextFormat = format;
			_label.text = path.substring(substr, path.length);
			_label.filters = [new DropShadowFilter(1,45, 0x000000,1,0,0,1)];
			
			graphics.beginFill(0x647789);
			graphics.drawRect(0,0,48,37);
			graphics.endFill();

			_loader.load(new URLRequest(thumbpath));
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, _handler);
			_loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, _handler);
			_loader.x = 1;
			_loader.y = 1;
			
			doubleClickEnabled = true;

			addChild(_loader);
			addChild(_label);
			addChild(_button);

			cacheAsBitmap = true;
		}
		
		private function _handler(event:Event):void {
			var loader:LoaderInfo = event.currentTarget as LoaderInfo;
			loader.removeEventListener(Event.COMPLETE, _handler);
			loader.removeEventListener(IOErrorEvent.IO_ERROR, _handler);
		}
		
		override public function dispose():void {
			
			removeChild(_loader);
			removeChild(_label);
			removeChild(_button);
			
			_loader.unload();
			_loader = null;
			_button = null;
			_label = null;
			path = null;
		}
	}
}