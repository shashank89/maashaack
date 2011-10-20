package com.ggshily.game.sudoku.ui
{
	import com.ggshily.game.sudoku.CellData;
	import com.ggshily.game.sudoku.ChessBoardData;
	import com.ggshily.game.sudoku.util.Checker;
	import com.ggshily.game.sudoku.util.Generator;
	import com.ggshily.game.sudoku.util.Resolver;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.ui.Mouse;
	
	public class ChessBoardUI extends Sprite
	{
		private var _cells:Vector.<CellUI>;
		private var _possibleCells:Vector.<CellUI>;
		private var _numberCells:Vector.<CellUI>;
		
		private var _cellSize:int;
		
		private var _selectedCell:CellUI;
		private var _frame:Sprite
		
		private var _chessBoardData:ChessBoardData;
		
		public function ChessBoardUI(cellSize:int)
		{
			_cellSize = cellSize;
			
			init();
			fillPossibleNumbers();
		}
		
		public function init():void
		{
			_chessBoardData = new ChessBoardData();
			_chessBoardData.init();
			
			// chess cells
			_cells = new Vector.<CellUI>();
			for(var y:int = 0; y < ChessBoardData.MAX_NUMBER; ++y)
			{
				for (var x:int = 0; x < ChessBoardData.MAX_NUMBER; ++x)
				{
					var cell:CellUI = new CellUI(x * _cellSize, y * _cellSize, _cellSize, _chessBoardData.cells[x + y * ChessBoardData.MAX_NUMBER]);
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
			_possibleCells = new Vector.<CellUI>();
			for(var k:int = 0; k < ChessBoardData.MAX_NUMBER; ++k)
			{
				var possibleCell:CellUI = new CellUI(_cellSize * (ChessBoardData.MAX_NUMBER + 1), k * _cellSize, _cellSize, new CellData(k + 1));
				_possibleCells.push(possibleCell);
				possibleCell.visible = false;
				addChild(possibleCell);
				
				possibleCell.addEventListener(MouseEvent.CLICK, selectPossibleHandler);
			}
			
			// numbers
			_numberCells = new Vector.<CellUI>();
			for(var m:int = 0; m < ChessBoardData.MAX_NUMBER; ++m)
			{
				var numberCells:CellUI = new CellUI(m * _cellSize, _cellSize * (ChessBoardData.MAX_NUMBER + 1), _cellSize, new CellData(m + 1));
				_numberCells.push(numberCells);
				numberCells.visible = false;
				addChild(numberCells);
				
				numberCells.addEventListener(MouseEvent.CLICK, selectNumberHandler);
			}
		}
		
		public function selectCellHandler(e:MouseEvent):void
		{
			var cell:CellUI = e.target as CellUI;
			
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
			var cell:CellUI = e.target as CellUI;
			cell.selected = !cell.selected;
			
			if(cell.selected)
			{
				_selectedCell.addPossible(cell.number);
			}
			else
			{
				_selectedCell.removePossible(cell.number);
			}
		}
		
		public function selectNumberHandler(e:MouseEvent):void
		{
			var cell:CellUI = e.target as CellUI;
			selectNumberForCell(_selectedCell, cell.number);
			
			_selectedCell.selected = false;
			_selectedCell = null;
			updateSelectedCellPossibles();
			updateNumbersCell();
		}
		
		public function selectNumberForCell(targetCell:CellUI, number:int):void
		{
			targetCell.number = number;
			var duplicated:Vector.<CellData> = _chessBoardData.checkDuplicateCell(targetCell.cellData);
			if(duplicated.length == 0)
			{
				removePossibleNumbers(targetCell);
			}
			else
			{
				targetCell.warning(true);
				for each(var cell:CellUI in _cells)
				{
					if(duplicated.indexOf(cell.cellData) >= 0)
					{
						cell.warning(true);
					}
				}
			}
		}
		
		public function clearCellNumber(targetCell:CellUI):void
		{
			targetCell.number = 0;
			
			for each(var cell:CellUI in _cells)
			{
				cell.warning(false);
			}
		}
		
		public function removePossibleNumbers(targetCell:CellUI):void
		{
			_chessBoardData.removePossibleNumbers(targetCell.cellData);
			
			var group:Vector.<int> = Resolver.getGroup(_cells.indexOf(targetCell));
			
			for each(var index:int in group)
			{
				var cell:CellUI = _cells[index];
				if(cell.number == 0)
				{
					cell.updatePossbileNumbersText();
				}
			}
		}
		
		public function updateSelectedCellPossibles():void
		{
			var cell:CellUI;
			for each(cell in _possibleCells)
			{
				cell.visible = _selectedCell != null;
				cell.selected = _selectedCell.possibles.indexOf(cell.number) >= 0;
			}
		}
		
		public function updateNumbersCell():void
		{
			var cell:CellUI;
			for each(cell in _numberCells)
			{
				cell.visible = _selectedCell != null;
			}
		}
		
		public function fillPossibleNumbers():void
		{
			_chessBoardData.fillPossibleNumbers();
			
			for each(var cell:CellUI in _cells)
			{
				if(cell.number == 0)
				{
					cell.updatePossbileNumbersText();
				}
			}
		}
	}
}