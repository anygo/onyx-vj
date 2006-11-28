package onyx.assets {
	
	import flash.text.Font;
	import flash.text.TextFormat;
	
	[Embed(
			source='/assets/Pixel.ttf',
			fontName='PixelFont',
			mimeType='application/x-font',
			unicodeRange='U+0020-U+0040,U+0041-U+005A,U+005B-U+0060,U+0061-U+007A,U+007B-U+007F')
	]
	public final class PixelFont extends Font {
		
		public static const DEFAULT:TextFormat			= new TextFormat('AssetFont', 7, 0xedeada);

		DEFAULT.leading			= 3;
		DEFAULT.letterSpacing	= .05;

	}
}