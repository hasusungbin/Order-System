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
        // 부모창에 값 세팅 함수
        function selectArrival(arrivalName, arrivalCities, arrivalTown, arrivalDetailedAddress, arrivalManager, arrivalManagerPhoneNum) {
            if (window.opener && !window.opener.closed) {
                window.opener.document.getElementById("arrivalName").value = arrivalName;
                window.opener.document.getElementById("arrivalCities").value = arrivalCities;
                window.opener.document.getElementById("arrivalTown").value = arrivalTown;
                window.opener.document.getElementById("arrivalDetailedAddress").value = arrivalDetailedAddress;
                window.opener.document.getElementById("arrivalManager").value = arrivalManager;
                window.opener.document.getElementById("arrivalManagerPhoneNum").value = arrivalManagerPhoneNum;
            }
            window.close(); // 팝업창 닫기
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
		System.out.println("userType: " + userType);
		System.out.println("userCompany: " + userCompany);
	    ArrivalDAO arrivalDAO = new ArrivalDAO();
	    List<Arrival> arrivalList = arrivalDAO.getSearchArrivalByCompany(userType, userCompany); // DAO에서 데이터 조회
	    System.out.println(arrivalList);
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
                        <input type="text" name="arrivalName" class="form-control" placeholder="도착지 명">
                    </div>
                    <label class="col-sm-2 control-label">시/도:</label>
                    <div class="col-sm-4">
                        <input type="text" name="arrivalCities" class="form-control" placeholder="시/도">
                    </div>
                </div>

                <div class="form-group row">
                    <label class="col-sm-2 control-label">시/군/구:</label>
                    <div class="col-sm-4">
                        <input type="text" name="arrivalTown" class="form-control" placeholder="시/군/구">
                    </div>
                    <label class="col-sm-2 control-label">담당자:</label>
                    <div class="col-sm-4">
                        <input type="text" name="arrivalManager" class="form-control" placeholder="담당자">
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
                    <c:choose>
                        <c:when test="${not empty arrivalList}">
                            <c:forEach var="arrival" items="${arrivalList}">
                                <tr>
                                	<c:if test="${empty arrivalList}">
									    <p>도착지 목록이 없습니다.</p>
									</c:if>
									
									<c:if test="${not empty arrivalList}">
									    <p>${arrivalList}</p> <!-- 리스트 값 확인 -->
									</c:if>
                                    <td>${arrival.arrivalName}</td>
                                    <td>${arrival.arrivalCities}</td>
                                    <td>${arrival.arrivalTown}</td>
                                    <td>${arrival.arrivalDetailedAddress}</td>
                                    <td>${arrival.arrivalManager}</td>
                                    <td>${arrival.arrivalManagerPhoneNum}</td>
                                    <td>
                                        <button class="btn btn-primary"
                                                onclick="selectArrival(
                                                    '${arrival.arrivalName}',
                                                    '${arrival.arrivalCities}',
                                                    '${arrival.arrivalTown}',
                                                    '${arrival.arrivalDetailedAddress}',
                                                    '${arrival.arrivalManager}',
                                                    '${arrival.arrivalManagerPhoneNum}'
                                                )">
                                            선택
                                        </button>
                                    </td>
                                </tr>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <tr>
                                <td colspan="7">검색 결과가 없습니다.</td>
                            </tr>
                        </c:otherwise>
                    </c:choose>
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