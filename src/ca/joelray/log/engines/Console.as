/**
 * Console by Joel Ray. 2011
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

	import flash.external.ExternalInterface;

	/**
	 * @author joelray
	 */
	public class Console extends AbstractEngine {
		
		// ===============================================================================================
		// CONSTRUCTOR -----------------------------------------------------------------------------------
		
		public function Console() {
			LazySingleton.validate(Console);
		}
		
		
		// ===============================================================================================
		// SINGLETON INTERFACE ---------------------------------------------------------------------------
		
		public static function getInstance():Console {
			return LazySingleton.getInstance(Console);
		}
		
		
		// ===============================================================================================
		// PUBLIC INTERFACE ------------------------------------------------------------------------------
		
		/**
		 * Clears current log messages.
		 */
		override public function clear():void {
			if(ExternalInterface.available) {
				ExternalInterface.call("console.clear");
			}
		}
		
		
		/**
		 * Sends message to Console.
		 */
		override public function log($level:String, ...$args):void {
			if(ExternalInterface.available) {
				var level:String;
				switch($level) {
					case "FATAL":
					case "ERROR":
						level = "console.error";
						break;
					case "WARNING":
						level = "console.warn";
						break;
					case "DEBUG":
						level = "console.debug";
						break;
					case "INFO":
						level = "console.info";
						break;
					default:
						level = "console.log";
						break;
				}
				
				ExternalInterface.call(level, $args);
			}
		}
		
	}
}