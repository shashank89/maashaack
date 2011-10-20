package com.ggshily.game.sudoku.ui
{
	import com.ggshily.game.sudoku.CellData;
	import com.ggshily.game.sudoku.ChessBoardData;
	import com.ggshily.game.ui.UIUtil;
	
	import flash.display.Sprite;
	import flash.text.TextField;
	
	public class CellUI extends Sprite
	{
		private var _textPossible:TextField;
		private var _textNumber:TextField;
		
		private var _cellSize:int;
		private var _selected:Boolean;
		
		private var _cellData:CellData;
		
		public function CellUI(x:int, y:int, size:int, cellData:CellData)
		{
			this.x = x;
			this.y = y;
			
			_cellSize = size;
			selected = false;
			
			_textPossible = UIUtil.getTextField(12, true, size);
			_textNumber = UIUtil.getTextField(36, false, size);
			
			_cellData = cellData;
			if(cellData.number > 0)
			{
				_textNumber.text = cellData.number.toString();
			}
			
			addChild(_textPossible);
			addChild(_textNumber);
			
			buttonMode = true;
			mouseChildren = false;
		}
		
		public function addPossible(number:int):void
		{
			_cellData.addPossible(number);
			updatePossbileNumbersText();
		}
		
		public function removePossible(number:int):void
		{
			_cellData.removePossible(number);
			updatePossbileNumbersText();
		}
		
		public function set possibles(value:Vector.<int>):void
		{
			_cellData.possibles = value;
			
			updatePossbileNumbersText();
			
			_textPossible.visible = true;
			_textNumber.visible = false;
		}
		
		internal function updatePossbileNumbersText():void
		{
			var text:String = "";
			for(var i:int = 0; i < ChessBoardData.MAX_NUMBER; ++i)
			{
				if(_cellData.possibles.indexOf(i + 1) == -1)
				{
					text += " ";
				}
				else
				{
					text += (i + 1).toString();
				}
				
				if((i + 1) % 3 == 0)
				{
					text += "\n";
				}
			}
			
			_textPossible.text = text;
		}
		
		public function warning(value:Boolean):void
		{
			_textNumber.textColor = value ? 0xFF0000 : 0x000000;
		}
		
		public function set number(value:int):void
		{
			_cellData.number = value;
			
			if(_cellData.number > 0)
			{
				_textNumber.text = value.toString();
				
				_textNumber.visible = true;
				_textPossible.visible = false;
			}
			else
			{
				_textNumber.text = "";
				
				_textNumber.visible = false;
				_textPossible.visible = false;
			}
		}

		public function get number():int
		{
			return _cellData.number;
		}

		public function get possibles():Vector.<int>
		{
			return _cellData.possibles;
		}

		public function get selected():Boolean
		{
			return _selected;
		}

		public function set selected(value:Boolean):void
		{
			_selected = value;
			
			var color:int = _selected ? 0xFF0000 : 0x000000;
			graphics.clear();
			graphics.lineStyle(1, color);
			graphics.beginFill(0xFFFFFF);
			graphics.drawRect(0, 0, _cellSize, _cellSize);
			graphics.endFill();
		}

		public function get cellData():CellData
		{
			return _cellData;
		}


	}
}