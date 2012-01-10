package qr2011;

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;

/**
 * <div id="dsb-problem-content-div0" class="dsb-problem-content-div" style="width: 40em; "><h3>Problem</h3>
<p>
Blue and Orange are friendly robots. An evil computer mastermind has locked them up in separate hallways to test them, and then possibly give them cake.
</p>

<p>
Each hallway contains 100 buttons labeled with the positive integers {1, 2, ..., 100}. Button k is always k meters from the start of the hallway, and the robots both begin at button 1. Over the period of one second, a robot can walk one meter in either direction, or it can press the button at its position once, or it can stay at its position and not press the button. To complete the test, the robots need to push a certain sequence of buttons in a certain order. Both robots know the full sequence in advance. How fast can they complete it?
</p>

<p>
For example, let's consider the following button sequence:
</p>

<p><code>&nbsp;&nbsp;&nbsp;O 2, B 1, B 2, O 4</code></p>

<p>
Here, <code>O 2</code> means button 2 in Orange's hallway, <code>B 1</code> means button 1 in Blue's hallway, and so on. The robots can push this sequence of buttons in 6 seconds using the strategy shown below:
</p><pre>Time | Orange           | Blue
-----+------------------+-----------------
  1  | Move to button 2 | Stay at button 1
  2  | Push button 2    | Stay at button 1
  3  | Move to button 3 | Push button 1
  4  | Move to button 4 | Move to button 2
  5  | Stay at button 4 | Push button 2
  6  | Push button 4    | Stay at button 2
</pre>
Note that Blue has to wait until Orange has completely finished pushing <code>O 2</code> before it can start pushing <code>B 1</code>.
<p></p>

<h3>Input</h3>
<p>
The first line of the input gives the number of test cases, <b>T</b>. <b>T</b> test cases follow.
</p>

<p>
Each test case consists of a single line beginning with a positive integer <b>N</b>, representing the number of buttons that need to be pressed. This is followed by <b>N</b> terms of the form "<b>R</b><sub>i</sub> <b>P</b><sub>i</sub>" where <b>R</b><sub>i</sub> is a robot color (always 'O' or 'B'), and <b>P</b><sub>i</sub> is a button position.
</p>

<h3>Output</h3>
<p>
For each test case, output one line containing "Case #x: y", where x is the case number (starting from 1) and y is the minimum number of seconds required for the robots to push the given buttons, in order.
</p>

<h3>Limits</h3>

<p>
1 ≤ <b>P</b><sub>i</sub> ≤ 100 for all i.
</p>

<h4>Small dataset</h4>
<p>
1 ≤ <b>T</b> ≤ 20.<br>
1 ≤ <b>N</b> ≤ 10.
</p>

<h4>Large dataset</h4>
<p>
1 ≤ <b>T</b> ≤ 100.<br>
1 ≤ <b>N</b> ≤ 100.
</p>

<h3>Sample</h3>
<div class="problem-io-wrapper">
<table>
<tbody><tr>
<td>
<br>
<span class="io-table-header">Input</span>
<br>&nbsp;
</td>
<td>
<br>
<span class="io-table-header">Output</span>
<br>&nbsp;
</td>
</tr>
<tr>
<td>
<code>
3<br>
4 O 2 B 1 B 2 O 4<br>
3 O 5 O 8 B 100<br>
2 B 2 B 1<br>
</code>
</td>
<td>
<code>
Case #1: 6<br>
Case #2: 100<br>
Case #3: 4<br>
<br>
</code>
</td></tr></tbody></table>
</div></div>
 * @author user2
 *
 */
public class BotTrust
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
					System.out.printf("Case #%d: %d\n", i, getMinSeconds(input.readLine()));
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

	protected static int getMinSeconds(String testCase)
	{
		String[] data = testCase.split(" ");
		int buttonNumber = Integer.valueOf(data[0]);
		int time = 0;
		Robot oRobot = new Robot("O", 1);
		Robot bRobot = new Robot("B", 1);
		
		int index = 0;
		while(index < buttonNumber)
		{
			Robot firstRobot = data[1 + index * 2].equals("O") ? oRobot : bRobot;
			int target = Integer.valueOf(data[1 + index * 2 + 1]);
			if(firstRobot.postion != target)
			{
				firstRobot.postion += (target - firstRobot.postion) / Math.abs(target - firstRobot.postion);
				time++;
				
//				System.out.printf("time: %d\n", time);
//				System.out.printf("%s go to %d\n", firstRobot.name, firstRobot.postion);
			}
			else
			{
				time++;

//				System.out.printf("time: %d\n", time);
//				System.out.printf("%s press button\n", firstRobot.name);
				
				index++;
			}
			
			int nextIndex = index;
			while(nextIndex < buttonNumber)
			{
				if(!data[1 + nextIndex * 2].equals(firstRobot.name))
				{
					Robot secondRobot = firstRobot == oRobot ? bRobot : oRobot;
					target = Integer.valueOf(data[1 + nextIndex * 2 + 1]);
					if(secondRobot.postion != target)
					{
						secondRobot.postion += (target - secondRobot.postion) / Math.abs(target - secondRobot.postion);

//						System.out.printf("%s go to %d\n", secondRobot.name, secondRobot.postion);
					}
					else
					{
//						System.out.printf("%s stay on %d\n", secondRobot.name, secondRobot.postion);
					}
					break;
				}
				nextIndex++;
			}
		}
		
		return time;
	}

}

class Robot
{
	public String name;
	public int postion;
	public Robot(String name, int postion)
	{
		super();
		this.name = name;
		this.postion = postion;
	}
}
