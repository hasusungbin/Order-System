<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="user.UserDAO" %>
<%@ page import="user.User" %>
<%@ page import="java.io.PrintWriter" %>
<% request.setCharacterEncoding( "UTF-8" ); %>
<jsp:useBean id="user" class="user.User" scope="page" />
<jsp:setProperty name="user" property="userID" />
<jsp:setProperty name="user" property="userPassword" />
<jsp:setProperty name="user" property="userType" />
<jsp:setProperty name="user" property="userCompany" />
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>로지플랫</title>
</head>
<body>
	<%
		String userID = null;
		if( session.getAttribute("userID" ) != null) {
			userID = (String) session.getAttribute("userID");
		}
		UserDAO userDAO = new UserDAO();
		User result = userDAO.login(user.getUserID(), user.getUserPassword());
		
		if (result != null) {  // 로그인 성공
		    session.setAttribute("userID", result.getUserID());  
		    session.setAttribute("userType", result.getUserType());  
		    session.setAttribute("userCompany", result.getUserCompany());  

		    PrintWriter script = response.getWriter();
		    script.println("<script>");
		    script.println("location.href = 'main.jsp'");
		    script.println("</script>");
		} else {  // 로그인 실패
		    PrintWriter script = response.getWriter();
		    script.println("<script>");
		    script.println("alert('로그인 실패: 아이디 또는 비밀번호가 올바르지 않습니다.');");
		    script.println("location.href = 'login.jsp'");
		    script.println("</script>");
		}
	%>
</body>
</html>