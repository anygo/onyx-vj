package ui.layer {
	
	import flash.display.DisplayObject;
	
	import onyx.controls.*;
	import onyx.filter.Filter;
	import onyx.layer.IContent;
	
	import ui.assets.AssetLayerFilterBackground;
	import ui.controls.DropDown;
	import ui.controls.SliderV;
	import ui.controls.UIControl;
	import ui.controls.filter.LayerFilter;
	import ui.core.UIObject;

	public final class UIFilterSelection extends UIObject {
		
		public var filter:Filter;
		private var _controls:Array = [];
		
		public function UIFilterSelection():void {
			
			var asset:DisplayObject = addChild(new AssetLayerFilterBackground());
			asset.alpha = .95;
			
		}
		
		public function removeControls():void {
			
			for each (var uicontrol:UIControl in _controls) {
				removeChild(uicontrol);
				uicontrol.dispose();
			}
			
			_controls = [];
		}
		
		public function addControls(filter:Filter):void {
			
			this.filter = filter;
			
			removeControls();
			
			var count:int = 0;
			
			for each (var control:Control in filter.controls) {
				
				var uicontrol:UIControl;

				if (control is ControlInt || control is ControlNumber) {
					
					uicontrol = new SliderV(control);
					
				} else if (control is ControlRange) {
					uicontrol = new DropDown(control as ControlRange);
				}
				
				if (uicontrol) {
	
					uicontrol.addLabel(control.displayName);
					uicontrol.x = count * 40 + 4;
					uicontrol.y = 14;
					uicontrol.background = true;
					
					addChild(uicontrol);
					_controls.push(uicontrol);
					
					count++;
				}
			}
			
		}
		
	}
}