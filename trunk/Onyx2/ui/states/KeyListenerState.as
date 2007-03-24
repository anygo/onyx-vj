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
package ui.states {
	
	import flash.display.Stage;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	
	import onyx.constants.ROOT;
	import onyx.states.ApplicationState;
	
	import ui.core.UIManager;
	import ui.layer.UILayer;

	/**
	 * 
	 */
	public final class KeyListenerState extends ApplicationState {
		
		public static var SELECT_FILTER_UP:int		= 38;
		public static var SELECT_FILTER_DOWN:int	= 40;
		
		public static var SELECT_LAYER_PREV:int		= 37;
		public static var SELECT_LAYER_NEXT:int		= 39;
		public static var SELECT_PAGE_0:int			= 81;
		public static var SELECT_PAGE_1:int			= 87;
		public static var SELECT_PAGE_2:int			= 69;
		public static var SELECT_LAYER_0:int		= 49;
		public static var SELECT_LAYER_1:int		= 50;
		public static var SELECT_LAYER_2:int		= 51;
		public static var SELECT_LAYER_3:int		= 52;
		public static var SELECT_LAYER_4:int		= 53;
		
		public static var ACTION_1:int				= 112;
		public static var ACTION_2:int				= 113;
		public static var ACTION_3:int				= 114;
		public static var ACTION_4:int				= 115;
		public static var ACTION_5:int				= 116;
		public static var ACTION_6:int				= 117;
		public static var ACTION_7:int				= 118;
		public static var ACTION_8:int				= 119;
		public static var ACTION_9:int				= 120;
		public static var ACTION_10:int				= 121;
		public static var ACTION_11:int				= 122;
		public static var ACTION_12:int				= 123;
		
		/**
		 * 	Initialize
		 */
		override public function initialize():void {
			
			// listen for keys
			ROOT.addEventListener(KeyboardEvent.KEY_DOWN, _onKeyPress);
		}
		
		/**
		 * 
		 */
		override public function pause():void {

			// remove listener
			ROOT.removeEventListener(KeyboardEvent.KEY_DOWN, _onKeyPress);
		}
		
		/**
		 * 	Terminates the keylistener
		 */
		override public function terminate():void {
		}
		
		/**
		 * 	@private
		 */
		private static function _onKeyPress(event:KeyboardEvent):void {
			
			var layer:UILayer;
			
			switch (event.keyCode) {
				case SELECT_LAYER_PREV:
					layer = UILayer.getLayerAt(UILayer.selectedLayer.index - 1);
					if (layer) {
						UILayer.selectLayer(layer);
					}
					
					break;
				case SELECT_LAYER_NEXT:
					layer = UILayer.getLayerAt(UILayer.selectedLayer.index + 1);
					if (layer) {
						UILayer.selectLayer(layer);
					}

					break;
				case SELECT_FILTER_UP:
					UILayer.selectedLayer.selectFilterUp(true);
					break;
				case SELECT_FILTER_DOWN:
					UILayer.selectedLayer.selectFilterUp(false);
					break;
				case SELECT_LAYER_0:
					UILayer.selectLayer(UILayer.layers[0]);
					break;
				case SELECT_LAYER_1:
					UILayer.selectLayer(UILayer.layers[1]);
					break;
				case SELECT_LAYER_2:
					UILayer.selectLayer(UILayer.layers[2]);
					break;
				case SELECT_LAYER_3:
					UILayer.selectLayer(UILayer.layers[3]);
					break;
				case SELECT_LAYER_4:
					UILayer.selectLayer(UILayer.layers[4]);
					break;
				case SELECT_PAGE_0:
				
					for each (layer in UILayer.layers) {
						layer.selectPage(0);
					}
					
					break;
				case SELECT_PAGE_1:
				
					for each (layer in UILayer.layers) {
						layer.selectPage(1);
					}
					
					break;
				case SELECT_PAGE_2:
				
					for each (layer in UILayer.layers) {
						layer.selectPage(2);
					}
					
					break;
				default:
					// trace(event.keyCode);
					// break;
			}
		}

	}
}