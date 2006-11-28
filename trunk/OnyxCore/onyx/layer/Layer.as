package onyx.layer {

	import flash.display.*;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.filters.BitmapFilter;
	import flash.filters.ColorMatrixFilter;
	import flash.geom.*;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	import flash.utils.getTimer;
	
	import onyx.content.*;
	import onyx.controls.*;
	import onyx.core.BLEND_MODES;
	import onyx.core.getBaseBitmap;
	import onyx.core.onyx_internal;
	import onyx.events.*;
	import onyx.external.Stream;
	import onyx.filter.*;
	import onyx.transition.Transition;
	
	use namespace onyx_internal;

	public class Layer extends Sprite implements ILayer {
		
		/**
		 * 	Holds the class for new transitions
		 */
		public static var transitionClass:Class;
		public static var transitionDuration:int	= 2000;

		/**
		 * 	@private
		 */
		private var _transition:Transition;

		/**
		 * 	@private
		 */
		private var _content:IContent			= new ContentNull();

		/**
		 * 	@private
		 */
		private var _settings:LayerSettings;
		
		/**
		 * 
		 */
		private var _request:URLRequest;
		
		/**
		 * 
		 */
		private var _temp:Object;
		
		/**
		 * 
		 */
		private var _source:BitmapData			= getBaseBitmap();
		
		/**
		 * 
		 */
		public var renderTime:int				= 0;

		/**
		 * 	@private
		 * 	Controls
		 */
		private const _controls:Controls = new Controls(this,
		
			new ControlNumber(	LayerProperties.DISPLAY_ALPHA,				null,	0,		1,		1),
			new ControlRange(	LayerProperties.DISPLAY_BLENDMODE,			null,	BLEND_MODES,	0),
			new ControlNumber(	LayerProperties.DISPLAY_BRIGHTNESS,			null,	-1,		1,		0),
			new ControlNumber(	LayerProperties.DISPLAY_CONTRAST,			null,	-1,		2,		0),
			new ControlNumber(	LayerProperties.DISPLAY_SCALEX,				null,	-5,		5,		1),
			new ControlNumber(	LayerProperties.DISPLAY_SCALEY,				null,	-5,		5,		1),
			new ControlNumber(	LayerProperties.DISPLAY_ROTATION,			null,	-360,	360,	0),
			new ControlNumber(	LayerProperties.DISPLAY_SATURATION,			null,	0,		2,		1),
			new ControlInt(		LayerProperties.DISPLAY_THRESHOLD,			null,	0,		100,	0),
			new ControlNumber(	LayerProperties.DISPLAY_TINT,				null,	0,		1,		0),
			new ControlNumber(	LayerProperties.DISPLAY_X,					null,	-5000,	5000,	0),
			new ControlNumber(	LayerProperties.DISPLAY_Y,					null,	-5000,	5000,	0),
			new ControlUInt  (	LayerProperties.DISPLAY_COLOR, 				null),
			new ControlNumber(	LayerProperties.DISPLAY_TIMEPERCENT,		null,	0,		1,	0),
			new ControlNumber(	LayerProperties.PLAYHEAD_RATE,				null,	-20,	20,	1),
			new ControlNumber(	LayerProperties.PLAYHEAD_RND,				null,	-20,	20,	1),

			new ControlNumber(	LayerProperties.PLAYHEAD_START,				null,	0,	1,	0),
			new ControlNumber(	LayerProperties.PLAYHEAD_END,				null,	0,	1,	1)

		);
		

		/**
		 * 	@private 
		 */
		onyx_internal var _index:int				= -1;


		/**
		 *	Constructor
		 */
		public function Layer():void {
			
			// initialize the bitmap
//			super(null);
			
//			super.smoothing = true;
			
		}

		/**
		 * 	Returns the index of the layer within the display
		 **/
		public function get index():int {
			return _index;
		}
		
		/**
		 * 	Loads a file type into a layer
		 * 	The path of the file to load into the layer
		 **/
		public function load(request:URLRequest, settings:LayerSettings = null):void {
			
			// do we have settings?
			_settings = settings;
			
			// store the request
			_request = request;
			
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
					loader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, _onLoadProgress);
					loader.load(request);
					
					_temp = loader;
					break;
				case 'onx':
					break;
				case 'flv':
					var stream:Stream = new Stream(path);
					stream.addEventListener(Event.COMPLETE, _onStreamData);
					
					_temp = stream;
					break;
			}
		}
		
		/**
		 * 	Handler for stream
		 */
		private function _onStreamData(event:Event):void {
			var stream:Stream = event.currentTarget as Stream;
			stream.removeEventListener(Event.COMPLETE, _onStreamData);
			
//			var content:ContentFLV = new ContentFLV(stream, this);
//			_addContent(content);
		}
		
		/**
		 * 	Progress
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
			
			_temp = null;
			
			if (event.type == Event.COMPLETE) {
				_addContent((info.content is MovieClip) ? new ContentSWFMovieClip(info.loader, this) : new ContentSWFSprite(info.loader, this));
			}
		}

		/**
		 * 	This is called when content has finished loading from a contentLoader;
		 *	The loader which is loading content (swf, jpg, png, etc)
		 **/
		private function _addContent(content:IContent):void {
	

			// content is null
			if (_content is ContentNull) {

				// create new bitmap
//				bitmapData = getBaseBitmap();

			}
			
			// now test to see if we have a transition
			if (transitionClass && !(_content is ContentNull)) {

				_transition = new transitionClass(transitionDuration);
				_transition.initializeTransition(_content, content, this);

				_content = content;

				removeEventListener(Event.ENTER_FRAME, _render);
				addEventListener(Event.ENTER_FRAME, _renderTransition);
				
				_renderTransition();

			} else {

				// kill old content
				_content.dispose();

				_content = content;

				// render frames
				removeEventListener(Event.ENTER_FRAME, _renderTransition);
				addEventListener(Event.ENTER_FRAME, _render);
				
				// render
				_render();

			}
			
			// dispatch a load event
			var dispatch:LayerEvent = new LayerEvent(LayerEvent.LAYER_LOADED, this);
			dispatch.layer = this;
			dispatchEvent(dispatch);
			
			// if there are settings, apply them
			if (_settings) {
				_settings.apply(this);
				_settings = null;
			}

			_controls.update();

		}

		/**
		 * 	Returns the current playhead of the layer as a percentage
		 **/
		public function get timePercent():Number {
			return _content.timePercent;
		}
		
		/**
		 * 	Sets time
		 */
		public function set time(value:Number):void {
			_content.time = value;
		}
		
		/**
		 * 	Gets time
		 */
		public function get time():Number {
			return _content.time;
		}
		
		/**
		 * 	Gets totalTime
		 */
		public function get totalTime():Number {
			return _content.totalTime;
		}

		/**
		 * 	Sets the playhead time
		 */
		public function set timePercent(value:Number):void {
			_content.time = value;
		}
		
		/**
		 * 	Returns the path of the file loaded
		 */
		public function get path():String {
			return (_request) ? _request.url : null;
		}
		
		/**
		 * 	Returns the control array of the layer
		 */
		public function get controls():Controls {
			return _controls;
		}

		/**
		 * 	Gets the framerate of the movie adjusted to it's own time rate
		 */
		public function get framerate():Number {
			return _content.framerate;
		}

		/**
		 * 	Sets the framerate
		 */
		public function set framerate(value:Number):void {
			_content.framerate = value;
		}

		/**
		 * 	Gets the framerate of the movie adjusted to it's own time rate
		 */
		public function get framernd():Number {
			return _content.framernd;
		}

		/**
		 * 	Sets the random frame
		 */
		public function set framernd(value:Number):void {
			_content.framernd = value;
		}

		/**
		 * 	Gets the start loop point
		 */
		public function get markerLeft():Number {
			return _content.markerLeft;
		}

		/**
		 * 	Sets the start loop point
		 */
		public function set markerLeft(value:Number):void {
			_content.markerLeft = value;
		}

		/**
		 * 	Gets the start marker
		 */
		public function get markerRight():Number {
			return _content.markerRight;
		}

		public function set markerRight(value:Number):void {
			_content.markerRight = value;
		}

		/**
		 * 	Pauses the layer
		 *	@param			True to pause, false to unpause
		 */
		public function pause(b:Boolean = true):void {
			_content.pause(b);
		}
		
		/**
		 * 	Returns a bitmapdata of the source file
		 **/
		public function get source():BitmapData {
			return _source;
		}
		
		/**
		 * 	Moves the layer up in the display list
		 */
		public function moveUp():void {
			trace('move up');
			dispatchEvent(new LayerEvent(LayerEvent.LAYER_MOVE_UP, this));
		}

		/**
		 * 	Moves the layer down the display list
		 */
		public function moveDown():void {
			trace('move down');
			dispatchEvent(new LayerEvent(LayerEvent.LAYER_MOVE_DOWN, this));
		}

		/**
		 * 	Copys the layer down
		 */
		public function copyLayer():void {
			dispatchEvent(new LayerEvent(LayerEvent.LAYER_COPY_LAYER, this));
		}

		/**
		 * 	Returns the threshold
		 */
		public function get threshold():int {
			return _content.threshold;
		}

		/**
		 * 	Sets the threshold
		 */
		public function set threshold(value:int):void {
			_content.threshold = value;
		}
	
		/**
		 * 	Returns contrast
		 */
		public function get contrast():Number {
			return _content.contrast;
		}
		
		/**
		 * 	Sets contrast
		 */
		public function set contrast(value:Number):void {
			_content.contrast = value;
		}

		/**
		 * 	Gets brightness
		 */
		public function get brightness():Number {
			return _content.brightness;
		}
		
		/**
		 * 	Sets brightness
		 */
		public function set brightness(value:Number):void {
			_content.brightness = value;
		}

		/**
		 * 	Sets saturation
		 */
		public function get saturation():Number {
			return _content.saturation;
		}

		/**
		 * 	Gets saturation
		 */
		public function set saturation(value:Number):void {
			_content.saturation = value;
		}

		/**
		 * 	Returns tint
		 */
		public function get tint():Number {
			return _content.tint;
		}
		
		/**
		 * 	Sets tint
		 */
		public function set tint(value:Number):void {
			_content.tint = value;
		}

		/**
		 * 	Sets color
		 */
		public function set color(value:uint):void {
			_content.color = value;
		}

		public function get color():uint {
			return _content.color;
		}
		
		override public function set alpha(value:Number):void {
			_content.alpha = value;
		}

		override public function get alpha():Number {
			return _content.alpha;
		}

		override public function set x(value:Number):void {
			_content.x = value;
		}

		override public function set y(value:Number):void {
			_content.y = value;
		}

		override public function set scaleX(value:Number):void {
			_content.scaleX = value;
		}

		override public function set scaleY(value:Number):void {
			_content.scaleY = value;
		}
		
		override public function get scaleX():Number {
			return _content.scaleX;
		}

		override public function get scaleY():Number {
			return _content.scaleY;
		}

		override public function get x():Number {
			return _content.x;
		}

		override public function get y():Number {
			return _content.y;
		}

		/**
		 * 
		 */
		public function set transition(value:Transition):void {
			_transition = value;
		}
		
		/**
		 * 	Adds an onyx-based filter
		 * 	The onyx filter to add to the Layer
		 */
		public function addFilter(filter:Filter):void {

			_content.addFilter(filter);

		}
		
		/**
		 * 	Removes an onyx filter from the layer
		 * 	@param		The filter to remove
		 **/
		public function removeFilter(filter:Filter):void {
			_content.removeFilter(filter);
		}
		
		override public function set filters(value:Array):void {
			throw new Error('Use addFilter() or removeFilter() instead');
		}
		
		/**
		 * 
		 */
		override public function get filters():Array {
			return _content.filters;
		}

		/**
		 * 	The enterframe event for rendering filters
		 */
		private function _render(event:Event = null):void {

/*			var start:int = getTimer();

			bitmapData.lock();		
			bitmapData.fillRect(bitmapData.rect, 0x00000000);

			var contentBitmapData:BitmapData = _content.draw();
			bitmapData.copyPixels(contentBitmapData, contentBitmapData.rect, new Point(0, 0));
			_content.applyFilters(bitmapData);
			
			bitmapData.unlock();
						
			renderTime = getTimer() - start;
*/
		}

		
		/**
		 * 	The enterframe event for rendering a transition
		 */
		private function _renderTransition(event:Event = null):void {
/*
			// fill in nothing
			bitmapData.fillRect(bitmapData.rect, 0x00000000);

			// draw the transition
			_transition.calculateTransition(bitmapData);
*/
		}
		/**
		 * 	Unloads the layer
		 **/
		public function unload():void {

			// disposes content
			if (_content) {

//				if (bitmapData) bitmapData.dispose();
				_content.dispose();
				
			}
			
			if (_temp) {
				if (_temp is LoaderInfo) {
					var info:LoaderInfo = _temp as LoaderInfo;
					info.removeEventListener(IOErrorEvent.IO_ERROR, _onLoadHandler);
					info.removeEventListener(Event.COMPLETE, _onLoadHandler);
					info.removeEventListener(ProgressEvent.PROGRESS, _onLoadProgress);
					info.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, _onLoadHandler);
					info.loader.close();
				}
			}

			// dispatch an unload event
			dispatchEvent(new LayerEvent(LayerEvent.LAYER_UNLOADED, this));
			
			// remove listener
			removeEventListener(Event.ENTER_FRAME, _render);
			removeEventListener(Event.ENTER_FRAME, _renderTransition);
			
			// remove content
			_content = new ContentNull();
			_settings = null;
			
		}
		
		public function endTransition(transition:Transition):void {

			var oldcontent:IContent = transition.oldContent;

			// kill old content
			oldcontent.dispose();
			
			// remove listener
			removeEventListener(Event.ENTER_FRAME, _renderTransition);

			// remove listener
			addEventListener(Event.ENTER_FRAME, _render);
 
		}
		
		public function draw(bmp:BitmapData):void {
/*			
			var scaleX:Number = bmp.width / bitmapData.width;
			var scaleY:Number = bmp.height / bitmapData.height;
			
			var matrix:Matrix = new Matrix();
			matrix.scale(scaleX, scaleY);
			bmp.draw(bitmapData, matrix);
*/
		}
		
		/**
		 * 	Merges a layer into the current layer (no load)
		 */
		public function merge(layer:Layer):void {
		}
		
		public function dispose():void {
		}

	}
}