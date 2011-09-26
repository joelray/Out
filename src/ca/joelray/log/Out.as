/**
 * Out by Joel Ray. 2011
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
package ca.joelray.log {

	import ca.joelray.log.engines.IEngine;

	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;
	
	/**
	 * The <code>Out</code> Class
	 * 
	 * @copyright 		2011 Joel Ray
	 * @author			Joel Ray
	 * @version			2.0 
	 * @langversion		ActionScript 3.0 			
	 * @playerversion 	Flash 9.0.0
	 */
	public class Out extends EventDispatcher {
		
		// Constants
		public static const INFO           : uint = 0;
		public static const STATUS         : uint = 1;
		public static const DEBUG          : uint = 2;
		public static const WARNING        : uint = 3;
		public static const ERROR          : uint = 4;
		public static const FATAL          : uint = 5;
		
		// Static Properties 
		public static var active           : Boolean = true;            // Is this son-of-a-bitch activated?
		public static var filterByEquality : Boolean = false;           // Only reveal log values from the base filter level.
		public static var filterLevel      : uint = 0;                  // The base filter level. Anything log level below this will be ignored.
		
		private static var __levels        : Dictionary;                // The log level's string values.
		private static var __engines       : Array  = new Array();      // Activated log engines.
		private static var __silenced      : Object = new Object();     // Mapped classes to silence/ignore.

		
		// ===========================================================================================================================
		// CONFIG INTERFACE ----------------------------------------------------------------------------------------------------------
		
		/**
		 * Registers a log engine.
		 * 
		 * @param $engine    An instance of an IEngine object.
		 */
		public static function registerEngine($engine:IEngine):void {
			if(!isEngineRegistered($engine)) {
				__engines.push($engine);
			}
		}
		
		
		/**
		 * Unregisters a log engine.
		 * 
		 * @param $engine    An instance of an IEngine object.
		 */
		public static function unregisterEngine($engine:IEngine):void {
			var i:int = __engines.indexOf($engine);
			if(i > -1) {
				__engines.splice(i);
			}
		}
		
		
		/**
		 * Checks if an engine is registered.
		 * 
		 * @param $engine    An instance of an IEngine object.
		 * @return Boolean
		 */
		public static function isEngineRegistered($engine:IEngine):Boolean {
			return __engines.indexOf($engine) > -1;
		}
		
		
		/**
		 * Gets a list of registered engines.
		 */
		public static function getEngines():Array {
			return __engines.concat();
		}
		
		
		/**
		 * Silences/ignores an object.
		 * All logs from a silenced origin will be ignored.
		 * 
		 * @param $o    The origin of an object.
		 */
		public static function silence($o:*):void {
			__silenced[__getClassName($o)] = true;
		}
		
		
		/**
		 * Unsilences an object.
		 * 
		 * @param $o    The origin of an object.
		 */
		public static function unsilence($o:*):void {
			__silenced[__getClassName($o)] = false;
		}
		
		
		/**
		 * Checks if an object origin is silenced.
		 * 
		 * @param $o    The origin of an object.
		 */
		public static function isSilenced($o:*):Boolean {
			return __silenced[__getClassName($o)];
		}
		
		
		/**
		 * Clears current log messages.
		 */
		public static function clear():void {
			for each(var engine:IEngine in __engines) {
				engine.clear();
			}
		}
		
		
		// ===========================================================================================================================
		// LOGGING INTERFACE ---------------------------------------------------------------------------------------------------------
		
		/**
		 * Log type: Info.
		 * 
		 * @param $origin    The origin of an object.
		 * @param $args      The message to log.
		 */
		public static function info($origin:*, ...$args):void {
			__log(INFO, $origin, $args);
		}

		
		/**
		 * Log type: Status.
		 * 
		 * @param $origin    The origin of an object.
		 * @param $args      The message to log.
		 */
		public static function status($origin:*, ...$args):void {
			__log(STATUS, $origin, $args);
		}

		
		/**
		 * Log type: Debug.
		 * 
		 * @param $origin    The origin of an object.
		 * @param $args      The message to log.
		 */
		public static function debug($origin:*, ...$args):void {
			__log(DEBUG, $origin, $args);
		}

		
		/**
		 * Log type: Warning.
		 * 
		 * @param $origin    The origin of an object.
		 * @param $args      The message to log.
		 */
		public static function warning($origin:*, ...$args):void {
			__log(WARNING, $origin, $args);
		}


		/**
		 * Log type: Error.
		 * 
		 * @param $origin    The origin of an object.
		 * @param $args      The message to log.
		 */
		public static function error($origin:*, ...$args):void {
			__log(ERROR, $origin, $args);
		}

		
		/**
		 * Log type: Fatal.
		 * 
		 * @param $origin    The origin of an object.
		 * @param $args      The message to log.
		 */
		public static function fatal($origin:*, ...$args):void {
			__log(FATAL, $origin, $args);
		}
		
		
		// ===========================================================================================================================
		// INTERNAL INTERFACE --------------------------------------------------------------------------------------------------------
		
		/**
		 * Formats the message and sends it to any registered engines.
		 * 
		 * @param $level     The log level.
		 * @param $origin    The origin of an object.
		 * @param $str       The message to log.
		 */
		private static function __log($level:uint, $origin:*, $str:*):void {
			if(isSilenced($origin)) return;
			
			if(active && __engines.length > 0 && (filterByEquality && $level == filterLevel || !filterByEquality && $level >= filterLevel)) {
				var level:String = __getLogLevelName($level);
				var origin:String = $origin ? __getClassName($origin) : "";
				while(level.length < 8) level += " ";
				
				var output:String = level != "" && origin != "" ? level + ":::	" + origin + "	::	" + $str : $str;
				for each(var engine:IEngine in __engines) {
					engine.log(__getLogLevelName($level), output);
				}
			}
		}

		
		/**
		 * Gets a class name devoid of any colons and package details.
		 */
		private static function __getClassName($o:*):String {
			var c:String = flash.utils.getQualifiedClassName($o);
			var s:String = (c == "String" ? $o : c.split("::")[1] || c);
			return s;
		}
		
		
		/**
		 * Gets a log level string name by uint id.
		 */
		private static function __getLogLevelName($level:uint):String {
			if(!__levels) {
				__levels = new Dictionary();
				__levels[INFO]    = "INFO";
				__levels[STATUS]  = "STATUS";
				__levels[DEBUG]   = "DEBUG";
				__levels[WARNING] = "WARNING";
				__levels[ERROR]   = "ERROR";
				__levels[FATAL]   = "FATAL";
			}
			
			return __levels[$level];
		}

	}
}