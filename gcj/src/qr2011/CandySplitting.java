package qr2011;

/**
 * <div id="dsb-problem-content-div2" class="dsb-problem-content-div" style="width: 40em; "><h3>Problem</h3>

<p>
Sean and Patrick are brothers who just got a nice bag of candy from their parents.  Each piece of candy has some positive integer value, and the children want to divide the candy between them.   First, Sean will split the candy into two piles, and choose one to give to Patrick. Then Patrick will try to calculate the value of each pile, where the value of a pile is the sum of the values of all pieces of candy in that pile; if he decides the piles don't have equal value, he will start crying.
</p>

<p>
Unfortunately, Patrick is very young and doesn't know how to add properly.  He <i>almost</i> knows how to add numbers in binary; but when he adds two 1s together, he always forgets to carry the remainder to the next bit. For example, if he wants to sum 12 (1100 in binary) and 5 (101 in binary), he will add the two rightmost bits correctly, but in the third bit he will forget to carry the remainder to the next bit:
</p>

<pre>  1100
+ 0101
------
  1001
</pre>

<p>
So after adding the last bit without the carry from the third bit, the final result is 9 (1001 in binary).  Here are some other examples of Patrick's math skills:
</p>

<pre>5 + 4 = 1
7 + 9 = 14
50 + 10 = 56
</pre>

<p>
Sean is very good at adding, and he wants to take as much value as he can without causing his little brother to cry.  If it's possible, he will split the bag of candy into two non-empty piles such that Patrick thinks that both have the same value. Given the values of all pieces of candy in the bag, we would like to know if this is possible; and, if it's possible, determine the maximum possible value of Sean's pile.
</p>

<h3>Input</h3>
<p>
The first line of the input gives the number of test cases, <b>T</b>.  <b>T</b> test cases follow.  Each test case is described in two lines. The first line contains a single integer <b>N</b>, denoting the number of candies in the bag. The next line contains the <b>N</b> integers <b>C<sub>i</sub></b> separated by single spaces, which denote the value of each piece of candy in the bag.
</p>

<h3>Output</h3>
<p>
For each test case, output one line containing "Case #x: y", where x is the case number (starting from 1). If it is impossible for Sean to keep Patrick from crying, y should be the word "NO". Otherwise, y should be the value of the pile of candies that Sean will keep.
</p>

<h3>Limits</h3>
<p>
1 ≤ <b>T</b> ≤ 100.<br>
1 ≤ <b>C<sub>i</sub></b> ≤ 10<sup>6</sup>.<br>
</p>

<h4>Small dataset</h4>
<p>
2 ≤ <b>N</b> ≤ 15.
</p>

<h4>Large dataset</h4>
<p>
2 ≤ <b>N</b> ≤ 1000.
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
2<br>
5<br>
1 2 3 4 5<br>
3<br>
3 5 6<br>
</code>
</td>
<td>
<code>
Case #1: NO<br>
Case #2: 11<br>
<br>
</code>
</td></tr></tbody></table>
</div>
</div>
 * @author user2
 *
 */
public class CandySplitting
{

}
