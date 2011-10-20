package com.ggshily.game.sudoku
{
	import com.ggshily.game.sudoku.util.Generator;
	import com.ggshily.game.sudoku.util.Resolver;

	public class ChessBoardData
	{
		public static const MAX_NUMBER:int = 9;
		
		private var _cells:Vector.<CellData>;
		
		public function ChessBoardData()
		{
		}
		
		public function init():void
		{
			var data : Vector.<int> = Generator.generateFinishedPuzzle();
			data = Generator.generatePuzzle(data);
			
			_cells = new Vector.<CellData>();
			for(var y:int = 0; y < MAX_NUMBER; ++y)
			{
				for (var x:int = 0; x < MAX_NUMBER; ++x)
				{
					var cell:CellData = new CellData(data[x + y * MAX_NUMBER]);
					
					_cells.push(cell);
				}
			}
		}
		
		public function checkDuplicateCell(targetCell:CellData):Vector.<CellData>
		{
			var group:Vector.<int> = Resolver.getGroup(_cells.indexOf(targetCell));
			
			var duplicated:Vector.<CellData> = new Vector.<CellData>();
			
			for each(var index:int in group)
			{
				var cell:CellData = _cells[index];
				if(cell != targetCell && cell.number == targetCell.number)
				{
					duplicated.push(cell);
				}
			}
			
			return duplicated;
		}
		
		public function removePossibleNumbers(targetCell:CellData):void
		{
			var group:Vector.<int> = Resolver.getGroup(_cells.indexOf(targetCell));
			
			for each(var index:int in group)
			{
				var cell:CellData = _cells[index];
				if(cell.number == 0)
				{
					cell.removePossible(targetCell.number);
				}
			}
		}	
		
		public function fillPossibleNumbers():void
		{
			var cell:CellData;
			var data:Vector.<int> = new Vector.<int>();
			for each(cell in _cells)
			{
				data.push(cell.number);
			}
			
			for(var i:int = 0; i < _cells.length; ++i)
			{
				cell = _cells[i];
				if(cell.number <= 0)
				{
					cell.possibles = Resolver.getPossibleNumbers(data, i);
				}
			}
		}

		public function get cells():Vector.<CellData>
		{
			return _cells;
		}

	}
}