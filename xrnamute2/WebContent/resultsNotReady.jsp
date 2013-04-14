<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>

<%
	//taking id from result.jsp
	String idString = request.getParameter("id");
	int id = Integer.parseInt(idString);
 
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
	<h3 class="header">Sorry, we have not finished analyzing the data
		yet, please try later in this link: <br><a href="result.jsp?id=<%=id%>">Results</a></h3>
	
</body>
</html>