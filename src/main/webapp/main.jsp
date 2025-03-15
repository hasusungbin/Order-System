<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" session="true"%>
<%@ page import="java.io.PrintWriter" %>
<%@ page import="user.UserDAO" %>
<%@ page import="user.User" %>
<%@ page import="departure.DepartureDAO" %>
<%@ page import="departure.Departure" %>
<%@ page import="arrival.ArrivalDAO" %>
<%@ page import="arrival.Arrival" %>
<%@ page import="carInfo.CarInfoDAO" %>
<%@ page import="carInfo.CarInfo" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.List" %>
<%@ page import="org.apache.ibatis.session.SqlSession" %>
<%@ page import="org.apache.ibatis.session.SqlSessionFactory" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.util.TimeZone" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width">
<link rel="stylesheet" href="css/bootstrap.css">
<!-- jQuery 공식 CDN -->
<!-- Bootstrap 3 JS -->
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
<script src="https://code.jquery.com/jquery-3.6.4.min.js"></script>
<!-- Moment.js (필수) -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.29.1/moment.min.js"></script>
<!-- Bootstrap Datetimepicker JS -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-datetimepicker/4.17.47/js/bootstrap-datetimepicker.min.js"></script>
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
        
        function openDeparturePopup() {
        	var userType = '<%= session.getAttribute("userType") %>';
            var userCompany = '<%= session.getAttribute("userCompany") %>';
            window.open("searchDeparture.jsp?userType=" + userType + "&userCompany=" + userCompany,
                        "DepartureSearch", "width=800,height=600");
        }
        
        function openArrivalPopup() {
            var userType = '<%= session.getAttribute("userType") %>';
            var userCompany = '<%= session.getAttribute("userCompany") %>';
            window.open("searchArrival.jsp?userType=" + userType + "&userCompany=" + userCompany,
                        "ArrivalSearch", "width=800,height=600");
        }
</script>
<script>
        $(document).ready(function() {
            // ✅ jQuery 로드 확인
            console.log("window.$ 값: ", window.$); // undefined -> jQuery 로드 실패
            if (window.$) {
                console.log("✅ jQuery 로드 성공");
            } else {
                console.error("❌ jQuery 로드 실패");
            }
        });
</script>
<script>
    $(document).ready(function () {
        $('#datetimepicker').datetimepicker({
            format: 'YYYY-MM-DD HH:mm', // 날짜 및 시간 형식 (24시간제)
            showTodayButton: true, // 오늘 날짜 선택 버튼 추가
            stepping: 30 // 30분 단위로 선택 가능
        });
    });
</script>
<style>
	#datetimepicker {
	    max-width: 300px; /* 전체 너비 조정 */
	}
