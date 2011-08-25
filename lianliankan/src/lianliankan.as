package
{
	import com.firedragon.game.lianliankan.GameBoard;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	
	import flashx.textLayout.debug.assert;
	
	[SWF(width = "760", height = "520", frameRate = "30")]
	public class lianliankan extends Sprite
	{
		private var _gameBoard:GameBoard;
		
		private var _cells:Vector.<Sprite>;
		private var _selectPoint:Point;
		
		public function lianliankan()
		{
			_gameBoard = new GameBoard();
			_gameBoard.init(generateRandomData(8, 8), 8, 8);
			
			_cells = new Vector.<Sprite>();
			for(var y:int = 0; y < 8; ++y)
			{
				for(var x:int = 0; x < 8; ++x)
				{
					var sprite:Sprite = new Sprite();
					sprite.graphics.beginFill(0x0000FF, .5);
					sprite.graphics.drawRect(-20, -20, 40, 40);
					sprite.graphics.endFill();
					
					var tf:TextField = new TextField();
					tf.text = _gameBoard.data[x + y * 8].toString();
					tf.selectable = false;
					sprite.addChild(tf);
					
					sprite.x = x * 50 + 50;
					sprite.y = y * 50 + 50;
					
					sprite.addEventListener(MouseEvent.CLICK, clickHandler);
					
					addChild(sprite);
					
					_cells.push(sprite);
				}
			}
			
			testGetLines();
		}
		
		private function clickHandler(e:MouseEvent):void
		{
			var index:int = _cells.indexOf(e.currentTarget);
			var selectPoint:Point = new Point(index % 8, int(index / 8));
			
			if(_selectPoint == null)
			{
				_selectPoint = selectPoint;
			}
			else
			{
				var path:Vector.<Point> = _gameBoard.select(_selectPoint, selectPoint);
				
				trace(path);
				
				if(path.length > 0)
				{
					removeChild(_cells[index]);
					removeChild(_cells[_selectPoint.x + _selectPoint.y * 8]);
				}
				
				_selectPoint = null;
				
			}
		}
		
		private function testGetPath():void
		{
			var game:GameBoard = new GameBoard();
			
			var str:String;
			
			var data:Vector.<int> = Vector.<int>(
				[
					-1,  0,  0, -1, -1,
					0 , -1,  0,  0,  0,
					0 ,  0, -1,  0,  0,
					0 , -1,  0, -1, -1,
					-1, 0 , -1, 0 , 0 ,
				]);
			
			game.init(data, 5, 5);
			
			var x1:int = 0;
			var y1:int = 1;
			trace(x1, y1);
			
			var x2:int = 0;
			var y2:int = 3;
			trace(x2, y2);
			
			var path:Vector.<Point> = game.getPath(new Point(x1, y1), new Point(x2, y2));
			trace(path);
		}
		
		private function testGetLines():void
		{
			var game:GameBoard = new GameBoard();
			
			var str:String;
			
			var data:Vector.<int> = generateRandomData(6, 6);
			
			data = Vector.<int>(
				[
					0, 0,  0,  0,  0,
					0, 0,  0,  0,  0,
					0, 0,  0,  0,  0,
					0, 0,  0,  0,  0,
					0, 0,  0,  0,  0,
				]);
			
			game.init(data, 5, 5);
			
			var x:int = 0;
			var y:int = 0;
			
			trace(x, y);
			
			var lines:Vector.<Vector.<Point>> = game.getLines(new Point(x, y));
			trace(lines); // (x=-1, y=0),(x=0, y=-1)
			
			trace(game.getLines(new Point(1, 0)));  //(x=1, y=-1)
			trace(game.getLines(new Point(2, 0)));  //(x=2, y=-1)
			trace(game.getLines(new Point(3, 0)));  //(x=3, y=-1)
			trace(game.getLines(new Point(4, 0)));  //(x=5, y=0),(x=4, y=-1)
			trace(game.getLines(new Point(0, 1)));  //(x=-1, y=1)
			trace(game.getLines(new Point(1, 1)));  //
			trace(game.getLines(new Point(2, 1)));  //
			trace(game.getLines(new Point(3, 1)));  //
			trace(game.getLines(new Point(4, 1)));  //(x=5, y=1)
			trace(game.getLines(new Point(0, 2)));  //(x=-1, y=2)
			trace(game.getLines(new Point(1, 2)));  //
			trace(game.getLines(new Point(2, 2)));  //
			trace(game.getLines(new Point(3, 2)));  //
			trace(game.getLines(new Point(4, 2)));  //(x=5, y=2)
			trace(game.getLines(new Point(0, 3)));  //(x=-1, y=3)
			trace(game.getLines(new Point(1, 3)));  //
			trace(game.getLines(new Point(2, 3)));  //
			trace(game.getLines(new Point(3, 3)));  //
			trace(game.getLines(new Point(4, 3)));  //(x=5, y=3)
			trace(game.getLines(new Point(0, 4)));  //(x=-1, y=4),(x=0, y=5)
			trace(game.getLines(new Point(1, 4)));  //(x=1, y=5)
			trace(game.getLines(new Point(2, 4)));  //(x=2, y=5)
			trace(game.getLines(new Point(3, 4)));  //(x=3, y=5)
			trace(game.getLines(new Point(4, 4)));  //(x=5, y=4),(x=4, y=5)
			
			data = Vector.<int>(
				[
					0, -1,  0,  -1,  0,
					-1, 0,  -1,  0,  -1,
					0, -1,  0,  -1,  0,
					-1, 0,  -1,  0,  -1,
					0, -1,  0,  -1,  0,
				]);
			
			game.init(data, 5, 5);
			trace(game.getLines(new Point(0, 0)));  //(x=-1, y=0),(x=1, y=0),(x=0, y=-1),(x=0, y=1)
			trace(game.getLines(new Point(2, 0)));  //(x=1, y=0),(x=3, y=0),(x=2, y=-1),(x=2, y=1)
			trace(game.getLines(new Point(4, 0)));  //(x=3, y=0),(x=5, y=0),(x=4, y=-1),(x=4, y=1)
			trace(game.getLines(new Point(1, 1)));  //(x=0, y=1),(x=-1, y=1),(x=2, y=1),(x=1, y=0),(x=1, y=-1),(x=1, y=2)
			trace(game.getLines(new Point(3, 1)));  //(x=2, y=1),(x=4, y=1),(x=5, y=1),(x=3, y=0),(x=3, y=-1),(x=3, y=2)
			trace(game.getLines(new Point(0, 2)));  //(x=-1, y=2),(x=1, y=2),(x=0, y=1),(x=0, y=3)
			trace(game.getLines(new Point(2, 2)));  //(x=1, y=2),(x=3, y=2),(x=2, y=1),(x=2, y=3)
			trace(game.getLines(new Point(4, 2)));  //(x=3, y=2),(x=5, y=2),(x=4, y=1),(x=4, y=3)
			trace(game.getLines(new Point(1, 3)));  //(x=0, y=3),(x=-1, y=3),(x=2, y=3),(x=1, y=2),(x=1, y=4),(x=1, y=5)
			trace(game.getLines(new Point(3, 3)));  //(x=2, y=3),(x=4, y=3),(x=5, y=3),(x=3, y=2),(x=3, y=4),(x=3, y=5)
			trace(game.getLines(new Point(0, 4)));  //(x=-1, y=4),(x=1, y=4),(x=0, y=3),(x=0, y=5)
			trace(game.getLines(new Point(2, 4)));  //(x=1, y=4),(x=3, y=4),(x=2, y=3),(x=2, y=5)
			trace(game.getLines(new Point(4, 4)));  //(x=3, y=4),(x=5, y=4),(x=4, y=3),(x=4, y=5)
		}
		
		private function generateRandomData(width:int, height:int, total:int = 10):Vector.<int>
		{
			var data:Vector.<int> = new Vector.<int>(width * height);
			
			var index:Vector.<int> = new Vector.<int>();
			for(var i:int = 0; i < width*height; ++i)
			{
				index.push(i);
			}
			while(index.length > 0)
			{
				var value:int = Math.random() * total;
				
				var position:int = Math.random() * index.length;
				data[index[position]] = value;
				index.splice(position, 1);
				
				position = Math.random() * index.length;
				data[index[position]] = value;
				index.splice(position, 1);
			}
			
			var str:String;
			for(i = 0; i < height; ++i)
			{
				str = "";
				for(var j:int = 0; j < width; ++j)
				{
					str += data[j + i * width] + "\t";
				}
				trace(str);
			}
			return data;
		}
	}
}