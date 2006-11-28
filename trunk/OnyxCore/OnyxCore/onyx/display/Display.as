package onyx.display {
	
	import flash.geom.Rectangle;
	
	import onyx.application.Onyx;
	import onyx.controls.*;
	import onyx.core.onyx_internal;
	import onyx.events.LayerEvent;
	import onyx.events.OnyxEvent;
	import onyx.layer.Layer;
	import onyx.layer.LayerProperties;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import onyx.layer.LayerSettings;
	import flash.display.Sprite;
	import flash.net.URLRequest;
	import onyx.transition.*;
	
	use namespace onyx_internal;
	
	public class Display extends Sprite {
		
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
		
		public function get length():int {
			return _layers.length;
		}
		
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
				
				Onyx.dispatcher.dispatchEvent(event);
			}
		}
		
		private function _onLayerMoveDown(event:LayerEvent):void {
			var layer:Layer = event.layer;
			if (layer._index < _layers.length - 1) {
				moveLayer(layer, layer.index + 1);
			}
		}
		
		private function _onLayerMoveUp(event:LayerEvent):void {
			var layer:Layer = event.layer;
			if (layer._index > 0) {
				moveLayer(layer, layer.index - 1);
			}
		}
		
		private function _onLayerCopy(event:LayerEvent):void {
			copyLayer(event.layer, event.layer.index + 1);
		}
		
		public function get layers():Array {
			return _layers.concat();
		}
		
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
		
		public function get index():int {
			return _index;
		}
		
		public function get controls():Controls {
			return _controls;
		}
		
		public function copyLayer(layer:Layer, index:int):void {
			
			var layerindex:int = layer.index;
			var copylayer:Layer = _layers[index];
			
			if (copylayer) {
				
				var settings:LayerSettings = new LayerSettings(layer);
				copylayer.load(new URLRequest(layer.path), settings);
				
			}
		}
		
		
		public function getIndex(layer:Layer):int {
			return _layers.indexOf(layer);
		}
		

	}
}


/****
 * 
 * 		HELPER CLASS
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