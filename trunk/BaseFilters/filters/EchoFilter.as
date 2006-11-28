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
package filters {
	
	import flash.display.BitmapData;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import onyx.core.getBaseBitmap;
	import onyx.filter.Filter;
	import onyx.filter.IBitmapFilter;
	
	public final class EchoFilter extends Filter implements IBitmapFilter {
		
		private var _bmp:BitmapData = getBaseBitmap();
		
		public function EchoFilter():void {
			super('Echo Filter');
		}
		
		override public function initialize():void {
			var source:BitmapData = content.source;
			_bmp.copyPixels(source, source.rect, new Point(0,0));
		}
		
		public function applyFilter(bitmapData:BitmapData, bounds:Rectangle):BitmapData {
			
			var transform:ColorTransform = new ColorTransform();
			transform.alphaMultiplier = .09;
			
			_bmp.draw(bitmapData, null, transform);
			
			bitmapData.copyPixels(_bmp, bitmapData.rect, new Point(bounds.x,bounds.y));
			
			return _bmp;
		}
		
		override public function clone():Filter {
			return new EchoFilter();
		}
		
		override public function dispose():void {
			_bmp.dispose();
			super.dispose();
		}
	}
}