<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>웹소켓 채팅</title>
<script type="text/javascript">
var webSocket = new WebSocket("ws://192.168.0.29:8081/WebsocketProject/ChatingServer");
var chatWindow, chatMessage, chatId; // form에 있는 id 정보를 스크립트에 가져와서 객체 형태로 사용하기 위한 정보로서 값을 담아주기 위해 세개의 변수를 선언한 것임.

// 채팅창이 열리면 대화창, 메시지 입력창, 대화명 표시란으로 사용할 DOM 객체 저장
window.onload = function(){ // 브라우저가 처음 실행될 때 호출되어지는 이벤트 onload -> 동작 타이밍이 body부분이 전부 실행되고 나서 이벤트가 시작됨.
	chatWindow = document.getElementById("chatWindow"); // getElementById -> 태그에 있는 id 속성을 사용하여 해당 태그에 접근하여 하고 싶은 작업을 할 때 쓰는 함수
	chatMessage = document.getElementById("chatMessage"); // 메시지 창
	chatId = document.getElementById('chatId').value; // 닉네임
}

// 메시지 전송
function sendMessage(){
	// 대화창에 표시
	chatWindow.innerHTML += "<div class='myMsg'>" + chatMessage.value + "</div>" // 나의 화면에도 내가 보내는 메시지를 보이게 한다.
	webSocket.send(chatId + ' | ' + chatMessage.value); // 서버로 전송
	chatMessage.value= ""; // 보내고 난 후에는 메시지 입력창의 내용 지우기
	chatWindow.scrollTop = chatWindow.scrollHeight; // 스크롤을 자동으로 가장 밑으로 내려가게 해준다.
}

// 서버와의 연결 종료
function disconnect(){
	webSocket.close();
}

// 엔터 키 입력 처리
function enterKey(){
	if(window.event.keyCode == 13){ // 13은 'Enter' 키의 코드값이다.
		sendMessage();
	}
}

// 웹소켓 서버에 연결됐을 때 실행
webSocket.onopen = function(event){
	chatWindow.innerHTML += "웹소켓 서버에 연결되었습니다.<br/>";
};

// 웹소켓이 닫혔을 때 (서버와의 연결이 끊겼을 때 ) 실행
webSocket.onclose = function(event){
	chatWindow.innerHTML += "웹소켓 서버가 종료되었습니다.<br/>";
};

// 에러 발생시 실행
webSocket.onerror = function(event){
	alert(event.data);
	chatWindow.innerHTML += "채팅 중 에러가 발생하였습니다.<br/>";
};

// 메시지를 받았을 때 실행
webSocket.onmessage = function(event){
	var message = event.data.split(" | "); // 대화명과 메시지 분리
	var sender = message[0]; // 보낸 사람의 대화명
	var content = message[1]; // 메시지 내용
	if(content != ""){ // 메시지의 내용이 빈 문자열이 아니면, 즉 내용이 있으면 true
		if(content.match("/")){ //  match -> 메시지 내용에 / 가 포함되어 있다면 true
			if(content.match(("/" + chatId))){ // 메시지 내용이 /chatId(나) 라면 true
				var temp = content.replace(("/" + chatId), "[귓속말] : "); // replace -> 바꾸다 ( /chatId -> [귓속말] : )
				chatWindow.innerHTML += "<div>" + sender + "" + temp + "</div>"; // 출력
			}
		}
		else { // 귓속말이 아닌 일반 대화 출력
			chatWindow.innerHTML += "<div>" + sender + " : " + content + "</div>";	
		}
	}
	chatWindow.scrollTop = chatWindow.scrollHeight; 
};
</script>

<style>
#chatWindow{border:1px solid black; width:270px; height:310px; overflow:scroll; padding:5px;}
#chatMessage{width:236px; height:30px;}
#sendBtn{height:30px; position:relative; top:2px; left:-2px;}
#closeBtn{margin-bottom:3px; position:relative; top:2px; left:-2px;}
#chatId{width:158px; height:24px; border:1px solid #AAAAAA; background-color:#EEEEEE;}
.myMsg{text-align:right;}
</style>

</head>
<body>
	대화명 : <input type="text" id="chatId" value="${ param.chatId }" readonly />
	<button id="closeBtn" onclick="disconnect();">채팅종료</button>
	<div id="chatWindow"></div>
	<div>
		<input type="text" id="chatMessage" onkeyup="enterKey();">
		<button id="sendBtn" onclick="sendMessage();">전송</button>
	</div>
</body>
</html>