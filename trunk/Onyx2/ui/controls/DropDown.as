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
package ui.controls {
	
	import flash.display.Shape;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import onyx.constants.POINT;
	import onyx.controls.Control;
	import onyx.controls.ControlRange;
	import onyx.events.ControlEvent;
	
	import ui.styles.*;
	import ui.text.TextField;
	
	/**
	 * 	Drop down control (relates to ControlRange)
	 */
	public final class DropDown extends UIControl {
		
		/**
		 * 	Option heights
		 */
		public static const ITEM_HEIGHT:int	= 12;

		/**
		 * 	@private
		 */
		private var _width:int;

		/**
		 * 	@private
		 */
		private var _label:TextField;

		/**
		 * 	@private
		 */
		private var _index:int;

		/**
		 * 	@private
		 */
		private var _button:ButtonClear;

		/**
		 * 	@private
		 */
		private var _data:Array;

		/**
		 * 	@private
		 */
		private var _items:Array;

		/**
		 * 	@private
		 */
		private var _selectedIndex:Option;
		
		/**
		 * 	@constructor
		 */
		public function DropDown(options:UIOptions, icontrol:Control):void {
			
			var control:ControlRange = icontrol as ControlRange;

			// super!
			super(options, control, true, control.display);
			
			// set width
			_width = options.width;

			// listen for changes			
			_control.addEventListener(ControlEvent.CHANGE, _onChanged);
			
			// assign the data provider
			_data = control.data;
			
			// draw
			_draw(options.width, options.height);

			// add listeners			
			_button.addEventListener(MouseEvent.MOUSE_DOWN, _onPress);
			_button.addEventListener(MouseEvent.MOUSE_WHEEL, _onWheel);

			// get value
			var value:* = control.value;
			
			_index		= _data.indexOf(value);
			
			setText(control.value);
			
			// cache
			cacheAsBitmap = true;
		}
		
		/**
		 * 	@private
		 */
		private function _onWheel(event:MouseEvent):void {
			if (event.delta > 0) {
				if (_index > 0) {
					_control.value = _data[--_index];
				}
			} else {
				if (_index < _data.length - 1) {
					_control.value = _data[++_index];
				}
			}
		}
		
		/**
		 * 	@private
		 */
		private function _onChanged(event:ControlEvent):void {
			setText(event.value);
		}
		
		/**
		 * 	@private
		 */
		private function _draw(width:int, height:int, drawBG:Boolean = false):void {

			_button	= new ButtonClear(width, height);
						
			_label		= new TextField(width, 9);
			_label.x	= 2;
			_label.y	= 1;

			addChild(_label);
			addChild(_button);
		}
		
		/**
		 * 	@private
		 */
		private function _onPress(event:MouseEvent):void {
			
			var control:ControlRange	= _control as ControlRange;

			// create an items array
			var items:Array				= [];
			_index						= _data.indexOf(control.value);
			
			var local:Point = localToGlobal(POINT);
			var start:int = Math.max(local.y - (_index * ITEM_HEIGHT), 0 - local.y) ;

			graphics.lineStyle(0, LINE_DEFAULT, .5);
			graphics.drawRect(-1, start - local.y - 1, _width + 1, _data.length * ITEM_HEIGHT + 2);
			
			var len:int = _data.length;
			
			for (var count:int = 0; count < len; count++) {
				
				var item:Option	= new Option(
					(control.binding) ? (_data[count] ? _data[count][control.binding] : 'None') : _data[count] || 'off', count, _width, control.binding)
				;
				
				item.addEventListener(MouseEvent.MOUSE_OVER, _onRollOver);
				item.addEventListener(MouseEvent.MOUSE_OUT, _onRollOut);
				
				item.y = start - local.y;
				start += ITEM_HEIGHT;
				
				items.push(item);
				addChild(item);

			}
			
			_items = items;
			
			stage.addEventListener(MouseEvent.MOUSE_UP, _onRelease);
		}
		
		/**
		 * 	@private
		 */
		private function _onRelease(event:MouseEvent):void {

			var control:ControlRange	= _control as ControlRange;
			
			graphics.clear();

			if (_selectedIndex) {
				
				_index = _selectedIndex.index;
				control.value = control.data[_index];
				
			}
			
			// kill all the items
			for each (var item:Option in _items) {
				item.removeEventListener(MouseEvent.MOUSE_OVER, _onRollOver);
				item.removeEventListener(MouseEvent.MOUSE_OUT, _onRollOut);
				item.dispose();
			}
			
			_selectedIndex = null;
			_items = null;
		}

		/**
		 * 	@private
		 */
		private function _onRollOver(event:MouseEvent):void {
			var option:Option = event.currentTarget as Option;
			_selectedIndex = option;
			option.draw(DROPDOWN_HIGHLIGHT, _width);
		}

		/**
		 * 	@private
		 */
		private function _onRollOut(event:MouseEvent):void {
			var option:Option = event.currentTarget as Option;
			_selectedIndex = null;
			option.draw(DROPDOWN_DEFAULT, _width);
		}
		
		/**
		 * 	Sets text to a value
		 */
		public function setText(value:*):void {
			var control:ControlRange	= _control as ControlRange;
			_label.text = (control.binding && value) ? value[control.binding] || 'None' : value || 'None';

		}
		
		/**
		 * 	Dispose
		 */
		override public function dispose():void {
			
			// remove value listening
			_control.removeEventListener(ControlEvent.CHANGE, _onChanged);
			
			// add listeners			
			_button.removeEventListener(MouseEvent.MOUSE_DOWN, _onPress);
			_button.removeEventListener(MouseEvent.MOUSE_WHEEL, _onWheel);
			
			_label 	= null;
			_button = null;
			_control = null;
			
			super.dispose();
		}
	}
}

import flash.display.Sprite

import ui.text.TextField;
import ui.controls.DropDown;
import ui.styles.*;

final class Option extends Sprite {
	
	private var _label:TextField;

	public var index:int;
	
	public function Option(text:String, index:int, width:int, bind:String = null):void {
		
		this.index = index;
		
		_label				= new TextField(width, 9);
		_label.x			= 2;
		_label.y			= 1;
		_label.text			= text ? text.toUpperCase() : '';
		
		graphics.beginFill(DROPDOWN_DEFAULT);
		graphics.drawRect(0, 0, width, DropDown.ITEM_HEIGHT);
		graphics.endFill();

		addChild(_label);
	}
	
	public function draw(color:int, width:int):void {
		graphics.clear();
		
		graphics.beginFill(color);
		graphics.drawRect(0, 0, width, DropDown.ITEM_HEIGHT);
		graphics.endFill();

	}
	
	public function dispose():void {
		
		if (parent) {
			parent.removeChild(this);
			removeChild(_label);
			_label = null;
		}
	}
	
}