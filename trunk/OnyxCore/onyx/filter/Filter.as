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
package onyx.filter {
	
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.describeType;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	import onyx.controls.Controls;
	import onyx.controls.IControlObject;
	import onyx.core.onyx_internal;
	import onyx.events.FilterEvent;
	import onyx.layer.IColorObject;
	import onyx.layer.IContent;
	import onyx.controls.Controls;
	
	use namespace onyx_internal;
	
	/**
	 * 	The base Filter class
	 */
	public class Filter extends EventDispatcher {

		// this sets the name of the filter
		private var _name:String;
		
		// stores the layer
		protected var content:IContent;
		
		// create controls
		protected var _controls:Controls	= new Controls(this);
		
		// constructor
		final public function Filter(name:String):void {
			_name = name;
		}
		
		final public function get name():String {
			return _name;
		}
		
		// gets the current position of the filter within the layer
		final public function get index():int {
			return content.getFilterIndex(this);
		}

		// called by layer when a filter is added to it
		onyx_internal function setContent(content:IContent):void {
			this.content = content;
		}
		
		final public function get controls():Controls {
			return _controls;
		}
		
		public function initialize():void {
		}
		
		public function clone():Filter {
			return null;
		}
		
		final public function moveUp():void {
//			var event:FilterEvent = new FilterEvent(FilterEvent.FILTER_MOVE_UP, this)
//			dispatchEvent(event);

			content.moveFilterUp(this);
//			content.moveFilter(this, true);
		}
		
		final public function moveDown():void {
//			var event:FilterEvent = new FilterEvent(FilterEvent.FILTER_MOVE_DOWN, this)
//			dispatchEvent(event);
			// content.moveFilter(this, false);
			content.moveFilterDown(this);
		}
		
		public function dispose():void {
			_controls.dispose();
			_controls = null;
		}
	}
}