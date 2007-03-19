/** 
 * Copyright (c) 2007, www.onyx-vj.com
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
 package {
	
	import flash.display.BitmapData;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.geom.*;
	import flash.filters.BlurFilter;
	import flash.filters.ConvolutionFilter;
	import flash.filters.ColorMatrixFilter;
	import flash.events.Event;

	import onyx.content.*;
	import onyx.controls.*;
	import onyx.core.*;
	import onyx.plugin.*;
	
	import onyx.events.*;

	/**
	 * 	Drawing clip
	 * 	Control click on a layer the preview box to send mouse events to this file
	 */
	[SWF(width='320', height='240', frameRate='24')]
	public class DrawingFingers extends Sprite implements IRenderObject, IControlObject {
		
		private var _source:BitmapData		= new BitmapData(320,240,true, 0x00000000);
		private var _controls:Controls;
		
		public var color1:uint	= 0xFF0000;
		public var fingeralpha:Number = 0.2;
		public var fingeraspect:Number = 1;
		public var blurX:Number = 0;
		public var blurY:Number = 0;
		public var fingershape:String = 'CIRCLE';
		public var fingerstyle:String = 'FILLED';
		public var fingerround:int;
		public var fade:Number = 0.1;

		private static var _client:NthClient;
		
		public const SHAPES:Array = ['CIRCLE', 'RECT', 'ROUNDRECT', 'ELLIPSE'];
		public const STYLES:Array = ['FILLED', 'OUTLINE'];
					
		private var _blur:BlurFilter = new BlurFilter(  );
	
		public function DrawingFingers():void {
			
			_controls = new Controls(this, 
				new ControlColor('color1','color1'),
				new ControlNumber('fingeralpha','alpha',	0,	1,	0.2),
				new ControlRange('fingershape','shape',	SHAPES,	0),
				new ControlRange('fingerstyle','style', STYLES, 0),
				new ControlNumber('fingeraspect','aspect',	0,	1,	0.5),
				new ControlInt('fingerround', 'round', 0, 50, 10, { factor: 10 }),
				new ControlNumber('blurX','blurX', 0, 1, 0),
				new ControlNumber('blurY','blurY', 0, 1, 0),
				new ControlNumber('fade','fade', 0, 1, 0.1)
			);
			_client = NthClient.getInstance();
			_client.addEventListener(FingerEvent.DOWN,onFingerDown);
    		_client.addEventListener(FingerEvent.UP,onFingerUp);
    		_client.addEventListener(FingerEvent.DRAG,onFingerDrag);
    		_client.addEventListener(MidiEvent.NOTEON,onNoteon);
    	}
		
		public function onNoteon(m:MidiEvent):void {
				trace("Got MIDI Noteon! pitch=",m.pitch());
		}
    	public function onFingerDown(f:FingerEvent):void {
 	 		_draw(f);
    	}
    	public function onFingerUp(f:FingerEvent):void {
    		;
    	}
    	public function onFingerDrag(f:FingerEvent):void {
  	 		_draw(f);
	   	}
	
		private function _draw(f:FingerEvent):void {
			var x:int = 320 * f.x();
			var y:int = 240 - 240 * f.y();
			var r:Number = 20 * f.proximity();
			if ( fingerstyle == 'FILLED' ) {
				graphics.beginFill(color1,fingeralpha);
			} else {
				graphics.lineStyle(1,color1,fingeralpha);
			}
			var a1:Number = r;
			var a2:Number = r * fingeraspect;
			if ( fingershape == 'CIRCLE' ) {
				graphics.drawCircle(x, y, r);
			} else if ( fingershape == 'RECT' ) {
				graphics.drawRect(x,y,a1,a2);
			} else if ( fingershape == 'ROUNDRECT' ) {
				graphics.drawRoundRect(x,y,r,r,fingerround);
			} else if ( fingershape == 'ELLIPSE' ) {
				graphics.drawEllipse(x,y,a1,a2);
			}
			if ( fingerstyle == 'FILLED' ) {
				graphics.endFill();
			}
		}

		/**
		 * 	@private
		 */
		public function render():RenderTransform {
			
			var t:RenderTransform = RenderTransform.getTransform(this);
			t.content = _source;

			// _source.scroll(2,1);
			// _source.fillRect(_source.rect,0x66ff0000);
		
			_blur.blurX = blurX * 320 / 4;
			_blur.blurY = blurY * 240 / 3;
            _source.applyFilter(_source, _source.rect, new Point(  ), _blur);
            
            var f:Number;
            if ( fade == 1.0 ) {
            	f = 0.0;
            } else {
            	f = 1.0 - (0.2 * fade * fade);
            }
			if ( fade != 0.0 ) {
				if ( f > 0.97 ) f = 0.97;
            	var _darken:ColorMatrixFilter = new ColorMatrixFilter([f, 0, 0, 0, 0, 0, f, 0, 0, 0, 0, 0, f, 0, 0, 0, 0, 0, 1, 0]);
	            _source.applyFilter(_source, _source.rect, new Point( ), _darken);
	 		}	
			_source.draw(this);
			graphics.clear();			
			return t;
		}
		
		public function get controls():Controls {
			return _controls;
		}
		
		public function dispose():void {
			_source.dispose();
			_source = null;
			
			_client.removeEventListener(FingerEvent.DOWN,onFingerDown);
    		_client.removeEventListener(FingerEvent.UP,onFingerUp);
    		_client.removeEventListener(FingerEvent.DRAG,onFingerDrag);
    		
			_controls.dispose();
			graphics.clear();

		}
	}
}
