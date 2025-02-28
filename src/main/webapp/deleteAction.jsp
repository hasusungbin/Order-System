<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter" %>
<%@ page import="java.util.List, java.util.Arrays, insertOrder.OrderDAO" %>
<% request.setCharacterEncoding( "UTF-8" ); %>
<%-- <jsp:useBean id="order" class="insertOrder.Order" scope="page" />
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
<jsp:useBean id="user" class="user.User" scope="page" />
<jsp:setProperty name="user" property="userID" /> --%>


<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>로지스톡</title>
</head>
<body>
	<%
    String[] orderNumbersArray = request.getParameterValues("orderNumbers");

    if (orderNumbersArray != null) {
        List<String> orderNumbers = Arrays.asList(orderNumbersArray);
        OrderDAO orderDAO = new OrderDAO();

        boolean success = orderDAO.deleteOrders(orderNumbers);

        if (success) {
%>
            <script>
                alert("선택한 주문이 삭제되었습니다.");
                window.location.href = "orderModify.jsp"; // 조회 페이지로 리디렉트
            </script>
<%
        } else {
%>
            <script>
                alert("삭제 중 오류가 발생했습니다.");
                history.back();
            </script>
<%
        }
    } else {
%>
        <script>
            alert("삭제할 주문을 선택해주세요.");
            history.back();
        </script>
<%
    }
%>
</body>
</html>