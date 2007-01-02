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
package onyx.application {

	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.utils.Timer;
	
	import onyx.assets.PixelFont;
	import onyx.core.Console;
	import onyx.core.onyx_internal;
	import onyx.events.ApplicationEvent;
	import onyx.events.FilterEvent;
	import onyx.events.PluginEvent;
	import onyx.events.TransitionEvent;
	import onyx.net.IExternalPlugin;
	import onyx.net.IFilterLoader;
	import onyx.net.ITransitionLoader;
	import onyx.net.Plugin;
	import onyx.settings.Settings;
	
	use namespace onyx_internal;

	/**
	 * 
	 */	
	public final class InitializationState extends ApplicationState {
		
		private var _filtersToLoad:Array	= [];
		private var _image:DisplayObject;
		private var _label:TextField		= new TextField();
		private var _timer:Timer			= new Timer(300);

		/**
		 * 	Initializes
		 */
		override public function initialize(... args:Array):void {
			
			// dispatch a start event
			Onyx.instance.dispatchEvent(new ApplicationEvent(ApplicationEvent.ONYX_STARTUP_START));
			
			// listen for new plugins
			Onyx.instance.addEventListener(PluginEvent.PLUGIN_LOADED, _onPluginCreate);

			// create the image and a label
			_image = new OnyxStartUpImage();
			Onyx.root.addChild(_image);
			Onyx.root.addChild(_label);
			
			Onyx.root.addEventListener(MouseEvent.MOUSE_DOWN, _captureEvents, true, -1);
			Onyx.root.addEventListener(MouseEvent.MOUSE_UP, _captureEvents, true, -1);
			
			_label.selectable = false;
			_label.defaultTextFormat = PixelFont.DEFAULT;
			_label.embedFonts = true;
			_label.x = 683;
			_label.y = 487;
			_label.height = 60;
			
			_loadExternalPlugins();
		}
		
		/**
		 * 	@private
		 * 	Handler when a plug-in is loaded
		 */
		private function _onPluginCreate(event:PluginEvent):void {
		}
		
		/**
		 * 	@private
		 * 	Initializes the external filter loading
		 */
		private function _loadExternalPlugins():void {
			var loader:URLLoader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, _onFiltersLoaded);
			loader.addEventListener(IOErrorEvent.IO_ERROR, _onFiltersLoaded);
			loader.load(new URLRequest(Settings.INITIAL_APP_DIRECTORY + 'filters.xml'));
			
			_label.text = 'LOADING PLUG-INS ... \n';
		}
		
		/**
		 * 	@private
		 * 	When filter is loaded
		 */
		private function _onFiltersLoaded(event:Event):void {
			
			if (!(event is IOErrorEvent)) {
				var loader:URLLoader = event.currentTarget as URLLoader;
				loader.removeEventListener(Event.COMPLETE, _onFiltersLoaded);
				
				var xml:XML = new XML(loader.data); 
				
				for each (var i:XML in xml.file) {
					
					var swfloader:Loader = new Loader();
					swfloader.contentLoaderInfo.addEventListener(Event.COMPLETE, _onFilterLoaded);
					swfloader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, _onFilterLoaded);
					swfloader.load(new URLRequest(Settings.INITIAL_APP_DIRECTORY + String(i.@name)));
					
					_filtersToLoad.push(swfloader);
					
					_label.appendText('LOADING ' + String(i.@name).toUpperCase() + '\n');
					_label.scrollV = _label.maxScrollV;
				}
			}

		}
		
		/**
		 * 	@private
		 * 	When a filter is loaded
		 */
		private function _onFilterLoaded(event:Event):void {
			
			var info:LoaderInfo = event.currentTarget as LoaderInfo;
			_filtersToLoad.splice(_filtersToLoad.indexOf(info.loader), 1);

			// if valid swf
			if (!(event is IOErrorEvent)) {
				
				var pluginSWF:IExternalPlugin = info.content as IExternalPlugin;
				
				if (pluginSWF) {
					
					var plugins:Array = pluginSWF.plugins;
					
					for each (var plugin:Plugin in plugins) {
						
						Onyx.registerPlugin(plugin);
						
						_label.appendText('REGISTERING ' + plugin.name.toUpperCase() + '\n');
						_label.scrollV = _label.maxScrollV;
					}
				}
			}
			
			// no more filters to load
			if (_filtersToLoad.length == 0) {
				_initialize();
			}
		}
		
		/**
		 * 	@private
		 * 	Begin initialization timer
		 */
		private function _initialize():void {
			Onyx.root.removeEventListener(Event.ADDED, _onItemAdded);
			_label.appendText('INITIALIZING ...\n');
			_label.scrollV = _label.maxScrollV;

			_timer.start();
			_timer.addEventListener(TimerEvent.TIMER, _endState);
		}
		
		/**
		 * 	@private
		 * 	Ends the timer
		 */
		private function _endState(event:TimerEvent):void {
			
			_timer.stop();
			_timer.removeEventListener(TimerEvent.TIMER, _endState);
			_timer = null;
			
			// end the state
			StateManager.removeState(this);
		}
		
		/**
		 * 	When an item is added, make sure it is below the startup image
		 */
		private function _onItemAdded(event:Event):void {
			
			var stage:Stage = Onyx.root;
			stage.setChildIndex(_image, stage.numChildren - 1);
			stage.setChildIndex(_label, stage.numChildren);
			
		}
		
		/**
		 * 	@private
		 * 	Traps all mouse events
		 */
		private function _captureEvents(event:MouseEvent):void {
			event.stopPropagation();
		}
		
		/**
		 * 	Terminates the state
		 */
		override public function terminate():void {

			// remove listeners
			Onyx.root.removeEventListener(MouseEvent.MOUSE_DOWN, _captureEvents, true);
			Onyx.root.removeEventListener(MouseEvent.MOUSE_UP, _captureEvents, true);
			
			// remove items
			Onyx.root.removeChild(_image);
			Onyx.root.removeChild(_label);
			
			// clear references
			_image = null;
			_label = null;
			_filtersToLoad = null;

			// we're done initializing
			Onyx.instance.dispatchEvent(new ApplicationEvent(ApplicationEvent.ONYX_STARTUP_END));

			// dispatch the start-up motd
			Console.trace(
				'<font size="14" color="#DCC697"><b>onyx version 3.0b</b></font><br>' + 
				'copyright 2003-2006: www.onyx-vj.com.' +
				'<br>enter command "help" for more info.<br><br>' +
				Onyx._filters.length + ' filters loaded.<br>' +
				Onyx._transitions.length + ' transitions loaded.<br><br>');

			StateManager.loadState(new RunTimeState());

		}
	}
}