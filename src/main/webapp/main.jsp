<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" session="true"%>
<%@ page import="java.io.PrintWriter" %>
<%@ page import="user.UserDAO" %>
<%@ page import="user.User" %>
<%@ page import="arrival.ArrivalDAO" %>
<%@ page import="arrival.Arrival" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.List" %>
<%@ page import="org.apache.ibatis.session.SqlSession" %>
<%@ page import="org.apache.ibatis.session.SqlSessionFactory" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width", initial-scale="1">
<link rel="stylesheet" href="css/bootstrap.css">
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
</script>
<script>
       // 선택한 도착지 정보가 부모 창의 input 태그에 반영되도록 처리
       function updateArrivalDetails() {
           var selectBox = document.getElementById("arrivalSelect");
           var selectedOption = selectBox.options[selectBox.selectedIndex];
           
           // 선택된 option이 존재하면 정보를 input 태그에 입력
           if (selectedOption.value !== "") {
               var orderNumber = selectedOption.value;
               var arrivalName = selectedOption.getAttribute("data-name");
               var arrivalCities = selectedOption.getAttribute("data-arrivalCities");
               var arrivalTown = selectedOption.getAttribute("data-arrivalTown");

               // 부모 창의 input 태그에 값 설정
               document.getElementById("orderNumber").value = orderNumber;
               document.getElementById("arrivalName").value = arrivalName;
               document.getElementById("arrivalCities").value = arrivalCities;
               document.getElementById("arrivalTown").value = arrivalTown;
               
            	// arrivalCities select box 값 자동 선택
               var citiesSelectBox = document.getElementById("arrivalCities");
               for (var i = 0; i < citiesSelectBox.options.length; i++) {
                   if (citiesSelectBox.options[i].value === arrivalCities) {
                       citiesSelectBox.selectedIndex = i;
                       break;
                   }
               }
           }
       }
   </script>
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
				<li><a href="arrivalModify.jsp">출/도착지 등록</a></li>
				<li><a href="carModify.jsp">고정차량 등록</a></li>
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
	<script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
	<script src="js/bootstrap.js"></script>
	<script>
		function rtn() {
			f.reset();
		}
	</script>
<form action="writeAction.jsp" method="post" name="f">
	<div class="container">
        <div class="panel panel-primary">
            <div class="panel-heading">화물등록 일반</div>
            <div class="panel-body">
	            <div class="text-right">
	            	<div class="btn-group">
		                <input type="button" class="btn btn-primary" onclick="rtn();" value="신규">
		                <button type="submit" class="btn btn-primary" style="margin-left: 10px;">저장</button>
	            	</div>
	            </div>
                   <div class="form-group row">
                       <label class="col-sm-2 control-label" ><a class="text-danger">* 운송요청일:</a></label>
                       <div class="col-sm-4">
                           <input type="date" name="orderDate" id="orderDate" class="form-control" required>
                       </div>
                   </div>
                   <div class="form-group row">
                       <label class="col-sm-2 control-label"><a class="text-danger">* 담당자명:</a></label>
                       <%
	                    	String userType2 = userDAO.getUserType();
	                        String userName2 = userDAO.getUserName();
	                        List<String> salesUserList = userDAO.getSalesUsersInCompany();
	                        
	                    	ArrayList<User> userList = userDAO.getUserList();
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
                               <option value="">Master data</option>
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
                            <input type="text" name="etc" class="form-control">
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
                        <label class="col-sm-2 control-label"><a class="text-danger">* 출발지명:</a></label>
                        <div class="col-sm-3">
                            <input type="text" name="departureName" id="departureName" class="form-control" required>
                        </div>
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
                        	<input type="text" name="departureTown" class="form-control">
                        </div>
                    </div>
                    <div class="form-group row">
                        <label class="col-sm-2 control-label">상세주소:</label>
                        <div class="col-sm-8">
                            <input type="text" name="departureDetailedAddress" class="form-control">
                        </div>
                    </div>
                    <div class="form-group row">
                    	<label class="col-sm-2 control-label">담당자:</label>
                        <div class="col-sm-3">
                        	<input type="text" name="departureManager" class="form-control">
                        </div>
                        <label class="col-sm-2 control-label">연락처:</label>
                        <div class="col-sm-3">
                        	<input type="text" name="departureManagerPhoneNum" class="form-control">
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
                        <label class="col-sm-2 control-label"><a class="text-danger">오더번호:</a></label>
                        <div class="col-sm-4">
                        	<input type="text" id="orderNumber" class="form-control" readonly>
                        </div>
                    </div>
                    <div class="form-group row">
                        <label class="col-sm-2 control-label"><a class="text-danger">* 신규 도착지명:</a></label>
                        <div class="col-sm-4">
                        	<input type="text" name="arrivalName" id="arrivalName" class="form-control" required>
                        </div>
                        <label class="col-sm-2 control-label"><a class="text-danger">기존 도착지 명 선택:</a></label>
                        <div class="col-sm-4">
	                        <select class="form-control" id="arrivalSelect" onchange="updateArrivalDetails()">
	                        <option value="">-- 선택 --</option>
					        <%
					            // ArrivalDAO 생성 후 도착지 리스트 가져오기
					            ArrivalDAO arrivalDAO = new ArrivalDAO();
					            List<Arrival> arrivalList = arrivalDAO.getArrivalList(userCompany);
								System.out.println(userCompany + ": userCompany");
					            // 도착지 리스트를 select box에 동적으로 추가
					            for (Arrival arrival : arrivalList) {
					        %>
				            <option value="<%= arrival.getOrderNumber() %>" 
				                    data-name="<%= arrival.getArrivalName() %>" 
				                    data-arrivalCities="<%= arrival.getArrivalCities() %>"
				                    data-arrivalTown="<%= arrival.getArrivalTown() %>">
				                <%= arrival.getArrivalName() %></option>
					        <%
					            }
					        %>
	    					</select>
	    				</div>
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
                    	<label class="col-sm-2 control-label">담당자:</label>
                        <div class="col-sm-3">
                        	<input type="text" name="arrivalManager" class="form-control">
                        </div>
                        <label class="col-sm-2 control-label">연락처:</label>
                        <div class="col-sm-3">
                        	<input type="text" name="arrivalManagerPhoneNum" class="form-control">
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