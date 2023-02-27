public Plugin myinfo =
{
	name = "(DF) NameSpam Block",
	author = "daffyy",
	description = "Disallow players to spam name changing",
	version = "1.0",
	url = "https://github.com/daffyyyy/sm-namespamblock"
}

// Variables
ConVar g_cvHowManyTimesAllowed;
ConVar g_cvHowManyTimesAllowedSeconds;
ConVar g_cvBanTime;

int g_iNameChangedTime[MAXPLAYERS +1];
int g_iNameChanged[MAXPLAYERS +1];

bool g_bSourceBans = false;

// Natives
native void SBPP_BanPlayer(int iAdmin, int iTarget, int iTime, const char[] sReason); // SourceBans++

public void OnPluginStart()
{
    g_cvHowManyTimesAllowed = CreateConVar("sm_namespamblock_allowed_times", "10", "How many changes is allowed (Safe value <= 10)");
    g_cvHowManyTimesAllowedSeconds = CreateConVar("sm_namespamblock_allowed_times_seconds", "35", "The time in which you can make max changes, the number of changes reset after it");
    g_cvBanTime = CreateConVar("sm_namespamblock_ban_time", "10", "Ban time length");
    AutoExecConfig(true, "sm_namespamblock");
    LoadTranslations("sm-namespamblock");
}

public APLRes AskPluginLoad2(Handle myself, bool late, char[] error, err_max)
{
	MarkNativeAsOptional("SBPP_BanPlayer");
	
	return APLRes_Success;
}

public void OnAllPluginsLoaded()
{
    // Detect sourcebans++
	g_bSourceBans = LibraryExists("sourcebans++");
}

public void OnLibraryAdded(const char []name)
{
    // Detect sourcebans++
	if (StrEqual(name, "sourcebans++"))
		g_bSourceBans = true;
}

public void OnLibraryRemoved(const char []name)
{
    // Detect sourcebans++
	if (StrEqual(name, "sourcebans++"))
		g_bSourceBans = false;
}

public void OnClientPutInServer(int client)
{
    // Reset variables on client connect
    g_iNameChanged[client] = 0;
    g_iNameChangedTime[client] = 0;
}

public void OnClientDisconnect(int client)
{
    // Reset variables on client disconnect
    g_iNameChanged[client] = 0;
    g_iNameChangedTime[client] = 0;
}

public void OnClientSettingsChanged(int client)
{
    // Check is client valid
    if (!IsFakeClient(client) && IsClientAuthorized(client))
    {
        // Check if client time is greater than actual 
        if (g_iNameChangedTime[client] > GetTime())
        {
            // Add one to changes
            g_iNameChanged[client]++;

            // check if client changes greater than allowed
            if (g_iNameChanged[client] > g_cvHowManyTimesAllowed.IntValue) {
                char banReason[128];
                Format(banReason, sizeof(banReason), "%t", "BanReason");
                
                // Ban client
                if (g_bSourceBans) {
                    SBPP_BanPlayer(0, client, g_cvBanTime.IntValue, banReason);
                } else {
                    BanClient(client, g_cvBanTime.IntValue, BANFLAG_AUTO, banReason)
                }
            }
        } else {
            // Reset client variables, no changes in allowed time
            g_iNameChanged[client] = 0;
            g_iNameChangedTime[client] = GetTime() + g_cvHowManyTimesAllowedSeconds.IntValue;
        }
    }
}
