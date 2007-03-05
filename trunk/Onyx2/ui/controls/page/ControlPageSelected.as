package ui.controls.page {
	
	import flash.display.Sprite;
	
	import ui.assets.AssetLayerTab;
	import ui.styles.*;
	import ui.text.TextField;

	public final class ControlPageSelected extends Sprite {
		
		/**
		 * 	Store the tab
		 */
		public var background:AssetLayerTab = new AssetLayerTab();

		/**
		 * 	@private
		 */
		private var _label:TextField		= new TextField(36, 10, TEXT_DEFAULT_CENTER);
		
		/**
		 * 	offset the tabs
		 */
		public var offsetX:int;
		
		/**
		 * 	@constructor
		 */
		public function ControlPageSelected():void {

			addChild(background);
			addChild(_label);

			_label.y	= 3;
		}
		
		public function set text(value:String):void {
			_label.text = value;
		}

	}
}