<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" session="true"%>
<%@ page import="java.io.PrintWriter" %>
<%@ page import="insertOrder.OrderDAO" %>
<%@ page import="insertOrder.Order" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.List" %>
<%@ page import="user.UserDAO" %>
<%@ page import="user.User" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width", initial-scale="1">
<link rel="stylesheet" href="css/bootstrap.css">
<script>
        document.addEventListener("DOMContentLoaded", function() {
            var today = new Date().toISOString().split('T')[0];
            document.getElementById("orderDate").value = today;
        });
        
        document.addEventListener("DOMContentLoaded", function() {
            var today = new Date().toISOString().split('T')[0];
            document.getElementById("startDate").value = today;
        });
        
        document.addEventListener("DOMContentLoaded", function() {
            var today = new Date().toISOString().split('T')[0];
            document.getElementById("endDate").value = today;
        });
</script>
<title>로지스톡 운송 오더 시스템</title>
</head>
<body>
	<%
		String userID = null;
		if (session.getAttribute("userID") != null) {
			userID = (String) session.getAttribute("userID");
		}
		
		OrderDAO orderDAO = new OrderDAO();
		UserDAO userDAO = new UserDAO();
		orderDAO.setSession(session);
		String userType = orderDAO.getUserType();
		String userCompany = userDAO.getUserCompany( userID );
	%>
	
	<%
		if (userID == null) {
	%>
			<ul class="nav navbar-nav">
				<li class="dropdown">
					<a href="login.jsp" class="dropdown-toggle"
						data-toggle="dropdown" role="button" aria-haspopup="true"
						aria-expanded="false">세션이 만료되었습니다. 다시 접속해주세요.<span class="caret"></span>
					</a>
					<ul class="dropdown-menu">
						<li class="active"><a href="login.jsp">로그인</a></li>
					</ul>
				</li>
			</ul>
	<%
		} else {
	%>
		<nav class="navbar navbar-default">
		<div class="navbar-header">
			<button type="button" class="navbar-toggle" data-toggle="collapse" data-target="#bs-example-navbar-collapse-1">
				<span class="icon-bar"></span>
				<span class="icon-bar"></span>
				<span class="icon-bar"></span>	
			</button>
			<a class="navbar-brand" href="main.jsp">로지스톡 운송 오더 시스템</a>
		</div>
		<div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
			<ul class="nav navbar-nav">
				<li><a href="main.jsp">운송오더 등록</a></li>
			</ul>
			<ul class="nav navbar-nav">
				<li><a href="orderModify.jsp">운송오더 조회/취소</a></li>
			</ul>
			<ul class="nav navbar-nav">
				<li class="active"><a href="userModify.jsp">담당자 등록</a></li>
				<li><a href="arrivalModify.jsp">출/도착지 등록</a></li>
				<li><a href="carInfoModify.jsp">고정차량 등록</a></li>
			</ul>
			<ul class="nav navbar-nav">
				<li class="dropdown">
					<a href="#" class="dropdown-toggle"
						data-toggle="dropdown" role="button" aria-haspopup="true"
						aria-expanded="false">회원관리<span class="caret"></span>
					</a>
					<ul class="dropdown-menu">
						<li><a href="logoutAction.jsp">로그아웃</a></li>
					</ul>
				</li>
			</ul>
	
		<ul class="nav navbar-nav">
		<li><p style="margin-top: 15px;">환영합니다. <%= userID %>님</p><li>
	</ul>
		</div>	
	</nav>
	<script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
	<script src="js/bootstrap.js"></script>
	<script>
		function rtn() {
			f.reset();
		}
	</script>
<form action="userUpdateAction.jsp" method="post" name="f">
		<%
            String modifyUserID = request.getParameter("userID");
            User user = userDAO.getUserById( modifyUserID );
        %>
	<div class="container">
        <div class="panel panel-primary">
            <div class="panel-heading">담당자 수정</div>
            <div class="panel-body">
	            <div class="text-right">
	            	<div class="btn-group">
		                <button type="submit" class="btn btn-primary" style="margin-left: 10px;">저장</button>
	            	</div>
	            </div>
                   <div class="form-group row">
	                   <label class="col-sm-2 control-label">* 담당자 ID:</label>
	                     <div class="col-sm-3">
	                     	<input type="text" id="userID" name="userID" class="form-control" required autocomplete="off" placeholder="담당자 ID 입력" value="<%= user.getUserID() %>">
	                     </div>
	                     <label class="col-sm-2 control-label">* 담당자 PW:</label>
	                     <div class="col-sm-3">
	                         <input type="password" id="userPassword" name="userPassword" class="form-control" autocomplete="off" placeholder="담당자 비밀번호 입력" required value="<%= user.getUserPassword() %>">
	                     </div>
	               </div>
                   <div class="form-group row">
                        <label class="col-sm-2 control-label">* 담당자명:</label>
                        <div class="col-sm-3">
                        	<input type="text" name="userName" class="form-control" autocomplete="off" placeholder="담당자명 입력" required value="<%= user.getUserName() %>">
                        </div>
                        <label class="col-sm-2 control-label">담당자 연락처:</label>
                        <div class="col-sm-3">
                            <input type="text" name="userPhoneNumber" class="form-control" placeholder="담당자 연락처 입력" required value="<%= user.getUserPhoneNumber() %>">
                        </div>
                    </div>
                    <div class="form-group row">
                    	<label class="col-sm-2 control-label">회사명:</label>
                        <div class="col-sm-3">
                            <select name="userCompany" class="form-control">
                            <%
                            	if( userCompany.equals("") ) {
                            %>
								<option value="KCC글라스" <%= "KCC글라스".equals( user.getUserCompany() ) ? "selected" : "" %>>KCC글라스</option>
								<option value="(주)쎄레코" <%= "(주)쎄레코".equals( user.getUserCompany() ) ? "selected" : "" %>>(주)쎄레코</option>
								<option value="(주)JKC 코퍼레이션" <%= "(주)JKC 코퍼레이션".equals( user.getUserCompany() ) ? "selected" : "" %>>(주)JKC 코퍼레이션</option>
								<option value="코스모프로" <%= "코스모프로".equals( user.getUserCompany() ) ? "selected" : "" %>>코스모프로</option>
								<option value="(주)발렉스" <%= "(주)발렉스".equals( user.getUserCompany() ) ? "selected" : "" %>>(주)발렉스</option>
							<%
                            	} else if( userCompany.equals("KCC글라스") ) {
							%>	
								<option value="KCC글라스" <%= "KCC글라스".equals( user.getUserCompany() ) ? "selected" : "" %>>KCC글라스</option>
							<%
                            	} else if( userCompany.equals("(주)쎄레코") ) {
							%>
								<option value="(주)쎄레코" <%= "(주)쎄레코".equals( user.getUserCompany() ) ? "selected" : "" %>>KCC글라스</option>
							<%
                            	} else if( userCompany.equals("(주)JKC 코퍼레이션") ) {
							%>
								<option value="(주)JKC 코퍼레이션" <%= "(주)JKC 코퍼레이션".equals( user.getUserCompany() ) ? "selected" : "" %>>(주)JKC 코퍼레이션</option>
							<%
                            	} else if( userCompany.equals("코스모프로") ) {
							%>
								<option value="코스모프로" <%= "코스모프로".equals( user.getUserCompany() ) ? "selected" : "" %>>코스모프로</option>
							<%
                            	} else if( userCompany.equals("(주)발렉스") ) {
							%>
								<option value="(주)발렉스" <%= "(주)발렉스".equals( user.getUserCompany() ) ? "selected" : "" %>>(주)발렉스</option>
							<%
                            	}
							%>
							</select>
                        </div>
                        <label class="col-sm-2 control-label">부서명:</label>
                        <div class="col-sm-3">
                            <input type="text" name="userTeam" class="form-control" placeholder="담당자 부서명 입력" required value="<%= user.getUserTeam() %>">
                        </div>
                    </div>
                    <div class="form-group row">
                    	<label class="col-sm-2 control-label">담당자 등급:</label>
                        <div class="col-sm-3">
                            <select name="userType" class="form-control" required>
                                <option value="sales">출하담당자</option>
                                <option value="manager">총괄 매니저</option>
                            </select>
                        </div>
                    </div>
                </div>
            </div>
        </div>
</form>
	<%
		}	
	%>
</body>
</html>