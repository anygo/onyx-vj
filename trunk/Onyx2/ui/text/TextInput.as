package ui.text {

	import flash.text.TextField;
	import flash.text.TextFieldType;

	public final class TextInput extends flash.text.TextField {
		
		public function TextInput(width:int = 100, height:int = 16):void {

			type = TextFieldType.INPUT;
			
			this.width = width;
			this.height = height;
			
			defaultTextFormat = Style.DEFAULT_TEXT_FORMAT;
			embedFonts = true;

		}

	}
}