package ui.controls {
	
	import onyx.controls.*;
	import ui.text.TextField;
	import flash.text.Font;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import ui.core.UIObject;
	
	public final class TextControl extends UIControl {
		
		private var _control:ControlString;
		private var _label:TextField;
		private var _font:Font;
		private var _popup:TextControlPopUp;
		
		public function TextControl(options:UIOptions, control:Control):void {
			
			super(options, control.display);

			_control = control as ControlString;
			
			_label = new TextField(options.width + 3, options.height, 'center');
			addChild(_label);
			
			_label.y			= 1;
			_label.textColor	= 0x999999;
			_label.text			= 'EDIT';
				
			addEventListener(MouseEvent.MOUSE_DOWN, _onMouseDown);	
		}

		private function _onMouseDown(event:MouseEvent):void {
			
			var bounds:Rectangle = getBounds(stage);
			
			_popup		= new TextControlPopUp(200,200);
			_popup.x	= bounds.x;
			_popup.y	= bounds.y;
			_popup.text	= _control.value;
			
			stage.addChildAt(_popup, stage.numChildren);
			stage.addEventListener(MouseEvent.MOUSE_DOWN, _captureMouse, true, 10);
			removeEventListener(MouseEvent.MOUSE_DOWN, _onMouseDown);	
			
			event.stopPropagation();
		}
		
		private function _captureMouse(event:MouseEvent):void {
			if (!_popup.hitTestPoint(stage.mouseX, stage.mouseY)) {
				
				_control.value = _popup.text;
				
				stage.removeEventListener(MouseEvent.MOUSE_DOWN, _captureMouse, true);
				stage.removeChild(_popup);
				_popup = null;
				
				addEventListener(MouseEvent.MOUSE_DOWN, _onMouseDown);
			}
			event.stopPropagation();
		}
		
		/**
		 * 
		 */
		override public function dispose():void {
			
			removeEventListener(MouseEvent.MOUSE_DOWN, _onMouseDown);
			
			if (_popup) {
				_popup.stage.removeEventListener(MouseEvent.MOUSE_DOWN, _captureMouse, true);
				_popup.dispose();
			}
			
			_popup = null;
			
			super.dispose();
		}
	}
}