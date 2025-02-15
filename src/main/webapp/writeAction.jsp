<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="insertOrder.OrderDAO" %>
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
<jsp:setProperty name="order" property="etc" />

<jsp:useBean id="carInfo" class="carInfo.carInfo" scope="page" />
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
			if ( order.getUserName() == null || order.getCarWeight() == null || order.getKindOfCar() == null ) {
				PrintWriter script = response.getWriter();
				script.println( "<script>" );
				script.println( "alert('필수 입력사항 중 누락이 있습니다.') ;" );
				script.println( "history.back()" );
				script.println( "</script>" );
			} else {
				OrderDAO orderDAO = new OrderDAO();
				int result = orderDAO.write( order.getUserName(), order.getOrderDate(), order.getCarWeight(), order.getKindOfCar(), order.getRefNumber(), order.getUserPhoneNumber(), order.getFixedCarNumber(), order.getUpDown(), order.getItem(), order.getEtc() );
				if( result == -1 ) {
					PrintWriter script = response.getWriter();
					script.println( "<script>" );
					script.println( "alert('오더 작성을 실패했습니다.');" );
					script.println( "history.back()" ); 
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