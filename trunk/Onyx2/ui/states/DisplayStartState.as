package ui.states {
	
	import flash.display.*;
	import flash.events.*;
	
	import onyx.core.*;
	import onyx.states.ApplicationState;
	
	import ui.assets.*;
	import ui.core.UIManager;
	import ui.text.TextField;
	import onyx.events.ConsoleEvent;
	
	public final class DisplayStartState extends ApplicationState {

		/**
		 * 	@private
		 */
		private var _image:DisplayObject;
		
		/**
		 * 	@private
		 */
		private var _label:TextField		= new TextField(200,125);
		
		/**
		 * 	Initialize
		 */
		override public function initialize(... rest:Array):void {
			
			// create the image and a label
			_image = new OnyxStartUpImage();
			
			// add the children
			UIManager.root.addChild(_image);
			UIManager.root.addChild(_label);
			
			// listen for mouse clicks
			UIManager.root.addEventListener(MouseEvent.MOUSE_DOWN,	_captureEvents,	true, -1);
			UIManager.root.addEventListener(MouseEvent.MOUSE_UP,	_captureEvents,	true, -1);
			
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
			
			var stage:Stage = UIManager.root;
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
			UIManager.root.removeEventListener(Event.ADDED, _onItemAdded);
			
			// remove listener for mouse clicks
			UIManager.root.removeEventListener(MouseEvent.MOUSE_DOWN,	_captureEvents,	true);
			UIManager.root.removeEventListener(MouseEvent.MOUSE_UP,		_captureEvents,	true);

			// remove items
			UIManager.root.removeChild(_image);
			UIManager.root.removeChild(_label);
			
			// clear references
			_image = null;
			_label = null;
		}
	}
}