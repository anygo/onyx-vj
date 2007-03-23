/** 
 * Copyright (c) 2007, www.onyx-vj.com
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
package ui.core {
	
	import flash.utils.Dictionary;
	
	import ui.controls.*
	import onyx.events.MidiEvent;
	

	/**
	 * 	Manage mappings of MIDI events to controls
	 */
	public class MidiManager {
		
		private static var _map:Dictionary = new Dictionary();
		
		public static function registerController(ct:UIControl, e:MidiEvent):void {
			_map[ct] = {device:e.device(), channel:e.channel(), controller:e.controller()};
			trace("_map[",ct,"] = device/",_map[ct].device," channel/",_map[ct].channel," controller/",_map[ct].controller);
		}
		public static function registerNote(ct:UIControl, e:MidiEvent):void {
			_map[ct] = {device:e.device(), channel:e.channel(), pitch:e.pitch()};
			trace("_map[",ct,"] = device/",_map[ct].device," channel/",_map[ct].channel," pitch/",_map[ct].pitch);
		}
		public static function deregisterController(ct:UIControl):void {
			delete _map[ct];
		}
	}
}