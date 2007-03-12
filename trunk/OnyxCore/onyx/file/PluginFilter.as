package onyx.file {
	
	public final class PluginFilter extends FileFilter {
		
		override public function validate(file:File):Boolean {
			
			var extension:String = file.extension;

			switch (extension) {
				case 'swf':
					if (file.path.indexOf('-debug') < 0) {
						return true;
					}
					break;
			}

			return false;
		}
	}
}