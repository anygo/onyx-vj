package onyx.content {

	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.geom.Matrix;
	
	import onyx.application.Onyx;
	import onyx.core.IDisposable;
	import onyx.core.onyx_internal;
	import onyx.layer.IContent;
	import onyx.layer.Layer;
	import onyx.layer.IStageAllowable;
	
	use namespace onyx_internal;
	
	[ExcludeClass]
	public final class ContentSWFSprite implements IContent {
		
		private var _loader:Loader;
		private var _child:Sprite;
		private var _layer:Layer;
		
		public function ContentSWFSprite(loader:Loader, layer:Layer):void {
			
			_layer = layer;
			_loader = loader;
			_child	= loader.content as Sprite;
			_filters = [];
			
			if (_child is IStageAllowable) {
				(_child as IStageAllowable).stage = Onyx.root;
			}
			
			_scaleX = 320 / loader.contentLoaderInfo.width;
			_scaleY = 240 / loader.contentLoaderInfo.height;

		}
		
		public function set time(value:Number):void {
		}
		
		public function get time():Number {
			return 0;
		}
		
		public function get totalTime():Number {
			return 1;
		}
		
		public function pause(b:Boolean = true):void {
		}
		
		public function isPaused():Boolean {
			return false;
		}
		
		
		public function get framerate():Number {
			return 1;
		}

		public function set framerate(value:Number):void {
		}

		public function get framernd():Number {
			return 0;
		}
		
		public function set framernd(value:Number):void {
		}

		public function get markerLeft():Number {
			return 0;
		}
		
		public function set markerLeft(value:Number):void {
		}
		
		public function get markerRight():Number {
			return 1;
		}
		
		public function set markerRight(value:Number):void {
		}
		
		public function get path():String {
			return _loader.contentLoaderInfo.url;
		}
		
		public function get timePercent():Number {
			return 0;
		}

		public function dispose():void {
						
			if (_child is IDisposable) {
				(_child as IDisposable).dispose();
			}

			_loader.unload();
			
			clearFilters();
			
			_loader = null;
			_child = null;
			_layer = null;
			_filter = null;
			_matrix = null;
			_filters = null;
			
			_source.dispose();
			_source = null;

		}
		
		public function toString():String {
			return '[SWFSprite:', path, ']';
		}

		include "ContentShared.as"		

	}
}