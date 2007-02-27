/** 
 * Copyright (c) 2003-2006, www.onyx-vj.com
 * All rights reserved.	
 * 
 * Redistribution and use in source and binary forms, with or without modification,
 * are permitted provided that the following conditions are met:
 * 
 * -  Redistributions of source code must retain the above copyright notice, this 
 *    list of conditions and the following disclaimer.
 * 
 * -  Redistributions in binary form must reproduce the above copyright notice, 
 *    this list of conditions and the following disclaimer in the documentation 
 *    and/or other materials provided with the distribution.
 * 
 * -  Neither the name of the www.onyx-vj.com nor the names of its contributors 
 *    may be used to endorse or promote products derived from this software without 
 *    specific prior written permission.
 * 
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND 
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED 
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. 
 * IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, 
 * INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
 * NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
 * PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, 
 * WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE 
 * POSSIBILITY OF SUCH DAMAGE.
 * 
 */
package ui.window {
	
	import flash.display.Loader;
	import flash.events.MouseEvent;
	import flash.media.Camera;
	import flash.net.URLRequest;
	
	import onyx.core.*;
	import onyx.file.*;
	import onyx.layer.LayerSettings;
	
	import ui.assets.*;
	import ui.controls.*;
	import ui.controls.browser.*;
	import ui.core.*;
	import ui.events.DragEvent;
	import ui.layer.UILayer;
	import ui.styles.*;
	import ui.text.*;

	/**
	 * 	File Explorer
	 */
	public final class Browser extends Window {

		/**
		 * 	@private
		 */
		private static const FILES_PER_ROW:int	= 6;
		
		/**
		 * 	@private
		 */
		private static const FILE_WIDTH:int		= 49;
		
		/**
		 * 	@private
		 */
		private static const FILE_HEIGHT:int	= 37;
		
		/**
		 * 	@private
		 */
		private static const FOLDER_HEIGHT:int	= 10;
		
		/**
		 * 	Holds the file objects
		 */
		private var _files:ScrollPane	= new ScrollPane(300, 185);
		
		/**
		 * 	Holds the folder objects
		 */
		private var _folders:ScrollPane	= new ScrollPane(90, 185);
		
		/**
		 * 	@constructor
		 */
		public function Browser():void {
			
			super('loading ... ', 396, 200, 6, 318);
			
			_files.x = 2;
			_files.y = 14;
			
			_folders.x = 304;
			_folders.y = 14;
			_folders.backgroundColor = 0x0d0d0d;
			
			addChild(_folders);
			addChild(_files);
			
			// query default folder
			FileBrowser.query(FileBrowser.initialDirectory + Settings.INITIAL_APP_DIRECTORY, _onReceive);
		}
		
		/**
		 * 	@private
		 * 	Clears children
		 */
		private function _clearChildren():void {
			
			while (_files.numChildren) {
				var control:FileControl = _files.removeChildAt(0) as FileControl;

				// stop listening to start dragging
				control.removeEventListener(MouseEvent.MOUSE_DOWN, _onMouseDown);
				control.removeEventListener(MouseEvent.DOUBLE_CLICK, _onDoubleClick);

			}
			
			while (_folders.numChildren) {
				var folder:FolderControl = _folders.removeChildAt(0) as FolderControl;
				folder.removeEventListener(MouseEvent.MOUSE_DOWN, _onFolderDown);
			}
		}
		
		/**
		 * 	@private
		 */
		private function _onReceive(list:FolderList):void {
			
			var index:int;

			title = 'file browser: [' + list.path + ']';

			// kill all previous objects here
			_clearChildren();

			// Now we add all the new stuff for this folder;

			_folders.reset();
			for each (var folder:Folder in list.folders) {
				
				var foldercontrol:FolderControl = new FolderControl(folder);
				foldercontrol.addEventListener(MouseEvent.MOUSE_DOWN, _onFolderDown);
				_folders.addChild(foldercontrol);
				
				index = _folders.getChildIndex(foldercontrol);
				foldercontrol.x = 3;
				foldercontrol.y = FOLDER_HEIGHT * index + 2;
				
			}
			
			_files.reset();
			for each (var file:File in list.files) {
				
				var control:FileControl = new FileControl(file);

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
		
		/**
		 * 	@private
		 *  double click auto-loads
		 */
		private function _onDoubleClick(event:MouseEvent):void {
			var control:FileControl = event.target as FileControl;

			if (event.ctrlKey && UILayer.selectedLayer.layer.path) {
				var settings:LayerSettings = new LayerSettings();
				settings.load(UILayer.selectedLayer.layer);
			}
			
			UILayer.selectedLayer.load(control.path, settings);
		}
		
		/**
		 * 	@private
		 *  when we start dragging
		 */
		private function _onMouseDown(event:MouseEvent):void {
			
			var control:FileControl = event.currentTarget as FileControl;
			DragManager.startDrag(control, UILayer.layers, _onDragOver, _onDragOut, _onDragDrop);
			
		}
		
		/**
		 * 	@private
		 *  when a folder is clicked
		 */
		private function _onFolderDown(event:MouseEvent):void {
			var control:FolderControl = event.currentTarget as FolderControl;

			FileBrowser.query(control.path, _onReceive);

		}
		
		/**
		 * 	@private
		 *  drag functions
		 */
		private function _onDragOver(event:DragEvent):void {
			var obj:UIObject = event.currentTarget as UIObject;
			obj.transform.colorTransform = DRAG_HIGHLIGHT;
		}
		
		/**
		 * 	@private
		 *  drag functions
		 */
		private function _onDragOut(event:DragEvent):void {
			var obj:UIObject = event.currentTarget as UIObject;
			obj.transform.colorTransform = (obj == UILayer.selectedLayer) ? LAYER_HIGHLIGHT : DEFAULT;
		}
		
		/**
		 * 	@private
		 *  drag functions
		 */
		private function _onDragDrop(event:DragEvent):void {
			var uilayer:UILayer = event.currentTarget as UILayer
			var origin:FileControl = event.origin as FileControl;
			
			uilayer.transform.colorTransform = DEFAULT;

			if (event.ctrlKey && uilayer.layer.path) {
				var settings:LayerSettings = new LayerSettings();
				settings.load(uilayer.layer);
			}

			uilayer.load(origin.path, settings);
			UILayer.selectLayer(uilayer);
		}
	}
}