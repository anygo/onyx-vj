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
	
	import flash.display.*;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.geom.Transform;
	import flash.utils.getTimer;
	
	import onyx.controls.*;
	import onyx.core.*;
	import onyx.events.FilterEvent;
	import onyx.filter.*;
	import onyx.layer.*;
	import onyx.settings.Settings;

	[Event(name="filter_applied",	type="onyx.events.FilterEvent")]
	[Event(name="filter_removed",	type="onyx.events.FilterEvent")]
	[Event(name="filter_moved",		type="onyx.events.FilterEvent")]
		
	use namespace onyx_ns;
	
	[ExcludeClass]
	public class ContentMC extends Content implements IContent {

		/**
		 * 	@private
		 * 	The left loop point
		 */
		protected var _loopStart:int						= 0;
		
		/**
		 * 	@private
		 * 	The right loop point
		 */
		protected var _loopEnd:int							= 1;
		
		/**
		 * 	@private
		 * 	Stores the loader object where the content was loaded into
		 */
		private var _loader:Loader;
		
		/**
		 * 	@private
		 * 	The frame number we are currently should navigate to
		 */
		private var _frame:Number							= 0;
		
		/**
		 * 	@private
		 * 	The amount of frames to move per frame
		 */
		private var _framerate:Number;
		
		/**
		 * 
		 */
		private var _ratioX:Number							= 1;
		
		/**
		 * 
		 */
		private var _ratioY:Number							= 1;
		
		/**
		 * 	@private
		 * 	Stores last time the draw was executed
		 */
		private var _lastTime:uint;
		
		/**
		 * 	@private
		 */
		private var _mc:MovieClip;

		/**
		 * 	@private
		 */
		private var _totalFrames:int;

		/**
		 * 	@constructor
		 */		
		public function ContentMC(loader:Loader, props:LayerProperties):void {
			
			_loader		= loader;
			_mc			= loader.content as MovieClip;
			
			// sets the framerate based on the swf framerate
			_framerate		= loader.contentLoaderInfo.frameRate / framerate;
			_totalFrames	= _mc.totalFrames;

			// sets the last time we executed
			_lastTime = getTimer();

			// resize?
			if (Settings.LAYER_AUTOSIZE) {
				_ratioX = WIDTH / loader.contentLoaderInfo.width;
				_ratioY = HEIGHT / loader.contentLoaderInfo.height;
			}
			
			super(props, _mc);
		}

		/**
		 * 	Sets the time
		 */
		override public function set time(value:Number):void {
			
			_frame = _totalFrames * value;
			
		}
		
		/**
		 * 	Gets the time
		 */
		override public function get time():Number {
			return _frame / _totalFrames;
		}
		
		/**
		 * 	Gets the total time
		 */
		override public function get totalTime():int {
			return (_totalFrames / _loader.contentLoaderInfo.frameRate) * 1000;
		}
		
		/**
		 * 	@private
		 * 	Runs every frame and adds time
		 */
		override public function render(bitmapData:BitmapData):void {
			
			if (!_paused) {
				
				var time:int = 1000 / (getTimer() - _lastTime);
				
				// add the framerate based off the last time
				var frame:Number = _frame + ((Onyx.framerate / time) * _framerate);
				
				frame = (frame < _loopStart) ? _loopEnd : Math.max(frame % _loopEnd, _loopStart);
	
				_frame = frame;
				
			}

			_lastTime = getTimer();

			// if the frame is different, update the source bitmap
			if (Math.floor(_frame) !== _mc.currentFrame) {
				_mc.gotoAndStop(Math.floor(_frame));

				// draw everything		
				super.render(bitmapData);
				
			// just apply filters to the current bitmap
			} else {
				
				// apply the filters and draw to the display
				_applyFilters(bitmapData);

			}

		}
		
		/**
		 * 	Gets the framerate
		 */
		override public function get framerate():Number {
			// get the ratio of the original framerate and the actual framerate
			var ratio:Number = _loader.contentLoaderInfo.frameRate / Onyx.framerate;
			
			return (_framerate / ratio);
		}

		/**
		 * 	Sets framerate
		 */
		override public function set framerate(value:Number):void {
			var ratio:Number = _loader.contentLoaderInfo.frameRate / Onyx.framerate

			_framerate = value * ratio;

			__framerate.setValue(value);
		}

		

		/**
		 * 	Sets the beginning loop point (percentage)
		 */		
		override public function set loopStart(value:Number):void {

			// loop
			var end:Number = loopEnd;
			var frame:Number = Math.min(value, end);
			
			_loopStart = __loopStart.setValue(frame) * _totalFrames;
			_frame = Math.max(_frame, _loopStart);
			
		}
		
		/**
		 * 
		 */
		override public function get loopStart():Number {
			return _loopStart / _totalFrames;
		}
		
		/**
		 * 	Sets the end loop point
		 */
		override public function set loopEnd(value:Number):void {
			
			// loop
			var start:Number = loopStart;
			var frame:Number = Math.max(value, start);
			
			_loopEnd = __loopEnd.setValue(frame) * _totalFrames;

			_frame = Math.min(_frame, _loopEnd);

		}
		
		/**
		 * 	Destroys the content
		 */
		override public function dispose():void {

			// destroy content
			_loader.unload();

			_loader = null;
			_mc		= null;
			
			super.dispose();
		}
		
		override public function get scaleX():Number {
			return super.scaleX / _ratioX;
		}
		
		override public function set scaleX(value:Number):void {
			super.scaleX = value * _ratioX;
		}
		
		override public function get scaleY():Number {
			return super.scaleY / _ratioY;
		}
		
		override public function set scaleY(value:Number):void {
			super.scaleY = value * _ratioY;
		}
	}
}