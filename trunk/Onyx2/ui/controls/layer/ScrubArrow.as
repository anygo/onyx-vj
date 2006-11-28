package ui.controls.layer
{
	import flash.display.Sprite;
	import ui.assets.AssetLayerMarker;
	import flash.display.DisplayObject;

	public final class ScrubArrow extends Sprite {
		
		public function ScrubArrow():void {
			var sprite:DisplayObject = addChild(new AssetLayerMarker());
			sprite.x = sprite.width / 2;
		}
		
	}
}