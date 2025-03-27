<%@ page contentType="text/html;charset=UTF-8" language="java" session="true"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="user.UserDAO" %>
<%@ page import="user.User" %>
<%@ page import="departure.DepartureDAO" %>
<%@ page import="departure.Departure" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.List" %>

<html>
<head>
    <title>출발지 조회</title>
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
        function selectDeparture(departureName, departureCities, departureTown, departureDetailedAddress, departureManager, departureManagerPhoneNum) {
        	if (window.opener && !window.opener.closed) {
                window.opener.document.getElementById("departureName").value = departureName;
                window.opener.document.getElementById("departureCities").value = departureCities;
                window.opener.document.getElementById("departureTown").value = departureTown;
                //window.opener.document.getElementById("departureTown").value = departureTown;
                window.opener.document.getElementById("departureDetailedAddress").value = departureDetailedAddress;
                window.opener.document.getElementById("departureManager").value = departureManager;
                window.opener.document.getElementById("departureManagerPhoneNum").value = departureManagerPhoneNum;
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
	    String departureName = request.getParameter("departureName");
	    String departureCities = request.getParameter("departureCities");
	    String departureTown = request.getParameter("departureTown");
	    String departureManager = request.getParameter("departureManager");

	    List<Departure> departureList = new ArrayList<>();
	    if (request.getParameter("search") != null) {
	    	DepartureDAO departureDAO = new DepartureDAO();
	    	departureList = departureDAO.getSearchDepartureByCompany( 
	            userType, userCompany, departureName, departureCities, departureTown, departureManager
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
        <div class="panel-heading">출발지 조회</div>
        <div class="panel-body">
            <form method="GET" action="searchDeparture.jsp">
                <div class="form-group row">
                    <label class="col-sm-2 control-label">출발지 명:</label>
                    <div class="col-sm-4">
                    	<input type="hidden" name="search" value="true">
                        <input type="text" id="departureName" name="departureName" class="form-control" placeholder="도착지 명" value="<%= departureName != null ? departureName : "" %>">
                    </div>
                    <label class="col-sm-2 control-label">시/도:</label>
                    <div class="col-sm-4">
                        <select id="departureCities" name="departureCities" class="form-control">
                        	<option value="">--선택--</option>
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
	                        <option value="전라남도">전라남도</option>
	                        <option value="강원도">강원도</option>
	                        <option value="제주도">제주도</option>
	                        <option value="세종특별자치시">세종특별자치시</option>
	                    </select>
                    </div>
                </div>

                <div class="form-group row">
                    <label class="col-sm-2 control-label">시/군/구:</label>
                    <div class="col-sm-4">
                        <input type="text" id="departureTown" name="departureTown" class="form-control" placeholder="시/군/구" value="<%= departureTown != null ? departureTown : "" %>">
                    </div>
                    <label class="col-sm-2 control-label">출발지 담당자:</label>
                    <div class="col-sm-4">
                        <input type="text" id="departureManager" name="departureManager" class="form-control" placeholder="담당자" value="<%= departureManager != null ? departureManager : "" %>">
                    </div>
                </div>

                <!-- 버튼 -->
                <div class="form-group text-center">
                    <button type="submit" class="btn btn-primary">조회</button>
                </div>
                <input type="hidden" name="userType" class="form-control" value="<%= userType %>">
                <input type="hidden" name="userCompany" class="form-control" value="<%= userCompany %>">
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
                        <th>출발지명</th>
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
					    if ( departureList != null && !departureList.isEmpty() ) {
					        for ( Departure departure : departureList ) {
					%>
					            <tr>
					                <td><%= departure.getDepartureName() %></td>
					                <td><%= departure.getDepartureCities() %></td>
					                <td><%= departure.getDepartureTown() %></td>
					                <td><%= departure.getDepartureDetailedAddress() %></td>
					                <td><%= departure.getDepartureManager() %></td>
					                <td><%= departure.getDepartureManagerPhoneNum() %></td>
					                <td>
					                    <button class="btn btn-primary"
					                            onclick="selectDeparture(
					                                '<%= departure.getDepartureName() %>',
					                                '<%= departure.getDepartureCities() %>',
					                                '<%= departure.getDepartureTown()  %>',
					                                '<%= departure.getDepartureDetailedAddress() %>',
					                                '<%= departure.getDepartureManager() %>',
					                                '<%= departure.getDepartureManagerPhoneNum() %>'
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