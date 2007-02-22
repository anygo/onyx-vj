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
package ui.text {
	
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import ui.assets.PixelFont;
	
	/**
	 * 	Default TextField
	 */
	public class TextField extends flash.text.TextField {
		
		/**
		 * 	@constructor
		 */
		public function TextField(width:int, height:int, align:String = 'left', selectable:Boolean = false, mouseEnabled:Boolean = false):void {
			
			super.selectable = selectable;

			var format:TextFormat = PixelFont.DEFAULT;
			format.align = align;

			defaultTextFormat = format;
			
			this.width = width;
			this.height = height;
			this.mouseEnabled = mouseEnabled;
			
			embedFonts = true;
		}

		/**
		 * 	Changes alignment
		 */		
		public function set align(a:String):void {
			
			var format:TextFormat = defaultTextFormat;
			embedFonts = (format.font == 'PixelFont')
			format.align = a;
			
			defaultTextFormat = format;
			
		}
		
		/**
		 * 	Gets alignment
		 */
		public function get align():String {
			return defaultTextFormat.align;
		}
		
		/**
		 * 	Sets text size
		 */
		public function set size(a:int):void {
			var format:TextFormat = defaultTextFormat;
			embedFonts = (format.font == 'PixelFont')
			format.size = a;
			
			defaultTextFormat = format;
		}
	}
}