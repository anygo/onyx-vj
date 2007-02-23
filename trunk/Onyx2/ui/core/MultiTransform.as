package ui.core {
	
	import flash.display.DisplayObject;
	import flash.geom.ColorTransform;
	import flash.geom.Transform;

	public final class MultiTransform extends Transform {
		
		/**
		 * 	@private
		 */
		private var _targets:Array;
		
		/**
		 * 	@constructor
		 */
		public function MultiTransform(obj:DisplayObject, ... targets:Array):void {
			super(obj);
			_targets = targets;
		}
		
		/**
		 * 	Override setting the colortransform to the objects
		 */
		override public function set colorTransform(value:ColorTransform):void {
			for each (var object:DisplayObject in _targets) {
				object.transform.colorTransform = value;
			}
		}
	
	}
}