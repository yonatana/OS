<%@ page import="XRNA.DB"%>
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
<%@page import=" javax.swing.JFileChooser"%>
<%@page import="javax.swing.filechooser.FileNameExtensionFilter"%>

<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>

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

	DB db = new DB();
	//Check the result status in the DB
	int resultStatus = db.checkResults(id);
	
	//0-there are no results yet, returns relevant page
	if (resultStatus == 0) { 

	%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<link rel="stylesheet" href="styleR.css">
<title>Results Not Ready</title>

</head>
<body>

	<!-- <h1 class="t1">Results</h1> -->
	<h3 class="header">
		Sorry, we have not finished analyzing the data yet, please try later
		in this link: <br>
		<a href="result.jsp?id=<%=id%>">Results</a>
	</h3>

</body>
</html>


<%	//2- the job has failed, returns relevant page
	} else if (resultStatus == 2) {
		
	%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<link rel="stylesheet" href="styleR.css">
<title>Results Failed</title>

</head>
<body>

	<!-- <h1 class="t1">Results</h1> -->
	<h3 class="header">
		Sorry, an error occured, please enter the data again in this link:<br>
		<a href="index.jsp">Try Again</a>
	</h3>

</body>
</html>
<%
	}else{
	//else: resultStatus==1 and the results desplayed in this page
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<link rel="stylesheet" href="styleR.css">
<title>Results</title>

</head>
<body>
	<div class="logo">
		<img src="BANNER.jpg" width="1250" height="150">
	</div>
	<!-- <h1 class="t1">Results</h1> -->
	<h3 class="header">Results:</h3>
	<fieldset>
		<table
			style="width: 100%; text-align: center; margin: 0px; padding: 0px;">
			<tbody>

				<tr>
					<div align="center">
						<img src="chartBP?id=<%=id%>" width=70% border="0" /> <br> <br>
						<b>Download:</b>
						<form action="chartBP/chartBP.jpg?id=<%=id%>" method="post"
							style="display: inline">
							<button type="submit" />
							jpeg
							</button>
						</form>
						<form action="chartBP/chartBP.pdf?id=<%=id%>" method="post"
							style="display: inline">
							<button type="submit" />
							pdf
							</button>
						</form>
						<form action="chartBP/chartBP.eps?id=<%=id%>" method="post"
							style="display: inline">
							<button type="submit" />
							eps
							</button>
						</form>
					</div>

				</tr>
				<tr>
					<div align="center">
						<br> <br> <br> <img src="chartTree?id=<%=id%>"
							width=70% border="0" /><br> <br> <b>Download:</b>
						<form action="chartTree/chartTree.jpg?id=<%=id%>" method="post"
							style="display: inline">
							<button type="submit" />
							jpeg
							</button>
						</form>
						<form action="chartTree/chartTree.pdf?id=<%=id%>" method="post"
							style="display: inline">
							<button type="submit" />
							pdf
							</button>
						</form>
						<form action="chartTree/chartTree.eps?id=<%=id%>" method="post"
							style="display: inline">
							<button type="submit" />
							eps
							</button>
						</form>
					</div>
				</tr>


			</tbody>
		</table>
	</fieldset>
	<br>



</body>
</html>
<%} %>
<!--include the call for the image 
<img src="/ChartServlet" width="400" height="300" border="0" alt="" />
include the map -->
<!--<IMG src="chartviewer" usemap="#map">
-->