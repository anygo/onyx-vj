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
	
	public final class ContentSWFMovieClip extends Bitmap implements IContent {
		
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
		private var _loopEnd:int				= 0;
		
		/**
		 * 	@private
		 * 	Counts the number of bitmap filters
		 */
		private var _bitmapFilterCount:int		= 0;
		
		/**
		 * 	@private
		 */
		private var _source:BitmapData			= getBaseBitmap();
		
		/**
		 * 	@private
		 * 	Stores last time the draw was executed
		 */
		private var _lastTime:uint;

		/**
		 * 	@constructor
		 */		
		public function ContentSWFMovieClip(loader:Loader):void {
			
			_loader		= loader;
			_content	= loader.content as MovieClip;
			
			if (Settings.LAYER_AUTOSIZE) {
				var ratioX:Number = 320 / loader.contentLoaderInfo.width;
				var ratioY:Number = 240 / loader.contentLoaderInfo.height;
			}
			
			_scaleX		= ratioX || 1;
			_scaleY		= ratioY || 1;
			
			_framerate	= loader.contentLoaderInfo.frameRate / Onyx.framerate;
			
			_loopStart	= 0;
			_loopEnd	= _content.totalFrames;
			
			// create the listener
			pause(false);

			super(getBaseBitmap());
			
			_lastTime = getTimer();
			
		}

		/**
		 * 	Sets the time
		 */
		public function set time(value:Number):void {
			var frame:int = Math.floor(_content.totalFrames * value);
			_frame = frame;
			
			_content.gotoAndStop(frame);
			updateSource();
		}
		
		/**
		 * 	Gets the time
		 */
		public function get time():Number {
			return _frame / _content.totalFrames;
		}
		
		/**
		 * 	Gets the total time
		 */
		public function get totalTime():Number {
			return _content.totalFrames;
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
			return hasEventListener(Event.ENTER_FRAME);
		}
		
		/**
		 * 	Runs every frame and adds time
		 */
		private function _onEnterFrame(event:Event):void {
			
			var diff:int = _loopEnd - _loopStart;
			
			// add the framerate based off the last time
			var frame:Number = _frame + (_framerate * ((getTimer() - _lastTime) / Onyx.framerate));

			frame = (frame < _loopStart) ? _loopEnd : Math.max(frame % _loopEnd, _loopStart);

			_frame = frame;

			// if the frame is different, update the source bitmap
			if (frame !== _content.currentFrame) {
				
				_content.gotoAndStop(Math.floor(frame));
				
				updateSource();
				
			}
			
			_lastTime = getTimer();
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
			_source.applyFilter(_source, _source.rect, new Point(0,0), _filter.filter);
			
			super.bitmapData.copyPixels(_source, _source.rect, new Point(0,0));
			applyFilters(super.bitmapData);

		}
		
		/**
		 * 	Gets the framerate
		 */
		public function get framerate():Number {
			// get the ratio of the original framerate and the actual framerate
			var ratio:Number = _loader.contentLoaderInfo.frameRate / Onyx.framerate
			
			return _framerate / ratio;
		}

		/**
		 * 	Sets framerate
		 */
		public function set framerate(value:Number):void {
			var ratio:Number = _loader.contentLoaderInfo.frameRate / Onyx.framerate
			
			_framerate = value * ratio;
		}
		
		/**
		 * 	Gets the beginning loop point
		 */
		public function get loopStart():Number {
			return _loopStart / _content.totalFrames;
		}

		/**
		 * 	Sets the beginning loop point (percentage)
		 */		
		public function set loopStart(value:Number):void {
			_loopStart = Math.min(Math.max(_content.totalFrames * value, 0), _loopEnd - 1);
			_frame = Math.max(_frame, _loopStart);
		}
		
		/**
		 * 	Gets the end loop point
		 */
		public function get loopEnd():Number {
			return _loopEnd / _content.totalFrames;
		}
		
		/**
		 * 	Sets the end loop point
		 */
		public function set loopEnd(value:Number):void {
			_loopEnd = Math.min(Math.max(_content.totalFrames * value, _loopStart + 1), _content.totalFrames);

			_frame = Math.min(_frame, _loopEnd);
		}
		
		/**
		 * 	Gets path to the content
		 */
		public function get path():String {
			return _loader.contentLoaderInfo.url;
		}

		public function addFilter(filter:Filter):void {
			
			// it's alive!
			filter.setContent(this);
			
			// push the layer into the array
			_filters.push(filter);
			
			// tell the filter it has started
			filter.initialize();
			
			// dispatch
			var event:FilterEvent = new FilterEvent(FilterEvent.FILTER_APPLIED, filter);
			dispatchEvent(event);
		}
		
		public function removeFilter(filter:Filter):void {
			
			var index:int = _filters.indexOf(filter);
			if (index >= 0) {
				_filters.splice(index, 1);
			}

			// dispose the filter
			filter.dispose();

			// dispatch a filter removed event
			var event:FilterEvent = new FilterEvent(FilterEvent.FILTER_REMOVED, filter)
			event.index = index;

			dispatchEvent(event);
		}
		
		/**
		 * 	@private
		 * 	Clears all the filters
		 */
		private function clearFilters():void {
			
			for (var count:int = _filters.length - 1; count >= 0; count--) {
				removeFilter(_filters[0] as Filter);
			}
		}
		
		override public function get filters():Array {
			return _filters;
		}
		
		/**
		 * 	Applies filters to bitmap
		 */
		public function applyFilters(bitmapData:BitmapData):void {
			
			// loop through and apply filters			
			for each (var filter:Filter in _filters) {
				if (filter is IBitmapFilter) {
					bitmapData = (filter as IBitmapFilter).applyFilter(bitmapData, bitmapData.rect);
				}
			}
		}
		
		/**
		 * 	Gets a filter's index
		 */
		public function getFilterIndex(filter:Filter):int {
			return _filters.indexOf(filter);
		}
		
		/**
		 * 
		 */
		public function moveFilterUp(filter:Filter):void {
			var index:int = _filters.indexOf(filter);

			if (index > 0) {

				_filters.splice(index, 1);
				_filters.splice(index - 1, 0, filter);
				
				dispatchEvent(new FilterEvent(FilterEvent.FILTER_APPLIED, filter));
				
			}
		}
		
		/**
		 * 
		 */
		public function moveFilterDown(filter:Filter):void {
			var index:int = _filters.indexOf(filter);
			if (index < _filters.length - 1) {
				_filters.splice(index, 1);
				_filters.splice(index + 1, 0, filter);

				dispatchEvent(new FilterEvent(FilterEvent.FILTER_MOVED, filter));
			}
		}
		
		/**
		 * 	Does it have filters?
		 */
		public function get hasFilters():Boolean {
			return (_filters.length > 0);
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