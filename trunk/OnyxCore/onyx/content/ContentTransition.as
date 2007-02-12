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
	
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.*;
	import flash.geom.*;
	import flash.utils.getTimer;
	
	import onyx.constants.POINT;
	import onyx.controls.*;
	import onyx.core.RenderTransform;
	import onyx.core.onyx_ns;
	import onyx.events.FilterEvent;
	import onyx.events.TransitionEvent;
	import onyx.filter.Filter;
	import onyx.layer.Layer;
	import onyx.layer.LayerProperties;
	import onyx.transition.Transition;
	import onyx.transition.IBitmapTransition;
	
	use namespace onyx_ns;
	
	public final class ContentTransition extends Content {
		
		/**
		 * 	@private
		 * 	Stores old content
		 */
		private var _oldContent:Content;

		/**
		 * 	@private
		 * 	Stores new content
		 */
		private var _newContent:Content;

		/**
		 * 	@private
		 * 	Stores transition
		 */
		private var _transition:Transition;
		
		/**
		 * 	@private
		 * 	Stores the start of the transition
		 */
		private var _startTime:uint;
		
		/**
		 * 	@constructor
		 */
		public function ContentTransition(layer:Layer, transition:Transition, current:Content, loaded:Content):void {
			
			_transition = transition;
			_oldContent	= current as Content;
			_newContent = loaded as Content;
			
			_newContent.addEventListener(FilterEvent.FILTER_APPLIED,		_forwardEvents);
			_newContent.addEventListener(FilterEvent.FILTER_MOVED,			_forwardEvents);
			_newContent.addEventListener(FilterEvent.FILTER_REMOVED,		_forwardEvents);
			
			super(layer, null, loaded);

			// initialize the transition
			_transition.setContent(current, loaded);

			// initialize the transition
			_transition.initialize();

			// set time			
			_startTime = getTimer();

		}
		
		/**
		 * 	@private
		 * 	Forward events from the new content
		 */
		private function _forwardEvents(event:Event):void {
			dispatchEvent(event);
		}
		
		/**
		 * 	Ends a transition
		 */
		public function endTransition():void {
			dispatchEvent(new TransitionEvent(TransitionEvent.TRANSITION_END, _newContent));
		}
		
		/**
		 * 	Renders the bitmap
		 */
		override public function render(source:BitmapData, transform:RenderTransform = null):void {
			
			// get the time of the transition
			var ratio:Number = (getTimer() - _startTime) / _transition.onyx_ns::_duration;
			
			// get out!
			if (ratio > 1) {
				
				endTransition();
				return;
				
			}

			_transition.apply(ratio);

			// check bitmap transition			
			if (_transition is IBitmapTransition) {
				
				(_transition as IBitmapTransition).render(source, ratio);
				
			// otherwise just normal render
			} else {
				
				// render old content				
				_oldContent.render(source, null);

				// render the new content, but don't have it draw to our bitmap (with null)
				_newContent.render(null, null);
				
				// draw the new bitmap onto this bitmap
				source.draw(_newContent.rendered);

			}

			// copy pixels to our source
			_source.copyPixels(source, source.rect, POINT);

		}
		
		/**
		 * 	Return loaded content
		 */
		public function get loadedContent():Content {
			return _newContent;
		}
		
		/**
		 * 	Gets alpha
		 */
		override public function get alpha():Number {
			return _newContent.alpha;
		}

		/**
		 * 	Sets alpha
		 */
		override public function set alpha(value:Number):void {
			_newContent.alpha = value;
		}
		
		/**
		 * 	Tint
		 */
		override public function set tint(value:Number):void {
			_newContent.tint = value;
		}
		
		/**
		 * 	Sets color
		 */
		override public function set color(value:uint):void {
			_newContent.color = value;
		}

		/**
		 * 	Gets color
		 */
		override public function get color():uint {
			return _newContent.color;
		}

		/**
		 * 	Gets tint
		 */
		override public function get tint():Number {
			return _newContent.tint;
		}
		
		/**
		 * 	Sets x
		 */
		override public function set x(value:Number):void {
			_newContent.x = value;
		}

		/**
		 * 	Sets y
		 */
		override public function set y(value:Number):void {
			_newContent.y = value;
		}

		override public function set scaleX(value:Number):void {
			_newContent.scaleX = value;
		}

		override public function set scaleY(value:Number):void {
			_newContent.scaleY = value;
		}
		
		override public function get scaleX():Number {
			return _newContent.scaleX;
		}

		override public function get scaleY():Number {
			return _newContent.scaleY;
		}

		override public function get x():Number {
			return _newContent.x;
		}

		override public function get y():Number {
			return _newContent.y;
		}
		
		/**
		 * 	Gets saturation
		 */
		override public function get saturation():Number {
			return _newContent.saturation;
		}
		
		/**
		 * 	Sets saturation
		 */
		override public function set saturation(value:Number):void {
			_newContent.saturation = value;
		}

		/**
		 * 	Gets contrast
		 */
		override public function get contrast():Number {
			return _newContent.contrast;
		}

		/**
		 * 	Sets contrast
		 */
		override public function set contrast(value:Number):void {
			_newContent.contrast = value
		}

		/**
		 * 	Gets brightness
		 */
		override public function get brightness():Number {
			return _newContent.brightness;
		}
		
		/**
		 * 	Sets brightness
		 */
		override public function set brightness(value:Number):void {
			_newContent.brightness = value;
		}

		/**
		 * 	Gets threshold
		 */
		override public function get threshold():int {
			return _newContent.threshold;
		}
		
		/**
		 * 	Sets threshold
		 */
		override public function set threshold(value:int):void {
			_newContent.threshold = value;
		}
		
		/**
		 *	Returns rotation
		 */
		override public function get rotation():Number {
			return _newContent.rotation;
		}

		/**
		 *	@private
		 * 	Sets rotation
		 */
		override public function set rotation(value:Number):void {
			_newContent.rotation = value;
		}

		/**
		 * 	Adds a filter
		 */
		override public function addFilter(filter:Filter):void {
			_newContent.addFilter(filter);
		}

		/**
		 * 	Removes a filter
		 */		
		override public function removeFilter(filter:Filter):void {
			_newContent.removeFilter(filter);
		}

		/**
		 * 
		 */
		override public function set filters(value:Array):void {
			throw new Error('set filters overridden, use addFilter, removeFilter');
		}
		
		/**
		 * 	Returns filters
		 */
		override public function get filters():Array {
			return _newContent.filters;
		}
		
		/**
		 * 	Gets a filter's index
		 */
		override public function getFilterIndex(filter:Filter):int {
			return _newContent.getFilterIndex(filter);
		}
		
		/**
		 * 	Moves a filter to an index
		 */
		override public function moveFilter(filter:Filter, index:int):void {
			_newContent.moveFilter(filter, index);
		}
				
		/**
		 * 	Sets the time
		 */
		override public function set time(value:Number):void {
			_newContent.time = value;
		}
		
		/**
		 * 	Gets the time
		 */
		override public function get time():Number {
			return _newContent.time;
		}
		
		/**
		 * 	Gets the total time
		 */
		override public function get totalTime():int {
			return _newContent.totalTime;
		}
		
		/**
		 * 	Pauses content
		 */
		override public function pause(value:Boolean = true):void {
			_newContent.pause(value);
		}
				
		/**
		 * 	Gets the framerate
		 */
		override public function get framerate():Number {
			return _newContent.framerate;
		}

		/**
		 * 	Sets framerate
		 */
		override public function set framerate(value:Number):void {
			_newContent.framerate = value;
		}
		
		/**
		 * 	Gets the beginning loop point
		 */
		override public function get loopStart():Number {
			return _newContent.loopStart;
		}
		
		/**
		 * 	Sets the beginning loop point (percentage)
		 */		
		override public function set loopStart(value:Number):void {
			_newContent.loopStart = value;
		}
		
		/**
		 * 	Gets the beginning loop point
		 */
		override public function get loopEnd():Number {
			return _newContent.loopEnd;
		}

		/**
		 * 	Sets the end loop point
		 */
		override public function set loopEnd(value:Number):void {
			_newContent.loopEnd = value;
		}

		/**
		 * 	Returns the bitmap source
		 */
		override public function get source():BitmapData {
			return _newContent.source;
		}
		
		/**
		 * 	Sets blendmode
		 */
		override public function set blendMode(value:String):void {
			_newContent.blendMode = value;
		}
		
		/**
		 * 	Returns content controls
		 */
		override public function get controls():Controls {
			return _newContent.controls;
		}
		
		/**
		 * 
		 */
		override public function set matrix(value:Matrix):void {
			_newContent.matrix = value;
		}
		
		/**
		 * 
		 */
		override public function dispose():void {
			
			_newContent.removeEventListener(FilterEvent.FILTER_APPLIED,		_forwardEvents);
			_newContent.removeEventListener(FilterEvent.FILTER_MOVED,			_forwardEvents);
			_newContent.removeEventListener(FilterEvent.FILTER_REMOVED,		_forwardEvents);

			super.dispose();
			_oldContent.dispose();

			_oldContent = null;
			_newContent = null;
		}
		
		override public function get rendered():BitmapData {
			return _source;
		}

 	}
}