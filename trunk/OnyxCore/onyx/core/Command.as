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

	import onyx.application.Onyx;
	import onyx.display.Display;
	import onyx.layer.Layer;
	import onyx.jobs.StatJob;
	
	use namespace onyx_internal;

	public final class Command {
		
		public static function help(... args:Array):void {
			
			var text:String;
			
			switch (args[0]) {
				case 'command':
				case 'commands':
				
					text =	_createHeader('commands') + 'plugins: shows # of plugins<br>' +
							'clear: clears the text<br>' +
							'stat [time:int]:	tests all layers for average rendering time';
				
					break;
				case 'contributors':
					text =	'contributors<br>-------------<br>Daniel Hai: http://www.danielhai.com'
					break;
				case 'plugins':
					text =	Onyx.filters.length + ' filters loaded.<br>' +
							Onyx.transitions.length + ' transitions loaded.';
					break;
				case 'stat':
					text =	_createHeader('stat') + 'tests framerate and layer rendering times.<br><br>usage: stat [numSeconds:int]<br>';
					break;
				default:
					text =	_createHeader('<b>onyx 3.0b</b>', 21) + 
							'copyright 2003-2006: www.onyx-vj.com.' +
							'<br>enter command "help commands" for more information about commands.';
					break;
			}
			// dispatch the start-up motd
			Console.output(text);
	
		}
		
		private static function _createHeader(command:String, size:int = 14):String {
			return '<font size="' + size + '" color="#DCC697">' + command + '</font><br><br>';
		}
		
		/**
		 * 	Finds out
		 */
		public static function stat(... args:Array):void {
			
			// does a stat job for a specified amount of time
			var time:int = args[0] || 2;
			
			var job:StatJob = new StatJob(time);
		}
	}
}