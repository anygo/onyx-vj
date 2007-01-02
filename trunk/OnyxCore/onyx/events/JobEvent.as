package onyx.events {
	
	import flash.events.Event;

	public final class JobEvent extends Event {
		
		public static const JOB_FINISHED:String = 'job_finished';
		
		public var value:*;
		
		public function JobEvent(type:String):void {
			super(type);
		}
	}
}