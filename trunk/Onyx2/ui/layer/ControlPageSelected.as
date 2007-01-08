package ui.layer
{
	import flash.display.Sprite;
	import ui.assets.AssetLayerTab;
	import ui.text.TextField;

	public final class ControlPageSelected extends Sprite {
		
		public var background:AssetLayerTab = new AssetLayerTab();
		private var _label:TextField		= new TextField(36, 10, 'center');
		
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