<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import ="java.io.PrintWriter" %>
<%@ page import ="bbs.TravelDAO" %>
<%@ page import ="bbs.Bbs" %>
<%@ page import ="java.util.ArrayList" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width-device-width", initial-scale = "1">
<link rel="stylesheet" href="css/bootstrap.css">
<link rel="stylesheet" href="css/custom.css">
<title>YB술칭게이들</title>
<style type="text/css">
	a, a:hover{
		color:#000000;
		text-decoration: none;
	}

</style>
</head>
<body>
	<%
		String userID=null;
		if(session.getAttribute("userID") != null)
		{
			userID = (String) session.getAttribute("userID");
		}
		int pageNumber = 1;
		if(request.getParameter("pageNumber") != null){
			pageNumber = Integer.parseInt(request.getParameter("pageNumber"));
		}
	%>
	<nav class="navbar navbar-default">
		<div class="navbar-header">
			<button type="button" class="navbar-toggle collapsed"
				data-toggle="collapse" data-target="#bs-example-navbar-collapse-1"
				aria-expanded = "false">
				<span class ="icon-bar"></span>
				<span class ="icon-bar"></span>
				<span class ="icon-bar"></span>
				</button>
				<a class="navbar-brand" href="main.jsp">YB술칭게이들</a>
		</div>
		<div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
			<ul class="nav navbar-nav">
				<li><a href="main.jsp">메인</a></li>
				<li><a href="notice.jsp">공지사항</a></li>
				<li><a href="money.jsp">회비관리</a></li>
				<li class="active"><a href="travel.jsp">여행지</a></li>
				<li><a href="bbs.jsp">자유게시판</a></li>
				<li><a href="chat.jsp">채팅</a></li>
			</ul>
			<%
				if(userID == null)
				{
			%>
			<ul class="nav navbar-nav navbar-right">
				<li class="dropdown">
					<a href="#" class="dropdown-toggle"
						data-toggle="dropdown" role="button" aria-haspopup="true"
						aria-expanded="false">접속하기<span class="caret"></span></a>
					<ul class = "dropdown-menu">
						<li class = "active"><a href="login.jsp">로그인</a></li>
						<li><a href="join.jsp">회원가입</a></li>
					</ul>
				</li>
			</ul>
			<%
				} else{
			%>
			<ul class="nav navbar-nav navbar-right">
				<li class="dropdown">
					<a href="#" class="dropdown-toggle"
						data-toggle="dropdown" role="button" aria-haspopup="true"
						aria-expanded="false">회원관리<span class="caret"></span></a>
					<ul class = "dropdown-menu">
						<li><a href="logoutAction.jsp">로그아웃</a></li>
					</ul>
				</li>
			</ul>		
			<%
				}
			%>
		</div>
	</nav>
	<div class="container">
		<div class="row">
				<%
					TravelDAO travelDAO = new TravelDAO();
					ArrayList<Bbs> list = travelDAO.getList(pageNumber);
					for(int i=0; i<list.size(); i++){	
				%>
				<table class ="table table-striped" style="text-align: center; border: 1px solid #dddddd">
				<tbody>
					<tr>
						<td style="width: 20%;">글 제목</td>
						<td colspan="2"><%= list.get(i).getBbsTitle().replaceAll(" ","&nbsp;").replaceAll("<", "&lt;").replaceAll(">","&gt").replaceAll("\n", "<br>") %></td>
					</tr>
					<tr>
						<td>작성자</td>
						<td colspan="2"><%= list.get(i).getUserID() %></td>
					</tr>
					<tr>
						<td>작성일자</td>
						<td colspan="2"><%= list.get(i).getBbsDate().substring(0,11) + list.get(i).getBbsDate().substring(11,13) + "시" + list.get(i).getBbsDate().substring(14,16) +"분"%></td>
					</tr>
				<tr>
						<td>내용</td>
						<td colspan="2" style="min-height=200px; text-align:left;"><%= list.get(i).getBbsContent().replaceAll(" ","&nbsp;").replaceAll("<", "&lt;").replaceAll(">","&gt").replaceAll("\n", "<br>") %></td>
				</tr>
					
				</tbody>
			</table>
			<%	
					}
			%>
			
			<%
				if(pageNumber != 1){
			%>
				<a href="travel.jsp?pageNumber=<%= pageNumber - 1%>" class="btn btn-success btn-arrow-left">이전</a>
			<%
				} if(travelDAO.nextPage(pageNumber+1)){
			%>
				<a href="travel.jsp?pageNumber=<%= pageNumber + 1%>" class="btn btn-success btn-arrow-left">다음</a>					
			<%		
				}
			%>
			
			
			<a href="writetravel.jsp" class="btn btn-primary pull-right">글쓰기</a>
		</div>
	</div>
	<script src = "http://code.jquery.com/jquery-3.1.1.min.js">	</script>
	<script src="js/bootstrap.js"></script>
</body>
</html>