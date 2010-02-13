/**
 * Copyright (c) 2003-2010 "Onyx-VJ Team" which is comprised of:
 *
 * Daniel Hai
 * Stefano Cottafavi
 * Bruce Lane
 *
 * All rights reserved.
 *
 * Licensed under the CREATIVE COMMONS Attribution-Noncommercial-Share Alike 3.0
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at: http://creativecommons.org/licenses/by-nc-sa/3.0/us/
 *
 * Please visit http://www.onyx-vj.com for more information
 * 
 */
package onyx.utils.file {
	
	import flash.filesystem.*;
	import onyx.plugin.*;
	/**
	 * 	Simple utility to write a log file synchronously
	 */
	public function writeLogFile( contents:String ):void {
		
		var file:File = File.applicationStorageDirectory.resolvePath( DATE_NOW + ".log" );
		var fileMode:String = FileMode.APPEND;
		
		var fileStream:FileStream = new FileStream();
		fileStream.open( file, fileMode );
		
		fileStream.writeMultiByte( contents + "\n", File.systemCharset );
		fileStream.close();
		trace( contents );
	}
}