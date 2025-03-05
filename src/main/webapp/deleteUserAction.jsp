<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter" %>
<%@ page import="java.util.List, java.util.Arrays" %>
<% request.setCharacterEncoding( "UTF-8" ); %>
<%@ page import="user.UserDAO" %>

<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>로지스톡</title>
</head>
<body>
	<%
		String[] userIDs = request.getParameterValues("userIDs");
		if (userIDs != null && userIDs.length > 0) {
	        UserDAO userDAO = new UserDAO();
	        boolean success = userDAO.deleteUser(Arrays.asList(userIDs));
		if (success) { 
		
%>
            <script>
                alert("선택한 유저가 삭제되었습니다.");
                window.location.href = "userModify.jsp"; // 조회 페이지로 리디렉트
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
            alert("삭제할 유저를 선택해주세요.");
            history.back();
        </script>
<%
    }
%>
</body>
</html>