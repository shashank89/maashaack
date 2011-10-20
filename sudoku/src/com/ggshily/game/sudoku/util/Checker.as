package com.ggshily.game.sudoku.util
{
	public class Checker
	{
		private static const MAX_NUMBER : int = 9;
		
		public function Checker()
		{
		}
		
		/**
		 * @param data the square data in one dimension
		 * 
		 * @return if finish this puzzle return true, vise versa
		 * 
		 **/
		public static function check(data : Vector.<int>) : Boolean
		{
			var index : int;
			
			var i : int = 0;
			var j : int = 0;
			var line : int;
			do{
				line = 0;
				j = 0;
				do{
					if(((1 << data[i * MAX_NUMBER + j]) & line) == 0)
					{
						line |= 1 << data[i * MAX_NUMBER + j];
					}
					else
					{
						return false;
					}
				}
				while(++j < MAX_NUMBER)
			}
			while(++i < MAX_NUMBER)
			
			i = 0;
			do{
				line = 0;
				j = 0;
				do{
					if(((1 << data[i + j * MAX_NUMBER]) & line) == 0)
					{
						line |= 1 << data[i + j * MAX_NUMBER];
					}
					else
					{
						return false;
					}
				}
				while(++j < MAX_NUMBER)
			}
			while(++i < MAX_NUMBER)
			
			i = 0;
			do{
				line = 0;
				j = 0;
				do{
					index = parseSquareIndex(i, j);
					if(((1 << data[index]) & line) == 0)
					{
						line |= 1 << data[index];
					}
					else
					{
						return false;
					}
				}
				while(++j < MAX_NUMBER)
			}
			while(++i < MAX_NUMBER)
			
			return true;
		}
		
		public static function parseSquareIndex(squareIndex : int, blockIndex : int) : int
		{
			return int(squareIndex / 3) * (3 * 9) + (squareIndex % 3) * 3 + int(blockIndex / 3) * 9 + blockIndex % 3;
		}
	}
}