package onyx.content
{
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.geom.Matrix;
	
	import onyx.controls.Controls;
	import onyx.core.RenderTransform;
	import onyx.filter.Filter;

	public final class ContentNull implements IContent
	{
		public function get source():BitmapData
		{
			return null;
		}
		
		public function get totalTime():int
		{
			return 0;
		}
		
		public function get filters():Array
		{
			return null;
		}
		
		public function removeFilter(filter:Filter):void
		{
		}
		
		public function get rendered():BitmapData
		{
			return null;
		}
		
		public function get loopStart():Number
		{
			return 0;
		}
		
		public function set loopStart(value:Number):void
		{
		}
		
		public function set time(value:Number):void
		{
		}
		
		public function get time():Number
		{
			return 0;
		}
		
		public function get loopEnd():Number
		{
			return 0;
		}
		
		public function set loopEnd(value:Number):void
		{
		}
		
		public function addFilter(filter:Filter):void
		{
		}
		
		public function getFilterIndex(filter:Filter):int
		{
			return 0;
		}
		
		public function set framerate(value:Number):void
		{
		}
		
		public function get framerate():Number
		{
			return 0;
		}
		
		public function moveFilter(filter:Filter, index:int):void
		{
		}
		
		public function set matrix(value:Matrix):void
		{
		}
		
		public function pause(b:Boolean=true):void
		{
		}
		
		public function get controls():Controls
		{
			return null;
		}
		
		public function dispose():void
		{
		}
		
		public function set tint(value:Number):void
		{
		}
		
		public function get tint():Number
		{
			return 0;
		}
		
		public function set alpha(value:Number):void
		{
		}
		
		public function get alpha():Number
		{
			return 0;
		}
		
		public function get contrast():Number
		{
			return 0;
		}
		
		public function set contrast(value:Number):void
		{
		}
		
		public function set color(value:uint):void
		{
		}
		
		public function get color():uint
		{
			return 0;
		}
		
		public function set threshold(value:int):void
		{
		}
		
		public function get threshold():int
		{
			return 0;
		}
		
		public function get saturation():Number
		{
			return 0;
		}
		
		public function set saturation(value:Number):void
		{
		}
		
		public function set y(value:Number):void
		{
		}
		
		public function get y():Number
		{
			return 0;
		}
		
		public function get brightness():Number
		{
			return 0;
		}
		
		public function set brightness(value:Number):void
		{
		}
		
		public function get blendMode():String
		{
			return null;
		}
		
		public function set blendMode(value:String):void
		{
		}
		
		public function set x(value:Number):void
		{
		}
		
		public function get x():Number
		{
			return 0;
		}
		
		public function get scaleY():Number
		{
			return 0;
		}
		
		public function set scaleY(value:Number):void
		{
		}
		
		public function get scaleX():Number
		{
			return 0;
		}
		
		public function set scaleX(value:Number):void
		{
		}
		
		public function set rotation(value:Number):void
		{
		}
		
		public function get rotation():Number
		{
			return 0;
		}
		
		public function render(source:BitmapData, transform:RenderTransform=null):void
		{
		}
		
		public function hasEventListener(type:String):Boolean
		{
			return false;
		}
		
		public function willTrigger(type:String):Boolean
		{
			return false;
		}
		
		public function addEventListener(type:String, listener:Function, useCapture:Boolean=false, priority:int=0.0, useWeakReference:Boolean=false):void
		{
		}
		
		public function removeEventListener(type:String, listener:Function, useCapture:Boolean=false):void
		{
		}
		
		public function dispatchEvent(event:Event):Boolean
		{
			return false;
		}
		
	}
}