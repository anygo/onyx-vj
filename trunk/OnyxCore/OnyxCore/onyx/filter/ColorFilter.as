package onyx.filter {
	
	import flash.filters.ColorMatrixFilter;
	import flash.geom.Matrix;
	
	import onyx.core.onyx_internal;
	
	use namespace onyx_internal;
	
	public final class ColorFilter {


		/**
		 * 	@private
		 */
		private static const MATRIX_DEFAULT:Array 	= [	1,0,0,0,0,
														0,1,0,0,0,
														0,0,1,0,0,
														0,0,0,1,0];

		/**
		 * 	@private
		 */
		private static const LUMINANCE_R:Number			= 0.212671;

		/**
		 * 	@private
		 */
		private static const LUMINANCE_G:Number			= 0.715160;

		/**
		 * 	@private
		 */
		private static const LUMINANCE_B:Number			= 0.072169;
		
		/**
		 * 	@private
		 */
		onyx_internal var _threshold:int				= 0;

		/**
		 * 	@private
		 */
		onyx_internal var _brightness:Number			= 0;

		/**
		 * 	@private
		 */
		onyx_internal var _contrast:Number				= 0;

		/**
		 * 	@private
		 */
		onyx_internal var _saturation:Number			= 1;
		
		/**
		 * 	@private
		 */
		private var _matrix:Array						= MATRIX_DEFAULT.concat();

		/**
		 * 	Filter
		 */
		public var filter:ColorMatrixFilter				= new ColorMatrixFilter(MATRIX_DEFAULT);
		
		/**
		 * 	@private
		 */
		onyx_internal var _color:uint					= 0;
		
		/**
		 * 	@private
		 */
		onyx_internal var _tint:Number					= 0;

		/**
		 * 	Returns threshold
		 */		
		public function get threshold():int {
			return _threshold;
		}

		/**
		 * 	Sets threshold
		 */
		public function set threshold(value:int):void {

			if (value !== _threshold) {
				
				var oldvalue:Number = _threshold;
				var thresh:Number = -256;
				
//				trace(thresh);
				
				_threshold = value;
/*				applyMatrix(
					[	0, 0, 0, 0,  thresh, 
						0, 0, 0, 0,  thresh, 
						0, 0, 0, 0,  thresh, 
						0, 0, 0, 0, 0
					]
				);
*/
				applyMatrix();
			}


			/* values 0 through 2 */
			// if (t != _threshold) {
			//	_threshold = t;
			//	applyMatrix();
			//}
			
		}

		/**
		 * 	Returns contrast
		 */	
		public function get contrast():Number {
			return _contrast;
		}
		
		/**
		 * 	Sets contrast
		 */
		public function set contrast(c:Number):void {
			if (_contrast !== c) {
				var old:Number = 1 + _contrast;
				var v:Number = 1 + c;
			
				var mat:Array = [	v - old,0,0,0, (128*(1-v)) - (128*(1-old)),
								0,v - old,0,0, (128*(1-v)) - (128*(1-old)),
								0,0,v - old,0, (128*(1-v)) - (128*(1-old)),
								0,0,0,0,0];
									
				_contrast = c;
				applyMatrix(mat);
			}
		}

		/**
		 * 	Gets brightness
		 */
		public function get brightness():Number {
			return _brightness;
		}
		
		/**
		 * 	Sets brightness
		 */
		public function set brightness(value:Number):void {
			if (_brightness != value) {
				var old:Number = 255 * _brightness;
				_brightness = value;
				var v:Number = 255 * value;
			
				applyMatrix([	0,0,0,0,v - old,
								0,0,0,0,v - old,
								0,0,0,0,v - old,
								0,0,0,0,0]
				);
			}
		}

		/**
		 * 	Gets saturation
		 */
		public function get saturation():Number {
			return _saturation;
		}

		/**
		 * 	Sets saturation
		 */
		public function set saturation(s:Number):void {
			if (s !== _saturation) {
				_saturation = s;
				applyMatrix();
			}
		}

		/**
		 * 	@private
		 */
		private function applyMatrix(mat:Array = null):void {
			
			if (mat) {
				_matrix = matrixAdd(mat);
			}
				
			var newmatrix:Array = _matrix.concat();

			// apply saturation
			if (_saturation != 1) {
				var s:Number = _saturation;
			
				var irlum:Number = (1-s) * LUMINANCE_R;
				var iglum:Number = (1-s) * LUMINANCE_G;
				var iblum:Number = (1-s) * LUMINANCE_B;
			
				newmatrix = matrixBlend(newmatrix, 
					[		irlum + s	, iglum    , iblum    , 0, 0,
			  				irlum  	, iglum + s, iblum    , 0, 0,
			    			irlum	, iglum    , iblum + s, 0, 0,
			    			0		, 0        , 0        , 1, 0 ]
				);
			}
			
			if (_threshold > 0) {
				var thresh:Number = -256 * ((100 - _threshold));
										
				newmatrix = matrixBlend(
					newmatrix, 
					[	64, 64, 64, 0,  thresh, 
						64, 64, 64, 0,  thresh, 
						64, 64, 64, 0,  thresh, 
						0, 0, 0, 1, 0
					]
				);
			}
				
			
			filter.matrix = newmatrix;
		}
		
		/**
		 * 	@private
		 */
		private function matrixAdd(mat:Array):Array {
			var newMatrix:Array = [];
			var matrixlength:int = mat.length;
			for (var i:int = 0;i < matrixlength;i++) {
				var orig:Number = filter.matrix[i];
				var newm:Number = mat[i]
				newMatrix.push(orig + newm);
			}

			return newMatrix;
		}
		
		/**
		 * 	@private
		 */
		private function matrixBlend(mat:Array, old:Array):Array {
		
			var temp:Array = [];
			var i:int = 0;
			
			for (var y:int = 0; y < 4; y++ ) {
				for (var x:int = 0; x < 5; x++ ) {
					
					temp[i + x] =	mat[i    ] * old[x     ] + 
								mat[i+1] * old[x +  5] + 
								mat[i+2] * old[x + 10] + 
								mat[i+3] * old[x + 15] +
								(x === 4 ? mat[i+4] : 0);
				}
				i+=5;
			}
			
			return temp;
		}

	}
}