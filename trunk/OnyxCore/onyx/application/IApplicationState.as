package onyx.application
{
	public interface IApplicationState {
		
		function initialize(... args:Array):void;
		function terminate():void;
		
	}
}