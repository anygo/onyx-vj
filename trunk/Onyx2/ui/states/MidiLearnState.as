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
	
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;
	import flash.geom.ColorTransform;
	
	import onyx.constants.*;
	import onyx.states.*;
	import onyx.events.*;
	import onyx.net.*;
	import onyx.core.Console;
	
	import ui.controls.UIControl;
	import ui.styles.*;
	import ui.controls.*;
	import ui.core.MidiManager;

	public final class MidiLearnState extends ApplicationState {
		
		private var _control:UIControl;
		private var _client:NthClient;
		
		public function MidiLearnState():void {
		}
		
		override public function initialize():void {
			// Highlight all the controls
			for (var i:Object in UIControl.controls) {
				var control:UIControl = i as UIControl;
				UIControl.controls[control] = control.transform.colorTransform;
				control.transform.colorTransform = MIDI_HIGHLIGHT;
			}
			STAGE.addEventListener(MouseEvent.MOUSE_DOWN, _onMouseDown, true, 9999);
		}
		
		private function _onMouseDown(event:MouseEvent):void {
			event.stopPropagation();
			
    		// Find which control we hit
    		_control = null;
			for (var i:Object in UIControl.controls) {
				if ( i == event.target.parent ) {
					_control = i as UIControl;
					break;
				}
			}
			// Unhighlight everything except that control
			_unHighlight(_control);
			if ( _control == null ) {
				// Clicked outside any control - abort learning
				StateManager.removeState(this);
			} else {
				_client = NthClient.getInstance();
	    		_client.addEventListener(MidiEvent.NOTEON,_onNoteon);
	    		_client.addEventListener(MidiEvent.CONTROLLER,_onController);
	  		}
		}
		private function _onNoteon(e:MidiEvent):void {
			if ( _control is ButtonClear ) {
				MidiManager.registerNote(_control,e);
			} else {
				Console.output("You need to use a MIDI controller (not a note) for that!");
			}
			StateManager.removeState(this);
		}
		
		private function _onController(e:MidiEvent):void {
			if ( _control is SliderV ) {
				MidiManager.registerController(_control,e);
			} else {
				Console.output("You need to use a MIDI note (not a controller) for that!");
			}
			StateManager.removeState(this);
		}
		
		override public function terminate():void {
			STAGE.removeEventListener(MouseEvent.MOUSE_DOWN, _onMouseDown, true);
			if ( _client ) {
				_client.removeEventListener(MidiEvent.NOTEON,_onNoteon);
				_client.removeEventListener(MidiEvent.CONTROLLER,_onController);
				_client = null;
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