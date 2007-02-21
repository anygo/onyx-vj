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
package ui.window {
	
	import flash.events.MouseEvent;
	
	import onyx.core.Onyx;
	import onyx.events.FilterEvent;
	import onyx.filter.Filter;
	import onyx.plugin.Plugin;
	
	import ui.controls.ScrollPane;
	import ui.controls.filter.LibraryFilter;
	import ui.core.*;
	import ui.events.DragEvent;
	import ui.layer.UILayer;
	import ui.policy.*;
	
	/**
	 * 	Filters Window
	 */
	public final class Filters extends Window {
		
		/**
		 * 
		 */
		private var _normalPane:ScrollPane		= new ScrollPane(92, 185);
		
		/**
		 * 
		 */
		private var _bitmapPane:ScrollPane		= new ScrollPane(92, 185);
		
		/**
		 * 	@constructor
		 */
		public function Filters():void {
			
			// set title, etc
			super('FILTERS', 196, 200, 412, 318);
			
			// add panes
			addChild(_normalPane);
			addChild(_bitmapPane);
			
			// add vertical ordering policy
			Policy.addPolicy(_normalPane, new VOrderPolicy());
			Policy.addPolicy(_bitmapPane, new VOrderPolicy());
			
			_normalPane.x = 100;
			_normalPane.y = 15;
			_bitmapPane.x = 4;
			_bitmapPane.y = 15;

			// create filter controls
			_createControls();

		}
		
		/**
		 * 	@private
		 */
		private function _createControls():void {
			
			var filters:Array = Filter.filters;
			var len:int = filters.length;
			
			for (var index:int = 0; index < len; index++) {
				
				var plugin:Plugin = filters[index];
				
				// create library ui item
				var lib:LibraryFilter = new LibraryFilter(plugin);
				
				if (plugin.getData('bitmapFilter')) {
					_bitmapPane.addChild(lib);
				} else {
					_normalPane.addChild(lib);
				}
				
				// handle events
				lib.addEventListener(MouseEvent.MOUSE_DOWN, _onMouseDown);
				lib.addEventListener(MouseEvent.DOUBLE_CLICK, _onDoubleClick);
				lib.doubleClickEnabled = true;
				
			}
			
		}
		
		/**
		 * 	@private
		 */
		private function _onDoubleClick(event:MouseEvent):void {
			
			var control:LibraryFilter	= event.target as LibraryFilter;
			var plugin:Plugin			= control.filter;
			
			if (event.ctrlKey) {
				_applyToAll(plugin);
			} else {
				UILayer.selectedLayer.addFilter(plugin.getDefinition() as Filter);
			}
			
		}
		
		/**
		 * 	@private
		 */
		private function _onMouseDown(event:MouseEvent):void {
			
			var control:LibraryFilter = event.currentTarget as LibraryFilter;
			DragManager.startDrag(control, UILayer.layers, _onDragOver, _onDragOut, _onDragDrop);
			
		}
		
		/**
		 * 	@private
		 */
		private function _onDragOver(event:DragEvent):void {
			var obj:UIObject = event.currentTarget as UIObject;
			obj.highlight(0x800800, .15);
		}
		
		/**
		 * 	@private
		 */
		private function _onDragOut(event:DragEvent):void {
			var obj:UIObject = event.currentTarget as UIObject;
			obj.highlight(0, 0);
		}
		
		/**
		 * 	@private
		 */
		private function _onDragDrop(event:DragEvent):void {
			var uilayer:UILayer			= event.currentTarget as UILayer
			var origin:LibraryFilter	= event.origin as LibraryFilter;
			var plugin:Plugin			= origin.filter;
			uilayer.highlight(0, 0);

			UILayer.selectLayer(uilayer);
			
			if (event.ctrlKey) {

				_applyToAll(plugin);

			} else {
				
				UILayer.selectedLayer.addFilter(plugin.getDefinition() as Filter);
				
			}
		}
		
		/**
		 * 
		 */
		private function _applyToAll(plugin:Plugin):void {
			var layers:Array = UILayer.layers;
			for each (var layer:UILayer in layers) {
				layer.addFilter(plugin.getDefinition() as Filter);
			}
		}
	}
}