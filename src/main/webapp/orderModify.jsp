<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter" %>
<%@ page import="insertOrder.OrderDAO" %>
<%@ page import="insertOrder.Order" %>
<%@ page import="java.util.ArrayList" %>
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
            document.getElementById("startDate").value = today;
            document.getElementById("endDate").value = today;
        });
</script>
<title>로지스톡 운송 오더 시스템</title>
</head>
<body>
<script>
	search.btn();
</script>
	<%
		String userID = null;
		if (session.getAttribute("userID") != null) {
			userID = (String) session.getAttribute("userID");
		}
		int pageNumber = 1;
		if (request.getParameter("pageNumber") != null ) {
			pageNumber = Integer.parseInt(request.getParameter("pageNumber"));
		}
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
				<li><a href="carModify.jsp">차량정보 수정</a></li>
				<li><a href="carModify.jsp">담당자 등록</a></li>
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
            <div class="panel-heading">화물조회</div>
            <div class="panel-body">
                <form id="frmBody" action="./orderModify.jsp">
                    <div class="form-group row">
                        <label class="col-sm-2 control-label">운송요청일:</label>
                        <div class="col-sm-4">
                            <input type="date" name="startDate" id="startDate" class="form-control" required>
                        </div>
                        <div class="col-sm-4">
                            <input type="date" name="endDate" id="endDate" class="form-control" required>
                        </div>
                    </div>
                    <div class="form-group row">
                        <label class="col-sm-2 control-label">참조번호:</label>
                        <div class="col-sm-3">
                            <input type="text" name="refNumber" class="form-control">
                        </div>
                        <label class="col-sm-2 control-label">담당자명:</label>
                        <div class="col-sm-3">
                            <select name="userName" class="form-control">
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
                    </div>
                    <div class="form-group row">
                        <label class="col-sm-2 control-label">출발지 명:</label>
                        <div class="col-sm-3">
                            <select name="departureName" class="form-control">
                                <option value="">Master data</option>
                            </select>
                        </div>
                        <label class="col-sm-2 control-label">도착지 명:</label>
                        <div class="col-sm-3">
                            <select name="arrivalName" class="form-control">
                                <option value="">Master data</option>
                            </select>
                        </div>
                    </div>
                    <div class="form-group row">
                        <label class="col-sm-2 control-label">도착지 시/도:</label>
                        <div class="col-sm-3">
							<select name="arrivalCities" class="form-control" required>
                                <option value="서울특별시">서울특별시</option>
                                <option value="경기도">경기도</option>
                                <option value="인천광역시">인천광역시</option>
                                <option value="부산광역시">부산광역시</option>
                                <option value="대전광역시">대전광역시</option>
                                <option value="광주광역시">광주광역시</option>
                                <option value="대구광역시">대구광역시</option>
                                <option value="울산광역시">울산광역시</option>
                                <option value="충청북도">충청북도</option>
                                <option value="충청남도">충청남도</option>
                                <option value="경상북도">경상북도</option>
                                <option value="경상남도">경상남도</option>
                                <option value="전라북도">전라북도</option>
                                <option value="전라북도">전라남도</option>
                                <option value="전라북도">강원도</option>
                                <option value="전라북도">제주도</option>
                                <option value="세종특별자치시">세종특별자치시</option>
                            </select>
                        </div>
                        <label class="col-sm-2 control-label">오더번호:</label>
                        <div class="col-sm-3">
                            <input type="text" name="orderNumber" class="form-control">
                        </div>
                    </div>
                    <div class="text-center">
                        <button type="submit" class="btn btn-primary" id="btnSearch">조회</button>
                    </div>
                </form>
            </div>
        </div>
        <div class="panel panel-default">
            <div class="panel-heading">조회 결과</div>
            <div class="panel-body">
                <table class="table table-bordered table-hover">
                    <thead>
                        <tr style="font-size: 10px;">
                            <th>체크</th>
                        	<th>오더번호</th>
                            <th>운송요청일</th>
                            <th>참조번호</th>
                            <th>출발지명</th>
                            <th>출발지 주소</th>
                            <th>도착지명</th>
                            <th>도착지 주소</th>
                            <th>화물톤급</th>
                            <th>차량종류</th>
                            <th>차량번호</th>
                            <th>기사명</th>
                            <th>기사연락처</th>
                            <th>운송비 금액</th>
                            <th>담당자명</th>
                            <th>등록일</th>
                        </tr>
                    </thead>
                    <tbody>
	                <%
	                	OrderDAO orderDAO = new OrderDAO();
	                	ArrayList<Order> list = orderDAO.getOrderList( pageNumber );
	                	for( int i = 0; i < list.size(); i++ ) {
	                %>
                        <tr style="font-size:10px;">
                        	<% if( list.get(i).getCarNumber() == null ) { %>
                            	<td><input type="checkbox"></td>
                            <% } else { %>
                            	<td style="font-color:red;">배차완료</td>
                            <% } %>
                            <td><%= list.get(i).getOrderNumber() %></td>
                            <td><%= list.get(i).getOrderDate() %></td>
                            <td><%= list.get(i).getRefNumber() %></td>
                            <td><%= list.get(i).getDepartureName() %></td>
                            <td><%= list.get(i).getDepartureCities() + " " + list.get(i).getDepartureTown() %></td>
                            <td><%= list.get(i).getArrivalName() %></td>
                            <td><%= list.get(i).getArrivalCities() + " " + list.get(i).getArrivalTown() %></td>
                            <td><%= list.get(i).getCarWeight() %></td>
                            <td><%= list.get(i).getKindOfCar() %></td>
                            <td><% out.print( list.get(i).getCarNumber() == null ? "" : list.get(i).getCarNumber() ); %></td>
                            <td><% out.print( list.get(i).getDriverName() == null ? "" : list.get(i).getDriverName() ); %></td>
	                        <td><% out.print( list.get(i).getDriverPhoneNum() == null ? "" : list.get(i).getDriverPhoneNum() ); %></td>
	                        <td><%= list.get(i).getBasicFare() + list.get(i).getAddFare() %></td>
                            <td><%= list.get(i).getUserName() %></td>
                            <td><%= list.get(i).getRegDate() %></td>
                        </tr>
	                <%
	                	}
	                %>
                    </tbody>
                </table>
                <%
                	if( pageNumber != 1 ) {
                %>
                	<a href="order.jsp?pageNumber=<%=pageNumber -1 %>" class="btn btn-success btn-arraw-left">이전</a>
                <% 
                	} if( orderDAO.nextPage(pageNumber + 1) ) {
                %>
                	<a href="order.jsp?pageNumber=<%=pageNumber +1 %>" class="btn btn-success btn-arraw-light">다음</a>
                <%
                	}
                %>
                <div class="text-center">
                    <button class="btn btn-success">엑셀다운</button>
                    <button class="btn btn-danger">요청취소</button>
                </div>
            </div>
        </div>
    </div>
	
	<script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
	<script src="js/bootstrap.js"></script>
	<script src="js/search.js"></script>
</body>
</html>