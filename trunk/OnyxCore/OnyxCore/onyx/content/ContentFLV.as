package onyx.content {
	
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	
	import onyx.core.onyx_internal;
	import onyx.external.*;
	import onyx.layer.IContent;
	import onyx.layer.Layer;
	
	use namespace onyx_internal;

	public final class ContentFLV implements IContent {
		
		private var _layer:Layer;
		private var _stream:Stream;
		private var _loader:Video;
		private var _duration:Number;
		private var _markerLeft:Number;
		private var _markerRight:Number;
		
		public function ContentFLV(stream:Stream, layer:Layer):void {
			
			_layer = layer;

			_stream = stream;
			_loader	= new Video();
			_loader.attachNetStream(_stream);

			_stream.resume();
			
			// start saving data
			_duration = stream.metadata.duration;
			_markerRight = _duration;
			
			_loader.addEventListener(Event.ENTER_FRAME, _onEnterFrame);
		}
		
		private function _onEnterFrame(event:Event):void {
			if (_stream.time >= _markerRight) {
				_stream.seek(_markerLeft);
			}
		}

		include 'ContentShared.as'

		public function get totalTime():Number {
			return _duration;
		}
		
		public function set timePercent(value:Number):void {
			_stream.seek(value * _duration);
		}
		
		public function get timePercent():Number {
			return _stream.time / _duration;
		}
		
		public function get time():Number {
			return _stream.time;
		}
		
		public function set time(value:Number):void {
			_stream.seek(value * _duration);
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

		public function get markerRight():Number {
			return _markerRight / _duration;;
		}
		
		public function set markerRight(value:Number):void {
			_markerRight = value * _duration;
		}
		
		public function pause(b:Boolean=true):void {
			if (b) {
				_stream.pause();
			} else {
				_stream.resume();
			}
			
		}
		
		public function get path():String {
			return _stream.path;
		}
		
		public function set markerLeft(value:Number):void {
			_markerLeft = value * _duration;
		}
		
		public function get markerLeft():Number {
			return _markerRight / _duration;
		}

		public function get blendMode():String {
			return null;
		}
		
		public function set blendMode(value:String):void {
		}
		
		public function dispose():void {
			_layer = null;
			_stream.close();
			_loader.attachNetStream(null);
			_loader = null;
			
			_source.dispose();
			_source = null;

		}

		
	}
}