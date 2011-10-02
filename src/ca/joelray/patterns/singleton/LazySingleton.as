/**
 * LazySingleton by Joel Ray. 2010
 *
 * Copyright (c) 2010 Joel Ray
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 *
 **/
package ca.joelray.patterns.singleton {
	
	import flash.utils.Dictionary;
	
	/**
	 * The <code>LazySingleton</code> Class
	 * 
	 * @copyright       2010 Joel Ray
	 * @author          Joel Ray
	 * @version         1.0 
	 * @langversion     ActionScript 3.0 			
	 * @playerversion   Flash 9.0.0
	 */
	public class LazySingleton {
		
		private static var __allowBuild     : Dictionary = new Dictionary();
		private static var __stack          : Dictionary = new Dictionary();
		
		// ===========================================================================================================================
		// PUBLIC STATIC INTERFACE ---------------------------------------------------------------------------------------------------

		public static function validate($class:Class):void {
			if(!__allowBuild[$class] || __stack[$class]) {
				throw new Error("Singleton error - Cannot instantiate a singleton from outside, use getInstance()");
			}
		}
		
		public static function getInstance($class:Class):* {
			if(!__stack[$class]) {
				__allowBuild[$class] = true;
				__stack[$class] = new $class;
				delete __allowBuild[$class];
			}
			
			return __stack[$class];
		}

	}
}