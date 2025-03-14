<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="departure.DepartureDAO" %>
<%@ page import="java.io.PrintWriter" %>
<% request.setCharacterEncoding( "UTF-8" ); %>
<jsp:useBean id="departure" class="departure.Departure" scope="page" />
<jsp:setProperty name="departure" property="departureID" />
<jsp:setProperty name="departure" property="departureName" />
<jsp:setProperty name="departure" property="departureCities" />
<jsp:setProperty name="departure" property="departureManager" />
<jsp:setProperty name="departure" property="departureTown" />
<jsp:setProperty name="departure" property="departureManagerPhoneNum" />
<jsp:setProperty name="departure" property="departureDetailedAddress" />
<jsp:setProperty name="departure" property="etc" />
<jsp:setProperty name="departure" property="regDate" />


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
			if ( departure.getDepartureName() == null || departure.getDepartureCities() == null || departure.getDepartureManager() == null || departure.getDepartureTown() == null ) {
				PrintWriter script = response.getWriter();
				script.println( "<script>" );
				script.println( "alert('필수 입력사항 중 누락이 있습니다.') ;" );
				script.println( "history.back()" );
				script.println( "</script>" );
			} else {
				DepartureDAO departureDAO = new DepartureDAO();
				int result = departureDAO.updateDeparture( departure.getDepartureID(), departure.getDepartureName(), departure.getDepartureCities(), departure.getDepartureTown(), departure.getDepartureDetailedAddress(), departure.getDepartureManager(), departure.getDepartureManagerPhoneNum(), departure.getEtc() );
				if( result == -1 ) {
					PrintWriter script = response.getWriter();
					script.println( "<script>" );
					script.println( "alert('출발지 수정을 실패했습니다.');" );
					script.println( "history.back()" ); 
					script.println( "</script>" );
				} else if ( result == -2 ) {
					PrintWriter script = response.getWriter();
					script.println( "<script>" );
					script.println( "alert('출발지 수정 및 작성에 필요한 데이터가 빠져있습니다. 다시 작성해주세요.');" );
					script.println( "location.href = 'departureUpdate.jsp'" );
					script.println( "</script>" );
				} else {
					PrintWriter script = response.getWriter();
					script.println( "<script>" );
					script.println( "alert('출발지 수정을 완료했습니다.');" );
					script.println( "location.href = 'arrivalModify.jsp'" );
					script.println( "</script>" );
				}
			}
		}
	%>
</body>
</html>