package com.playfish.rpc.share
{
	import flash.display.Sprite;
	import flash.utils.ByteArray;

	/**
	* This class implements a vector of bits that grows as needed. 
	* Each component of the bit set has a boolean value. The bits of a BitSet are indexed by nonnegative integers. Individual indexed bits can be examined, set, or cleared.
	*/
	public class BitSet {

		// ByteArray used to represent internal state
		/** @private */
		internal var bits:ByteArray;

		public function BitSet() {
			bits = new ByteArray();
		}

		/**
		* Returns the value of the bit with the specified index.
		*/
		public function get(bitIndex: uint):Boolean {	
			var byteIndex:int = bitIndex / 8;
			var byteShift:int = 7 - (bitIndex % 8);

			if (bits.length < byteIndex) {
				// return default value
				return false;
			}

			return (Boolean) ((bits[byteIndex] >> byteShift) & 0x1);
		}

		/**
		 * Returns true if this BitSet contains no bits that are set to true.
		 */
		public function isEmpty():Boolean {
			return bits.length == 0;
		}

		/**
		 * Returns the number of bits set to true in this BitSet.
		 */
		public function cardinality():uint {
			var result:uint;
			for (var i:uint=0;i<bits.length*8;i++) {
				if (get(i)) {
					result++;
				}
			}

			return result;
		}

		/**
		 * Returns the "logical size" of this BitSet: the index of the highest set bit in the BitSet plus one.
		 */
		public function length():uint {
			var result:uint;
			for (var i:uint=0;i<bits.length*8;i++) {
				if (get(i)) {
					result = i;
				}
			}

			return result + 1;
		}

		/**
		*  Sets the bit at the specified index to the specified value.
		*/
		private function _set(bitIndex: uint, value:Boolean):void {

			var byteIndex:uint = bitIndex / 8;
			var byteShift:uint  = 7 - (bitIndex % 8);

			var newBits:ByteArray = new ByteArray();

			// check if array needs to grow
			if (bits.length <= byteIndex) {
				// Don't set anything is value=false
				if (!value) return;

				// Calculate how many bytes we need to add
				var extraBytes:uint = byteIndex - bits.length;

				// Copy current array
				newBits.writeBytes(bits);

				// Fill with zeros 
				for (var i:uint =0;i<extraBytes;i ++) {
					newBits.writeByte(0x0);
				}

				// Write the last byte
				newBits.writeByte(0x1 << byteShift);
			} else {
				// Copy first part of the array
				if (byteIndex != 0) {
					newBits.writeBytes(bits, 0, byteIndex);
				}

				// Copy target byte and set bit
				if (value) {
					newBits.writeByte(bits[byteIndex] | (0x1 << byteShift));
				} else {
					newBits.writeByte(~(~bits[byteIndex] | (0x1 << byteShift)));
				}

				// Copy the last part of the array
				if ( byteIndex < bits.length - 1) {
					newBits.writeBytes(bits, byteIndex + 1 , bits.length - byteIndex - 1);
				}
			}

			setArray(newBits);
		}

		/**
		 * Sets the bits from the specified fromIndex(inclusive) to the specified toIndex(exclusive) to the specified value.
		 * 
		 * If the value parameter is omitted, the default value of true is used. If the toIndex parameter is omitted, 
		 * the default value of 0 is used; the method will set the bit at fromIndex to true;
		 */
		public function set(fromIndex:uint, toIndex:uint=0, value:Boolean=true):void {
			if (toIndex == 0) {
				_set(fromIndex, value);
				return;
			}

			for (var i:uint=fromIndex; i<toIndex;i++) {
				_set (i, value);
			}
		}

		/**
		 * Cloning this BitSet produces a new BitSet that is equal to it.
		 */
		public function clone():BitSet {
			var result:BitSet = new BitSet ();
			result.bits.writeBytes (bits);

			return result;
		}

		/**
		 * Sets the bits from the specified fromIndex(inclusive) to the specified toIndex(exclusive) to false.
		 * 
		 * If the toIndex parameters is omitted, the default value of 0 is used; the method will set the bit fromIndex
		 * to false. If the fromIndex parameter is omitted all the bits in the BitSet will be set to false.
		 */
		public function clear(fromIndex:uint=0, toIndex:uint=0): void {
			if (fromIndex == 0 && toIndex == 0) {
				bits = new ByteArray ();
				return;
			}

			if (toIndex == 0) {
				_set (fromIndex, false);
				return;
			}

			for (var i:uint=fromIndex; i<toIndex;i++) {
				_set (i, false);
			}
		}

		/** @private */
		internal function setArray(bits:ByteArray):void {
			this.bits = bits;
		}

		/** @private */
		public function toString():String {
			var str:String = "[bits=";
			str +=getBitString(bits);	
			str += "]";

			return str;
		}

		private function getBitString(bits:ByteArray):String {
			var str:String = "";

			for (var i:uint=0; i<bits.length;i++) {
				var byte:uint=bits[i];

				str += ((byte >> 7) & 0x1);
				str += ((byte >> 6) & 0x1);
				str += ((byte >> 5) & 0x1);
				str += ((byte >> 4) & 0x1);
				str += ((byte >> 3) & 0x1);
				str += ((byte >> 2) & 0x1);
				str += ((byte >> 1) & 0x1);
				str += (byte        & 0x1);
			}

			return str;
		}
	}
}
