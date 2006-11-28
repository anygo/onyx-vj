package ui.events {
	
	import flash.errors.StackOverflowError;
	import flash.events.Event;

	public final class DragEvent extends Event {
		
		public static const DRAG_OVER:String	= 'dragover';
		public static const DRAG_OUT:String	= 'dragout';
		public static const DRAG_DROP:String	= 'dragdrop';
		
		public var origin:*;
		
		public function DragEvent(type:String):void {
			super(type);
		}
		
	}
}