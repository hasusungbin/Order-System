<%@page import="org.apache.poi.util.SystemOutLogger"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" session="true"%>
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
<meta http-equiv="refresh" content="20">
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width">
<!-- ✅ jQuery를 먼저 로드 -->
<script src="https://code.jquery.com/jquery-1.12.4.min.js"></script>

<!-- ✅ Bootstrap CSS 로드 -->
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css">

<!-- ✅ Bootstrap JS 로드 (jQuery 다음에 로드) -->
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/js/bootstrap.min.js"></script>
<!-- Moment.js (필수) -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.29.1/moment.min.js"></script>
<!-- Bootstrap Datetimepicker JS -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-datetimepicker/4.17.47/js/bootstrap-datetimepicker.min.js"></script>
<style>
	.d-flex {
	    display: flex !important;
	    flex-wrap: nowrap;
	    align-items: center;
	}
</style>
<script>
        document.addEventListener("DOMContentLoaded", function() {
            var today = new Date().toISOString().split('T')[0];
            document.getElementById("endDate").value = today;
            document.getElementById("endDate2").value = today;
            
            // ✅ 값 변경이 자동 제출을 발생시키지 않도록 수정
            document.getElementById("endDate").addEventListener('change', (event) => event.preventDefault());
            document.getElementById("endDate2").addEventListener('change', (event) => event.preventDefault());
        });
</script>
<title>로지스톡 운송 오더 시스템</title>
</head>
<body>
<!-- <script>
	search.btn();
