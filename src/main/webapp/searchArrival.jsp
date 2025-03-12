<%@ page contentType="text/html;charset=UTF-8" language="java" session="true"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="user.UserDAO" %>
<%@ page import="user.User" %>
<%@ page import="arrival.ArrivalDAO" %>
<%@ page import="arrival.Arrival" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.List" %>

<html>
<head>
    <title>도착지 조회</title>
    <!-- Bootstrap 3 CDN 추가 -->
    <link href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>

    <style>
        body {
            font-size: 14px;
        }

        .panel-heading {
            background-color: #337ab7;
            color: white;
            font-size: 16px;
            font-weight: bold;
            padding: 10px;
        }

        .form-control {
            height: 34px;
            font-size: 14px;
        }

        .btn-primary {
            background-color: #337ab7;
            border-color: #2e6da4;
        }

        .btn-danger {
            background-color: #d9534f;
            border-color: #d43f3a;
        }

        table th, table td {
            text-align: center;
            vertical-align: middle !important;
        }
    </style>

    <script>
	 	// 문자열의 특수문자를 처리해주는 함수
	    function escapeJavaScript(str) {
	        if (str) {
	            return str.replace(/\\/g, '\\\\')
	                      .replace(/'/g, '\\\'')
	                      .replace(/"/g, '\\\"')
	                      .replace(/\n/g, '\\n')
	                      .replace(/\r/g, '\\r');
	        }
	        return '';
	    }
        // 부모창에 값 세팅 함수
        function selectArrival(arrivalName, arrivalCities, arrivalTown, arrivalDetailedAddress, arrivalManager, arrivalManagerPhoneNum) {
        	if (window.opener && !window.opener.closed) {
                window.opener.document.getElementById("arrivalName").value = arrivalName;
                window.opener.document.getElementById("arrivalCities").value = arrivalCities;
                window.opener.document.getElementById("arrivalTown").value = arrivalTown;
                window.opener.document.getElementById("arrivalDetailedAddress").value = arrivalDetailedAddress;
                window.opener.document.getElementById("arrivalManager").value = arrivalManager;
                window.opener.document.getElementById("arrivalManagerPhoneNum").value = arrivalManagerPhoneNum;
            } else {
                alert("부모창이 열려있지 않습니다.");
            }

            // 팝업창 닫기
            setTimeout(function() {
                window.close();
            }, 100); // 100ms 딜레이 후 닫기
        }
    </script>
</head>
<body>

<div class="container">
	<%
		String userID = null;
		if (session.getAttribute("userID") != null) {
			userID = (String) session.getAttribute("userID");
		}
		
		String userType = request.getParameter("userType");
	    String userCompany = request.getParameter("userCompany");
	    String arrivalName = request.getParameter("arrivalName");
	    String arrivalCities = request.getParameter("arrivalCities");
	    String arrivalTown = request.getParameter("arrivalTown");
	    String arrivalManager = request.getParameter("arrivalManager");

	    List<Arrival> arrivalList = new ArrayList<>();
	    if (request.getParameter("search") != null) {
	        ArrivalDAO arrivalDAO = new ArrivalDAO();
	        arrivalList = arrivalDAO.getSearchArrivalByCompany(
	            userType, userCompany, arrivalName, arrivalCities, arrivalTown, arrivalManager
	        );
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
		}
	%>
	
    <!-- 조회 패널 -->
    <div class="panel panel-primary">
        <div class="panel-heading">도착지 조회</div>
        <div class="panel-body">
            <form method="GET" action="searchArrival.jsp">
                <div class="form-group row">
                    <label class="col-sm-2 control-label">도착지 명:</label>
                    <div class="col-sm-4">
                    	<input type="hidden" name="search" value="true">
                        <input type="text" name="arrivalName" class="form-control" placeholder="도착지 명" value="<%= arrivalName != null ? arrivalName : "" %>">
                    </div>
                    <label class="col-sm-2 control-label">시/도:</label>
                    <div class="col-sm-4">
                        <input type="text" name="arrivalCities" class="form-control" placeholder="시/도" value="<%= arrivalCities != null ? arrivalCities : "" %>">
                    </div>
                </div>

                <div class="form-group row">
                    <label class="col-sm-2 control-label">시/군/구:</label>
                    <div class="col-sm-4">
                        <input type="text" name="arrivalTown" class="form-control" placeholder="시/군/구" value="<%= arrivalTown != null ? arrivalTown : "" %>">
                    </div>
                    <label class="col-sm-2 control-label">담당자:</label>
                    <div class="col-sm-4">
                        <input type="text" name="arrivalManager" class="form-control" placeholder="담당자" value="<%= arrivalManager != null ? arrivalManager : "" %>">
                    </div>
                </div>

                <!-- 버튼 -->
                <div class="form-group text-center">
                    <button type="submit" class="btn btn-primary">조회</button>
                </div>
                <input type="hidden" name="userType" class="form-control" placeholder="담당자" value="<%= userType %>">
                <input type="hidden" name="userCompany" class="form-control" placeholder="담당자" value="<%= userCompany %>">
            </form>
        </div>
    </div>

    <!-- 조회 결과 패널 -->
    <div class="panel panel-default">
        <div class="panel-heading">조회 결과</div>
        <div class="panel-body">
            <table class="table table-bordered table-striped">
                <thead>
                    <tr>
                        <th>도착지명</th>
                        <th>시/도</th>
                        <th>시/군/구</th>
                        <th>상세주소</th>
                        <th>담당자</th>
                        <th>연락처</th>
                        <th>선택</th>
                    </tr>
                </thead>
                <tbody>
                    <%
					    if (arrivalList != null && !arrivalList.isEmpty()) {
					        for (Arrival arrival : arrivalList) {
					%>
					            <tr>
					                <td><%= arrival.getArrivalName() %></td>
					                <td><%= arrival.getArrivalCities() %></td>
					                <td><%= arrival.getArrivalTown() %></td>
					                <td><%= arrival.getArrivalDetailedAddress() %></td>
					                <td><%= arrival.getArrivalManager() %></td>
					                <td><%= arrival.getArrivalManagerPhoneNum() %></td>
					                <td>
					                    <button class="btn btn-primary"
					                            onclick="selectArrival(
					                                '<%= arrival.getArrivalName() %>',
					                                '<%= arrival.getArrivalCities() %>',
					                                '<%= arrival.getArrivalTown() %>',
					                                '<%= arrival.getArrivalDetailedAddress() %>',
					                                '<%= arrival.getArrivalManager() %>',
					                                '<%= arrival.getArrivalManagerPhoneNum() %>'
					                            )">
					                        선택
					                    </button>
					                </td>
					            </tr>
					<%
					        }
					    } else {
					%>
					        <tr>
					            <td colspan="7">검색 결과가 없습니다.</td>
					        </tr>
					<%
					    }
					%>
                </tbody>
            </table>

            <!-- 페이지네이션 -->
            <div class="text-center">
                <ul class="pagination">
                    <li class="disabled"><a href="#">«</a></li>
                    <li class="active"><a href="#">1</a></li>
                    <li class="disabled"><a href="#">»</a></li>
                </ul>
            </div>
        </div>
    </div>
</div>

</body>
</html>