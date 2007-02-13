package onyx.sound {
	
	import flash.display.BitmapData;
	
	import onyx.controls.Controls;
	import onyx.controls.IControlObject;
	import onyx.core.IDisposable;
	import onyx.core.PluginBase;
	import onyx.core.RenderTransform;
	import onyx.core.onyx_ns;
	import onyx.plugin.IRenderable;
	import onyx.plugin.Plugin;
	
	use namespace onyx_ns;
		
	public class Visualizer extends PluginBase implements IRenderable {

		/**
		 * 	@private
		 * 	Stores definitions
		 */
		private static var _definition:Object	= new Object();
		
		/**
		 * 	@private
		 */
		private static var _visualizers:Array		= [null];
		
		/**
		 * 	Registers a plugin
		 */
		onyx_ns static function registerPlugin(plugin:Plugin):void {
			_definition[plugin.name] = plugin;
			_visualizers.push(plugin);
			
		}

		/**
		 * 	Returns a definition
		 */
		public static function getDefinition(name:String):Plugin {
			return _definition[name];
		}
		
		/**
		 * 
		 */
		public static function get visualizers():Array {
			return _visualizers.concat();
		}
				
		/**
		 * 	@constructor
		 */
		public function Visualizer(...controls:Array):void {
			super.controls.addControl.apply(null, controls);
			SpectrumAnalyzer.register(this);
		}
		
		/**
		 * 
		 */
		public function render(source:BitmapData, transform:RenderTransform = null):void {
		}
		
		/**
		 * 
		 */
		override public function dispose():void {
			SpectrumAnalyzer.unregister(this);
		}
		
	}
}

