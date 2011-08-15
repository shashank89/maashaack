package
{
	import com.firedragon.game.lianliankan.GameBoard;
	
	import flash.display.Sprite;
	import flash.geom.Point;
	
	public class lianliankan extends Sprite
	{
		public function lianliankan()
		{
//			testGetLines();
			testGetPath();
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
			
			var data:Vector.<int> = generateRandomData(5, 5);
			
			game.init(data, 5, 5);
			
			var x:int = Math.random() * 5;
			var y:int = Math.random() * 5;
			
			trace(x, y);
			
			var lines:Vector.<Vector.<Point>> = game.getLines(new Point(x, y));
			for each(var line:Vector.<Point> in lines)
			{
				trace(line);
			}
		}
		
		private function generateRandomData(width:int, height:int):Vector.<int>
		{
			var str:String;
			var data:Vector.<int> = new Vector.<int>();
			for(var i:int = 0; i < height; ++i)
			{
				str = "";
				for(var j:int = 0; j < width; ++j)
				{
					var value:int = int(Math.random() * 2) - 1;
					data.push(value);
					
					str += value + "\t";
				}
				trace(str);
			}
			return data;
		}
	}
}