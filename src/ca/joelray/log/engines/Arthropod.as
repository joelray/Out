/**
 * Arthropod by Joel Ray. 2011
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

	import flash.events.StatusEvent;
	import flash.net.LocalConnection;
	
	/**
	 * @author joelray
	 * @reference http://arthropod.stopp.se
	 */
	public class Arthropod extends AbstractEngine {
		
		// Constants
		public static const DEFAULT      : uint = 0xFEFEFE;
		public static const RED          : uint = 0xCC0000;
		public static const GREEN        : uint = 0x00CC00;
		public static const PINK         : uint = 0xCC00CC;
		public static const YELLOW       : uint = 0xCCCC00;
		
		// Static Properties
		public static var password       : String  = 'CDC309AF'; // Arthropod -> Settings -> Connection Password --- default: 'CDC309AF'
		
		// Properties
		private var _lc                  : LocalConnection = new LocalConnection();	
		private var _hasListeners        : Boolean         = false;


		/**
		 * DO NOT CHANGE THESE VALUES! IF CHANGED, ARTHROPOD MIGHT NOT WORK PROPERLY!
		 */
		private static const DOMAIN             : String = 'com.carlcalderon.Arthropod';
		private static const CHECK              : String = '.161E714B6C1A76DE7B9865F88B32FCCE8FABA7B5.1';
		private static const TYPE               : String = 'app';
		private static const CONNECTION         : String = 'arthropod';

		private static const LOG_OPERATION      : String = 'debug';
		private static const ERROR_OPERATION    : String = 'debugError';
		private static const WARNING_OPERATION  : String = 'debugWarning';
		private static const CLEAR_OPERATION    : String = 'debugClear';
		
		
		// ===============================================================================================
		// CONSTRUCTOR -----------------------------------------------------------------------------------
		
		public function Arthropod() {
			LazySingleton.validate(Arthropod);
		}
		
		
		// ===============================================================================================
		// SINGLETON INTERFACE ---------------------------------------------------------------------------
		
		public static function getInstance():Arthropod {
			return LazySingleton.getInstance(Arthropod);
		}
		
		
		// ===============================================================================================
		// PUBLIC INTERFACE ------------------------------------------------------------------------------
		
		/**
		 * Clears current log messages.
		 */
		override public function clear():void {
			_send(CLEAR_OPERATION, 0, 0x000000);
		//	Debug.clear();
		}
		
		
		/**
		 * Color-codes log level before sending to Arthropod.
		 */
		override public function log($level:String, ...$output):void {
			switch($level){
				case "ERROR"   : _send(ERROR_OPERATION,   String($output), RED);     break;
				case "WARNING" : _send(WARNING_OPERATION, String($output), YELLOW);  break;
				case "FATAL"   : _send(LOG_OPERATION,     String($output), RED);     break;
				case "DEBUG"   : _send(LOG_OPERATION,     String($output), PINK);    break;
				case "STATUS"  : _send(LOG_OPERATION,     String($output), GREEN);   break;
				case "INFO"    : _send(LOG_OPERATION,     String($output), DEFAULT); break;
			}
		}
		
		
		// ===============================================================================================
		// INTERNAL INTERFACE ----------------------------------------------------------------------------
		
		/**
		 * Sends message to Arthropod.
		 * 
		 * @param $operation    Operation name
		 * @param $value        Value to send
		 * @param $color        opt. Color of the message
		 */
		private function _send($operation:String, $value:*, $color:*):void {
			_lc.allowDomain("*");

			if(!_hasListeners) {
				_lc.addEventListener(StatusEvent.STATUS, _ignore);
				_hasListeners = true;
			}

			try { _lc.send( TYPE + "#" + DOMAIN + CHECK + ":" + CONNECTION, $operation, password, $value, $color ); } 
			catch($err:*) {}
		}
		
		
		// ===============================================================================================
		// EVENT INTERFACE -------------------------------------------------------------------------------

		/**
		 * Ignore StatusEvent's if an error occurs.
		 * 
		 * @param	$evt    StatusEvent
		 */
		private function _ignore($evt:StatusEvent):void {};
		
	}
}
