package com.ggshily.game.sudoku.ui
{
	import com.ggshily.game.sudoku.Checker;
	import com.ggshily.game.sudoku.Generator;
	import com.ggshily.game.sudoku.Resolver;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.ui.Mouse;
	
	public class ChessBoard extends Sprite
	{
		private var _cells:Vector.<Cell>;
		private var _possibleCells:Vector.<Cell>;
		private var _numberCells:Vector.<Cell>;
		
		private var _cellSize:int;
		
		private var _selectedCell:Cell;
		private var _frame:Sprite
		
		public function ChessBoard(cellSize:int)
		{
			_cellSize = cellSize;
			
			init();
			fillPossibleNumbers();
		}
		
		public function init():void
		{
			var data : Vector.<int> = Generator.generateFinishedPuzzle();
			data = Generator.generatePuzzle(data);
			
			
			// chess cells
			_cells = new Vector.<Cell>();
			for(var y:int = 0; y < sodoku.MAX_NUMBER; ++y)
			{
				for (var x:int = 0; x < sodoku.MAX_NUMBER; ++x)
				{
					var cell:Cell = new Cell(x * _cellSize, y * _cellSize, data[x + y * sodoku.MAX_NUMBER], _cellSize);
					cell.addEventListener(MouseEvent.CLICK, selectCellHandler);
					
					_cells.push(cell);
					addChild(cell);
				}
			}
			
			_frame = new Sprite();
			 _frame.graphics.lineStyle(2, 0x000000);
			for(var i:int = 0; i < 3; ++i)
			{
				for(var j:int = 0; j < 3; ++j)
				{
					_frame.graphics.drawRect(i * 3 * _cellSize, j * 3 * _cellSize, _cellSize * 3, _cellSize * 3);
				}
			}
			_frame.mouseEnabled = false;
			_frame.mouseChildren = false;
			
			addChild(_frame);
			
			// possible numbers
			_possibleCells = new Vector.<Cell>();
			for(var k:int = 0; k < sodoku.MAX_NUMBER; ++k)
			{
				var possibleCell:Cell = new Cell(_cellSize * (sodoku.MAX_NUMBER + 1), k * _cellSize, k + 1, _cellSize);
				_possibleCells.push(possibleCell);
				possibleCell.visible = false;
				addChild(possibleCell);
				
				possibleCell.addEventListener(MouseEvent.CLICK, selectPossibleHandler);
			}
			
			// numbers
			_numberCells = new Vector.<Cell>();
			for(var m:int = 0; m < sodoku.MAX_NUMBER; ++m)
			{
				var numberCells:Cell = new Cell(m * _cellSize, _cellSize * (sodoku.MAX_NUMBER + 1), m + 1, _cellSize);
				_numberCells.push(numberCells);
				numberCells.visible = false;
				addChild(numberCells);
				
				numberCells.addEventListener(MouseEvent.CLICK, selectNumberHandler);
			}
		}
		
		public function selectCellHandler(e:MouseEvent):void
		{
			var cell:Cell = e.target as Cell;
			
			if(_selectedCell != null && _selectedCell != cell)
			{
				_selectedCell.selected = false;
				_selectedCell = null;
			}
			
			if(cell.number <= 0)
			{
				cell.selected = !cell.selected;
				
				addChild(_frame);
				if(cell.selected)
				{
					addChild(cell);
					_selectedCell = cell;
				}
			}
			
			updateSelectedCellPossibles();
			updateNumbersCell();
		}
		
		public function selectPossibleHandler(e:MouseEvent):void
		{
			var cell:Cell = e.target as Cell;
			_selectedCell.removePossible(cell.number);
		}
		
		public function selectNumberHandler(e:MouseEvent):void
		{
			var cell:Cell = e.target as Cell;
			selectNumberForCell(_selectedCell, cell.number);
			
			_selectedCell.selected = false;
			_selectedCell = null;
			updateSelectedCellPossibles();
			updateNumbersCell();
		}
		
		public function selectNumberForCell(cell:Cell, number:int):void
		{
			cell.number = number;
			if(!checkDuplicateCell(cell))
			{
				removePossibleNumbers(cell);
			}
		}
		
		public function clearCellNumber(targetCell:Cell):void
		{
			targetCell.number = 0;
			
			for each(var cell:Cell in _cells)
			{
				cell.warning(false);
			}
		}
		
		public function checkDuplicateCell(targetCell:Cell):Boolean
		{
			var group:Vector.<int> = Resolver.getGroup(_cells.indexOf(targetCell));
			
			var hasDuplicated:Boolean = false;
			
			for each(var index:int in group)
			{
				var cell:Cell = _cells[index];
				if(cell != targetCell && cell.number == targetCell.number)
				{
					cell.warning(true);
					targetCell.warning(true);
					hasDuplicated = true;
				}
			}
			
			return hasDuplicated;
		}
		
		public function removePossibleNumbers(targetCell:Cell):void
		{
			var group:Vector.<int> = Resolver.getGroup(_cells.indexOf(targetCell));
			
			for each(var index:int in group)
			{
				var cell:Cell = _cells[index];
				if(cell.number == 0)
				{
					cell.removePossible(targetCell.number);
				}
			}
		}
		
		public function updateSelectedCellPossibles():void
		{
			var cell:Cell;
			for each(cell in _possibleCells)
			{
				cell.visible = _selectedCell != null && _selectedCell.possibles.indexOf(cell.number) >= 0;
			}
		}
		
		public function updateNumbersCell():void
		{
			var cell:Cell;
			for each(cell in _numberCells)
			{
				cell.visible = _selectedCell != null;
			}
		}
		
		public function fillPossibleNumbers():void
		{
			var cell:Cell;
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
	}
}