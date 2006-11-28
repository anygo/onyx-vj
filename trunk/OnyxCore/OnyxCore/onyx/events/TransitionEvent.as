package onyx.events {
	
	import flash.events.Event;
	import onyx.transition.Transition;

	public final class TransitionEvent extends Event {
		
		public static const TRANSITION_CREATED:String 	= 'tcreate';
		
		public var definition:Class;
		public var index:int;
		
		public function TransitionEvent(type:String):void {
			super(type);
		}
	}
}