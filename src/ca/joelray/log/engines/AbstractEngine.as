/**
 * AbstractEngine by Joel Ray. 2011
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
	public class AbstractEngine implements IEngine {
		
		// ===============================================================================================
		// PUBLIC INTERFACE ------------------------------------------------------------------------------
		
		/**
		 * Clears current log messages.
		 * The engine, Trace, is not currently supported.
		 */
		public function clear():void {
			
		}
		
		
		/**
		 * Log type: Info.
		 */
		public function info(...$args):void {
			$args.unshift("INFO");
			log.apply(null, $args);
		}
		
		
		/**
		 * Log type: Status.
		 */
		public function status(...$args):void {
			$args.unshift("STATUS");
			log.apply(null, $args);
		}
		
		
		/**
		 * Log type: Debug.
		 */
		public function debug(...$args):void {
			$args.unshift("DEBUG");
			log.apply(null, $args);
		}
		
		
		/**
		 * Log type: Warning.
		 */
		public function warning(...$args):void {
			$args.unshift("WARNING");
			log.apply(null, $args);
		}
		
		
		/**
		 * Log type: Error.
		 */
		public function error(...$args):void {
			$args.unshift("ERROR");
			log.apply(null, $args);
		}
		
		
		/**
		 * Log type: Fatal.
		 */
		public function fatal(...$args):void {
			$args.unshift("FATAL");
			log.apply(null, $args);
		}
		
		
		/**
		 * Base engine output. Must be overridden.
		 */
		public function log($level:String, ...$output):void {
			throw new Error("AbstractEngine error: The log() method must be overridden.");
		}
		
	}
}
