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
	import flash.events.*;
	import flash.geom.*;
	import flash.utils.getTimer;
	
	import onyx.constants.*;
	import onyx.controls.*;
	import onyx.core.*;
	import onyx.events.*;
	import onyx.filter.*;
	import onyx.layer.*;
	import onyx.render.*;
	import onyx.settings.*;
			
	use namespace onyx_ns;
	
	[ExcludeClass]
	public class ContentMC extends Content {

		/**
		 * 	@private
		 * 	The left loop point
		 */
		protected var _loopStart:Number						= 0;
		
		/**
		 * 	@private
		 * 	The right loop point
		 */
		protected var _loopEnd:Number						= 1;
		
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
		private var _framerate:Number						= 1;
		
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
		 * 	@constructor
		 */		
		public function ContentMC(layer:Layer, path:String, loader:Loader):void {

			_loader			= loader;
			_mc				= loader.content as MovieClip;
			
			// sets the framerate based on the swf framerate
			_framerate		= loader.contentLoaderInfo.frameRate / framerate;
			_frame			= 0;

			// sets the last time we executed
			_lastTime		= getTimer() - STAGE.frameRate;

			// resize?
			if (LAYER_AUTOSIZE) {
				_ratioX = 320 / loader.contentLoaderInfo.width;
				_ratioY = 240 / loader.contentLoaderInfo.height;
			}
			
			super(layer, path, _mc);
		}

		/**
		 * 	Sets the time
		 */
		override public function set time(value:Number):void {
			
			_frame = _mc.totalFrames * value;
			
		}
		
		/**
		 * 	Gets the time
		 */
		override public function get time():Number {
			return _frame / (_mc.totalFrames );
		}
		
		/**
		 * 	Gets the total time
		 */
		override public function get totalTime():int {
			return (_mc.totalFrames / _loader.contentLoaderInfo.frameRate) * 1000;
		}
		
		/**
		 * 	Updates the bimap source
		 */
		override public function render():RenderTransform {
			
			if (!_paused) {
				
				// get framerate
				var time:int = 1000 / ((getTimer() - _lastTime)) || STAGE.frameRate;
				
				// add the framerate based off the last time
				var frame:Number = _frame + ((STAGE.frameRate / time) * _framerate);
				var totalFrames:int	= _mc.totalFrames;
				var loopEnd:int = totalFrames * _loopEnd;
				var loopStart:int = totalFrames * _loopStart;
				
				// constrain the frame
				frame = (frame < loopStart) ? loopEnd : Math.max(frame % loopEnd, loopStart);

				// save the frame				
				_frame = frame;
				
			}

			// store last time
			_lastTime = getTimer();

			// go to the right frame
			_mc.gotoAndStop(Math.floor(_frame));

			// render me baby					
			return super.render();
		}
		
		/**
		 * 	Gets the framerate
		 */
		override public function get framerate():Number {
			// get the ratio of the original framerate and the actual framerate
			var ratio:Number = _loader.contentLoaderInfo.frameRate / STAGE.frameRate;
			
			return (_framerate / ratio);
		}

		/**
		 * 	Sets framerate
		 */
		override public function set framerate(value:Number):void {
			var ratio:Number = _loader.contentLoaderInfo.frameRate / STAGE.frameRate;

			_framerate = value * ratio;

			super.framerate = value;
		}

		

		/**
		 * 	Sets the beginning loop point (percentage)
		 */		
		override public function set loopStart(value:Number):void {
			_loopStart = __loopStart.setValue(Math.min(value, _loopEnd));
		}
		
		/**
		 * 
		 */
		override public function get loopStart():Number {
			return _loopStart;
		}
		
		/**
		 * 	Sets the end loop point
		 */
		override public function set loopEnd(value:Number):void {
			
			_loopEnd = __loopEnd.setValue(Math.max(value, _loopStart, 0.01));

		}
		
		/**
		 * 	Sets the end loop point
		 */
		override public function get loopEnd():Number {
			return _loopEnd;
		}
		
		/**
		 * 	Destroys the content
		 */
		override public function dispose():void {

			// dispose
			super.dispose();

			// unregister
			var value:Boolean = ContentLoader.unregister(_path);
			
			if (!value && _mc is IDisposable) {
				(_mc as IDisposable).dispose();
			}
			
			// remove reference
			_loader = null;
			_mc		= null;
		}
		
		/**
		 * 
		 */
		override public function get scaleX():Number {
			return super.scaleX / _ratioX;
		}
		
		/**
		 * 
		 */
		override public function set scaleX(value:Number):void {
			super.scaleX = value * _ratioX;
		}
		
		/**
		 * 
		 */
		override public function get scaleY():Number {
			return super.scaleY / _ratioY;
		}
		
		/**
		 * 
		 */
		override public function set scaleY(value:Number):void {
			super.scaleY = value * _ratioY;
		}
	}
}