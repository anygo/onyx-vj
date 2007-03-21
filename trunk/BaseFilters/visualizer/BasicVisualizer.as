package visualizer {
	
	import flash.display.BitmapData;
	import flash.display.Shape;
	
	import onyx.constants.*;
	import onyx.core.*;
	import onyx.render.RenderTransform;
	import onyx.sound.SpectrumAnalysis;
	import onyx.sound.SpectrumAnalyzer;
	import onyx.sound.Visualizer;

	public final class BasicVisualizer extends Visualizer {
		
		private var _shape:Shape = new Shape();
		
		public function BasicVisualizer():void {
		}
		
		override public function render():RenderTransform {
			
			var transform:RenderTransform = RenderTransform.getTransform(_shape);
		
			var step:Number = BITMAP_WIDTH / 127;
			
			_shape.graphics.clear();
			_shape.graphics.lineStyle(0, 0xFFFFFF);
			
			var analysis:Array = SpectrumAnalyzer.spectrum.analysis;
			_shape.graphics.moveTo(0,100 + (analysis[0] * 200));

			for (var count:int = 1; count < analysis.length; count++) {
				_shape.graphics.lineTo(count * step, 100 + (analysis[count] * 200));
			}
			
			return transform;
		}
		
		override public function dispose():void {
			_shape = null;
		}
	}
}