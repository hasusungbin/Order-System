<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" session="true"%>
<%@ page import="java.io.PrintWriter" %>
<%@ page import="carInfo.CarInfoDAO" %>
<%@ page import="carInfo.CarInfo" %>
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
		CarInfoDAO arrivalDAO = new CarInfoDAO();
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
				<li><a href="orderModify.jsp">운송오더 조회/취소</a></li>
			</ul>
			<ul class="nav navbar-nav">
				<li><a href="userModify.jsp">담당자 등록</a></li>
				<li><a href="arrivalModify.jsp">출/도착지 등록</a></li>
				<li class="active"><a href="carInfoModify.jsp">고정차량 등록</a></li>
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
<form action="carInfoUpdateAction.jsp" method="post" name="f">
		<%
            String carNumber = request.getParameter("carNumber");
            CarInfo carInfo = arrivalDAO.getCarInfoByCarNumber( carNumber );
        %>
	<div class="container">
        <div class="panel panel-primary">
            <div class="panel-heading">고정차량 수정</div>
            <div class="panel-body">
	            <div class="text-right">
	            	<div class="btn-group">
		                <button type="submit" class="btn btn-primary" style="margin-left: 10px;">저장</button>
	            	</div>
	            </div>
                   <div class="form-group row">
                   		<label class="col-sm-2 control-label">* 차량번호:</label>
	                    <div class="col-sm-3">
	                    	<input type="text" id="carNumber" name="carNumber" class="form-control" readonly value="<%= carInfo.getCarNumber() %>">
	                    </div>
	                    <%
                        	if( userType.equals("admin") ) {
                        %>
                        	<label class="col-sm-2 control-label">회사:</label>
	                        <div class="col-sm-3">
								<select name="userCompany" class="form-control">
									<option value="" >--선택--</option>
									<option value="KCC글라스" <%= "KCC글라스".equals(carInfo.getUserCompany()) ? "selected" : "" %>>KCC글라스</option>
									<option value="(주)쎄레코" <%= "(주)쎄레코".equals(carInfo.getUserCompany()) ? "selected" : "" %>>(주)쎄레코</option>
									<option value="(주)JKC 코퍼레이션" <%= "(주)JKC 코퍼레이션".equals(carInfo.getUserCompany()) ? "selected" : "" %>>(주)JKC 코퍼레이션</option>
									<option value="코스모프로" <%= "코스모프로".equals(carInfo.getUserCompany()) ? "selected" : "" %>>코스모프로</option>
									<option value="(주)발렉스" <%= "(주)발렉스".equals(carInfo.getUserCompany()) ? "selected" : "" %>>(주)발렉스</option>
								</select>
	                        </div>
                        <%
                        	}
                        %>
                    </div>
                    <div class="form-group row">
                    	<label class="col-sm-2 control-label">기사명:</label>
                        <div class="col-sm-3">
                        	<input type="text" id="driverName" name="driverName" class="form-control" value="<%= carInfo.getDriverName() == null ? "" : carInfo.getDriverName() %>">
                        </div>
                    	<label class="col-sm-2 control-label">차량 톤급:</label>
                        <div class="col-sm-3">
                            <select name="carWeight" class="form-control">
					            <option value="이륜차" <%= "이륜차".equals( carInfo.getCarWeight() ) ? "selected" : "" %>>이륜차</option>
					            <option value="1톤" <%= "1톤".equals( carInfo.getCarWeight() ) ? "selected" : "" %>>1톤</option>
					            <option value="1.4톤" <%= "1.4톤".equals( carInfo.getCarWeight() ) ? "selected" : "" %>>1.4톤</option>
					            <option value="2.5톤" <%= "2.5톤".equals( carInfo.getCarWeight() ) ? "selected" : "" %>>2.5톤</option>
					            <option value="3.5톤" <%= "3.5톤".equals( carInfo.getCarWeight() ) ? "selected" : "" %>>3.5톤</option>
					            <option value="5톤" <%= "5톤".equals( carInfo.getCarWeight() ) ? "selected" : "" %>>5톤</option>
					            <option value="5톤 축" <%= "5톤 축".equals( carInfo.getCarWeight() ) ? "selected" : "" %>>5톤 축</option>
					            <option value="8톤" <%= "8톤".equals( carInfo.getCarWeight() ) ? "selected" : "" %>>8톤</option>
					            <option value="11톤" <%= "11톤".equals( carInfo.getCarWeight() ) ? "selected" : "" %>>11톤</option>
					            <option value="11톤 축" <%= "11톤 축".equals( carInfo.getCarWeight() ) ? "selected" : "" %>>11톤 축</option>
					            <option value="15톤" <%= "15톤".equals( carInfo.getCarWeight() ) ? "selected" : "" %>>15톤</option>
					            <option value="18톤" <%= "18톤".equals( carInfo.getCarWeight() ) ? "selected" : "" %>>18톤</option>
					            <option value="25톤" <%= "25톤".equals( carInfo.getCarWeight() ) ? "selected" : "" %>>25톤</option>
					        </select>
                        </div>
                    </div>
                    <div class="form-group row">
                    	<label class="col-sm-2 control-label">기사 연락처:</label>
                        <div class="col-sm-3">
                            <input type="text" name="driverPhoneNumber" class="form-control" placeholder="기사 연락처 입력" value="<%= carInfo.getDriverPhoneNumber() == null ? "" : carInfo.getDriverPhoneNumber() %>">
                        </div>
                    	<label class="col-sm-2 control-label">차량 종류:</label>
                        <div class="col-sm-3">
                        	<select name="kindOfCar" class="form-control">
					            <option value="카고" <%= "카고".equals( carInfo.getKindOfCar() ) ? "selected" : "" %>>카고</option>
					            <option value="윙바디" <%= "윙바디".equals( carInfo.getKindOfCar() ) ? "selected" : "" %>>윙바디</option>
					            <option value="탑" <%= "탑".equals( carInfo.getKindOfCar() ) ? "selected" : "" %>>탑</option>
					            <option value="냉동/냉장" <%= "냉동/냉장".equals( carInfo.getKindOfCar() ) ? "selected" : "" %>>냉동/냉장</option>
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