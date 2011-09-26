/**
 * Stringifier by Joel Ray. 2011
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
 package ca.joelray.log.utils {

	import ca.joelray.log.vo.SOSFoldVO;

	import flash.display.DisplayObject;
	import flash.utils.describeType;
	
	/**
	 * @author joelray
	 */
	public class Stringifier {
		
		// ===============================================================================================
		// PUBLIC STATIC INTERFACE -----------------------------------------------------------------------
		
		/**
		 * Converts a log object to a SOSFoldVO.
		 * 
		 * @param $obj          The log object to convert.
		 * @param $separator    SOSFold seperator type.
		 * @return SOSFoldVO
		 */
		public static function stringifyObject($obj:*, $separator:String = "\t"):SOSFoldVO {
			if($obj is SOSFoldVO) return $obj;

			var fold:SOSFoldVO = new SOSFoldVO();
			if($obj === null) {
				fold.title = "null";
				return fold;
			} else if($obj === "") {
				fold.title = "";
				return fold;
			} else if($obj === undefined) {
				fold.title = "undefined";
				return fold;
			} else if(__isPrimitive($obj)) {
				fold.title = $obj.toString();
				return fold;
			}

			var type:* = describeType($obj), name:* = describeType($obj).@name, body:String = $separator + name;
			if(type.@base) body += (" extends " + type.@base);
			body += "\n";

			for each(var i:XML in type["variable"]) {
				body += ($separator + "var " + i.@name + ":" + i.@type + " = " + $obj[i.@name] + ";\n");
			}

			body += __getExtras($obj, $separator);
			fold.title = $obj.toString();
			fold.body = body;
			
			return fold;
		}
		
		
		// ===============================================================================================
		// INTERNAL INTERFACE ----------------------------------------------------------------------------
		
		/**
		 * Determine if an object is primitive.
		 * 
		 * @param $obj    The object to examine.
		 * @return Boolean
		 */
		private static function __isPrimitive($obj:*):Boolean {
			switch(describeType($obj).@name) {
				case "Boolean":
				case "int":
				case "uint":
				case "Number":
				case "String":
					return true;
			}
			
			return false;
		}
		
		
		/**
		 * Retrieves any extra atributes that an object may contain.
		 * 
		 * @param $obj          The object to examine.
		 * @param $separator    The string seperator type.
		 * @return String
		 */
		private static function __getExtras($obj:*, $separator:String):String {
			var extras:String = "";
			
			if($obj is DisplayObject) {
				extras = extras + ($separator + "x: " + $obj["x"] + ", y: " + $obj["y"] + "\n");
				extras = extras + ($separator + "width: " + $obj["width"] + ", height: " + $obj["height"] + "\n");
				extras = extras + ($separator + "alpha: " + $obj["alpha"] + ", visible: " + $obj["visible"] + "\n");
			}
			
			if($obj is Object) {
				for(var i:* in $obj) {
					extras += ($separator + i + ": " + $obj[i] + "\n");
				}
			}
			
			return extras;
		}
		
	}
}
