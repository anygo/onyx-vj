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
package onyx.layer {

	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	import flash.net.URLRequest;
	import flash.utils.getTimer;
	
	import onyx.constants.*;
	import onyx.content.*;
	import onyx.controls.*;
	import onyx.core.*;
	import onyx.display.Display;
	import onyx.events.*;
	import onyx.filter.*;
	import onyx.net.Stream;
	import onyx.transition.Transition;
	
	use namespace onyx_ns;
	
	[Event(name="filter_applied",	type="onyx.events.FilterEvent")]
	[Event(name="filter_removed",	type="onyx.events.FilterEvent")]
	[Event(name="filter_moved",		type="onyx.events.FilterEvent")]
	[Event(name="layer_loaded",		type="onyx.events.LayerEvent")]
	[Event(name="layer_moved",		type="onyx.events.LayerEvent")]
	[Event(name="progress",			type="flash.events.Event")]

	/**
	 * 	Layer is the base media for all video objects
	 */
	public class Layer extends Sprite implements ILayer {
		
		/**
		 * 	@private
		 * 	Stores the transition for layer
		 */
		private var _transition:Transition;

		/**
		 * 	@private
		 * 	Stores the content
		 */
		onyx_ns var	_content:IContent					= new ContentNull();

		/**
		 * 	@private
		 * 	The url request for the layer path
		 */
		private var			_request:URLRequest;
		
		/**
		 * 	Creates the base bitmap
		 */
		private var			_source:BitmapData			= getBaseBitmap();

		/**
		 * 	@private
		 * 	Controls
		 */
		private var			_properties:LayerProperties;
		
		/**
		 * 	@constructor
		 */
		public function Layer():void {

			mouseEnabled	= false;
			mouseChildren	= false;
			
			_properties = new LayerProperties(this);
			
		}
		
		/**
		 * 	Loads a file type into a layer
		 * 	The path of the file to load into the layer
		 **/
		public function load(request:URLRequest, settings:LayerSettings = null):void {
			
			// get the path
			var path:String = request.url;
	
			// get extension
			var extension:String = path.substr(path.lastIndexOf('.')+1, path.length).toLowerCase();
			
			// if it's an onx file, pass it over to the display
			if (extension === 'mix' || extension === 'xml') {
				
				if (parent is Display) {
					(parent as Display).load(request, this);
				}
				
			} else {
				
				// store the request
				_request = request;
				
				var loader:ContentLoader = new ContentLoader();
				loader.addEventListener(Event.COMPLETE,						_onContentStatus);
				loader.addEventListener(IOErrorEvent.IO_ERROR,				_onContentStatus);
				loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR,	_onContentStatus);
				loader.addEventListener(ProgressEvent.PROGRESS,				_forwardEvents);
				loader.load(request, extension, _properties, settings);
				
			}
		}
		
		/**
		 * 	@private
		 * 	Content Status Handler
		 */
		private function _onContentStatus(event:Event):void {
			
			// remove references
			var loader:ContentLoader = event.currentTarget as ContentLoader;
			loader.removeEventListener(Event.COMPLETE,					_onContentStatus);
			loader.removeEventListener(IOErrorEvent.IO_ERROR,			_onContentStatus);
			loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR,	_onContentStatus);
			loader.removeEventListener(ProgressEvent.PROGRESS,			_forwardEvents);
		
			if (event is ErrorEvent) {
				Console.output('Error loading layer: ', index, (event as ErrorEvent).text);
			} else {
			
				var contentEvent:LayerContentEvent = event as LayerContentEvent;
				
				trace(contentEvent.content);

				// if we have content, we have a successful load
				if (contentEvent.content) {
					_createContent(contentEvent.content, contentEvent.settings);
				}					
			}
		}
		
		/**
		 * 	@private
		 * 	Initializes Content
		 */
		private function _createContent(content:IContent, settings:LayerSettings):void {
			
			// if we don't have a transition, automatically destroy the earlier content
			if (!_transition) {
				_destroyContent();
			}
			
			if (_transition && !(_content is ContentNull)) {
				_transition.initializeTransition(_content, content, this);	
			}

			_content = content;
			
			// if it's a displayobject, add it
			if (_content is DisplayObject) {
				super.addChild(_content as DisplayObject);
			}
			
			// listen for events to forward			
			_content.addEventListener(FilterEvent.FILTER_APPLIED,	_forwardEvents);
			_content.addEventListener(FilterEvent.FILTER_MOVED,		_forwardEvents);
			_content.addEventListener(FilterEvent.FILTER_REMOVED,	_forwardEvents);

			// apply values
			settings.apply(content);

			// dispatch a load event
			var dispatch:LayerEvent = new LayerEvent(LayerEvent.LAYER_LOADED, this);
			dispatch.layer = this;
			super.dispatchEvent(dispatch);
		}
		
		/**
		 * 	@private
		 * 	Destroys the current content state
		 */
		private function _destroyContent():void {
			
			// destroys the earlier content
			_content.dispose();

			// removes listener forwarding
			_content.removeEventListener(FilterEvent.FILTER_APPLIED,	_forwardEvents);
			_content.removeEventListener(FilterEvent.FILTER_MOVED,		_forwardEvents);
			_content.removeEventListener(FilterEvent.FILTER_REMOVED,	_forwardEvents);
			
		}
		
		/**
		 * 	@private
		 * 	Listens for events and forwards them
		 */
		private function _forwardEvents(event:Event):void {
			super.dispatchEvent(event);
		}
		
		/**
		 * 	Sets time
		 */
		public function set time(value:Number):void {
			_content.time = value;
		}
		
		/**
		 * 	Gets time
		 */
		public function get time():Number {
			return _content.time;
		}
		
		/**
		 * 	Gets totalTime
		 */
		public function get totalTime():Number {
			return _content.totalTime;
		}
		
		/**
		 * 	Returns the path of the file loaded
		 */
		public function get path():String {
			return (_request) ? _request.url : null;
		}
		
		/**
		 * 	Returns the control array of the layer
		 */
		public function get controls():Controls {
			return _content.controls;
		}

		/**
		 * 	Gets the framerate of the movie adjusted to it's own time rate
		 */
		public function get framerate():Number {
			return _content.framerate;
		}

		/**
		 * 	Sets the framerate
		 */
		public function set framerate(value:Number):void {
			_content.framerate = value;
		}

		/**
		 * 	Gets the start loop point
		 */
		public function get loopStart():Number {
			return _content.loopStart;
		}

		/**
		 * 	Sets the start loop point
		 */
		public function set loopStart(value:Number):void {
			_content.loopStart = value;
		}

		/**
		 * 	Gets the start marker
		 */
		public function get loopEnd():Number {
			return _content.loopEnd;
		}

		/**
		 * 	Sets the right loop point for the video
		 */
		public function set loopEnd(value:Number):void {
			_content.loopEnd = value;
		}

		/**
		 * 	Pauses the layer
		 *	@param			True to pause, false to unpause
		 */
		public function pause(b:Boolean = true):void {
			_content.pause(b);
		}
		
		/**
		 * 	Returns a bitmapdata of the source file
		 **/
		public function get source():BitmapData {
			return _source;
		}
		
		/**
		 * 	Copys the layer down
		 */
		public function moveLayer(index:int):void {
			
			if (parent is Display) {
				var display:Display = parent as Display;
				display.moveLayer(this, index);
			}
		}
		
		/**
		 * 	Copys the layer down
		 */
		public function copyLayer():void {
			super.dispatchEvent(new LayerEvent(LayerEvent.LAYER_COPY_LAYER, this));
		}

		/**
		 * 	Returns the threshold
		 */
		public function get threshold():int {
			return _content.threshold;
		}

		/**
		 * 	Sets the threshold
		 */
		public function set threshold(value:int):void {
			_content.threshold = value;
		}
	
		/**
		 * 	Returns contrast
		 */
		public function get contrast():Number {
			return _content.contrast;
		}
		
		/**
		 * 	Sets contrast
		 */
		public function set contrast(value:Number):void {
			_content.contrast = value;
		}

		/**
		 * 	Gets brightness
		 */
		public function get brightness():Number {
			return _content.brightness;
		}
		
		/**
		 * 	Sets brightness
		 */
		public function set brightness(value:Number):void {
			_content.brightness = value;
		}

		/**
		 * 	Sets saturation
		 */
		public function get saturation():Number {
			return _content.saturation;
		}

		/**
		 * 	Gets saturation
		 */
		public function set saturation(value:Number):void {
			_content.saturation = value;
		}

		/**
		 * 	Returns tint
		 */
		public function get tint():Number {
			return _content.tint;
		}
		
		/**
		 * 	Sets tint
		 */
		public function set tint(value:Number):void {
			_content.tint = value;
		}

		/**
		 * 	Sets color
		 */
		public function set color(value:uint):void {
			_content.color = value;
		}

		/**
		 * 	Gets color of current content
		 */
		public function get color():uint {
			return _content.color;
		}
		
		/**
		 * 	Sets alpha of current content
		 */
		override public function set alpha(value:Number):void {
			_content.alpha = value;
		}

		/**
		 * 	Gets alpha of current content
		 */
		override public function get alpha():Number {
			return _content.alpha;
		}
		
		/**
		 * 	Sets alpha of current content
		 */
		override public function set blendMode(value:String):void {
			_content.blendMode = value;
		}

		/**
		 * 	Gets alpha of current content
		 */
		override public function get blendMode():String {
			return _content.blendMode;
		}

		/**
		 * 	Sets the x of current content
		 */
		override public function set x(value:Number):void {
			_content.x = value;
		}

		/**
		 * 	Sets the y of current content
		 */
		override public function set y(value:Number):void {
			_content.y = value;
		}

		/**
		 * 	Sets scaleX for current content
		 */
		override public function set scaleX(value:Number):void {
			_content.scaleX = value;
		}

		/**
		 * 	Sets scaleY for current content
		 */
		override public function set scaleY(value:Number):void {
			_content.scaleY = value;
		}
		
		/**
		 * 	Gets scaleX for current content
		 */
		override public function get scaleX():Number {
			return _content.scaleX;
		}

		/**
		 * 	Gets scaleY for current content
		 */
		override public function get scaleY():Number {
			return _content.scaleY;
		}

		/**
		 * 	Gets x for current content
		 */
		override public function get x():Number {
			return _content.x;
		}

		/**
		 * 	Gets y for current content
		 */
		override public function get y():Number {
			return _content.y;
		}
		
		/**
		 * 	Gets content rotation
		 */
		override public function get rotation():Number {
			return _content.rotation / RADIANS;
		}

		/**
		 * 	Sets content rotation
		 */
		override public function set rotation(value:Number):void {
			_content.rotation = value * RADIANS;
		}
		
		/**
		 * 	Gets transition that the layer is using
		 */
		public function get transition():Transition {
			return _transition
		}
		
		/**
		 * 	Sets the transition for the layer
		 */
		public function set transition(value:Transition):void {
			
			if (_transition) {
				_transition.dispose();
			}
			
			_transition = value;

		}
		
		/**
		 * 	Adds an onyx-based filter
		 * 	The onyx filter to add to the Layer
		 */
		public function addFilter(filter:Filter):void {
			_content.addFilter(filter);
		}
		
		/**
		 * 	Removes an onyx filter from the layer
		 * 	@param		The filter to remove
		 **/
		public function removeFilter(filter:Filter):void {
			_content.removeFilter(filter);
		}

		/**
		 * 	Overrides filters
		 */		
		override public function set filters(value:Array):void {
			throw new Error('Use addFilter() or removeFilter() instead');
		}
		
		/**
		 * 	Returns the filters
		 */
		override public function get filters():Array {
			return _content.filters.concat();
		}
		
		/**
		 * 	@private
		 * 	Ends a transition
		 */
		private function _endTransition(event:TransitionEvent):void {
			
			var transition:Transition = event.transition;
			
			// remove listener
			transition.removeEventListener(TransitionEvent.TRANSITION_END, _endTransition);

			// get the old content
			var oldcontent:IContent = transition.oldContent;

			// kill old content
			oldcontent.dispose();
			
			// remove listener
			// removeEventListener(Event.ENTER_FRAME, _renderTransition);

			// remove listener
			// addEventListener(Event.ENTER_FRAME, _render);
 
		}
		
		/**
		 * 	Draws bitmap
		 */
		public function draw(bmp:BitmapData):void {
			
			var scaleX:Number = bmp.width / _content.source.width;
			var scaleY:Number = bmp.height / _content.source.height;
			
			var matrix:Matrix = new Matrix();
			matrix.scale(scaleX, scaleY);
			
			bmp.draw(_content.bitmapData, matrix);
			
		}
		
		/**
		 * 	Merges a layer into the current layer (no load)
		 */
		public function merge(layer:Layer):void {
		}
		
		/**
		 * 	Returns the index of the layer within the display
		 **/
		public function get index():int {
			return (parent is Display) ? (parent as Display).indexOf(this) : -1;
		}
		

		/**
		 * 	Unloads the layer
		 **/
		public function unload():void {

			// disposes content
			if (!(_content is ContentNull)) {

				// dispatch an unload event
				super.dispatchEvent(new LayerEvent(LayerEvent.LAYER_UNLOADED, this));

				// store the current content				
				var content:IContent = _content;

				// destroy the content
				_destroyContent();

				// set content to nothing					
				_content			= new ContentNull();
				
				// change the property target to this layer
				_properties.target	= this;

			}
		}
		
		/**
		 * 	Disposes the layer
		 */
		public function dispose():void {
			unload();
		}
		
		/**
		 * 
		 */
		public function get properties():LayerProperties {
			return _properties;
		}
		
		/**
		 * 	@private
		 * 	Use this method to dispatch methods to the layer itself (not content
		 */
		onyx_ns function dispatch(event:Event):void {
			super.dispatchEvent(event);
		}
		
		/**
		 * 	Forwards event to the content
		 */
		override public function dispatchEvent(event:Event):Boolean {
			return _content.dispatchEvent(event);
		}

	}
}