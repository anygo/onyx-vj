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
package onyx.core {
	
	import flash.events.*;
	import flash.utils.*;
	
	import onyx.controls.*;
	import onyx.events.*;
	import onyx.net.*;
	import onyx.constants.*;
	
	public class Midi extends EventDispatcher implements IControlObject {
		
		private static var _instance:Midi;
		private static var _creating:Boolean = false;
		
		private var _listen:Boolean = false;
		private var _controls:Controls;
		private var _client:NthClient;
		private var _map:Dictionary;

		public function Midi():void {
			if ( !_creating ) {
				throw new Error("Use Midi.getInstance()!");
			}
			_client = NthClient.getInstance();
			_controls = new Controls(this,
				new ControlRange('listen', 'midi control', BOOLEAN)
				);
			_map = new Dictionary();
		}
		public static function getInstance():Midi {
			if ( !_instance ) {
				_creating = true;
				_instance = new Midi();
				_creating = false;
			}
			return _instance;
		}
		public function set listen(value:Boolean):void {
			_listen = value;
			if ( _listen ) {
				start();
			} else {
				stop();
			}
		}
		public function get listen():Boolean {
			return _listen;
		}
		public function start():void {
			_client.addEventListener(MidiEvent.NOTEON, _onNoteon);
			_client.addEventListener(MidiEvent.PROGRAM, _onProgram);
			_client.addEventListener(MidiEvent.CONTROLLER, _onController);
		}
		
		public function stop():void {
			_client.removeEventListener(MidiEvent.NOTEON, _onNoteon);
			_client.removeEventListener(MidiEvent.PROGRAM, _onProgram);
			_client.removeEventListener(MidiEvent.CONTROLLER, _onController);
		}
		
		public function _onNoteon(e:MidiEvent):void {
			trace("Don't know how to handle noteon messages yet");
		}
		
		public function _onProgram(e:MidiEvent):void {
			trace("Don't know how to handle program messages yet");
		}
		
		public function _onController(e:MidiEvent):void {
			for ( var co:Object in _map ) {
				var c:Control = co as Control;
				var o:Object = _map[c];
				if (o.device == e.device() && o.channel == e.channel() && o.controller == e.controller() ) {
					var f:Number = e.value() / 127.0;
					if ( c is ControlNumber ) {
						var n:ControlNumber = c as ControlNumber;
						n.value = n.min + (n.max - n.min) * f;
					} else if ( c is ControlInt ) {
						var i:ControlInt = c as ControlInt;
						i.value = i.min + (i.max - i.min) * f;
					} else {
						trace("Don't know how to handle that type of control");
					}
				}
			}
		}
		
		public function registerController(ct:Control, e:MidiEvent):void {
			_map[ct] = {device:e.device(), channel:e.channel(), controller:e.controller()};
		}
		
		public function registerNote(ct:Control, e:MidiEvent):void {
			_map[ct] = {device:e.device(), channel:e.channel(), pitch:e.pitch()};
		}
		
		public function deregisterController(ct:Control):void {
			delete _map[ct];
		}
		
		public function dispose():void {
		}
		public function get controls():Controls {
			return _controls;
		}
	}
}