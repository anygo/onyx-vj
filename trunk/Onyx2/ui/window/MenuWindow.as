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
	
	import flash.utils.Dictionary;
	
	import onyx.errors.*;
	
	import ui.controls.TextButton;
	import ui.styles.MENU_OPTIONS;
	import ui.controls.MenuButton;
	import flash.events.MouseEvent;
	
	/**
	 * 	Menu Window
	 */
	public final class MenuWindow extends Window {
		
		/**
		 * 	@private
		 */
		private static const windows:Array = [];
		
		/**
		 * 	@private
		 */
		private static const definition:Dictionary = new Dictionary(true);
		
		/**
		 * 	Registers windows
		 */
		public static function register(... args:Array):void {
			
			for each (var reg:WindowRegistration in args) {
				
				definition[reg.name] = reg;
				windows.push(reg);
				
				instance.createButton(reg);
			}
		}
		
		/**
		 * 	Returns the instance
		 */
		public static const instance:MenuWindow		= new MenuWindow();

		/**
		 * 	@constructor
		 */
		public function MenuWindow():void {
			
			// position and create window
			super(null, 100, 100, 200, 744);

		}
		
		/**
		 * 	@private
		 * 	Creates a button related to the window class
		 */
		private function createButton(reg:WindowRegistration):void {
			
			// get index
			var index:int = windows.indexOf(reg);
			
			// create control
			var control:MenuButton = new MenuButton(reg, MENU_OPTIONS);
			control.x = (index % 6) * (MENU_OPTIONS.width + 2);
			control.y = Math.floor(index / 6) * (MENU_OPTIONS.height + 2);

			addChild(control);
			
		}
	}
}