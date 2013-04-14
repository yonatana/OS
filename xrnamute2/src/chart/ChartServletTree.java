package chart;

import java.awt.BasicStroke;
import java.awt.Color;
import java.awt.Paint;
import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.Closeable;
import java.io.DataInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.ObjectOutputStream;
import java.io.OutputStream;
import java.net.URLDecoder;
import java.util.ArrayList;

import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.swing.JFileChooser;
import javax.swing.filechooser.FileNameExtensionFilter;

import org.jfree.chart.ChartFactory;
import org.jfree.chart.ChartUtilities;
import org.jfree.chart.JFreeChart;
import org.jfree.data.xy.DefaultXYDataset;
import org.jfree.data.xy.XYSeries;
import org.jfree.data.xy.XYSeriesCollection;
import org.jfree.chart.axis.NumberAxis;
import org.jfree.chart.plot.PlotOrientation;
import org.jfree.chart.plot.XYPlot;
import org.jfree.chart.renderer.xy.XYLineAndShapeRenderer;

import XRNA.DB;
import XRNA.dataPoint;
import XRNA.resultData;


public class ChartServletTree extends HttpServlet {
	private static final long serialVersionUID = 1L;

	private int id=0;
	private DB db = new DB();
	private ArrayList<dataPoint> myDataPointsTree;
	private resultData myResults;
	private String filePath;
	private static int DEFAULT_BUFFER_SIZE = 10240;


	public void init() throws ServletException {
		// gets the path for all the files
		filePath = getServletContext().getRealPath("");//+ File.separator + "chart.jpg";
	}

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {

		response.setContentType("image/png");
		OutputStream outputStream = response.getOutputStream();

		//gets the session
		HttpSession session = request.getSession(true);

		//get id from result.jsp
		String idString = request.getParameter("id").replace(" ", "");
		id = Integer.parseInt(idString);

		//gets the chart and saves it in the session
		session.setAttribute("myChartTree", getChart());

		int width = 650;
		int height = 500;

		ChartUtilities.writeChartAsPNG(outputStream, (JFreeChart) session.getAttribute("myChartTree")/*myChart*/, width, height);


	}   
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		/**
		 * The File servlet for serving from absolute path.
		 * @author BalusC
		 * @link http://balusc.blogspot.com/2007/07/fileservlet.html
		 */


		//get id from result.jsp
		String idString = request.getParameter("id").replace(" ", "");
		id = Integer.parseInt(idString);

		// Get requested file by path info.
		String requestedFile = request.getPathInfo();

		// Check if file is actually supplied to the request URI.
		if (requestedFile == null) {
			// Do your thing if the file is not supplied to the request URI.
			// Throw an exception, or send 404, or show default/warning page, or just ignore it.
			System.out.println("requestedFile == null");
			response.sendError(HttpServletResponse.SC_NOT_FOUND); // 404.
			return;
		}

		// Decode the file name (might contain spaces and on) and prepare file object.
		File file = new File(filePath, URLDecoder.decode(requestedFile, "UTF-8"));
		//	System.out.println("path: "+ filePath);
		//System.out.println("file name: "+file.getName());

		//gets the session
		HttpSession session = request.getSession(true);

		//defines the chart for the user
		JFreeChart myChart;
		//if the session timed out and chart is null- creates the chart again
		if((JFreeChart) session.getAttribute("myChartTree") == null){
			//System.out.println("chart is null");
			myChart= getChart();

		}else{
			//else- takes the chart from the session
			myChart = (JFreeChart) session.getAttribute("myChartTree");
		}


		//////creates the users chart in the requested file (=format)
		int width = 700;
		int height = 550;

