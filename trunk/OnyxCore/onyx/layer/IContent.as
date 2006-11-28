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
	
	import flash.display.BitmapData;
	import flash.display.IBitmapDrawable;
	import flash.events.IEventDispatcher;
	import flash.geom.Matrix;
	
	import onyx.core.IDisposable;
	import onyx.filter.Filter;
	import flash.geom.Rectangle;
	import onyx.layer.ILayer;
	import flash.display.DisplayObject;
	
	public interface IContent extends IColorObject, IDisposable {
		
		function get time():Number;
		function set time(value:Number):void;

		function get totalTime():Number;

		function get framerate():Number;
		function set framerate(value:Number):void;
		
		function get framernd():Number;
		function set framernd(value:Number):void;
		
		function get markerLeft():Number;
		function set markerLeft(value:Number):void;

		function get markerRight():Number;
		function set markerRight(value:Number):void;
		
		function get path():String;
		
		function get timePercent():Number;
		function get filters():Array;
		
		function get source():BitmapData;
		function get rendered():BitmapData;
		
		function addFilter(filter:Filter):void;
		function removeFilter(filter:Filter):void;

		function draw():BitmapData;
		
		function applyFilters(render:BitmapData):void;
		
		function pause(b:Boolean = true):void;
		function getFilterIndex(filter:Filter):int;
		
		function moveFilterUp(filter:Filter):void;
		function moveFilterDown(filter:Filter):void;

	}
}