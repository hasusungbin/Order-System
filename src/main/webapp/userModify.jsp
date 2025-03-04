<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" session="true"%>
<%@ page import="java.io.PrintWriter" %>
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
<title>로지스톡 운송 오더 시스템</title>
<script>
        function validateForm() {
            let userId = document.getElementById("userID").value;
            let userPw = document.getElementById("userPassword").value;

            if (userId === "" || userPw === "") {
                alert("ID와 PW를 입력하세요.");
                return false;
            }

            return true;
        }
    </script>
</head>
<body>
<script>
	search.btn();
</script>
<script>
		function rtn() {
			f.reset();
		}
</script>
<script>
	window.onload = function () {
	    document.getElementById("userName").value = "";
	    document.getElementById("userPassword").value = "";
	};
</script>
	<%
		String userID = null;
		if (session.getAttribute("userID") != null) {
			userID = (String) session.getAttribute("userID");
		}
		
		UserDAO userDAO = new UserDAO();
		userDAO.setSession(session);
		String userType = userDAO.getUserType();
		
		HttpSession userSession = request.getSession();
	    String sessionCompany = (String) userSession.getAttribute("userCompany");

	    List<User> userList = userDAO.getUsersByCompany(sessionCompany);
		
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
						<li><a href="orderModify.jsp">조회 및 수정(취소)</a></li>
					</ul>
				</li>
			</ul>
			<ul class="nav navbar-nav">
				<li class="active" <%= "sales".equals( userType ) ? "style='display:none;'" : ""%>><a href="userModify.jsp">담당자 등록</a></li>
				<li><a href="carModify.jsp">출/도착지 등록</a></li>
				<li><a href="carModify.jsp">고정차량 등록</a></li>
			</ul>
	<%
		if (userID == null) {
	%>
			<ul class="nav navbar-nav">
				<li class="dropdown">
					<a href="#" class="dropdown-toggle"
						data-toggle="dropdown" role="button" aria-haspopup="true"
						aria-expanded="false">접속하기<span class="caret"></span>
					</a>
					<ul class="dropdown-menu">
						<li><a href="login.jsp">로그인</a></li>
					</ul>
				</li>
			</ul>
	<%
		} else {
	%>
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
	<%
		}	
	%>
	<ul class="nav navbar-nav">
		<li><p>환영합니다. <%= userID %>님.</p><li>
	</ul>
		</div>	
	</nav>
	<div class="container">
        <div class="panel panel-primary">
            <div class="panel-heading">담당자 등록</div>
            <div class="panel-body">
                <form id="searchForm" action="./userModify.jsp" onsubmit="return validateForm();" name="f">
                	<div class="text-right">
		            	<div class="btn-group">
			                <input type="button" class="btn btn-primary" onclick="rtn();" value="신규">
			                <button type="submit" class="btn btn-primary" style="margin-left: 10px;">저장</button>
		            	</div>
		            </div>
                	<div class="form-group row">
                        <label class="col-sm-2 control-label">* 담당자 ID:</label>
                        <div class="col-sm-3">
                        	<input type="text" id="userID" name="userID" class="form-control" required autocomplete="off" placeholder="담당자 ID 입력">
                        </div>
                        <label class="col-sm-2 control-label">* 담당자 PW:</label>
                        <div class="col-sm-3">
                            <input type="password" id="userPassword" name="userPassword" class="form-control" autocomplete="off" placeholder="담당자 비밀번호 입력" required>
                        </div>
                    </div>
                    <div class="form-group row">
                        <label class="col-sm-2 control-label">* 담당자명:</label>
                        <div class="col-sm-3">
                        	<input type="text" name="userName" class="form-control" autocomplete="off" placeholder="담당자명 입력" required>
                        </div>
                        <label class="col-sm-2 control-label">담당자 연락처:</label>
                        <div class="col-sm-3">
                            <input type="text" name="userPhoneNumber" class="form-control" placeholder="담당자 연락처 입력" required>
                        </div>
                    </div>
                    <div class="form-group row">
                        <label class="col-sm-2 control-label">부서명:</label>
                        <div class="col-sm-3">
                            <input type="text" name="userTeam" class="form-control" placeholder="담당자 부서명 입력" required>
                        </div>
                        <label class="col-sm-2 control-label">담당자 등급:</label>
                        <div class="col-sm-3">
                            <select name="userType" class="form-control" required>
                                <option value="sales">영업사원</option>
                                <option value="manager">총괄 매니저</option>
                            </select>
                        </div>
                    </div>
                </form>
            </div>
        </div>
        <div class="panel panel-default">
            <div class="panel-heading">조회 결과
	            <div class="text-right">
					<button onclick="deleteSelectedOrders()" class="btn btn-danger">요청취소</button>
	            </div>
            </div>
            <div class="panel-body">
                <table class="table table-bordered table-hover">
                    <thead>
                        <tr style="font-size: 10px;">
                            <th>체크</th>
                        	<th>담당자명</th>
                            <th>담당자 연락처</th>
                            <th>부서명</th>
                            <th>담당자 등급</th>
                            <th>등록일자</th>
                        </tr>
                    </thead>
                    <tbody>
			           <%--  <% for (Order order : orderList) { %>
			                <tr style="font-size:10px;">
			                    <td><input type="checkbox" name="orderCheckbox" value="<%= order.getOrderNumber() %>"></td>
			                    <td><a href="orderUpdate.jsp?orderNumber=<%= order.getOrderNumber() %>"><%= order.getOrderNumber() %></a></td>
			                    <td><%= order.getOrderDate() %></td>
			                    <td><%= order.getRefNumber() %></td>
			                    <td><%= order.getDepartureName() %></td>
			                    <td><%= order.getDepartureCities() + " " + order.getDepartureTown() %></td>
			                    <td><%= order.getArrivalName() %></td>
			                    <td><%= order.getArrivalCities() + " " + order.getArrivalTown() %></td>
			                    <td><%= order.getCarWeight() %></td>
			                    <td><%= order.getKindOfCar() %></td>
			                    <td><%= order.getCarNumber() != null ? order.getCarNumber() : "" %></td>
			                    <td><%= order.getDriverName() != null ? order.getDriverName() : "" %></td>
			                    <td><%= order.getDriverPhoneNum() != null ? order.getDriverPhoneNum() : "" %></td>
			                    <td><%= order.getBasicFare() + order.getAddFare() %></td>
			                    <td><%= order.getUserName() %></td>
			                    <td><%= order.getRegDate() %></td>
			                </tr>
			            <% } %> --%>
           			</tbody>
                </table>
            </div>
        </div>
    </div>
	
<script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
<script src="js/bootstrap.js"></script>
<script src="js/search.js"></script>
<script>
    function submitForm(action) {
        document.getElementById('searchForm').action = action;
        document.getElementById('searchForm').submit();
    }
</script>
</body>
</html>