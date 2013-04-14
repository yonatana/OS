<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="java.io.*"%>
<%
	String str = "Please insert an RNA sequence or upload a txt file.";
	//handle a File upload
	//to get the content type information from JSP Request Header
	String contentType = request.getContentType();
	//here we are checking the content type is not equal to Null and as well as the passed data from mulitpart/form-data is greater than or equal to 0
	//System.out.println("hell");
	if ((contentType != null)
			&& (contentType.indexOf("multipart/form-data") >= 0)) {
		//System.out.println("if");
		DataInputStream in = new DataInputStream(
				request.getInputStream());
		//we are taking the length of Content type data
		int formDataLength = request.getContentLength();
		byte dataBytes[] = new byte[formDataLength];
		int byteRead = 0;
		int totalBytesRead = 0;
		//this loop converting the uploaded file into byte code
		while (totalBytesRead < formDataLength) {
			byteRead = in.read(dataBytes, totalBytesRead,
					formDataLength);
			totalBytesRead += byteRead;
		}

		String file = new String(dataBytes);

		//for saving the file name
		String saveFile = file
				.substring(file.indexOf("filename=\"") + 10);
		saveFile = saveFile.substring(0, saveFile.indexOf("\n"));
		saveFile = saveFile.substring(saveFile.lastIndexOf("\\") + 1,
				saveFile.indexOf("\""));
		int lastIndex = contentType.lastIndexOf("=");
		String boundary = contentType.substring(lastIndex + 1,
				contentType.length());
		int pos;

		pos = file.indexOf("filename=\"");
		pos = file.indexOf("\n", pos) + 1;
		pos = file.indexOf("\n", pos) + 1;
		pos = file.indexOf("\n", pos) + 1;
		int boundaryLocation = file.indexOf(boundary, pos) - 4;
		int startPos = ((file.substring(0, pos)).getBytes()).length;
		int endPos = ((file.substring(0, boundaryLocation)).getBytes()).length;
		str = file.substring(startPos, endPos);
	}
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<link rel="stylesheet" href="styleI.css">
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>RNAthermsw webserver</title>

</head>


	
	
	<!-- <table
		style="width: 100%; text-align: right; margin: 0px; padding: 0px; line-height: 0.8em">
		<tbody>
			<tr>
				<td>[<a href="http://www.youtube.com/watch?v=eTXV4AdZ-dE">Home</a>|<a
					href="http://www.youtube.com/watch?v=QkNrSpqUr-E" target="_blank">Help</a>]
				</td>
			</tr>
		</tbody>
	</table> -->
	
	 <div class="logo">
		<img src="BANNER.jpg" width="1250" height="150">
	</div> 
	
	<!-- CONTENT_S -->
	<!-- ENCTYPE="multipart/form-data" (add to the form to pass file) -->
	<form name="form" action="proccese_input.jsp"
		onsubmit="return validate_form(this)" method="post">

		<!-- <h1 class="t1">RNA thermo switch WebServer</h1> -->

		<a1> <font color="navy"><p>
				The RNAthermsw webserver is for detecting RNA thermoswitches using a
				sliding window. <br> The structural changes will be measured
				using the tree edit distance and base-pair distance methods.<br>
				<br> Please enter your RNA sequence and the necessary
				parameters:<br> -&emsp;The sequence must only include the
				characters A,U,G,C,a,u,g,c (case insensitive)<br> -&emsp;The
				temperature and sliding window size parameters must be integers in
				the specified range<br> <br> A varying-size sliding window
				will be used with the given min-max range, and the input temperature
				will be used to extrapolate the sequence structure compared with the
				default (37 C).<br> After input is given and the "submit"
				button is pressed, a link will be shown to display the results when
				they are ready.<br> Please note that it may take a while for
				the algorithm to compute the necessary data, especially for long
				sequences with large window ranges.<br> If an email was given,
				the results link will be sent to the address specified.
			</p></font></a1>
		<h2>
			<font color="navy"><p>Insert your RNA sequence here:</p></font>
		</h2>
		<textarea input="text" name="str" rows="10" cols="100"><%=str%> </textarea>
		<br />
		<blockquote>
			&nbsp;
			<h3>Algorithm parameters</h3>
			<table>
				<tbody>
					<tr>
						<td>
							<fieldset>
								<legend>Sliding window option</legend>
								<table>
									<tbody>
										<tr>
											<td>Minimum Size of windows:</td>
											<td width="20"></td>
											<td><input type="text" name="min" id="min" size="4"></td>
										</tr>
										<tr>
											<td>Maximum Size of windows:</td>
											<td width="20"></td>
											<td><input type="text" name="max" id="max" size="4"></td>
										</tr>
										<td>temperature:</td>
										<td width="20"></td>
										<td><input type="text" name="temp" id="temp" size="4"
											value="38"></td>
										</tr>
										<tr>
											<td>The reference value is 37 degrees.</td>
										</tr>
									</tbody>
								</table>
								<br>
							</fieldset>
						</td>
						<td width="10"></td>
					</tr>
				</tbody>
			</table>
			<p>Results:</p>
			<input type="radio" name="useMail" value="1" checked="">
			Without email: <br> <br> <input type="radio" name="useMail"
				value="2"> Send by email:<input type="text" name="email"
				size="25" value="">

			<p>
				<input type="submit" value="Submit Form">
			</p>

		</blockquote>
		<script type="text/javascript">
			init(this);
		</script>
	</form>
	<FORM ENCTYPE="multipart/form-data" ACTION="index.jsp"
		onsubmit="return validFile(this)" METHOD=POST>
		<br>
		<tr>
			<td>Choose the file To Upload (optional):</td>
			<td><INPUT NAME="f1" TYPE="file" size="20"></td>
		</tr>
		<INPUT TYPE="submit" VALUE="Upload File">
		<br>
		<td>It might take a few minutes (if the sequence is very long):</td>
		</p>
		</td>
		</tr>

	</FORM>

	<font size="2"> Created by Alexander Churkin, Yonatan Alexander,
		Anna Kuzin, Marina Traisler, Yariv Tzur.<br /> For assistance please
		contact Danny Barash at <a
		href="mailto:dbarash@cs.bgu.ac.il?subject=RNA Microswitch Project">dbarash@cs.bgu.ac.il</a>.
		<font /> <!-- 
            <div id="footer">
		<div id="footerleft">&nbsp;</div>
		<div id="footerright">&nbsp;</div>
		<div id="footermain">&nbsp;</div>
		<div class="clear"><a href="http://www.tbi.univie.ac.at/RNA/" target="_blank">
	     Vienna RNA</a> | <a href="http://www.cs.bgu.ac.il/" target="_blank">Ben Guryon University</a> |
	     <a href="mailto:dbarash@cs.bgu.ac.il?subject=RNA Microswitch Project">dbarash@cs.bgu.ac.il</a></div>	
	</div> --> <br /> <!-- onsubmit="return validate_form(this)" -->
