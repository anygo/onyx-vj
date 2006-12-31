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
package onyx.display {
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	
	import onyx.application.Onyx;
	import onyx.controls.*;
	import onyx.core.onyx_internal;
	import onyx.events.ApplicationEvent;
	import onyx.events.LayerEvent;
	import onyx.layer.Layer;
	import onyx.layer.LayerProperties;
	import onyx.layer.LayerSettings;
	import onyx.transition.*;
	
	use namespace onyx_internal;
	
	/**
	 * 	
	 */
	public class Display extends Sprite {
		
		// Background
		private var _background:Background		= new Background(320, 240, 0x000000);
		
		// add the controls that we can bind to
		private const _controls:Controls = new Controls(this,
			new ControlInt('x', 'x', 0, 2000, 0),
			new ControlInt('y', 'y', 0, 2000, 0),
			new ControlNumber('scaleX', 'scaleX', 0, 4, 0),
			new ControlNumber('scaleY', 'scaleY', 0, 4, 0)
		);
		
		onyx_internal var _layers:Array		= [];
		onyx_internal var _index:int;
		
		public function Display():void {
			
			addChild(_background);

		}
		
		/**
		 * 	Returns the number of layers
		 */
		public function get numLayers():int {
			return _layers.length;
		}
		
		/**
		 * 	Creates a specified number of layers
		 */
		public function createLayers(numLayers:uint):void {
			
			while (numLayers-- ) {
				
				// create a new layer and set it's index
				var layer:Layer = new Layer();
				layer.onyx_internal::_index = _layers.push(layer) - 1;
				
				// listen for move events, etc
				layer.addEventListener(LayerEvent.LAYER_MOVE_DOWN,	_onLayerMoveDown);
				layer.addEventListener(LayerEvent.LAYER_MOVE_UP,	_onLayerMoveUp);
				layer.addEventListener(LayerEvent.LAYER_COPY_LAYER,	_onLayerCopy);
				
				// add the layer to this display object
				addChildAt(layer, 1);
				
				// dispatch
				var event:LayerEvent = new LayerEvent(LayerEvent.LAYER_CREATED, layer);
				
				// dispatch a layer create event
				Onyx.dispatcher.dispatchEvent(event);
			}
		}
		
		/**
		 * 	When a layer is moved down
		 */
		private function _onLayerMoveDown(event:LayerEvent):void {
			var layer:Layer = event.layer;
			if (layer._index < _layers.length - 1) {
				moveLayer(layer, layer.index + 1);
			}
		}
		
		/**
		 * 	When a layer is moved up
		 */
		private function _onLayerMoveUp(event:LayerEvent):void {
			var layer:Layer = event.layer;
			if (layer._index > 0) {
				moveLayer(layer, layer.index - 1);
			}
		}
		
		/**
		 * 	Copies a layer
		 */
		private function _onLayerCopy(event:LayerEvent):void {
			copyLayer(event.layer, event.layer.index + 1);
		}
		
		/**
		 * 	Returns the layers
		 */
		public function get layers():Array {
			return _layers.concat();
		}
		
		/**
		 * 	Moves a layer to a specified index
		 */
		public function moveLayer(layer:Layer, index:int):void {
			
			var fromIndex:int = layer.index;
			var toLayer:Layer = _layers[index];
			
			var numLayers:int = _layers.length;
			
			var fromChildIndex:int = getChildIndex(layer);
			var toChildIndex:int = getChildIndex(toLayer);
			
			setChildIndex(layer, toChildIndex);
			setChildIndex(toLayer, fromChildIndex);
			
			_layers[fromIndex] = toLayer;
			_layers[index] = layer;
			
			toLayer._index = fromIndex;
			layer._index = index;
			
			layer.dispatchEvent(new LayerEvent(LayerEvent.LAYER_MOVE, layer));
			toLayer.dispatchEvent(new LayerEvent(LayerEvent.LAYER_MOVE, toLayer));
		}
		
		/**
		 * 	Gets the display index
		 */
		public function get index():int {
			return _index;
		}
		
		/**
		 * 	Gets the controls related to the display
		 */
		public function get controls():Controls {
			return _controls;
		}
		
		/**
		 * 	Copies a layer
		 */
		public function copyLayer(layer:Layer, index:int):void {
			
			var layerindex:int = layer.index;
			var copylayer:Layer = _layers[index];
			
			if (copylayer) {
				
				var settings:LayerSettings = new LayerSettings(layer);
				copylayer.load(new URLRequest(layer.path), settings);
				
			}
		}
		
		/**
		 * 	Gets the index of a layer
		 */
		public function getIndex(layer:Layer):int {
			return _layers.indexOf(layer);
		}
		

	}
}


/****
 * 
 * 		HELPER CLASS FOR BACKGROUND
 * 
 ****/

import flash.display.Sprite;

final class Background extends Sprite {
	
	public function Background(width:int, height:int, color:int):void {
		
		graphics.beginFill(color);
		graphics.drawRect(0,0,width,height);
		graphics.endFill();
		cacheAsBitmap = true;
		
	}
}