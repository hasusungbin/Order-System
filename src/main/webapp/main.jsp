<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter" %>
<%@ page import="user.UserDAO" %>
<%@ page import="user.User" %>
<%@ page import="java.util.ArrayList" %>
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
</script>
<title>로지스톡 운송 오더 시스템</title>
</head>
<body>
	<%
		String userID = null;
		if (session.getAttribute("userID") != null) {
			userID = (String) session.getAttribute("userID");
		}
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
				<li class="active"><a href="main.jsp">운송오더 등록</a></li>
			</ul>
			<ul class="nav navbar-nav">
				<li class="dropdown">
					<a href="#" class="dropdown-toggle"
						data-toggle="dropdown" role="button" aria-haspopup="true"
						aria-expanded="false">운송오더 조회<span class="caret"></span>
					</a>
					<ul class="dropdown-menu">
						<li><a href="orderModify.jsp">조회 및 수정(취소)</a></li>
						<li><a href="carInfo.jsp">차량정보 등록</a></li>
					</ul>
				</li>
			</ul>
			<ul class="nav navbar-nav">
				<li><a href="carModify.jsp">차량정보 수정</a></li>
				<li><a href="carModify.jsp">담당자 등록</a></li>
				<li><a href="carModify.jsp">출/도착지 등록</a></li>
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
<form action="writeAction.jsp" method="post" name="f">
	<div class="container">
        <div class="panel panel-primary">
            <div class="panel-heading">화물등록 일반</div>
            <div class="panel-body">
	            <div class="text-right">
	            	<div class="btn-group">
		                <input type="button" class="btn btn-primary" onclick="rtn();" value="신규">
		                <button type="submit" class="btn btn-primary" style="margin-left: 10px;">저장</button>
	            	</div>
	            </div>
                   <div class="form-group row">
                       <label class="col-sm-2 control-label" ><a class="text-danger">* 운송요청일:</a></label>
                       <div class="col-sm-4">
                           <input type="date" name="orderDate" id="orderDate" class="form-control" required>
                       </div>
                   </div>
                   <div class="form-group row">
                       <label class="col-sm-2 control-label"><a class="text-danger">* 담당자명:</a></label>
                       <div class="col-sm-3">
                           <select name="userName" class="form-control" required>
                           	<%
	                        	UserDAO userDAO = new UserDAO();
	                        	ArrayList<User> userList = userDAO.getUserList();
	                        	for( int i = 0; i < userList.size(); i++ ) {
	                        %>
                               <option><%= userList.get(i).getUserName() %></option>
                               <%
	                        	}
                               %>
                           </select>
                       </div>
                       <label class="col-sm-2 control-label">연락처:</label>
                       <div class="col-sm-3">
                           <input type="text" name="userPhoneNumber" class="form-control" placeholder="-없이 입력해주세요.">
                       </div>
                   </div>
                   <div class="form-group row">
                       <label class="col-sm-2 control-label"><a class="text-danger">* 차량톤급:</a></label>
                       <div class="col-sm-3">
                           <select name="carWeight" class="form-control" required>
                               <option value="이륜차">이륜차</option>
                               <option value="1톤">1톤</option>
                               <option value="1.4톤">1.4톤</option>
                               <option value="2.5톤">2.5톤</option>
                               <option value="3.5톤">3.5톤</option>
                               <option value="5톤">5톤</option>
                               <option value="5톤 축">5톤 축</option>
                               <option value="8톤">8톤</option>
                               <option value="11톤">11톤</option>
                               <option value="11톤 축">11톤 축</option>
                               <option value="15톤">15톤</option>
                               <option value="18톤">18톤</option>
                               <option value="25톤">25톤</option>
                           </select>
                       </div>
                       <label class="col-sm-2 control-label"><a class="text-danger">* 차량종류:</a></label>
                       <div class="col-sm-3">
                           <select name="kindOfCar" class="form-control" required>
                               <option value="카고">카고</option>
                               <option value="윙바디">윙바디</option>
                               <option value="탑">탑</option>
                               <option value="냉동/냉장">냉동/냉장</option>
                           </select>
                       </div>
                   </div>
                   <div class="form-group row">
                   	<label class="col-sm-2 control-label">고정차량:</label>
                       <div class="col-sm-3">
                           <select name="fixedCarNumber" class="form-control">
                               <option value="">Master data</option>
                           </select>
                       </div>
                       <label class="col-sm-2 control-label">상하차 방식:</label>
                       <div class="col-sm-3">
                           <select name="upDown" class="form-control" required>
                               <option value="지게차">지게차</option>
                               <option value="수작업">수작업</option>
                               <option value="일부 수작업">일부 수작업</option>
                               <option value="호이스트">호이스트</option>
                           </select>
                       </div>
                   </div>
                   <div class="form-group row">
                    <label class="col-sm-2 control-label">참조번호:</label>
                        <div class="col-sm-3">
                            <input type="text" name="refNumber" class="form-control">
                        </div>
                    <label class="col-sm-2 control-label">품목:</label>
                       <div class="col-sm-5">
                       	<input type="text" name="item" class="form-control">
                       </div>
                </div>
                <div class="form-group row">
                	<label class="col-sm-2 control-label">기타:</label>
                        <div class="col-sm-10">
                            <input type="text" name="etc" class="form-control">
                        </div>
				</div>
            </div>
        </div>
	</div>
	<div class="container">
        <div class="panel panel-primary">
            <div class="panel-heading">화물등록 상세</div>
            <div class="panel-body">
                    <div class="form-group row">
                        <label class="col-sm-2 control-label"><a class="text-danger">* 출발지 도착일시:</a></label>
                        <div class="col-sm-4">
                            <input type="date" name="startDate" id="startDate" class="form-control" required>
                        </div>
                    </div>
                    <div class="form-group row">
                        <label class="col-sm-2 control-label">출발지명:</label>
                        <div class="col-sm-3">
                            <select name="userName" class="form-control" required>
                            	<%
		                        	for( int i = 0; i < userList.size(); i++ ) {
		                        %>
                                <option><%= userList.get(i).getUserName() %></option>
                                <%
		                        	}
                                %>
                            </select>
                        </div>
                        <label class="col-sm-2 control-label">연락처:</label>
                        <div class="col-sm-3">
                            <input type="text" name="userPhoneNumber" class="form-control">
                        </div>
                    </div>
                    <div class="form-group row">
                        <label class="col-sm-2 control-label">* 시/도:</label>
                        <div class="col-sm-3">
                            <select name="carWeight" class="form-control" required>
                                <option value="서울특별시">서울특별시</option>
                                <option value="1Ton">1톤</option>
                                <option value="1.4Ton">1.4톤</option>
                                <option value="2.5Ton">2.5톤</option>
                                <option value="3.5Ton">3.5톤</option>
                                <option value="5Ton">5톤</option>
                                <option value="5TonAxis">5톤 축</option>
                                <option value="8Ton">8톤</option>
                                <option value="11Ton">11톤</option>
                                <option value="11TonAxis">11톤 축</option>
                                <option value="15Ton">15톤</option>
                                <option value="18Ton">18톤</option>
                                <option value="25Ton">25톤</option>
                            </select>
                        </div>
                        <label class="col-sm-2 control-label">고정차량:</label>
                        <div class="col-sm-3">
                            <select name="carNumber" class="form-control">
                                <option value="">Master data</option>
                            </select>
                        </div>
                    </div>
                    <div class="form-group row">
                        <label class="col-sm-2 control-label">상하차 방식:</label>
                        <div class="col-sm-3">
                            <select name="upDown" class="form-control" required>
                                <option value="forklift">지게차</option>
                                <option value="handwork">수작업</option>
                                <option value="someHandwork">일부 수작업</option>
                                <option value="hoist">호이스트</option>
                            </select>
                        </div>
                        <label class="col-sm-2 control-label">품목:</label>
                        <div class="col-sm-5">
                        	<input type="text" name="item" class="form-control">
                        </div>
                    </div>
                    <div class="form-group row">
                        <label class="col-sm-2 control-label">도착지 시/도:</label>
                        <div class="col-sm-3">
                            <select name="arrivalCity" class="form-control">
                                <option value="">Code data</option>
                            </select>
                        </div>
                        <label class="col-sm-2 control-label">오더번호:</label>
                        <div class="col-sm-3">
                            <input type="text" name="orderNumber" class="form-control">
                        </div>
                    </div>
                    <div class="form-group row">
	                    <label class="col-sm-2 control-label">참조번호:</label>
	                        <div class="col-sm-3">
	                            <input type="text" name="referenceNumber" class="form-control">
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