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

		
	
		import flash.display.BitmapData;
		import flash.events.Event;
		import flash.geom.ColorTransform;
		import flash.geom.Matrix;
		import flash.geom.Point;
		import flash.geom.Rectangle;
		import flash.geom.Transform;
		import flash.utils.getTimer;
		
		import onyx.core.IDisposable;
		import onyx.core.onyx_internal;
		import onyx.events.FilterEvent;
		import onyx.filter.ColorFilter;
		import onyx.filter.Filter;
		import onyx.filter.IBitmapFilter;
		
		use namespace onyx_internal;

		private var _rect:Rectangle								= new Rectangle(0,0,320,240);

		/**
		 * 
		 */
		private var _source:BitmapData							= new BitmapData(320,240, true, 0x000000);

		/**
		 * 	@private
		 */
		private var _filters:Array							= [];

		/**
		 * 	@private
		 * 	Stores the matrix for the content
		 */
		private var _matrix:Matrix							= new Matrix();
		
		/**
		 * 	@private
		 */
		private var _alpha:Number							= 1;

		/**
		 * 	@private
		 */
		private var _rotation:Number						= 0;

		/**
		 * 	@private
		 */
		private var _colorTransform:ColorTransform			= new ColorTransform(); 
		
		/**
		 * 	@private
		 */
		private var _scaleX:Number							= 1;

		/**
		 * 	@private
		 */
		private var _scaleY:Number							= 1;

		/**
		 * 	@private
		 */
		private var _x:Number								= 0;

		/**
		 * 	@private
		 */
		private var _y:Number								= 0;

		/**
		 * 	@private
		 */
		private var _tint:Number							= 0;

		/**
		 * 	@private
		 */
		private var _color:Number							= 0;
		
		/**
		 * 	@private
		 */
		private var _filter:ColorFilter						= new ColorFilter();
		
		/**
		 * 	Tint
		 */
		public function set tint(value:Number):void {		
			
			_tint = value;
			
			var r:Number = ((_color & 0xFF0000) >> 16) * value;
			var g:Number = ((_color & 0x00FF00) >> 8) * value;
			var b:Number = (_color & 0x0000FF) * value;

			var amount:Number = 1 - value;
			
			_colorTransform = new ColorTransform(amount,amount,amount,_alpha,r,g,b);
		}
		
		/**
		 * 	Sets color
		 */
		public function set color(value:uint):void {
			
			_color = value;
			
			var r:Number = ((_color & 0xFF0000) >> 16) * _tint;
			var g:Number = ((_color & 0x00FF00) >> 8) * _tint;
			var b:Number = (_color & 0x0000FF) * _tint;

			var amount:Number = 1 - _tint;

			_colorTransform = new ColorTransform(amount,amount,amount,_alpha,r,g,b);
		}

		
		public function set alpha(value:Number):void {
			_alpha = value;
			
			var r:Number = ((_color & 0xFF0000) >> 16) * _tint;
			var g:Number = ((_color & 0x00FF00) >> 8) * _tint;
			var b:Number = (_color & 0x0000FF) * _tint;

			var amount:Number = 1 - _tint;

			_colorTransform = new ColorTransform(amount,amount,amount,_alpha,r,g,b);
		}
		
		/**
		 * 	Gets color
		 */
		public function get color():uint {
			return _color;
		}

		/**
		 * 	Gets tint
		 */
		public function get tint():Number {
			return _tint;
		}
		
		/**
		 * 	Sets x
		 */
		public function set x(value:Number):void {
			_x = value;
			_buildMatrix();
		}

		/**
		 * 	Sets y
		 */
		public function set y(value:Number):void {
			_y = value;
			_buildMatrix();
		}

		public function set scaleX(value:Number):void {
			_scaleX = value;
			_buildMatrix();
		}

		public function set scaleY(value:Number):void {
			_scaleY = value;
			_buildMatrix();
		}
		
		public function get scaleX():Number {
			return _scaleX;
		}

		public function get scaleY():Number {
			return _scaleY;
		}

		public function get x():Number {
			return _x;
		}

		public function get y():Number {
			return _y;
		}
		
		public function get alpha():Number {
			return _alpha;
		}
		
		public function get rotation():Number {
			return _rotation;
		}

		public function set rotation(value:Number):void {
			_rotation = value;
			_buildMatrix();
		}
		
		public function get saturation():Number {
			return _filter._saturation;
		}
		
		public function set saturation(value:Number):void {
			_filter.saturation = value;
		}

		public function get contrast():Number {
			return _filter._contrast;
		}

		public function set contrast(value:Number):void {
			_filter.contrast = value;
		}

		public function get brightness():Number {
			return _filter._brightness;
		}
		
		public function set brightness(value:Number):void {
			_filter.brightness = value;
		}

		public function get threshold():int {
			return _filter._threshold;
		}
		
		public function set threshold(value:int):void {
			_filter.threshold = value;
		}

		private function _buildMatrix():void {
			_rect	= new Rectangle();
			_rect.x = _x;
			_rect.y = _y;
			_rect.width = 320 * _scaleX;
			_rect.height = 240 * _scaleY;

			_matrix.identity();
			_matrix.translate(_x, _y);
			_matrix.scale(_scaleX, _scaleY);
		}

		public function addFilter(filter:Filter):void {
			
			// it's alive!
			filter.setContent(this);
			
			// push the layer into the array
			_filters.push(filter);
			
			// tell the filter it has started
			filter.initialize();
			
			// dispatch a creation
			_layer.dispatchEvent(new FilterEvent(FilterEvent.FILTER_APPLIED, filter));

		}
		
		public function removeFilter(filter:Filter):void {
			
			var index:int = _filters.indexOf(filter);
			if (index >= 0) {
				_filters.splice(index, 1);
			}

			// dispose the filter
			filter.dispose();

			var event:FilterEvent = new FilterEvent(FilterEvent.FILTER_REMOVED, filter)
			event.index = index;
			
			_layer.dispatchEvent(event);

		}
		
		private function clearFilters():void {
			for (var count:int = _filters.length - 1; count >= 0; count--) {
				removeFilter(_filters[count] as Filter);
			}
		}
		
		public function get filters():Array {
			return _filters;
		}
		
		public function get rendered():BitmapData {
			return null; // _layer.bitmapData;
		}
		
		public function get source():BitmapData {
			return _source;
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
				
				_layer.dispatchEvent(new FilterEvent(FilterEvent.FILTER_MOVED, filter));
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

				_layer.dispatchEvent(new FilterEvent(FilterEvent.FILTER_MOVED, filter));
			}
		}
		
		/**
		 * 
		 */
		public function get hasFilters():Boolean {
			return (_filters.length > 0);
		}
		
		/**
		 * 	Draws
		 */
		public function draw():BitmapData {
			
			// draw
			_source.fillRect(_source.rect, 0x00000000);
			
			// draw it
			_source.draw(_loader, _matrix, _colorTransform);
			
			// need to apply the color filter
			_source.applyFilter(_source, _source.rect, new Point(0,0), _filter.filter);
			
			return _source;
		}
		
		public function buildBitmap():void {
		}
	}
}