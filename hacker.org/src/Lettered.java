
/**
 * @see http://www.hacker.org/challenge/chal.php?id=164
 * 
 * @author chen.haogang
 *
 */
public class Lettered
{

	public static void main(String[] args)
	{
		final String letters = "&#38&#119&#101&#105&#101&#114&#112&#59&#38&#79&#116&#105&#108&#100&#101&#59&#38&#85&#103&#114&#97&#118&#101&#59&#38&#114&#101&#97&#108&#59&#38&#99&#111&#112&#121&#59&#38&#84&#104&#101&#116&#97&#59&#38&#102&#110&#111&#102&#59&#38&#102&#110&#111&#102&#59&#38&#105&#115&#105&#110&#59&#38&#105&#115&#105&#110&#59";
		
		String[] letteres = letters.split("&#");
		
		for(int i = 1; i < letteres.length; i++)
		{
			System.out.print((char)(Integer.parseInt(letteres[i])));
		}
		
		// correct answer:pourcoffee
	}
}
