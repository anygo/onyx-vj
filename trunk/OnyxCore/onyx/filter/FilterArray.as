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
	import flash.geom.Rectangle;
	
	import onyx.constants.*;
	import onyx.content.IContent;
	import onyx.core.*;
	import onyx.events.*;
	import onyx.plugin.*;
	import onyx.tween.*;
	
	use namespace onyx_ns;
	
	
	dynamic public final class FilterArray extends Array {
		
		/**
		 * 	@constructor
		 */
		public function FilterArray():void {
		}
		
		/**
		 * 	Removes a filter
		 * 	@returns	true if the filter was added successfully
		 */
		public function addFilter(filter:Filter, content:IContent):void {

			// check for unique filters
			if (filter._unique) {
				
				var plugin:Plugin = Filter.getDefinition(filter.name);
				
				for each (var otherFilter:Filter in this) {
					if (otherFilter is plugin._definition) {
						return;
					}
				}
			}
			
			// it's alive!
			filter.setContent(content);
			
			// push the layer into the array
			super.push(filter);
			
			// tell the filter it has started
			filter.initialize();
			
			// dispatch
			var event:FilterEvent = new FilterEvent(FilterEvent.FILTER_APPLIED, filter)
			content.dispatchEvent(event);

		}
		
		/**
		 * 	Removes a filter
		 * 	@returns	true if the removed filter existed in the array
		 */
		public function removeFilter(filter:Filter, content:IContent):void {

			// now remove it
			var index:int = super.indexOf(filter);
			
			if (index >= 0) {
				
				// remove all tweens related to the filter
				// Tween.stopTweens(filter);

				// remove the filter
				splice(index, 1);

				// dispose the filter
				filter.dispose();
				
				// clean up our references
				filter.cleanContent();
				
				// dispatch
				var event:FilterEvent = new FilterEvent(FilterEvent.FILTER_REMOVED, filter)
				content.dispatchEvent(event);

			}
		}
		
		/**
		 * 
		 */
		public function clear(content:IContent):void {
			while (super.length) {
				removeFilter(this[0], content);
			}
		}
		
		/**
		 * 	Renders all filters to the source bitmap
		 */
		public function render(source:BitmapData):void {
			for each (var filter:Filter in this) {
				if (filter is IBitmapFilter) {
					(filter as IBitmapFilter).applyFilter(source);
				}
			}
		}
	}
}