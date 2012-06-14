package com.ggshily.mail;

import java.io.IOException;
import java.util.zip.DataFormatException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.appengine.api.datastore.Blob;
import com.google.appengine.api.datastore.Cursor;
import com.google.appengine.api.datastore.DatastoreService;
import com.google.appengine.api.datastore.DatastoreServiceFactory;
import com.google.appengine.api.datastore.Entity;
import com.google.appengine.api.datastore.FetchOptions;
import com.google.appengine.api.datastore.PreparedQuery;
import com.google.appengine.api.datastore.Query;
import com.google.appengine.api.datastore.QueryResultList;
import com.google.appengine.api.datastore.Query.SortDirection;
import com.google.gson.Gson;
import com.google.gson.JsonSyntaxException;

@SuppressWarnings("serial")
public class ReportsServlet extends HttpServlet
{

	/*
	 * (non-Javadoc)
	 * 
	 * @see
	 * javax.servlet.http.HttpServlet#doGet(javax.servlet.http.HttpServletRequest
	 * , javax.servlet.http.HttpServletResponse)
	 */
	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException
	{
		DatastoreService datastore = DatastoreServiceFactory
				.getDatastoreService();

		Query q = new Query("ErrorReport");

		q.addFilter("mailSent", Query.FilterOperator.EQUAL, false);
		q.addSort("time", SortDirection.DESCENDING);
		/*
		 * q.addFilter("height", Query.FilterOperator.LESS_THAN,
		 * maxHeightParam);
		 */

		// PreparedQuery contains the methods for fetching query results
		// from the datastore
		PreparedQuery pq = datastore.prepare(q);
	    int pageSize = 15;
	    
	    FetchOptions fetchOptions = FetchOptions.Builder.withLimit(pageSize);
	    String startCursor = req.getParameter("cursor");

	    // If this servlet is passed a cursor parameter, let's use it
	    if (startCursor != null) {
	      fetchOptions.startCursor(Cursor.fromWebSafeString(startCursor));
	    }
	    
	    QueryResultList<Entity> results = pq.asQueryResultList(fetchOptions);
		String content = "{";
		for(Entity result : results)
		{
			Blob report = (Blob) result.getProperty("report");

			try
			{
				Gson gson = new Gson();
				Log log = gson.fromJson(LogUtil.getLogString(report.getBytes()), Log.class);
				log.clientLog = "";
				log.rpcActions = "";
				log.key = result.getKey().toString();
				
				content += gson.toJson(log, Log.class) + ", ";
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
		}
		if(content.length() > 1)
		{
			content = content.substring(0, content.length() - 2);
		}
		content += "}";
		resp.setContentType("text/plain");
		resp.getWriter().println(content);
	}

}
