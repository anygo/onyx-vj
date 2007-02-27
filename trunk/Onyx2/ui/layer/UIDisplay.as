package ui.layer {
	
	import onyx.display.Display;
	import onyx.events.FilterEvent;
	import onyx.filter.Filter;
	
	import ui.assets.AssetDisplay;
	import ui.controls.UIControl;
	import ui.controls.page.*;
	import ui.core.*;
	import ui.styles.*;
	import ui.window.*;
	import onyx.controls.Controls;

	/**
	 * 	Display Control
	 */
	public final class UIDisplay extends UIFilterControl implements IFilterDrop {
		
		/**
		 * 	@private
		 */
		private var _display:Display;
		
		/**
		 * 	@private
		 */
		private var _background:AssetDisplay			= new AssetDisplay();
		
		/**
		 * 	@constructor
		 */
		public function UIDisplay(display:Display):void {
			
			var controls:Controls = display.controls;

			// super!			
			super(
				display,
				88,
				new LayerPage('DISPLAY',
					controls.getControl('position'),
					controls.getControl('size'),
					controls.getControl('backgroundColor'),
					controls.getControl('visible')
				),
				new LayerPage('FILTERS'),
				new LayerPage('CUSTOM')
			);

			// register this as a drop target for filters
			Filters.registerTarget(this);

			// save display
			_display = display;
			
			// order
			controlPage.x = 91;
			controlPage.y = 25;
			controlTabs.x = 88;
			filterPane.x = 4;
			filterPane.y = 4;

			controlTabs.transform.colorTransform = LAYER_HIGHLIGHT;
			
			// add background
			addChildAt(_background, 0);
		}
	}
}