</script> -->
<script>
function deleteSelectedOrders() {
    let selectedOrders = [];
    
    // 체크된 체크박스 가져오기
    document.querySelectorAll('input[name="orderCheckbox"]:checked').forEach((checkbox) => {
        selectedOrders.push(checkbox.value);
    });

    if (selectedOrders.length === 0) {
        alert("삭제할 주문을 선택해주세요.");
        return;
    }

    if (!confirm("선택한 주문을 삭제하시겠습니까?")) {
        return;
    }

    // 폼 생성 후 POST 요청
    let form = document.createElement("form");
    form.method = "POST";
    form.action = "deleteAction.jsp";

    selectedOrders.forEach(orderNumber => {
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
<script>
  $(document).ready(function () {
    $('.dropdown-toggle').dropdown();
  });
</script>

	<%
		String userID = null;
		if (session.getAttribute("userID") != null) {
			userID = (String) session.getAttribute("userID");
		}
		
		OrderDAO orderDAO = new OrderDAO();
		orderDAO.setSession(session);
		UserDAO userDAO = new UserDAO();
		String userType = orderDAO.getUserType();
		
		String userCompany = userDAO.getUserCompany(userID);
		
		String pageNumberStr = request.getParameter("pageNumber");
	    int pageNumber = (pageNumberStr != null) ? Integer.parseInt(pageNumberStr) : 1;
	    int pageSize = 10;
	    
		String endDate = request.getParameter("endDate");
	    String endDate2 = request.getParameter("endDate2");
	    String refNumber = request.getParameter("refNumber");
	    String userName = request.getParameter("userName");
	    String departureName = request.getParameter("departureName");
	    String arrivalName = request.getParameter("arrivalName");
	    String departureCities = request.getParameter("departureCities");
	    String arrivalCities = request.getParameter("arrivalCities");
	    String orderNumber = request.getParameter("orderNumber");
	    if ("".equals(refNumber)) {
	    	refNumber = null;
	    }
	    
	    if ("".equals(userName)) {
	    	userName = null;
	    }
	    
	    if ("".equals(departureName)) {
	    	departureName = null;
	    }
	    
	    if ("".equals(arrivalName)) {
	    	arrivalName = null;
	    }
	    
	    if ("".equals(departureCities)) {
	    	departureCities = null;
	    }
	    
	    if ("".equals(arrivalCities)) {
	    	arrivalName = null;
	    }
	    
	    if ("".equals(orderNumber)) {
	    	orderNumber = null;
	    }
	    
	    List<Order> orderList = null;
	    int totalCount = 0;
	    int totalPages = 0;
	    
	    String searchClicked = request.getParameter("searchClicked");
	    boolean isSearchClicked = "true".equals(searchClicked);
	    
	    if (isSearchClicked) {
	        totalCount = orderDAO.getTotalCount( 
	            endDate, endDate2, refNumber, userName, departureName,
	            arrivalName, arrivalCities, orderNumber
	        );
	        totalPages = (int) Math.ceil((double) totalCount / pageSize);
			orderList = orderDAO.getPagedList(
		            pageNumber, pageSize, endDate, endDate2, refNumber, userName,
		            departureName, departureCities, arrivalName, arrivalCities, orderNumber, userType, userCompany
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
		<li><p style="margin-top: 15px;">환영합니다. <%= userID %>님.</p><li>
	</ul>
		</div>	
	</nav>
	<div class="container">
        <div class="panel panel-primary">
            <div class="panel-heading">화물조회</div>
            <div class="panel-body">
                <form id="searchForm" action="./orderModify.jsp">
                    <div class="form-group row">
					    <label class="col-sm-2 col-form-label" style="font-size:14px;"><a class="text-danger">* 도착지 도착일시:</a></label>
					    <div class="col-sm-8 d-flex align-items-center" style="gap: 10px;">
					        <input type="date" name="endDate" id="endDate" class="form-control" required style="max-width: 180px;">
					        <span>~</span>
					        <input type="date" name="endDate2" id="endDate2" class="form-control" required style="max-width: 180px;">
					    </div>
					</div>
                    <div class="form-group row">
                        <label class="col-sm-2 control-label">참조번호:</label>
                        <div class="col-sm-3">
                            <input type="number" name="refNumber" class="form-control">
                        </div>
                        <label class="col-sm-2 control-label">담당자명:</label>
                        <%
	                    	userDAO.setSession(session);
	                    	
	                    	String userType2 = userDAO.getUserType();
	                        String userName2 = userDAO.getUserName();
	                        List<String> salesUserList = userDAO.getSalesUsersInCompany();
	                        
	                    	List<User> userList = userDAO.getUserList();
                        %>
                        <div class="col-sm-3">
                            <select id="userName" name="userName"  class="form-control">
                                <%
							        if ("sales".equals(userType2)) { // 본인 이름만 선택 가능
							    %>
							        <option value="<%= userName2 %>"><%= userName2 %></option>
							    <%
							        } else if ("manager".equals(userType)) { // 같은 userCompany에 속한 sales 계정 선택 가능
							            for (String salesUser : salesUserList) {
							    %>
							        <option value="<%= salesUser %>"><%= salesUser %></option>
							    <%
							            }
							        } else if( "admin".equals(userType) ) {
							    %>
							    	<option value="">--선택--</option>
							    <%
							        	for( int i = 0; i < userList.size(); i++ ) {
							    %>
							    	<option><%= userList.get(i).getUserName() %></option>
							    <%
							       		}
							        }
							    %>
                            </select>
                        </div>
                    </div>
                    <div class="form-group row">
                        <label class="col-sm-2 control-label">출발지 명:</label>
                        <div class="col-sm-3">
                        	<input type="text" name="departureName" class="form-control">
                        </div>
                        <label class="col-sm-2 control-label">도착지 명:</label>
                        <div class="col-sm-3">
							<input type="text" name="arrivalName" class="form-control">
                        </div>
                    </div>
                    <div class="form-group row">
                        <label class="col-sm-2 control-label">출발지 시/도:</label>
                        <div class="col-sm-3">
							<select name="departureCities" class="form-control">
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
                        <label class="col-sm-2 control-label">도착지 시/도:</label>
                        <div class="col-sm-3">
							<select name="arrivalCities" class="form-control">
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
                    	<label class="col-sm-2 control-label">오더번호:</label>
                        <div class="col-sm-3">
                            <input type="text" name="orderNumber" class="form-control">
                            <input type="hidden" name="pageNumber" class="form-control" value="1">
                        </div>
                    <%
                    	if( "admin".equals(userType) ) {
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
                    <div class="form-group text-center" style="display: flex; justify-content: center; gap: 10px;">
		                <div class="col-sm-3">
		                	<input type="hidden" name="searchClicked" value="true">
		                	<input type="hidden" name="userType" value="<%= userType %>">
	                    	<button type="submit" class="btn btn-primary" onclick="submitForm('orderModify.jsp')">조회</button>
	                    	<button type="button" class="btn btn-success" onclick="submitForm('downloadExcel')">엑셀 다운로드</button>
	                    </div>
                   	</div>
                </form>
            </div>
        </div>
        <%
		    boolean hasSearchData = (endDate != null && !endDate.isEmpty()) || 
		                            (endDate2 != null && !endDate2.isEmpty()) || 
		                            (refNumber != null && !refNumber.isEmpty()) || 
		                            (userName != null && !userName.isEmpty()) || 
		                            (departureName != null && !departureName.isEmpty()) || 
		                            (arrivalName != null && !arrivalName.isEmpty()) || 
		                            (arrivalCities != null && !arrivalCities.isEmpty()) || 
		                            (orderNumber != null && !orderNumber.isEmpty()) ||
		                            (userCompany != null && !userCompany.isEmpty());
		
		    boolean showResults = hasSearchData && (orderList != null && !orderList.isEmpty());
		    %>
        <div class="panel panel-default">
            <div class="panel-heading" style="display: flex; justify-content: space-between; align-items: center;">
			    <p style="font-weight: bold; margin: 0;">조회 결과</p>
			    <div>
			        <button onclick="deleteSelectedOrders()" class="btn btn-danger">요청취소</button>
			    </div>
			</div>
            <div class="panel-body" style="overflow-x: auto; white-space: nowrap;">
            	<% if (showResults) { %> <!-- 조회 조건이 있을 때만 테이블 표시 -->
                <table class="table table-bordered table-hover">
                    <thead>
                        <tr style="font-size: 14px;">
                            <th>체크</th>
                        	<th>오더번호</th>
                        	<th>오더 등록일</th>
                            <th>도착지 도착일시</th>
                            <th>참조번호</th>
                            <th>출발지명</th>
                            <th>출발지 주소</th>
                            <th>도착지명</th>
                            <th>도착지 주소</th>
                            <th>화물톤급</th>
                            <th>차량종류</th>
                            <th>상하차 방식</th>
                            <th>차량번호</th>
                            <th>기사명</th>
                            <th>기사연락처</th>
                            <th>운송비 금액</th>
                            <th>담당자명</th>
                            <th>등록일</th>
                            <th>이착지 주소</th>
                            <th>옵션1</th>
		                    <th>옵션2</th>
		                    <th>옵션3</th>
		                    <th>옵션4</th>
		                    <%
		                    	if( userType.equals("admin") ) {
		                    %>
		                    	<th>회사명</th>
		                    <%
		                    	}
		                    %>
                        </tr>
                    </thead>
                    <tbody>
			            <% for ( Order order : orderList ) { %> 
			            	<%	
				            	String carNumber = null;
			            		if( order.getCarNumber() != null ) {
			            			carNumber = order.getCarNumber();
			            		} else if( order.getFixedCarNumber() != null ) {
			            			carNumber = order.getFixedCarNumber();
			            		}
			            	%>
			                <tr style="font-size:14px;">
			                    <td><input type="checkbox" name="orderCheckbox" value="<%= order.getOrderNumber() %>"></td>
			                    <td><a href="orderUpdate.jsp?orderNumber=<%= order.getOrderNumber() %>"><%= order.getOrderNumber() %></a></td>
			                    <td><%= order.getOrderDate() %></td>
			                    <td><%= order.getEndDate() %></td>
			                    <td><%= order.getRefNumber() %></td>
			                    <td><%= order.getDepartureName() %></td>
			                    <td><%= order.getDepartureCities() + " " + order.getDepartureTown() %></td>
			                    <td><%= order.getArrivalName() %></td>
			                    <td><%= order.getArrivalCities() + " " + order.getArrivalTown() %></td>
			                    <td><%= order.getCarWeight() %></td>
			                    <td><%= order.getKindOfCar() %></td>
			                    <td><%= order.getUpDown() %></td>
			                    <td><%= carNumber != null ? carNumber : "" %></td>
			                    <td><%= order.getDriverName() != null ? order.getDriverName() : "" %></td>
			                    <td><%= order.getDriverPhoneNum() != null ? order.getDriverPhoneNum() : "" %></td>
			                    <td><%= String.format("%,d", order.getBasicFare() + order.getAddFare()) %></td>
			                    <td><%= order.getUserName() %></td>
			                    <td><%= order.getRegDate() %></td>
			                    <td><%= order.getDestinationAddress() != null ? order.getDestinationAddress() : "" %></td>
			                    <td><%= order.getOption1() != null ? order.getOption1() : "" %></td>
			                    <td><%= order.getOption2() != null ? order.getOption2() : "" %></td>
			                    <td><%= order.getOption3() != null ? order.getOption3() : "" %></td>
			                    <td><%= order.getOption4() != null ? order.getOption4() : "" %></td>
			                    <%
			                    	if( userType.equals("admin") ) {
			                    %>
			                    	<td><%= order.getUserCompany() != null ? order.getUserCompany() : "" %></td>
			                    <%
			                    	}
			                    %>
			                </tr>
			            <% } %>
           			</tbody>
                </table>
                <% } else { %>
        			<p class="text-center">검색 결과가 없습니다.</p>
        		<% } %>
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
	<%
		}	
	%>
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