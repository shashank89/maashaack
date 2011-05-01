package
{
	import com.ggshily.game.geom.Grid;
	import com.ggshily.game.geom.Parallelogram;
	import com.ggshily.game.geom.Rhombus;
	import com.ggshily.game.geom.RhombusGrid;
	
	import flash.display.Graphics;
	import flash.display.SpreadMethod;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.ui.Mouse;
	
	[SWF(width="760", height="700", backgroundColor="#ffffff", frameRate="30",allowFullScreen="true")]
	public class GridTest extends Sprite
	{
		public function GridTest()
		{
			
			var map : Sprite = new Sprite();
			addChild(map);
			
			var cell:Parallelogram = new Rhombus(32, 16);
			var frame : Grid = new RhombusGrid(cell as Rhombus, 20, 20);
			frame.setGrid(20, 20);
			drawGrid(map.graphics, frame, 0x00FF00, false);
			
			var building1 : Grid = new RhombusGrid(cell as Rhombus, 4, 4);
			var building2 : Grid = new RhombusGrid(cell as Rhombus, 3, 3);
			
			var result : Grid = new Grid(cell);
			frame.containsPointInGrid(100, 100, result);
			building1.setPosCell(result.cellX, result.cellY, frame);
			
			frame.containsPointInGrid(102, 102, result);
			building2.setPosCell(result.cellX, result.cellY, frame);
			
			trace(building1.intersectsGrid(building2));
			
			map.graphics.beginFill(0x0000FF);
			map.graphics.moveTo(building1.x + building1.xoffset, building1.y);
			map.graphics.lineTo(building1.x + building1.width, building1.y + building1.height - building1.yoffset);
			map.graphics.lineTo(building1.x + building1.width - building1.xoffset, building1.y + building1.height);
			map.graphics.lineTo(building1.x, building1.y + building1.yoffset);
			map.graphics.lineTo(building1.x + building1.xoffset, building1.y);
			map.graphics.endFill();
			
			var top : Sprite = new Sprite();
			addChild(top);
			top.mouseEnabled = false;
			
			stage.addEventListener(MouseEvent.MOUSE_MOVE, 
				function(e : MouseEvent) : void
				{
					trace("out : " + frame.containsPointInGrid(e.localX, e.localY, result).isOut());
					building2.setPosCell(result.cellX, result.cellY, frame);
					var intersect : Boolean = building1.intersectsGrid(building2);
					
					top.x = building2.x;
					top.y = building2.y;
					
					trace(top.x , top.y);
					
					top.graphics.clear();
					top.graphics.beginFill(intersect ? 0xFF0000 : 0x0000FF);
					top.graphics.moveTo(0 + building2.xoffset, 0);
					top.graphics.lineTo( building2.width,  building2.height - building2.yoffset);
					top.graphics.lineTo( building2.width - building2.xoffset,  building2.height);
					top.graphics.lineTo(0,  building2.yoffset);
					top.graphics.lineTo( building2.xoffset, 0);
					top.graphics.endFill();
				}
			);
		}
		
		private function drawGrid(graphics : Graphics, grid : Grid, color : int, fill : Boolean) : void
		{
			graphics.clear();
			if(fill)
				graphics.beginFill(color);
			else
				graphics.lineStyle(1, color);
			graphics.moveTo(grid.x + grid.xoffset, grid.y);
			graphics.lineTo(grid.x + grid.width, grid.y + grid.height - grid.yoffset);
			graphics.lineTo(grid.x + grid.width - grid.xoffset, grid.y + grid.height);
			graphics.lineTo(grid.x, grid.y + grid.yoffset);
			graphics.lineTo(grid.x + grid.xoffset, grid.y);
			if(fill)
				graphics.endFill();
		}
	}
}