		if(file.getName().equals("chartTree.jpg")){
			ChartFormats.saveChartAsJPEG(file, (JFreeChart) session.getAttribute("myChartTree")/*myChart*/, width, height);

		}else if(file.getName().equals("chartTree.pdf")){
			try {
				ChartFormats.saveChartToPDF((JFreeChart) session.getAttribute("myChartTree")/*myChart*/, file, width, height);
			} catch (Exception e) {
				e.printStackTrace();
			}
		}else if(file.getName().equals("chartTree.eps")){
			System.out.println("needed eps");
			ChartFormats.saveChartToEPS(file, (JFreeChart) session.getAttribute("myChartTree")/*myChart*/, width, height);

		}

		// Get content type by filename.
		String contentType = getServletContext().getMimeType(file.getName());


		// If content type is unknown, then set the default value.
		// For all content types, see: http://www.w3schools.com/media/media_mimeref.asp
		// To add new content types, add new mime-mapping entry in web.xml.
		if (contentType == null) {
			contentType = "image/jpeg";
		}

		//sets buffer size to the file length 
		DEFAULT_BUFFER_SIZE= (int) file.length();	

		// Init servlet response.
		response.reset();
		response.setBufferSize(DEFAULT_BUFFER_SIZE);
		response.setContentType(contentType);
		response.setHeader("Content-Length", String.valueOf(file.length()));
		response.setHeader("Content-Disposition", "attachment; filename=\"" + file.getName() + "\"");
		System.out.println("String.valueOf(file.length()): "+ String.valueOf(file.length()));

		// Prepare streams.
		BufferedInputStream input = null;
		BufferedOutputStream output = null;

		try {
			// Open streams.
			input = new BufferedInputStream(new FileInputStream(file), DEFAULT_BUFFER_SIZE);
			output = new BufferedOutputStream(response.getOutputStream(), DEFAULT_BUFFER_SIZE);

			// Write file contents to response.
			byte[] buffer = new byte[DEFAULT_BUFFER_SIZE];
			int length;
			while ((length = input.read(buffer)) > 0) {
				output.write(buffer, 0, length);
			}
		} finally {
			// Gently close streams.

			close(output);
			close(input);

		}

	}   

	// Helpers (can be refactored to public utility class) ----------------------------------------

	private static void close(Closeable resource) {
		if (resource != null) {
			try {
				resource.close();
			} catch (IOException e) {
				// Do your thing with the exception. Print it, log it or mail it.
				e.printStackTrace();
			}
		}
	}

	private JFreeChart getChart() {

		JFreeChart chart;

		//gets the results of data points for this id from DB
		myResults = db.getResults(id);
		myDataPointsTree = myResults.getTreeDist();

		//define new Series of points for this id
		final XYSeries s1 = new XYSeries(id);
		//insert all the points into this series
		for (int i = 0; i < myDataPointsTree.size(); i++) {
			s1.add(myDataPointsTree.get(i).getX(), myDataPointsTree.get(i).getY());
		}    

		//creates new XYSeriesCollection and adds the series for this id in the SeriesCollection
		final XYSeriesCollection dataset = new XYSeriesCollection();
		dataset.addSeries(s1);

		boolean legend = false;
		boolean tooltips = false;
		boolean urls = false; 

		chart = ChartFactory.createScatterPlot("Tree edit distance", "start window", "end window", dataset, PlotOrientation.VERTICAL , legend, tooltips, urls);

		chart.setBorderStroke(new BasicStroke(5.0f));
		XYPlot plot = (XYPlot) chart.getPlot();

		plot.setBackgroundPaint(new Color(0xffffe0));
		plot.setDomainGridlinesVisible(true);
		plot.setDomainGridlinePaint(Color.lightGray);
		plot.setRangeGridlinePaint(Color.lightGray);
		plot.getDomainAxis().setStandardTickUnits(NumberAxis.createIntegerTickUnits());
		plot.getRangeAxis().setStandardTickUnits(NumberAxis.createIntegerTickUnits());

		MyRenderer renderer = new MyRenderer(false, true, myDataPointsTree);
		plot.setRenderer(renderer);

		return chart;
	}

}



