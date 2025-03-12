<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" session="true"%>
<%@ page import="java.io.PrintWriter" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.List" %>
<%@ page import="arrival.ArrivalDAO" %>
<%@ page import="arrival.Arrival" %>
<%@ page import="departure.DepartureDAO" %>
<%@ page import="departure.Departure" %>
<%@ page import="user.UserDAO" %>
<%@ page import="user.User" %>
<%@ page import="org.apache.ibatis.session.SqlSessionFactory" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width", initial-scale="1">
<link rel="stylesheet" href="css/bootstrap.css">
<title>로지스톡 운송 오더 시스템</title>
<script>
    function deleteSelectedArrival() {
        let selectedArrival = [];
        
        // 체크된 체크박스 가져오기
        document.querySelectorAll('input[name="arrivalCheckbox"]:checked').forEach((checkbox) => {
        	selectedArrival.push(checkbox.value);
        });

        if (selectedArrival.length === 0) {
            alert("삭제할 출/도착지를 선택해주세요.");
            return;
        }

        if (!confirm("선택한 출/도착지를 삭제하시겠습니까?")) {
            return;
        }

        // 폼 생성 후 POST 요청
        let form = document.createElement("form");
        form.method = "POST";
        form.action = "deleteArrivalAction.jsp";

        selectedArrival.forEach(orderNumber => {
            let input = document.createElement("input");
            input.type = "hidden";
            input.name = "orderNumbers";
            input.value = orderNumber;
            form.appendChild(input);
        });

        document.body.appendChild(form);
        form.submit();
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
		String userCompany = userDAO.getUserCompany();
		

	    // DAO 생성 및 출/도착지 리스트 조회
	    ArrivalDAO arrivalDAO = new ArrivalDAO();
	    List<Arrival> arrivalList = arrivalDAO.getArrivalsByCompany(userType, userCompany);
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
				<li <%= "sales".equals( userType ) ? "style='display:none;'" : ""%>><a href="userModify.jsp">담당자 등록</a></li>
				<li class="active"><a href="arrivalModify.jsp">출/도착지 등록</a></li>
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
            <div class="panel-heading">출/도착지 등록</div>
            <div class="panel-body">
                <form id="searchForm" action="./arrivalRegisterAction.jsp" name="f">
                	<div class="text-right">
		            	<div class="btn-group">
			                <input type="button" class="btn btn-primary" onclick="rtn();" value="신규">
			                <button type="submit" class="btn btn-primary" style="margin-left: 10px;">저장</button>
		            	</div>
		            </div>
                	<div class="form-group row">
                        <label class="col-sm-2 control-label">* 출/도착지 구분:</label>
                        <div class="col-sm-3">
                        	<select name="type" class="form-control" required>
                                <option value="출발지">출발지</option>
                                <option value="도착지">도착지</option>
                            </select>
                        </div>
                    </div>
                    <div class="form-group row">
                    	<label class="col-sm-2 control-label">* 명칭:</label>
                        <div class="col-sm-3">
                            <input type="text" id="arrivalName" name="arrivalName" class="form-control" autocomplete="off" placeholder="명칭을 적어주세요.(명칭은 중복이 불가합니다.)" required>
                        </div>
                        <label class="col-sm-2 control-label">* 시/도:</label>
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
                                <option value="전라남도">전라남도</option>
                                <option value="강원도">강원도</option>
                                <option value="제주도">제주도</option>
                                <option value="세종특별자치시">세종특별자치시</option>
                            </select>
                        </div>
                    </div>
                    <div class="form-group row">
                    	<label class="col-sm-2 control-label">담당자 명:</label>
                        <div class="col-sm-3">
							<input type="text" name="arrivalManager" class="form-control" placeholder="담당자명 입력" required>
                        </div>
                        <label class="col-sm-2 control-label">시/군/구:</label>
                        <div class="col-sm-3">
                            <input type="text" name="arrivalTown" class="form-control" placeholder="시/군/구 입력" required>
                        </div>
                    </div>
                    <div class="form-group row">
                    	<label class="col-sm-2 control-label">담당자 연락처:</label>
                        <div class="col-sm-3">
                            <input type="text" name="arrivalManagerPhoneNum" class="form-control" placeholder="담당자 연락처(- 제외)입력" required>
                        </div>
                        <label class="col-sm-2 control-label">상세주소:</label>
                        <div class="col-sm-3">
                            <input type="text" name="arrivalDetailedAddress" class="form-control" placeholder="상세주소 입력" required>
                        </div>
                    </div>
                    <div class="form-group row">
                    	<label class="col-sm-2 control-label">기타사항:</label>
                        <div class="col-sm-8">
                            <input type="text" name="etc" class="form-control" placeholder="기타사항 입력">
                        </div>
                    </div>
                </form>
            </div>
        </div>
        <div class="panel panel-default">
            <div class="panel-heading">출/도착지 리스트
	            <div class="text-right">
					<button onclick="deleteSelectedArrival()" class="btn btn-danger">출/도착지 삭제</button>
	            </div>
            </div>
            <div class="panel-body">
				<table class="table table-bordered table-hover" border="1">
				    <tr style="font-size: 10px;">
				        <th>체크</th>
				        <th>출/도착지 구분</th>
				        <th>명칭</th>
				        <th>시/도</th>
				        <th>시/군/구</th>
				        <th>상세주소</th>
				        <th>담당자명</th>
				        <th>담당자 연락처</th>
				        <th>기타사항</th>
				        <th>등록일자</th>
				    </tr>
					<% for (Arrival arrival : arrivalList) { %>
				        <tr>
				            <td><input type="checkbox" name="arrivalCheckbox" value="<%= arrival.getArrivalID() %>"></td> 
				            <td><a href="arrivalUpdate.jsp?arrivalID=<%= arrival.getArrivalID() %>"><%= arrival.getArrivalID() %></a></td>
				            <td><%= arrival.getArrivalName() %></td>
				            <td><%= arrival.getArrivalCities() %></td>
				            <td><%= arrival.getArrivalManager() %></td>
				            <td><%= arrival.getArrivalTown() %></td>
				            <td><%= arrival.getArrivalManagerPhoneNum() %></td>
				            <td><%= arrival.getArrivalDetailedAddress() %></td>
				            <td><%= arrival.getEtc() %></td>
				            <td><%= arrival.getFormattedRegDate() %></td>
				        </tr>
			    	<% } %>
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