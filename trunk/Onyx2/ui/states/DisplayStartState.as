package ui.states {
	
	import flash.display.*;
	import flash.events.*;
	
	import onyx.constants.ROOT;
	import onyx.core.*;
	import onyx.events.ConsoleEvent;
	import onyx.states.ApplicationState;
	
	import ui.assets.*;
	import ui.core.UIManager;
	import ui.text.TextField;
	
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
			ROOT.addEventListener(MouseEvent.MOUSE_UP,	_captureEvents,	true, -1);
			
			// listen for updates
			var console:Console = Console.getInstance();
			console.addEventListener(ConsoleEvent.OUTPUT, _onOutput);
			
			// set the label type
			_label.selectable		= false;
			_label.x				= 683;
			_label.y				= 437;
			
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
			
			var console:Console = Console.getInstance();
			console.removeEventListener(ConsoleEvent.OUTPUT, _onOutput);
			
			// remove listener to the stage
			ROOT.removeEventListener(Event.ADDED, _onItemAdded);
			
			// remove listener for mouse clicks
			ROOT.removeEventListener(MouseEvent.MOUSE_DOWN,	_captureEvents,	true);
			ROOT.removeEventListener(MouseEvent.MOUSE_UP,		_captureEvents,	true);

			// remove items
			ROOT.removeChild(_image);
			ROOT.removeChild(_label);
			
			// clear references
			_image = null;
			_label = null;
		}
	}
}