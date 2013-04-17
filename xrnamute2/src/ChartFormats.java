

import java.awt.Graphics2D;
import java.awt.geom.Rectangle2D;
import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.io.FileWriter;
import java.io.IOException;
import java.io.Writer;
import java.util.ArrayList;

import org.jfree.chart.ChartUtilities;
import org.jfree.chart.JFreeChart;
import org.jibble.epsgraphics.EpsGraphics2D;

import XRNA.dataPoint;
import XRNA.resultData;

import com.lowagie.text.Rectangle;
import com.lowagie.text.pdf.DefaultFontMapper;
import com.lowagie.text.pdf.PdfContentByte;
import com.lowagie.text.pdf.PdfTemplate;
import com.lowagie.text.pdf.PdfWriter;

public class ChartFormats {
	
	//private constructor
	private ChartFormats() {}
	
	/**
	* Save chart as JPEG file.
	*
	* @param chart JFreeChart to save.
	* @param file the file to save chart in.
	* @param width Width of chart graphic.
	* @param height Height of chart graphic.
	* @throws Exception if failed.
	*/
	public static void saveChartAsJPEG(java.io.File file, JFreeChart chart, int width,int height) throws java.io.IOException{
		ChartUtilities.saveChartAsJPEG(file,chart,width,height);

	}
	
	/**
	* Save chart as PDF file. Requires iText library.
	*
	* @param chart JFreeChart to save.
	* @param file the file to save chart in.
	* @param width Width of chart graphic.
	* @param height Height of chart graphic.
	* @throws Exception if failed.
	* @see <a href="http://www.lowagie.com/iText">iText</a>
	*/
	public static void saveChartToPDF(JFreeChart chart, File file, int width, int height) throws Exception {
	    if (chart != null) {
	        BufferedOutputStream out = null;
	        try {
	        	
	        	out = new BufferedOutputStream(new FileOutputStream(file));
	        	
	            //convert chart to PDF with iText:
	            Rectangle pagesize = new Rectangle(width, height);
	            com.lowagie.text.Document document = new com.lowagie.text.Document(pagesize, 50, 50, 50, 50);
	            try {
	                PdfWriter writer = PdfWriter.getInstance(document, out);
	                document.addAuthor("JFreeChart");
	                document.open();
	       
	                PdfContentByte cb = writer.getDirectContent();
	                PdfTemplate tp = cb.createTemplate(width, height);
	                Graphics2D g2 = tp.createGraphics(width, height, new DefaultFontMapper());
	       
	                Rectangle2D r2D = new Rectangle2D.Double(0, 0, width, height);
	                chart.draw(g2, r2D, null);
	                g2.dispose();
	                cb.addTemplate(tp, 0, 0);
	            } finally {
	                document.close();
	            }
	        } finally {
	            if (out != null) {
	                out.close();
	            }
	        }
	    }//else: input values not available 
	}//saveChartToPDF()
	
	/**
	* Save chart as EPS file.
	*
	* @param chart JFreeChart to save.
	* @param file the file to save chart in.
	* @param width Width of chart graphic.
	* @param height Height of chart graphic.
	* @throws Exception if failed.
	*/
	
	public static void saveChartToEPS(File file, JFreeChart chart, int width, int height) throws IOException {
        
		Graphics2D g = new EpsGraphics2D();
		
		Rectangle2D rect = new Rectangle2D.Double((double)0, (double)0,(double)width,(double)height);
		
        chart.draw(g, rect);
        
        Writer out=new FileWriter(file);
        
        out.write(g.toString());
        
        out.close();
    }
    
    
}
