package ui.controls {

	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import onyx.controls.ControlString;
	
	import ui.core.UIObject;
	import ui.text.TextInput;
	
	public final class TextControlPopUp extends UIObject {

		private var _input:TextInput;
		private var _control:ControlString;

		public function TextControlPopUp(parent:DisplayObjectContainer, width:int, height:int, text:String, control:ControlString = null):void {
			
			if (parent) {
				
				_control		= control;

				var bounds:Rectangle	= parent.getBounds(parent.stage);
				x						= bounds.x;
				y						= bounds.y;
				parent.stage.addChildAt(this, parent.stage.numChildren);
				
				stage.addEventListener(MouseEvent.MOUSE_DOWN, _captureMouse);

				displayBackground(width, height);
				
				_input				= new TextInput(width - 4, height - 4);
				_input.multiline	= true;
				_input.x			= 2;
				_input.y			= 2;
				_input.text			= text;
				addChild(_input);

				_input.setSelection(0, text.length - 1);
			}
			
			mouseEnabled = true;
			mouseChildren = true;
			
		}
		
		/**
		 * 	@private
		 */
		private function _captureMouse(event:MouseEvent):void {
			
			if (!hitTestPoint(stage.mouseX, stage.mouseY)) {
				
				if (_control) {
					_control.value = _input.text;
					_control = null;
				}
				
				stage.removeEventListener(MouseEvent.MOUSE_DOWN, _captureMouse, false);
				stage.removeChild(this);
				
			}
			
			event.stopPropagation();
		}
	}
}