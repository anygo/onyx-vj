/** 
 * Copyright (c) 2003-2006, www.onyx-vj.com
 * All rights reserved.	
 * 
 * Redistribution and use in source and binary forms, with or without modification,
 * are permitted provided that the following conditions are met:
 * 
 * -  Redistributions of source code must retain the above copyright notice, this 
 *    list of conditions and the following disclaimer.
 * 
 * -  Redistributions in binary form must reproduce the above copyright notice, 
 *    this list of conditions and the following disclaimer in the documentation 
 *    and/or other materials provided with the distribution.
 * 
 * -  Neither the name of the www.onyx-vj.com nor the names of its contributors 
 *    may be used to endorse or promote products derived from this software without 
 *    specific prior written permission.
 * 
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND 
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED 
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. 
 * IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, 
 * INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
 * NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
 * PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, 
 * WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE 
 * POSSIBILITY OF SUCH DAMAGE.
 * 
 */
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