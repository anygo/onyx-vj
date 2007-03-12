package onyx.file {

	/**
	 * 
	 */
	public final class SWFFilter extends FileFilter {

		override public function validate(file:File):Boolean {
			
			var extension:String = file.extension;

			switch (extension) {
				case 'swf':
					if (file.path.indexOf('-debug') >= 0) {
						break;
					}
				case 'onx':
				case 'mix':
				case 'flv':
				case 'jpg':
				case 'jpeg':
				case 'png':
				case 'cam':
				case 'mp3':
				case 'xml':
					return true;
			}

			return false;
		}
	}

}