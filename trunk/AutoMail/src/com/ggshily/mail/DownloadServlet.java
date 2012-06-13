package com.ggshily.mail;

import java.io.IOException;
import java.util.zip.DataFormatException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.appengine.api.datastore.Blob;
import com.google.appengine.api.datastore.DatastoreService;
import com.google.appengine.api.datastore.DatastoreServiceFactory;
import com.google.appengine.api.datastore.Entity;
import com.google.appengine.api.datastore.EntityNotFoundException;
import com.google.appengine.api.datastore.KeyFactory;
import com.google.gson.Gson;
import com.google.gson.JsonSyntaxException;

@SuppressWarnings("serial")
public class DownloadServlet extends HttpServlet
{

	/* (non-Javadoc)
	 * @see javax.servlet.http.HttpServlet#doGet(javax.servlet.http.HttpServletRequest, javax.servlet.http.HttpServletResponse)
	 */
	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException
	{
		DatastoreService datastore = DatastoreServiceFactory
		.getDatastoreService();
		
		String content = "no content";
		String strFileName = "log.txt";
		try
		{		
			String key = req.getParameter("key");

			Entity result = datastore.get(KeyFactory.stringToKey(key));

			Blob report = (Blob) result.getProperty("report");

			Gson gson = new Gson();
			Log log = gson.fromJson(LogUtil.getLog(report.getBytes()), Log.class);
			
			content = log.clientLog + log.rpcActions;
		}
		catch(EntityNotFoundException e)
		{
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		catch(JsonSyntaxException e)
		{
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		catch(DataFormatException e)
		{
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		resp.setContentType("text/plain");
//		resp.setHeader("Content-Disposition", "attachment; filename="+ strFileName);
		resp.getWriter().println(content);
	}

}
