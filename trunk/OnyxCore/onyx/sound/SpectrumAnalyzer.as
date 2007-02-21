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
package onyx.sound {
	
	import flash.events.Event;
	import flash.media.SoundMixer;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	import onyx.controls.Controls;
	import onyx.controls.IControlObject;
	import onyx.core.IDisposable;
	import onyx.core.Onyx;
	import onyx.core.PluginBase;
	import onyx.core.onyx_ns;
	import onyx.plugin.Plugin;
	
	use namespace onyx_ns;
	
	/**
	 * 	Plugin
	 */
	public class SpectrumAnalyzer extends PluginBase implements IControlObject {
		
		/**
		 * 	@private
		 */
		private static function _init():void {
			for (var count:int = 0; count < 127; count++) {
				BASE_ANALYSIS[count] = 0;
			}
		}
		
		_init();
		
		/**
		 * 	@private
		 */
		private static const BASE_ANALYSIS:Array	= new Array(127);
		
		/**
		 * 
		 */
		public static var useFFT:Boolean			= false;
		
		/**
		 * 	@private
		 */
		private static var _bytes:ByteArray;
		
		
		/**
		 * 	@private
		 */
		private static var _dict:Dictionary = new Dictionary(true);
		
		/**
		 * 	Stores the spectrum analysis
		 */
		onyx_ns static var spectrum:SpectrumAnalysis;

		/**
		 * 	Registers an object to be analyzed
		 */
		public static function register(obj:Object):void {
			Onyx.root.addEventListener(Event.ENTER_FRAME, _analyze, false, 10000);
			_dict[obj] = obj;
			
			_bytes = new ByteArray();
		}
		
		/**
		 * 	@private
		 * 	Does actual changing of bytearray to array
		 */
		private static function _analyze(event:Event):void {
			
			var analysis:SpectrumAnalysis = new SpectrumAnalysis();
			analysis.fft = useFFT;
			
			SoundMixer.computeSpectrum(_bytes, useFFT);
			
			var i:Number	= 128;
			var array:Array = BASE_ANALYSIS.concat();
			
			while ( --i > -1 ) {
				
				// move the pointer
				_bytes.position = i * 8;
				
				// get amplitude value
				array[i % 127] += (_bytes.readFloat() >> 1);
				
			}
			
			analysis.analysis = array;
			spectrum = analysis;
		}
		
		/**
		 * 	Unregisters
		 */
		public static function unregister(obj:Object):void {
			delete _dict[obj];
			
			for each (var i:Object in _dict) {
				return;
			}
			
			Onyx.root.removeEventListener(Event.ENTER_FRAME, _analyze);
			spectrum = null;
		}
		
	}
}