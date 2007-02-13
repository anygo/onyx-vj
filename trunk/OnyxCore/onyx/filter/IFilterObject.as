package onyx.filter
{
	public interface IFilterObject
	{
		function get filters():Array;
		function addFilter(filter:Filter):void;
		function removeFilter(filter:Filter):void;
		function getFilterIndex(filter:Filter):int;
		function moveFilter(filter:Filter, index:int):void;

	}
}