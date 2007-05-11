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
	import flash.display.Stage;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import onyx.constants.*;
	import onyx.controls.*;
	import onyx.core.*;
	import onyx.plugin.*;

	/**
	 * 	Echo Filter
	 */
	public final class EchoFilter extends Filter implements IBitmapFilter {
		
		private var _source:BitmapData;
		
		private var _feedAlpha:ColorTransform	= new ColorTransform(1,1,1,.09);
		private var _mixAlpha:ColorTransform	= new ColorTransform(1,1,1,0);
		
		public var feedBlend:String				= 'normal';
		public var mixBlend:String				= 'normal';
		public var scrollX:int					= 0;
		public var scrollY:int					= 0;
		public var delay:int					= 1;
		private var _count:int					= 0;
		
		public function EchoFilter():void {

			super(
				false,
				new ControlNumber('feedAlpha', 'Echo Alpha', 0, 1, .09),
				new ControlRange('feedBlend', 'Echo Blend', BLEND_MODES, 9),
				new ControlNumber('mixAlpha', 'Mix Alpha', 0, 1, .02),
				new ControlRange('mixBlend', 'Mix Blend', BLEND_MODES, 0),
				new ControlProxy(
					'scroll', 'scroll',
					new ControlInt('scrollX', 'scroll X', -10, 10, 0),
					new ControlInt('scrollY', 'scroll Y', -10, 10, 0)
				),
				new ControlInt('delay', 'Frame Delay', 1, 10, 2)
			);
		}
		
		override public function initialize():void {
			_source		= content.source.clone();
		}
		
		public function set feedAlpha(value:Number):void {
			_feedAlpha.alphaMultiplier = value;
		}
		
		public function get feedAlpha():Number {
			return _feedAlpha.alphaMultiplier;
		}
		
		public function set mixAlpha(value:Number):void {
			_mixAlpha.alphaMultiplier = value;
		}
		
		public function get mixAlpha():Number {
			return _mixAlpha.alphaMultiplier;
		}
		
		public function applyFilter(bitmapData:BitmapData):void {
			
			_count = (_count + 1) % delay;
			
			if (_count == 0) {
				
				if (_feedAlpha.alphaMultiplier > 0) {
					
					// draw to our stored bitmap
					_source.draw(bitmapData, null, _feedAlpha, feedBlend);
	
				}
				
				if (_mixAlpha.alphaMultiplier > 0) {

					// draw the original bitmap
					_source.draw(bitmapData, null, _mixAlpha, mixBlend);
				}
				
			}

			// check for scroll
			if (scrollX != 0 || scrollY != 0) {
				_source.scroll(scrollX, scrollY);
			}		
	
			// copy the pixels back to the original bitmap
			bitmapData.copyPixels(_source, BITMAP_RECT, POINT);
		}
		
		override public function dispose():void {
			if (_source) {
				_source.dispose();
				_source = null;
			}
			
			_feedAlpha = null;
			_mixAlpha = null;
			
			super.dispose();
		}
	}
}