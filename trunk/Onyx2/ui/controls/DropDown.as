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
	
	import onyx.controls.Control;
	import onyx.controls.ControlRange;
	import onyx.events.ControlEvent;
	
	import ui.text.Style;
	import ui.text.TextField;
	
	public final class DropDown extends UIControl {
		
		public static const ITEM_HEIGHT:int	= 12;

		private var _width:int;
		private var _label:TextField;
		private var _control:ControlRange;
		private var _index:int;
		private var _button:ButtonClear;
		private var _data:Array;
		private var _items:Array;
		private var _selectedIndex:Option;
		private var _bind:String;
		
		public function DropDown(options:UIOptions, range:Control, align:String = 'left', bind:String = null):void {
			
			var control:ControlRange = range as ControlRange;
			
			super(options, true, control.display);
			
			_bind = bind;
			_width = options.width;
			
			_control = control;
			_control.addEventListener(ControlEvent.CONTROL_CHANGED, _onChanged);
			
			// assign the data provider
			_data = control.data;
			
			// draw
			_draw(options.width, options.height, align);

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
		
		private function _draw(width:int, height:int, align:String, drawBG:Boolean = false):void {

			_button	= new ButtonClear(width, height);
						
			_label		= new TextField(width, 9, align);
			_label.x	= 2;
			_label.y	= 1;

			addChild(_label);
			addChild(_button);
		}
		
		private function _onPress(event:MouseEvent):void {
			
			_items = [];
			_index = _data.indexOf(_control.value);
			
			var local:Point = localToGlobal(new Point(0,0));
			var start:int = Math.max(local.y - (_index * ITEM_HEIGHT), 0 - local.y) ;

			graphics.lineStyle(0, 0x96abbc, .5);
			graphics.drawRect(-1, start - local.y - 1, _width + 1, _data.length * ITEM_HEIGHT + 2);
			
			for (var count:int = 0; count < _data.length; count++) {
				
				var item:Option	= new Option(
					(_bind) ? (_data[count] ? _data[count][_bind] : 'None') : _data[count], count, _width, _label.align, _bind)
				;
				
				item.addEventListener(MouseEvent.MOUSE_OVER, _onRollOver);
				item.addEventListener(MouseEvent.MOUSE_OUT, _onRollOut);
				
				item.y = start - local.y;
				start += ITEM_HEIGHT;
				
				_items.push(item);
				addChild(item);

			}
			
			stage.addEventListener(MouseEvent.MOUSE_UP, _onRelease);
		}
		
		private function _onRelease(event:MouseEvent):void {
			
			graphics.clear();

			if (_selectedIndex) {
				_index = _selectedIndex.index;
				_control.value = _control.data[_index];
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

			_label.text = (_bind && value) ? value[_bind] || 'None' : value || 'None';

		}
		
		override public function dispose():void {
			
			_control.removeEventListener(ControlEvent.CONTROL_CHANGED, _onChanged);
			
			// add listeners			
			_button.removeEventListener(MouseEvent.MOUSE_DOWN, _onPress);
			_button.removeEventListener(MouseEvent.MOUSE_WHEEL, _onWheel);
			
			super.dispose();
		}
	}
}

import ui.text.TextField;
import ui.text.Style;
import flash.display.Sprite
import ui.controls.DropDown;

final class Option extends Sprite {
	
	private var _label:TextField;

	public var index:int;
	
	public function Option(text:String, index:int, width:int, align:String, bind:String = null):void {
		
		this.index = index;
		
		_label				= new TextField(width, 9, align);
		_label.x			= 2;
		_label.y			= 1;
		_label.text = text.toUpperCase();
		
		graphics.beginFill(Style.DEFAULT_GREY);
		graphics.drawRect(0, 0, width, DropDown.ITEM_HEIGHT);
		graphics.endFill();

		addChild(_label);
		
		cacheAsBitmap	= true;
	}
	
	public function draw(color:int, width:int):void {
		graphics.clear();
		
		graphics.beginFill(color);
		graphics.drawRect(0, 0, width, DropDown.ITEM_HEIGHT);
		graphics.endFill();

	}
	
	public function dispose():void {
		
		parent.removeChild(this);
		removeChild(_label);
		_label = null;
		
	}
	
}