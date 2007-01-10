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
	
	import onyx.application.Onyx;
	import onyx.controls.*;
	import onyx.core.*;
	import onyx.events.FilterEvent;
	import onyx.filter.*;
	import onyx.layer.*;
	import onyx.net.IContentObject;
	import onyx.net.Plugin;
	import onyx.settings.Settings;
	import onyx.tween.Tween;
	import onyx.utils.ArrayUtil;
	
	[Event(name="filter_applied",	type="onyx.events.FilterEvent")]
	[Event(name="filter_removed",	type="onyx.events.FilterEvent")]
	[Event(name="filter_moved",		type="onyx.events.FilterEvent")]
		
	use namespace onyx_ns;
	
	[ExcludeClass]
	public class Content extends Bitmap implements IContent {
		
		/**
		 * 	@private
		 * 	Stores the filters for this content
		 */
		private var _filters:Array								= [];

		/**
		 * 	@private
		 */
		private var _filter:ColorFilter							= new ColorFilter();
		
		/**
		 * 	@private
		 * 	Stores the matrix for the content
		 */
		private var _matrix:Matrix								= new Matrix();
		
		/**
		 * 	@private
		 */
		private var _rotation:Number;

		/**
		 * 	@private
		 */
		private var _colorTransform:ColorTransform				= new ColorTransform(); 
		
		/**
		 * 
		 */
		protected var _paused:Boolean = false;

		/**
		 * 	@private
		 */
		private var _scaleX:Number;

		/**
		 * 	@private
		 */
		private var _scaleY:Number;

		/**
		 * 	@private
		 */
		private var _x:int;

		/**
		 * 	@private
		 */
		private var _y:int;

		/**
		 * 	@private
		 */
		private var _tint:Number;

		/**
		 * 	@private
		 */
		private var _color:uint;

		/**
		 * 	@private
		 * 	The source
		 */
		protected var _source:BitmapData						= getBaseBitmap();
		
		/**
		 * 	@private
		 */
		protected var _rendered:BitmapData						= getBaseBitmap();
		
		/**
		 * 	@private
		 * 	Stores the layer's controls so that the external content can use them
		 */
		private var _controls:Controls;
		
		/**
		 * 	@private
		 * 	Stores the content that we're gonna draw
		 */
		private var _content:IBitmapDrawable;
		
		// stores controls
		protected var __color:Control;
		protected var __alpha:Control;
		protected var __brightness:Control;
		protected var __contrast:Control;
		protected var __scaleX:Control;
		protected var __scaleY:Control;
		protected var __rotation:Control;
		protected var __saturation:Control;
		protected var __threshold:Control;
		protected var __tint:Control;
		protected var __x:Control;
		protected var __y:Control;
		protected var __framerate:Control;
		protected var __loopStart:Control;
		protected var __loopEnd:Control;
		protected var __blendMode:Control;

		/**
		 * 	@constructor
		 */		
		public function Content(props:LayerProperties, content:IBitmapDrawable):void {

			// set bitmap
			super(getBaseBitmap());

			// store controls
			__color			= props.color;
			__alpha 		= props.alpha;
			__brightness	= props.brightness;
			__contrast		= props.contrast;
			__scaleX		= props.scaleX;
			__scaleY		= props.scaleY;
			__rotation		= props.rotation;
			__saturation	= props.saturation;
			__threshold		= props.threshold;
			__tint			= props.tint;
			__x				= props.x;
			__y				= props.y;
			__framerate		= props.framerate;
			__loopStart		= props.loopStart;
			__loopEnd		= props.loopEnd;
			__blendMode		= props.blendMode;
			
			// set targets
			props.target	= this;
			
			// store content
			_content	= content;
			
			// check for custom controls
			if (_content is IControlObject) {
				_controls = (_content as IControlObject).controls;
			}
			
			// if it takes events, pass em on
			if (_content is IEventDispatcher) {
				addEventListener(MouseEvent.MOUSE_DOWN,	_forwardEvents);
				addEventListener(MouseEvent.MOUSE_UP,	_forwardEvents);
				addEventListener(MouseEvent.MOUSE_MOVE,	_forwardEvents);
			}
			
			// if it wants the stage, pass it over
			if (_content is IContentObject) {
				var stageContent:IContentObject = _content as IContentObject;
				stageContent.initialize(Onyx.root, this);
			}
			
			addEventListener(Event.ENTER_FRAME, render);
		}
		
		
		/**
		 * 	Gets alpha
		 */
		override public function get alpha():Number {
			return _colorTransform.alphaMultiplier;
		}

		/**
		 * 	Sets alpha
		 */
		override public function set alpha(value:Number):void {
			_colorTransform.alphaMultiplier = __alpha.setValue(value);
		}
		
		/**
		 * 	Tint
		 */
		public function set tint(value:Number):void {		
			
			_tint = value;
			
			var r:Number = ((_color & 0xFF0000) >> 16) * value;
			var g:Number = ((_color & 0x00FF00) >> 8) * value;
			var b:Number = (_color & 0x0000FF) * value;

			var amount:Number = 1 - value;
			
			_colorTransform = new ColorTransform(amount,amount,amount,1,r,g,b);
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

			_colorTransform = new ColorTransform(amount,amount,amount,1,r,g,b);
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
		override public function set x(value:Number):void {
			_x = __x.setValue(value);
		}

		/**
		 * 	Sets y
		 */
		override public function set y(value:Number):void {
			_y = __y.setValue(value);;
		}

		override public function set scaleX(value:Number):void {
			_scaleX = __scaleX.setValue(value);
		}

		override public function set scaleY(value:Number):void {
			_scaleY = __scaleY.setValue(value);
		}
		
		override public function get scaleX():Number {
			return _scaleX;
		}

		override public function get scaleY():Number {
			return _scaleY;
		}

		override public function get x():Number {
			return _x;
		}

		override public function get y():Number {
			return _y;
		}
		
		/**
		 * 	Gets saturation
		 */
		public function get saturation():Number {
			return _filter._saturation;
		}
		
		/**
		 * 	Sets saturation
		 */
		public function set saturation(value:Number):void {
			_filter.saturation = __saturation.setValue(value);
		}

		/**
		 * 	Gets contrast
		 */
		public function get contrast():Number {
			return _filter._contrast;
		}

		/**
		 * 	Sets contrast
		 */
		public function set contrast(value:Number):void {
			_filter.contrast = __contrast.setValue(value);
		}

		/**
		 * 	Gets brightness
		 */
		public function get brightness():Number {
			return _filter._brightness;
		}
		
		/**
		 * 	Sets brightness
		 */
		public function set brightness(value:Number):void {
			_filter.brightness = __brightness.setValue(value);
		}

		/**
		 * 	Gets threshold
		 */
		public function get threshold():int {
			return _filter._threshold;
		}
		
		/**
		 * 	Sets threshold
		 */
		public function set threshold(value:int):void {
			_filter.threshold = __threshold.setValue(value);
		}
		
		/**
		 *	Returns rotation
		 */
		override public function get rotation():Number {
			return _rotation;
		}

		/**
		 *	@private
		 * 	Sets rotation
		 */
		override public function set rotation(value:Number):void {
			_rotation = value;
		}

		/**
		 * 	Adds a filter
		 */
		public function addFilter(filter:Filter):void {
			
			if (filter._unique) {
				
				var plugin:Plugin = Onyx.getDefinition(filter.name);
				
				for each (var otherFilter:Filter in _filters) {
					if (otherFilter is plugin.definition) {
						return;
					}
				}
			}
			
			// it's alive!
			filter.setContent(this, Onyx.root);
			
			// push the layer into the array
			_filters.push(filter);
			
			// tell the filter it has started
			filter.initialize();
			
			// dispatch
			var event:FilterEvent = new FilterEvent(FilterEvent.FILTER_APPLIED, filter);
			dispatchEvent(event);
		}

		/**
		 * 	Removes a filter
		 */		
		public function removeFilter(filter:Filter):void {
			
			// now remove it
			var index:int = _filters.indexOf(filter);
			
			if (index >= 0) {

				// remove the filter
				_filters.splice(index, 1);

				// dispatch a filter removed event
				var event:FilterEvent = new FilterEvent(FilterEvent.FILTER_REMOVED, filter)
				dispatchEvent(event);

				// dispose the filter
				filter.dispose();
				
				// clean up our references
				filter.cleanContent();
			}
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
		
		/**
		 * 
		 */
		override public function set filters(value:Array):void {
			throw new Error('set filters overridden');
		}
		/**
		 * 	Returns filters
		 */
		override public function get filters():Array {
			
			return _filters;
		}
		
		/**
		 * 	@private
		 * 	Applies filters to bitmap
		 */
		private function _applyFilters(bitmapData:BitmapData):void {
			
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
		 * 	Moves a filter to an index
		 */
		public function moveFilter(filter:Filter, index:int):void {
			
			if (ArrayUtil.swap(_filters, filter, index)) {
				dispatchEvent(new FilterEvent(FilterEvent.FILTER_MOVED, filter));
			}
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
		public function get totalTime():int {
			return 1;
		}
		
		/**
		 * 	Pauses content
		 */
		public function pause(value:Boolean = true):void {
			_paused = value;
		}
		
		/**
		 * 	@private
		 * 	Renders the content
		 */
		protected function render(event:Event = null, update:Boolean = true):void {
			
			// lock the bitmaps
			_source.lock();
			super.bitmapData.lock();

			if (update) {

				// store a temporary rendered			
				_rendered.copyPixels(bitmapData, bitmapData.rect, POINT);
			
				// draw everything

				_matrix.identity();
				_matrix.scale(_scaleX, _scaleY);
				_matrix.rotate(_rotation);
				_matrix.translate(_x, _y);
			
				// if rotation is 0, send a clipRect, otherwise, don't clip
				var rect:Rectangle = (_rotation === 0) ? new Rectangle(0, 0, Math.max(320 / _scaleX, 320), Math.max(240 / _scaleY, 240)) : null;

				// if it's a contentobject, we're gonna let it render itself
				if (_content is IContentObject) {
					(_content as IContentObject).render(_source, _matrix, _colorTransform, rect);
				} else {
					_drawContent(_matrix, rect);
				}
			}
		
			// apply the color filter to the source
			_source.applyFilter(_source, _source.rect, POINT, _filter.filter);

			super.bitmapData.copyPixels(_source, _source.rect, POINT);
		
			_applyFilters(super.bitmapData);
		
			// unlock them
			_source.unlock();
			super.bitmapData.unlock();
		}
		
		/**
		 * 
		 */
		private function _drawContent(matrix:Matrix, clipRect:Rectangle):void {

			// fill the source with nothing
			_source.fillRect(_source.rect, 0x00000000);
			_source.draw(_content, matrix, _colorTransform, null, clipRect);
			
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
		 * 	Gets the beginning loop point
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
		 * 	Returns the bitmap source
		 */
		public function get source():BitmapData {
			return _source;
		}
		
		/**
		 * 	Destroys the content
		 */
		public function dispose():void {
			
			// don't render anymore
			removeEventListener(Event.ENTER_FRAME, render);
			
			Tween.stopTweens(this);
			
			// if it takes events, pass em on
			if (_content is IEventDispatcher) {
				removeEventListener(MouseEvent.MOUSE_DOWN,	_forwardEvents);
				removeEventListener(MouseEvent.MOUSE_UP,	_forwardEvents);
				removeEventListener(MouseEvent.MOUSE_MOVE,	_forwardEvents);
			}
			
			// check to see if it's disposable
			if (_content is IDisposable) {
				(_content as IDisposable).dispose();
			}
			
			// remove it?
			if (parent) {
				parent.removeChild(this);
			}
			
			// store controls
			__color			= null;
			__alpha 		= null;
			__brightness	= null;
			__contrast		= null;
			__scaleX		= null;
			__scaleY		= null;
			__rotation		= null;
			__saturation	= null;
			__threshold		= null;
			__tint			= null;
			__x				= null;
			__y				= null;
			__framerate		= null;
			__loopStart		= null;
			__loopEnd		= null;
			__blendMode		= null;
			
			// kill all filters
			clearFilters();

			// dispose
			_source.dispose();
			_rendered.dispose();

			// dispose
			bitmapData.dispose();
			
			// clear references
			
			_content = null;
			_filter = null;
			_filters = null;
			_controls = null;
		}
		
		/**
		 * 	Sets blendmode
		 */
		override public function set blendMode(value:String):void {
			super.blendMode = __blendMode.setValue(value);
		}
		
		/**
		 * 	Returns content controls
		 */
		public function get controls():Controls {
			return _controls;
		}
		
		/**
		 * 	@private
		 * 	Forwards events
		 */
		private function _forwardEvents(event:MouseEvent):void {
			var content:IEventDispatcher = _content as IEventDispatcher;
			content.dispatchEvent(event);
			
			// content will be part of layer, so make sure it doesn't bubble
			event.stopPropagation();
		}
		
		/**
		 * 
		 */
		public function get previousRender():BitmapData {
			return _rendered;
		}

	}
}