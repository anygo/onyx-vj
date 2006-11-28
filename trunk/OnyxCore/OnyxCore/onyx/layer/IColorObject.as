package onyx.layer {
	
	import onyx.filter.Filter;
	
	public interface IColorObject {
		
		function set color(value:uint):void;
		function get color():uint;

		function get alpha():Number;
		function set alpha(value:Number):void;

		function get brightness():Number;
		function set brightness(value:Number):void;

		function get contrast():Number;
		function set contrast(value:Number):void;

		function get scaleX():Number;
		function set scaleX(value:Number):void;

		function get scaleY():Number;
		function set scaleY(value:Number):void;

		function get rotation():Number;
		function set rotation(value:Number):void;

		function get saturation():Number;
		function set saturation(value:Number):void;

		function get threshold():int;
		function set threshold(value:int):void;

		function get tint():Number;
		function set tint(value:Number):void;

		function get x():Number;
		function set x(value:Number):void;

		function get y():Number;
		function set y(value:Number):void;
		
	}
}