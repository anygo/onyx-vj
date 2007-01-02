package onyx.application {
	
	/**
	 * 	Manager class that loads and removes states
	 */
	public final class StateManager {
		
		/**
		 * 	@private
		 * 	Stores states	
		 */
		private static var _states:Array			= [];

		/**
		 * 	Loads an application state
		 */
		internal static function loadState(state:ApplicationState, ... args:Array):void {

			_states.push(state);
			state.initialize.apply(state, args);

		}
		
		/**
		 * 	Removes an application state
		 */
		internal static function removeState(state:ApplicationState):void {
			state.terminate();
			_states.splice(_states.indexOf(state), 1);
		}

		
	}
}