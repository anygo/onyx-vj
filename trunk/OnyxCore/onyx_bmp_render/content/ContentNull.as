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
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.geom.Transform;
	import flash.utils.getTimer;
	
	import onyx.controls.Controls;
	import onyx.core.IDisposable;
	import onyx.core.IRenderable;
	import onyx.core.onyx_ns;
	import onyx.events.FilterEvent;
	import onyx.filter.ColorFilter;
	import onyx.filter.Filter;
	import onyx.filter.IBitmapFilter;
	import onyx.layer.IColorObject;
	import onyx.layer.Layer;
		
	[ExcludeClass]
	public final class ContentNull extends EventDispatcher implements IRenderable {

		public function get transform():Transform {
			return new Transform(null);
		}

		public function get totalTime():int
		{
			return 1;
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
		public function get loopEnd():Number
		{
			return 0;
		}
		
		public function set loopEnd(value:Number):void
		{
		}
		
		public function pause(b:Boolean=true):void
		{
		}
		
		public function set loopStart(value:Number):void
		{
		}
		
		public function get loopStart():Number
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
		
		public function set blendMode(value:String):void {
		}
		
		public function set tint(value:Number):void {		
		}
		
		public function set color(value:uint):void {
		}

		
		public function set alpha(value:Number):void {
		}
		
		/**
		 * 	Gets color
		 */
		public function get color():uint {
			return 0;
		}

		/**
		 * 	Gets tint
		 */
		public function get tint():Number {
			return 0;
		}
		
		/**
		 * 	Sets x
		 */
		public function set x(value:Number):void {
		}

		/**
		 * 	Sets y
		 */
		public function set y(value:Number):void {
		}

		public function set scaleX(value:Number):void {
		}

		public function set scaleY(value:Number):void {
		}
		
		public function get scaleX():Number {
			return 1;
		}

		public function get scaleY():Number {
			return 1;
		}

		public function get x():Number {
			return 0;
		}

		public function get y():Number {
			return 0;
		}
		
		public function get alpha():Number {
			return 1;
		}
		
		public function get rotation():Number {
			return 0;
		}

		public function set rotation(value:Number):void {
		}
		
		public function get saturation():Number {
			return 1;
		}
		
		public function set saturation(value:Number):void {
		}

		public function get contrast():Number {
			return 0;
		}

		public function set contrast(value:Number):void {
		}

		public function get brightness():Number {
			return 0;
		}
		
		public function set brightness(value:Number):void {
		}

		public function get threshold():int {
			return 0;
		}
		
		public function set threshold(value:int):void {
		}

		public function addFilter(filter:Filter):void {
		}
		
		public function removeFilter(filter:Filter):void {
		}
		
		public function get filters():Array {
			return [];
		}
		
		public function get bitmapData():BitmapData {
			return null;
		}
		
		public function get source():BitmapData {
			return null;
		}
		
		/**
		 * 	Gets a filter's index
		 */
		public function getFilterIndex(filter:Filter):int {
			return -1;
		}
		
		/**
		 * 
		 */
		public function moveFilter(filter:Filter, index:int):void {
		}
		
		/**
		 * 
		 */
		public function get customControls():Controls {
			return null;
		}
		
		public function get controls():Controls {
			return null;
		}
		
		public function get previousRender():BitmapData {
			return null;
		}
		
		public function set matrix(value:Matrix):void {
		}
		
		public function render(bitmapData:BitmapData):void {
		}
			
	}
}