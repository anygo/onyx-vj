package {
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import fonts.ImpactFont;
	
	import onyx.controls.*;
	import onyx.core.IDisposable;
	import onyx.net.Stream;

	public class OnyxText extends Sprite implements IControlObject {
		
		ImpactFont;
		
		private var _controls:Controls;
		
		private var _text:String;
		private var _format:TextFormat	= new TextFormat('Impact', 28);

		public var bitmapData:BitmapData;
		public var color:uint = 0xFFFFFF;
		
		public function OnyxText():void {
			text = '1234512345';
			_controls = new Controls(
				this,
				new ControlColor('color','Color'),
				new ControlString('text', 'text')
			)
		}
		
		public function redraw():void {
			
			while (numChildren) {
				removeChildAt(0);
			}
			
			var label:TextField 	= new TextField();
			label.embedFonts		= true;
			label.defaultTextFormat = _format;
			label.autoSize			= 'left';
			label.textColor			= color;
			label.text				= _text;
			
			addChild(label);

		}
		
		public function set text(value:String):void {
			_text = value;
			redraw();
		}
		
		public function get text():String {
			return _text;
		}
		
		public function get controls():Controls {
			return _controls;
		}
		
		public function dispose():void {
			while (numChildren) {
				removeChildAt(0);
			}
		}
	}
}
