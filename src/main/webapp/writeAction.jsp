<%@page import="org.apache.poi.util.SystemOutLogger"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="org.apache.ibatis.session.SqlSession" %>
<%@ page import="insertOrder.OrderDAO" %>
<%@ page import="departure.DepartureDAO" %>
<%@ page import="departure.Departure" %>
<%@ page import="arrival.ArrivalDAO" %>
<%@ page import="arrival.Arrival" %>
<%@ page import="carInfo.CarInfoDAO" %>
<%@ page import="carInfo.CarInfo" %>
<%@ page import="java.io.PrintWriter" %>
<%@ page import="insertOrder.MybatisUtil" %>

<%
	request.setCharacterEncoding("UTF-8");
	response.setContentType("text/html; charset=UTF-8");
	
	String userID = (String) session.getAttribute("userID");
	

	String userName = request.getParameter("userName");
	String orderDate = request.getParameter("orderDate");
	String carWeight = request.getParameter("carWeight");
	String kindOfCar = request.getParameter("kindOfCar");
	String refNumber = request.getParameter("refNumber");
	String userPhoneNumber = request.getParameter("userPhoneNumber");
	String fixedCarNumber = request.getParameter("fixedCarNumber");
	String upDown = request.getParameter("upDown");
	String item = request.getParameter("item");
	String etc = request.getParameter("etc");
	String startDate = request.getParameter("startDate");
	String endDate = request.getParameter("endDate");
	String departureName = request.getParameter("departureName");
	String arrivalName = request.getParameter("arrivalName");
	String departureCities = request.getParameter("departureCities");
	String arrivalCities = request.getParameter("arrivalCities");
	String departureTown = request.getParameter("departureTown");
	String arrivalTown = request.getParameter("arrivalTown");
	String departureDetailedAddress = request.getParameter("departureDetailedAddress");
	String arrivalDetailedAddress = request.getParameter("arrivalDetailedAddress");
	String departureManager = request.getParameter("departureManager");
	String arrivalManager = request.getParameter("arrivalManager");
	String departureManagerPhoneNum = request.getParameter("departureManagerPhoneNum");
	String arrivalManagerPhoneNum = request.getParameter("arrivalManagerPhoneNum");
	String option1 = request.getParameter("option1");
	String option2 = request.getParameter("option2");
	String option3 = request.getParameter("option3");
	String option4 = request.getParameter("option4");
	String destinationAddress = request.getParameter("destinationAddress");
	String userCompany = request.getParameter("userCompany");
	String standard = request.getParameter("standard");
	String weight = request.getParameter("weight");
	
	try (SqlSession sqlSession = MybatisUtil.getSession()) {
	    OrderDAO orderDAO = new OrderDAO(sqlSession);
		CarInfoDAO carInfoDAO = new CarInfoDAO();
		if( !fixedCarNumber.equals("") ) {
			CarInfo carInfo = carInfoDAO.getCarInfoByCarNumber(fixedCarNumber);
		    // === Order 처리 ===
			    int result1 = orderDAO.writeOrder(
			        userID, kindOfCar, userName, orderDate, carWeight, refNumber, userPhoneNumber,
			        fixedCarNumber != null ? fixedCarNumber : carInfo.getCarNumber(), upDown, item, etc, startDate, endDate, departureName, arrivalName,
			        departureCities, arrivalCities, departureTown, arrivalTown, departureDetailedAddress,
			        arrivalDetailedAddress, departureManager, arrivalManager, departureManagerPhoneNum,
			        arrivalManagerPhoneNum, carInfo.getDriverName(), carInfo.getDriverPhoneNumber(), option1, option2, option3, option4, destinationAddress,
			        userCompany, standard, weight
			    ); 
			    if (result1 <= 0) {
			        sqlSession.rollback(); // ✅ 실패 시 rollback
			        throw new Exception("오더 작성 실패");
			}
		} else if( fixedCarNumber.equals("") ) {
	    	int result2 = orderDAO.writeOrder(
			        userID, kindOfCar, userName, orderDate, carWeight, refNumber, userPhoneNumber,
			        upDown, item, etc, startDate, endDate, departureName, arrivalName,
			        departureCities, arrivalCities, departureTown, arrivalTown, departureDetailedAddress,
			        arrivalDetailedAddress, departureManager, arrivalManager, departureManagerPhoneNum,
			        arrivalManagerPhoneNum, option1, option2, option3, option4, destinationAddress, userCompany,
			        standard, weight
			    );
			    if (result2 <= 0) {
			        sqlSession.rollback(); // ✅ 실패 시 rollback
			        throw new Exception("오더 작성 실패");
			    }
	    }
	
	
	    // === Arrival 처리 ===
	    ArrivalDAO arrivalDAO = new ArrivalDAO(sqlSession);
        Arrival arrival = new Arrival();
        arrival.setArrivalName(arrivalName);
        arrival.setArrivalCities(arrivalCities);
        arrival.setArrivalTown(arrivalTown);
        arrival.setArrivalDetailedAddress(arrivalDetailedAddress);
        arrival.setArrivalManager(arrivalManager);
        arrival.setArrivalManagerPhoneNum(arrivalManagerPhoneNum);
        arrival.setUserCompany(userCompany);

        if (arrivalDAO.insertArrival(arrival) <= 0) {
            sqlSession.rollback(); // ✅ 실패 시 rollback
            throw new Exception("Arrival 등록 실패");
        }
	
	    // === Departure 처리 ===
	    DepartureDAO departureDAO = new DepartureDAO(sqlSession);
        Departure departure = new Departure();
        departure.setDepartureName(departureName);
        departure.setDepartureCities(departureCities);
        departure.setDepartureTown(departureTown);
        departure.setDepartureDetailedAddress(departureDetailedAddress);
        departure.setDepartureManager(departureManager);
        departure.setDepartureManagerPhoneNum(departureManagerPhoneNum);
        departure.setUserCompany(userCompany);

        if (departureDAO.insertDeparture(departure) <= 0) {
            sqlSession.rollback(); // ✅ 실패 시 rollback
            throw new Exception("Departure 등록 실패");
        }
	
	    // ✅ 모든 작업 성공 시 커밋
	    sqlSession.commit();
	
	    // ✅ 성공 시 alert 후 main.jsp로 이동
	    out.println("<script>");
	    out.println("alert('오더 작성을 완료했습니다.');");
	    out.println("location.href = 'main.jsp';");
	    out.println("</script>");
	
	} catch (Exception e) {
	    e.printStackTrace();
	
	    // ✅ 실패 시 alert 후 이전 페이지로 이동
	    out.println("<script>");
	    out.println("alert('오더 작성에 실패했습니다.');");
	    out.println("history.back();");
	    out.println("</script>");
	}
%>