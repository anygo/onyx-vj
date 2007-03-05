package ui.window {
	
	import ui.styles.*;
	import ui.text.TextField;
	
	public final class HelpWindow extends Window {
		
		private var _text:TextField	= new TextField(390, 190, TEXT_ARIAL);
		
		public function HelpWindow():void {
			
			super('HELP', 396, 200, 614, 318);
			
			_text.x			= 4;
			_text.y			= 15;
			_text.wordWrap	= true;
			_text.textColor	= 0xDCC697;

			_text.htmlText	= 
			'ONYX IS A VIDEO-MIXING PROGRAM MEANT FOR DOING LIVE CLUB VISUALS AND ART INSTALLATIONS\n\n' +
			'LOAD VIDEOS BY DRAGGING FILES FROM THE BROWSER ON THE LEFT ONTO ONE OF THE LAYERS.' +
			'BLEND THE LAYERS BY CLICKING AND DRAGGING ON THE TEXT THAT SAYS "NORMAL" ON THE LAYER CONTROL.  YOU CAN CONTROL BRIGHTNESS, ALPHA, ETC, WITH THE CONTROLS UNDER THE "BASIC" TAB.' +

			'ADDING FILTERS AND EFFECTS:\n\n' +
			'ADD FILTERS TO LAYERS BY DRAGGING FILTERS TO THE LAYER.  CONTROL FILTER PARAMETERS BY CLICKING ON THE "FILTERS" TAB.  YOU CAN ALSO ADD GLOBAL FILTERS BY DRAGGING THEM ONTO THE CONTROL AT THE BOTTOM OF THE SCREEN.\n\n' +
			
			'FOR MORE HELP, PLEASE REFER TO THE TUTORIALS SECTION.';
			
			addChild(_text);
			
		}
	}
}