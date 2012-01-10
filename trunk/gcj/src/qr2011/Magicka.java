package qr2011;

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;

/**
 * <div id="dsb-problem-content-div1" class="dsb-problem-content-div" style="width: 40em; "><h3>Introduction</h3>
<p>
Magicka™ is an action-adventure game developed by Arrowhead Game Studios.  In Magicka you play a wizard, invoking and combining elements to create Magicks.  This problem has a similar idea, but it does not assume that you have played Magicka.
</p>
<p>
Note: "invoke" means "call on."  For this problem, it is a technical term and you don't need to know its normal English meaning.
</p>
<h3>Problem</h3>
<p>
As a wizard, you can <b>invoke</b> eight elements, which are the "base" elements.  Each base element is a single character from {Q, W, E, R, A, S, D, F}.  When you invoke an element, it gets appended to your <b>element list</b>.  For example: if you invoke W and then invoke A, (we'll call that "invoking WA" for short) then your element list will be [W, A].
</p>
<p>
We will specify pairs of base elements that <b>combine</b> to form non-base elements (the other 18 capital letters).  For example, Q and F might combine to form T.  If the two elements from a pair appear at the end of the element list, then both elements of the pair will be immediately removed, and they will be replaced by the element they form.  In the example above, if the element list looks like [A, Q, F] or [A, F, Q] at any point, it will become [A, T].
</p>
<p>
We will specify pairs of base elements that are <b>opposed</b> to each other.  After you invoke an element, if it isn't immediately combined to form another element, and it is opposed to something in your element list, then your whole element list will be cleared.
</p>
<p>
For example, suppose Q and F combine to make T.  R and F are opposed to each other.  Then invoking the following things (in order, from left to right) will have the following results:
</p><ul>
<li>QF → [T]  (Q and F combine to form T)</li>
<li>QEF → [Q, E, F] (Q and F can't combine because they were never at the end of the element list together)</li>
<li>RFE → [E] (F and R are opposed, so the list is cleared; then E is invoked)</li>
<li>REF → [] (F and R are opposed, so the list is cleared)</li>
<li>RQF → [R, T] (QF combine to make T, so the list is not cleared)</li>
<li>RFQ → [Q] (F and R are opposed, so the list is cleared)</li>
</ul>
<p></p>
<p>
Given a list of elements to invoke, what will be in the element list when you're done?
</p>

<h3>Input</h3>
<p>
The first line of the input gives the number of test cases, <b>T</b>.  <b>T</b> test cases follow.  Each test case consists of a single line, containing the following space-separated elements in order:
</p>
<p>
First an integer <b>C</b>, followed by <b>C</b> strings, each containing three characters: two base elements followed by a non-base element.  This indicates that the two base elements combine to form the non-base element.  Next will come an integer <b>D</b>, followed by <b>D</b> strings, each containing two characters: two base elements that are opposed to each other.  Finally there will be an integer <b>N</b>, followed by a single string containing <b>N</b> characters: the series of base elements you are to invoke.  You will invoke them in the order they appear in the string (leftmost character first, and so on), one at a time.
</p>

<h3>Output</h3>
<p>
For each test case, output one line containing "Case #x: y", where x is the case number (starting from 1) and y is a list in the format "[e<sub>0</sub>, e<sub>1</sub>, ...]" where e<sub>i</sub> is the i<sup>th</sup> element of the final element list.  Please see the sample output for examples.
</p>

<h3>Limits</h3>
<p>
1 ≤ <b>T</b> ≤ 100.<br>
Each pair of base elements may only appear together in one combination, though they may appear in a combination and also be opposed to each other.<br>
No base element may be opposed to itself.<br>
Unlike in the computer game Magicka, there is no limit to the length of the element list.
</p>

<h4>Small dataset</h4>
<p>
0 ≤ <b>C</b> ≤ 1.<br>
0 ≤ <b>D</b> ≤ 1.<br>
1 ≤ <b>N</b> ≤ 10.<br>
</p>

<h4>Large dataset</h4>
<p>
0 ≤ <b>C</b> ≤ 36.<br>
0 ≤ <b>D</b> ≤ 28.<br>
1 ≤ <b>N</b> ≤ 100.<br>
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
5<br>
0 0 2 EA<br>
1 QRI 0 4 RRQR<br>
1 QFT 1 QF 7 FAQFDFQ<br>
1 EEZ 1 QE 7 QEEEERA<br>
0 1 QW 2 QW<br>
</code>
</td>
<td>
<code>
Case #1: [E, A]<br>
Case #2: [R, I, R]<br>
Case #3: [F, D, T]<br>
Case #4: [Z, E, R, A]<br>
Case #5: []<br>
</code>
</td></tr></tbody></table>
</div>
<p>
Magicka™ is a trademark of Paradox Interactive AB.  Paradox Interactive AB does not endorse and has no involvement with Google Code Jam.
</p></div>
 * @author user2
 *
 */
public class Magicka
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
					System.out.printf("Case #%d: %s\n", i, getFinalElements(input.readLine()));
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

	protected static String getFinalElements(String testCase)
	{
		String[] data = testCase.split(" ");
		
		int combineCount = Integer.valueOf(data[0]);
		String[] combineElements = new String[combineCount];
		for (int i = 0; i < combineCount; i++)
		{
			combineElements[i] = data[1 + i];
		}
		
		int opposedCount = Integer.valueOf(data[1 + combineCount]);
		String[] opposedElements = new String[opposedCount];
		for (int i = 0; i < opposedCount; i++)
		{
			opposedElements[i] = data[1 + combineCount + 1 + i];
		}
		
		char[] elements = data[data.length - 1].toCharArray();
		
		
		
		return null;
	}
}
