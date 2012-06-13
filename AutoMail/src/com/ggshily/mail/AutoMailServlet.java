package com.ggshily.mail;

import java.io.DataInputStream;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.GregorianCalendar;
import java.util.Properties;
import java.util.TimeZone;
import java.util.zip.DataFormatException;

import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.Multipart;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.AddressException;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeBodyPart;
import javax.mail.internet.MimeMessage;
import javax.mail.internet.MimeMultipart;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.appengine.api.datastore.Blob;
import com.google.appengine.api.datastore.DatastoreService;
import com.google.appengine.api.datastore.DatastoreServiceFactory;
import com.google.appengine.api.datastore.Entity;
import com.google.appengine.api.datastore.EntityNotFoundException;
import com.google.appengine.api.datastore.FetchOptions;
import com.google.appengine.api.datastore.PreparedQuery;
import com.google.appengine.api.datastore.Query;
import com.google.gson.Gson;

@SuppressWarnings("serial")
public class AutoMailServlet extends HttpServlet
{
	public void doGet(HttpServletRequest req, HttpServletResponse resp)
			throws IOException
	{
		Properties props = new Properties();
		Session session = Session.getDefaultInstance(props, null);

		process(req, session);
		resp.setContentType("text/plain");
		resp.getWriter().println("Hello, world");
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see
	 * javax.servlet.http.HttpServlet#doPost(javax.servlet.http.HttpServletRequest
	 * , javax.servlet.http.HttpServletResponse)
	 */
	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException
	{
		Properties props = new Properties();
		Session session = Session.getDefaultInstance(props, null);

		process(req, session);
		resp.setContentType("text/plain");
		resp.getWriter().println("Done");
	}

