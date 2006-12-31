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
package ui.layer {
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	import flash.events.TimerEvent;
	import flash.filters.DropShadowFilter;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.net.URLRequest;
	import flash.utils.Timer;
	
	import onyx.application.Onyx;
	import onyx.controls.Controls;
	import onyx.events.ControlEvent;
	import onyx.events.FilterEvent;
	import onyx.events.LayerEvent;
	import onyx.filter.Filter;
	import onyx.layer.Layer;
	
	import ui.assets.*;
	import ui.controls.*;
	import ui.controls.filter.LayerFilter;
	import ui.controls.layer.*;
	import ui.core.UIObject;
	import ui.text.Style;
	import ui.text.TextField;
	
	public class UILayer extends UIObject {
		
		/**
		 * 	STATIC MEMBERS
		 **/

		public static const LAYER_X:int				= 6;
		public static const LAYER_Y:int				= 6;
		public static const LAYER_SCRUB_LEFT:int	= 3;
		public static const LAYER_SCRUB_RIGHT:int	= 176;
		public static const LAYER_WIDTH:int			= LAYER_SCRUB_RIGHT - LAYER_SCRUB_LEFT;

		private static var _layers:Array			= [];

		// an index of all the layers
		public static function get layers():Array {
			return _layers;
		}
		
		public static function getLayerAt(index:int):UILayer {
			return _layers[index];
		}

		/**
		 * 	@method		Selects a layer
		 */
		public static function selectLayer(uilayer:UILayer):void {
			
			if (selectedLayer) {
				selectedLayer._timer.delay = 2000;
				selectedLayer.highlight(0,0);
			}
			
			// make the delay slower
			uilayer._timer.delay = 100;
			uilayer.highlight(0xCCCCCC, .09);
			
			selectedLayer = uilayer;
			
			uilayer.moveToTop();
		}
		
		/**
		 *	@property	The currently selected layer 
		 */
		public static var selectedLayer:UILayer;

		/********************************************************
		 * 
		 * 					CLASS MEMBERS
		 * 
		 **********************************************************/

		private var _layer:Layer;
		private var _index:int;
		private var _monitor:Boolean				= false;

		private var _btnUp:ButtonClear				= new ButtonClear(10, 10);
		private var _btnDown:ButtonClear			= new ButtonClear(10, 10);
		private var _btnCopy:ButtonClear			= new ButtonClear(10, 10);
		private var _btnDelete:ButtonClear			= new ButtonClear(10, 10);
		
		private var _loopStart:LoopStart;
		private var _loopEnd:LoopEnd;
		
		private var _assetLayer:AssetLayer			= new AssetLayer();
		private var _assetScrub:ScrubArrow 			= new ScrubArrow();
		private var _btnScrub:ButtonClear			= new ButtonClear(192, 9, false);
		private var _timer:Timer					= new Timer(2000);
		private var _preview:Bitmap					= new Bitmap(new BitmapData(192, 144, true, 0x00000000));
		private var _filename:TextField				= new TextField(162,16);
		
		private var _filters:ScrollPane				= new ScrollPane(100,110);

		private var _selectedFilter:LayerFilter;
		private var _selectedFilterWindow:UIFilterSelection;

		/**
		 * 	@constructor
		 **/

		public function UILayer(layer:Layer):void {
			
			if (!selectedLayer) {
				selectLayer(this);
			}
			
			_layer = layer;

			_layers.push(this);
			
			_draw();
			
			_assignHandlers();
			
		}
		
		/**
		 * 	@method		Highlights a layer with a particular color
		 *	@param		The color to tint
		 * 	@param		The amount to tint by
		 */
		override public function highlight(color:uint, amount:Number):void {
			
			var transform:ColorTransform = new ColorTransform();
			
			var r:int = ((color & 0xFF0000) >> 16) * amount;
			var g:int = ((color & 0x00FF00) >> 8) * amount;
			var b:int = ((color & 0x0000FF)) * amount;
			
			var newcolor:int = r << 16 ^ g << 8 ^ b;
			
			transform.color = newcolor;
			transform.redMultiplier = 1-amount;
			transform.greenMultiplier = 1-amount;
			transform.blueMultiplier = 1-amount;
			
			_assetLayer.transform.colorTransform = transform;
			
		}
		
		// assign handlers
		private function _assignHandlers():void {
			
			// add layer event handlers
			_layer.addEventListener(LayerEvent.LAYER_LOADED, _onLayerLoad);
			_layer.addEventListener(LayerEvent.LAYER_UNLOADED, _onLayerUnLoad);
			
			// when a filter is applied
			_layer.addEventListener(FilterEvent.FILTER_APPLIED, _onFilterApplied);
			_layer.addEventListener(FilterEvent.FILTER_REMOVED, _onFilterRemoved);
			_layer.addEventListener(FilterEvent.FILTER_MOVED, _onFilterMove);
			_layer.addEventListener(ProgressEvent.PROGRESS, _onLayerProgress);
			
			// when the scrub button is pressed
			_btnScrub.addEventListener(MouseEvent.MOUSE_DOWN, _onScrubPress);
			
			// this listens for selecting the layer
			addEventListener(MouseEvent.MOUSE_DOWN, _onMouseDown);

			// buttons
			_btnUp.addEventListener(MouseEvent.MOUSE_DOWN, _onButtonPress);
			_btnDown.addEventListener(MouseEvent.MOUSE_DOWN, _onButtonPress);
			_btnCopy.addEventListener(MouseEvent.MOUSE_DOWN, _onButtonPress);
			_btnDelete.addEventListener(MouseEvent.MOUSE_DOWN, _onButtonPress);

			// when the layer is moved
			_layer.addEventListener(LayerEvent.LAYER_MOVE, moveLayer);

		}
		
		/**
		 * 
		 */
		private function _onLayerProgress(event:ProgressEvent):void {
			_filename.text = 'LOADING ' + Math.floor(event.bytesLoaded / event.bytesTotal * 100) + '% (' + Math.floor(event.bytesTotal / 1024) + ' kb)';
		}
		
		/**
		 * 	@private
		 */
		private function _onButtonPress(event:MouseEvent):void {
			
			switch (event.target) {
				case _btnUp:
					trace('up');
					_layer.moveUp();
					break;
				case _btnDown:
					trace('down');
					_layer.moveDown();
					break;
				case _btnCopy:
					_layer.copyLayer();
					break;
				case _btnDelete:
					_layer.unload();
					break;
					
			}
		}
		
		private function _draw():void {
			
			// make the filename text have a drop shadow
			_filename.filters = [new DropShadowFilter(1, 45,0x000000, 1, 0, 0, 1)];
			_filename.cacheAsBitmap = true;
			
			// create a temp var
			var controls:Controls = _layer.controls;
			
			_loopStart = new LoopStart(controls.loopStart);
			_loopEnd = new LoopEnd(controls.loopEnd);
			
			addChildren(
			
				_assetLayer,												0,			0,
				_preview,													1,			1,
				_filename,													3,			3,

				new SliderV2(controls.y, controls.x, false),				7,			181,
				new SliderV2(controls.scaleY, controls.scaleX, true, 100),	7,			200,
				new SliderV(controls.rotation),								7,			219,
				new SliderV(controls.tint,100),								7,			238,
				new ColorPicker(controls.color),							7,			257,
				
				new SliderV(controls.alpha,100),							47,			181,
				new SliderV(controls.brightness,100),						47,			200,
				new SliderV(controls.contrast,100),							47,			219,
				new SliderV(controls.saturation,100),						47,			238,

				new SliderV(controls.threshold,1),							47,			257,

				new SliderV(controls.framerate,10,.1),						47,			276,

				new DropDown(controls.blendMode, false, 124, 12, 'left'),	4,			154,
				
				_assetScrub,								LAYER_SCRUB_LEFT,			141,
				_btnScrub,													1,			135,
				_filters,													96,			172,

				_loopStart,												10,			138,
				_loopEnd,												184,		138,
				
				_btnUp,														153,		154,
				_btnDown,													162,		154,
				_btnCopy,													171,		154,
				_btnDelete,													180,		154
		
			);
			
		}
		
		/**
		 * 	@method		Loads a layer
		 */
		public function load(path:String):void {
			_layer.load(new URLRequest(path));
		}
		
		/**
		 * 	Handler that is evoked when a layer has finished loading a file
		 */
		private function _onLayerLoad(startInterval:Boolean):void {
			
			trace('layer loaded');
				
			var path:String = _layer.path;

			var start:int = Math.max(path.lastIndexOf('\\')+1,path.lastIndexOf('/')+1);
			var end:int = path.lastIndexOf('.');
			
			_filename.text = path.substr(start, end - start);
			
			// add the preview interval
			_timer.addEventListener(TimerEvent.TIMER, _onUpdateTimer);
			
			// frame listener
			addEventListener(Event.ENTER_FRAME, _updatePlayheadHandler);
			
			// make sure the timer is running
			_timer.start();

			// update the preview			
			_onUpdateTimer(null);
			
			// clears children
			_filters.clearChildren();
			
			// TBD: Need to add filters
		}
		
		
		/**
		 *	Handler that is evoked when a layer is unloaded
		 */
		private function _onLayerUnLoad(event:LayerEvent):void {
			
			_timer.stop();
			_timer.removeEventListener(TimerEvent.TIMER, _onUpdateTimer);
			
			_filename.text = '';
			_assetScrub.x = LAYER_SCRUB_LEFT;
			
			removeEventListener(Event.ENTER_FRAME, _updatePlayheadHandler);
			_preview.bitmapData.fillRect(_preview.bitmapData.rect, 0x000000);
			
			if (_selectedFilterWindow) {
				_selectedFilterWindow.removeControls();
				removeChild(_selectedFilterWindow);
			}

		}
		
		/**
		 * 	Handler that is evoked when an update is called for
		 */
		private function _onUpdateTimer(event:TimerEvent):void {
			
			// updates the bitmap
			var bmp:BitmapData = _preview.bitmapData;
			bmp.fillRect(bmp.rect, 0x00000000);

			// draw			
			_layer.draw(bmp);
			
		}
		
		
		/**
		 * 	@private
		 * 	Handler that is evoked to update the playhead location
		 */
		private function _updatePlayheadHandler(event:Event):void {

			// updates the playhead marker
			_assetScrub.x = _layer.time * LAYER_WIDTH + LAYER_SCRUB_LEFT;
			_filename.text = _layer.path;

		}

		/**
		 * 	@private
		 * 	Mouse handler that is evoked when the playhead button is pressed
		 */		
		private function _onScrubPress(event:MouseEvent):void {
			
			stage.addEventListener(MouseEvent.MOUSE_MOVE, _onScrubMove);
			stage.addEventListener(MouseEvent.MOUSE_UP, _onScrubUp);
			removeEventListener(Event.ENTER_FRAME, _updatePlayheadHandler);
			
			_layer.pause(true);
		}

		/**
		 * 	@private
		 * 	When the scrubber is moved
		 */
		private function _onScrubMove(event:MouseEvent):void {
			var value:int = Math.min(Math.max(_btnScrub.mouseX,LAYER_SCRUB_LEFT),LAYER_SCRUB_RIGHT);
			_assetScrub.x = value;
			_layer.timePercent = value / LAYER_WIDTH;

		}

		/**
		 * 	@private
		 * 	When the scrub bar is moused up
		 */
		private function _onScrubUp(event:MouseEvent):void {

			// add our events back			
			addEventListener(Event.ENTER_FRAME, _updatePlayheadHandler);
			
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, _onScrubMove);
			stage.removeEventListener(MouseEvent.MOUSE_UP, _onScrubUp);
			
			_layer.pause(false);

		}

		/**
		 * 	@private
		 * 	Handler for the mousedown select
		 */
		private function _onMouseDown(event:Event):void {
			selectLayer(this);
		}
		
		/**
		 * 	Adds a filter
		 */
		public function addFilter(filter:Filter):void {
			_layer.addFilter(filter);
		}
		
		/**
		 * 	Removes a filter
		 */
		public function removeFilter(filter:Filter):void {
			_layer.removeFilter(filter);
		}
		
		/**
		 * 	@private
		 * 	Event when filter is added
		 */
		private function _onFilterApplied(event:FilterEvent):void {
			
			var filter:LayerFilter = new LayerFilter(event.filter, _layer);
			
			// add the event handler
			filter.addEventListener(MouseEvent.MOUSE_DOWN, _filterMouseHandler);

			// add to the scrollpane			
			_filters.addChild(filter);
			
			// reorder filters
			reorderFilters();
		}
		
		/**
		 * 	@private
		 * 	Called when a filter is removed
		 */
		private function _onFilterRemoved(event:FilterEvent):void {
			
			for (var count:int = 0; count < _filters.numChildren; count++) {
				
				var layerfilter:LayerFilter = _filters.getChildAt(count) as LayerFilter;

				if (layerfilter.filter === event.filter) {
					_filters.removeChild(layerfilter);
					break;
				}
			}
			
			if (layerfilter) {
				layerfilter.removeEventListener(MouseEvent.MOUSE_DOWN, _filterMouseHandler);
				layerfilter.dispose();
			}

			if (_selectedFilterWindow) {
				if (_selectedFilterWindow.filter === event.filter) {
					
					_selectedFilterWindow.removeControls();
					
					removeChild(_selectedFilterWindow);
					
					_selectedFilterWindow = null;
					
				}
			}

			// change orders
			reorderFilters();

		}

		/**
		 * 	When a filter is moved
		 */		
		private function _onFilterMove(event:FilterEvent):void {
			reorderFilters();
		}
		
		/**
		 * 	@private
		 */
		private function _filterMouseHandler(event:MouseEvent):void {
			
			selectFilter(event.currentTarget as LayerFilter);
			
		}

		/**
		 * 
		 */		
		public function reorderFilters():void {
			for (var count:int = 0; count < _filters.numChildren; count++) {
				var filter:LayerFilter = _filters.getChildAt(count) as LayerFilter;
				filter.y = filter.index * 14;
			}
		}
		
		public function selectFilter(filter:LayerFilter):void {
			
			if (!_selectedFilterWindow) {
				_selectedFilterWindow = new UIFilterSelection();
				
				addChild(_selectedFilterWindow);
				
			} else {
				_selectedFilter.highlight(0, 0);
			}

			filter.highlight(0xFFFFFF, .4);

			_selectedFilterWindow.y = 302;
			_selectedFilterWindow.addControls(filter.filter);
			
			_selectedFilter = filter;
		}

		public function moveLayer(event:LayerEvent = null):void {
			x = _layer.index * 200 + LAYER_X;
			y = LAYER_Y;
		}
		
		public function get index():int {
			return _layer.index;
		}
		
		override public function toString():String {
			return '[UILayer ' + _layer.index + ']';
		}

	}
}