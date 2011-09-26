/**
 * IEngine by Joel Ray. 2011
 *
 * Copyright (c) 2011 Joel Ray
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
package ca.joelray.log.engines {
	
	/**
	 * @author joelray
	 */
	public interface IEngine {
		
		/**
		 * Clears current log messages.
		 * The engine, Trace, is not currently supported.
		 */
		function clear():void;
		
		
		/**
		 * Log type: Info.
		 */
		function info(...$args):void;
		
		
		/**
		 * Log type: Debug.
		 */
		function debug(...$args):void;
		
		
		/**
		 * Log type: Warning.
		 */
		function warning(...$args):void;
		
		
		/**
		 * Log type: Error.
		 */
		function error(...$args):void;
		
		
		/**
		 * Log type: Fatal.
		 */
		function fatal(...$args):void;
		
		
		/**
		 * Base engine output.
		 */
		function log($level:String, ...$args):void;
		
	}
}
