package com.ggshily.game.sudoku
{
	public class CellData
	{
		private var _number:int;
		private var _possibles:Vector.<int>;
		
		public function CellData(number:int)
		{
			if(number > 0)
			{
				_number = number;
			}
			else
			{
				_number = 0;
			}
		}
		
		public function addPossible(number:int):void
		{
			if(_possibles.indexOf(number) == -1)
			{
				_possibles.push(number);
			}
		}
		
		public function removePossible(number:int):void
		{
			if(_possibles.indexOf(number) >= 0)
			{
				_possibles.splice(_possibles.indexOf(number), 1);
			}
		}
		
		public function set possibles(value:Vector.<int>):void
		{
			_possibles = value;
		}
		
		public function set number(value:int):void
		{
			_number = value;
		}
		
		public function get number():int
		{
			return _number;
		}
		
		public function get possibles():Vector.<int>
		{
			return _possibles;
		}
	}
}