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
	public class Layer extends Bitmap implements ILayer {
		
		/**
		 * 	@private
		 * 	Stores the content
		 */
		onyx_ns var			_content:IContent				= new ContentNull();

		/**
		 * 	@private
		 * 	The url request for the layer path
		 */
		private var			_request:URLRequest;

		/**
		 * 	@private
		 * 	Controls
		 */
		private var			_properties:LayerProperties;
		
		/**
		 * 	@constructor
		 */
		public function Layer():void {

			_properties = new LayerProperties(this);
			
			super(null);
			
		}
		
		/**
		 * 	Loads a file type into a layer
		 * 	The path of the file to load into the layer
		 **/
		public function load(request:URLRequest, settings:LayerSettings = null, transition:Transition = null):void {
			
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
				
				// load content
				var loader:ContentLoader = new ContentLoader();
				loader.addEventListener(Event.COMPLETE,						_onContentStatus);
				loader.addEventListener(IOErrorEvent.IO_ERROR,				_onContentStatus);
				loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR,	_onContentStatus);
				loader.addEventListener(ProgressEvent.PROGRESS,				_forwardEvents);
				
				// load
				loader.load(request, extension, settings, transition);
				
			}
		}
		
		/**
		 * 	@private
		 * 	Content Status Handler
		 */
		private function _onContentStatus(event:Event):void {
			
			// remove references
			var loader:ContentLoader = event.currentTarget as ContentLoader;
			loader.removeEventListener(Event.COMPLETE,						_onContentStatus);
			loader.removeEventListener(IOErrorEvent.IO_ERROR,				_onContentStatus);
			loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,	_onContentStatus);
			loader.removeEventListener(ProgressEvent.PROGRESS,				_forwardEvents);
		
			// check for error
			if (event is ErrorEvent) {
				
				Console.output('Error loading layer: ', index, (event as ErrorEvent).text);
			
			} else {
			
				// get event info
				var contentEvent:LayerContentEvent = event as LayerContentEvent;

				// create the new content object based on the type				
				var loadedContent:Content = new contentEvent.contentType(this, contentEvent.reference);

				// if a transition was loaded, load the transition with the layer
				if (!(_content is ContentNull) && contentEvent.transition) {
					
					if (_content is ContentTransition) {
						
						// end the transition
						(_content as ContentTransition).endTransition();
						
						// create a new transition
						loadedContent = new ContentTransition(this, contentEvent.transition, _content, loadedContent);
					} else {
						loadedContent = new ContentTransition(this, contentEvent.transition, _content, loadedContent);
					}
					
				}

				// pass the content on
				_createContent(loadedContent, contentEvent.settings);

			}
		}
		
		/**
		 * 	@private
		 * 	Initializes Content
		 */
		private function _createContent(content:Content, settings:LayerSettings):void {
			
			// create a new bitmap?
			if (!super.bitmapData) {
				super.bitmapData = getBaseBitmap();
			}
	
			// only destroy previous content if it's not a transition		
			if (!(_content is ContentNull) && !(content is ContentTransition)) {
				_destroyContent();
			}
			
			// store content
			_content = content;
			
			// listen for events to forward			
			_content.addEventListener(FilterEvent.FILTER_APPLIED,		_forwardEvents);
			_content.addEventListener(FilterEvent.FILTER_MOVED,			_forwardEvents);
			_content.addEventListener(FilterEvent.FILTER_REMOVED,		_forwardEvents);
			
			// listen every frame
			if (_content is Content) {
				addEventListener(Event.ENTER_FRAME, _renderContent);
			}

			// test transition
			if (content is ContentTransition) {

				_content.addEventListener(TransitionEvent.TRANSITION_END,	_endTransition);
				settings.apply((content as ContentTransition).loadedContent);

			} else {
				
				if (settings) {
					settings.apply(content);
				}
				
			}

			// dispatch a load event
			var dispatch:LayerEvent = new LayerEvent(LayerEvent.LAYER_LOADED, this);
			dispatch.layer = this;
			super.dispatchEvent(dispatch);
		}
		
		/**
		 * 	@private
		 *	Handler for when a transition ends (swap the content
		 */
		private function _endTransition(event:TransitionEvent):void {
			
			var transition:ContentTransition = event.currentTarget as ContentTransition;
			transition.removeEventListener(TransitionEvent.TRANSITION_END, _endTransition);
			
			// create the content
			_createContent(event.content, null);
		}
		
		/**
		 * 	@private
		 * 	Renders the content onto this bitmap
		 */
		private function _renderContent(event:Event):void {
			
			super.bitmapData.lock();
			
			_content.render(super.bitmapData, null);
			
			super.bitmapData.unlock();
			
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
			super.blendMode = _properties.blendMode.setValue(value);
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
		 * 	Draws bitmap from a source bitmap
		 */
		public function draw(bmp:BitmapData):void {
			
			var scaleX:Number = bmp.width / _content.source.width;
			var scaleY:Number = bmp.height / _content.source.height;
			
			var matrix:Matrix = new Matrix();
			matrix.scale(scaleX, scaleY);
			
			bmp.draw(_content.rendered, matrix);
			
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
			
			if (super.bitmapData) {
				super.bitmapData.dispose();
				super.bitmapData = null;
			}

			// disposes content
			if (_content) {

				// dispatch an unload event
				super.dispatchEvent(new LayerEvent(LayerEvent.LAYER_UNLOADED, this));

				// stop rendering
				removeEventListener(Event.ENTER_FRAME, _renderContent);

				// destroy the content
				_destroyContent();

				// set content to nothing					
				_content			= new ContentNull();
				
				// change the property target to this layer
				_properties.target	= this;

			}
		}
		
		/**
		 * 	Returns properties related to the layer
		 */
		public function get properties():LayerProperties {
			return _properties;
		}
		
		/**
		 * 	@private
		 * 	Use this method to dispatch methods to the layer itself (not content)
		 */
		onyx_ns function dispatch(event:Event):void {
			super.dispatchEvent(event);
		}
		
		/**
		 * 	Forwards event to the content
		 * 	(usually mouse events)
		 */
		override public function dispatchEvent(event:Event):Boolean {
			return _content.dispatchEvent(event);
		}
		
		/**
		 * 	Disposes the layer
		 */
		public function dispose():void {
			unload();
		}
		
	}
}