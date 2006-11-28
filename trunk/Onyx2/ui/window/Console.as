package ui.window {
	
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	
	import onyx.core.Console;
	import onyx.core.onyx_internal;
	import onyx.events.ConsoleEvent;
	
	import ui.text.Style;
	import ui.text.TextField;
	import ui.text.TextInput;
	
	use namespace onyx_internal;
	
	public final class Console extends Window {
		
		private var _text:TextField;
		private var _input:TextInput;
		
		public function Console():void {
			
			onyx.core.Console.addEventListener(ConsoleEvent.CONSOLE_TRACE, _onConsole);
			
			_draw();
			
			_input.addEventListener(KeyboardEvent.KEY_DOWN, _onKeyDown);
			_input.addEventListener(MouseEvent.DOUBLE_CLICK, _onDoubleClick);

		}
		
		private function _onConsole(event:ConsoleEvent):void {
			_text.htmlText += event.message;
			_text.scrollV = _text.maxScrollV;
		}
		
		private function _draw():void {

			title = 'console';

			width = 190;
			height = 180;
			
			x = 6;
			y = 580;

			_text			= new TextField(187, 100);
			_text.multiline	= true;
			_text.wordWrap		= true;
			_text.x			= 2;
			_text.y			= 12;
			
			_input	= new TextInput(187, 10);
			_input.x  = 2;
			_input.y  = 168;
			_input.text = 'enter command here';
			_input.setSelection(0, _input.text.length);
			_input.background = true;
			_input.backgroundColor = 0x1f2a34;
			_input.doubleClickEnabled = true;

			addChild(_text);
			addChild(_input)
			
		}
		
		private function _onKeyDown(event:KeyboardEvent):void {
			switch (event.keyCode) {
				// execute
				case 13:
					onyx.core.Console.executeCommand(_input.text);
					_input.setSelection(0,_input.text.length);
					break;
			}
		}
		
		private function _onDoubleClick(event:MouseEvent):void {
			_input.setSelection(0,_input.text.length);
		}
		
	}
}