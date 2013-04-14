
<%@page import="XRNA.DB" import="XRNA.SSHAgent"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="java.io.*, java.util.Random"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<link rel="stylesheet" href="styleR.css">
<title>RNAthermsw processing</title>
</head>
<body>
	<div class="logo">
		<img src="BANNER.jpg" width="1250" height="150">
	</div>
	<%
		//main application
		Random randomGenerator = new Random();
		String email = request.getParameter("email");
		String temp = request.getParameter("temp");
		String windowMin = request.getParameter("min");
		String windowMax = request.getParameter("max");
		String sequence = request.getParameter("str");
		int id = randomGenerator.nextInt(10);
		String linkMassage = "you can see and download your results here when they are done";
		String adress = "result.jsp";

		DB db = new DB();
		id = db.insertInput(email, windowMin, windowMax, temp, sequence);

		if (id == 0) {
			linkMassage = "we encountered a problem while uploading to the data base, please try again.";
			adress = "index.jsp";
		} else {//do the algorithm
			try {
				SSHAgent agent = new SSHAgent("clustrix1.cs.bgu.ac.il",
						"xrna2", "L.#Xhi27");
				agent.connect();
				//TODO use the respond from server from the return of the excecute
				agent.executeCommand("cd /home/studies/projects/xrna2/ ; qsub -v id="
						+ id + " runAlgo.sh");
			} catch (Exception e) {
				e.printStackTrace();
				linkMassage = "we encountered a problem while using te algorithm, please try again.";
				adress = "index.jsp";
			}
		}
	%>

	<%!public Boolean testInput(String input) {
		return input.matches("[acugtACUGT ]+");
	}%>
	<h2 class="t1">
		<br /> Thank you for using our web server! <br />
		<%
			out.println("<a href=" + adress + "?id=" + id + ">" + linkMassage
					+ "</a>");
		%>
	</h2>

	<br />
</html>