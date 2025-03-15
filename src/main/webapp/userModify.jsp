<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" session="true"%>
<%@ page import="java.io.PrintWriter" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.List" %>
<%@ page import="user.UserDAO" %>
<%@ page import="user.User" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width">
<link rel="stylesheet" href="css/bootstrap.css">
<title>로지스톡 운송 오더 시스템</title>
<script>
    function deleteSelectedUsers() {
        let selectedUsers = [];
        
        // 체크된 체크박스 가져오기
        document.querySelectorAll('input[name="userCheckbox"]:checked').forEach((checkbox) => {
            selectedUsers.push(checkbox.value);
        });

        if (selectedUsers.length === 0) {
            alert("삭제할 유저를 선택해주세요.");
            return;
        }

        if (!confirm("선택한 유저를 삭제하시겠습니까?")) {
            return;
        }

        // 폼 생성 후 POST 요청
        let form = document.createElement("form");
        form.method = "POST";
        form.action = "deleteUserAction.jsp";

        selectedUsers.forEach(userID => {
            let input = document.createElement("input");
            input.type = "hidden";
            input.name = "userIDs";
            input.value = userID;
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
		String userCompany = userDAO.getUserCompany( userID );
		
	    //List<User> userList = userDAO.getUserByCompany(userCompany);
	    
	    List<User> userList = userDAO.getModifyUserList(userType, userID, userCompany);
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
				<li class="active" <%= "sales".equals( userType ) ? "style='display:none;'" : ""%>><a href="userModify.jsp">담당자 등록</a></li>
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
	<%
		}	
	%>
	<ul class="nav navbar-nav">
		<li><p style="margin-top: 15px;">환영합니다. <%= userID %>님.</p><li>
	</ul>
		</div>	
	</nav>
	<div class="container">
        <div class="panel panel-primary">
            <div class="panel-heading">담당자 등록</div>
            <div class="panel-body">
                <form id="searchForm" action="./userRegisterAction.jsp" onsubmit="return validateForm();" name="f">
                	<div class="text-right">
		            	<div class="btn-group">
			                <input type="button" class="btn btn-primary" onclick="rtn();" value="신규">
			                <button type="submit" class="btn btn-primary" style="margin-left: 10px;">저장</button>
		            	</div>
		            </div>
                	<div class="form-group row">
                        <label class="col-sm-2 control-label"><a class="text-danger">* 담당자 ID:</a></label>
                        <div class="col-sm-3">
                        	<input type="text" id="userID" name="userID" class="form-control" required placeholder="담당자 ID 입력" autocomplete="off" onfocus="this.removeAttribute('readonly');">
                        </div>
                        <label class="col-sm-2 control-label"><a class="text-danger">* 담당자 PW:</a></label>
                        <div class="col-sm-3">
                            <input type="password" id="userPassword" name="userPassword" class="form-control" placeholder="담당자 비밀번호 입력" required autocomplete="new-password" onfocus="this.removeAttribute('readonly');">
                        </div>
                    </div>
                    <div class="form-group row">
                        <label class="col-sm-2 control-label"><a class="text-danger">* 담당자명:</a></label>
                        <div class="col-sm-3">
                        	<input type="text" name="userName" class="form-control" placeholder="담당자명 입력" required>
                        </div>
                        <label class="col-sm-2 control-label">담당자 연락처:</label>
                        <div class="col-sm-3">
                            <input type="text" name="userPhoneNumber" class="form-control" placeholder="담당자 연락처 입력">
                        </div>
                    </div>
                    <div class="form-group row">
                    	<label class="col-sm-2 control-label">회사명:</label>
                        <div class="col-sm-3">
                            <select name="userCompany" class="form-control">
                            	<%
                            		if( userType.equals("admin") ) {
                            	%>
								<option value="KCC글라스">KCC글라스</option>
								<option value="(주)쎄레코">(주)쎄레코</option>
								<option value="(주)JKC 코퍼레이션">(주)JKC 코퍼레이션</option>
								<option value="코스모프로">코스모프로</option>
								<option value="(주)발렉스">(주)발렉스</option>
								<%
	                            	} else if( userCompany.equals("KCC글라스") ) {
								%>	
									<option value="KCC글라스">KCC글라스</option>
								<%
	                            	} else if( userCompany.equals("(주)쎄레코") ) {
								%>
									<option value="(주)쎄레코">(주)쎄레코</option>
								<%
	                            	} else if( userCompany.equals("(주)JKC 코퍼레이션") ) {
								%>
									<option value="(주)JKC 코퍼레이션">(주)JKC 코퍼레이션</option>
								<%
	                            	} else if( userCompany.equals("코스모프로") ) {
								%>
									<option value="코스모프로">코스모프로</option>
								<%
	                            	} else if( userCompany.equals("(주)발렉스") ) {
								%>
									<option value="(주)발렉스">(주)발렉스</option>
								<%
	                            	}
								%>
							</select>
                        </div>
                        <label class="col-sm-2 control-label">부서명:</label>
                        <div class="col-sm-3">
                            <input type="text" name="userTeam" class="form-control" placeholder="담당자 부서명 입력">
                        </div>
                    </div>
                    <div class="form-group row">
                    	<label class="col-sm-2 control-label"><a class="text-danger">* 담당자 등급:</a></label>
                        <div class="col-sm-3">
                            <select name="userType" class="form-control" required>
                                <option value="sales">출하담당자</option>
                                <option value="manager">총괄 매니저</option>
                            </select>
                        </div>
                    </div>
                </form>
            </div>
        </div>
        <div class="panel panel-default">
        	<div class="panel-heading" style="display: flex; justify-content: space-between; align-items: center;">
			    <p style="font-weight: bold; margin: 0;">당담자 리스트</p>
			    <div>
			        <button onclick="deleteSelectedOrders()" class="btn btn-danger">담당자 삭제</button>
			    </div>
			</div>
            <div class="panel-body">
				<table class="table table-bordered table-hover" border="1">
				    <tr style="font-size: 10px;">
				        <th>체크</th>
				        <th>담당자명</th>
				        <th>담당자 연락처</th>
				        <th>부서명</th>
				        <th>담당자 등급</th>
				        <th>등록일자</th>
				    </tr>
				<% for (User user : userList) { %>
			        <tr>
			            <td><input type="checkbox" name="userCheckbox" value="<%= user.getUserID() %>"></td>
			            <td><a href="userUpdate.jsp?userID=<%= user.getUserID() %>"><%= user.getUserName() %></a></td>
			            <td><%= user.getUserPhoneNumber() != null ? user.getUserPhoneNumber() : "" %></td>
			            <td><%= user.getUserTeam() != null ? user.getUserTeam() : "" %></td>
			            <td><%= user.getUserType() != null ? user.getUserType() : "" %></td>
			            <td><%= user.getFormattedRegDate() != null ? user.getFormattedRegDate() : "" %></td>
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