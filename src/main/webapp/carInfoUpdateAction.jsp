<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="carInfo.CarInfoDAO" %>
<%@ page import="user.UserDAO" %>
<%@ page import="java.io.PrintWriter" %>
<% request.setCharacterEncoding( "UTF-8" ); %>
<jsp:useBean id="carInfo" class="carInfo.CarInfo" scope="page" />
<jsp:setProperty name="carInfo" property="carNumber" />
<jsp:setProperty name="carInfo" property="driverName" />
<jsp:setProperty name="carInfo" property="carWeight" />
<jsp:setProperty name="carInfo" property="driverPhoneNumber" />
<jsp:setProperty name="carInfo" property="kindOfCar" />
<jsp:setProperty name="carInfo" property="userCompany" />


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
		UserDAO userDAO = new UserDAO();
		String userType = userDAO.getUserTypeByID( userID );
		String userCompany = userDAO.getUserCompany( userID );
		
 		if( userID == null ) {
			PrintWriter script = response.getWriter();
			script.println( "<script>" );
			script.println( "alert('로그인을 하세요.') ;" );
			script.println( "location.href = 'login.jsp'" );
			script.println( "</script>" );
		} else {
			if ( carInfo.getCarNumber() == null ) {
				PrintWriter script = response.getWriter();
				script.println( "<script>" );
				script.println( "alert('필수 입력사항 중 누락이 있습니다.') ;" );
				script.println( "history.back()" );
				script.println( "</script>" );
			} else {
				CarInfoDAO carInfoDAO = new CarInfoDAO();
				
				int result = carInfoDAO.updateCarInfo( carInfo.getCarNumber(), carInfo.getDriverName(), carInfo.getCarWeight(), carInfo.getDriverPhoneNumber(), carInfo.getKindOfCar(), userType.equals("admin") ? carInfo.getUserCompany() : userCompany );
				if( result == -1 ) { 
					PrintWriter script = response.getWriter();
					script.println( "<script>" );
					script.println( "alert('고정차량 수정을 실패했습니다.');" );
					script.println( "history.back()" ); 
					script.println( "</script>" );
				} else if ( result == -2 ) {
					PrintWriter script = response.getWriter();
					script.println( "<script>" );
					script.println( "alert('고정차량 수정 및 작성에 필요한 데이터가 빠져있습니다. 다시 작성해주세요.');" );
					script.println( "location.href = 'carInfoUpdate.jsp'" );
					script.println( "</script>" );
				} else {
					PrintWriter script = response.getWriter();
					script.println( "<script>" );
					script.println( "alert('고정차량 수정을 완료했습니다.');" );
					script.println( "location.href = 'carInfoModify.jsp'" );
					script.println( "</script>" );
				}
			}
		}
	%>
</body>
</html>