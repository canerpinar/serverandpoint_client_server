package websocketExample;

import java.io.IOException;
import java.util.Collections;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Map;
import java.util.Set;

import javax.swing.plaf.SliderUI;
import javax.websocket.EncodeException;
import javax.websocket.OnClose;
import javax.websocket.OnMessage;
import javax.websocket.OnOpen;
import javax.websocket.Session;
import javax.websocket.server.PathParam;
import javax.websocket.server.ServerEndpoint;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import org.json.JSONString;

import com.google.gson.Gson;
import com.google.gson.JsonObject;

import websocketExample.service.JsonService;

@ServerEndpoint("/websocket/{username}")
public class WsServer {
	
	private static Set<Session> clients = Collections.synchronizedSet(new HashSet<>());	  
	  
	public void sendPrivateMessag(Session session,String message,String id,String username){
		synchronized (clients) {
			for(Session client:clients){
				if(!client.equals(session)){
					if(username.equals(client.getUserProperties().get("username"))){
						try {
							client.getBasicRemote().sendText("{\"privateMessage\" : \""+message+"\",\"username\":"
									+ "\""+session.getUserProperties().get("username")+"\",\"sessionId\" : \""+session.getId()+"\"}");
						} catch (IOException e) {
							// TODO Auto-generated catch block
							e.printStackTrace();
						}
					}
				}
			}
		}
	}
	  
	@OnMessage
	public void onMessage(String message,Session session){
		
		JSONObject data=JsonService.parseJson(message);
		
		
		if(data.getString("sentId")!=null){
			String id=data.getString("sentId");
			String username=data.getString("username");
			System.out.println(id);
			sendPrivateMessag(session, data.getString("message"), id, username);
			return;
		}
		

		String user = data.getString("user");
		String text=data.getString("message");
		System.out.println(user);
		
		//if(data.getString("sentId"))
		
		
	    synchronized(clients){
	    	/*
			String username=jsonObject.getString("user");
			String mesaj = jsonObject.getString("message");
			System.out.println(username);
			*/
	        // Iterate over the connected sessions
	        // and broadcast the received message
	        for(Session client : clients){
	          if (!client.equals(session)){
	            try {	          
					client.getBasicRemote().sendText("{\"ileti\" : "+"\"<p><span style='color:red'>"+user.concat("</span> diyorki ").concat(text)+"</p>\"}");					
				} catch (IOException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
	          }
	        }
	      }			
	}
	
	@OnOpen
	public void onOpen(Session session,@PathParam("username")String user){
		session.getUserProperties().put("username", user);
		clients.add(session);
		System.out.println("oturum "+ user);					
		
		String jsonString="";
		
        for(Session client : clients){
	          if (!client.equals(session)){
	            try {
					client.getBasicRemote().sendText("{\"adi\" : \""+user+"\",\"id\" : \""+session.getId()+"\"}");
					jsonString +="{\"ad\" : \""+client.getUserProperties().get("username")+"\",\"id\" : \""+client.getId()+"\"},";
				} catch (IOException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
	          }	          	          
	        }
        
      
       /* 
        if(clients.size()==2){
        	jsonString=jsonString.replace(",", "");
        }
        */	
        
        
        
        
        if(clients.size()>=2)
        	{
        		jsonString=jsonString.substring(0, jsonString.length()-1);
        		
        		//jsonString="{ "+herkes+jsonString+"] }";
        	}
        
        jsonString="[ "+jsonString+" ]";
        try {
			session.getBasicRemote().sendText(jsonString);
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
        System.out.println(jsonString);
	      }
		
		
	
	
	@OnClose
	public void onClose(Session session){
		 for(Session client : clients){
	          if (!client.equals(session)){
	            try {
					client.getBasicRemote().sendText("{\"removeId\" : \""+session.getId()+"\"}");
				} catch (IOException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
	          }	          	          
	        }
		 try {
			session.close();
			clients.remove(session);
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		 


		
	}
}
