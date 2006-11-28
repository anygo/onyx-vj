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
	
	import onyx.filter.Filter;
	import onyx.layer.IColorObject;
	import onyx.layer.IContent;
	import flash.geom.Rectangle;
	import onyx.layer.Layer;
	import flash.display.Sprite;

	[ExcludeClass]
	public final class ContentNull implements IContent, IColorObject
	{
		
		private var _layer:Layer;
		private var _loader:Sprite;
		
		include 'ContentShared.as'
		
		public function get totalTime():Number
		{
			return 0;
		}
		
		public function set timePercent(value:Number):void {
		}
		
		public function get timePercent():Number
		{
			return 0;
		}
		
		public function get time():Number
		{
			return 0;
		}
		
		public function set time(value:Number):void
		{
		}
		
		public function get framerate():Number
		{
			return 0;
		}
		
		public function set framerate(value:Number):void
		{
		}
		
		public function get framernd():Number
		{
			return 0;
		}
		
		public function set framernd(value:Number):void
		{
		}
		public function get markerRight():Number
		{
			return 0;
		}
		
		public function set markerRight(value:Number):void
		{
		}
		
		public function pause(b:Boolean=true):void
		{
		}
		
		public function get path():String
		{
			return null;
		}
		
		public function set markerLeft(value:Number):void
		{
		}
		
		public function get markerLeft():Number
		{
			return 0;
		}
		
		public function dispose():void
		{
		}
		public function get blendMode():String
		{
			return null;
		}
		
		public function set blendMode(value:String):void
		{
		}
		
	}
}