<%@page import="org.apache.poi.util.SystemOutLogger"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="user.UserDAO" %>
<%@ page import="user.User" %>
<%@ page import="java.io.PrintWriter" %>
<%@ page import="java.io.IOException" %>
<%@ page import="javax.servlet.http.HttpServletRequest" %>
<%@ page import="javax.servlet.http.HttpServletResponse" %>
<%@ page import="javax.servlet.http.HttpSession" %>

<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>로지스톡</title>
</head>
<body>
<%
    request.setCharacterEncoding( "UTF-8" );

    String userID = request.getParameter( "userID" );
    String userPassword = request.getParameter( "userPassword" );
    String userName = request.getParameter( "userName" );
    String userType = request.getParameter( "userType" );
    String userPhoneNumber = request.getParameter( "userPhoneNumber" );
    String userCompany = request.getParameter( "userCompany" );
    String userTeam = request.getParameter( "userTeam" );

    HttpSession session2 = request.getSession();
    String sessionCompany = ( String ) session2.getAttribute( "userCompany" );

    UserDAO userDAO = new UserDAO();

    boolean isUserExists = userDAO.isUserExists( userID ); 
    if ( isUserExists ) {
%>
    <script>
        alert("이미 존재하는 ID입니다. 다른 ID를 입력하세요.");
        history.back();
    </script>
<%
    } else { 
        userDAO.insertUser( new User(userID, userPassword, userName, userType, userPhoneNumber, userCompany, userTeam) );
%>
    <script>
        alert( "담당자가 성공적으로 등록되었습니다." );
        location.href = "userModify.jsp";
    </script>
<%
    }
%>
</body>
</html>