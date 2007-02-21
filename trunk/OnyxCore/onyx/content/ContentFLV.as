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
	import flash.media.Video;
	
	import onyx.controls.Controls;
	import onyx.core.*;
	import onyx.layer.Layer;
	import onyx.layer.LayerProperties;
	import onyx.layer.LayerSettings;
	import onyx.net.Connection;
	import onyx.net.Stream;

	[ExcludeClass]
	public class ContentFLV extends Content {
		
		private var _stream:Stream;
		private var _totalTime:Number;
		private var _loopStart:Number;
		private var _loopEnd:Number;
		private var _video:Video;
	
		/**
		 * 	@constructor
		 */
		public function ContentFLV(layer:Layer, path:String, stream:Stream, props:LayerProperties):void {
			
			_stream = stream;
			
			_totalTime = stream.metadata.duration;
			
			_video = new Video(320,240);

			_video.attachNetStream(stream);

			super(layer, path, _video);
		}
		
		/**
		 * 	@private
		 * 	Updates the bimap source
		 */
		override public function render(stack:RenderStack):RenderTransform {

			// test loop points
			if (_stream.time >= _loopEnd || _stream.time < _loopStart) {
				_stream.seek(_loopStart);
			}
			
			return super.render(stack);
		}

		/**
		 * 
		 */
		override public function get time():Number {
			return _stream.time / _totalTime;
		}
		
		/**
		 * 	@private
		 * 	Goes to particular time
		 */		
		override public function set time(value:Number):void {
			_stream.seek(value * _totalTime);
		}
		
		/**
		 * 
		 */
		override public function get loopStart():Number {
			return _loopStart / _totalTime;
		}
		
		/**
		 * 	@private
		 * 	Sets Loop Start
		 */		
		override public function set loopStart(value:Number):void {
			_loopStart = __loopStart.setValue(_totalTime * value);
		}

		/**
		 * 
		 */
		override public function get loopEnd():Number {
			return _loopEnd / _totalTime;
		}
		
		/**
		 * 	@private
		 * 	Sets Loop Start
		 */		
		override public function set loopEnd(value:Number):void {
			_loopEnd = __loopStart.setValue(_totalTime * value);
		}
		
		/**
		 * 
		 */
		override public function pause(value:Boolean = false):void {
			if (value) {
				_stream.pause();
			} else {
				_stream.resume();
			}
		}

		/**
		 * 
		 */
		override public function dispose():void {
		
			_video.attachNetStream(null);
			_stream.close();

			_video		= null;
			_stream		= null;
			
			super.dispose();
		}
	}
}