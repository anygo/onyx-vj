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
package ui.states {
	
	import flash.display.*;
	import flash.events.MouseEvent;
	import flash.geom.*;
	import flash.utils.Dictionary;
	
	import onyx.constants.*;
	import onyx.states.*;
	import onyx.events.*;
	import onyx.net.*;
	import onyx.core.*;
	
	import ui.controls.UIControl;
	import ui.styles.*;
	import ui.controls.*;
	import onyx.midi.*;
	import onyx.controls.ControlRange;

	public final class MidiLearnState extends ApplicationState {
		
		private var _control:UIControl;
		private var _client:NthEventClient;
		private var _midi:Midi;
		
		/**
		 * 	@constructor
		 */
		public function MidiLearnState():void {
			_midi = Midi.getInstance();
		}
		
		/**
		 * 	initialize
		 */
		override public function initialize():void {
			// Highlight all the controls
			for (var i:Object in UIControl.controls) {
				var control:UIControl = i as UIControl;
				UIControl.controls[control] = control.transform.colorTransform;
				control.transform.colorTransform = MIDI_HIGHLIGHT;
			}
			
			STAGE.addEventListener(MouseEvent.MOUSE_DOWN, _onControlSelect, true, 9999);
		}

		/**
		 * 	@private
		 */
		private function _onControlSelect(event:MouseEvent):void {
			
			var objects:Array		= STAGE.getObjectsUnderPoint(new Point(STAGE.mouseX, STAGE.mouseY));
			
			// loop for UIControls
			_control = null;
			for each (var object:DisplayObject in objects) {
				_control = object.parent as UIControl;
				if (_control) {
					break;
				}
			}
			event.stopPropagation();
			
			_unHighlight(_control); // Unhighlight everything except selected control
			if ( _control == null ) {
				// Clicked outside any control - abort learning
				StateManager.removeState(this);
			} else {
				// Wait for a MIDI noteon or controller event
				_client = NthEventClient.getInstance();
	    		_client.addEventListener(MidiMsg.NOTEON,_onNoteOn);
	    		_client.addEventListener(MidiMsg.NOTEOFF,_onNoteOff);
	    		_client.addEventListener(MidiMsg.CONTROLLER,_onController);
	  		}
		}
		
		private function _onNoteOn(e:MidiEvent):void {
			if ( _control is ButtonControl ) {
				_midi.registerNoteOn(_control.control,e.deviceIndex,e.midimsg as MidiNoteOn);
			} else {
				Console.output("You need to map a MIDI controller to that control!");
			}
			StateManager.removeState(this);
		}
		
		private function _onNoteOff(e:MidiEvent):void {
			if ( _control is ButtonControl ) {
				_midi.registerNoteOff(_control.control,e.deviceIndex,e.midimsg as MidiNoteOff);
			} else {
				Console.output("You need to map a MIDI controller to that control!");
			}
			StateManager.removeState(this);
		}
		
		private function _onController(e:MidiEvent):void {
			if ( _control is SliderV || _control is DropDown || _control is ButtonControl ) {
				_midi.registerController(_control.control,e);
			} else {
				Console.output("That control can't be mapped!");
			}
			StateManager.removeState(this);
		}
		
		/**
		 * 	Remove state
		 */
		override public function terminate():void {
			
			STAGE.removeEventListener(MouseEvent.MOUSE_DOWN, _onControlSelect, true);
	   		if ( _client ) {
				_client.removeEventListener(MidiMsg.NOTEON,_onNoteOn);
				_client.removeEventListener(MidiMsg.NOTEOFF,_onNoteOff);
	   			_client.removeEventListener(MidiMsg.CONTROLLER,_onController);
	   		}
	   		_unHighlight();
		}

    	// Turn off the highlight on all the controls except ex
		private function _unHighlight(ex:Object = null):void {
			for (var i:Object in UIControl.controls) {
				if ( i != ex ) {
					var control:UIControl = i as UIControl;
					control.transform.colorTransform = UIControl.controls[control] || new ColorTransform();
					UIControl.controls[control] = null;
				}
			}
		}
		
	}
}