package websocket;

import java.io.IOException;
import java.util.Collections;
import java.util.HashSet;
import java.util.Set;

import javax.websocket.OnClose;
import javax.websocket.OnError;
import javax.websocket.OnMessage;
import javax.websocket.OnOpen;
import javax.websocket.Session;
import javax.websocket.server.ServerEndpoint;

@ServerEndpoint("/ChatingServer") // 클라이언트쪽에서 사용할 이름
public class ChatServer {
	private static Set<Session> clients 
				= Collections.synchronizedSet(new HashSet<Session>());
	// HashSet은 기본적으로 동기화 처리가 안 되어있기 때문에 
	// 여러 클라이언트가 동시에 접속해도 문제가 생기지 않도록 하기 위하여 Collections.synchronizedSet 을 사용하여 동기화 처리한다.

	@OnOpen // 클라이언트 접속했을 때 자동으로 실행할 메서드를 정의한다. 
	public void onOpen(Session session) {
		clients.add(session); // 클라이언트가 보내주는 세션값을 받아 저장한다.
		System.out.println("웹소켓 연결 : " + session.getId()); // 해당 클라이언트가 접속할 때 생성되어진 세션 아이디를 보여준다.
	}
	
	@OnMessage // 클라이언트로부터 메시지를 받았을 때 실행할 메서드를 정의한다. 클라이언트가 보낸 메시지와 클라이언트와 연결된 세션이 매개변수로 넘어온다.
	public void onMessage(String message, Session session) throws IOException{
		System.out.println("메세지 전송 : " + session.getId() + " : " + message); // 아이디 확인 작업 + 메세지 확인
		synchronized (clients) { // 동기화 처리를 안 해놓으면 클라이언트가 보낸 메시지 순서가 달라지기 때문에 동기화 처리 필수.
			for(Session client : clients) { // 모든 클라이언트에게 메시지 전달하는 작업
				if(!client.equals(session)) { // 단, 메시지를 보낸 클라이언트에게는 제외하고 전달
					client.getBasicRemote().sendText(message); // getBasicRemote().sendText() -> 메시지 전달하는 메서드
				}
			}
		}
	}
	
	@OnClose // 클라이언트와의 연결이 끊기면 실행할 메서드를 정의한다. clients에서 해당 클라이언트의 세션을 삭제한다.
	public void onClose(Session session) {
		clients.remove(session); // 클라이언트가 접속 종료를 했기 때문에 set에서 관리할 필요가 없으므로 세션값을 삭제한다. 
		System.out.println("웹소켓 종료 : " + session.getId());
	}
	
	@OnError // 에러가 발생했을 때 실행할 메서드를 정의한다.
	public void onError(Throwable e) {
		System.out.println("에러 발생");
		e.printStackTrace();
	}
}