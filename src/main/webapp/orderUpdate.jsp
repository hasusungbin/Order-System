<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" session="true"%>
<%@ page import="java.io.PrintWriter" %>
<%@ page import="insertOrder.OrderDAO" %>
<%@ page import="insertOrder.Order" %>
<%@ page import="carInfo.CarInfoDAO" %>
<%@ page import="carInfo.CarInfo" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.List" %>
<%@ page import="user.UserDAO" %>
<%@ page import="user.User" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width">
<link rel="stylesheet" href="css/bootstrap.css">
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
<script src="https://code.jquery.com/jquery-3.6.4.min.js"></script>
<!-- Moment.js (필수) -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.29.1/moment.min.js"></script>
<!-- Bootstrap Datetimepicker JS -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-datetimepicker/4.17.47/js/bootstrap-datetimepicker.min.js"></script>
<script>
    document.addEventListener('DOMContentLoaded', () => {
        const carNumberInput = document.getElementById('carNumber'); // 일반 차량번호 입력 필드
        const fixedCarSelect = document.getElementById('fixedCarNumber'); // 고정 차량 선택 필드

        function validateCarInput() {
            const carNumberValue = carNumberInput.value.trim(); // 공백 제거
            const fixedCarValue = fixedCarSelect.value.trim(); // 공백 제거
            
            // ✅ 둘 다 값이 존재하면 alert 발생
            if (carNumberValue !== '' && fixedCarValue !== '') {
                alert("고정차량과 일반차량 중 한 곳만 입력해야 합니다.");
                
                // ⚠️ focus를 설정해서 사용자가 수정하도록 유도
                carNumberInput.focus(); 
                
                // ✅ 중복 입력 상태를 방지하기 위해 기존 입력 초기화 (선택사항)
                carNumberInput.value = '';
                fixedCarSelect.value = '';
            }
        }

        // ✅ 입력 필드나 select 값이 변경될 때마다 체크 실행
        carNumberInput.addEventListener('input', validateCarInput);
        fixedCarSelect.addEventListener('change', validateCarInput);
    });
</script>
<script>
	function formatAmount(input) {
	    let value = input.value.replaceAll(',', '').replace(/\D/g, '');
	    input.value = value.replace(/\B(?=(\d{3})+(?!\d))/g, ',');
	}
</script>
<script>
  // 스크롤 감지
  $(window).scroll(function () {
    if ($(this).scrollTop() > 200) {
      $('#scrollTopBtn').fadeIn();
    } else {
      $('#scrollTopBtn').fadeOut();
    }
  });

  // 버튼 클릭 시 맨 위로 이동
  $('#scrollTopBtn').click(function (e) {
    e.preventDefault();
    $('html, body').animate({ scrollTop: 0 }, 600);
  });
</script>
<title>로지스톡 운송 오더 시스템</title>
</head>
<body>
	<%
		String userID = null;
		if (session.getAttribute("userID") != null) {
			userID = (String) session.getAttribute("userID");
		}
		
		OrderDAO orderDAO = new OrderDAO();
		UserDAO userDAO = new UserDAO();
		orderDAO.setSession(session);
		String userType = orderDAO.getUserType();
		String userCompany = userDAO.getUserCompany( userID );
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
			<button type="button" class="navbar-toggle" data-toggle="collapse" data-target="#bs-example-navbar-collapse-1">
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
				<li class="active"><a href="orderModify.jsp">운송오더 조회/취소</a></li>
			</ul>
			<ul class="nav navbar-nav">
				<li><a href="userModify.jsp">담당자 등록</a></li>
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
	<script src="js/bootstrap.js"></script>
	<script>
		function rtn() {
			f.reset();
		}
	</script>
