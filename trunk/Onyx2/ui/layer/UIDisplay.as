/** 
 * Copyright (c) 2003-2006, www.onyx-vj.com
 * All rights reserved.	
 * 
 * Redistribution and use in source and binary forms, with or without modification,
 * are permitted provided that the following conditions are met:
 * 
 * -  Redistributions of source code must retain the above copyright notice, this 
 *    list of conditions and the following disclaimer.
 * 
 * -  Redistributions in binary form must reproduce the above copyright notice, 
 *    this list of conditions and the following disclaimer in the documentation 
 *    and/or other materials provided with the distribution.
 * 
 * -  Neither the name of the www.onyx-vj.com nor the names of its contributors 
 *    may be used to endorse or promote products derived from this software without 
 *    specific prior written permission.
 * 
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND 
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED 
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. 
 * IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, 
 * INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
 * NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
 * PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, 
 * WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE 
 * POSSIBILITY OF SUCH DAMAGE.
 * 
 */
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