/**

package
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.display.TextField;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.filters.BlurFilter;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.util.Timer;
	import flash.util.getTimer;
	import flash.util.trace;
	
	public class BitmapCloud extends Sprite
	{
		private const WIDTH: int = 256;
		private const HEIGHT: int = 256;
		
		private const EYEANGLE: int = 25;
		private const DISTANCE: int = 100;
		
		private const IDENTITY: Matrix = new Matrix();
		private const origin: Point = new Point();
		private const blur: BlurFilter = new BlurFilter( 4, 4, 1 );
		private const brighten: ColorTransform = new ColorTransform( 1, 1, 1, 1, 0, 0, 0, -32 );
		
		private var pixels: Array;
		private var source: BitmapData;
		private var output: BitmapData;
		private var buffer: BitmapData;
		private var pattern: Pattern;
		
		private var fpsText: TextField;
		private var fps: int;
		private var ms: int;
		
		private var mx: Number;
		private var my: Number;
		
		private var mouseDown: Boolean;
		
		[Embed(source='flash.png')] public var Image: Class;
		[Embed(source='pattern.gif')] public var PImage: Class;
		
		public function BitmapCloud()
		{
			//-- create background
			var bgLib: Bitmap = new PImage();
			var bgBmp: BitmapData = new BitmapData( bgLib.width, bgLib.height, false, 0 );
			bgBmp.draw( bgLib, IDENTITY );
			pattern = new Pattern( WIDTH, HEIGHT, bgBmp );
			pattern.drawUnify();
			addChild( new Bitmap( pattern ) );
			
			var img: Bitmap = new Image();
			source = new BitmapData( img.width, img.height, true, 0 );
			source.draw( img, IDENTITY );
			
			output = new BitmapData( WIDTH, HEIGHT, true, 0 );
			buffer = new BitmapData( WIDTH, HEIGHT, true, 0 );
			
			addChild( new Bitmap( output ) );
			
			fpsText = new TextField();
			fpsText.textColor = 0xcfcfcf;
			fpsText.autoSize = "left";
			fpsText.text = "";
			ms = getTimer();
			fps = 0;
			addChild( fpsText );
			
			create();
			
			mx = 0;
			my = 0;
			
			stage.addEventListener( 'mouseDown', onMouseDown );
			stage.addEventListener( 'mouseUp', onMouseUp );

			var timer: Timer = new Timer( 19 );
			timer.addEventListener( TimerEvent.TIMER, show );
			timer.start();
		}
		
		private function show( event: Event ): void
		{
			buffer.colorTransform( buffer.rectangle, brighten );
			buffer.applyFilter( buffer, buffer.rectangle, origin, blur );
			
			//-- clamp angles
			if( mx < -Math.PI ) mx += Math.PI * 2;
			else if( mx > +Math.PI ) mx -= Math.PI * 2;
			if( my < -Math.PI ) my += Math.PI * 2;
			else if( my > +Math.PI ) my -= Math.PI * 2;
			
			if( mouseDown )
			{
				// force mouse
				mx += ( mouseX - WIDTH / 2 ) / 1000;
				my -= ( mouseY - HEIGHT / 2 ) / 1000;
			}
			else
			{
				// force origin
				mx *= .9;
				my *= .9;
			}
			
			rotate( my, mx );
			
			var i: int = pixels.length;
			var pixel: Pixel;
			
			var sx: int;
			var sy: int;
			var p: Number;
			
			while( --i > -1 )
			{
				pixel = pixels[i];
				
				if( pixel.rz > -DISTANCE ) // clipping
				{
					p = EYEANGLE / ( pixel.rz + DISTANCE );
					
					sx = int( pixel.rx * p + .5 ) + WIDTH/2;
					sy = int( pixel.ry * p + .5 ) + HEIGHT/2;
					
					buffer.setPixel32( sx, sy, pixel.c );
				}
			}
			
			if( getTimer() - 1000 > ms )
			{
				ms = getTimer();
				fpsText.text = fps.toString();
				fps = 0;
			}
			else
			{
				++fps;
			}
			
			output.copyPixels( buffer, buffer.rectangle, origin );
		}
		
		private function rotate( ax: Number, ay: Number ): void
		{
			var tx: Number;
			var ty: Number;
			var tz: Number;
			
			var sinax: Number = Math.sin( ax );
			var cosax: Number = Math.cos( ax );
			var sinay: Number = Math.sin( ay );
			var cosay: Number = Math.cos( ay );
			
			var i: int = pixels.length;
			var p: Pixel;
			while( --i > -1 )
			{
				p = pixels[i];
				
				ty = p.wy * cosax - p.wz * sinax;
				tz = p.wy * sinax + p.wz * cosax;
				p.ry = ty;
				
				tx = p.wx * cosay + tz * sinay;
				p.rz = tz * cosay - p.wx * sinay;
				p.rx = tx;
			}
		}
		
		private function create(): void
		{
			pixels = new Array();
			
			var sw: int = source.width;
			var sh: int = source.height;
			
			var sx: int;
			var sy: int;
			
			var x: Number;
			var y: Number;
			var z: Number;
			var c: uint;
			var r: int;
			var g: int;
			var b: int;
			var p: Number;
			
			var pixel: Pixel;
			
			for( sy = 0 ; sy < sh ; sy++ )
			{
				for( sx = 0 ; sx < sw ; sx++ )
				{
					c = source.getPixel32( sx, sy );
					
					if( ( ( c >> 24 ) & 0xff ) > 0 )	// kill trans pixel
					{
						//-- play here --//
						z = Math.random() * 400 - 100 + DISTANCE;
						//---------------//
						
						p = EYEANGLE / z;
						x = ( sx - sw/2 ) / p;
						y = ( sy - sh/2 ) / p;
						r = c >> 16 & 0xff;
						g = c >> 8 & 0xff;
						b = c & 0xff;
						
						pixel = new Pixel( x, y, z - DISTANCE, c );
						
						pixels.push( pixel );
					}
				}
			}
			
			trace( pixels.length );
		}
		
		private function onMouseDown( event: Event ): void
		{
			mouseDown = true;
		}
		
		private function onMouseUp( event: Event ): void
		{
			mouseDown = false;
		}
	}
}
**/