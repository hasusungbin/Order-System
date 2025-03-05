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
<meta name="viewport" content="width=device-width", initial-scale="1">
<link rel="stylesheet" href="css/bootstrap.css">
<title>로지스톡 운송 오더 시스템</title>
<script>
        function validateForm() {
            let userId = document.getElementById("userID").value;
            let userPw = document.getElementById("userPassword").value;

            if (userId === "" || userPw === "") {
                alert("ID와 PW를 입력하세요.");
                return false;
            }

            return true;
        }
</script>
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
		String userCompany = userDAO.getUserCompany();
		
	    //List<User> userList = userDAO.getUserByCompany(userCompany);
	    List<User> userList = userDAO.getModifyUserList(userType, userID, userCompany); 
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
				<li class="active" <%= "sales".equals( userType ) ? "style='display:none;'" : ""%>><a href="userModify.jsp">담당자 등록</a></li>
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
                        <label class="col-sm-2 control-label">* 담당자 ID:</label>
                        <div class="col-sm-3">
                        	<input type="text" id="userID" name="userID" class="form-control" required autocomplete="off" placeholder="담당자 ID 입력">
                        </div>
                        <label class="col-sm-2 control-label">* 담당자 PW:</label>
                        <div class="col-sm-3">
                            <input type="password" id="userPassword" name="userPassword" class="form-control" autocomplete="off" placeholder="담당자 비밀번호 입력" required>
                        </div>
                    </div>
                    <div class="form-group row">
                        <label class="col-sm-2 control-label">* 담당자명:</label>
                        <div class="col-sm-3">
                        	<input type="text" name="userName" class="form-control" autocomplete="off" placeholder="담당자명 입력" required>
                        </div>
                        <label class="col-sm-2 control-label">담당자 연락처:</label>
                        <div class="col-sm-3">
                            <input type="text" name="userPhoneNumber" class="form-control" placeholder="담당자 연락처 입력" required>
                        </div>
                    </div>
                    <div class="form-group row">
                    	<label class="col-sm-2 control-label">회사명:</label>
                        <div class="col-sm-3">
                            <select name="userCompany" class="form-control" required>
                                <option value="logistalk">로지스톡</option>
                                <option value="KCC">KCC</option>
                            </select>
                        </div>
                        <label class="col-sm-2 control-label">부서명:</label>
                        <div class="col-sm-3">
                            <input type="text" name="userTeam" class="form-control" placeholder="담당자 부서명 입력" required>
                        </div>
                    </div>
                    <div class="form-group row">
                    	<label class="col-sm-2 control-label">담당자 등급:</label>
                        <div class="col-sm-3">
                            <select name="userType" class="form-control" required>
                                <option value="sales">영업사원</option>
                                <option value="manager">총괄 매니저</option>
                            </select>
                        </div>
                    </div>
                </form>
            </div>
        </div>
        <div class="panel panel-default">
            <div class="panel-heading">당담자 리스트
	            <div class="text-right">
					<button onclick="deleteSelectedUsers()" class="btn btn-danger">담당자 삭제</button>
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
			            <td><%= user.getUserPhoneNumber() %></td>
			            <td><%= user.getUserTeam() %></td>
			            <td><%= user.getUserType() %></td>
			            <td><%= user.getFormattedRegDate() %></td>
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