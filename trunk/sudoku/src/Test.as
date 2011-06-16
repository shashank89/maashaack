package
{
	import com.ggshily.game.sudoku.Checker;
	
	import flash.display.Sprite;
	
	import flashx.textLayout.utils.CharacterUtil;

	public class Test extends Sprite
	{
		public function Test()
		{
			testCheck();
		}
		
		private function testCheck() : void
		{
			var data : Vector.<int> = Vector.<int>(
				[1, 2 , 3, 4 , 5 , 6 , 7 , 8 , 9 ,
				4,  5,  6,  7,  8,  9,  1,  2,  3,
				7,  8,  9,  1,  2,  3,  4,  5,  6,
				2,  3,  1,  5,  6,  4,  8,  9,  7, 
				5,  6,  4,  8,  9,  7,  2,  3,  1,
				8,  9,  7,  2,  3,  1,  5,  6,  4,
				3,  1,  2,  6,  4,  5,  9,  7,  8,
				6,  4,  5,  9,  7,  8,  3,  1,  2,
				9,  7,  8,  3,  1,  2,  6,  4,  5]);
			trace(Checker.check(data));
			
			data = Vector.<int>([3, 4, 5, 9, 8, 2, 7, 1, 6,
				6, 7, 9, 4, 5, 1, 3, 2, 8,
				1, 8, 2, 7, 3, 6, 9, 5, 4,
				2, 3, 4, 6, 7, 8, 1, 9, 5,
				5, 1, 6, 2, 9, 3, 8, 4, 7,
				8, 9, 7, 1, 4, 5, 2, 6, 3,
				7, 5, 1, 3, 6, 9, 4, 8, 2,
				4, 2, 8, 5, 1, 7, 6, 3, 9,
				9, 6, 3, 8, 2, 4, 5, 7, 1,]);
			trace(Checker.check(data));
		}
		
		private function testParseIndex() : void
		{
			trace(Checker.parseSquareIndex(0, 0) == 0);
			trace(Checker.parseSquareIndex(0, 1) == 1);
			trace(Checker.parseSquareIndex(0, 2) == 2);
			trace(Checker.parseSquareIndex(0, 3) == 9);
			trace(Checker.parseSquareIndex(0, 4) == 10);
			trace(Checker.parseSquareIndex(0, 5) == 11);
			trace(Checker.parseSquareIndex(0, 6) == 18);
			trace(Checker.parseSquareIndex(0, 7) == 19);
			trace(Checker.parseSquareIndex(0, 8) == 20);
			trace(Checker.parseSquareIndex(1, 0) == 3);
			trace(Checker.parseSquareIndex(1, 1) == 4);
			trace(Checker.parseSquareIndex(1, 2) == 5);
			trace(Checker.parseSquareIndex(1, 3) == 12);
			trace(Checker.parseSquareIndex(1, 4) == 13);
			trace(Checker.parseSquareIndex(1, 5) == 14);
			trace(Checker.parseSquareIndex(1, 6) == 21);
			trace(Checker.parseSquareIndex(1, 7) == 22);
			trace(Checker.parseSquareIndex(1, 8) == 23);
			trace(Checker.parseSquareIndex(2, 0) == 6);
			trace(Checker.parseSquareIndex(2, 1) == 7);
			trace(Checker.parseSquareIndex(2, 2) == 8);
			trace(Checker.parseSquareIndex(2, 3) == 15);
			trace(Checker.parseSquareIndex(2, 4) == 16);
			trace(Checker.parseSquareIndex(2, 5) == 17);
			trace(Checker.parseSquareIndex(2, 6) == 24);
			trace(Checker.parseSquareIndex(2, 7) == 25);
			trace(Checker.parseSquareIndex(2, 8) == 26);
			trace(Checker.parseSquareIndex(3, 0) == 27);
			trace(Checker.parseSquareIndex(3, 1) == 28);
			trace(Checker.parseSquareIndex(3, 2) == 29);
			trace(Checker.parseSquareIndex(3, 3) == 36);
			trace(Checker.parseSquareIndex(3, 4) == 37);
			trace(Checker.parseSquareIndex(3, 5) == 38);
			trace(Checker.parseSquareIndex(3, 6) == 45);
			trace(Checker.parseSquareIndex(3, 7) == 46);
			trace(Checker.parseSquareIndex(3, 8) == 47);
			trace(Checker.parseSquareIndex(4, 0) == 30);
			trace(Checker.parseSquareIndex(4, 1) == 31);
			trace(Checker.parseSquareIndex(4, 2) == 32);
			trace(Checker.parseSquareIndex(4, 3) == 39);
			trace(Checker.parseSquareIndex(4, 4) == 40);
			trace(Checker.parseSquareIndex(4, 5) == 41);
			trace(Checker.parseSquareIndex(4, 6) == 48);
			trace(Checker.parseSquareIndex(4, 7) == 49);
			trace(Checker.parseSquareIndex(4, 8) == 50);
			trace(Checker.parseSquareIndex(5, 0) == 33);
			trace(Checker.parseSquareIndex(5, 1) == 34);
			trace(Checker.parseSquareIndex(5, 2) == 35);
			trace(Checker.parseSquareIndex(5, 3) == 42);
			trace(Checker.parseSquareIndex(5, 4) == 43);
			trace(Checker.parseSquareIndex(5, 5) == 44);
			trace(Checker.parseSquareIndex(5, 6) == 51);
			trace(Checker.parseSquareIndex(5, 7) == 52);
			trace(Checker.parseSquareIndex(5, 8) == 53);
			trace(Checker.parseSquareIndex(6, 0) == 54);
			trace(Checker.parseSquareIndex(6, 1) == 55);
			trace(Checker.parseSquareIndex(6, 2) == 56);
			trace(Checker.parseSquareIndex(6, 3) == 63);
			trace(Checker.parseSquareIndex(6, 4) == 64);
			trace(Checker.parseSquareIndex(6, 5) == 65);
			trace(Checker.parseSquareIndex(6, 6) == 72);
			trace(Checker.parseSquareIndex(6, 7) == 73);
			trace(Checker.parseSquareIndex(6, 8) == 74);
			trace(Checker.parseSquareIndex(7, 0) == 57);
			trace(Checker.parseSquareIndex(7, 1) == 58);
			trace(Checker.parseSquareIndex(7, 2) == 59);
			trace(Checker.parseSquareIndex(7, 3) == 66);
			trace(Checker.parseSquareIndex(7, 4) == 67);
			trace(Checker.parseSquareIndex(7, 5) == 68);
			trace(Checker.parseSquareIndex(7, 6) == 75);
			trace(Checker.parseSquareIndex(7, 7) == 76);
			trace(Checker.parseSquareIndex(7, 8) == 77);
			trace(Checker.parseSquareIndex(8, 0) == 60);
			trace(Checker.parseSquareIndex(8, 1) == 61);
			trace(Checker.parseSquareIndex(8, 2) == 62);
			trace(Checker.parseSquareIndex(8, 3) == 69);
			trace(Checker.parseSquareIndex(8, 4) == 70);
			trace(Checker.parseSquareIndex(8, 5) == 71);
			trace(Checker.parseSquareIndex(8, 6) == 78);
			trace(Checker.parseSquareIndex(8, 7) == 79);
			trace(Checker.parseSquareIndex(8, 8) == 80);
		}
	}
}