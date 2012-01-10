package qr2011;

/**
 * <div id="dsb-problem-content-div3" class="dsb-problem-content-div" style="width: 40em; "><h3>Problem</h3>
<p>
Goro has 4 arms. Goro is very strong. You don't mess with Goro. Goro needs to sort an array of <b>N</b> different integers. Algorithms are not Goro's strength; strength is Goro's strength. Goro's plan is to use the fingers on two of his hands to hold down several elements of the array and hit the table with his third and fourth fists as hard as possible. This will make the unsecured elements of the array fly up into the air, get shuffled randomly, and fall back down into the empty array locations.
</p>

<p>
Goro wants to sort the array as quickly as possible. How many hits will it take Goro to sort the given array, on average, if he acts intelligently when choosing which elements of the array to hold down before each hit of the table?  Goro has an infinite number of fingers on the two hands he uses to hold down the array.
</p>

<p>
More precisely, before each hit, Goro may choose any subset of the elements of the array to freeze in place. He may choose differently depending on the outcomes of previous hits. Each hit permutes the unfrozen elements uniformly at random. Each permutation is equally likely.
</p>

<h3>Input</h3>
<p>
The first line of the input gives the number of test cases, <b>T</b>.  <b>T</b> test cases follow.  Each one will consist of two lines. The first line will give the number <b>N</b>. The second line will list the <b>N</b> elements of the array in their initial order.
</p>

<h3>Output</h3>
<p>
For each test case, output one line containing "Case #<b>x</b>: <b>y</b>", where <b>x</b> is the case number (starting from 1) and <b>y</b> is the expected number of hit-the-table operations when following the best hold-down strategy. Answers with an absolute or relative error of at most 10<sup>-6</sup> will be considered correct.
</p>

<h3>Limits</h3>
<p>
1 ≤ <b>T</b> ≤ 100;<br>
The second line of each test case will contain a permutation of the <b>N</b>
smallest positive integers.<br>
</p>

<h4>Small dataset</h4>
<p>
1 ≤ <b>N</b> ≤ 10;
</p>

<h4>Large dataset</h4>
<p>
1 ≤ <b>N</b> ≤ 1000;
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
2<br>
2 1<br>
3<br>
1 3 2<br>
4<br>
2 1 4 3<br>
</code>
</td>
<td>
<code>
Case #1: 2.000000<br>
Case #2: 2.000000<br>
Case #3: 4.000000<br>
<br>
</code>
</td></tr></tbody></table>
</div>

<h3>Explanation</h3>
In test case #3, one possible strategy is to hold down the two leftmost elements first. Elements 3 and 4 will be free to move. After a table hit, they will land in the correct order [3, 4] with probability 1/2 and in the wrong order [4, 3] with probability 1/2. Therefore, on average it will take 2 hits to arrange them in the correct order. After that, Goro can hold down elements 3 and 4 and hit the table until 1 and 2 land in the correct order, which will take another 2 hits, on average. The total is then <nobr>2 + 2 = 4</nobr> hits.
</div>
 * @author user2
 *
 */
public class GoroSort
{

}