</style>
<title>로지스톡 운송 오더 시스템</title>
</head>
<body>
	<%
		String userID = null;
		if (session.getAttribute("userID") != null) {
			userID = (String) session.getAttribute("userID");
		}
		
		UserDAO userDAO = new UserDAO();
        userDAO.setSession(session);
        String userType = userDAO.getUserType();
        String userCompany = userDAO.getUserCompany();
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
				<li class="active"><a href="main.jsp">운송오더 등록</a></li>
			</ul>
			<ul class="nav navbar-nav">
				<li><a href="orderModify.jsp">운송오더 조회/취소</a></li>
			</ul>
			<ul class="nav navbar-nav">
				<li <%= "sales".equals( userType ) ? "style='display:none;'" : ""%>><a href="userModify.jsp">담당자 등록</a></li>
				<li><a href="arrivalModify.jsp">출/도착지 등록</a></li>
				<li><a href="carInfoModify.jsp">고정차량 등록</a></li>
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
	<script>
		function rtn() {
			f.reset();
		}
	</script>
	<%
	    SimpleDateFormat outputFormat = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm");
	    String formattedOrderDate = outputFormat.format(new Date());
	%>
	<script>
	    document.addEventListener("DOMContentLoaded", function() {
	        const orderDateInput = document.getElementById("orderDate");
	        if (!orderDateInput.value) {
	            orderDateInput.value = "<%= formattedOrderDate %>";
	        }
	    });
	</script>
	<script>
	document.addEventListener("DOMContentLoaded", function () {
	    let datetimeInput = document.getElementById("datetimepicker");

	    datetimeInput.addEventListener("change", function () {
	        let inputValue = this.value;

	        // 입력된 값이 비어있지 않은 경우만 처리
	        if (inputValue) {
	            let date = new Date(inputValue);

	            // 현재 분 값 가져오기
	            let minutes = date.getMinutes();

	            // 30분 단위로 반올림
	            let roundedMinutes = Math.round(minutes / 30) * 30;

	            // 원래 날짜와 시간은 유지하면서 분만 조정
	            date.setMinutes(roundedMinutes);
	            date.setSeconds(0);

	            // 올바른 형식(YYYY-MM-DDTHH:MM)으로 변환 후 반영
	            let year = date.getFullYear();
	            let month = String(date.getMonth() + 1).padStart(2, '0');
	            let day = String(date.getDate()).padStart(2, '0');
	            let hours = String(date.getHours()).padStart(2, '0');
	            let mins = String(date.getMinutes()).padStart(2, '0');

	            this.value = `${year}-${month}-${day}T${hours}:${mins}`;
	        }
	    });
	});
	</script>
