package ui.controls {
	
	import flash.display.Sprite;
	import ui.core.UIObject;
	import ui.text.TextInput;
	import flash.events.MouseEvent;
	import onyx.controls.ControlString;
	
	public final class TextControlPopUp extends UIObject {

		private var _input:TextInput;
		private var _control:ControlString;

		public function TextControlPopUp(width:int, height:int):void {
			
			displayBackground(width, height);
			
			_input				= new TextInput(width - 4, height - 4);
			_input.multiline	= true;
			_input.x			= 2;
			_input.y			= 2;
			
			addChild(_input);
			
			mouseEnabled	= false;
			mouseChildren	= true;
		}
		
		/**
		 * 	Sets text
		 */
		public function set text(value:String):void {
			_input.text = value;
			_input.setSelection(0, value.length - 1);
		}
		
		/**
		 * 	Gets text
		 */
		public function get text():String {
			return _input.text;
		}
	}
}