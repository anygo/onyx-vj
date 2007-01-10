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
package onyx.transition {
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.EventDispatcher;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	
	import onyx.content.IContent;
	import onyx.core.getBaseBitmap;
	import onyx.core.onyx_ns;
	import onyx.events.TransitionEvent;
	import onyx.layer.ILayer;
	import onyx.core.IDisposable;
	
	use namespace onyx_ns;
	
	/**
	 * 	Transition
	 */
	public class Transition extends EventDispatcher implements IDisposable {
		
		/** @private **/
		onyx_ns var _duration:int;

		/** @private **/
		private var _startTime:int;

		/** @private **/
		onyx_ns var oldContent:IContent;

		/** @private **/
		onyx_ns var newContent:IContent;
		
		/** 
		 * 	@private
		 * 	stores name of the transition
		 */
		public var name:String;
		
		/**
		 * 	@private
		 * 	Stores layer
		 */
		private var _layer:ILayer;
		
		/**
		 * 	@constructor
		 */
		public function Transition(name:String, duration:int = 2000):void {
			this.name = name;
			_duration = duration;
		}
		
		/**
		 * 	@private
		 */
		onyx_ns final function initializeTransition(oldContent:IContent, newContent:IContent, layer:ILayer):void {
			
			_layer = layer;
			
			this.oldContent = oldContent;
			this.newContent = newContent;
			
			_startTime = getTimer();

			// initialize();
		}
		
		/**
		 * 	@private
		 */
		onyx_ns final function calculateTransition(bitmapData:BitmapData):void {

			var time:Number = (getTimer() - _startTime) / _duration;

			// first draw the new content
			// var oldbmp:BitmapData = oldContent.draw();
			// bitmapData.copyPixels(oldbmp, oldbmp.rect, new Point(0,0));
			
			// apply transition
			// applyTransition(bitmapData, newContent.draw(), Math.min(time,1));
			
			if (time >= 1) {
				dispose();
			}
		}

		public function initialize():void {
		}
		
		public function applyTransition(oldContent:BitmapData, newContent:BitmapData, time:Number):void {
		}

		/**
		 * 	Sets duration
		 */		
		final public function set duration(value:int):void {
			_duration = value;
		}
		
		/**
		 * 	Gets duration
		 */
		final public function get duration():int {
			return _duration;
		}
		
		/**
		 * 	Destroys
		 */
		public function dispose():void {
			
			// dispatch an end transition event
			var event:TransitionEvent = new TransitionEvent(TransitionEvent.TRANSITION_END)
			event.transition = this;
			
			dispatchEvent(event);
			
			this.oldContent	= null;
			this.newContent	= null;
			_layer			= null;
		}

	}
}