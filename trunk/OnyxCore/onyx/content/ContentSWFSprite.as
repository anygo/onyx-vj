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
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.geom.Matrix;
	
	import onyx.application.Onyx;
	import onyx.core.IDisposable;
	import onyx.core.onyx_internal;
	import onyx.layer.IContent;
	import onyx.layer.Layer;
	import onyx.layer.IStageAllowable;
	
	use namespace onyx_internal;
	
	[ExcludeClass]
	public final class ContentSWFSprite implements IContent {
		
		private var _loader:Loader;
		private var _child:Sprite;
		private var _layer:Layer;
		
		public function ContentSWFSprite(loader:Loader, layer:Layer):void {
			
			_layer = layer;
			_loader = loader;
			_child	= loader.content as Sprite;
			_filters = [];
			
			if (_child is IStageAllowable) {
				(_child as IStageAllowable).stage = Onyx.root;
			}
			
			_scaleX = 320 / loader.contentLoaderInfo.width;
			_scaleY = 240 / loader.contentLoaderInfo.height;

		}
		
		public function set time(value:Number):void {
		}
		
		public function get time():Number {
			return 0;
		}
		
		public function get totalTime():Number {
			return 1;
		}
		
		public function pause(b:Boolean = true):void {
		}
		
		public function isPaused():Boolean {
			return false;
		}
		
		
		public function get framerate():Number {
			return 1;
		}

		public function set framerate(value:Number):void {
		}

		public function get framernd():Number {
			return 0;
		}
		
		public function set framernd(value:Number):void {
		}

		public function get markerLeft():Number {
			return 0;
		}
		
		public function set markerLeft(value:Number):void {
		}
		
		public function get markerRight():Number {
			return 1;
		}
		
		public function set markerRight(value:Number):void {
		}
		
		public function get path():String {
			return _loader.contentLoaderInfo.url;
		}
		
		public function get timePercent():Number {
			return 0;
		}

		public function dispose():void {
						
			if (_child is IDisposable) {
				(_child as IDisposable).dispose();
			}

			_loader.unload();
			
			clearFilters();
			
			_loader = null;
			_child = null;
			_layer = null;
			_filter = null;
			_matrix = null;
			_filters = null;
			
			_source.dispose();
			_source = null;

		}
		
		public function toString():String {
			return '[SWFSprite:', path, ']';
		}

		include "ContentShared.as"		

	}
}