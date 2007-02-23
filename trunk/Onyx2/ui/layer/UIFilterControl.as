package ui.layer {
	
	import flash.events.MouseEvent;
	
	import onyx.events.FilterEvent;
	import onyx.filter.Filter;
	import onyx.filter.IFilterObject;
	
	import ui.controls.filter.*;
	import ui.controls.page.*;
	import ui.core.UIObject;

	public class UIFilterControl extends UIObject {
		
		/**
		 * 	@private
		 */
		private var _target:IFilterObject;
		
		/**
		 * 
		 */
		protected var selectedPage:int						= -1;

		/**
		 * 
		 */
		protected var filterPane:FilterPane					= new FilterPane();
		
		/**	
		 * 	@private
		 */
		protected var controlPage:ControlPage				= new ControlPage();
		
		/**
		 *  @private
		 */
		protected var controlTabs:ControlPageSelected		= new ControlPageSelected();
		
		/**
		 * 
		 */
		protected var pages:Array;
		
		/**
		 * 	@constructor
		 */
		public function UIFilterControl(target:IFilterObject, tabOffset:int, ... pages:Array):void {

			// move to top
			super(true);
			
			this.pages = pages || [];
			
			// create buttons for pages
			_registerPages();
			
			// listen for events
			_target = target;
			_target.addEventListener(FilterEvent.FILTER_APPLIED, _onFilterApplied);
			_target.addEventListener(FilterEvent.FILTER_REMOVED, _onFilterRemoved);
			_target.addEventListener(FilterEvent.FILTER_MOVED, _onFilterMove);
			_target.addEventListener(FilterEvent.FILTER_MUTED, _onFilterMute);
			
			// set offset
			controlTabs.offsetX = tabOffset;
			controlTabs.x		= tabOffset;
			
			// add filter objects
			addChild(filterPane);
			addChild(controlPage);
			addChild(controlTabs);
			
			// select page
			selectPage(0);
		}
		
		/**
		 * 	Selects a page
		 */
		public function selectPage(index:int, controls:Array = null):void {
			
			var page:LayerPage = pages[index];
			
			if (controls) {
				page.controls = controls;
				controlPage.addControls(page.controls);
			}
			
			if (index !== selectedPage) {
				
				controlPage.addControls(page.controls);
				controlTabs.text	= page.name;
				controlTabs.x		= index * 35 + controlTabs.offsetX;
				
				selectedPage = index;
			}
		}
		

		/**
		 * 	Gets a page
		 */
		public function getPage(index:int):LayerPage {
			return pages[index];
		}
		
		/**
		 * 	Adds a page
		 */
		private function _registerPages():void {
			
			for (var count:int = 0; count < pages.length; count++) {
				var page:LayerPage = pages[count];

				var button:ControlPageButton = new ControlPageButton(count);
				button.x		= count * 35 + controlTabs.offsetX;
				button.y		= 169;

				addChild(button);
	
				button.addEventListener(MouseEvent.MOUSE_DOWN, _onPageSelect);
			}
		}

		/**
		 * 	@private
		 */
		private function _onPageSelect(event:MouseEvent):void {
			
			var target:ControlPageButton = event.currentTarget as ControlPageButton;
			
			if (target.index === 1) {
				var filter:LayerFilter = filterPane.getFilter(_target.filters[0]);
				if (filter) {
					filterPane.selectFilter(filter);
				}
			} else {
				filterPane.selectFilter(null);
				selectPage(target.index);
			}
		}
		
		/**
		 * 	Adds a filter
		 */
		public function addFilter(filter:Filter):void {
			_target.addFilter(filter);
		}
		
		/**
		 * 	Removes a filter
		 */
		public function removeFilter(filter:Filter):void {
			_target.removeFilter(filter);
		}
		
		/**
		 * 	@private
		 * 	Event when filter is added
		 */
		private function _onFilterApplied(event:FilterEvent):void {
			filterPane.register(event.filter);
		}
		
		/**
		 * 	@private
		 * 	Called when a filter is removed
		 */
		private function _onFilterRemoved(event:FilterEvent):void {
			filterPane.unregister(event.filter);
		}

		/**
		 * 	@private
		 * 	When a filter is moved
		 */		
		private function _onFilterMove(event:FilterEvent):void {
			filterPane.reorder();
		}

		/**
		 * 	@private
		 * 	When a filter is moved
		 */		
		private function _onFilterMute(event:FilterEvent):void {
			filterPane.mute(event.filter);
		}
		
		
	}
}