<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<script src="https://npmcdn.com/tether@1.2.4/dist/js/tether.min.js"></script>
	<script type="text/javascript" src="resources/js/jquery-3.2.1.min.js"></script>
	<script type="text/javascript" src="resources/bootstrap-4.0.0-alpha.6-dist/js/bootstrap.min.js"></script>
	<link rel="stylesheet" type="text/css" href="resources/bootstrap-4.0.0-alpha.6-dist/css/bootstrap.min.css" />
</head>
<body>


	<form>
		<input id="message" type="text" required="required" />
		<input value="Gönder" type="button" onclick="wsSentMessage();"/>
		<input value="Kapat" type="button" onclick="wsCloseConnect();" />
	</form>
	<div id="outText"></div>
	
    <br/>	    
    
	<div style="float: right;">
		<div id="users" style="background-color: silver; width: 250px; border: 2px solid; border-radius: 25px;"></div>	
		<div style="float: right; cursor:pointer; background-color: aqua; border: 2px solid; border-radius: 25px; width: 250px;" onclick="clickChat();">Online Sohbet</div>
	</div>
	<script type="text/javascript">
		var username = getParameterByName("username");
		var destinationUser;
		var sentId;
		var websocket = new WebSocket("ws://localhost:8080/websocketExample/websocket/"+username);
		var message = document.getElementById("message");
		var outText = document.getElementById("outText");
		var users = document.getElementById("users");
		var privateMessageAll="";
		
		var listMessages =[];
		var listMessage = {};
		
		websocket.onopen = function(message){wsOpen(message);};
		websocket.onmessage = function(message){wsGetMessage(message);};
		websocket.onclose = function (message){wsCloseConnect(message);};
		
		
		//if data is JSON
		function IsJsonString(str) {
		    try {
		        JSON.parse(str);
		    } catch (e) {
		        return false;
		    }
		    return true;
		}
		
		
		function wsGetMessage(message) {
			//alert("message data" + message.data);
						
			var mesaj = JSON.parse(message.data);
			
			
			//alert(mesaj.privateMessage);
			if(typeof mesaj.privateMessage !== "undefined")
			{	
				
				
				//alert(mesaj.privateMessage);
				//alert(mesaj.username);
				//alert(mesaj.sessionId);
				var div = "#div_"+mesaj.sessionId;
				$(div).css("background-color","aqua");
			
				var privateMessageText = "";
				var status = "false";
				listMessages.forEach(function(message){					
					if(message.divId === div){
						privateMessageAll = "<span>"+mesaj.username+"</span> : "+ mesaj.privateMessage +"<br/>";
						message.text += privateMessageAll;
						status = "true";
						privateMessageText = message.text;
						$("#privateMessages").html(privateMessageText);
						
					}					
				});
				
				if(status === "false"){
					var listMessage = {};
					listMessage.divId = div;					
					listMessage.text = "";
					listMessage.text += "<span>"+mesaj.username+"</span> : "+ mesaj.privateMessage +"<br/>";	
					listMessages.push(listMessage);
					privateMessageText = listMessage.text;
					$("#privateMessages").html(privateMessageText);
					
				}						
				/*
				listMessages.forEach(function(message){
					var status="false";
					if(message.divId === div){																								
						alert("asdaaaaaaaa");
						message.text = message.text + privateMessageAll;
						privateMessageText = messageText;
						status="true";
					}
				});
				*/
				alert(privateMessageText);
				privateMessageAll = "";
				
				
			}
			
			
			//alert("sdasd "+mesaj.ileti);			
				
				var json = JSON.parse(message.data);
				//alert("message_data_1 "+ json);
				
				for(var i=0; i < json.length ;i++){
				    var obj = json[i];
				    //console.log(obj.ad);
				    users.innerHTML +='<div id=\"div_'+obj.id+'\" style="position:relative; border-radius: 25px; left:20px; color:black; font-size:larger; width:200px;" onclick="userChat(\''+obj.ad+'\',\''+obj.id+'\')";>'+obj.ad+'</div>';					
				}
				
			if(typeof mesaj.adi !== "undefined")
			{
				//alert("message data_2" + message.data);
				users.innerHTML +='<div id=\"div_'+mesaj.id+'\" style="position:relative; border-radius: 25px; left:20px; color:black; font-size:larger; width:200px;" onclick="userChat(\''+mesaj.adi+'\',\''+mesaj.id+'\')";>'+mesaj.adi+'</div>';
			}
			
			if(typeof mesaj.ileti !== "undefined")
			{
				//alert("message data_2" + message.data);
				//users.innerHTML +="<span style='position:relative; left:20px; color:black; font-size:larger; width:250px;' onclick='userChat();'>"+mesaj.adi+"</span><br/>";
				outText.innerHTML +=mesaj.ileti;
			}
			
			
			if(typeof mesaj.removeId !== "undefined"){
				alert(mesaj.removeId);
				var removeDiv = "div_"+mesaj.removeId;
				var element = document.getElementById(removeDiv);
				element.outerHTML = "";
				delete element;
			}	
		
			
			
			//users.innerHTML +="<span style='position:relative; left:20px; color:black; font-size:larger; width:250px;' onclick='userChat();'>"+mesaj.ad+"</span><br/>";								
		}
		
		
		
		function createListMessage(user,id){			
			var status = "false";
			listMessages.forEach(function(message){
				//alert(message.divId);
				//alert(message.text);				
				if(message.divId === id){
					//alert("div id"+message.divId);
					//alert("id :" +message.id);
					$("#privateMessages").html(message.text);
					status = "true";
				}				
			});
			
			if(status==="false"){
				var listMessage = {};
				listMessage.divId = id;
				listMessage.text = "";
				listMessages.push(listMessage);
				$("#privateMessages").html("");
			}			
			
		}
		
		function userChat(user,id) {
			//alert("user");
			$("#privateMessage").html("");
			//alert("kullanici ad "+user+ " id"+id);
			$("#modalHeader").text(user);
			$("#myModal").modal();
			sentId=id;
			destinationUser=user;
			var div = "#div_"+sentId;
			$(div).css("background-color","silver");
			createListMessage(user,div);
			/*
			websocket.send(JSON.stringify({
				username:user,
				userId:id
			}));
			*/
		}
		
		function sentPrivateMessage() {
			//alert(username + sentId +$("#privateMessage").val());
			var privateMessage=$("#privateMessage").val();			
			websocket.send(JSON.stringify({
				message:privateMessage,
				sentId:sentId,
				username:destinationUser
			}));
									
			listMessages.forEach(function(message){								
				if(message.divId === "#div_"+sentId){
					privateMessageAll +="<span>Sen</span> : "+ privateMessage +"<br/>";
					message.text = message.text + privateMessageAll;					
					//$("#privateMessages").html(message.text);
					privateMessageAll = message.text;
				}				
			});
			$("#privateMessages").html(privateMessageAll);
			privateMessageAll = "";
		}
		
		function wsOpen(message){
			console.log("connect");
			users.innerHTML +="<div style='position:relative; left:20px; border-radius: 25px; color:black; font-size:larger;' onclick='userChat(); width:200px;'>"+username+"</div>";		
		}
		
		//for login user sent
		function wsSentUsername(user){
			websocket.send(user);
		}
		
		
		//for meessage send
		function wsSentMessage(){
			var username = getParameterByName("username");
			websocket.send(JSON.stringify({
				  message: message.value,
				  user:username
				}));
			outText.innerHTML +="<p><span  style='color:red'>"+username+("</span> diyorki ")+message.value+"</p>";
			message.value="";
			
			
			//private message
			
		}
				
		function wsCloseConnect(){
			websocket.close();
		}
		
		//for querstring
		function getParameterByName(name, url) {
		    if (!url) url = window.location.href;
		    name = name.replace(/[\[\]]/g, "\\$&");
		    var regex = new RegExp("[?&]" + name + "(=([^&#]*)|&|#|$)"),
		        results = regex.exec(url);
		    if (!results) return null;
		    if (!results[2]) return '';
		    return decodeURIComponent(results[2].replace(/\+/g, " "));
		}
		
		function clickChat() {
			alert("sohbet click");
		}
		
		function sentPrivateMessages() {
			listMessages.forEach(function(message){								
					//alert(message.divId);				
			});
		}
		
		window.onbeforeunload = function(){
			wsCloseConnect();
		}
			
	</script>

 <div class="modal fade" id="myModal" role="dialog">
    <div class="modal-dialog">
    
      <!-- Modal content-->
      <div class="modal-content">
        <div class="modal-header">
          <button type="button" class="close" data-dismiss="modal">&times;</button>
          <h4 id="modalHeader" class="modal-title"></h4>
        </div>
        <div class="modal-body">
          <div id="privateMessages"></div>
          
          <input type="text" id="privateMessage" name="privateMessage" width="100"/><br/>
          
          <input type="button" onclick="sentPrivateMessage();" value="Gönder" />
         
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
        </div>
      </div>
      
    </div>
  </div>



</body>
</html>
