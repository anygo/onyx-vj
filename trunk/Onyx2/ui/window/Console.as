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