<form action="updateAction.jsp" method="post" name="f">
		<%
            String orderNumber = request.getParameter("orderNumber");
            Order order = orderDAO.getOrderById( orderNumber );
        %>
	<div class="container">
        <div class="panel panel-primary">
            <div class="panel-heading">화물등록 수정</div>
            <div class="panel-body">
	            <div class="text-right">
	            	<div class="btn-group">
		                <button type="submit" class="btn btn-primary" style="margin-left: 10px;">저장</button>
	            	</div>
	            </div>
                   <div class="form-group row">
                       <label class="col-sm-2 control-label" ><a class="text-danger">* 운송요청일:</a></label>
                       <div class="col-sm-3">
                       		<input type="hidden" name="orderNumber" value="<%= order.getOrderNumber() %>">
                       		<%
	                       		String formattedOrderDate = "";
	                       	    if (order.getOrderDate() != null && !order.getOrderDate().trim().isEmpty()) {
	                       	        try {
	
	                       	            // ✅ String → Date 변환 (포맷을 정확히 맞추기)
	                       	            SimpleDateFormat inputFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss"); // DB 저장 형식 확인
	                       	            Date date = inputFormat.parse(order.getOrderDate().trim()); // 공백 제거 후 변환
	
	                       	            // ✅ Date → String 변환 (input type=datetime-local 형식에 맞추기)
	                       	            SimpleDateFormat outputFormat = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm");
	                       	            formattedOrderDate = outputFormat.format(date);
	
	                       	            // ✅ 변환된 값 디버깅 로그 출력
	
	                       	        } catch (Exception e) {
	                       	            e.printStackTrace(); // 변환 오류 확인
	                       	        }
	                       	    }
							%>
                       		<input type="datetime-local" name="orderDate" id="orderDate" class="form-control" required value="<%= formattedOrderDate %>">
                       </div>
                   </div>
                   <div class="form-group row">
                       <label class="col-sm-2 control-label"><a class="text-danger">* 담당자명:</a></label>
                       <%
	                    	userDAO.setSession(session);
	                    	
	                    	String userType2 = userDAO.getUserType();
	                        String userName2 = userDAO.getUserName();
	                        List<String> salesUserList = userDAO.getSalesUsersInCompany();
	                        
	                    	List<User> userList = userDAO.getUserList();
                        %>
                       <div class="col-sm-3">
    <select id="userName" name="userName" class="form-control" required>
        <%
            String selectedUserName = order.getUserName(); // 선택된 사용자명
            
            if ("sales".equals(userType2)) {
        %>
            <option value="<%= userName2 %>" <%= userName2.equals(selectedUserName) ? "selected" : "" %>><%= userName2 %></option>
        <%
            } else if ("manager".equals(userType)) {
                for (String salesUser : salesUserList) {
        %>
            <option value="<%= salesUser %>" <%= salesUser.equals(selectedUserName) ? "selected" : "" %>><%= salesUser %></option>
        <%
                }
            } else if ("admin".equals(userType)) {
                for (int i = 0; i < userList.size(); i++) {
                    String user = userList.get(i).getUserName();
        %>
            <option value="<%= user %>" <%= user.equals(selectedUserName) ? "selected" : "" %>><%= user %></option>
        <%
                }
            }
        %>
    </select>
