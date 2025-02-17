<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter" %>
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
                <form method="post" id="frmBody">
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
                            <input type="text" name="referenceNumber" class="form-control">
                        </div>
                        <label class="col-sm-2 control-label">담당자명:</label>
                        <div class="col-sm-3">
                            <select name="personInCharge" class="form-control">
                                <option value="">Master data</option>
                            </select>
                        </div>
                    </div>
                    <div class="form-group row">
                        <label class="col-sm-2 control-label">출발지 명:</label>
                        <div class="col-sm-3">
                            <select name="personInCharge" class="form-control">
                                <option value="">Master data</option>
                            </select>
                        </div>
                        <label class="col-sm-2 control-label">도착지 명:</label>
                        <div class="col-sm-3">
                            <select name="arrival" class="form-control">
                                <option value="">Master data</option>
                            </select>
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
                    <div class="text-center">
                        <button type="submit" class="btn btn-primary" id="btnSearch">조회</button>
                        <input type="hidden" name="nowPage" />
                    </div>
                </form>
            </div>
        </div>
        <div class="panel panel-default">
            <div class="panel-heading">조회 결과</div>
            <div class="panel-body">
                <table class="table table-bordered table-hover">
                    <thead>
                        <tr>
                            <th>체크</th>
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
                        <tr>
                            <td><input type="checkbox"></td>
                            <td>2025-02-08</td>
                            <td>123456</td>
                            <td>우리은행</td>
                            <td>경기도 화성시</td>
                            <td>산업은행</td>
                            <td>경기도 파주시</td>
                            <td>5톤</td>
                            <td>윙바디</td>
                            <td>12가1234</td>
                            <td>김길동</td>
                            <td>010-1234-1234</td>
                            <td>130,000</td>
                            <td>김기찬</td>
                            <td>2025-02-07</td>
                        </tr>
                    </tbody>
                </table>
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