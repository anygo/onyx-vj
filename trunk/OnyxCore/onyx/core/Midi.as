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
		private var _map:Dictionary = new Dictionary();

		public function Midi():void {
			if ( !_creating ) {
				throw new Error("Use Midi.getInstance()!");
			}
			_client = NthClient.getInstance();
			_controls = new Controls(this,
				new ControlRange('listen', 'midi control', BOOLEAN)
				);
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
			_client.addEventListener(MidiEvent.NOTEOFF, _onNoteoff);
			_client.addEventListener(MidiEvent.PROGRAM, _onProgram);
			_client.addEventListener(MidiEvent.CONTROLLER, _onController);
		}
		
		public function stop():void {
			_client.removeEventListener(MidiEvent.NOTEON, _onNoteon);
			_client.removeEventListener(MidiEvent.NOTEOFF, _onNoteoff);
			_client.removeEventListener(MidiEvent.PROGRAM, _onProgram);
			_client.removeEventListener(MidiEvent.CONTROLLER, _onController);
		}
		
		public function _onNoteon(e:MidiEvent):void {
			trace("got NoteOn");
			dispatchEvent(new Event(Event.CHANGE));
		}
		public function _onNoteoff(e:MidiEvent):void {
			trace("got NoteOff");
			dispatchEvent(new Event(Event.CHANGE));
		}
		public function _onProgram(e:MidiEvent):void {
			trace("got Program");
			dispatchEvent(new Event(Event.CHANGE));
		}
		public function _onController(e:MidiEvent):void {
			trace("got Controller");
			dispatchEvent(new Event(Event.CHANGE));
		}
		public function dispose():void {
		}
		public function get controls():Controls {
			return _controls;
		}
	}
}