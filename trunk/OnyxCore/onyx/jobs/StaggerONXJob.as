package onyx.jobs {
	
	import flash.events.TimerEvent;
	import flash.net.URLRequest;
	
	import onyx.events.LayerEvent;
	import onyx.events.TransitionEvent;
	import onyx.jobs.onx.LayerLoadSettings;
	import onyx.layer.Layer;
	import onyx.layer.LayerSettings;
	import onyx.transition.Transition;
	import flash.utils.Dictionary;
	import flash.events.Event;
	import flash.utils.Timer;
	
	public final class StaggerONXJob {
		
		/**
		 * 	@private
		 */
		private var _dict:Dictionary = new Dictionary(true)
		
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