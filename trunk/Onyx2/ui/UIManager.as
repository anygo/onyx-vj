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
package ui {
	
	import flash.display.Bitmap;
	import flash.display.Stage;
	import flash.display.StageQuality;
	import flash.events.EventDispatcher;
	
	import onyx.core.Onyx;
	import onyx.display.Display;
	import onyx.events.ApplicationEvent;
	import onyx.events.DisplayEvent;
	import onyx.events.LayerEvent;
	import onyx.layer.Layer;
	import onyx.plugin.Plugin;
	import onyx.states.StateManager;
	import onyx.transition.Transition;
	
	import ui.assets.*;
	import ui.layer.UILayer;
	import ui.states.KeyListenerState;
	import ui.window.*;

	/**
	 * 	Class that handles top-level management of all ui objects
	 */
	public class UIManager {
		
		public static var transition:Transition;

		/**
		 * 	@private
		 */
		public static var root:Stage;
		
		/**
		 * 	initialize
		 */
		public static function initialize(root:Stage):void {
			
			// store the root
			UIManager.root = root;
			
			// low quality
			root.stage.quality = StageQuality.LOW;
			
			// initializes onyx
			var engine:EventDispatcher = Onyx.initialize(root);
			
			// wait til we're done initializing
			engine.addEventListener(ApplicationEvent.ONYX_STARTUP_END, _onInitialize);
		}
		
		/**
		 * 	@private
		 */
		private static function _onInitialize(event:ApplicationEvent):void {
			
			var engine:EventDispatcher = event.currentTarget as EventDispatcher;

			_loadWindows(Console, PerfMonitor, Browser, Filters, TransitionWindow);

			// listen for windows created
			engine.removeEventListener(ApplicationEvent.ONYX_STARTUP_END, _onInitialize);
			engine.addEventListener(LayerEvent.LAYER_CREATED, _onLayerCreate);
			engine.addEventListener(DisplayEvent.DISPLAY_CREATED, _onDisplayCreate);
			
			Onyx.createLocalDisplay(5);
			
			StateManager.loadState(new KeyListenerState(), root);
		}
		
		/**
		 * 	@private
		 */
		private static function _loadWindows(... windowsToLoad:Array):void {

			for each (var window:Class in windowsToLoad) {
				root.addChild(new window());
			}

		}
		
		/**
		 * 	@private
		 */
		private static function _onDisplayCreate(event:DisplayEvent):void {
			var display:SettingsWindow = new SettingsWindow(event.display);
			root.addChild(display);
		}
		
		/**
		 * 	@private
		 */
		private static function _onLayerCreate(event:LayerEvent):void {
			
			var uilayer:UILayer = new UILayer(event.layer);
			uilayer.reOrderLayer();

			root.addChildAt(uilayer, 0);
		}
	}
}