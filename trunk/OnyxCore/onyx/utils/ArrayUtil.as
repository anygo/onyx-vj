package onyx.utils {
	
	public final class ArrayUtil {
		
		public static function swap(array:Array, item:Object, itemIndex2:int):Boolean {
			
			var itemIndex:int	= array.indexOf(item);
			var item2:Object	= array[itemIndex2];
			
			if (item2 && itemIndex >= 0 && itemIndex !== itemIndex2) {
				array[itemIndex]	= item2;
				array[itemIndex2]	= item;

				return true;
			}
			
			return false;
		}
		
	}
}