<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" session="true"%>
<%@ page import="java.io.PrintWriter" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.List" %>
<%@ page import="carInfo.CarInfoDAO" %>
<%@ page import="carInfo.CarInfo" %>
<%@ page import="user.UserDAO" %>
<%@ page import="user.User" %>
<%@ page import="org.apache.ibatis.session.SqlSessionFactory" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width">
<link rel="stylesheet" href="css/bootstrap.css">
<title>로지스톡 운송 오더 시스템</title>
<script>
    function deleteSelectedCarInfo() {
        let selectedCarInfo = [];
        
        // 체크된 체크박스 가져오기
        document.querySelectorAll('input[name="carInfoCheckbox"]:checked').forEach((checkbox) => {
        	selectedCarInfo.push(checkbox.value);
        });

        if (selectedCarInfo.length === 0) {
            alert("삭제할 고정차량을 선택해주세요.");
            return;
        }

        if (!confirm("선택한 고정차량을 삭제하시겠습니까?")) {
            return;
        }

        // 폼 생성 후 POST 요청
        let form = document.createElement("form");
        form.method = "POST";
        form.action = "deleteCarInfoAction.jsp";

        selectedCarInfo.forEach(carNumber => {
            let input = document.createElement("input");
            input.type = "hidden";
            input.name = "carNumbers";
            input.value = carNumber;
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
	    CarInfoDAO carInfoDAO = new CarInfoDAO(); 
	    List<CarInfo> carInfoList = carInfoDAO.getCarInfosByCompany(userType, userCompany); 
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
				<li <%= "sales".equals( userType ) ? "style='display:none;'" : ""%>><a href="userModify.jsp">담당자 등록</a></li>
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
		<li><p style="margin-top: 15px;">환영합니다. <%= userID %>님.</p><li>
	</ul>
		</div>	
	</nav>
	<div class="container">
        <div class="panel panel-primary">
            <div class="panel-heading">고정차량 등록</div>
            <div class="panel-body">
                <form id="searchForm" action="./carInfoRegisterAction.jsp" name="f">
                	<div class="text-right">
		            	<div class="btn-group">
			                <input type="button" class="btn btn-primary" onclick="rtn();" value="신규">
			                <button type="submit" class="btn btn-primary" style="margin-left: 10px;">저장</button>
		            	</div>
		            </div>
                	<div class="form-group row">
                        <label class="col-sm-2 control-label"><a class="text-danger">* 차량번호:</a></label>
                        <div class="col-sm-3">
							<input type="text" id="carNumber" name="carNumber" class="form-control" autocomplete="off" placeholder="차량번호 입력" required>
                        </div>
                        <%
                        	if( userType.equals("admin") ) {
                        %>
                        	<label class="col-sm-2 control-label">회사:</label>
	                        <div class="col-sm-3">
								<select name="userCompany" class="form-control">
									<option value="">--선택--</option>
									<option value="KCC글라스">KCC글라스</option>
									<option value="(주)쎄레코">(주)쎄레코</option>
									<option value="(주)JKC 코퍼레이션">(주)JKC 코퍼레이션</option>
									<option value="코스모프로">코스모프로</option>
									<option value="(주)발렉스">(주)발렉스</option>
								</select>
	                        </div>
                        <%
                        	}
                        %>
                    </div>
                    <div class="form-group row">
                    	<label class="col-sm-2 control-label">기사명:</label>
                        <div class="col-sm-3">
                            <input type="text" id="driverName" name="driverName" class="form-control" autocomplete="off" placeholder="기사명 입력">
                        </div>
                        <label class="col-sm-2 control-label">차량 톤급:</label>
                        <div class="col-sm-3">
                        	<select name="carWeight" class="form-control">
                        		<option value="">--선택--</option>
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
                    </div>
                    <div class="form-group row">
                    	<label class="col-sm-2 control-label">기사 연락처:</label>
                        <div class="col-sm-3">
							<input type="text" name="driverPhoneNumber" class="form-control" placeholder="기사 연락처 입력">
                        </div>
                        <label class="col-sm-2 control-label">차량 종류:</label>
                        <div class="col-sm-3">
                            <select name="kindOfCar" class="form-control">
                               <option value="">--선택--</option>
                               <option value="카고">카고</option>
                               <option value="윙바디">윙바디</option>
                               <option value="탑">탑</option>
                               <option value="냉동/냉장">냉동/냉장</option>
                           </select>
                        </div>
                    </div>
                </form>
            </div>
        </div>
        <div class="panel panel-default">
        	<div class="panel-heading" style="display: flex; justify-content: space-between; align-items: center;">
			    <p style="font-weight: bold; margin: 0;">고정차량 리스트</p>
			    <div>
			        <button onclick="deleteSelectedOrders()" class="btn btn-danger">고정차량 삭제</button>
			    </div>
			</div>
            <div class="panel-body">
				<table class="table table-bordered table-hover" border="1">
				    <tr style="font-size: 10px;">
				    	<th>체크</th>
				        <th>차량번호</th>
				        <th>차량 톤급</th>
				        <th>차량종류</th>
				        <th>기사명</th>
				        <th>기사 연락처</th>
				        <th>등록일자</th>
				        <%
				        	if( userType.equals("admin") ) {
				        %>
				        	<th>등록 회사명</th>
				        <%
				        	}
				        %>
				    </tr>
					<% for (CarInfo carInfo : carInfoList) { %>
				        <tr>
				            <td><input type="checkbox" name="carInfoCheckbox" value="<%= carInfo.getCarNumber() %>"></td>
				            <td><a href="carInfoUpdate.jsp?carNumber=<%= carInfo.getCarNumber() %>"><%= carInfo.getCarNumber() %></a></td>
				            <td><%= carInfo.getCarWeight() == null ? "" : carInfo.getCarWeight() %></td>
				            <td><%= carInfo.getKindOfCar() == null ? "" : carInfo.getKindOfCar() %></td>
				            <td><%= carInfo.getDriverName() == null ? "" : carInfo.getDriverName()  %></td>
				            <td><%= carInfo.getDriverPhoneNumber() == null ? "" : carInfo.getDriverPhoneNumber()  %></td>
				            <td><%= carInfo.getFormattedRegDate() %></td>
				            <%
				            	if( userType.equals("admin") ) {
				            %>
				            	<td><%= carInfo.getUserCompany() == null ? "" : carInfo.getUserCompany() %></td>
				            <%
				        		}
				       		%>
				        </tr>
			    	<% } %>
				</table>
            </div>
        </div>
    </div>
<% } %>
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