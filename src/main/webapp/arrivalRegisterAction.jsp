<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="arrival.ArrivalDAO" %>
<%@ page import="arrival.Arrival" %>
<%@ page import="departure.DepartureDAO" %>
<%@ page import="departure.Departure" %>
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
    /* String userID = null;
	if (session.getAttribute("userID") != null) {
		userID = (String) session.getAttribute("userID");
	} */
    UserDAO userDAO = new UserDAO();
    String userID = userDAO.getUserID(); 
    //String userCompany = userDAO.getUserCompany();
    String userCompany = (String) session.getAttribute("userCompany");

    if (userCompany == null) {
        PrintWriter script = response.getWriter();
        script.println("<script>");
        script.println("alert('로그인 정보가 없습니다. 다시 로그인하세요.');");
        script.println("location.href='login.jsp';");
        script.println("</script>");
        return;
    }

    // 입력 데이터 받기
    String type = request.getParameter("type");
    String arrivalName = request.getParameter("arrivalName");
    String arrivalCities = request.getParameter("arrivalCities");
    String arrivalManager = request.getParameter("arrivalManager");
    String arrivalTown = request.getParameter("arrivalTown");
    String arrivalManagerPhoneNum = request.getParameter("arrivalManagerPhoneNum");
    String arrivalDetailedAddress = request.getParameter("arrivalDetailedAddress");
    String etc = request.getParameter("etc");

    // Arrival 객체 생성 및 값 설정
    if( type.equals("출발지") ) {
    	Departure departure = new Departure();
    	departure.setDepartureName(arrivalName);
    	departure.setDepartureCities(arrivalCities);
    	departure.setDepartureManager(arrivalManager);
    	departure.setDepartureTown(arrivalTown);
    	departure.setDepartureManagerPhoneNum(arrivalManagerPhoneNum);
    	departure.setDepartureDetailedAddress(arrivalDetailedAddress);
    	departure.setEtc(etc);
    	departure.setUserCompany(userCompany);
    	
    	DepartureDAO departureDAO = new DepartureDAO();
    	departureDAO.insertDeparture(departure);
    	
    	PrintWriter script = response.getWriter();
        script.println("<script>");
        script.println("alert('출발지가 저장되었습니다.');");
        script.println("location.href='arrivalModify.jsp';");
        script.println("</script>");
        
    } else if( type.equals("도착지") ) {
    	Arrival arrival = new Arrival();
        arrival.setArrivalName(arrivalName);
        arrival.setArrivalCities(arrivalCities);
        arrival.setArrivalManager(arrivalManager);
        arrival.setArrivalTown(arrivalTown);
        arrival.setArrivalManagerPhoneNum(arrivalManagerPhoneNum);
        arrival.setArrivalDetailedAddress(arrivalDetailedAddress);
        arrival.setEtc(etc);
        arrival.setUserCompany(userCompany); // 세션에서 가져온 userCompany 저장 

        // DAO 생성 및 저장
        ArrivalDAO arrivalDAO = new ArrivalDAO(); 
        arrivalDAO.insertArrival(arrival);

        PrintWriter script = response.getWriter();
        script.println("<script>");
        script.println("alert('도착지가 저장되었습니다.');");
        script.println("location.href='arrivalModify.jsp';");
        script.println("</script>");
    }
%>
</body>
</html>