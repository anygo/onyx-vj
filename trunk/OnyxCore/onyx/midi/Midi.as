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
package onyx.midi {
	
	import flash.events.*;
	import flash.utils.*;
	
	import onyx.controls.*;
	import onyx.events.*;
	import onyx.net.*;
	import onyx.constants.*;
	import onyx.layer.*;
	import onyx.content.*;
	import onyx.display.Display;
	import onyx.layer.*;
 	import onyx.errors.INVALID_CLASS_CREATION;
	
	public class Midi extends EventDispatcher implements IControlObject {
		
		private static var _instance:Midi;
		private static var _creating:Boolean = false;
		
		private var _listen:Boolean = false;
		private var _controls:Controls;
		private var _client:NthEventClient;
		private var _map:Array = new Array();

		public function Midi():void {
			if ( !_creating ) {
				throw INVALID_CLASS_CREATION;
			}
			_client = NthEventClient.getInstance();
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
		
		public function registerLayers(layers:Array):void {
			for each (var layer:Layer in layers) {
				layer.addEventListener(LayerEvent.LAYER_UNLOADED,_layerUnloaded);
			}
		}
		
		private function _layerUnloaded(event:LayerEvent):void {
			
			var target:Layer = event.currentTarget as Layer;
			var disp:Display = Display.getDisplay(0);
			
			target.removeEventListener(LayerEvent.LAYER_UNLOADED,_layerUnloaded);
			
			var layers:Array = disp.layers;
			for (var i:int=0; i<layers.length; i++){
				if (target == layers[i])
					break;
			}
			if (i==layers.length){
				trace("Couldn't find layer in _layerUnloaded!?");
				return;
			}
			// Remove maps for any constrols whose name begin
			// with this layer name.
			var layerName:String = i.toString();
			var lookfor:String = layerName + ".";
			for each (var m:MidiMap in _map) {
				var nm:String = disp.getNameOfControl(m.control);
				if ( nm.indexOf(lookfor) >= 0 ) {
					_removeMapForControl(m.control);
				}
			}
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
			_client.addEventListener(MidiEvent.CONTROLLER, _onController);
		}
		
		public function stop():void {
			_client.removeEventListener(MidiEvent.NOTEON, _onNoteon);
			_client.removeEventListener(MidiEvent.CONTROLLER, _onController);
		}
		
		public function _onNoteon(e:MidiEvent):void {
			trace("Don't know how to handle noteon messages yet");
		}
		
		private function _removeMapForControl(c:Control):void {
			for ( var i:int = 0; i<_map.length; i++ ) {
				if ((_map[i] as MidiMap).control == c) {
						break;
				}
			}
			if ( i < _map.length) {
				_map.splice(i,1);
			}
		}
		
		public function _onController(e:MidiEvent):void {
			for each (var m:MidiMap in _map) {
				if ( m is MidiMapController ) {
					if ( ! m.matchesEvent(e) && m.control != null ) {
						continue;
					}
					var f:Number = e.value() / 127.0;
					var c:Control = m.control;
					if ( c is ControlNumber ) {
						var cn:ControlNumber = c as ControlNumber;
						cn.value = cn.min + (cn.max - cn.min) * f;
					} else if ( c is ControlInt ) {
						var ci:ControlInt = c as ControlInt;
						ci.value = ci.min + (ci.max - ci.min) * f;
					} else {
						trace("Don't know how to handle that type of control");
					}
				} else if ( m is MidiMapNote ) {
					trace("MidiMapNote is not handled yet");
				} else {
					trace("Don't know how to handle that type of MidiMap");
				}
			}
		}
		
		/**
		 *  public
		 */
		public function registerController(c:Control, e:MidiEvent):void {
			var m:MidiMap = new MidiMapController(
				e.deviceIndex(), e.channel(), e.controller(), c);
			_registerMap(c,m);
		}
		
		public function registerNote(c:Control, e:MidiEvent):void {
			var m:MidiMap = new MidiMapNote(
				e.deviceIndex(), e.channel(), e.pitch(), c);
			_registerMap(c,m);
		}
		public function deregisterController(c:Control):void {
			_removeMapForControl(c);
		}
		
		public function dispose():void {
		}
		
		public function get controls():Controls {
			return _controls;
		}
		
		public function toXML():XML {
			var disp:Display = Display.getDisplay(0);
			var x:XML = <midi/>;
			for each (var m:MidiMap in _map) {
				var fullControlname:String = disp.getNameOfControl(m.control);
				if (fullControlname == null) {
					trace("Unable to find name of control!? ",m.control);
					continue;
				}
				if ( m is MidiMapController ) {
					var mc:MidiMapController = m as MidiMapController;
					x.appendChild( <mapcontroller>
								<deviceIndex>{mc.deviceIndex}</deviceIndex>
								<channel>{mc.channel}</channel>
								<controller>{mc.controller}</controller>
								<control>{fullControlname}</control>
								</mapcontroller> );
				} else if ( m is MidiMapNote ) {
					var mn:MidiMapNote = m as MidiMapNote;
					x.appendChild( <mapnote>
								<deviceIndex>{mn.deviceIndex}</deviceIndex>
								<channel>{mn.channel}</channel>
								<pitch>{mn.pitch}</pitch>
								<control>{fullControlname}</control>
								</mapnote> );
				}
			}
			return x;
		}
		
		public function loadXML(xml:XMLList):void {
			var display:Display = Display.getDisplay(0);
			for each (var xm:XML in xml.mapcontroller) {
				var deviceIndex:int = xm.deviceIndex;
				var c:Control = display.getControlByName(xm.control);
				if ( c == null ) {
					trace("Unable to find control=",xm.control);
					continue;
				}
				var m:MidiMap = new MidiMapController(
					xm.deviceIndex, xm.channel, xm.controller, c);
				_registerMap(c,m);
			}
		}
		
		private function _registerMap(c:Control, m:MidiMap):void {
			_removeMapForControl(c);
			_map.push(m);
		}
	}
}