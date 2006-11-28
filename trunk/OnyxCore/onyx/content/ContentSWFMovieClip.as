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
	
	import flash.display.Bitmap;
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
	import onyx.core.onyx_internal;
	import onyx.layer.IContent;
	import onyx.layer.Layer;
	import flash.geom.Rectangle;
	
	use namespace onyx_internal;
	
	[ExcludeClass]
	public final class ContentSWFMovieClip implements IContent {
		
		/**
		 * 	@private
		 */
		private var _loader:Loader;
		private var _layer:Layer;
		private var _child:MovieClip;
		private var _frame:Number				= 0;
		
		private var _framerate:Number;
		private var _framernd:int				= 0;
		private var _markerLeft:int				= 0;
		private var _markerRight:int			= 0;
		
		public function ContentSWFMovieClip(loader:Loader, layer:Layer):void {
			
			_layer = layer;
			_loader = loader;
			_child	= loader.content as MovieClip;
			_filters = [];
			
			_framerate = loader.contentLoaderInfo.frameRate / Onyx.framerate;
			
			_markerLeft = 0;
			_markerRight = _child.totalFrames;
			
			_loader.addEventListener(Event.ENTER_FRAME, _onEnterFrame);
			
			_scaleX = 320 / loader.contentLoaderInfo.width;
			_scaleY = 240 / loader.contentLoaderInfo.height;
			
		}
		
		public function set time(value:Number):void {
			var frame:int = Math.floor(_child.totalFrames * value);
			_frame = frame;
			
			_child.gotoAndStop(frame);
		}
		
		public function get time():Number {
			return _child.currentFrame;
		}
		
		public function get totalTime():Number {
			return _child.totalFrames;
		}
		
		public function pause(b:Boolean = true):void {
			if (b) {
				_loader.removeEventListener(Event.ENTER_FRAME, _onEnterFrame);
			} else {
				_loader.addEventListener(Event.ENTER_FRAME, _onEnterFrame);
			}
		}
		
		public function isPaused():Boolean {
			return _loader.hasEventListener(Event.ENTER_FRAME);
		}
		
		private function _onEnterFrame(event:Event):void {
			
			var diff:int = _markerRight - _markerLeft;
			
			_frame += _framerate;
			_frame = (_frame < _markerLeft) ? _markerRight : Math.max(_frame % _markerRight, _markerLeft);
			
			_child.gotoAndStop(Math.floor(_frame));
			
		}
		
		public function get framerate():Number {
			// get the ratio of the original framerate and the actual framerate
			var ratio:Number = _loader.contentLoaderInfo.frameRate / Onyx.framerate
			
			return _framerate / ratio;
		}

		public function set framerate(value:Number):void {
			var ratio:Number = _loader.contentLoaderInfo.frameRate / Onyx.framerate
			
			_framerate = value * ratio;
		}
		
		public function get framernd():Number {
			return _framernd;
		}
		
		public function set framernd(value:Number):void {
			_framernd = value;
		}

		public function get markerLeft():Number {
			return _markerLeft / _child.totalFrames;
		}
		
		public function set markerLeft(value:Number):void {
			_markerLeft = Math.min(Math.max(_child.totalFrames * value, 0), _markerRight - 1);
			_frame = Math.max(_frame, _markerLeft);
		}
		
		public function get markerRight():Number {
			return _markerRight / _child.totalFrames;
		}
		
		public function set markerRight(value:Number):void {
			_markerRight = Math.min(Math.max(_child.totalFrames * value, _markerLeft + 1), _child.totalFrames);

			_frame = Math.min(_frame, _markerRight);
		}
		
		public function get path():String {
			return _loader.contentLoaderInfo.url;
		}
		
		public function set timePercent(value:Number):void {
			_frame = _child.totalFrames * value;
		}
		
		public function get timePercent():Number {
			return _frame / _child.totalFrames;
		}

		public function dispose():void {
			
			if (_child is IDisposable) {
				(_child as IDisposable).dispose();
			}

			_loader.unload();
			_loader.removeEventListener(Event.ENTER_FRAME, _onEnterFrame);

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

		
		include "ContentShared.as"		
	}
}