package ui.text {
	
	import flash.text.GridFitType;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import onyx.assets.PixelFont;
	
	public class TextField extends flash.text.TextField {
		
		public function TextField(width:int, height:int, align:String = 'left'):void {
			
			selectable = false;

			var inheritStyle:TextFormat = PixelFont.DEFAULT;
			var format:TextFormat = new TextFormat(inheritStyle.font, inheritStyle.size, inheritStyle.color);
			format.align = align;
			format.leading = inheritStyle.leading;

			defaultTextFormat = format;
			
			this.width = width;
			this.height = height;
			
			embedFonts = true;
			
		}
		
		public function set align(a:String):void {
			
			var format:TextFormat = defaultTextFormat;
			embedFonts = (format.font == 'AssetFont')
			format.align = a;
			
			defaultTextFormat = format;
			
		}
		
		public function get align():String {
			return defaultTextFormat.align;
		}
		
		public function set size(a:int):void {
			var format:TextFormat = defaultTextFormat;
			embedFonts = (format.font == 'AssetFont')
			format.size = a;
			
			defaultTextFormat = format;
		}
	}
}