package onyx.events {
	
	import flash.events.Event;
	import onyx.layer.Layer;
	import onyx.core.onyx_internal;
	
	use namespace onyx_internal;

	public final class LayerEvent extends Event {
		
		onyx_internal static const LAYER_MOVE_UP:String		= 'layermoveup';
		onyx_internal static const LAYER_MOVE_DOWN:String	= 'layermovedown';
		onyx_internal static const LAYER_COPY_LAYER:String	= 'layercopy';

		public static const LAYER_LOADED:String		= 'layerload';
		public static const LAYER_UNLOADED:String	= 'layerunload';
		public static const LAYER_CREATED:String	= 'layercreate';
		public static const LAYER_MOVE:String		= 'layermove';

		public var layer:Layer;
		
		public function LayerEvent(type:String, layer:Layer):void {
			this.layer = layer;
			super(type); 
		}
		
	}
}