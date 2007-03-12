package ui.states {
	
	import flash.display.*;
	import flash.events.*;
	
	import onyx.constants.*;
	import onyx.core.Onyx;
	import onyx.display.*;
	import onyx.events.*;
	import onyx.states.*;
	
	import ui.assets.*;
	import ui.core.*;
	import ui.layer.UILayer;
	import ui.settings.*;
	import ui.text.*;
	import ui.window.*;
	
	public final class DisplayStartState extends ApplicationState {

		/**
		 * 	@private
		 */
		private var _image:DisplayObject;
		
		/**
		 * 	@private
		 */
		private var _label:TextField		= new TextField(400,125);
		
		/**
		 * 
		 */
		private var _states:Array;

		/**
		 * 	Initialize
		 */
		override public function initialize(... rest:Array):void {
			
			// create the image and a label
			_image = new OnyxStartUpImage();
			
			// add the children
			ROOT.addChild(_image);
			ROOT.addChild(_label);
			
			// listen for mouse clicks
			ROOT.addEventListener(MouseEvent.MOUSE_DOWN,	_captureEvents,	true, -1);
			ROOT.addEventListener(MouseEvent.MOUSE_UP,		_captureEvents,	true, -1);
			
			// listen for updates
			var console:onyx.core.Console = onyx.core.Console.getInstance();
			console.addEventListener(ConsoleEvent.OUTPUT, _onOutput);
			
			// set the label type
			_label.selectable		= false;
			_label.x				= 683;
			_label.y				= 437;
			
			// save states to run
			_states = rest;
			
		}
		
		/**
		 * 
		 */
		private function _onOutput(event:ConsoleEvent):void {
			_label.appendText(event.message + '\n');
			_label.scrollV = _label.maxScrollV;
		}
		
		/**
		 * 	@private
		 * 	Traps all mouse events
		 */
		private function _captureEvents(event:MouseEvent):void {
			event.stopPropagation();
		}
		
		/**
		 * 	@private
		 * 	When an item is added, make sure it is below the startup image
		 */
		private function _onItemAdded(event:Event):void {
			
			var stage:DisplayObjectContainer = ROOT;
			stage.setChildIndex(_image, stage.numChildren - 1);
			stage.setChildIndex(_label, stage.numChildren);
			
		}

		/**
		 * 	Terminate
		 */		
		override public function terminate():void {
			
			var console:onyx.core.Console = onyx.core.Console.getInstance();
			console.removeEventListener(ConsoleEvent.OUTPUT, _onOutput);
			
			// remove listener to the stage
			ROOT.removeEventListener(Event.ADDED, _onItemAdded);
			
			// remove listener for mouse clicks
			ROOT.removeEventListener(MouseEvent.MOUSE_DOWN,		_captureEvents,	true);
			ROOT.removeEventListener(MouseEvent.MOUSE_UP,		_captureEvents,	true);

			// remove items
			ROOT.removeChild(_image);
			ROOT.removeChild(_label);
			
			// clear references
			_image = null;
			_label = null;
			
			// load menu bar
			ROOT.addChild(MenuWindow.instance);
			
			// add a display
			var display:Display = Onyx.createDisplay(STAGE.stageWidth - 320, 525, 1, 1, !SETTING_SUPPRESS_DISPLAYS);
			display.createLayers(5);
			
			// loop through and load states			
			if (_states) {
				for each (var state:ApplicationState in _states) {
					StateManager.loadState(state);
				}
			}

			// remove references
			_states = null;
			
			// register default windows
			MenuWindow.register(
				new WindowRegistration('FILE BROWSER',	Browser),
				new WindowRegistration('CONSOLE',		ui.window.Console),
				new WindowRegistration('FILTERS',		Filters),
				new WindowRegistration('TRANSITIONS',	TransitionWindow),
				new WindowRegistration('SETTINGS',		SettingsWindow),
				new WindowRegistration('LAYERS',		LayerWindow),
				new WindowRegistration('MEMORY',		MemoryWindow, false)
			);
			
		}
	}
}