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
package onyx.jobs {
	
	import flash.events.*;
	import flash.net.URLRequest;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	
	import onyx.events.*;
	import onyx.jobs.onx.LayerLoadSettings;
	import onyx.layer.*;
	import onyx.transition.Transition;
	
	public final class StaggerONXJob extends Job {
		
		/**
		 * 	@private
		 */
		private var _transition:Transition;
		
		/**
		 * 	@private
		 */
		private var _jobs:Array;
		
		/**
		 * 
		 */
		private var _timer:Timer;

		/**
		 * 	@constructor
		 */
		public function StaggerONXJob(transition:Transition, jobs:Array):void {
			
			_transition = transition;
			_jobs = jobs;
			
			for each (var job:LayerLoadSettings in jobs) {
				var layer:Layer = job.layer;
				if (!layer.path) {
					layer.load(new URLRequest(job.settings.path), job.settings);
					_jobs.splice(_jobs.indexOf(job), 1);
				}
			}
			
			_timer = new Timer(_transition.duration);
			_timer.addEventListener(TimerEvent.TIMER, _loadJob);

			_loadJob();
		}
		
		/**
		 * 	@private
		 */
		private function _loadJob(event:Event = null):void {
			
			var job:LayerLoadSettings = _jobs.shift() as LayerLoadSettings;
			
			if (job) {
	
				var layer:Layer				= job.layer;
				var settings:LayerSettings	= job.settings;
				layer.load(new URLRequest(settings.path), settings, _transition);
				
				_timer.start();
				
				return;
			}

			dispose();
		}
		
		/**
		 * 
		 */
		public function dispose():void {
			_timer.removeEventListener(TimerEvent.TIMER, _loadJob);
			_timer.stop();
			_timer		= null;
			_transition	= null;
			_jobs		= null;
		}
		
	}
}