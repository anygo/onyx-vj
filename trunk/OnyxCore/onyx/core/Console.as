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
package onyx.core {
	
	import flash.events.EventDispatcher;
	
	import onyx.display.Display;
	import onyx.events.ConsoleEvent;

	public final class Console extends EventDispatcher {
		
		public static const MESSAGE_NONE:int	= 0;
		public static const MESSAGE_SYSTEM:int	= 1;
		
		private static const dispatcher:EventDispatcher	= new EventDispatcher();
		
		public static function getInstance():EventDispatcher {
			return dispatcher;
		}
		
		public static function output(... args:Array):void {
			
			dispatcher.dispatchEvent(
				new ConsoleEvent(args.join(' '))
			);
		}
		
		public static function executeCommand(command:String):void {
			
			var command:String = command.toLowerCase();
			
			var commands:Array = command.split(' ');
			
			if (commands.length) {
				var firstcommand:String = commands.shift();
				
				if (Command[firstcommand]) {
					var fn:Function = Command[firstcommand];
					
					try {
						var message:String = fn.apply(null, commands);
					} catch (e:Error) {
						output(e.message);
					}
				}
			}
		}
		
		public function Console():void {
			throw ErrorDescription.INVALID_CLASS_CREATION;
		}

	}
}