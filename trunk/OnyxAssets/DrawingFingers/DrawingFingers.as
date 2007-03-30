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
	
	import flash.display.*;
	import flash.events.Event;
	import flash.filters.*;
	import flash.geom.*;
	
	import onyx.constants.*;
	import onyx.content.*;
	import onyx.controls.*;
	import onyx.constants.*;
	import onyx.core.*;
	import onyx.events.*;
	import onyx.net.*;
	import onyx.plugin.*;
	import onyx.render.*;
	import onyx.utils.*;

	/**
	 * 	Drawing clip
	 * 	Control click on a layer the preview box to send mouse events to this file
	 */
	public class DrawingFingers extends Sprite implements IRenderObject, IControlObject {
		
		private var _source:BitmapData		= BASE_BITMAP();
		private var _controls:Controls;
		
		public var hue1:Number = 0.0;
		public var hue2:Number = 0.0;
		public var luminance1:Number = 0.5;
		public var luminance2:Number = 0.5;
		public var saturation1:Number = 1.0;
		public var saturation2:Number = 1.0;
		public var fingeralpha:Number = 0.2;
		public var fingeraspect:Number = 1;
		public var blurX:Number = 0;
		public var blurY:Number = 0;
		public var fingershape:String = 'CIRCLE';
		public var fingerstyle:String = 'FILLED';
		public var fingerround:int;
		public var fade:Number = 0.1;
		
		private static var _client:NthEventClient;
		
		public const SHAPES:Array = ['CIRCLE', 'RECT', 'ROUNDRECT', 'ELLIPSE'];
		public const STYLES:Array = ['FILLED', 'OUTLINE'];
					
		private var _blur:BlurFilter = new BlurFilter(  );
		private var _changed:Boolean = false;
	
		public function DrawingFingers():void {
			
			_controls = new Controls(this, 
				new ControlNumber('hue1','hue1',	0,	360,	0, { multiplier: 1 } ),
				new ControlNumber('hue2','hue2',	0,	360,	0, { multiplier: 1 } ),
				new ControlNumber('fingeralpha','alpha',	0,	1,	0.2),
				new ControlRange('fingershape','shape',	SHAPES,	0),
				new ControlRange('fingerstyle','style', STYLES, 0),
				new ControlNumber('fingeraspect','aspect',	0,	1,	0.5),
				new ControlInt('fingerround', 'round', 0, 50, 10, { factor: 10 }),
				new ControlNumber('blurX','blurX', 0, 1, 0),
				new ControlNumber('blurY','blurY', 0, 1, 0),
				new ControlNumber('fade','fade', 0, 1, 0.1),
				new ControlExecute('clear','clear')
			);
			_client = NthEventClient.getInstance();
			_client.addEventListener(FingerEvent.DOWN,onFingerDown);
    		_client.addEventListener(FingerEvent.UP,onFingerUp);
    		_client.addEventListener(FingerEvent.DRAG,onFingerDrag);
    		
			addEventListener(Event.ENTER_FRAME, _ent);
    	}
    	
		public function clear():void {
			graphics.beginFill(0x000000,1.0);
			graphics.drawRect(0,0,BITMAP_WIDTH,BITMAP_HEIGHT);
			graphics.endFill();
		}
    	
    	private function _ent(e:Event):void {
    		if ( ! _changed )
    			return
    		// trace("drawing, e=",e);
    		var d:Object = _client.getFingerStates();
    		for each ( var x:Object in d ) {
    			var f:FingerState = x as FingerState;
    			_draw(f);
    		}
    		_changed = false;
    	}
		
    	public function onFingerDown(f:FingerEvent):void {
    		_changed = true;
 	 		// _draw(f);
    	}
    	public function onFingerUp(f:FingerEvent):void {
    		_changed = true;
    	}
    	public function onFingerDrag(f:FingerEvent):void {
    		_changed = true;
  	 		// _draw(f);
	   	}
	
		private function _draw(f:FingerState):void {
			var x:int = BITMAP_WIDTH * f.x;
			var y:int = BITMAP_HEIGHT - BITMAP_HEIGHT * f.y;
			var r:Number = 20 * f.proximity;
			
			var color1:HLS = new HLS(hue1,luminance1,saturation1);
			var color2:HLS = new HLS(hue2,luminance2,saturation2);
			
			var color:uint =  ((f.deviceIndex % 2)==0) ? color1.rgb : color2.rgb;
			if ( fingerstyle == 'FILLED' ) {
				graphics.beginFill(color,fingeralpha);
			} else {
				graphics.lineStyle(1,color,fingeralpha);
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
			
			if ( blurX > 0 || blurY > 0 ) {
				_blur.blurX = blurX * BITMAP_WIDTH / 4;
				_blur.blurY = blurY * BITMAP_HEIGHT / 3;
	            _source.applyFilter(_source, _source.rect, new Point(  ), _blur);
			}
            
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
