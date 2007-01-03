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
	import flash.filters.BitmapFilter;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.geom.Transform;
	import flash.utils.getTimer;
	
	import onyx.application.Onyx;
	import onyx.core.IDisposable;
	import onyx.core.POINT;
	import onyx.core.getBaseBitmap;
	import onyx.core.onyx_internal;
	import onyx.events.FilterEvent;
	import onyx.filter.*;
	import onyx.layer.Layer;
	import onyx.settings.Settings;
	
	[Event(name="filter_applied",	type="onyx.events.FilterEvent")]
	[Event(name="filter_removed",	type="onyx.events.FilterEvent")]
	[Event(name="filter_moved",		type="onyx.events.FilterEvent")]
		
	use namespace onyx_internal;
	
	public final class ContentSprite extends Bitmap implements IContent {
		
		include 'ContentProperties.txt';
		
		/**
		 * 	@private
		 * 	Stores the loader object where the content was loaded into
		 */
		private var _loader:Loader;
		
		/**
		 * 	@private
		 * 	Stores a reference to the loader content
		 */
		private var _content:MovieClip;
		
		/**
		 * 	@private
		 * 	The frame number we are currently should navigate to
		 */
		private var _frame:Number				= 0;
		
		/**
		 * 	@private
		 * 	The amount of frames to move per frame
		 */
		private var _framerate:Number;
		
		/**
		 * 	@private
		 * 	The left loop point
		 */
		private var _loopStart:int				= 0;
		
		/**
		 * 	@private
		 * 	The right loop point
		 */
		private var _loopEnd:int				= 1;

		
		/**
		 * 	@private
		 */
		private var _source:BitmapData			= getBaseBitmap();

		/**
		 * 	@constructor
		 */		
		public function ContentSprite(loader:Loader):void {
			
			_loader		= loader;
			_content	= loader.content as MovieClip;
			
			if (Settings.LAYER_AUTOSIZE) {
				var ratioX:Number = 320 / loader.contentLoaderInfo.width;
				var ratioY:Number = 240 / loader.contentLoaderInfo.height;
			}
			
			_scaleX		= ratioX || 1;
			_scaleY		= ratioY || 1;
			
			// create the listener
			pause(false);

			super(getBaseBitmap());
			
		}

		/**
		 * 	Sets the time
		 */
		public function set time(value:Number):void {
		}
		
		/**
		 * 	Gets the time
		 */
		public function get time():Number {
			return 0;
		}
		
		/**
		 * 	Gets the total time
		 */
		public function get totalTime():Number {
			return 1;
		}
		
		/**
		 * 	Pauses content
		 */
		public function pause(b:Boolean = true):void {
			if (b) {
				removeEventListener(Event.ENTER_FRAME, _onEnterFrame);
			} else {
				addEventListener(Event.ENTER_FRAME, _onEnterFrame);
			}
		}
		
		/**
		 * 	Returns whether the content is paused
		 */
		public function isPaused():Boolean {
			return false;
		}
		
		/**
		 * 	Runs every frame and adds time
		 */
		private function _onEnterFrame(event:Event):void {
			updateSource();
		}
		
		/**
		 * 	Updates
		 */
		public function updateSource():void {
			
			// draw everything
			var matrix:Matrix = new Matrix();
			matrix.scale(_scaleX, _scaleY);
			matrix.rotate(_rotation);
			matrix.translate(_x, _y);
			
			// fill the source with nothing
			_source.fillRect(_source.rect, 0x00000000);
			_source.draw(_content, matrix, _colorTransform, null, null);

			// apply the color filter to the source
			_source.applyFilter(_source, _source.rect, POINT, _filter.filter);
			
			super.bitmapData.copyPixels(_source, _source.rect, POINT);
			applyFilters(super.bitmapData);

		}
		
		/**
		 * 	Gets the framerate
		 */
		public function get framerate():Number {
			return 1;
		}

		/**
		 * 	Sets framerate
		 */
		public function set framerate(value:Number):void {
		}
		
		/**
		 * 	Gets the beginning loop point
		 */
		public function get loopStart():Number {
			return 0;
		}

		/**
		 * 	Sets the beginning loop point (percentage)
		 */		
		public function set loopStart(value:Number):void {
		}
		
		/**
		 * 	Gets the end loop point
		 */
		public function get loopEnd():Number {
			return 1;
		}
		
		/**
		 * 	Sets the end loop point
		 */
		public function set loopEnd(value:Number):void {
		}
		
		/**
		 * 	Gets path to the content
		 */
		public function get path():String {
			return _loader.contentLoaderInfo.url;
		}

		/**
		 * 	Returns the bitmap source
		 */
		public function get source():BitmapData {
			return _source;
		}


		/**
		 * 	Destroys the content
		 */
		public function dispose():void {
			
			// dispose it?
			if (_content is IDisposable) {
				(_content as IDisposable).dispose();
			}
			
			// remove it?
			if (parent) {
				parent.removeChild(this);
			}

			// destroy content
			_loader.unload();
			removeEventListener(Event.ENTER_FRAME, _onEnterFrame);

			// kill all filters
			clearFilters();

			_loader = null;
			_content = null;
			_filter = null;
			_filters = null;
		}

	}
}