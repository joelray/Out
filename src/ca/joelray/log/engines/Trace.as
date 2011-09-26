/**
 * Trace by Joel Ray. 2011
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

	import ca.joelray.patterns.singleton.LazySingleton;
	
	/**
	 * @author joelray
	 */
	public class Trace extends AbstractEngine {
		
		// ===============================================================================================
		// CONSTRUCTOR -----------------------------------------------------------------------------------
		
		public function Trace() {
			LazySingleton.validate(Trace);
		}
		
		
		// ===============================================================================================
		// SINGLETON INTERFACE ---------------------------------------------------------------------------
		
		public static function getInstance():Trace {
			return LazySingleton.getInstance(Trace);
		}
		
		
		// ===============================================================================================
		// PUBLIC INTERFACE ------------------------------------------------------------------------------
		
		/**
		 * @inheritDoc
		 */
		override public function clear():void {
			// TODO: Call Adobe and ask them to support an Output palette API. Clearly a necessity.. 
		}
		
		
		/**
		 * Sends message to flashlog.
		 */
		override public function log($level:String, ...$output):void {
			if($level) { // Couldn't stand the FDT warning...
				trace($output);
			}
		}
		
	}
}
