<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
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
		
		OrderDAO orderDAO = new OrderDAO();
		
		String pageNumberStr = request.getParameter("pageNumber");
	    int pageNumber = (pageNumberStr != null) ? Integer.parseInt(pageNumberStr) : 1;
	    int pageSize = 10;
		
		String startDate = request.getParameter("startDate");
	    String endDate = request.getParameter("endDate");
	    String refNumberStr = request.getParameter("refNumber");
	    Integer refNumber = (refNumberStr != null && !refNumberStr.isEmpty()) ? Integer.parseInt(refNumberStr) : null;
	    String userName = request.getParameter("userName");
	    String departureName = request.getParameter("departureName");
	    String arrivalName = request.getParameter("arrivalName");
	    String arrivalCities = request.getParameter("arrivalCities");
	    String orderNumber = request.getParameter("orderNumber");
	    
	    
	    
	    try {
	        if (refNumberStr != null && !refNumberStr.isEmpty()) {
	            refNumber = Integer.parseInt(refNumberStr);
	        }
	    } catch (NumberFormatException e) {
	        refNumber = 0; // 숫자가 아닌 값이 들어오면 무시
	    }
	    
	    int totalCount = orderDAO.getTotalCount( startDate, endDate, refNumber, userName, departureName, arrivalName, arrivalCities, orderNumber);
	    int totalPages = (int) Math.ceil((double) totalCount / pageSize);
		
	    List<Order> orderList = orderDAO.getPagedList(pageNumber, pageSize, startDate, endDate, refNumber, userName, departureName, arrivalName, arrivalCities, orderNumber);
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
                <form id="searchForm" action="./orderModify.jsp">
                    <div class="form-group row">
                        <label class="col-sm-2 control-label" style="font-size:12px;">운송요청일(출발일 ~ 도착일):</label>
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
                            <input type="number" name="refNumber" class="form-control">
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
                            <input type="hidden" name="pageNumber" class="form-control" value="1">
                        </div>
                    </div>
                    <div class="text-center">
                    	<button type="submit" class="btn btn-primary" onclick="submitForm('orderModify.jsp')">조회</button>
                    </div>
                    <div class="text-center" style="margin-top:5%;">
	                	<%-- <%
	                		for( int i = 0; i < orderList.size(); i++ ) {
	               		%>
		                	<input type="hidden" name="startDate" value="<%= orderList.get(i).getStartDate() != null ? orderList.get(i).getStartDate() : "" %>">
		                	<input type="hidden" name="endDate" value="<%= orderList.get(i).getEndDate() != null ? orderList.get(i).getEndDate() : "" %>">
						    <input type="hidden" name="refNumber" value="<%= orderList.get(i).getRefNumber() != 0 ? orderList.get(i).getRefNumber() : "" %>">
						    <input type="hidden" name="userName" value="<%= orderList.get(i).getUserName() != null ? orderList.get(i).getUserName() : "" %>">
						    <input type="hidden" name="departureName" value="<%= orderList.get(i).getDepartureName() != null ? orderList.get(i).getDepartureName() : "" %>">
						    <input type="hidden" name="arrivalName" value="<%= orderList.get(i).getArrivalName() != null ? orderList.get(i).getArrivalName() : "" %>">
						    <input type="hidden" name="arrivalCities" value="<%= orderList.get(i).getArrivalCities() != null ? orderList.get(i).getArrivalCities() : "" %>">
						    <input type="hidden" name="orderNumber" value="<%= orderList.get(i).getOrderNumber() != null ? orderList.get(i).getOrderNumber() : "" %>">
						<%
	                		}
	                	%> --%>					    
					    <button type="button" class="btn btn-success" onclick="submitForm('downloadExcel')">엑셀 다운로드</button>
                </div>
                </form>
            </div>
        </div>
        <div class="panel panel-default">
            <div class="panel-heading">조회 결과
	            <div class="text-right">
					<button class="btn btn-danger">요청취소</button>
	            </div>
            </div>
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
	                	for( int i = 0; i < orderList.size(); i++ ) {
	                %>
                        <tr style="font-size:10px;">
                        	<% if( orderList.get(i).getCarNumber() == null ) { %>
                            	<td><input type="checkbox"></td>
                            <% } else { %>
                            	<td style="font-color:red;">배차완료</td>
                            <% } %>
                            <td><%= orderList.get(i).getOrderNumber() %></td>
                            <td><%= orderList.get(i).getOrderDate() %></td>
                            <td><%= orderList.get(i).getRefNumber() %></td>
                            <td><%= orderList.get(i).getDepartureName() %></td>
                            <td><%= orderList.get(i).getDepartureCities() + " " + orderList.get(i).getDepartureTown() %></td>
                            <td><%= orderList.get(i).getArrivalName() %></td>
                            <td><%= orderList.get(i).getArrivalCities() + " " + orderList.get(i).getArrivalTown() %></td>
                            <td><%= orderList.get(i).getCarWeight() %></td>
                            <td><%= orderList.get(i).getKindOfCar() %></td>
                            <td><% out.print( orderList.get(i).getCarNumber() == null ? "" : orderList.get(i).getCarNumber() ); %></td>
                            <td><% out.print( orderList.get(i).getDriverName() == null ? "" : orderList.get(i).getDriverName() ); %></td>
	                        <td><% out.print( orderList.get(i).getDriverPhoneNum() == null ? "" : orderList.get(i).getDriverPhoneNum() ); %></td>
	                        <td><%= orderList.get(i).getBasicFare() + orderList.get(i).getAddFare() %></td>
                            <td><%= orderList.get(i).getUserName() %></td>
                            <td><%= orderList.get(i).getRegDate() %></td>
                        </tr>
	                <%
	                	}
	                %>
                    </tbody>
                </table>
                <div class="text-center">
	                <% if (pageNumber > 1) { %>
	    				<a href="orderModify.jsp?pageNumber=<%= pageNumber - 1 %>" class="btn btn-success btn-arraw-left">이전</a>
					<% } %>
						Page <%= pageNumber %> of <%= totalPages %>
					<% if (pageNumber < totalPages) { %>
	    				<a href="orderModify.jsp?pageNumber=<%= pageNumber + 1 %>" class="btn btn-success btn-arraw-light">다음</a>
					<% } %>
                </div>
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