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
	
	import onyx.controls.ControlRange;
	import onyx.events.ControlEvent;
	
	import ui.text.Style;
	import ui.text.TextField;
	
	public final class DropDown extends UIControl {
		
		public static const ITEM_HEIGHT:int	= 10;

		private var _width:int;
		private var _label:TextField;
		private var _control:ControlRange;
		private var _index:int;
		private var _button:ButtonClear;
		private var _data:Array;
		private var _items:Array;
		private var _selectedIndex:Option;
		private var _bind:String;
		
		public function DropDown(control:ControlRange, drawBG:Boolean = false, width:int = 50, height:int = 10, align:String = 'left', bind:String = null):void {
			
			_bind = bind;
			_width = width;
			
			_control = control;
			_control.addEventListener(ControlEvent.CONTROL_CHANGED, _onChanged);
			
			// assign the data provider
			_data = control.data;
			
			// draw
			_draw(width, height, align);

			// add listeners			
			_button.addEventListener(MouseEvent.MOUSE_DOWN, _onPress);

			// get value
			var value:* = control.value;
			
			_index		= _data.indexOf(value);
			setText(_index);
			
			// cache
			cacheAsBitmap = true;

		}
		
		private function _onChanged(event:ControlEvent):void {
			setText(event.value);
		}
		
		private function _draw(width:int, height:int, align:String, drawBG:Boolean = false):void {

			_button	= new ButtonClear(width, height);

			super.background = drawBG;
			
			_label		= new TextField(width, ITEM_HEIGHT, align);
			_label.y	= 1;

			addChild(_label);
			addChild(_button);
		}
		
		private function _onPress(event:MouseEvent):void {
			
			_items = [];
			
			var local:Point = localToGlobal(new Point(0,0));
			var start:int = Math.max(local.y - (_index * ITEM_HEIGHT), 0 - local.y) + 1;
			
			for (var count:int = 0; count < _data.length; count++) {
				
				var item:Option	= new Option(
					(_bind) ? (_data[count] ? _data[count][_bind] : 'None') : _data[count], count, _width, _label.align, _bind)
				;
				
				item.addEventListener(MouseEvent.MOUSE_OVER, _onRollOver);
				item.addEventListener(MouseEvent.MOUSE_OUT, _onRollOut);
				
				item.y = start - local.y;
				start += 10;
				
				_items.push(item);
				addChild(item);

			}
			
			stage.addEventListener(MouseEvent.MOUSE_UP, _onRelease);
			
		}
		
		private function _onRelease(event:MouseEvent):void {
			
			if (_selectedIndex) {
				_index = _selectedIndex.index;
				_control.value = _index;
			}
			
			for each (var item:Option in _items) {
				item.removeEventListener(MouseEvent.MOUSE_OVER, _onRollOver);
				item.removeEventListener(MouseEvent.MOUSE_OUT, _onRollOut);
				item.dispose();
			}
			
			_selectedIndex = null;
			_items = null;
		}
		
		private function _onRollOver(event:MouseEvent):void {
			var option:Option = event.currentTarget as Option;
			_selectedIndex = option;
			option.draw(Style.DEFAULT_HIGHLIGHT, _width);
		}

		private function _onRollOut(event:MouseEvent):void {
			var option:Option = event.currentTarget as Option;
			_selectedIndex = null;
			option.draw(Style.DEFAULT_GREY, _width);
		}
		
		public function setText(value:*):void {

			if (value is Number) {
				_index = value;
				_label.text = String(_data[_index]);
			} else {
				_index = _data.indexOf(value);
				_label.text = (_bind && value) ? value[_bind] : (value === null) ? '' : value;

			}			
		}
	}
}

import ui.text.TextField;
import ui.text.Style;
import flash.display.Sprite

final class Option extends Sprite {
	
	public static const ITEM_HEIGHT:int = 10;
	
	private var _label:TextField;

	public var index:int;
	
	public function Option(text:String, index:int, width:int, align:String, bind:String = null):void {
		
		this.index = index;
		
		_label				= new TextField(width, 13, align);
		_label.text = text;
		
		graphics.beginFill(Style.DEFAULT_GREY);
		graphics.drawRect(0, 0, width, ITEM_HEIGHT);
		graphics.endFill();

		addChild(_label);
		
		cacheAsBitmap = true;
	}
	
	public function draw(color:int, width:int):void {
		graphics.clear();
		
		graphics.beginFill(color);
		graphics.drawRect(0, 0, width, ITEM_HEIGHT);
		graphics.endFill();

	}
	
	public function dispose():void {
		
		parent.removeChild(this);
		removeChild(_label);
		_label = null;
		
	}
	
}