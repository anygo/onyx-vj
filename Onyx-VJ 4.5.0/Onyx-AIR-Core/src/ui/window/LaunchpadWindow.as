/**
 * Copyright (c) 2003-2012 "Onyx-VJ Team" which is comprised of:
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
 */

package ui.window {
	
	
	import flash.display.Sprite;
	import flash.events.*;
	import flash.ui.*;
	import flash.utils.Timer;
	
	import onyx.core.*;
	import onyx.display.BlendModes;
	import onyx.display.OutputDisplay;
	import onyx.plugin.*;
	import onyx.system.NativeAppLauncher;
	import onyx.tween.Tween;
	import onyx.tween.TweenProperty;
	import onyx.utils.string.*;
	
	import services.remote.DirectLanConnection;
	
	import ui.controls.*;
	import ui.core.*;
	import ui.layer.UILayer;
	import ui.policy.*;
	import ui.states.*;
	
	/**
	 * 	Remote Mapping Window
	 */
	public final class LaunchpadWindow extends Window {
		
		/**
		 * 	@private
		 */
		private var pane:ScrollPane;
		private var connectBtn:TextButton;
		private var outputBtn:TextButton;
		private var resetBtn:TextButton;
		private var lightAllBtn:TextButton;
		
		private var tween:Tween;
		private var index:int = 0;
		private var selectedLayer:int = 0;
		private var timer:Timer = new Timer(1000);
		private var pathToExe:String = 'MidiPipe.exe';
		private var tempText:String	= 'outp launchpad';
		private var appLauncher:NativeAppLauncher;		
		private var numerator:uint = 1;
		private var denominator:uint = 3;

		/**
		 * 	@Constructor
		 */
		public function LaunchpadWindow(reg:WindowRegistration):void {
			
			// position & create
			super(reg, true, 260, 217);
			
			// show controls
			init();
			
			// we are draggable
			DragManager.setDraggable(this, true);
			
		}
		
		/**
		 * 	@private
		 */
		private function init():void 
		{
			var index:int = 0;			
			pane		= new ScrollPane(242, 100);
			pane.x		= 3;
			pane.y		= 18;
			addChild(pane);
			
			var options:UIOptions	= new UIOptions( true, true, null, 60, 12 );
			connectBtn					= new TextButton(options, 'connect'),
			connectBtn.addEventListener(MouseEvent.MOUSE_DOWN, start);
			pane.addChild(connectBtn).y = (index++ * 15);		
			
			outputBtn				= new TextButton(options, 'outp launchpad'),
			outputBtn.addEventListener(MouseEvent.MOUSE_DOWN, outpMsg);
			pane.addChild(outputBtn).y = (index++ * 15);
			
			resetBtn				= new TextButton(options, 'reset btns'),
			resetBtn.addEventListener(MouseEvent.MOUSE_DOWN, reset);
			pane.addChild(resetBtn).y = (index++ * 15);
			
			lightAllBtn				= new TextButton(options, 'light all'),
			lightAllBtn.addEventListener(MouseEvent.MOUSE_DOWN, lightAll);
			pane.addChild(lightAllBtn).y = (index++ * 15);
			
			appLauncher = new NativeAppLauncher(pathToExe);
			appLauncher.addEventListener( Event.ACTIVATE, activate );
			appLauncher.addEventListener( Event.CLOSE, closed );
			appLauncher.addEventListener( Event.CHANGE, change );
			
			timer.addEventListener(TimerEvent.TIMER, onTimer);
			timer.start();
		}
		public function start(event:MouseEvent):void 
		{
			appLauncher.launchExe();
			event.stopPropagation();
		}
		private function outpMsg(event:MouseEvent):void 
		{
			appLauncher.writeData('list');
			appLauncher.writeData('outp launchpad');
			appLauncher.writeData('inpt loop');
			appLauncher.writeData('144,64,29');
			appLauncher.writeData('144,65,29');
			appLauncher.writeData('144,66,29');
			appLauncher.writeData('144,67,29');
			appLauncher.writeData('144,96,29');			
			event.stopPropagation();
		}
		/*public function write():void 
		{			
			appLauncher.writeData(tempText);
			if (tempText == 'outp launchpad') tempText = 'inpt loop';
		}*/
		public function reset(event:MouseEvent):void 
		{			
			appLauncher.writeData('176,0,0');
			event.stopPropagation();
		}
		public function lightAll(event:MouseEvent):void 
		{			
			appLauncher.writeData('176,0,127');
			event.stopPropagation();
		}
		public function dutyCycle():void 
		{	
			if (numerator++>7) numerator = 1;
			if (denominator++>17) denominator = 3;
			var duty:uint = (16 * (numerator - 1)) + (denominator - 3);
			//if (duty > 127) duty = 0;
			appLauncher.writeData('176,30,' + duty);
		}
		public function gradient():void
		{
			for (var red:uint=0;red<8;red++)
			{
				for (var green:uint=0;green<8;green++)
				{
					var colour:uint = 12 + red + (green*16);
					var pos:uint = red + ((green)*16);
					appLauncher.writeData('144,' + pos + ',' + colour);
				}	
			}
		}
		private function lightPad( padIndex:uint, color:uint):void
		{
			appLauncher.writeData('144,' + padIndex + ',29' );
		}
		private function onTimer(event:TimerEvent):void 
		{
			
			var layer:Layer	= (UIObject.selection as UILayer).layer;
			//dutyCycle();
		}

		private function tweenFinish(event:Event):void {
			tween.removeEventListener(Event.COMPLETE, tweenFinish);
			var layer:Layer = Display.getLayerAt(selectedLayer);
			layer.visible = false;
		}
		private function sendMsg(event:MouseEvent):void {
			switch (event.currentTarget) {
				case connectBtn:
					
					break;
			}
			event.stopPropagation();
		}
		public function change(evt:Event):void 
		{
			var cmd:String = appLauncher.readAppOutput();
			var data1:uint = uint(cmd);
			var x:uint = Math.abs(data1-36)/4;
			var y:uint = Math.abs(data1-36)%4;
			var pos:uint = y + ((x)*8);
			appLauncher.writeData('144,' + data1 + ',58' );
			//3 = red, 5=low red, 30=mid orange,
			trace("change:" + data1+" x:" + x +" y:" + y +" pos:" + pos);	
			switch ( data1 ) 
			{ 
				// 1st line: layer select
				case 64:
				case 65:
				case 66:
				case 67:
				case 96:
					if ( selectedLayer != data1-64 )
					{						
						appLauncher.writeData('144,64,29');
						appLauncher.writeData('144,65,29');
						appLauncher.writeData('144,66,29');
						appLauncher.writeData('144,67,29');
						appLauncher.writeData('144,96,29');
						selectedLayer = data1-64;
						if ( selectedLayer > 3 ) selectedLayer = 4;
						UILayer.selectLayer(selectedLayer);
						var layer:Layer = Display.getLayerAt(selectedLayer);
						appLauncher.writeData('144,' + data1 + ',' + 60);
						if (layer.visible) 
						{
							
						}
						else
						{
							
						}
					}
					break;	
				// go to A
				case 97:
					if ( Display.channelMix > 0 ) Display.channelMix -= 0.03;
					break;
				// go to B
				case 98:
					if ( Display.channelMix < 1 ) Display.channelMix += 0.03;
					break;
				// switch A/B
				case 99:
					const property:TweenProperty = (Display.channelMix > .5) ? new TweenProperty('channelMix', Display.channelMix, 0) : new TweenProperty('channelMix', Display.channelMix, 1);					
					new Tween( Display, 4000, property );
					break;
				//2nd line visibility
				case 60:
				case 61:
				case 62:
				case 63:
				case 92:
					index = data1 - 60;
					selectedLayer = index;
					if ( selectedLayer > 3 ) selectedLayer = 4;
					var layer:Layer = Display.getLayerAt(selectedLayer);
					
					trace(layer.channel);// = true;
					layer.pause(true);
					if (layer.visible)
					{
						appLauncher.writeData('144,'+data1+',13');
						tween = new Tween(
							layer,
							250,
							new TweenProperty('alpha', layer.alpha, 0)
						);
						tween.addEventListener(Event.COMPLETE, tweenFinish);
					} 
					else 
					{
						appLauncher.writeData('144,'+data1+',60');
						layer.visible = true;
						tween = new Tween(
							layer,
							250,
							new TweenProperty('alpha', 0, 1)
						);
					}
					break;
				case 95:
					if (Display.brightness < 0)
					{
						appLauncher.writeData('144,95,60');
					}
					else
					{
						appLauncher.writeData('144,95,13');
					}
					new Tween(
						Display,
						500,
						new TweenProperty('brightness', Display.brightness, (Display.brightness < 0) ? 0 : -1)
					)
					break;
				case 104:
					for each (var layer:Layer in Display.layers) {
					layer.framerate += .5;
				}
					break;
				case 105:
					for each (var layer:Layer in Display.layers) {
					layer.framerate -= .5;
				}
					break;
				case "cycle-blendmode-down":
					var layer:Layer	= (UIObject.selection as UILayer).layer;
					layer.blendMode	= BlendModes[Math.min(BlendModes.indexOf(layer.blendMode)+1, BlendModes.length - 1)];
					break;
				case "cycle-blendmode-up":
					var layer:Layer	= (UIObject.selection as UILayer).layer;
					layer.blendMode	= BlendModes[Math.max(BlendModes.indexOf(layer.blendMode)-1,0)];	
					break;
				
				
				/*case "rotation":
					var layer:Layer	= (UIObject.selection as UILayer).layer;
					
					var rTween:Tween = new Tween(
						layer,
						250,
						new TweenProperty('rotation', layer.rotation, dataReceived.value)
					);
					break;
				case "alpha":
					var layer:Layer	= (UIObject.selection as UILayer).layer;
					
					var rTween:Tween = new Tween(
						layer,
						25,
						new TweenProperty('alpha', layer.alpha, dataReceived.value/100)
					);
					break;*/
				case "bounce":
					var layer:Layer	= (UIObject.selection as UILayer).layer;
					
					/*const totalTime:int	= layer.totalTime;
					const time:int		= layer.time * totalTime;
					const start:int		= layer.loopStart * totalTime;
					const end:int		= layer.loopEnd	* totalTime;
					const frame:int		= layer.framerate * Display.frameRate * 2;
					
					if (time + frame > end || time + frame < start) {*/
					layer.framerate	*= -1;
					//}
					break;
				/*case "x":
					var layer:Layer	= (UIObject.selection as UILayer).layer;
					
					var rTween:Tween = new Tween(
						layer,
						25,
						new TweenProperty('x', layer.x, dataReceived.value)
					);
					break;*/
				//layer.content onyx.display.ContentCustom
				//layer.content.customParameters
				//layer.content.customParameters.length
				//layer.content.customParameters[6].value //6 rotx
				/*case "y":
					var layer:Layer	= (UIObject.selection as UILayer).layer;
					
					var rTween:Tween = new Tween(
						layer,
						25,
						new TweenProperty('y', layer.y, dataReceived.value)
					);
					break;
				case "brightness":
					var layer:Layer	= (UIObject.selection as UILayer).layer;
					
					var rTween:Tween = new Tween(
						layer,
						25,
						new TweenProperty('brightness', layer.brightness, dataReceived.value/100)
					);
					break;
				case "contrast":
					var layer:Layer	= (UIObject.selection as UILayer).layer;
					
					var rTween:Tween = new Tween(
						layer,
						25,
						new TweenProperty('contrast', layer.contrast, dataReceived.value/100)
					);
					break;
				case "saturation":
					var layer:Layer	= (UIObject.selection as UILayer).layer;
					
					var rTween:Tween = new Tween(
						layer,
						25,
						new TweenProperty('saturation', layer.saturation, dataReceived.value/100)
					);
					break;*/
				default: 
					
					break;
			}
		}
		
		private function activate(evt:Event):void
		{
			trace("activate");
			//running = true;
		}
		private function closed(evt:Event):void
		{
			trace("closed");
			//running = false;
		}
		/**
		 * 
		 */
		override public function dispose():void 
		{					
			// dispose
			super.dispose(); 
		}
	}
}
