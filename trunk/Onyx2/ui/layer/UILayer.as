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
	
	import flash.display.*;
	import flash.events.*;
	import flash.filters.DropShadowFilter;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.net.URLRequest;
	import flash.utils.Timer;
	
	import onyx.application.Onyx;
	import onyx.application.StateManager;
	import onyx.controls.*;
	import onyx.events.*;
	import onyx.filter.Filter;
	import onyx.layer.Layer;
	import onyx.layer.LayerProperties;
	import onyx.net.Plugin;
	import onyx.transition.Transition;
	
	import ui.assets.*;
	import ui.controls.*;
	import ui.controls.filter.LayerFilter;
	import ui.controls.layer.*;
	import ui.core.UIObject;
	import ui.states.FilterMoveState;
	import ui.states.LayerMoveState;
	import ui.text.Style;
	import ui.text.TextField;
	import ui.window.TransitionWindow;

	/**
	 * 	Controls layers
	 */	
	public class UILayer extends UIObject {
		
		/**
		 * 	STATIC MEMBERS
		 **/

		public static const LAYER_X:int				= 6;
		public static const LAYER_Y:int				= 6;
		public static const SCRUB_LEFT:int	= 3;
		public static const SCRUB_RIGHT:int	= 176;
		public static const LAYER_WIDTH:int			= SCRUB_RIGHT - SCRUB_LEFT;

		/**
		 * 	@private
		 */
		private static var _layers:Array			= [];

		/**
		 * 	Returns all layers
		 */
		public static function get layers():Array {
			return _layers;
		}

		/**
		 * 	Returns the layer control at a specified index
		 */		
		public static function getLayerAt(index:int):UILayer {
			return _layers[index];
		}

		/**
		 * 	Selects a layer
		 */
		public static function selectLayer(uilayer:UILayer):void {
			
			if (selectedLayer) {
				selectedLayer._timer.delay = 2200;
				selectedLayer.highlight(0,0);
			}
			
			// make the delay faster
			uilayer._timer.delay = 220;
			
			uilayer.highlight(0x3186d6,.13);
			
			selectedLayer = uilayer;
			
			uilayer.moveToTop();
		}
		
		/**
		 *	The currently selected layer 
		 */
		public static var selectedLayer:UILayer;

		/********************************************************
		 * 
		 * 					CLASS MEMBERS
		 * 
		 **********************************************************/

		/** @private **/
		private var _layer:Layer;

		/** @private **/
		private var _monitor:Boolean						= false;

		/** @private **/
		private var _btnUp:ButtonClear						= new ButtonClear(10, 10);

		/** @private **/
		private var _btnDown:ButtonClear					= new ButtonClear(10, 10);

		/** @private **/
		private var _btnCopy:ButtonClear					= new ButtonClear(10, 10);

		/** @private **/
		private var _btnDelete:ButtonClear					= new ButtonClear(10, 10);
		
		/** @private **/
		private var _loopStart:LoopStart;

		/** @private **/
		private var _loopEnd:LoopEnd;
		
		/** @private **/
		private var _assetLayer:AssetLayer					= new AssetLayer();

		/** @private **/
		private var _assetScrub:ScrubArrow 					= new ScrubArrow();

		/** @private **/
		private var _btnScrub:ButtonClear					= new ButtonClear(192, 12, false);

		/** @private **/
		private var _timer:Timer							= new Timer(2000);

		/** @private **/
		private var _preview:Bitmap							= new Bitmap(new BitmapData(192, 144, true, 0x00000000));

		/** @private **/
		private var _filename:TextField						= new TextField(162,16);

		/** @private **/
		private var _filterPane:Sprite						= new Sprite();
		
		/** @private **/
		private var _filters:Array							= [];
		
		/** @private **/
		private var _controlPage:ControlPage				= new ControlPage();
		
		/** @private **/
		private var _controlTabs:ControlPageSelected		= new ControlPageSelected();
		
		/** @private **/
		private var _pages:Array							= [];

		/** @private **/
		private var _selectedPage:int						= -1;
				
		/** @private **/
		private var _selectedFilter:LayerFilter;
		
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
			
			super(true);
		}
		
		/**
		 * 	Highlights a layer with a particular color
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
			
			_assetLayer.transform.colorTransform				= transform;
			_controlTabs.background.transform.colorTransform	= transform;
			
		}
		
		/**
		 * 	@private
		 * 	assign handlers
		 */
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

			// set enabled
			_btnUp.doubleClickEnabled = true;
			_btnDown.doubleClickEnabled = true;	

			// buttons
			_btnUp.addEventListener(MouseEvent.CLICK, _onButtonPress);
			_btnDown.addEventListener(MouseEvent.CLICK, _onButtonPress);
			_btnUp.addEventListener(MouseEvent.DOUBLE_CLICK, _onButtonPress);
			_btnDown.addEventListener(MouseEvent.DOUBLE_CLICK, _onButtonPress);
			_btnCopy.addEventListener(MouseEvent.MOUSE_DOWN, _onButtonPress);
			_btnDelete.addEventListener(MouseEvent.MOUSE_DOWN, _onButtonPress);

			// when the layer is moved
			_layer.addEventListener(LayerEvent.LAYER_MOVE, reOrderLayer);

		}
		
		/**
		 * 	@private
		 * 	Handler while a file loads
		 */
		private function _onLayerProgress(event:ProgressEvent):void {
			_filename.text = 'LOADING ' + Math.floor(event.bytesLoaded / event.bytesTotal * 100) + '% (' + Math.floor(event.bytesTotal / 1024) + ' kb)';
		}
		
		/**
		 * 	@private
		 */
		private function _onButtonPress(event:MouseEvent):void {
			
			switch (event.currentTarget) {
				case _btnUp:
					_layer.moveLayer(index-1);
					break;
				case _btnDown:
					_layer.moveLayer(index+1);
					break;
				case _btnCopy:
					_layer.copyLayer();
					break;
				case _btnDelete:
					_layer.unload();
					break;
					
			}
		}
		
		/**
		 * 	Moves a layer to a specified index
		 */
		public function moveLayer(index:int):void {
			_layer.moveLayer(index);
		}
		
		/**
		 * 	@private
		 * 	Positions all the objects
		 */
		private function _draw():void {
			
			// make the filename text have a drop shadow
			_filename.filters = [new DropShadowFilter(1, 45,0x000000, 1, 0, 0, 1)];
			_filename.cacheAsBitmap = true;
			
			var props:LayerProperties = _layer.properties;
			
			_loopStart = new LoopStart(props.getControl('loopStart'));
			_loopEnd = new LoopEnd(props.getControl('loopEnd'));
			
			var options:UIOptions		= new UIOptions();
			var dropOptions:UIOptions	= new UIOptions(false, false, null, 140, 11);

			var page:LayerPage	= _pages[0];
			
			addPage('BASIC',
				props.position,
				props.alpha,
				props.scale,
				props.brightness,
				props.rotation,
				props.contrast,
				props.tint,
				props.saturation,
				props.color,
				props.threshold,
				props.framerate
			);
			
			addPage('FILTERS');
			addPage('CUSTOM');
		
			selectPage(0);
						
			addChildren(
			
				_assetLayer,														0,			0,
				_preview,															1,			1,
				_filename,															3,			3,
				_controlPage,														6,			193,

				new DropDown(dropOptions, props.blendMode),							4,			153,
				_assetScrub,										 		SCRUB_LEFT,			139,
				_btnScrub,															1,			139,
				_filterPane,														110,		182,

				_btnUp,																153,		154,
				_btnDown,															162,		154,
				_btnCopy,															171,		154,
				_btnDelete,															180,		154,
				
				_controlTabs,														0,			169,
				
				_loopStart,															10,			138,
				_loopEnd,															184,		138
			);
			
		}
		
		/**
		 * 	Loads a layer
		 */
		public function load(path:String):void {
			_layer.load(new URLRequest(path), null);
			
		}
		
		/**
		 * 
		 */
		public function selectPage(index:int):void {
			
			if (index !== _selectedPage) {
				var page:LayerPage = _pages[index];
				
				_controlPage.addControls(page.controls);
				_controlTabs.text	= page.name;
				_controlTabs.x		= index * 35;
				
				_selectedPage = index;
			}
		}
		
		/**
		 * 
		 */
		public function addPage(name:String, ... controls:Array):void {
			var page:LayerPage = new LayerPage(name);
			page.controls = controls || [];
			
			var index:int	= _pages.push(page) - 1;
			
			var button:LayerPageButton = new LayerPageButton(index);
			button.x		= index * 35;
			button.y		= 169;

			addChild(button);

			button.addEventListener(MouseEvent.MOUSE_DOWN, _onPageSelect);
		}

		/**
		 * 	@private
		 */
		private function _onPageSelect(event:MouseEvent):void {
			var target:LayerPageButton = event.currentTarget as LayerPageButton;
			
			if (target.index === 1) {
				var filter:LayerFilter = _filters[0];
				if (filter) {
					selectFilter(filter);
				}
			} else {
				selectFilter(null);
				selectPage(target.index);
			}
		}
		
		/**
		 * 	@private
		 * 	Handler that is evoked when a layer has finished loading a file
		 */
		private function _onLayerLoad(startInterval:Boolean):void {
			
			// parse out the extension
			var path:String = _layer.path;

			var start:int = Math.max(path.lastIndexOf('\\')+1,path.lastIndexOf('/')+1);
			var end:int = path.lastIndexOf('.');
			
			// check for custom controls
			if (_layer.controls) {
				var page:LayerPage = _pages[2];
				page.controls = _layer.controls;

				// check if we're on the custom controls page
				if (_selectedPage == 2) {
					_controlPage.addControls(_layer.controls);
				}

			}
			
			// set name
			_filename.text = path.substr(start, end - start);
			
			// add the preview interval
			_timer.addEventListener(TimerEvent.TIMER, _onUpdateTimer);
			
			// frame listener
			addEventListener(Event.ENTER_FRAME, _updatePlayheadHandler);
			
			// make sure the timer is running
			_timer.start();
		}
		
		/**
		 * 	@private
		 *	Handler that is evoked when a layer is unloaded
		 */
		private function _onLayerUnLoad(event:LayerEvent):void {
			
			var page:LayerPage = _pages[2];
			if (page.controls) {
				page.controls = null;
			}
			selectPage(0);
			
			_timer.stop();
			_timer.removeEventListener(TimerEvent.TIMER, _onUpdateTimer);
			
			_filename.text = '';
			_assetScrub.x = SCRUB_LEFT;
			
			removeEventListener(Event.ENTER_FRAME, _updatePlayheadHandler);
			_preview.bitmapData.fillRect(_preview.bitmapData.rect, 0x000000);
		}
		
		/**
		 * 	@private
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
			_assetScrub.x = _layer.time * LAYER_WIDTH + SCRUB_LEFT;

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

			_onScrubMove(event);
		}

		/**
		 * 	@private
		 * 	When the scrubber is moved
		 */
		private function _onScrubMove(event:MouseEvent):void {
			var value:int = Math.min(Math.max(_btnScrub.mouseX - SCRUB_LEFT, SCRUB_LEFT), SCRUB_RIGHT);
			_assetScrub.x = value;
			_layer.time = value / LAYER_WIDTH;

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
		private function _onMouseDown(event:MouseEvent):void {
			selectLayer(this);
			
			// check to see if we clicked on the top portion, if so, we're going to allow
			// dragging to move a layer
			if (mouseY < 136) {
				
				if (event.ctrlKey) {
					
					_forwardMouse(event);
					addEventListener(MouseEvent.MOUSE_MOVE, _forwardMouse);
					addEventListener(MouseEvent.MOUSE_UP, _stopForwardMouse);
				
				} else {
					
					StateManager.loadState(new LayerMoveState(), this);
					
				}
				
			} else if (mouseY > 182) {
			
				// else check to see if the mouse is within the empty area
				if (_selectedFilter) {
					if (mouseX > 105) {
						if (!(event.target is LayerFilter)) {
							selectFilter(null);
						}
					}
				}
			}
		}
		
		/**
		 * 	@private
		 * 	Forwards mouse events to the layer based on clicking the preview
		 */
		private function _forwardMouse(event:MouseEvent):void {
			event.localX = _preview.mouseX / .6 / _layer.scaleX;
			event.localY = _preview.mouseY / .6 / _layer.scaleY;
			
			_layer.dispatchEvent(event);
		}
		
		/**
		 * 	@private
		 * 	Forwards mouse events to the layer based on clicking the preview
		 */
		private function _stopForwardMouse(event:MouseEvent):void {
			removeEventListener(MouseEvent.MOUSE_MOVE, _forwardMouse);
			removeEventListener(MouseEvent.MOUSE_UP, _stopForwardMouse);
			
			_forwardMouse(event);
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
			
			// make a new filter
			var filter:LayerFilter = new LayerFilter(event.filter, _layer);
			
			// push filter
			_filters.push(filter)

			// add the event handler
			filter.addEventListener(MouseEvent.MOUSE_DOWN, _filterMouseHandler);

			// add to the scrollpane			
			_filterPane.addChildAt(filter, event.filter.index);
			
			// reorder filters
			reorderFilters();
			
			// select it
			selectFilter(filter);
		}
		
		/**
		 * 	@private
		 * 	Called when a filter is removed
		 */
		private function _onFilterRemoved(event:FilterEvent):void {
			
			for (var count:int = 0; count < _filters.length; count++) {
				var filter:LayerFilter = _filters[count];
				if (filter.filter === event.filter) {
					_filters.splice(count, 1);
					break;
				}
			}
			
			if (filter === _selectedFilter) {
				selectFilter(null);
			}
			
			// remove the layer reference
			_filterPane.removeChild(filter);

			// remove
			filter.removeEventListener(MouseEvent.MOUSE_DOWN, _filterMouseHandler);
			filter.dispose();

			// change orders
			reorderFilters();

		}

		/**
		 * 	@private
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
			
			var state:FilterMoveState = new FilterMoveState();
			StateManager.loadState(state, event.currentTarget, _filters);
		}

		/**
		 * 	Re-orders filters
		 */		
		public function reorderFilters():void {
			
			var filters:Array = _layer.filters;
			
			// clears filters: this needs to be here?  bug with setChildIndex?
			while (_filterPane.numChildren) {
				_filterPane.removeChildAt(0);
			}
			
			for each (var control:LayerFilter in _filters) {
				var index:int = control.filter.index;
				control.y = index * 14;
				
				_filterPane.addChild(control);
			}

		}
		
		/**
		 * 	Selects a filter, de-selects if already selected
		 */
		public function selectFilter(control:LayerFilter):void {
			
			if (_selectedFilter) {
				_selectedFilter.highlight(0,0);
				
				if (control === _selectedFilter) {
					control = null;
				}
			}
			
			_selectedFilter = control;
			
			if (control) {
				
				control.highlight(0xFFFFFF, .4);

				if (_selectedPage != 1) {
					var page:LayerPage = _pages[1];
					page.controls = control.filter.controls;
	
					selectPage(1);
				} else {
					_controlPage.addControls(control.filter.controls);
				}

			} else {
				
				selectPage(0);
				
			}
		}

		/**
		 * 	Moves layer
		 */
		public function reOrderLayer(event:LayerEvent = null):void {
			x = _layer.index * 200 + LAYER_X;
			y = LAYER_Y;
		}
		
		/**
		 * 	Returns the index
		 */
		public function get index():int {
			return _layer.index;
		}

		/**
		 * 	Returns layer
		 */
		public function get layer():Layer {
			return _layer;
		}
		
		/**
		 * 
		 */
		public function selectFilterUp(up:Boolean):void {
			if (_selectedFilter) {
				var index:int = _selectedFilter.filter.index + (up ? -1 : 1);
				selectFilter(_filters[index]);
			} else {
				selectFilter(_filters[int((up) ? _filters.length - 1 : 0)]);
			}
		}

	}
}