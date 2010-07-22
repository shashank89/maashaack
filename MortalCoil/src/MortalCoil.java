import java.io.BufferedReader;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.MalformedURLException;
import java.net.URL;

import com.ggshily.mortalcoil.GameMap;

/**
 * 
 */

/**
 * @author playfish_chg
 *
 */
public class MortalCoil
{
	public static final String FLASHVARS = "FlashVars=";

	/**
	 * @param args
	 */
	public static void main(String[] args)
	{
		new Thread(new Runnable(){

			@Override
			public void run()
			{
				URL u;
				try
				{
					GameMap gm = new GameMap();
					int level = 1;
//					u = new URL("http://www.hacker.org/coil/index.php?name=gg_shily&password=kzhxkzhx&gotolevel=1&go=Go+To+Level");
					u = new URL("http://www.hacker.org/coil/index.php?name=gg_shily&password=kzhxkzhx");
					while(true)
					{
						level++;
						//+ "&path=" + path + "&x=" + startX + "&y=" + startY);gotolevel=1&go=Go+To+Level
				        InputStream is = u.openStream();
				        BufferedReader in = new BufferedReader(new InputStreamReader(is));
				        StringBuilder content = new StringBuilder();
				        String str;
				        while ((str = in.readLine())!= null) { content.append(str).append("\n"); }
				        is.close();
				        
				        int index = content.indexOf(FLASHVARS);
				        if(index > 0)
				        {
				        	String mapdata = content.substring(index + FLASHVARS.length() + 1, content.indexOf("\"", index + FLASHVARS.length() + 1));
				        	gm.setMap(mapdata);
				        	System.out.println(gm.getFormatMap());
				        	String solution = gm.getPath();
				        	if(solution != null)
				        	{
								u = new URL("http://www.hacker.org/coil/index.php?name=gg_shily&password=kzhxkzhx&" + solution);
				        		System.out.println(solution);
				        	}
				        	else
				        	{
				        		System.out.println(mapdata);
				        	}
				        }
				        else
				        {
				        	System.out.println(content);
				        	break;
				        }
					}
				} catch (Exception e)
				{
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			}}).start();
	}

}
