
public class DidacticBits
{

	/**
	 * @param args
	 */
	public static void main(String[] args)
	{
		final String cypher = "abbbabaaabbabaaaabbaababaabaaaaaabbaaaababbabbbaabbbaabbabbbabbbabbaabababbbaabaaabaaaaaabbabaababbbaabbaabaaaaaabbaaaababbaabaaabbbabababbabbababbaaabaabbbaabaabbaaaababbbabaaabbaabab";
		
		final int[] cypherNumber = new int[cypher.length()];
		
		for(int i = 0; i < cypher.length(); ++i)
		{
			cypherNumber[i] = cypher.charAt(i) == 'a' ? 0 : 1;
		}

		for(int i = 0; i < cypher.length(); i += 8)
		{
			int temp = 0;
			for(int j = 0; j < 8; ++j)
			{
				temp |= cypherNumber[i + j] << (7 - j);
			}
			System.out.print((char)temp);
		}
	}

}
