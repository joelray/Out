/**
 * SOSMax by Joel Ray. 2011
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

	import ca.joelray.log.utils.Stringifier;
	import ca.joelray.log.vo.SOSFoldVO;
	import ca.joelray.patterns.singleton.LazySingleton;

	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.XMLSocket;
	
	/**
	 * @author joelray
	 */
	public class SOSMax extends AbstractEngine {
		
		// Properties
		private var _buffer:Array;
		private var _socket:XMLSocket;
		
		private var _host:String = "localhost";
		private var _port:uint = 4445;
		private var _clearOnConnect:Boolean = true;
		
		
		// ===============================================================================================
		// CONSTRUCTOR -----------------------------------------------------------------------------------
		
		public function SOSMax() {
			LazySingleton.validate(SOSMax);
			_buffer = new Array();
		}
		
		
		// ===============================================================================================
		// SINGLETON INTERFACE ---------------------------------------------------------------------------
		
		public static function getInstance():SOSMax {
			return LazySingleton.getInstance(SOSMax);
		}
		
		
		// ===============================================================================================
		// PUBLIC INTERFACE ------------------------------------------------------------------------------
		
		/**
		 * Clears current log messages.
		 */
		override public function clear():void {
			_sendCommand("<clear />");
		}
		
		
		/**
		 * @inheritDoc
		 */
		override public function log($level:String, ...$args):void {
			var command:String, key:String = $level;
			var fold:SOSFoldVO = Stringifier.stringifyObject($args[0]);
			
			if(fold.body == null) command = "<showMessage key=\'" + key + "\'>" + fold.title + "</showMessage>";
			else command = "<showFoldMessage key=\'" + key + "\'><title>" + fold.title + "</title><message>" + fold.body + "</message></showFoldMessage>";
			
			_sendCommand(command);
		}
		
		
		// ===============================================================================================
		// INTERNAL INTERFACE ----------------------------------------------------------------------------
		
		/**
		 * Sends message to SOS.
		 */
		private function _sendCommand($command:String):void {
			if(_socket && _socket.connected) {
				_socket.send($command);
			} else {
				_buffer.push($command);
				
				if(!_socket) {
					_socket = new XMLSocket();
					_socket.addEventListener(Event.CONNECT, _onSocketConnected);
					_socket.addEventListener(IOErrorEvent.IO_ERROR, _onSocketConnectionIOError);
					_socket.addEventListener(SecurityErrorEvent.SECURITY_ERROR, _onSocketConnectionSecurityError);
					_socket.connect(_host, _port);
				}
			}
		}
		
		
		// ===============================================================================================
		// EVENT INTERFACE -------------------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function _onSocketConnected($evt:Event):void {
			if(_clearOnConnect) clear();
			
			for each(var s:String in _buffer) _sendCommand(s);
			_buffer = new Array();
		}
		
		
		/**
		 * @private
		 */
		private function _onSocketConnectionIOError($evt:IOErrorEvent):void {}
		
		
		/**
		 * @private
		 */
		private function _onSocketConnectionSecurityError($evt:SecurityErrorEvent):void {}
		
	}
}