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

	import flash.display.Shape;
	import flash.events.*;
	import flash.geom.*;
	import flash.system.System;
	import flash.utils.*;
	
	import onyx.controls.*;
	import onyx.core.*;
	import onyx.display.*;
	import onyx.events.TempoEvent;
	
	import ui.controls.*;
	import ui.core.UIObject;

	public final class SettingsWindow extends Window {
		
		/**
		 * 	@private
		 */
		private static const TRANSFORM_NORMAL:ColorTransform = new ColorTransform(1,1,1);

		/**
		 * 	@private
		 */
		private static const TRANSFORM_WHITE:ColorTransform = new ColorTransform(2,2,2);
		
		/**
		 * 	@private
		 */
		private var _controlXY:SliderV2;

		/**
		 * 	@private
		 */
		private var _controlScale:SliderV2;

		/**
		 * 	@private
		 */
		private var _controlColor:ColorPicker;

		/**
		 * 	@private
		 */
		private var _controlXML:TextButton;

		/**
		 * 	@private
		 */
		private var _controlSize:DropDown;
		
		/**
		 * 	@private
		 */
		private var _controlTempo:SliderV;
		
		/**
		 * 	@private
		 */
		private var _tapTempo:TempoShape	= new TempoShape();
		
		/**
		 * 	@private
		 */
		private var _releaseTimer:Timer		= new Timer(50);
		
		/**
		 * 	@private
		 */
		private var _samples:Array			= [0];
		
		/**
		 * 
		 */
		private var _tempo:Tempo			= Tempo.getInstance();
		
		/**
		 * 	@constructor
		 */
		public function SettingsWindow(display:IDisplay):void {
			
			super('SETTINGS WINDOW', 202, 100, 200, 522);
			
			var control:Control, controls:Controls;

			// create new ui options
			var options:UIOptions	= new UIOptions();
			options.width			= 50;
			
			// get controls for the display
			controls				= display.controls;
			control					= new ControlRange('size', 'size', DisplaySize.SIZES, 0, 'name');
			control.target			= display;

			// controls for display
			_controlXY				= new SliderV2(options, controls.getControl('position'));
			_controlColor			= new ColorPicker(options, controls.getControl('backgroundColor'));
			_controlXML				= new TextButton(options, 'save layers');
			_controlSize			= new DropDown(options, control, 'left');
			
			// tempo controls
			_controlTempo			= new SliderV(options, _tempo.controls.getControl('tempo'));
			
			// add controls
			addChildren(	
				_controlXY,		2,	24,
				_controlColor,	2,	70,
				_controlXML,	2,	83,
				_controlSize,	60,	24,
				_controlTempo,	60,	70,
				_tapTempo,		60,	83
			);

			// start the timer
			_tempo.addEventListener(TempoEvent.CLICK, _onTempo);
			
			// tap tempo click
			_tapTempo.addEventListener(MouseEvent.MOUSE_DOWN, _onTempoDown);
			
			// xml
			_controlXML.addEventListener(MouseEvent.MOUSE_DOWN, _onMouseDown);
			
		}

		/**
		 * 	@private
		 */
		private function _onTempoDown(event:Event):void {
			
			var time:int = getTimer();
			
			if (time - _samples[_samples.length - 1] > 1000) {
				_samples = [time];
			} else {
				_samples.push(time);
			}
			
			if (_samples.length > 2) {

				var total:int	= 0;
	
				for (var count:int = 1; count < _samples.length; count++) {
					total += _samples[count] - _samples[count - 1];
				}

				total /= (count - 1);
				_tempo.tempo = total;
			} else {
				_tempo.start();
			}
			
			if (_samples.length > 8) {
				_samples.shift();
			}

		}
		
		/**
		 * 	@private
		 */
		private function _onTempo(event:TempoEvent):void {
			_tapTempo.transform.colorTransform = TRANSFORM_WHITE;
			_releaseTimer.addEventListener(TimerEvent.TIMER, _onTempoOff);
			_releaseTimer.start();
		}
		
		/**
		 * 	@private
		 */
		private function _onTempoOff(event:TimerEvent):void {
			_tapTempo.transform.colorTransform = TRANSFORM_NORMAL;
			_releaseTimer.removeEventListener(TimerEvent.TIMER, _onTempoOff);
			_releaseTimer.stop();
		}
		
		/**
		 * 	@private
		 */
		private function _onMouseDown(event:MouseEvent):void {
			var display:Display = Onyx.displays[0];
			var text:String		= display.toXML().normalize();
			
			var popup:TextControlPopUp = new TextControlPopUp(this, 200, 200, 'Copied to clipboard\n\n' + text);

			// saves breaks
			var arr:Array = text.split(String.fromCharCode(10));
			text		= arr.join(String.fromCharCode(13,10));
			
			System.setClipboard(text);
			
			event.stopPropagation();
		}
	}
}

import flash.display.Sprite;

class TempoShape extends Sprite {
	
	/**
	 * 	@constructor
	 */
	public function TempoShape():void {
		
		mouseChildren = false;
		graphics.beginFill(0xAAAAAA);
		graphics.drawRect(0,0,20,10);
		graphics.endFill();
		
		cacheAsBitmap = true;
	}
}