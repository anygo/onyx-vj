/**
 * Copyright (c) 2003-2010 "Onyx-VJ Team" which is comprised of:
 *
 * Daniel Hai
 * Stefano Cottafavi
 * Bruce Lane
 *
 * All rights reserved.
 *
 * Licensed under the CREATIVE COMMONS Attribution-Noncommercial-Share Alike 3.0
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at: http://creativecommons.org/licenses/by-nc-sa/3.0/us/
 *
 * Please visit http://www.onyx-vj.com for more information
 *  
 * Downloaded from http://wonderfl.net/c/pOiZ, a fork from nitoyon's Hello World 2
 * Adapted for Onyx-VJ 4 by Bruce LANE (http://www.batchass.fr)
 * version 4.0.503 last modified March 6th 2009
 */
package library.patches 
{

	import caurina.transitions.Tweener;
	
	import flash.display.*;
	import flash.filters.*;
	import flash.geom.*;
	import flash.text.*;
	
	import onyx.core.*;
	import onyx.events.InteractionEvent;
	import onyx.parameter.*;
	import onyx.plugin.*;
	
	public class CircleText extends Patch
	{
		private	var tf:TextField = new TextField();
		private var source:BitmapData; 		
		private var bmp:Bitmap;
		private var sprite:Sprite;
		private var _color:uint = 0xFFFF00;
		private var i:int = 0;
		private var j:int = 0;
		private var mx:Number = 0;
		private var my:Number = 0;
		private var lastX:Number = 0;
		private var lastY:Number = 0;
		private var running:Boolean = false;
		private var sourceBitmap:Bitmap;
		private var _text:String = "Hello !";
		/**
		 * 	@constructor
		 */
		public function CircleText():void 
		{
			Console.output('CircleText');
			Console.output('Credits to nitoyon');
			Console.output('Adapted by Bruce LANE (http://www.batchass.fr)');
			_color = 0x0000FF;
			parameters.addParameters(
				new ParameterColor('color', 'color'),
				new ParameterString('text', 'text'),
				new ParameterExecuteFunction('run', 'run')
			)
			addEventListener( InteractionEvent.MOUSE_MOVE, mouseMove );
			//tf.textColor = color;
			tf.text = _text;
			tf.textColor = 0xFF0000;
			tf.autoSize = "left";

			//bmp = new Bitmap(new BitmapData(DISPLAY_WIDTH, DISPLAY_HEIGHT, true, 0x0000FF00));
			bmp = new Bitmap(new BitmapData(DISPLAY_WIDTH, DISPLAY_HEIGHT, false, 0xff9933));
			sprite = new Sprite();
			addChild(sprite);
			sprite.addChild(bmp);
			
			source = new BitmapData(tf.width, tf.height, false, 0xff9933);
			source.draw(tf);
			source.applyFilter(source, source.rect, new Point(), new BlurFilter());
			source.draw(tf);
			sourceBitmap = new Bitmap( source );
			sprite.addChild(sourceBitmap);
						
			for(var i:int = 0; i < source.width; i++)
			{
				for(var j:int = 0; j < source.height; j++)
				{
					if (source.getPixel(i, j)) trace( i + ":" + source.getPixel(i, j) );
					var circle:Circle = new Circle(source.getPixel(i, j));
					circle.realx = i * 10; circle.realy = j * 10;
					circle.x = circle.realx;// + Math.random() * 300 - 150;
					circle.y = circle.realy;// + Math.random() * 300 - 150;
					circle.alpha = 0.5;
					
					sprite.addChild(circle);
					Tweener.addTween(
						circle, {
							x: circle.realx, y: circle.realy, alpha: 1, time: 1,
							delay: Math.sqrt(i + j) * Math.random()
						}
					);
				}
			}		
		}

		/**
		 * 	Render graphics
		 */
		override public function render(info:RenderInfo):void 
		{
			if ( running )
			{
				var sourceBD:BitmapData = bmp.bitmapData;
				var circle:Circle = new Circle(source.getPixel(i, j));
				circle.realx = i * 10; circle.realy = j * 10;
				circle.x = circle.realx + Math.random() * 300 - 150;
				circle.y = circle.realy + Math.random() * 300 - 150;
				circle.alpha = 0;
				sprite.addChild(circle);
				Tweener.addTween(
					circle, {
						x: circle.realx, y: circle.realy, alpha: 1, time: 1,
						delay: Math.sqrt(i + j) * Math.random()
					}
				);
	
				lastX = mx;
				lastY = my;
				if ( i++ >= source.width ) 
				{
					i = 0;
					if ( j++ > source.height ) running = false;
				}
				sourceBD.draw(circle, info.matrix, null, null, null, true);
				
			}
			info.render( sprite );		
		} 
		/**
		 * 	
		 */
		public function set text(value:String):void {
			_text = value;
			tf.text = _text;
		}
		
		/**
		 * 	
		 */
		public function get text():String {
			return _text;
		}

		public function set color(value:uint):void 
		{
			_color = value;
		}
		public function get color():uint 
		{
			return _color;
		}
		private function mouseMove(event:InteractionEvent):void 
		{
			mx = event.localX; 
			my = event.localY; 
		}
		public function run():void 
		{
			running = true;
		}
	}
}


import flash.display.Sprite;
import caurina.transitions.Tweener;
import flash.filters.GlowFilter;

class Circle extends Sprite{
	public var realx:int;
	public var realy:int;
	public function Circle( color:uint ):void{
		graphics.beginFill( color );
		graphics.drawCircle( 0, 0, 6 );
		graphics.endFill();
		mouseEnabled = true;
		
		var self:Circle = this;
		addEventListener("mouseOver", function(e:*):void{
			self.parent.addChild(self);
			
			filters = [new GlowFilter(0xffffff, 1.5)];
			Tweener.addTween(self, {
				x: realx + Math.random() * 40 - 20,
				y: realy + Math.random() * 40 - 20,
				time: .5,
				onComplete: function():void{
					Tweener.addTween(self, {
						x: self.realx, y: self.realy, time: .5,
						transition: 'easeOutSine',
						onComplete: function():void{
							filters = [];
						}
					});
				}
			});
		});
	}
}
