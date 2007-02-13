package visualizer {
	
	import flash.display.BitmapData;
	import flash.display.Shape;
	
	import onyx.core.RenderTransform;
	import onyx.sound.Visualizer;
	import onyx.sound.SpectrumAnalysis;
	
	public final class BasicVisualizer extends Visualizer {
		
		private var _shape:Shape = new Shape();
		
		public function BasicVisualizer():void {
		}
		
		override public function render(source:BitmapData, transform:RenderTransform = null):void {
		
			var step:Number = 320 / 127;
			
			_shape.graphics.clear();
			_shape.graphics.lineStyle(0, 0xFFFFFF);
			
			var analysis:Array = transform.spectrum.analysis;
			_shape.graphics.moveTo(0,100 + (analysis[0] * 200));

			for (var count:int = 1; count < analysis.length; count++) {
				_shape.graphics.lineTo(count * step, 100 + (analysis[count] * 200));
			}
			
			source.draw(_shape);
			
		}
	}
}