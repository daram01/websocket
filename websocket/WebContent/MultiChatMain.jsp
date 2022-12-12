<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<script>
	function chatWinOpen(){ // 채팅창을 팝업창으로 열어주는 함수
		var id = document.getElementById("chatId"); // 대화명 입력상자의 DOM 객체를 얻어와서
		if(id.value == ""){ // 대화명이 입력되지 않았으면 경고를 띄워주는 조건문
			alert("대화명을 입력 후 채팅창을 열어주세요.");
			id.focus();
			return;
		}
		window.open("ChatWindow.jsp?chatId=" + id.value, "", "width=350,height=400"); // 문제가 없으면 대화명을 매개변수로 전달해 채팅창을 띄운다.
		id.value= "";
	}
	</script>
	<h2>웹소켓 채팅 - 대화명 적용하여 채팅창 띄워주기</h2>
	대화명 : <input type="text" id="chatId" /> <!-- 대화명 입력상자 -->
	<button onclick="chatWinOpen();">채팅 참여</button> <!-- [채팅 참여] 버튼을 누르면 chatWinOpen() 함수 호출 -->
</body>
</html>