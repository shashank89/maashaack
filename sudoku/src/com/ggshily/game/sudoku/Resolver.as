package com.ggshily.game.sudoku
{
	public class Resolver
	{
		private static const NUMBERS : Vector.<int> = Vector.<int>([1, 2, 3, 4, 5, 6, 7, 8, 9]);
		
		public function Resolver()
		{
		}
		
		public static function resolve(data : Vector.<int>) : Vector.<Vector.<int>>
		{
			var results : Vector.<Vector.<int>> = new Vector.<Vector.<int>>();
			
			var possibleNumbers : Vector.<Vector.<int>> = new Vector.<Vector.<int>>();
			for(var i : int = 0; i < data.length; ++i)
			{
				possibleNumbers.push(getPossibleNumbers(data, i));
			}
			
			getSolution(data, possibleNumbers, results, 0);
			
			return results;
		}
		
		private static function getSolution(data:Vector.<int>, possibleNumbers:Vector.<Vector.<int>>, results:Vector.<Vector.<int>>, index:int):void
		{
			if(index == 81)
			{
				if(Checker.check(data))
				{
					results.push(new Vector.<int>().concat(data));
				}
			}
			else
			{
				for(var i : int = 0; i < possibleNumbers[index].length; ++i)
				{
					data[index] = possibleNumbers[index][i];
					if(isValide(data, index))
					{
						getSolution(data, possibleNumbers, results, index + 1);
					}
					else
					{
//						trace("find invalid");
					}
					data[index] = 0;
				}
			}
		}
		
		private static function isValide(data:Vector.<int>, i:int):Boolean
		{
			var numbers : Vector.<int> = new Vector.<int>();
			
			var x : int = i % 9;
			var y : int = i / 9;
			for(var i : int = 0; i < 9; ++i)
			{
				if(data[i + y * 9] > 0)
				{
					if(numbers.indexOf(data[i + y * 9]) >= 0)
					{
						return false;
					}
					else
					{
						numbers.push(data[i + y * 9]);
					}
				}
			}
			numbers.length = 0;
			for(i = 0; i < 9; ++i)
			{
				if(data[i * 9 + x] > 0)
				{
					if(numbers.indexOf(data[i * 9 + x]) >= 0)
					{
						return false;
					}
					else
					{
						numbers.push(data[i * 9 + x]);
					}
				}
			}
			numbers.length = 0;
			for(i = 0; i < 9; ++i)
			{
				if(data[int(x / 3) * 3 + int(y / 3) * 3 * 9 + int(i / 3) * 9 + i % 3] > 0)
				{
					if(numbers.indexOf(data[int(x / 3) * 3 + int(y / 3) * 3 * 9 + int(i / 3) * 9 + i % 3]) >= 0)
					{
						return false;
					}
					else
					{
						numbers.push(data[int(x / 3) * 3 + int(y / 3) * 3 * 9 + int(i / 3) * 9 + i % 3]);
					}
				}
			}
			
			return true;
		}
		
		private static function getPossibleNumbers(data:Vector.<int>, i:int):Vector.<int>
		{
			var numbers : Vector.<int> = new Vector.<int>();
			
			if(data[i] > 0)
			{
				numbers.push(data[i]);
			}
			else
			{
				numbers = numbers.concat(NUMBERS);
				var x : int = i % 9;
				var y : int = i / 9;
				for(var i : int = 0; i < 9; ++i)
				{
					var index : int = numbers.indexOf(data[i + y * 9]);
					if(index >= 0)
					{
						numbers.splice(index, 1);
					}
					index = numbers.indexOf(data[i * 9 + x]);
					if(index >= 0)
					{
						numbers.splice(index, 1);
					}
					index = numbers.indexOf(data[int(x / 3) * 3 + int(y / 3) * 3 * 9 + int(i / 3) * 9 + i % 3]);
					if(index >= 0)
					{
						numbers.splice(index, 1);
					}
				}
			}
			
			return numbers;
		}
	}
}