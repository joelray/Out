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
	
	/**
	 * @author joelray
	 * @reference http://arthropod.stopp.se
	 */
	public class Arthropod extends AbstractEngine {
		
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
			Debug.clear();
		}
		
		
		/**
		 * Sends message to Arthropod.
		 */
		override public function log($level:String, ...$output):void {
			switch($level){
				case "ERROR" :
					Debug.error($output);
					break;
				case "WARNING" :
					Debug.warning($output);
					break;
				case "FATAL" :
					Debug.log($output, Debug.RED);
					break;
				case "DEBUG" :
					Debug.log($output, Debug.PINK);
					break;
				case "STATUS" :
					Debug.log($output, Debug.GREEN);
					break;
				case "INFO" :
					Debug.log($output);
					break;
			}
		}
		
	}
}


// ===============================================================================================
// AUXILIARY INTERFACE ---------------------------------------------------------------------------

/**
* Debug
* Designed for version 0.96.7 to 1.0 of the Arthropod Debugger.
* 
* Condensed version of Arthropod.
* Exclusively used for ca.joelray.log.Out.
* 
* USE AT YOUR OWN RISK!
* Any trace that is made with arthropod may be viewed by others.
* The main purpose of arthropod and this debug class is to debug
* unpublished AIR applications or sites in their real 
* environment (such as a web-browser). Future versions of
* Arthropod may change the trace-engine pattern and may cause
* traces for older versions not work properly.
* 
* A big thanks goes out to:
* Stockholm Postproduction - www.stopp.se
* Lee Brimelow - www.theflashblog.com 
* 
* @author Carl Calderon 2008
* @version 0.74
* @link http.//www.carlcalderon.com/
* @since 0.72
*/
 
import flash.events.StatusEvent;
import flash.net.LocalConnection;

internal class Debug {
	
	/**
	 * <b>Privacy</b>
	 * 
	 * <p>By setting this password, you need to enter the
	 * same in "Arthropod -> Settings -> Connection Password"
	 * to be able to see the traces.<br />
	 * 
	 * <i>default: <code>'CDC309AF';</code></i></p>
	 */
	public static var __password            : String = 'CDC309AF';
	
	public static var allowLog              : Boolean = true;
	

	private static var __lc                 : LocalConnection    = new LocalConnection();	
	private static var __hasListeners       : Boolean            = false;
	
	
	// Predefined colors:
	public static const RED                 : uint = 0xCC0000;
	public static const GREEN               : uint = 0x00CC00;
	public static const PINK                : uint = 0xCC00CC;
	public static const YELLOW              : uint = 0xCCCC00;
	public static const BLUE				: uint = 0x1b9ef9;
	
	
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
	
	
	// ===========================================================================================================================
	// PUBLIC STATIC INTERFACE ---------------------------------------------------------------------------------------------------
	
	/**
	 * Traces a message to Arthropod
	 * 
	 * @param	$msg		Message to be traced
	 * @param	$color		opt. Color of the message
	 * @return				True if successful
	 */
	public static function log($msg:*, $color:uint = 0xFEFEFE):Boolean {
		return send(LOG_OPERATION, String($msg), $color);
	};
	
	
	/**
	 * Traces a warning to Arthropod.
	 * The message will be displayed in yellow.
	 * 
	 * @param	$msg		Message to be traced
	 * @return				True if successful
	 */
	public static function error($msg:*):Boolean {
		return send(ERROR_OPERATION, String($msg), 0xCC0000);
	};
	
	
	/**
	 * Traces an error to Arthropod.
	 * The message will be displayed in red.
	 * 
	 * @param	$msg		Message to be traced
	 * @return				True if successful
	 */
	public static function warning($msg:*):Boolean {
		return send(WARNING_OPERATION, String($msg), 0xCCCC00);
	};
	
	
	/**
	 * Clears all the traces, including arrays and bitmaps
	 * from the Arthropod application window.
	 * 
	 * @return				True if successful
	 */
	public static function clear():Boolean {
		return send(CLEAR_OPERATION, 0, 0x000000);
	};
	
	
	// ===========================================================================================================================
	// INTERNAL INTERFACE --------------------------------------------------------------------------------------------------------
	
	/**
	 * Sends the message
	 * 
	 * @param	$operation	Operation name
	 * @param	$value		Value to send
	 * @param	$color		opt. Color of the message
	 */
	private static function send($operation:String, $value:*, $prop:*):Boolean {
		__lc.allowDomain("*");
		
		if(!__hasListeners) {
			__lc.addEventListener(StatusEvent.STATUS, ignore);
			__hasListeners = true;
		}
		
		try {
			__lc.send( TYPE + "#" + DOMAIN + CHECK + ":" + CONNECTION, $operation, __password, $value, $prop );
			return true;
		} catch($err:*) {} // throw error?
		
		return false;
	};
	
	
	// ===========================================================================================================================
	// EVENT INTERFACE -----------------------------------------------------------------------------------------------------------
	
	/**
	 * Ignore StatusEvent's if an error occurs.
	 * 
	 * @see		ignoreStatus
	 * @param	$evt		StatusEvent
	 */
	private static function ignore($evt:StatusEvent):void {};
	
}
