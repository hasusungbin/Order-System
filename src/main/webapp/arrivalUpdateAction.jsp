<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="arrival.ArrivalDAO" %>
<%@ page import="java.io.PrintWriter" %>
<% request.setCharacterEncoding( "UTF-8" ); %>
<jsp:useBean id="arrival" class="arrival.Arrival" scope="page" />
<jsp:setProperty name="arrival" property="arrivalName" />
<jsp:setProperty name="arrival" property="arrivalCities" />
<jsp:setProperty name="arrival" property="arrivalManager" />
<jsp:setProperty name="arrival" property="arrivalTown" />
<jsp:setProperty name="arrival" property="arrivalManagerPhoneNum" />
<jsp:setProperty name="arrival" property="arrivalDetailedAddress" />
<jsp:setProperty name="arrival" property="etc" />
<jsp:setProperty name="arrival" property="regDate" />


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
			if ( arrival.getArrivalName() == null || arrival.getArrivalCities() == null || arrival.getArrivalManager() == null || arrival.getArrivalTown() == null || arrival.getArrivalManagerPhoneNum() == null ||
				 arrival.getArrivalDetailedAddress() == null ) {
				PrintWriter script = response.getWriter();
				script.println( "<script>" );
				script.println( "alert('필수 입력사항 중 누락이 있습니다.') ;" );
				script.println( "history.back()" );
				script.println( "</script>" );
				System.out.println(arrival.getArrivalName());
				System.out.println(arrival.getArrivalCities());
				System.out.println(arrival.getArrivalManager());
				System.out.println(arrival.getArrivalTown());
				System.out.println(arrival.getArrivalManagerPhoneNum());
				System.out.println(arrival.getArrivalDetailedAddress());
			} else {
				ArrivalDAO arrivalDAO = new ArrivalDAO();
				int result = arrivalDAO.updateArrival( arrival.getArrivalName(), arrival.getArrivalCities(), arrival.getArrivalTown(), arrival.getArrivalDetailedAddress(), arrival.getArrivalManager(), arrival.getArrivalManagerPhoneNum(), arrival.getEtc() );
				if( result == -1 ) {
					PrintWriter script = response.getWriter();
					script.println( "<script>" );
					script.println( "alert('출/도착지 수정을 실패했습니다.');" );
					script.println( "history.back()" ); 
					script.println( "</script>" );
				} else if ( result == -2 ) {
					PrintWriter script = response.getWriter();
					script.println( "<script>" );
					script.println( "alert('출/도착지 수정 및 작성에 필요한 데이터가 빠져있습니다. 다시 작성해주세요.');" );
					script.println( "location.href = 'arrivalUpdate.jsp'" );
					script.println( "</script>" );
				} else {
					PrintWriter script = response.getWriter();
					script.println( "<script>" );
					script.println( "alert('출/도착지 수정을 완료했습니다.');" );
					script.println( "location.href = 'arrivalModify.jsp'" );
					script.println( "</script>" );
				}
			}
		}
	%>
</body>
</html>