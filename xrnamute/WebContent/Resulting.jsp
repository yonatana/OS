<%@ page import="XRNA.DB"%>
<%@ page import="chart.ChartServlet"%>
<%@ page import="java.io.*"%>
<%@ page import="org.jfree.chart.JFreeChart"%>
<%@ page import="org.jfree.chart.ChartUtilities"%>
<%@ page session="true"%>

<%@page import="java.awt.RenderingHints"%>
<%@page import="org.jfree.chart.ChartFrame"%>
<%@page import=" org.jfree.chart.ChartPanel"%>
<%@page import=" org.jfree.chart.JFreeChart"%>
<%@page import=" org.jfree.chart.axis.NumberAxis"%>
<%@page import=" org.jfree.chart.plot.FastScatterPlot"%>
<%@page import=" org.jfree.ui.ApplicationFrame"%>
<%@page import=" org.jfree.ui.RefineryUtilities"%>

<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>test</title>
<script language="Javascript">
	function refreshpage() {
		document.forms.form1.submit();
	}
</script>
</head>
<body>
	<h1>JFreechart: Create Scatter Chart Dynamically</h1>
	SAFSDFASFa
	<%
		//taking id from yonatan
		int id = 0;
		String idString = "";
		//try & catch input check
		try {
			idString = request.getParameter("id");
			id = Integer.parseInt(idString);
		} catch (Exception e) {
			e.printStackTrace();
		}

	%>
	your id is:<%=idString%>
	<form id="form1" action="chart" method="post">
		<img src="chart?id=<%=id%>"  width="600" height="400" border="0" />
		
		<br> 
		<img src="chart2?id=<%=id%>" width="600" height="400" border="0" /> </br> 
		<input type="button" onclick="refreshpage()" value="Refresh" />
		
	</form>

</body>
</html>



<%
	//produce chart ....

	//store it the way you want : here in session

	//session.setAttribute( "chart", new ChartServlet().getChart() ); 

	//get ImageMap

	//populate the info
	//chart.createBufferedImage(640, 400, info); 
	//String imageMap = ChartUtilities.getImageMap( "map", info );
%>
<!--include the call for the image 
<img src="/ChartServlet" width="400" height="300" border="0" alt="" />
include the map -->
<!--<IMG src="chartviewer" usemap="#map">
-->