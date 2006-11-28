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
	import onyx.external.IFilterLoader;
	import onyx.external.ITransitionLoader;
	import onyx.settings.Settings;
	
	use namespace onyx_internal;
	
	public final class InitializationState implements IApplicationState {
		
		private var _filtersToLoad:Array	= [];
		private var _image:DisplayObject;
		private var _label:TextField		= new TextField();
		private var _timer:Timer			= new Timer(500);

		public function initialize(... args:Array):void {
			
			_image = new OnyxStartUpImage();
			Onyx.root.addChild(_image);
			Onyx.root.addChild(_label);
			Onyx.root.addEventListener(MouseEvent.MOUSE_DOWN, _onMouseDown, true, -1);
			
			_label.selectable = false;
			_label.defaultTextFormat = PixelFont.DEFAULT;
			_label.embedFonts = true;
			_label.x = 683;
			_label.y = 487;
			_label.height = 60;
			
			_loadExternalPlugins();
		}
		
		/**
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
		 * 	When a filter is loaded
		 */
		private function _onFilterLoaded(event:Event):void {
			
			var info:LoaderInfo = event.currentTarget as LoaderInfo;
			_filtersToLoad.splice(_filtersToLoad.indexOf(info.loader), 1);

			if (!(event is IOErrorEvent)) {
				
				if (info.content is IFilterLoader) {
					
					var filters:Array = (info.content as IFilterLoader).registerFilters();

					for each (var filter:Class in filters) {
						Onyx.registerFilter(filter);
						_label.appendText('REGISTERING ' + String(filter.name).toUpperCase() + '\n');
						_label.scrollV = _label.maxScrollV;
					}
				
				}


				if (info.content is ITransitionLoader) {
					
					var transitions:Array = (info.content as ITransitionLoader).registerTransitions();

					for each (var transition:Class in transitions) {
						Onyx.registerTransition(transition);
						_label.appendText('REGISTERING ' + String(transition.name).toUpperCase() + '\n');
						_label.scrollV = _label.maxScrollV;
					}
				
				}
			}
			
			if (_filtersToLoad.length == 0) {

				Onyx.root.removeEventListener(Event.ADDED, _onItemAdded);
				_label.appendText('INITIALIZING ...\n');
				_label.scrollV = _label.maxScrollV;

				_timer.start();
				_timer.addEventListener(TimerEvent.TIMER, _endState);
			}
		}
		
		private function _endState(event:TimerEvent):void {
			
			_timer.stop();
			_timer.removeEventListener(TimerEvent.TIMER, _endState);
			_timer = null;
			
			Onyx.loadApplicationState(new RunTimeState());
		}
		
		/**
		 * 
		 */
		private function _onItemAdded(event:Event):void {
			
			var stage:Stage = Onyx.root;
			stage.setChildIndex(_image, stage.numChildren - 1);
			stage.setChildIndex(_label, stage.numChildren);
			
		}
		
		/**
		 * 	Traps events
		 */
		private function _onMouseDown(event:MouseEvent):void {
			event.stopImmediatePropagation();
		}
		
		/**
		 * 	Terminates
		 */
		public function terminate():void {

			Console.trace(
				'<font size="14" color="#DCC697"><b>onyx version 3.0a</b></font><br>' + 
				'copyright 2003-2006 by Daniel Hai.' +
				'<br>enter command "help" for more info.<br><br>' +
				Onyx._filters.length + ' filters loaded.<br>' +
				Onyx._transitions.length + ' transitions loaded.<br><br>');

			Onyx.root.removeEventListener(MouseEvent.MOUSE_DOWN, _onMouseDown, true);
			Onyx.root.removeChild(_image);
			Onyx.root.removeChild(_label);
			
			_image = null;
			_label = null;
			_filtersToLoad = null;
		}

	}
}