package onyx.layer {
	
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLRequest;
	
	import onyx.content.*;
	import onyx.core.IDisposable;
	import onyx.events.ContentEvent;
	import onyx.net.Stream;

	/**
	 * 	Loads content
	 */
	internal final class ContentLoader extends EventDispatcher {
		
		/**
		 * 	@Constructor
		 */
		public function ContentLoader(request:URLRequest):void {
		
			// get the path
			var path:String = request.url;
			
			// do different stuff based on the extension
			var extension:String = path.substr(path.lastIndexOf('.')+1, path.length).toLowerCase();
			
			// do different stuff based on the extension
			switch (extension) {
				// load a loader if we're any other type of file
				case 'jpg':
				case 'jpeg':
				case 'png':
				case 'swf':
				
					var loader:Loader  = new Loader();
					loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, _onLoadHandler);
					loader.contentLoaderInfo.addEventListener(Event.COMPLETE, _onLoadHandler);
					loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, _onLoadProgress);
					loader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, _onLoadHandler);
					loader.load(request);
					
					break;
				case 'onx':
					break;
					
			}
		}
		
		/**
		 * 	Progress handler, forward the event
		 */
		private function _onLoadProgress(event:ProgressEvent):void {
			dispatchEvent(event);
		}
		
		/**
		 * 	Handler for loaded loaders
		 */
		private function _onLoadHandler(event:Event):void {
			
			var info:LoaderInfo = event.currentTarget as LoaderInfo;
			info.removeEventListener(IOErrorEvent.IO_ERROR, _onLoadHandler);
			info.removeEventListener(Event.COMPLETE, _onLoadHandler);
			info.removeEventListener(ProgressEvent.PROGRESS, _onLoadProgress);
			info.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, _onLoadHandler);
			
			var dispatch:ContentEvent = new ContentEvent(ContentEvent.CONTENT_STATUS);
			
			switch (event.type) {
				
				case Event.COMPLETE:
					dispatch.content = info.loader;
					break;
				
				// set error messages
				case SecurityErrorEvent.SECURITY_ERROR:
					dispatch.errorMessage = (event as SecurityErrorEvent).text;
					break;
					
				case IOErrorEvent.IO_ERROR:
					dispatch.errorMessage = (event as IOErrorEvent).text;
					break;
			}
			
			dispatchEvent(dispatch);
			
		}
	}
}