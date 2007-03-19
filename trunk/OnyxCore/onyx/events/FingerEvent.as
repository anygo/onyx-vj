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
 package onyx.events
{
	public class FingerEvent extends NthEvent
	{
		public static const DOWN:String  = "DOWN";
		public static const UP:String = "UP";
		public static const DRAG:String = "DRAG";

		public function FingerEvent(x:XML)
		{
			var t:String = x.localName();
			if ( t == "finger_up" ) {
				t = UP;
			} else if ( t == "finger_down" ) {
				t = DOWN;
			} else if ( t == "finger_drag" ) {
				t = DRAG;
			}
			// trace("FingerEvent t="+t);
			super(t,x)
		}
		public override function toString():String {
			return "FingerEvent[type="+this.type+" dev="+deviceIndex()+" fing="+fingerIndex()+"]";
		}
		public function fingerUID():String {
			// Returns unique id string across all devices
			return "d"+xml.attribute("devindex")+"_f"+xml.attribute("finger");
		}
		public function deviceIndex():int {
    		return xml.attribute("devindex");
    	}
    	public function x():Number {
    		return xml.attribute("x");
    	}
    	public function y():Number {
    		return xml.attribute("y");
    	}
    	public function fingerIndex():int {
    		return xml.attribute("finger");
    	}
    	public function proximity():Number {
    		return xml.attribute("prox");
    	}
    	public function time():Number {
    		return xml.attribute("time");
    	}
	}
}