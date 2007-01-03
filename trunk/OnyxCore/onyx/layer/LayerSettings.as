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
	
	import flash.events.EventDispatcher;
	
	import onyx.controls.Controls;
	import onyx.core.onyx_internal;
	import onyx.filter.Filter;
	
	use namespace onyx_internal;

	/**
	 * 	This class stores settings that can be applied to layers
	 */
	public class LayerSettings extends EventDispatcher {

		public var x:Number;
		public var y:Number;
		public var scaleX:Number;
		public var scaleY:Number;
		public var rotation:Number;

		public var alpha:Number;
		public var brightness:Number;
		public var contrast:Number;
		public var saturation:Number;
		public var hue:Number;
		public var tint:Number;
		public var color:uint;
		public var threshold:Number;
		public var blendMode:String;
		
		public var time:Number;
		public var framerate:Number;
		public var framernd:Number;

		public var filters:Array;
		public var loopStart:Number;
		public var loopEnd:Number;
		
		/**
		 * 	@constructor
		 */
		public function LayerSettings(layer:Layer = null):void {
			
			if (layer) {
				
				x			= layer.x;
				y			= layer.y;
				scaleX		= layer.scaleX;
				scaleY		= layer.scaleY;
				rotation	= layer.rotation;
				
				alpha		= layer.alpha;
				brightness	= layer.brightness;
				contrast	= layer.contrast;
				saturation	= layer.saturation;
				color		= layer.color;
				tint		= layer.tint;
				threshold	= layer.threshold;
				blendMode	= layer.blendMode;
				
				time		= layer.time;
				framerate	= layer.framerate;

				loopStart	= layer.loopStart;
				loopEnd	= layer.loopEnd;
				
				filters		= layer.filters.concat();
				
			}

		}
		
		/**
		 * 	Loads settings info from xml
		 */
		public function loadFromXML(xml:XML):void {
		}
		
		/**
		 * 	Applies values to a layer
		 */
		public function apply(layer:Layer):void {
			
			layer.x = x;
			layer.y = y;
			layer.scaleX = scaleX;
			layer.scaleY = scaleY;
			layer.rotation = rotation;
			
			layer.alpha = alpha;
			layer.brightness = brightness;
			layer.contrast = contrast;
			layer.saturation = saturation;
			layer.color = color;
			layer.tint = tint;
			layer.threshold = threshold;
			layer.blendMode = blendMode;
			
			layer.time = time;
			layer.framerate = layer.framerate;
			layer.loopStart = layer.loopStart;
			layer.loopEnd = layer.loopEnd;
			
			for each (var filter:Filter in filters) {
				layer.addFilter(filter.clone());
			}
		}
	}
}