	private void process(HttpServletRequest req, Session session)
			throws IOException
	{
		try
		{
			storeData(req);
			if(needSendMail())
			{
				sendMail(session);
			}
		}
		catch(EntityNotFoundException e)
		{
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

	private void storeData(HttpServletRequest req) throws IOException
	{

		byte[] by = null;
		DataInputStream dis;
		dis = new DataInputStream(req.getInputStream());
		int contentLength = req.getContentLength();
		by = new byte[contentLength];
		int bytesRead = 0, totalBytesRead = 0;
		while(totalBytesRead < contentLength)
		{
			bytesRead = dis.read(by, totalBytesRead, contentLength);
			totalBytesRead += bytesRead;
		}
		log("totalBytesRead:" + totalBytesRead);

		DatastoreService datastore = DatastoreServiceFactory
				.getDatastoreService();
		Entity errorReport = new Entity("ErrorReport");
		errorReport.setProperty("report", new Blob(by));
		errorReport.setProperty("mailSent", false);
		errorReport.setProperty("time", new Date());
		datastore.put(errorReport);
	}

	private boolean needSendMail() throws EntityNotFoundException
	{
		DatastoreService datastore = DatastoreServiceFactory
				.getDatastoreService();

		Query q = new Query("LastMailTime");
		/*
		 * q.addFilter("lastName", Query.FilterOperator.EQUAL, lastNameParam);
		 * q.addFilter("height", Query.FilterOperator.LESS_THAN,
		 * maxHeightParam);
		 */

		// PreparedQuery contains the methods for fetching query results
		// from the datastore
		PreparedQuery pq = datastore.prepare(q);

		Entity lastMailTime;

		if(pq.countEntities(FetchOptions.Builder.withDefaults()) == 0)
		{
			lastMailTime = new Entity("LastMailTime", "LastMailTime");
			lastMailTime.setProperty("time", new Date());

			datastore.put(lastMailTime);
		}
		else
		{
			lastMailTime = pq.asSingleEntity();
		}

		Date lastTime = (Date) lastMailTime.getProperty("time");
		Date now = new Date();

		long elipse = now.getTime() - lastTime.getTime();

		int tick = 12 * 60 * 1000;

		Calendar cal = new GregorianCalendar();
		cal.setTime(now);
		if(cal.get(Calendar.HOUR) > 0 && cal.get(Calendar.HOUR) < 8)
		{
			tick = 6 * 60 * 1000;
		}

		if(elipse > tick)
		{
			lastMailTime = new Entity("LastMailTime", "LastMailTime");
			lastMailTime.setProperty("time", new Date());

			datastore.put(lastMailTime);
			return true;
		}

		return false;
	}

	private void sendMail(Session session) throws UnsupportedEncodingException
	{
		try
		{
			DatastoreService datastore = DatastoreServiceFactory
					.getDatastoreService();

			Query q = new Query("ErrorReport");

			q.addFilter("mailSent", Query.FilterOperator.EQUAL, false);
			/*q.addFilter("height", Query.FilterOperator.LESS_THAN,
					maxHeightParam);*/

			// PreparedQuery contains the methods for fetching query results
			// from the datastore
			PreparedQuery pq = datastore.prepare(q);

			ArrayList<Log> logs = new ArrayList<Log>();

			String mailBody = "";
			int i = 0;
			for(Entity result : pq.asIterable())
			{
				Blob report = (Blob) result.getProperty("report");
				result.setProperty("mailSent", true);

				Gson gson = new Gson();
				Log log = gson.fromJson(LogUtil.getLog(report.getBytes()), Log.class);
				logs.add(log);
				mailBody += (i++)
						+ ":<div><br>user :<a href=\"http://www.facebook.com/profile.php?id="
						+ log.userId + "\">" + log.userId
						+ "</a><br>Error code:" + log.code
						+ "<br>Error message:<br>"
						+ log.message.replaceAll("\n", "<br>") + "</div>";
				if(i == 2)
				{
					break;
				}
			}
			datastore.put(pq.asList(FetchOptions.Builder.withDefaults()));

			if(logs.size() > 0)
			{
				Message msg = new MimeMessage(session);
				msg.setFrom(new InternetAddress("gg.shily@gmail.com",
						"SimCity Error Log"));
				msg.addRecipient(Message.RecipientType.TO, new InternetAddress(
						"chen.haogang@playfish.com", "chen haogang"));
				msg.addRecipient(Message.RecipientType.TO, new InternetAddress(
						"ding.ning@playfish.com", "ding ning"));
				msg.addRecipient(Message.RecipientType.TO, new InternetAddress(
						"li.maomao@playfish.com", "li maomao"));
				msg.addRecipient(Message.RecipientType.TO, new InternetAddress(
						"qiao.jia@playfish.com", "qiao jia"));
				msg.addRecipient(Message.RecipientType.TO, new InternetAddress(
						"chen.liang@playfish.com", "chen liang"));
				msg.addRecipient(Message.RecipientType.TO, new InternetAddress(
						"li.juqiang@playfish.com", "li juqiang"));

				SimpleDateFormat df = new SimpleDateFormat(
						"MM_dd_yyyy-HH:mm:ss");
				df.setTimeZone(TimeZone.getTimeZone("GMT+8:00"));
				msg.setSubject("Simcity error report:" + logs.size() + " "
						+ df.format(new Date()));
				// msg.setText(mailBody);

				Multipart mp = new MimeMultipart();

				MimeBodyPart htmlPart = new MimeBodyPart();
				htmlPart.setContent(mailBody, "text/html");
				mp.addBodyPart(htmlPart);

				i = 0;
				for(Log log : logs)
				{
					if(log.clientLog.length() > 0)
					{
						MimeBodyPart attachment = new MimeBodyPart();
						attachment.setFileName(df.format(new Date())
								+ "_client_" + i + ".txt");
						attachment.setContent(log.clientLog, "application/txt");
						mp.addBodyPart(attachment);
					}
					if(log.rpcActions.length() > 0)
					{
						MimeBodyPart attachment1 = new MimeBodyPart();
						attachment1.setFileName(df.format(new Date())
								+ "_rpcActions_" + i + ".txt");
						attachment1.setContent(log.rpcActions,
								"application/txt");
						mp.addBodyPart(attachment1);
					}
					i++;
				}
				msg.setContent(mp);

				Transport.send(msg);
				log("mail sent");
			}
		}
		catch(AddressException e)
		{
			log(e.toString());
		}
		catch(MessagingException e)
		{
			log(e.toString());
		}
		catch(IOException e)
		{
			log(e.toString());
		}
		catch(DataFormatException e)
		{
			log(e.toString());
		}
	}
}
