#include <sourcemod>
#include <clientprefs>
#include <sdktools>

#pragma semicolon 1
#pragma newdecls required

Cookie g_MuteChatTickCookie;

public Plugin myinfo =  {
	name = "[CSGO] Chat Tick Muter", 
	author = "Natanel 'LuqS'", 
	description = "Allows players to mute the annoying \"tick\" sound from chat messages.", 
	version = "1.0.0", 
	url = "https://steamcommunity.com/id/luqsgood || Discord: LuqS#6505 || https://github.com/Natanel-Shitrit"
};

public void OnPluginStart()
{
	if (GetEngineVersion() != Engine_CSGO)
		SetFailState("This plugin is for CSGO only.");
	
	HookUserMessage(GetUserMessageId("SayText2"), OnSayText2, true);
	
	g_MuteChatTickCookie = new Cookie("chat_tick_muter_enabled", "whether or not to mute the clicking sound from chat messages.", CookieAccess_Private);
	g_MuteChatTickCookie.SetPrefabMenu(CookieMenu_OnOff_Int, "Mute the ticking sound from chat messages.");
}

public Action OnSayText2(UserMsg msg_id, Protobuf msg, const int[] players, int playersNum, bool reliable, bool init)
{
	int client = players[0];
	bool make_tick = true;
	
	if (AreClientCookiesCached(client))
	{
		char cookie_value[2];
		g_MuteChatTickCookie.Get(client, cookie_value, sizeof(cookie_value));
				
		if (StringToInt(cookie_value)) make_tick = false;
	}
	
	msg.SetBool("chat", make_tick);
	return Plugin_Changed;
}