package ui.layer {
	
	import flash.utils.Dictionary;
	
	import onyx.controls.*;
	
	import ui.controls.*;
	import ui.core.UIObject;
	import ui.text.TextField;

	/**
	 * 	The pages
	 */
	public final class ControlPage extends UIObject {

		/** @private **/
		private var _controls:Array		= [];
		
		/**
		 * 	@constructor
		 */		
		public function ControlPage():void {
			super(true);
		}
		
		/**
		 * 	
		 */
		public function removeControls():void {
			for each (var uicontrol:UIControl in _controls) {
				uicontrol.dispose();
			}
			_controls = [];
		}
		
		/**
		 * 	
		 */
		public function addControls(controls:Array):void {
			
			var uicontrol:UIControl, x:int = 0, y:int = 0;
			var options:UIOptions	= UIOptions.DEFAULT;
			var _width:int			= 60;
			
			removeControls();

			for each (var control:Control in controls) {
				
				uicontrol = null;
				var metadata:Object = control.metadata || {};
				
				if (control is ControlNumber) {
					if (metadata.display === 'frame') {
						uicontrol = new SliderVFrameRate(options, control);
					}
					
					if (!uicontrol) {
						uicontrol = new SliderV(options, control);
					}
				} else if (control is ControlProxy) {
					uicontrol = new SliderV2(options, control);
				} else if (control is ControlRange) {
					uicontrol = new DropDown(options, control);
				} else if (control is ControlColor) {
					uicontrol = new ColorPicker(options, control);
				} else if (control is ControlColor) {
					uicontrol = new ColorPicker(options, control);
				} else if (control is ControlToggle) {
					uicontrol = new CheckBox(options, control);
				} else if (control is ControlString) {
					uicontrol = new TextControl(options, control);
				}
				
				uicontrol.x = metadata.x || x;
				uicontrol.y = metadata.y || y;
				_controls.push(uicontrol);
				
				x += options.width + 4;
				
				if (x > _width) {
					x = 0;
					y += options.height + 10;
				}
				
				addChild(uicontrol);

			}
		}
	}
}