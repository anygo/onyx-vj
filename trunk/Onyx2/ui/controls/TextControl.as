package ui.controls {
	
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.Font;
	
	import onyx.controls.*;
	
	import ui.core.UIObject;
	import ui.styles.*;
	import ui.text.TextField;
	
	public final class TextControl extends UIControl {
		
		/**
		 * 	@private
		 */
		private var _control:ControlString;

		/**
		 * 	@private
		 */
		private var _label:TextField;
		
		/**
		 * 	@constructor
		 */
		public function TextControl(options:UIOptions, control:Control):void {
			
			super(options, true, control.display);

			_control = control as ControlString;
			
			_label = new TextField(options.width + 3, options.height, TEXT_DEFAULT_CENTER);
			addChild(_label);
			
			_label.y			= 1;
			_label.textColor	= 0x999999;
			_label.text			= 'EDIT';
				
			addEventListener(MouseEvent.MOUSE_DOWN, _onMouseDown);	
		}

		/**
		 * 	@private
		 */
		private function _onMouseDown(event:MouseEvent):void {
			
			var popup:TextControlPopUp	= new TextControlPopUp(this, 200, 200, _control.value, _control);
			event.stopPropagation();
		}
		
		/**
		 * 
		 */
		override public function dispose():void {
			
			removeEventListener(MouseEvent.MOUSE_DOWN, _onMouseDown);
			_control = null;
			_label = null;
			
			super.dispose();
		}
	}
}