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
	import flash.filters.ColorMatrixFilter;
	import flash.geom.*;
	import flash.utils.getTimer;
	
	import onyx.constants.*;
	import onyx.controls.*;
	import onyx.core.*;
	import onyx.events.FilterEvent;
	import onyx.filter.*;
	import onyx.layer.*;
	import onyx.plugin.IContentObject;
	import onyx.plugin.Plugin;
	import onyx.settings.Settings;
	import onyx.tween.Tween;
	import onyx.utils.ArrayUtil;
	
	[Event(name="filter_applied",	type="onyx.events.FilterEvent")]
	[Event(name="filter_removed",	type="onyx.events.FilterEvent")]
	[Event(name="filter_moved",		type="onyx.events.FilterEvent")]
		
	use namespace onyx_ns;
	
	public class Content extends EventDispatcher implements IContent {
		
		/**
		 * 	@private
		 */
		onyx_ns var _layer:Layer;
		
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
		onyx_ns var _renderMatrix:Matrix;
		
		/**
		 * 	The concatenated matrix
		 */
		private var _matrix:Matrix;
		
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
		protected var _controls:Controls;
		
		/**
		 * 	@private
		 * 	Stores the content that we're gonna draw
		 */
		protected var _content:IBitmapDrawable;
		
		// stores controls
		private var __color:Control;
		private var __alpha:Control;
		private var __brightness:Control;
		private var __contrast:Control;
		private var __scaleX:Control;
		private var __scaleY:Control;
		private var __rotation:Control;
		private var __saturation:Control;
		private var __threshold:Control;
		private var __tint:Control;
		private var __x:Control;
		private var __y:Control;
		private var __framerate:Control;
		private var __blendMode:Control;
		protected var __loopStart:Control;
		protected var __loopEnd:Control;

		/**
		 * 	@constructor
		 */		
		public function Content(layer:Layer, content:IBitmapDrawable, newTarget:IControlObject = null):void {
			
			var props:LayerProperties = layer.properties;

			// store layer
			_layer = layer;
			
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
			props.target	= newTarget || this;
			
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
			
			// create the first frame
			if (content) {
				updateSource(null);
			}
		}
		
		/**
		 * 	Gets alpha
		 */
		public function get alpha():Number {
			return _colorTransform.alphaMultiplier;
		}

		/**
		 * 	Sets alpha
		 */
		public function set alpha(value:Number):void {
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
		public function set x(value:Number):void {
			_x				= __x.setValue(value);
			_renderMatrix	= null;
		}

		/**
		 * 	Sets y
		 */
		public function set y(value:Number):void {
			_y				= __y.setValue(value);
			_renderMatrix	= null;
		}

		public function set scaleX(value:Number):void {
			_scaleX			= __scaleX.setValue(value);
			_renderMatrix	= null;
		}

		public function set scaleY(value:Number):void {
			_scaleY			= __scaleY.setValue(value);
			_renderMatrix	= null;
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
		public function get rotation():Number {
			return _rotation;
		}

		/**
		 *	@private
		 * 	Sets rotation
		 */
		public function set rotation(value:Number):void {
			_rotation = value;
			_renderMatrix = null;
		}

		/**
		 * 	Adds a filter
		 */
		public function addFilter(filter:Filter):void {
			
			// check for unique filters
			if (filter._unique) {
				
				var plugin:Plugin = Filter.getDefinition(filter.name);
				
				for each (var otherFilter:Filter in _filters) {
					if (otherFilter is plugin._definition) {
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
		internal function clearFilters():void {
			
			for (var count:int = _filters.length - 1; count >= 0; count--) {
				removeFilter(_filters[0] as Filter);
			}
		}
		
		/**
		 * 
		 */
		public function set filters(value:Array):void {
			throw new Error('set filters overridden, use addFilter, removeFilter');
		}
		/**
		 * 	Returns filters
		 */
		public function get filters():Array {
			return _filters;
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
		 * 	Gets the transform
		 */
		public function getTransform():RenderTransform {
			var transform:RenderTransform = new RenderTransform();

			// test our stored matrix
			if (!_renderMatrix) {
				_renderMatrix = new Matrix();
				_renderMatrix.scale(_scaleX, _scaleY);
				_renderMatrix.rotate(_rotation);
				_renderMatrix.translate(_x, _y);
			}

			// if we have a matrix set, append it			
			var matrix:Matrix = _renderMatrix.clone();
			if (_matrix) {
				matrix.concat(_matrix);
			}

			// if rotation is 0, send a clipRect, otherwise, don't clip
			var rect:Rectangle = (_rotation === 0) ? new Rectangle(0, 0, Math.max(320 / _scaleX, 320), Math.max(240 / _scaleY, 240)) : null;

			transform.matrix			= matrix;
			transform.rect				= rect;
			transform.colorTransform	= _colorTransform;

			return transform;
		}
		
		/**
		 * 	Called by the parent layer every frame to render
		 */
		public function render(source:BitmapData, transform:RenderTransform = null):void {

			// updates source			
			updateSource(transform);

			// apply filters the rendered bitmap
			applyFilters();
			
			// copy the pixels back to the layer
			if (source) {
				source.copyPixels(_rendered, _rendered.rect, POINT);
			}
		}
		
		/**
		 * 
		 */
		onyx_ns function updateSource(transform:RenderTransform):void {
			
			var transform:RenderTransform		= transform || getTransform();
			var rect:Rectangle					= transform.rect;
			var matrix:Matrix					= transform.matrix;
			var colorTransform:ColorTransform	= transform.colorTransform;
			
			// fill our source with nothing
			_source.fillRect(source.rect, 0x00000000);
			
			// draw our content
			_source.draw(_content, matrix, colorTransform, null, rect);

			// apply the color filter to the source
			_source.applyFilter(_source, _source.rect, POINT, _filter.filter);
			
		}
		
		/**
		 * 	@private
		 * 	Applies filters to bitmap
		 */
		onyx_ns function applyFilters():void {

			// copy pixels to our "rendered" buffer
			_rendered.copyPixels(_source, _source.rect, POINT);
			
			// loop through and apply filters			
			for each (var filter:Filter in _filters) {
				if (filter is IBitmapFilter) {
					(filter as IBitmapFilter).applyFilter(_rendered, _rendered.rect);
				}
			}
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
			__framerate.setValue(value);
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
		 * 	Sets blendmode
		 */
		public function set blendMode(value:String):void {
			_layer.blendMode = value;
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
		
		/**
		 * 
		 */
		public function set matrix(value:Matrix):void {
			_matrix = value;
		}
		
		/**
		 * 	Destroys the content
		 */
		public function dispose():void {
						
			// stop all tweens related to this content
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
			
			// remove references
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
			
			// clear references

			_source = null;
			_rendered = null;
			_content = null;
			_filter = null;
			_filters = null;
			_controls = null;
			_layer = null;
		}
		
		/**
		 * 
		 */
		public function get rendered():BitmapData {
			return _rendered;
		}
		
		/**
		 * 
		 */
		public function get blendMode():String {
			return _layer.blendMode;
		}
	}
}