import com.ggshily.game.magiccube.Cube;
import com.ggshily.game.magiccube.CubeFactory;


public class Main
{
	public static void main(String[] args)
	{
		int[] data = {0, 0, 0, 0, 0, 0, 0, 0, 0,
					  1, 1, 1, 1, 1, 1, 1, 1, 1,
					  2, 2, 2, 2, 2, 2, 2, 2, 2,
					  3, 3, 3, 3, 3, 3, 3, 3, 3,
					  4, 4, 4, 4, 4, 4, 4, 4, 4,
					  5, 5, 5, 5, 5, 5, 5, 5, 5,
					  };
		
		Cube cube = CubeFactory.createCube(data);
		System.out.println(cube.toString());
		System.out.println();
		
//		cube.R();
//		System.out.println(cube.toString());
//		
//		cube.R_CC();
//		System.out.println(cube.toString());
//		
//		cube.U();
//		System.out.println(cube.toString());
//		
//		cube.U_CC();
//		System.out.println(cube.toString());
//		
//		cube.L();
//		System.out.println(cube.toString());
//		
//		cube.L_CC();
//		System.out.println(cube.toString());
//		
//		cube.F();
//		System.out.println(cube.toString());
//		
//		cube.F_CC();
//		System.out.println(cube.toString());
//		
//		cube.D();
//		System.out.println(cube.toString());
//		
//		cube.D_CC();
//		System.out.println(cube.toString());
	}
}
