package ui.core {

	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	
	/**
	 * 	Handles tooltips
	 */
	public final class ToolTipManager {
		
		/**
		 * 
		 */
		private static var _dict:Dictionary = new Dictionary(true);

		/**
		 * 
		 */
		private static var timer:Timer		= new Timer(650);
		
		/**
		 * 
		 */
		private static var offTimer:Timer	= new Timer(100);
		
		/**
		 * 
		 */
		private static var _lastObject:DisplayObject;
		
		/**
		 * 	@private
		 * 	ToolTip
		 */
		private static var toolTip:ToolTip;

		/**
		 * 
		 */
		public static function registerToolTip(obj:DisplayObject, tip:String):void {
			_dict[obj] = tip;

			if (tip) {
				obj.addEventListener(MouseEvent.ROLL_OVER, _onToolOver, false, 0, true);
			} else {
				obj.removeEventListener(MouseEvent.ROLL_OVER, _onToolOver);
			}
		}
		
		/**
		 * 	@private
		 */
		private static function _onToolOver(event:MouseEvent):void {
			
			var obj:DisplayObject = event.currentTarget as DisplayObject;
			obj.addEventListener(MouseEvent.ROLL_OUT, _onToolOut, false, 0, true);

			_lastObject = obj;
			offTimer.stop();
			
			if (!toolTip) {
				timer.start();
			} else {
				_onTimer(null);
			}
		}

		
		/**
		 * 	@private
		 */
		private static function _onToolOut(event:MouseEvent):void {
			timer.stop();
			
			if (toolTip) {
				offTimer.start();
			}
		}
		
		/**
		 * 	@private
		 */
		private static function _onTimer(event:TimerEvent):void {
			timer.stop();
			
			if (_lastObject.stage) {
				var stage:Stage = _lastObject.stage;
	
				if (!toolTip) {
					toolTip = new ToolTip();
				}
				toolTip.x = stage.mouseX + 4;
				toolTip.y = stage.mouseY - 4;
				toolTip.text = (_dict[_lastObject] as String).toUpperCase();
				
				stage.addChild(toolTip);
			}
		}
		
		/**
		 * 	@private
		 */
		private static function _offTimer(event:TimerEvent):void {
			toolTip.parent.removeChild(toolTip);
			offTimer.removeEventListener(TimerEvent.TIMER, _offTimer);
			offTimer.stop();
		}
		
		/**
		 * 	
		 */
		public static function set enabled(value:Boolean):void {
			if (value) {
				timer.addEventListener(TimerEvent.TIMER, _onTimer);
				offTimer.addEventListener(TimerEvent.TIMER, _offTimer);
			} else {
				timer.removeEventListener(TimerEvent.TIMER, _onTimer);
				offTimer.removeEventListener(TimerEvent.TIMER, _offTimer);
			}
		}
		
		enabled = true;
	}
}

import flash.text.*;
import flash.text.TextField;
import onyx.assets.PixelFont;

class ToolTip extends TextField {

	public function ToolTip():void {
		
		mouseEnabled = false;
		
		super.selectable		= false;
		super.autoSize			= TextFieldAutoSize.LEFT;
		
		super.background		= true;
		super.backgroundColor	= 0xFFCC00;
		
		super.defaultTextFormat = PixelFont.DEFAULT;
		super.embedFonts		= true;
		super.textColor			= 0x000000;
		
	}

}