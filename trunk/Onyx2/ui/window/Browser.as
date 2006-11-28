package ui.window {
	
	import flash.display.Loader;
	import flash.events.MouseEvent;
	import flash.media.Camera;
	import flash.net.URLRequest;
	
	import onyx.external.FileBrowser;
	import onyx.external.files.*;
	import onyx.settings.Settings;
	
	import ui.assets.AssetCamera;
	import ui.assets.AssetFolder;
	import ui.controls.ScrollPane;
	import ui.controls.browser.FileControl;
	import ui.controls.browser.FolderControl;
	import ui.core.DragManager;
	import ui.core.UIObject;
	import ui.events.DragEvent;
	import ui.layer.UILayer;
	import ui.text.Style;
	import ui.text.TextField;

	public final class Browser extends Window {

		private static const FILES_PER_ROW:int	= 6;
		private static const FILE_WIDTH:int		= 49;
		private static const FILE_HEIGHT:int	= 37;
		private static const FOLDER_HEIGHT:int	= 10;
		
		// holds our child objects and masks em
		private var _files:ScrollPane	= new ScrollPane(500, 204);
		private var _folders:ScrollPane	= new ScrollPane(94, 200);
		
		// constructor
		public function Browser():void {
			
			title = 'loading ... ';
			
			width = 396;
			height = 220;
			
			x = 6;
			y = 302;
			
			_files.x = 2;
			_files.y = 14;
			
			_folders.x = 300;
			_folders.y = 18;
			_folders.backgroundColor = 0x181a1b;
			
			addChild(_folders);
			addChild(_files);
			
			FileBrowser.query(Settings.INITIAL_APP_DIRECTORY, _onReceive);
		}
		
		private function _onMouseUp(event:MouseEvent):void {
		}
		
		private function _clearChildren():void {
		}
		
		private function _onReceive(list:FolderList):void {
			
			var index:int;

			title = 'file browser: [' + list.path + ']';

			// kill all previous objects here

			// Now we add all the new stuff for this folder;

			for each (var folder:Folder in list.folders) {
				
				var foldercontrol:FolderControl = new FolderControl(folder.path);
				_folders.addChild(foldercontrol);
				
				index = _folders.getChildIndex(foldercontrol);
				foldercontrol.y = FOLDER_HEIGHT * index;
				
			}
			
			for each (var file:File in list.files) {
				
				var control:FileControl = new FileControl(file.path, file.thumbnail, list.path);

				// add it to the files scrollpane
				_files.addChild(control);

				// get the index
				index = _files.getChildIndex(control);
				
				// position it
				control.x = (index % FILES_PER_ROW) * FILE_WIDTH;
				control.y = Math.floor(index / FILES_PER_ROW) * FILE_HEIGHT;
				
				// start listening to start dragging
				control.addEventListener(MouseEvent.MOUSE_DOWN, _onMouseDown);
				control.addEventListener(MouseEvent.DOUBLE_CLICK, _onDoubleClick);
				
			}
		}
		
		// double click auto-loads
		private function _onDoubleClick(event:MouseEvent):void {
			var control:FileControl = event.target as FileControl;
			UILayer.selectedLayer.load(control.path);
		}
		
		// when we start dragging
		private function _onMouseDown(event:MouseEvent):void {
			
			var control:FileControl = event.currentTarget as FileControl;
			DragManager.startDrag(control, UILayer.layers, _onDragOver, _onDragOut, _onDragDrop);
			
		}
		
		// drag functions
		private function _onDragOver(event:DragEvent):void {
			var obj:UIObject = event.currentTarget as UIObject;
			obj.highlight(0x800800, .15);
		}
		
		private function _onDragOut(event:DragEvent):void {
			var obj:UIObject = event.currentTarget as UIObject;
			obj.highlight(0, 0);
		}
		
		private function _onDragDrop(event:DragEvent):void {
			var uilayer:UILayer = event.currentTarget as UILayer
			var origin:FileControl = event.origin as FileControl;
			uilayer.highlight(0, 0);
			uilayer.load(origin.path);
			UILayer.selectLayer(uilayer);
		}
	}
}