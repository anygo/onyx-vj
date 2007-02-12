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
package ui.core {
	
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	import flash.utils.getTimer;
	
	import onyx.core.IDisposable;
	
	import ui.text.TextField;
	import flash.utils.Timer;
	import flash.events.TimerEvent;

	/**
	 * 	Base UIObject Class
	 */
	public class UIObject extends Sprite {
		
		/**
		 * 	@private
		 * 	When mouse is clicked
		 */
		private static function _mouseDown(event:MouseEvent):void {
			
			var dispatcher:EventDispatcher = event.currentTarget as EventDispatcher;
			
			if (_doubleObject == dispatcher) {
				if (getTimer() - _doubleTime < 300) {
					event.stopPropagation();
					
					var e:MouseEvent = new MouseEvent(MouseEvent.DOUBLE_CLICK);
					e.ctrlKey	= event.ctrlKey;
					e.altKey	= event.altKey;
					e.shiftKey	= event.shiftKey;
					
					dispatcher.dispatchEvent(e);
				}
			}
			
			_doubleObject = dispatcher;
			_doubleTime = getTimer();
		}
		
		/**
		 * 	@private
		 */
		private static var _doubleObject:EventDispatcher;
		
		/**
		 * 	@private
		 */
		private static var _doubleTime:int;
		
		/**
		 * 	Stores the background shape
		 */		
		protected var background:Shape;

		/**
		 * 	@constructor
		 */
		public function UIObject(movesToTop:Boolean = false):void {

			if (movesToTop) {
				addEventListener(MouseEvent.MOUSE_DOWN, moveToTop);
			}
			
			tabEnabled = false;
		}
		
		/**
		 * 	Sets doubleClickEnabled
		 */
		public override function set doubleClickEnabled(s:Boolean):void {
			if (s) {
				addEventListener(MouseEvent.MOUSE_DOWN, _mouseDown, true);
			} else {
				removeEventListener(MouseEvent.MOUSE_DOWN, _mouseDown, true);
			}
		}
		
		/**
		 * 	Removes all children
		 */
		public function clearChildren():void {
			
			var numChildren:int = numChildren;
			for (var count:int = 0; count < numChildren; count++) {
				var child:DisplayObject = getChildAt(0);
				removeChild(child);
				
				if (child is IDisposable) {
					(child as IDisposable).dispose();
				}
			}
		}
		
		/**
		 * 	Highlights object with specified color
		 */
		public function highlight(color:uint, amount:Number):void {
			
			var transform:ColorTransform = new ColorTransform();
			
			var r:int = ((color & 0xFF0000) >> 16) * amount;
			var g:int = ((color & 0x00FF00) >> 8) * amount;
			var b:int = ((color & 0x0000FF)) * amount;
			
			var newcolor:int = r << 16 ^ g << 8 ^ b;
			
			transform.color = newcolor;
			transform.redMultiplier = 1-amount;
			transform.greenMultiplier = 1-amount;
			transform.blueMultiplier = 1-amount;
			
			this.transform.colorTransform = transform;
			
		}
		
		/**
		 * 	Moves to the top
		 */
		public function moveToTop(event:MouseEvent = null):void {
			
			if (parent) {
				parent.setChildIndex(this, parent.numChildren - 1);
			}
		}	
		
		/**
		 * 	Creates a background
		 */
		protected function displayBackground(width:int, height:int):void {
			if (!background) {
				background = new ControlShape(width, height);
				addChildAt(background, 0);
			}
		}

		/**
		 * 	Adds Children
		 */
		public function addChildren(... args:Array):void {
			
			var len:int = args.length;
			for (var count:int = 0; count < len; count+=3) {
				args[count].x = args[count+1];
				args[count].y = args[count+2];
				addChild(args[count]);
			}
		}

		/**
		 * 	Disposes the UIObject
		 */
		public function dispose():void {
			
			if (parent) {
				parent.removeChild(this);
			}
			
			clearChildren();
			
			removeEventListener(MouseEvent.MOUSE_DOWN, moveToTop, true);
		}

		
		/**
		 * 	Adds a label to the control
		 */
		protected function addLabel(name:String, align:String, width:int, height:int, offset:int = -8):void {
			
			var label:TextField = new TextField(width + 3, height);
			label.textColor		= 0x96abbc;
			label.align			= align || 'center';
			label.text			= name.toUpperCase();
			label.y				= offset;
			label.mouseEnabled	= false;

			addChild(label);
			
		}

	}
}


import flash.display.Shape;

/**
 * 	Stores shape
 */
final class ControlShape extends Shape {
	
	/**
	 * 	@constructor
	 */
	public function ControlShape(width:int, height:int):void {

		graphics.lineStyle(0, 0x45525c);
		graphics.beginFill(0x0e0f0f);
		graphics.drawRect(0,0,width,height);
		graphics.endFill();
		
		cacheAsBitmap = true;

	}
	
}