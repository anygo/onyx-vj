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
package onyx.content {

	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.geom.Transform;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.utils.getTimer;
	
	import onyx.constants.BOOLEAN;
	import onyx.constants.POINT;
	import onyx.controls.*;
	import onyx.core.IDisposable;
	import onyx.core.RenderTransform;
	import onyx.core.onyx_ns;
	import onyx.events.FilterEvent;
	import onyx.filter.*;
	import onyx.layer.IColorObject;
	import onyx.layer.Layer;
	import onyx.layer.LayerProperties;
	import onyx.plugin.Plugin;
	import onyx.sound.SpectrumAnalyzer;
	import onyx.sound.Visualizer;
//	import onyx.sound.SpectrumAnalyzer;

	use namespace onyx_ns;
	
	[ExcludeClass]
	public final class ContentMP3 extends Content {
	
		private var _length:int;
		private var _loopStart:int;
		private var _loopEnd:int;	
		private var _sound:Sound;
		private var _channel:SoundChannel;
		
		private var _plugin:Plugin;
		
		public function ContentMP3(layer:Layer, path:String, sound:Sound):void {
			
			_sound = sound;
			_length = Math.max(Math.floor(sound.length / 100) * 100, 0);
			
			_loopStart	= 0;
			_loopEnd	= _length;
			
			super(layer, path, null);

			// add a control for the visualizer
			_controls = new Controls(this, 
				new ControlRange('visualizer', 'Visualizer', Visualizer.visualizers, 0, 'name')
			);
		}
		
		/**
		 * 	Gets the visualizer
		 */
		public function get visualizer():Plugin {
			return _plugin;
		}

		/**
		 * 	Sets the visualizer
		 */
		public function set visualizer(plugin:Plugin):void {
			
			if (_plugin) {
				_plugin.relatedObject.dispose();
				_plugin.relatedObject = null;
			}
			
			_plugin = plugin;
			_plugin.relatedObject = plugin.getDefinition();
		}
		
		/**
		 * 	Updates the bimap source
		 */
		override public function render(source:BitmapData, transform:RenderTransform = null):void {
			var position:Number = Math.ceil(_channel.position);
			
			if (position >= _loopEnd || position < _loopStart || position >= _length) {
				_channel.stop();
				_channel = _sound.play(_loopStart);
			}
			
			if (_plugin && SpectrumAnalyzer.spectrum) {
				
				// empty
				_source.fillRect(source.rect, 0x00000000);

				// get the transform and pass it on
				var transform:RenderTransform = getTransform();
				
				// add the analysis
				transform.spectrum = SpectrumAnalyzer.spectrum;

				// render
				(_plugin.relatedObject as Visualizer).render(_source, transform);

				// apply the color filter to the source
				_source.applyFilter(_source, _source.rect, POINT, _filter.filter);
				
				// apply filters
				applyFilters();
				
				// copy the pixels back to the layer
				source.copyPixels(_rendered, _rendered.rect, POINT);

			}
		}
		
		/**
		 * 	
		 */
		override public function get time():Number {
			return (_channel) ? _channel.position / _sound.length : 0;
		}
		
		/**
		 * 	
		 */
		override public function set time(value:Number):void {
			
			if (_channel) {
				_channel.stop();
			}
			
			_channel = _sound.play(value * _length);
			
		}
		
		/**
		 * 	
		 */
		override public function set loopStart(value:Number):void {
			_loopStart = __loopStart.setValue(value) * _length;
		}
		
		/**
		 * 	
		 */
		override public function get loopStart():Number {
			return _loopStart / _length;
		}
		
		/**
		 * 	
		 */
		override public function set loopEnd(value:Number):void {
			_loopEnd = __loopEnd.setValue(value) * _length;
		}
		
		/**
		 * 	
		 */
		override public function get loopEnd():Number {
			return _loopEnd / _length;
		}
		
		/**
		 * 	Dispose
		 */
		override public function dispose():void {
	
			_channel.stop();
			_channel = null;
			_sound = null;
			
			super.dispose();
		}
	}
}