package com.ggshily.game.sudoku
{
	public class Generator
	{
		private static const NUMBERS : Vector.<int> = Vector.<int>([1, 2, 3, 4, 5, 6, 7, 8, 9]);
		
		public function Generator()
		{
		}
		
		public static function generate() : Vector.<int>
		{
			var data : Vector.<int>;
			
			while(true)
			{
				data = new Vector.<int>(81);
				
				var finish : Boolean = true;
				for(var i : int = 0; i < 9; ++i)
				{
					for(var j : int = 0; j < 9; ++j)
					{
						var next : int = getRandomNumber(collectExcludeNumbers(data, j, i));
						if(next > 0)
						{
							data[i * 9 + j] = next;
						}
						else
						{
							finish = false;
							break;
						}
					}
					
					if(!finish)
					{
						break;
					}
				}
				
				if(finish)
				{
					break;
				}
			}
			
			return data;
		}
		
		private static function collectExcludeNumbers(data:Vector.<int>, x : int, y : int):Vector.<int>
		{
			var result : Vector.<int> = new Vector.<int>();
			
			for(var i : int = 0; i < 9; ++i)
			{
				result.push(data[i + y * 9]);
				result.push(data[i * 9 + x]);
				result.push(data[int(x / 3) * 3 + int(y / 3) * 3 * 9 + int(i / 3) * 9 + i % 3]);
			}
			
			return result;
		}
		
		private static function getRandomNumber(exclude : Vector.<int>) : int
		{
			var result : Vector.<int> = new Vector.<int>();
			for each(var number : int in NUMBERS)
			{
				if(exclude.indexOf(number) == -1)
				{
					result.push(number);
				}
			}
			
			if(result.length > 0)
			{
				return result[int(Math.random() * result.length)];
			}
			else
			{
				return 0;
			}
		}
	}
}