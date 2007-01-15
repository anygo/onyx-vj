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
package {
	
	import filters.*;
	
	import flash.display.Sprite;
	import flash.system.Security;
	
	import onyx.filter.Filter;
	import onyx.plugin.*;
	
	import transitions.*;
	
	public class BaseFilters extends Sprite implements IPluginLoader {

		public function get plugins():Array {
			return [
				new Plugin('Echo Filter', 		EchoFilter, 'Threshold Transition'),
				new Plugin('Blur Filter', 		Blur, 'Threshold Transition'),
				new Plugin('Noise Filter',		NoiseFilter, 'Threshold Transition'),
				new Plugin('Repeater Filter',	Repeater, 'Threshold Transition'),
//				new Plugin('FeedBack Filter',	FeedbackFilter, 'Feedback Filter'),
				new Plugin('Blink Effect', 		Blink, 'Blinks the layer'),
				new Plugin('Frame Random', 		FrameRND, 'Threshold Transition'),
				new Plugin('MoveScale Effect', 	MoverScaler, 'Moves and Scales Object'),
				new Plugin('Matrix Effect',		MatrixEffect, ''),
				new Plugin('Bleed Filter',		PasteFilter, ''),
				new Plugin('Blur Transition',	BlurTransition, 'Blurs the loaded layer')
//				new Plugin('Dissolve Transition', DissolveTransition, 'Dissolves the loaded layer'),
//				new Plugin('Threshold Transition', ThresholdTransition, 'Threshold Transition'),
			];
		}
	}
}