<form action="writeAction.jsp" method="post" name="f">
	<div class="container">
        <div class="panel panel-primary">
            <div class="panel-heading">화물등록 일반</div>
            <div class="panel-body">
	            <div class="text-right">
	            	<div class="btn-group">
		                <input type="button" class="btn btn-primary" onclick="rtn();" value="신규">
		                <button type="submit" class="btn btn-primary" style="margin-left: 10px;" onclick="insertOrder();">저장</button>
	            	</div>
	            </div>
                   <div class="form-group row">
                       <label class="col-sm-2 control-label" ><a class="text-danger">* 운송요청일:</a></label>
                       <div class="col-sm-4">
                           <input type="datetime-local" name="orderDate" id="orderDate" class="form-control" required value="<%= formattedOrderDate %>">
                           <input type="hidden" name="userType" id="userType" value="<%= userType %>">
                           <input type="hidden" name="userCompany" id="userCompany" value="<%= userCompany %>">
                       </div>
                   </div>
                   <div class="form-group row">
                       <label class="col-sm-2 control-label"><a class="text-danger">* 담당자명:</a></label>
                       <%
	                    	String userType2 = userDAO.getUserType();
	                        String userName2 = userDAO.getUserName();
	                        List<String> salesUserList = userDAO.getSalesUsersInCompany();
	                        
	                    	List<User> userList = userDAO.getUserList();
                        %>
                       <div class="col-sm-3">
                           <select name="userName" class="form-control" required>
                           	<%
							        if ("sales".equals(userType2)) { // 본인 이름만 선택 가능
							    %>
							        <option value="<%= userName2 %>"><%= userName2 %></option>
							    <%
							        } else if ("manager".equals(userType2)) { // 같은 userCompany에 속한 sales 계정 선택 가능
							            for (String salesUser : salesUserList) {
							    %>
							        <option value="<%= salesUser %>"><%= salesUser %></option>
							    <%
							            }
							        } else if( "admin".equals(userType2) ) {
							        	for( int i = 0; i < userList.size(); i++ ) {
							    %>
							    	<option><%= userList.get(i).getUserName() %></option>
							    <%
							       		}
							        }
							    %>
                       		</select>
                       </div>
                       <label class="col-sm-2 control-label">연락처:</label>
                       <div class="col-sm-3">
                           <input type="text" name="userPhoneNumber" class="form-control" placeholder="-없이 입력해주세요.">
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
                       		<option value="">--선택--</option>
                       <%
                       	CarInfoDAO carInfoDAO = new CarInfoDAO();
                       	List<CarInfo> carInfoList = carInfoDAO.getCarInfosByCompany( userType2, userCompany );
                       	
                       	for( CarInfo carInfo : carInfoList) {
                       %>
                               <option value="<%= carInfo.getCarNumber() %>"><%= carInfo.getCarNumber() %></option>
                       <%
                       	}
                       %>
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
                            <input type="number" name="refNumber" class="form-control">
                        </div>
                    <label class="col-sm-2 control-label">품목:</label>
                       <div class="col-sm-5">
                       	<input type="text" name="item" class="form-control">
                       </div>
                </div>
                <div class="form-group row">
                	<label class="col-sm-2 control-label">기타:</label>
                        <div class="col-sm-10">
                            <input type="text" name="etc" id="etc" class="form-control">
                        </div>
				</div>
            </div>
        </div>
	</div>
	<div class="container">
        <div class="panel panel-primary">
            <div class="panel-heading">화물등록 상세(출발지 등록)</div>
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
                            <input type="text" name="departureName" id="departureName" class="form-control">
                        </div>
                        <button type="button" onclick="openDeparturePopup()">🔍</button>
                    </div>
                    <div class="form-group row">
                        <label class="col-sm-2 control-label"><a class="text-danger">* 시/도:</a></label>
                        <div class="col-sm-3">
                            <select name="departureCities" class="form-control" required>
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
                    	 <label class="col-sm-2 control-label"><a class="text-danger">* 시/군/구:</a></label>
                        <div class="col-sm-3">
                        	<input type="text" name="departureTown" id="departureTown" class="form-control" required>
                        </div>
                    </div>
                    <div class="form-group row">
                        <label class="col-sm-2 control-label">상세주소:</label>
                        <div class="col-sm-8">
                            <input type="text" name="departureDetailedAddress" class="form-control">
                        </div>
                    </div>
                    <div class="form-group row">
                    	<label class="col-sm-2 control-label">출발지 담당자:</label>
                        <div class="col-sm-3">
                        	<input type="text" name="departureManager" class="form-control">
                        </div>
                        <label class="col-sm-2 control-label">연락처:</label>
                        <div class="col-sm-3">
                        	<input type="text" name="departureManagerPhoneNum" class="form-control">
                        	<input type="hidden" name="departureEtc" value="">
                        </div>
                    </div>
            </div>
        </div>
	</div>
	<div class="container">
        <div class="panel panel-primary">
            <div class="panel-heading">화물등록 상세(도착지 등록)</div>
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
                        	<input type="text" name="arrivalName" id="arrivalName" class="form-control">
                        </div>
                        <button type="button" onclick="openArrivalPopup()">🔍</button>
                    </div>
                    <div class="form-group row">
                        <label class="col-sm-2 control-label"><a class="text-danger">* 시/도:</a></label>
                        <div class="col-sm-3">
                            <select id= "arrivalCities" name="arrivalCities" class="form-control" required>
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
                    	<label class="col-sm-2 control-label"><a class="text-danger">* 시/군/구:</a></label>
                        <div class="col-sm-3">
                        	<input type="text" id="arrivalTown" name="arrivalTown" class="form-control">
                        </div>
                    </div>
                    <div class="form-group row">
                        <label class="col-sm-2 control-label">상세주소:</label>
                        <div class="col-sm-8">
                            <input type="text" name="arrivalDetailedAddress" class="form-control">
                        </div>
                    </div>
                    <div class="form-group row">
                    	<label class="col-sm-2 control-label">도착지 담당자:</label>
                        <div class="col-sm-3">
                        	<input type="text" name="arrivalManager" class="form-control">
                        </div>
                        <label class="col-sm-2 control-label">연락처:</label>
                        <div class="col-sm-3">
                        	<input type="text" name="arrivalManagerPhoneNum" class="form-control">
                        	<input type="hidden" name="arrivalEtc" value="">
                        </div>
                    </div>
            </div>
        </div>
	</div>
	<div class="container">
        <div class="panel panel-primary">
            <div class="panel-heading">옵션</div>
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
</form>
	<%
		}	
	%>
</body>
</html>