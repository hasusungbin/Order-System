<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="carInfo.CarInfoDAO" %>
<%@ page import="carInfo.CarInfo" %>
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
    request.setCharacterEncoding("UTF-8");

    // 세션에서 userCompany 가져오기
    String userID = null;
	if (session.getAttribute("userID") != null) {
		userID = (String) session.getAttribute("userID");
	}
	
    UserDAO userDAO = new UserDAO();
    String userType = userDAO.getUserTypeByID( userID );
    String userCompany1 = (String) session.getAttribute("userCompany");
    
    
    if (userCompany1 == null) {
        PrintWriter script = response.getWriter();
        script.println("<script>");
        script.println("alert('로그인 정보가 없습니다. 다시 로그인하세요.');");
        script.println("location.href='login.jsp';");
        script.println("</script>");
        return;
    }

    // 입력 데이터 받기
    String carNumber = request.getParameter("carNumber");
    String driverName = request.getParameter("driverName");
    String carWeight = request.getParameter("carWeight");
    String driverPhoneNumber = request.getParameter("driverPhoneNumber");
    String kindOfCar = request.getParameter("kindOfCar");
    String userCompany2 = request.getParameter("userCompany");

    // CarInfo 객체 생성 및 값 설정
    if( carNumber != null && userType.equals("admin") ) {
    	CarInfo carInfo = new CarInfo();
    	carInfo.setCarNumber(carNumber);
    	carInfo.setDriverName(driverName);
    	carInfo.setCarWeight(carWeight);
    	carInfo.setDriverPhoneNumber(driverPhoneNumber);
    	carInfo.setKindOfCar(kindOfCar);
    	carInfo.setUserCompany(userCompany2);
    	
    	CarInfoDAO carInfoDAO = new CarInfoDAO();
    	int result = carInfoDAO.insertCarInfo(carInfo);
    	
    	if( result > 0 ) {
	    	PrintWriter script = response.getWriter();
	        script.println("<script>");
	        script.println("alert('고정차량이 저장되었습니다.');");
	        script.println("location.href='carInfoModify.jsp';");
	        script.println("</script>");
    	} else if( result <= 0 ) {
    		PrintWriter script = response.getWriter();
	        script.println("<script>");
	        script.println("alert('고정차량 저장을 실패했습니다.');");
	        script.println("location.href='carInfoModify.jsp';");
	        script.println("</script>");
    	}
    } else if( carNumber != null && userType != "admin" ) {
    	
    	CarInfo carInfo = new CarInfo();
    	carInfo.setCarNumber(carNumber);
    	carInfo.setDriverName(driverName);
    	carInfo.setCarWeight(carWeight);
    	carInfo.setDriverPhoneNumber(driverPhoneNumber);
    	carInfo.setKindOfCar(kindOfCar);
    	carInfo.setUserCompany(userCompany1);
    	
    	CarInfoDAO carInfoDAO = new CarInfoDAO();
    	int result = carInfoDAO.insertCarInfo(carInfo);
    	
    	if( result > 0 ) {
	    	PrintWriter script = response.getWriter();
	        script.println("<script>");
	        script.println("alert('고정차량이 저장되었습니다.');");
	        script.println("location.href='carInfoModify.jsp';");
	        script.println("</script>");
    	} else if( result <= 0 ) {
    		PrintWriter script = response.getWriter();
	        script.println("<script>");
	        script.println("alert('고정차량 저장을 실패했습니다.');");
	        script.println("location.href='carInfoModify.jsp';");
	        script.println("</script>");
    	}
    } else {
    	PrintWriter script = response.getWriter();
        script.println("<script>");
        script.println("alert('필수값들을 입력해주세요.');");
        script.println("location.href='carInfoModify.jsp';");
        script.println("</script>");
    }
%>
</body>
</html>