/** 
 * Copyright (c) 2007, www.onyx-vj.com
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
 package onyx.net
{
	import flash.events.*;
	import flash.net.XMLSocket;
	import flash.utils.Dictionary;
	
	import onyx.core.Console;
	import onyx.events.*;

	public class NthClient extends EventDispatcher
	{
		private var _socket:XMLSocket;
		private var _count:int = 0;
		private static var instance:NthClient;
		private static var creating:Boolean = false;
		private static var fingers:Object = new Object();
	
		public function NthClient() {
			if ( !creating ) {
				throw new Error("Use NthClient.getInstance()!");
			}
			_socket = new XMLSocket;
			configureListeners();
			_socket.connect("localhost", 1383);
		}
		public static function getInstance():NthClient {
			if ( !instance ) {
				creating = true;
				instance = new NthClient();
				creating = false;
			}
			return instance;
		}
		public function isConnected():Boolean {
			return _socket.connected;
		}
		
		private function configureListeners():void {
	        _socket.addEventListener(Event.CLOSE, closeHandler);
	        _socket.addEventListener(Event.CONNECT, connectHandler);
	        _socket.addEventListener(DataEvent.DATA, dataHandler);
	        _socket.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
	        _socket.addEventListener(ProgressEvent.PROGRESS, progressHandler);
	        _socket.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
	    }
	    private function closeHandler(event:Event):void {
	        trace("closeHandler: " + event);
	        dispatchEvent(new Event(Event.CLOSE));
	        removeListeners();
	    }
	    private function removeListeners():void {	        
	    	_socket.removeEventListener(Event.CLOSE, closeHandler);
	        _socket.removeEventListener(Event.CONNECT, connectHandler);
	        _socket.removeEventListener(DataEvent.DATA, dataHandler);
	        _socket.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
	        _socket.removeEventListener(ProgressEvent.PROGRESS, progressHandler);
	        _socket.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
	    }
	
	    private function connectHandler(event:Event):void {
	    	// trace("connected Event="+event);
	    	dispatchEvent(new Event(Event.CONNECT));
	        // socket.send('<connect uri="example.com/pie" user="tjt" />')
	        requestNextEvent();
	    }
	    
	    protected function requestNextEvent():void {
	     	_socket.send("<next_event/>");
	    }
	
		private function dataHandler(event:DataEvent):void {
			// trace("data="+event.data);
	        var x:XML = new XML(event.data);
	        // trace("xml name="+x.name()+" localName="+x.name().localName);
	        if ( x.localName() == "event" ) {
	        	var c:XMLList = x.children()
	        	for each ( var i:XML in c ) {
	        		var s:String = i.localName();
	        		if ( s.search("finger_") == 0 ) {
	        			var f:FingerEvent = new FingerEvent(i);
	        			updateFingers(f);
	        			dispatchEvent(f);
	        		} else {
	        			trace("Unrecognized event: "+s)
	        		}
	        	}
	        }
	       	requestNextEvent();
	    }

	    private function updateFingers(f:FingerEvent):void {
				fingers[f.fingerUID()] = new FingerState(f);
	    }
	    
	    public function getFingerStates():Object {
			return fingers;
	    }

	    private function ioErrorHandler(event:IOErrorEvent):void {
	        trace("ioErrorHandler: " + event);
	        if ( ! _socket.connected ) {
	        	Console.output("You need to start the NthEvent server...");
	        }
	    }
	
	    private function progressHandler(event:ProgressEvent):void {
	        trace("progressHandler loaded:" + event.bytesLoaded + " total: " + event.bytesTotal);
	    }
	
	    private function securityErrorHandler(event:SecurityErrorEvent):void {
	        trace("securityErrorHandler: " + event);
	    }
	}
}