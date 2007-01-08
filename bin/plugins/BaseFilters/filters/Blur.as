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
	import flash.filters.BlurFilter;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import onyx.controls.ControlInt;
	import onyx.controls.Controls;
	import onyx.core.onyx_internal;
	import onyx.filter.Filter;
	import onyx.filter.IBitmapFilter;
	
	use namespace onyx_internal;

	public final class Blur extends Filter implements IBitmapFilter {
		
		private var _filter:flash.filters.BlurFilter	= new flash.filters.BlurFilter();
		private var _blur:int;
		private var _quality:int;
		
		public function Blur():void {

			super('Blur');
			
			_controls.addControl(
				new ControlInt('blurX', 'blurX', 0, 42, 2),
				new ControlInt('blurY', 'blurY', 0, 42, 2)
			);
		}
		
		public function applyFilter(bitmapData:BitmapData, bounds:Rectangle):BitmapData {
			bitmapData.applyFilter(bitmapData, bitmapData.rect, new Point(0,0), _filter);
			return bitmapData;
		}
		
		public function terminate():void {
			_filter = null;
		}
		
		public function set blurX(x:int):void {
			_filter.blurX = x;
		}
		
		public function get blurX():int {
			return _filter.blurX;
		}
		
		public function set blurY(Y:int):void {
			_filter.blurY = Y;
		}
		
		public function get blurY():int {
			return _filter.blurY;
		}
		
		public function set quality(q:int):void {
			_filter.quality = q + 1;
		}
		
		public function get blur():int {
			return (_filter.blurX + _filter.blurY) / 2;
		}
		
		public function set blur(b:int):void {
			
			_filter.blurX = b;
			_filter.blurY = b;
		}

		public function get quality():int {
			return _filter.quality;
		}
	}
}