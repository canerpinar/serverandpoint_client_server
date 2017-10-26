package websocketExample.service;

import org.json.JSONException;
import org.json.JSONObject;

public class JsonService {

	public static JSONObject parseJson(String data){
		JSONObject jsonObject;
		        try {
		            jsonObject = new JSONObject(data);
		      } catch (JSONException e) {
		          jsonObject = null;
		            e.printStackTrace();
		      }
		        return jsonObject;
		  }
	}