package onyx.jobs {
	
	import flash.events.Event;
	
	import onyx.display.IDisplay;
	import onyx.events.RenderEvent;
	import onyx.file.FileBrowser;
	import onyx.utils.bitmap.PNGEncoder;
	import flash.display.BitmapData;
	import onyx.utils.bitmap.JPGEncoder;
	
	public final class SaveJob extends Job {
		
		private var _maxFrames:int;
		private var _currentFrame:int;
		private var _display:IDisplay;
		private var _frames:Array		= [];
		
		public function SaveJob(display:IDisplay, frames:int):void {
			_display	= display;
			_maxFrames		= frames;
			
			_display.addEventListener(RenderEvent.RENDER, _onRender);
		}
		
		private function _onRender(event:Event):void {
			
			if (_currentFrame >= _maxFrames) {
				_display.removeEventListener(RenderEvent.RENDER, _onRender);
				save();
				return;
			}
			
			_frames.push(_display.rendered.clone());

			_currentFrame++;
		}
		
		private function save():void {
			
			var encoder:JPGEncoder = new JPGEncoder();
			
			for (var count:int = 0; count < _frames.length; count++) {
				var bmp:BitmapData = _frames[count];
				FileBrowser.save(count + '.jpg', encoder.encode(bmp), _onSave);
				bmp.dispose();
			}
		}
		
		private function _onSave():void {
			trace('frame saved');
		}
		
	}
}