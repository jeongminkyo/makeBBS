<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<meta name = "viewport" content = "width=dievice-width, initial-scale=1">
	<link rel = "stylesheet" href="css/bootstrap.css">
	<link rel = "stylesheet" href="css/custom.css">
	<title>YB술친게이들</title>
	<script src="http://code.jquery.com/jquery-3.1.1.min.js"></script>
	<script src="js/bootstrap.js"></script>
	<script type="text/javascript">
		var lastID = 0;
		function submitFunction()
		{
			var chatName = $('#chatName').val();
			var chatContent = $('#chatContent').val();
			$.ajax({
				type : "POST",
				url:"./chatSubmitServlet",
				data: {
					chatName: encodeURIComponent(chatName),
					chatContent: encodeURIComponent(chatContent)
				},
				success: function(result){
					if(result == 1)
					{
						autoClosingAlert('#successMessage',2000);
					}
					else if(result == 0)
					{
						autoClosingAlert('#dangerMessage',2000);
					}
					else
					{
						autoClosingAlert('#warningMessage',2000);	
					}
				}
			});
			$('#chatContent').val('');
		}
		function autoClosingAlert(selector, delay)
		{
			var alert = $(selector).alert();
			alert.show();
			window.setTimeout(function() {alert.hide()}, delay);
		}
		function chatListFunction(type)
		{
			$.ajax({
				type : "POST",
				url:"./chatListServlet",
				data: {
					listType : type,
				},
				success: function(data){
					if(data == "") return;
					var parsed = JSON.parse(data);
					var result = parsed.result;
					for(var i=0; i<result.length; i++)
					{
						addChat(result[i][0].value, result[i][1].value, result[i][2].value);	
					}
					lastID = Number(parsed.last);
				}
			});
		}
		function addChat(chatName, chatContent, chatTime)
		{
			$('#chatList').append('<div class="row">'+
					'<div class="col-lg-12">' +
					'<div class="media">' + 
					'<a class="pull-left" href="#">' +
					'<img class="media-object img-circle" src="Images/icon.jpg">' +
					'</a>'+
					'<div class="media-body">'+
					'<h4 class="media-heading">'+
					chatName+
					'<span class="small pull-right">'+
					chatTime+
					'</span>'+
					'</h4>'+
					'<p>'+
					chatContent +
					'</p>'+
					'</div>'+
					'</div>'+
					'</div>'+
					'</div>'+
					'<hr>');
			$('#chatList').scrollTop($('#chatList')[0].scrollHeight);
		}
		function getInfiniteChat()
		{
			setInterval(function() {
				chatListFunction(lastID);
			},1000);
		}
	</script>
</head>
<body>
<%
		String userID=null;
		if(session.getAttribute("userID") != null)
		{
			userID = (String) session.getAttribute("userID");
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
				<li><a href="travel.jsp">여행지</a></li>
				<li><a href="bbs.jsp">자유게시판</a></li>
				<li class="active"><a href="chat.jsp">채팅</a></li>
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
		<div class="contanier bootsrap snippet">
			<div class="row">
				<div class="col-xs-12">
					<div class="portlet portlet-default">
						<div class="portlet-heading">
							<div class="portlet-title">
								<h4><i class= "fa fa-circle text-green"></i>실시간 채팅방</h4>
							</div>
							<div class="clearfix"></div>
						</div>
						<div id ="chat" class="panel-collapes collapse in"></div>
							<div id="chatList" class="portlet-body chat-widget" style="overflow-y: auto; width: auto; height:600px;">
					
							</div>
							<div class="portlet-footer">
								<div class="row">
									<div class="form-group col-xs-4">
										<input style="height: 40px;" type="text" id="chatName" class="form-control" placeholder="이름" maxlength="8">
									</div>
								</div>
								<div class="row" style="height:90px">
									<div class ="form-group col-xs-10">
										<textarea style="height:80px;" id="chatContent" class="form-control" placeholder="메세지를 입력하세요" maxlength="100"></textarea>
									</div>
									<div class="form-group col-xs-2">
										<button type="button" class="btn btn-default pull-right" onclick="submitFunction();">전송</button>
										<div class="clearfix"></div>
									</div>
								</div>
							</div>
							
					</div>
				</div>
			</div>
			<div class = "alert alert-success" id="successMessage" style="display : none;">
				<strong>메세지 전송에 성공하였습니다.</strong>
			</div>
			<div class = "alert alert-danger" id="dangerMessage" style="display : none;">
				<strong>이름과 내용을 모두 입력해주세요.</strong>
			</div>
			<div class = "alert alert-warning" id="warningMessage" style="display : none;">
				<strong>데이터베이스 오류가 발생했습니다.</strong>
			</div>
		</div>
		<script type="text/javascript">
			$(document).ready(function() {
				getInfiniteChat();
				chatListFunction('ten');
			});
		</script>
</body>
</html>