package ui.window {

	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import onyx.events.SpectrumEvent;
	import onyx.sound.SpectrumAnalyzer;
	import onyx.sound.SpectrumTrigger;
	
	public class SoundEqualizer extends Window {
		
		private var analyzer:SpectrumAnalyzer = SpectrumAnalyzer.getGlobal();
		private var overlay:Sprite = new Sprite();
		
		public function SoundEqualizer():void {

			title = 'sound monitor';
			
			width = 200;
			
			x = 822;
			y = 2;
			
			overlay.x = 2;
			overlay.y = 13;
			
			addChild(overlay);
			
			analyzer.addEventListener(SpectrumEvent.SPECTRUM_ANALYZED, _analyzed);
			analyzer.addEventListener(SpectrumEvent.SPECTRUM_TRIGGER,	_triggered);
			analyzer.addTrigger(new SpectrumTrigger(192, 255))
			
			addEventListener(MouseEvent.MOUSE_DOWN, _onMouseDown);
		}
		
		private function _onMouseDown(event:MouseEvent):void {
		}

		private function _analyzed(event:SpectrumEvent):void {
			
			var analysis:Array = event.analysis;
			
			overlay.graphics.clear();
			
			var amount:Number = 256 / 200;
			
			for (var count:int = 0; count < 256; count += amount) {
				
				var amplitude:Number = analysis[count];
				
				overlay.graphics.beginFill(0xFFFFFF);
				overlay.graphics.drawRect(count,0,0, amplitude * 120);
				overlay.graphics.endFill();
				
			}
		}
		
		private function _triggered(event:SpectrumEvent):void {
			trace(event);
		}
	}
}