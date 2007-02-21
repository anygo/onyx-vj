package ui.policy {

	import flash.events.IEventDispatcher;
	import flash.utils.Dictionary;
	
	public class Policy {
		
		/**
		 * 	@private
		 */
		private static var _dict:Dictionary = new Dictionary(true);
		
		/**
		 * 	Adds a policy to an object
		 */
		public static function addPolicy(target:IEventDispatcher, policy:Policy):void {
			
			// no policies for object
			if (!_dict[target]) {
				var policies:Array = []
				_dict[target] = policies;
			} else {
				policies = _dict[target];
			}
			
			// add the policy
			policies.push(policy);
			
			// initialize
			policy.initialize(target);
			
		}
		
		/**
		 * 
		 */
		public function initialize(target:IEventDispatcher):void {
		}
		
		/**
		 * 
		 */
		public function terminate(target:IEventDispatcher):void {
		}
	}
}