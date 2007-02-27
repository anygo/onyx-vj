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
	import flash.geom.*;
	import flash.net.URLRequest;
	import flash.utils.Timer;
	
	import onyx.controls.*;
	import onyx.core.Onyx;
	import onyx.events.*;
	import onyx.filter.Filter;
	import onyx.layer.*;
	import onyx.plugin.Plugin;
	import onyx.states.StateManager;
	import onyx.transition.Transition;
	import onyx.utils.string.*;
	
	import ui.assets.*;
	import ui.controls.*;
	import ui.controls.filter.*;
	import ui.controls.layer.*;
	import ui.controls.page.*;
	import ui.core.*;
	import ui.states.*;
	import ui.styles.*;
	import ui.text.*;
	import ui.window.*;

	/**
	 * 	Controls layers
	 */	
	public class UILayer extends UIFilterControl implements IFilterDrop {
		
		/**
		 * 	@private
		 */
		private static const LAYER_X:int			= 6;

		/**
		 * 	@private
		 */
		private static const LAYER_Y:int				= 6;

		/**
		 * 	@private
		 */
		private static const SCRUB_LEFT:int			= 3;

		/**
		 * 	@private
		 */
		private static const SCRUB_RIGHT:int			= 173;

		/**
		 * 	@private
		 */
		private static const LAYER_WIDTH:int			= SCRUB_RIGHT - SCRUB_LEFT;

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
				selectedLayer._timer.delay = 3000;
				selectedLayer.transform.colorTransform = DEFAULT;
			}
			
			// make the delay faster
			uilayer._timer.delay = 1000;
			
			// highlight
			uilayer.transform.colorTransform = LAYER_HIGHLIGHT;
			
			// select layer
			selectedLayer = uilayer;
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
		private var _layer:ILayer;

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
		private var _preview:Bitmap							= new Bitmap();

		/** @private **/
		private var _filename:TextField						= new TextField(162,16);
				
		/**
		 * 	@constructor
		 **/
		public function UILayer(layer:ILayer):void {
			
			var props:LayerProperties = layer.properties;
			
			// register for filter drops
			super(
				layer, 
				0,
				new LayerPage('BASIC',	props.position,
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
				),
				new LayerPage('FILTERS'),
				new LayerPage('CUSTOM')
			);
			
			// register this as a drop target for filters
			Filters.registerTarget(this);
			
			// store layer
			_layer = layer;

			// push
			_layers.push(this);

			// draw
			_draw();
			
			// add handlers			
			_assignHandlers();

			// if there is no selected layer, select current layer
			if (!selectedLayer) {
				selectLayer(this);
			}
		}

		/**
		 * 	Overrides the layer colortransform
		 */
		override public function get transform():Transform {
			var mtransform:MultiTransform = new MultiTransform(this, _assetLayer, controlTabs);
			return mtransform;
		}
		
		/**
		 * 	@private
		 * 	assign handlers
		 */
		private function _assignHandlers():void {
			
			// add layer event handlers
			_layer.addEventListener(LayerEvent.LAYER_LOADED, _onLayerLoad);
			_layer.addEventListener(LayerEvent.LAYER_UNLOADED, _onLayerUnLoad);
			
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
					_layer.dispose();
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
			
			// resize preview
			_preview.scaleX = _preview.scaleY = .6;
			
			// make the filename text have a drop shadow
			_filename.filters = [new DropShadowFilter(1, 45,0x000000, 1, 0, 0, 1)];
			_filename.cacheAsBitmap = true;
			
			var props:LayerProperties = _layer.properties;
			
			_loopStart		= new LoopStart(props.getControl('loopStart'));
			_loopEnd		= new LoopEnd(props.getControl('loopEnd'));
			
			var options:UIOptions		= new UIOptions();
			var dropOptions:UIOptions	= new UIOptions(false, false, null, 140, 11);
						
			addChildren(
			
				_assetLayer,														0,			0,
				_preview,															1,			1,
				_filename,															3,			3,
				controlPage,														3,			192,

				new DropDown(dropOptions, props.blendMode),							4,			153,
				_assetScrub,										 		SCRUB_LEFT,			139,
				_btnScrub,															1,			139,
				filterPane,														111,		186,

				_btnUp,																153,		154,
				_btnDown,															162,		154,
				_btnCopy,															171,		154,
				_btnDelete,															180,		154,
				
				controlTabs,														0,			169,
				
				_loopStart,															10,			138,
				_loopEnd,															184,		138
			);
			
		}
		
		/**
		 * 	Loads a layer
		 */
		public function load(path:String, settings:LayerSettings = null):void {
			
			// see if we're passing a transition
			if (UIManager.transition) {
				var transition:Transition = UIManager.transition.clone();
			}
			
			_layer.load(path, settings, transition);
			
		}
		
		/**
		 * 	@private
		 * 	Handler that is evoked when a layer has finished loading a file
		 */
		private function _onLayerLoad(event:Event):void {
			
			// parse out the extension
			var path:String = _layer.path;

			// check for custom controls
			if (_layer.controls) {
				var page:LayerPage = pages[2];
				page.controls = _layer.controls;

				// check if we're on the custom controls page
				if (selectedPage == 2) {
					controlPage.addControls(_layer.controls);
				}

			}
			
			// set name
			_filename.text = removeExtension(path);
			
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
			
			var page:LayerPage = pages[2];
			if (page.controls) {
				page.controls = null;
			}
			selectPage(0);
			
			_filename.text = '';
			_assetScrub.x = SCRUB_LEFT;
			
			removeEventListener(Event.ENTER_FRAME, _updatePlayheadHandler);
		}
		
		/**
		 * 	@private
		 * 	Handler that is evoked to update the playhead location
		 */
		private function _updatePlayheadHandler(event:Event):void {

			// updates the playhead marker
			_assetScrub.x = _layer.time * LAYER_WIDTH + SCRUB_LEFT;
			_preview.bitmapData = _layer.rendered;

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
			var value:int = Math.min(Math.max(_btnScrub.mouseX, SCRUB_LEFT), SCRUB_RIGHT);
			_assetScrub.x = value;
			_layer.time = (value - SCRUB_LEFT) / LAYER_WIDTH;
			
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
				if (filterPane.selectedFilter) {
					if (mouseX > 105) {
						if (!(event.target is LayerFilter)) {
							filterPane.selectFilter(null);
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
		 * 	Moves layer
		 */
		public function reOrderLayer(event:LayerEvent = null):void {
			x = _layer.index * 203 + LAYER_X;
			y = LAYER_Y;
		}
		
		/**
		 * 	Returns the index of the current layer
		 */
		public function get index():int {
			return _layer.index;
		}

		/**
		 * 	Returns layer associated to this control
		 */
		public function get layer():ILayer {
			return _layer;
		}
		
		/**
		 * 	Selects a filter above or below currently selected filter
		 */
		public function selectFilterUp(up:Boolean):void {
			
			/*
			if (_selectedFilter) {
				var index:int = _selectedFilter.filter.index + (up ? -1 : 1);
				selectFilter(_filters[index]);
			} else {
				selectFilter(_filters[int((up) ? _filters.length - 1 : 0)]);
			}
			*/
		}

	}
}
