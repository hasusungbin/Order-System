<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="insertOrder.OrderDAO" %>
<%@ page import="arrival.ArrivalDAO" %>
<%@ page import="arrival.Arrival" %>
<%@ page import="java.io.PrintWriter" %>
<% request.setCharacterEncoding( "UTF-8" ); %>
<jsp:useBean id="order" class="insertOrder.Order" scope="page" />
<jsp:setProperty name="order" property="userName" />
<jsp:setProperty name="order" property="orderDate" />
<jsp:setProperty name="order" property="carWeight" />
<jsp:setProperty name="order" property="kindOfCar" />
<jsp:setProperty name="order" property="refNumber" />
<jsp:setProperty name="order" property="userPhoneNumber" />
<jsp:setProperty name="order" property="fixedCarNumber" />
<jsp:setProperty name="order" property="upDown" />
<jsp:setProperty name="order" property="item" />
<jsp:setProperty name="order" property="startDate" />
<jsp:setProperty name="order" property="endDate" />
<jsp:setProperty name="order" property="departureName" />
<jsp:setProperty name="order" property="arrivalName" />
<jsp:setProperty name="order" property="departureCities" />
<jsp:setProperty name="order" property="arrivalCities" />
<jsp:setProperty name="order" property="departureTown" />
<jsp:setProperty name="order" property="arrivalTown" />
<jsp:setProperty name="order" property="departureDetailedAddress" />
<jsp:setProperty name="order" property="arrivalDetailedAddress" />
<jsp:setProperty name="order" property="departureManager" />
<jsp:setProperty name="order" property="arrivalManager" />
<jsp:setProperty name="order" property="departureManagerPhoneNum" />
<jsp:setProperty name="order" property="arrivalManagerPhoneNum" />
<jsp:setProperty name="order" property="option1" />
<jsp:setProperty name="order" property="option2" />
<jsp:setProperty name="order" property="option3" />
<jsp:setProperty name="order" property="option4" />
<jsp:setProperty name="order" property="destinationAddress" />
<%-- <jsp:useBean id="user" class="user.User" scope="page" />
<jsp:setProperty name="user" property="userID" /> --%>


<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>로지스톡</title>
</head>
<body>
	<%
		String userID = null;
		if( session.getAttribute("userID" ) != null) {
			userID = (String) session.getAttribute("userID");
		}
 		if( userID == null ) {
			PrintWriter script = response.getWriter();
			script.println( "<script>" );
			script.println( "alert('로그인을 하세요.') ;" );
			script.println( "location.href = 'login.jsp'" );
			script.println( "</script>" );
		} else {
			if ( order.getUserName() == null || order.getCarWeight() == null || order.getKindOfCar() == null || order.getStartDate() == null || order.getEndDate() == null || order.getDepartureCities() == null || order.getArrivalCities() == null || order.getDepartureTown() == null || order.getArrivalTown() == null ) {
				PrintWriter script = response.getWriter();
				script.println( "<script>" );
				script.println( "alert('필수 입력사항 중 누락이 있습니다.') ;" );
				script.println( "history.back()" );
				script.println( "</script>" );
			} else {
				OrderDAO orderDAO = new OrderDAO();
				ArrivalDAO arrivalDAO = new ArrivalDAO();
				String type = request.getParameter("type");
				String arrivalName = request.getParameter("arrivalName");
				String arrivalCities = request.getParameter("arrivalCities");
				String arrivalTown = request.getParameter("arrivalTown");
				String arrivalDetailedAddress = request.getParameter("arrivalDetailedAddress");
				String arrivalManager = request.getParameter("arrivalManager");
				String arrivalManagerPhoneNum = request.getParameter("arrivalManagerPhoneNum");
				String etc = request.getParameter("etc");
				String userCompany = request.getParameter("userCompany");
				int orderNumber = Integer.parseInt(request.getParameter("orderNumber"));
				arrivalDAO.insertArrival(arrival);
				int result = orderDAO.writeOrder( userID, order.getKindOfCar(), order.getUserName(), order.getOrderDate(), order.getCarWeight(), order.getRefNumber(), order.getUserPhoneNumber(), order.getFixedCarNumber(), order.getUpDown(), order.getItem(), order.getEtc(), 
													order.getStartDate(), order.getEndDate(), order.getDepartureName(), order.getArrivalName(), order.getDepartureCities(), order.getArrivalCities(), order.getDepartureTown(), order.getArrivalTown(), 
													order.getDepartureDetailedAddress(), order.getArrivalDetailedAddress(), order.getDepartureManager(), order.getArrivalManager(), order.getDepartureManagerPhoneNum(), order.getArrivalManagerPhoneNum(),
													order.getOption1(), order.getOption2(), order.getOption3(), order.getOption4(), order.getDestinationAddress() );
				if( result == -1 ) {
					PrintWriter script = response.getWriter();
					script.println( "<script>" );
					script.println( "alert('오더 작성을 실패했습니다.');" );
					script.println( "history.back()" ); 
					script.println( "</script>" );
				} else if ( result == -2 ) {
					PrintWriter script = response.getWriter();
					script.println( "<script>" );
					script.println( "alert('오더 작성에 필요한 데이터가 빠져있습니다. 다시 작성해주세요.');" );
					script.println( "location.href = 'main.jsp'" );
					script.println( "</script>" );
				} else {
					PrintWriter script = response.getWriter();
					script.println( "<script>" );
					script.println( "alert('오더 작성을 완료했습니다.');" );
					script.println( "location.href = 'main.jsp'" );
					script.println( "</script>" );
				}
			}
		}
	%>
</body>
</html>