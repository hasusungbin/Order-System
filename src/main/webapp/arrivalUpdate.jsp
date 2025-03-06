<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" session="true"%>
<%@ page import="java.io.PrintWriter" %>
<%@ page import="arrival.ArrivalDAO" %>
<%@ page import="arrival.Arrival" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.List" %>
<%@ page import="user.UserDAO" %>
<%@ page import="user.User" %>
<%@ page import="insertOrder.OrderDAO" %>
<%@ page import="insertOrder.Order" %>
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
		ArrivalDAO arrivalDAO = new ArrivalDAO();
		orderDAO.setSession(session);
		String userType = orderDAO.getUserType();
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
			<button type="button" class="navbar-toggle collapsed"
				data-toggle="collpase" data-target="#bs-example-navbar-collapse-1"
				aria-expended="false">
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
				<li class="dropdown">
					<a href="#" class="dropdown-toggle"
						data-toggle="dropdown" role="button" aria-haspopup="true"
						aria-expanded="false">운송오더 조회<span class="caret"></span>
					</a>
					<ul class="dropdown-menu">
						<li class="active"><a href="orderModify.jsp">조회 및 수정(취소)</a></li>
						<li><a href="carInfo.jsp">차량정보 등록</a></li>
					</ul>
				</li>
			</ul>
			<ul class="nav navbar-nav">
				<li><a href="userModify.jsp">담당자 등록</a></li>
				<li><a href="arrivalModify.jsp">출/도착지 등록</a></li>
				<li><a href="carModify.jsp">고정차량 등록</a></li>
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
<form action="arrivalUpdateAction.jsp" method="post" name="f">
		<%
            String arrivalName = request.getParameter("arrivalName");
            Arrival arrival = arrivalDAO.getArrivalByName( arrivalName ); 
        %>
	<div class="container">
        <div class="panel panel-primary">
            <div class="panel-heading">출/도착지 수정</div>
            <div class="panel-body">
	            <div class="text-right">
	            	<div class="btn-group">
		                <button type="submit" class="btn btn-primary" style="margin-left: 10px;">저장</button>
	            	</div>
	            </div>
                   <div class="form-group row">
	                   <label class="col-sm-2 control-label">출/도착지 구분:</label>
	                     <div class="col-sm-3">
	                     	<select name="type" class="form-control" required>
                                <option value="출발지">출발지</option>
                                <option value="도착지">도착지</option>
                            </select>
	                     </div>
	               </div>
                   <div class="form-group row">
                   		<label class="col-sm-2 control-label">명칭:</label>
	                     <div class="col-sm-3">
	                         <input type="text" id="arrivalName" name="arrivalName" class="form-control" autocomplete="off" placeholder="명칭은 중복이 불가합니다." readonly value="<%= arrival.getArrivalName() %>">
	                     </div>
                        <label class="col-sm-2 control-label">* 시/도:</label>
                        <div class="col-sm-3">
                        	<input type="text" name="arrivalCities" class="form-control" autocomplete="off" placeholder="시/도 입력" required value="<%= arrival.getArrivalCities() %>">
                        </div>
                    </div>
                    <div class="form-group row">
                    	<label class="col-sm-2 control-label">담당자 명:</label>
                        <div class="col-sm-3">
                            <input type="text" name="arrivalManager" class="form-control" placeholder="담당자명 입력" required value="<%= arrival.getArrivalManager() %>">
                        </div>
                    	<label class="col-sm-2 control-label">시/군/구:</label>
                        <div class="col-sm-3">
                            <input type="text" name="arrivalTown" class="form-control" placeholder="시/군/구 입력" required value="<%= arrival.getArrivalTown() %>">
                        </div>
                    </div>
                    <div class="form-group row">
                    	<label class="col-sm-2 control-label">담당자 연락처:</label>
                        <div class="col-sm-3">
                            <input type="text" name="arrivalManagerPhoneNum" class="form-control" placeholder="담당자 연락처(- 제외)입력" required value="<%= arrival.getArrivalManagerPhoneNum() %>">
                        </div>
                    	<label class="col-sm-2 control-label">상세주소:</label>
                        <div class="col-sm-3">
                            <input type="text" name="arrivalDetailedAddress" class="form-control" placeholder="상세주소 입력" required value="<%= arrival.getArrivalDetailedAddress() %>">
                        </div>
                    </div>
                    <div class="form-group row">
                    	<label class="col-sm-2 control-label">기타사항:</label>
                        <div class="col-sm-8">
                            <input type="text" name="etc" class="form-control" placeholder="기타사항 입력" value="<%= arrival.getEtc() %>">
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