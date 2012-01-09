package y2011.qr;

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;

/**
 * <div class="mvm uiP fsm">A double-square number is an integer <b>X</b> which can be expressed as the
sum of two perfect squares.  For example, 10 is a double-square because 10 =
3<sup>2</sup> + 1<sup>2</sup>.  Your task in this problem is, given <b>X</b>, 
determine the number of ways in which it can be written as the sum of two
squares.  For example, 10 can only be written as 3<sup>2</sup> + 1<sup>2</sup>
(we don't count 1<sup>2</sup> + 3<sup>2</sup> as being different).  On the
other hand, 25 can be written as 5<sup>2</sup> + 0<sup>2</sup> or as
4<sup>2</sup> + 3<sup>2</sup>.<br><br>
<h3>Input</h3>
You should first read an integer <b>N</b>, the number of test cases.  The next
<b>N</b> lines will contain <b>N</b> values of <b>X</b>.
<h3>Constraints</h3>
0 ≤ <b>X</b> ≤ 2147483647<br>
1 ≤ <b>N</b> ≤ 100
<h3>Output</h3>
For each value of <b>X</b>, you should output the number of ways to write
<b>X</b> as the sum of two squares.
</div>
 * @author user2
 *
 */
public class DoubleSquares
{
	public static void main(String[] args)
	{
		if (args.length != 1)
		{
			System.out.println("need a file name paramter");
			return;
		}
		try
		{
			BufferedReader input = new BufferedReader(new FileReader(args[0]));
			try
			{
				int n = Integer.valueOf(input.readLine());
				int i = 0;
				while (i++ < n)
				{
					System.out.println(getNumber(Integer.valueOf(input.readLine())));
				}
			}
			finally
			{
				input.close();
			}
		}
		catch (IOException ex)
		{
			ex.printStackTrace();
		}
	}

	protected static int getNumber(int x)
	{
		int count = 0;
		
		final int sqrt = (int) Math.sqrt(x);
		int i = 0;
		do
		{
			int j = (int) Math.sqrt(x - i * i);
			if(i * i + j * j == x && i <= j)
			{
				count++;
			}
		}while(++i < sqrt);
		
		return count;
	}
}
