package
{
	import com.ggshily.game.sudoku.ui.ChessBoard;
	import com.ggshily.game.ui.CustomSelectableButton;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	[SWF(width = "760", height = "700", frameRate = "30")]
	public class sodoku extends Sprite
	{
		public static const MAX_NUMBER:int = 9;
		public static const CELL_SIZE:int = 60;
		
		private var _chessBoard:ChessBoard;
		
		public function sodoku()
		{
			var button:CustomSelectableButton = new CustomSelectableButton("button");
			
			button.addEventListener(MouseEvent.CLICK, 
				function(e:MouseEvent):void
				{
					trace("clicked");
					
					button.selected = !button.selected;
				});
			
			addChild(button);
			
			init();
		}
		
		public function init():void
		{
			_chessBoard = new ChessBoard(CELL_SIZE);
			addChild(_chessBoard);
			_chessBoard.x = 1;
			_chessBoard.y = 1;
		}
	}
}