</div>
                       <label class="col-sm-2 control-label">연락처:</label>
                       <div class="col-sm-3">
                           <input type="text" name="userPhoneNumber" class="form-control" placeholder="-없이 입력해주세요." value="<%= order.getUserPhoneNumber() != null ? order.getUserPhoneNumber() : "" %>">
                       </div>
                   </div>
                   <div class="form-group row">
                       <label class="col-sm-2 control-label"><a class="text-danger">* 차량톤급:</a></label>
                       <div class="col-sm-3">
                           <select name="carWeight" class="form-control" required>
					            <option value="이륜차" <%= "이륜차".equals( order.getCarWeight() ) ? "selected" : "" %>>이륜차</option>
					            <option value="0.5톤" <%= "0.5톤".equals( order.getCarWeight() ) ? "selected" : "" %>>0.5톤</option>
					            <option value="1톤" <%= "1톤".equals( order.getCarWeight() ) ? "selected" : "" %>>1톤</option>
					            <option value="1.4톤" <%= "1.4톤".equals( order.getCarWeight() ) ? "selected" : "" %>>1.4톤</option>
					            <option value="2.5톤" <%= "2.5톤".equals( order.getCarWeight() ) ? "selected" : "" %>>2.5톤</option>
					            <option value="3.5톤" <%= "3.5톤".equals( order.getCarWeight() ) ? "selected" : "" %>>3.5톤</option>
					            <option value="5톤" <%= "5톤".equals( order.getCarWeight() ) ? "selected" : "" %>>5톤</option>
					            <option value="5톤 축" <%= "5톤 축".equals( order.getCarWeight() ) ? "selected" : "" %>>5톤 축</option>
					            <option value="8톤" <%= "8톤".equals( order.getCarWeight() ) ? "selected" : "" %>>8톤</option>
					            <option value="11톤" <%= "11톤".equals( order.getCarWeight() ) ? "selected" : "" %>>11톤</option>
					            <option value="11톤 축" <%= "11톤 축".equals( order.getCarWeight() ) ? "selected" : "" %>>11톤 축</option>
					            <option value="15톤" <%= "15톤".equals( order.getCarWeight() ) ? "selected" : "" %>>15톤</option>
					            <option value="18톤" <%= "18톤".equals( order.getCarWeight() ) ? "selected" : "" %>>18톤</option>
					            <option value="25톤" <%= "25톤".equals( order.getCarWeight() ) ? "selected" : "" %>>25톤</option>
					        </select>
                       </div>
                       <label class="col-sm-2 control-label"><a class="text-danger">* 차량종류:</a></label>
                       <div class="col-sm-3">
                           <select name="kindOfCar" class="form-control" required>
					            <option value="카고" <%= "카고".equals( order.getKindOfCar() ) ? "selected" : "" %>>카고</option>
					            <option value="카고/윙" <%= "카고/윙".equals( order.getKindOfCar() ) ? "selected" : "" %>>카고/윙</option>
					            <option value="윙바디" <%= "윙바디".equals( order.getKindOfCar() ) ? "selected" : "" %>>윙바디</option>
					            <option value="탑" <%= "탑".equals( order.getKindOfCar() ) ? "selected" : "" %>>탑</option>
					            <option value="냉동/냉장" <%= "냉동/냉장".equals( order.getKindOfCar() ) ? "selected" : "" %>>냉동/냉장</option>
					        </select>
                       </div>
                   </div>
                   <div class="form-group row">
                   	<label class="col-sm-2 control-label">고정차량:</label>
                       <div class="col-sm-3">
                       		<select id="fixedCarNumber" name="fixedCarNumber" class="form-control">
	                       		<option value="" <%= order.getFixedCarNumber() == "" ? "selected" : "" %>>--선택--</option>
			                       <%
			                       	CarInfoDAO carInfoDAO = new CarInfoDAO();
			                       	List<CarInfo> carInfoList = carInfoDAO.getCarInfosByCompany( userType2, userCompany );
			                       	
			                       	for( CarInfo carInfo : carInfoList) {
				                       	String selectedCarNumber = carInfo.getCarNumber();
				                       	String carNumber = order.getFixedCarNumber();
				                       	boolean isSelected = carNumber != null && carNumber.equals(selectedCarNumber);
			                       %>
			                       		<% 
			                       			if( carInfo.getCarNumber() != null ) {
			                       		%>
			                               <option value="<%= carInfo.getCarNumber() %>" <%= isSelected ? "selected" : "" %>><%= carInfo.getCarNumber() %></option>
			                            <%
			                       			}
			                            %>
			                       <%
			                       	}
			                       %>
                       		</select>
                       </div>
                       <label class="col-sm-2 control-label">상하차 방식:</label>
                       <div class="col-sm-3">
                           <select name="upDown" class="form-control" required>
							    <option value="지게차" <%= "지게차".equals( order.getUpDown() ) ? "selected" : "" %>>지게차</option>
							    <option value="수작업" <%= "수작업".equals( order.getUpDown() ) ? "selected" : "" %>>수작업</option>
							    <option value="일부 수작업" <%= "일부 수작업".equals( order.getUpDown() ) ? "selected" : "" %>>일부 수작업</option>
							    <option value="호이스트" <%= "호이스트".equals( order.getUpDown() ) ? "selected" : "" %>>호이스트</option>
							</select>
                       </div>
                   </div>
               	<div class="form-group row">
                   	<label class="col-sm-2 control-label">참조번호:</label>
                       <div class="col-sm-3">
                           <input type="text" name="refNumber" class="form-control" value="<%= order.getRefNumber() != null ? order.getRefNumber() : "" %>">
                       </div>
                   	<label class="col-sm-2 control-label">품목:</label>
                      <div class="col-sm-3">
                      		<input type="text" name="item" class="form-control" value="<%= order.getItem() != null ? order.getItem() : "" %>">
                      </div>
               	</div>
               	<div class="form-group row">
                   	<label class="col-sm-2 control-label">규격:</label>
                       <div class="col-sm-3">
                           <input type="text" name="standard" class="form-control" value="<%= order.getStandard() != null ? order.getStandard() : "" %>">
                       </div>
                   	<label class="col-sm-2 control-label">중량:</label>
                      <div class="col-sm-3">
                      		<input type="text" name="weight" class="form-control" value="<%= order.getWeight() != null ? order.getWeight() : "" %>">
                      </div>
               	</div>
                <div class="form-group row">
                	<label class="col-sm-2 control-label">기타:</label>
                        <div class="col-sm-10">
                            <input type="text" name="etc" class="form-control" value="<%= order.getEtc() != null ? order.getEtc() : "" %>">
                        </div>
				</div>
            </div>
        </div>
	</div>
	<div class="container">
        <div class="panel panel-primary">
            <div class="panel-heading">화물수정 상세(출발지 수정)</div>
            <div class="panel-body">
                    <div class="form-group row">
                        <label class="col-sm-2 control-label"><a class="text-danger">* 출발지 도착일시:</a></label>
                        <div class="col-sm-3">
                        	<%
	                       		String formattedStartDate = "";
	                       	    if (order.getStartDate() != null && !order.getStartDate().trim().isEmpty()) {
	                       	        try {
	
	                       	            // ✅ String → Date 변환 (포맷을 정확히 맞추기)
	                       	            SimpleDateFormat inputFormat2 = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss"); // DB 저장 형식 확인
	                       	            Date date2 = inputFormat2.parse(order.getStartDate().trim()); // 공백 제거 후 변환
	
	                       	            // ✅ Date → String 변환 (input type=datetime-local 형식에 맞추기)
	                       	            SimpleDateFormat outputFormat2 = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm");
	                       	            formattedStartDate = outputFormat2.format(date2);
	
	                       	            // ✅ 변환된 값 디버깅 로그 출력
	
	                       	        } catch (Exception e) {
	                       	            e.printStackTrace(); // 변환 오류 확인
	                       	        }
	                       	    }
							%>
                            <input type="datetime-local" name="startDate" id="startDate" class="form-control" required value="<%= formattedStartDate %>">
                        </div>
                    </div>
                    <div class="form-group row">
                        <label class="col-sm-2 control-label">출발지명:</label>
                        <div class="col-sm-3">
                            <input type="text" name="departureName" id="departureName" class="form-control" value="<%= order.getDepartureName() == null ? "" : order.getDepartureName() %>">
                        </div>
                    </div>
                    <div class="form-group row">
                        <label class="col-sm-2 control-label"><a class="text-danger">* 시/도:</a></label>
                        <div class="col-sm-3">
                            <select name="departureCities" class="form-control" required>
                                <option value="서울특별시" <%= "서울특별시".equals(order.getDepartureCities()) ? "selected" : "" %>>서울특별시</option>
                                <option value="경기도" <%= "경기도".equals(order.getDepartureCities()) ? "selected" : "" %>>경기도</option>
                                <option value="인천광역시" <%= "인천광역시".equals(order.getDepartureCities()) ? "selected" : "" %>>인천광역시</option>
                                <option value="부산광역시" <%= "부산광역시".equals(order.getDepartureCities()) ? "selected" : "" %>>부산광역시</option>
                                <option value="대전광역시" <%= "대전광역시".equals(order.getDepartureCities()) ? "selected" : "" %>>대전광역시</option>
                                <option value="광주광역시" <%= "광주광역시".equals(order.getDepartureCities()) ? "selected" : "" %>>광주광역시</option>
                                <option value="대구광역시" <%= "대구광역시".equals(order.getDepartureCities()) ? "selected" : "" %>>대구광역시</option>
                                <option value="울산광역시" <%= "울산광역시".equals(order.getDepartureCities()) ? "selected" : "" %>>울산광역시</option>
                                <option value="충청북도" <%= "충청북도".equals(order.getDepartureCities()) ? "selected" : "" %>>충청북도</option>
                                <option value="충청남도" <%= "충청남도".equals(order.getDepartureCities()) ? "selected" : "" %>>충청남도</option>
                                <option value="경상북도" <%= "경상북도".equals(order.getDepartureCities()) ? "selected" : "" %>>경상북도</option>
                                <option value="경상남도" <%= "경상남도".equals(order.getDepartureCities()) ? "selected" : "" %>>경상남도</option>
                                <option value="전라북도" <%= "전라북도".equals(order.getDepartureCities()) ? "selected" : "" %>>전라북도</option>
                                <option value="전라남도" <%= "전라남도".equals(order.getDepartureCities()) ? "selected" : "" %>>전라북도</option>
                                <option value="강원도" <%= "강원도".equals(order.getDepartureCities()) ? "selected" : "" %>>강원도</option>
                                <option value="제주도" <%= "제주도".equals(order.getDepartureCities()) ? "selected" : "" %>>제주도</option>
                                <option value="세종특별자치시" <%= "세종특별자치시".equals(order.getDepartureCities()) ? "selected" : "" %>>세종특별자치시</option>
                            </select>
                        </div>
                    </div>
                    <div class="form-group row">
                    	 <label class="col-sm-2 control-label"><a class="text-danger">* 시/군/구:</a></label>
                        <div class="col-sm-3">
                        	<input type="text" name="departureTown" class="form-control" value="<%= order.getDepartureTown() == null ? "" : order.getDepartureTown() %>">
                        </div>
                    </div>
                    <div class="form-group row">
                        <label class="col-sm-2 control-label">상세주소:</label>
                        <div class="col-sm-8">
                            <input type="text" name="departureDetailedAddress" class="form-control" value="<%= order.getDepartureDetailedAddress() == null ? "" : order.getDepartureDetailedAddress() %>">
                        </div>
                    </div>
                    <div class="form-group row">
                    	<label class="col-sm-2 control-label">출발지 담당자:</label>
                        <div class="col-sm-3">
                        	<input type="text" name="departureManager" class="form-control" value="<%= order.getDepartureManager() == null ? "" : order.getDepartureManager() %>">
                        </div>
                        <label class="col-sm-2 control-label">연락처:</label>
                        <div class="col-sm-3">
                        	<input type="text" name="departureManagerPhoneNum" class="form-control" value="<%= order.getDepartureManagerPhoneNum() == null ? "" : order.getDepartureManagerPhoneNum() %>">
                        </div>
                    </div>
            </div>
        </div>
	</div>
	<div class="container">
        <div class="panel panel-primary">
            <div class="panel-heading">화물수정 상세(도착지 수정)</div>
            <div class="panel-body">
                    <div class="form-group row">
                        <label class="col-sm-2 control-label"><a class="text-danger">* 도착지 도착일시:</a></label>
                        <div class="col-sm-3">
                        	<%
	                       		String formattedEndDate = "";
	                       	    if (order.getEndDate() != null && !order.getEndDate().trim().isEmpty()) {
	                       	        try {
	
	                       	            // ✅ String → Date 변환 (포맷을 정확히 맞추기)
	                       	            SimpleDateFormat inputFormat3 = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss"); // DB 저장 형식 확인
	                       	            Date date3 = inputFormat3.parse(order.getEndDate().trim()); // 공백 제거 후 변환
	
	                       	            // ✅ Date → String 변환 (input type=datetime-local 형식에 맞추기)
	                       	            SimpleDateFormat outputFormat3 = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm");
	                       	            formattedEndDate = outputFormat3.format(date3);
	
	                       	            // ✅ 변환된 값 디버깅 로그 출력
	
	                       	        } catch (Exception e) {
	                       	            e.printStackTrace(); // 변환 오류 확인
	                       	        }
	                       	    }
							%>
                            <input type="datetime-local" name="endDate" id="endDate" class="form-control" required value="<%= formattedEndDate %>">
                        </div>
                    </div>
                    <div class="form-group row">
                        <label class="col-sm-2 control-label">도착지명:</label>
                        <div class="col-sm-3">
                            <input type="text" name="arrivalName" id="arrivalName" class="form-control" value="<%= order.getArrivalName() == null ? "" : order.getArrivalName() %>">
                        </div>
                    </div>
                    <div class="form-group row">
                        <label class="col-sm-2 control-label"><a class="text-danger">* 시/도:</a></label>
                        <div class="col-sm-3">
                            <select name="arrivalCities" class="form-control" required>
                                <option value="서울특별시" <%= "서울특별시".equals(order.getArrivalCities()) ? "selected" : "" %>>서울특별시</option>
                                <option value="경기도" <%= "경기도".equals(order.getArrivalCities()) ? "selected" : "" %>>경기도</option>
                                <option value="인천광역시" <%= "인천광역시".equals(order.getArrivalCities()) ? "selected" : "" %>>인천광역시</option>
                                <option value="부산광역시" <%= "부산광역시".equals(order.getArrivalCities()) ? "selected" : "" %>>부산광역시</option>
                                <option value="대전광역시" <%= "대전광역시".equals(order.getArrivalCities()) ? "selected" : "" %>>대전광역시</option>
                                <option value="광주광역시" <%= "광주광역시".equals(order.getArrivalCities()) ? "selected" : "" %>>광주광역시</option>
                                <option value="대구광역시" <%= "대구광역시".equals(order.getArrivalCities()) ? "selected" : "" %>>대구광역시</option>
                                <option value="울산광역시" <%= "울산광역시".equals(order.getArrivalCities()) ? "selected" : "" %>>울산광역시</option>
                                <option value="충청북도" <%= "충청북도".equals(order.getArrivalCities()) ? "selected" : "" %>>충청북도</option>
                                <option value="충청남도" <%= "충청남도".equals(order.getArrivalCities()) ? "selected" : "" %>>충청남도</option>
                                <option value="경상북도" <%= "경상북도".equals(order.getArrivalCities()) ? "selected" : "" %>>경상북도</option>
                                <option value="경상남도" <%= "경상남도".equals(order.getArrivalCities()) ? "selected" : "" %>>경상남도</option>
                                <option value="전라북도" <%= "전라북도".equals(order.getArrivalCities()) ? "selected" : "" %>>전라북도</option>
                                <option value="전라남도" <%= "전라남도".equals(order.getArrivalCities()) ? "selected" : "" %>>전라북도</option>
                                <option value="강원도" <%= "강원도".equals(order.getArrivalCities()) ? "selected" : "" %>>강원도</option>
                                <option value="제주도" <%= "제주도".equals(order.getArrivalCities()) ? "selected" : "" %>>제주도</option>
                                <option value="세종특별자치시" <%= "세종특별자치시".equals(order.getArrivalCities()) ? "selected" : "" %>>세종특별자치시</option>
                            </select>
                        </div>
                    </div>
                    <div class="form-group row">
                    	<label class="col-sm-2 control-label"><a class="text-danger">* 시/군/구:</a></label>
                        <div class="col-sm-3">
                        	<input type="text" name="arrivalTown" class="form-control" value="<%= order.getArrivalTown() == null ? "" : order.getArrivalTown() %>">
                        </div>
                    </div>
                    <div class="form-group row">
                        <label class="col-sm-2 control-label">상세주소:</label>
                        <div class="col-sm-8">
                            <input type="text" name="arrivalDetailedAddress" class="form-control" value="<%= order.getArrivalDetailedAddress() == null ? "" : order.getArrivalDetailedAddress() %>">
                        </div>
                    </div>
                    <div class="form-group row">
                    	<label class="col-sm-2 control-label">도착지 담당자:</label>
                        <div class="col-sm-3">
                        	<input type="text" name="arrivalManager" class="form-control" value="<%= order.getArrivalManager() == null ? "" : order.getArrivalManager() %>">
                        </div>
                        <label class="col-sm-2 control-label">연락처:</label>
                        <div class="col-sm-3">
                        	<input type="text" name="arrivalManagerPhoneNum" class="form-control" value="<%= order.getArrivalManagerPhoneNum() == null ? "" : order.getArrivalManagerPhoneNum() %>">
                        </div>
                    </div>
            </div>
        </div>
	</div>
	<div class="container">
        <div class="panel panel-primary">
            <div class="panel-heading">옵션 수정</div>
            <div class="panel-body" style="position: relative;">
	            <div class="form-group row">
                	<label class="col-sm-2 control-label">이착지 주소:</label>
	                	<div class="col-sm-3">
		                    <input type="text" name="destinationAddress" class="form-control" value="<%= order.getDestinationAddress() == null ? "" : order.getDestinationAddress() %>">              	
	                	</div>
	                	<div class="col-sm-3">
						    이착 : <input type="checkbox" name="option1" value="이착" 
						        <%= "이착".equals(order.getOption1()) ? "checked" : "" %> >
						    혼적 : <input type="checkbox" name="option2" value="혼적" 
						        <%= "혼적".equals(order.getOption2()) ? "checked" : "" %> >
						    왕복 : <input type="checkbox" name="option3" value="왕복" 
						        <%= "왕복".equals(order.getOption3()) ? "checked" : "" %> >
						    착불 : <input type="checkbox" name="option4" value="착불" 
						        <%= "착불".equals(order.getOption4()) ? "checked" : "" %> >
						</div>
	            </div>
	            <a href="#" class="btn btn-primary btn-sm" id="scrollTopBtn"
					       style="display:none; position: absolute; bottom: 30px; right: 30px; z-index: 999;">
					        ↑ 맨 위로
					    </a>
            </div>
        </div>
	</div>
	<div class="container" <%= "admin".equals( userType2 ) ? "" : "style='display:none;'" %>>
        <div class="panel panel-primary">
            <div class="panel-heading">차량정보</div>
            <div class="panel-body">
	            <div class="form-group row">
                	<label class="col-sm-2 control-label">차량번호: </label>
                	<div class="col-sm-3">
	                    <input type="text" id="carNumber" name="carNumber" class="form-control hide-on-select" value="<%= order.getCarNumber() == null ? "" : order.getCarNumber() %>">          	
                	</div>
                </div>
                <div class="form-group row">
                	<label class="col-sm-2 control-label">기사명: </label>
                	<div class="col-sm-3">
	                    <input type="text" name="driverName" class="form-control hide-on-select" value="<%= order.getDriverName() == null ? "" : order.getDriverName() %>">            	
                	</div>
                </div>
	            <div class="form-group row">
	                <label class="col-sm-2 control-label">기사연락처: </label>
                	<div class="col-sm-3">
	                    <input type="text" name="driverPhoneNum" class="form-control hide-on-select" value="<%= order.getDriverPhoneNum() == null ? "" : order.getDriverPhoneNum() %>">            	
                	</div>
	            </div>
	            <div class="form-group row">
	            	<label class="col-sm-2 control-label">기본운임: </label>
                	<div class="col-sm-3">
	                    <input type="text" name="basicFare" class="form-control" value="<%= String.format("%,d", order.getBasicFare()) == null ? "" : String.format("%,d", order.getBasicFare()) %>" oninput="formatAmount(this)">            	
                	</div>
	                <label class="col-sm-2 control-label">추가운임: </label>
                	<div class="col-sm-3">
	                    <input type="text" name="addFare" class="form-control" value="<%= String.format("%,d", order.getAddFare()) == null ? "" : String.format("%,d", order.getAddFare()) %>" oninput="formatAmount(this)">            	
                	</div>
                	<div class="text-center">
		                <button type="submit" class="btn btn-primary">저장</button>
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