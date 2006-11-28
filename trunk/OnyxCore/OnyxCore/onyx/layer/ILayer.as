package onyx.layer {

	import onyx.layer.IContent;
	import onyx.transition.Transition;
	
	public interface ILayer extends IColorObject {
		function endTransition(transition:Transition):void;
	}
}