</body>

<script type="text/javascript">
	
	function validate_form(thisform) {

		var str = document.form.str.value;
		var min = document.form.min.value;
		var max = document.form.max.value;
		var temp = document.form.temp.value;
		var len = str.length;
		//var file = document.form.file.value;

		if (valid_str(str) == false || valid_temp(temp) == false
				|| valid_win(min, max, len) == false) {
			return false;
		} else {
			return true;
		}

	}
	function valid_str(field) {
		//var alphaExp = /^[A C U T G a c u t g ' ' \n \t]+$/;
		var alphaExp = /^[ACUTGacutg]+$/;

		if (field == null || field == "" || field == ' ') {

			alert("Please insert an RNA sequence.");
			return false;
		} else {
			if (field.match(alphaExp)) {
				return true;
			} else {
				alert("The rna seq is not valid , please re-enter.");
				return false;
			}
		}
	}

	function valid_temp(field) {
		if (field == null || field == "" || field == ' ') {
			alert("Please insert a temperature betwen 32 and 42.");
			return false;
		} else if (!isNaN(field)) {//its a float number
			var num = parseFloat(field);
			if (!(32 <= num && num <= 42)) {
				alert("The temperture is not between 32 and 42 , please re-enter.");
				return false;
			} else {
				return true;
			}
		} else {
			alert("The temperture is not valid , please re-enter.");
			return false;
		}
	}

	function valid_win(min, max, len) {
		//alert("validWin:"+ min+" "+ max+ " "+" "+ len);

		if (min == null | max == null | min == "" | max == "") {
			alert("please enter sliding window parameters.");
			return false;
		} else if (isNaN(min)) {
			alert("The minimum window size is not valid , please re-enter.");
			return false;
		} else if (isNaN(max)) {
			alert("The maxinum window size is not valid , please re-enter.");
			return false;
		} else if (parseFloat(min) >= parseFloat(max)) {
			alert("The maxinum window size should be greater the the minimum, please re-enter.");
			return false;
		} else if (parseFloat(max) >= len) {
			alert("The maxinum window size should not be greater the sequence length, please re-enter.");
			return false;
		} else
			return true;
	}
</script>
</html>
