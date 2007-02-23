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
package onyx.core {

	import flash.display.*;
	import flash.geom.*;
	import flash.utils.*;
	
	import onyx.constants.*;
	import onyx.content.ColorFilter;
	import onyx.filter.FilterArray;
	
	/**
	 * 	This class stores the last rendering time for a given target
	 */
	public final class RenderManager {
		
		/**
		 * 	@private
		 */
		private static var _dict:Dictionary = new Dictionary(true);
		
		/**
		 * 
		 */
		public static function getTime(target:Object):int {
			
			var time:int	= _dict[target];
			var now:int		= getTimer();
			_dict[target]	= now;
			
			return (now - time) / STAGE.frameRate;
		}
		
		/**
		 * 	
		 */
		public static function renderContent(source:BitmapData, content:IBitmapDrawable, transform:RenderTransform, filter:ColorFilter):void {
			
			var matrix:Matrix = transform.matrix;
			var rect:Rectangle = transform.rect;
			
			// fill our source with nothing
			source.fillRect(source.rect, 0x00000000);
			
			// draw our content
			source.draw(content, matrix, filter, null, rect);

			// apply the color filter to the source
			source.applyFilter(source, source.rect, POINT, filter.filter);
			
		}
		
		/**
		 * 
		 */
		public static function renderFilters(source:BitmapData, rendered:BitmapData, filters:FilterArray):void {
			
			// copy to the rendered bitmap
			rendered.copyPixels(source, source.rect, POINT);
			
			// render filters
			filters.render(source);
			
			// copy pixels to the rendered bitmap
			rendered.copyPixels(source, source.rect, POINT);

		}
	}
}