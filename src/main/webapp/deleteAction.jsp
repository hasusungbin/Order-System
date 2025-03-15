<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter" %>
<%@ page import="java.util.List, java.util.Arrays, insertOrder.OrderDAO" %>
<% request.setCharacterEncoding( "UTF-8" ); %>
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