<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="arrival.ArrivalDAO" %>
<%@ page import="arrival.Arrival" %>
<%@ page import="org.apache.ibatis.session.SqlSessionFactory" %>
<%@ page import="java.io.PrintWriter" %>
<%@ page import="user.UserDAO" %>
<%@ page import="user.User" %>
<% request.setCharacterEncoding( "UTF-8" ); %>

<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>로지스톡</title>
</head>
<body>
	<%
	    String userID = null;
		if (session.getAttribute("userID") != null) {
			userID = (String) session.getAttribute("userID");
		}
	
	    String arrivalName = request.getParameter("arrivalName");
	    String arrivalCities = request.getParameter("arrivalCities");
	    String arrivalTown = request.getParameter("arrivalTown");
	    String arrivalDetailedAddress = request.getParameter("arrivalDetailedAddress");
	    String arrivalManager = request.getParameter("arrivalManager");
	    String arrivalManagerPhoneNum = request.getParameter("arrivalManagerPhoneNum");
	
	    Arrival arrival = new Arrival();
	    arrival.setArrivalName(arrivalName);
	    arrival.setArrivalCities(arrivalCities);
	    arrival.setArrivalTown(arrivalTown);
	    arrival.setArrivalDetailedAddress(arrivalDetailedAddress);
	    arrival.setArrivalManager(arrivalManager);
	    arrival.setArrivalManagerPhoneNum(arrivalManagerPhoneNum);
	
	    ArrivalDAO arrivalDAO = new ArrivalDAO();
	    int result = arrivalDAO.insertOrderArrival(arrival);
	
	    if (result > 0) {
	        out.print("SUCCESS");
	    } else if (result == 0) {
	        out.print("DUPLICATE");
	    } else {
	        out.print("ERROR");
	    }
	%>
</body>
</html>