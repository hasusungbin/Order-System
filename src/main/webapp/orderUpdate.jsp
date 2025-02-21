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
			System.out.println(userID);
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
<form action="updateAction.jsp" method="post" name="f">
		<%
            String orderNumber = request.getParameter("orderNumber");
            OrderDAO orderDAO = new OrderDAO();
            Order order = orderDAO.getOrderById( orderNumber );
        %>
	<div class="container">
        <div class="panel panel-primary">
            <div class="panel-heading">화물등록 수정</div>
            <div class="panel-body">
	            <div class="text-right">
	            	<div class="btn-group">
		                <button type="submit" class="btn btn-primary" style="margin-left: 10px;">저장</button>
	            	</div>
	            </div>
                   <div class="form-group row">
                       <label class="col-sm-2 control-label" ><a class="text-danger">* 운송요청일:</a></label>
                       <div class="col-sm-4">
                           <input type="date" name="orderDate" id="orderDate" class="form-control" required value="<%= order.getOrderDate() %>">
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
                           <input type="text" name="userPhoneNumber" class="form-control" placeholder="-없이 입력해주세요." value="<%= order.getArrivalManagerPhoneNum() %>">
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
                            <input type="number" name="refNumber" class="form-control" value="<%= order.getRefNumber() %>">
                        </div>
                    	<label class="col-sm-2 control-label">품목:</label>
                       <div class="col-sm-5">
                       		<input type="text" name="item" class="form-control" value="<%= order.getItem() %>">
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
            <div class="panel-heading">화물수정 상세(출발지 수정)</div>
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
                            <select name="departureName" class="form-control" required>
                            	<%
		                        	for( int i = 0; i < userList.size(); i++ ) {
		                        %>
                                <option><%= userList.get(i).getUserName() %></option>
                                <%
		                        	}
                                %>
                            </select>
                        </div>
                    </div>
                    <div class="form-group row">
                        <label class="col-sm-2 control-label"><a class="text-danger">* 시/도:</a></label>
                        <div class="col-sm-3">
                            <select name="departureCities" class="form-control" required>
                                <option value="서울특별시" <%= "서울특별시".equals(order.getDepartureCities()) ? "selected" : "" %>>서울특별시</option>
                                <option value="경기도" <%= "경기도".equals(order.getDepartureCities()) ? "selected" : "" %>>경기도</option>
                                <option value="인천광역시" <%= "인천광역시".equals(order.getDepartureCities()) ? "selected" : "" %>>인천광역시</option>
                                <option value="부산광역시" <%= "부산광역시".equals(order.getDepartureCities()) ? "selected" : "" %>>부산광역시</option>
                                <option value="대전광역시" <%= "대전광역시".equals(order.getDepartureCities()) ? "selected" : "" %>>대전광역시</option>
                                <option value="광주광역시" <%= "광주광역시".equals(order.getDepartureCities()) ? "selected" : "" %>>광주광역시</option>
                                <option value="대구광역시" <%= "대구광역시".equals(order.getDepartureCities()) ? "selected" : "" %>>대구광역시</option>
                                <option value="울산광역시" <%= "울산광역시".equals(order.getDepartureCities()) ? "selected" : "" %>>울산광역시</option>
                                <option value="충청북도" <%= "충청북도".equals(order.getDepartureCities()) ? "selected" : "" %>>충청북도</option>
                                <option value="충청남도" <%= "충청남도".equals(order.getDepartureCities()) ? "selected" : "" %>>충청남도</option>
                                <option value="경상북도" <%= "경상북도".equals(order.getDepartureCities()) ? "selected" : "" %>>경상북도</option>
                                <option value="경상남도" <%= "경상남도".equals(order.getDepartureCities()) ? "selected" : "" %>>경상남도</option>
                                <option value="전라북도" <%= "전라북도".equals(order.getDepartureCities()) ? "selected" : "" %>>전라북도</option>
                                <option value="전라남도" <%= "전라남도".equals(order.getDepartureCities()) ? "selected" : "" %>>전라북도</option>
                                <option value="강원도" <%= "강원도".equals(order.getDepartureCities()) ? "selected" : "" %>>강원도</option>
                                <option value="제주도" <%= "제주도".equals(order.getDepartureCities()) ? "selected" : "" %>>제주도</option>
                                <option value="세종특별자치시" <%= "세종특별자치시".equals(order.getDepartureCities()) ? "selected" : "" %>>세종특별자치시</option>
                            </select>
                        </div>
                    </div>
                    <div class="form-group row">
                    	 <label class="col-sm-2 control-label"><a class="text-danger">* 시/군/구:</a></label>
                        <div class="col-sm-3">
                        	<input type="text" name="departureTown" class="form-control">
                        </div>
                    </div>
                    <div class="form-group row">
                        <label class="col-sm-2 control-label">상세주소:</label>
                        <div class="col-sm-8">
                            <input type="text" name="departureDetailedAddress" class="form-control">
                        </div>
                    </div>
                    <div class="form-group row">
                    	<label class="col-sm-2 control-label">담당자:</label>
                        <div class="col-sm-3">
                        	<input type="text" name="departureManager" class="form-control">
                        </div>
                        <label class="col-sm-2 control-label">연락처:</label>
                        <div class="col-sm-3">
                        	<input type="text" name="departureManagerPhoneNum" class="form-control">
                        </div>
                    </div>
            </div>
        </div>
	</div>
	<div class="container">
        <div class="panel panel-primary">
            <div class="panel-heading">화물수정 상세(도착지 수정)</div>
            <div class="panel-body">
                    <div class="form-group row">
                        <label class="col-sm-2 control-label"><a class="text-danger">* 도착지 도착일시:</a></label>
                        <div class="col-sm-4">
                            <input type="date" name="endDate" id="endDate" class="form-control" required>
                        </div>
                    </div>
                    <div class="form-group row">
                        <label class="col-sm-2 control-label">도착지명:</label>
                        <div class="col-sm-3">
                            <select name="arrivalName" class="form-control" required>
                            	<%
		                        	for( int i = 0; i < userList.size(); i++ ) {
		                        %>
                                <option <%= userList.get(i).equals(order.getUserName()) ? "selected" : "" %>><%= userList.get(i).getUserName() %></option>
                                <%
		                        	}
                                %>
                            </select>
                        </div>
                    </div>
                    <div class="form-group row">
                        <label class="col-sm-2 control-label"><a class="text-danger">* 시/도:</a></label>
                        <div class="col-sm-3">
                            <select name="arrivalCities" class="form-control" required>
                                <option value="서울특별시" <%= "서울특별시".equals(order.getArrivalCities()) ? "selected" : "" %>>서울특별시</option>
                                <option value="경기도" <%= "경기도".equals(order.getArrivalCities()) ? "selected" : "" %>>경기도</option>
                                <option value="인천광역시" <%= "인천광역시".equals(order.getArrivalCities()) ? "selected" : "" %>>인천광역시</option>
                                <option value="부산광역시" <%= "부산광역시".equals(order.getArrivalCities()) ? "selected" : "" %>>부산광역시</option>
                                <option value="대전광역시" <%= "대전광역시".equals(order.getArrivalCities()) ? "selected" : "" %>>대전광역시</option>
                                <option value="광주광역시" <%= "광주광역시".equals(order.getArrivalCities()) ? "selected" : "" %>>광주광역시</option>
                                <option value="대구광역시" <%= "대구광역시".equals(order.getArrivalCities()) ? "selected" : "" %>>대구광역시</option>
                                <option value="울산광역시" <%= "울산광역시".equals(order.getArrivalCities()) ? "selected" : "" %>>울산광역시</option>
                                <option value="충청북도" <%= "충청북도".equals(order.getArrivalCities()) ? "selected" : "" %>>충청북도</option>
                                <option value="충청남도" <%= "충청남도".equals(order.getArrivalCities()) ? "selected" : "" %>>충청남도</option>
                                <option value="경상북도" <%= "경상북도".equals(order.getArrivalCities()) ? "selected" : "" %>>경상북도</option>
                                <option value="경상남도" <%= "경상남도".equals(order.getArrivalCities()) ? "selected" : "" %>>경상남도</option>
                                <option value="전라북도" <%= "전라북도".equals(order.getArrivalCities()) ? "selected" : "" %>>전라북도</option>
                                <option value="전라남도" <%= "전라남도".equals(order.getArrivalCities()) ? "selected" : "" %>>전라북도</option>
                                <option value="강원도" <%= "강원도".equals(order.getArrivalCities()) ? "selected" : "" %>>강원도</option>
                                <option value="제주도" <%= "제주도".equals(order.getArrivalCities()) ? "selected" : "" %>>제주도</option>
                                <option value="세종특별자치시" <%= "세종특별자치시".equals(order.getArrivalCities()) ? "selected" : "" %>>세종특별자치시</option>
                            </select>
                        </div>
                    </div>
                    <div class="form-group row">
                    	<label class="col-sm-2 control-label"><a class="text-danger">* 시/군/구:</a></label>
                        <div class="col-sm-3">
                        	<input type="text" name="arrivalTown" class="form-control">
                        </div>
                    </div>
                    <div class="form-group row">
                        <label class="col-sm-2 control-label">상세주소:</label>
                        <div class="col-sm-8">
                            <input type="text" name="arrivalDetailedAddress" class="form-control">
                        </div>
                    </div>
                    <div class="form-group row">
                    	<label class="col-sm-2 control-label">담당자:</label>
                        <div class="col-sm-3">
                        	<input type="text" name="arrivalManager" class="form-control">
                        </div>
                        <label class="col-sm-2 control-label">연락처:</label>
                        <div class="col-sm-3">
                        	<input type="text" name="arrivalManagerPhoneNum" class="form-control">
                        </div>
                    </div>
            </div>
        </div>
	</div>
	<div class="container">
        <div class="panel panel-primary">
            <div class="panel-heading">옵션 수정</div>
            <div class="panel-body">
	            <div class="form-group row">
                	<label class="col-sm-2 control-label">이착지 주소:</label>
	                	<div class="col-sm-3">
		                    <input type="text" name="destinationAddress" class="form-control">	                	
	                	</div>
	                	<div class="col-sm-3">
		                    이착 : <input type="checkbox" name="option1" value="이착">
		                    혼적 : <input type="checkbox" name="option2" value="혼적">
		                    왕복 : <input type="checkbox" name="option3" value="왕복">
		                    착불 : <input type="checkbox" name="option4" value="착불">
	                    </div>
	            </div>
            </div>
        </div>
	</div>
	<%	
		UserDAO userDAO2 = new UserDAO();
		System.out.println(userID + "이거 왜아노대 ㅡㅡ");
		User userType = userDAO2.getAdminUser(userID);
		System.out.println(userType + "이거 왜아노대 ㅡㅡ2222");
	%>
	<div class="container" <%= "admin".equals( userType ) ? "" : "style='display:none;'" %>>
        <div class="panel panel-primary">
            <div class="panel-heading">차량정보</div>
            <div class="panel-body">
	            <div class="form-group row">
                	<label class="col-sm-2 control-label">차량번호: </label>
	                	<div class="col-sm-3">
		                    <input type="text" name="carNumber" class="form-control">          	
	                	</div>
	                <label class="col-sm-2 control-label">기사명: </label>
	                	<div class="col-sm-3">
		                    <input type="text" name="driverName" class="form-control">            	
	                	</div>
	                <label class="col-sm-2 control-label">기사연락처: </label>
	                	<div class="col-sm-3">
		                    <input type="text" name="carNumber" class="form-control">            	
	                	</div>
	                <label class="col-sm-2 control-label">기본운임: </label>
	                	<div class="col-sm-3">
		                    <input type="text" name="basicFare" class="form-control">            	
	                	</div>
	                <label class="col-sm-2 control-label">추가운임: </label>
	                	<div class="col-sm-3">
		                    <input type="text" name="addFare" class="form-control">            	
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