//==================================================================================================================================
// webkit.h
//==================================================================================================================================
typedef enum
{
  WEBKIT_NAVRESP_ACCEPT,
  WEBKIT_NAVRESP_IGNORE,
  WEBKIT_NAVRESP_DOWNLOAD
} WebKitNavigationResponse;
//----------------------------------------------------------------------------------------------------------------------------------
typedef enum
{
  WEBKIT_TARGETINFO_HTML,
  WEBKIT_TARGETINFO_TEXT,
  WEBKIT_TARGETINFO_IMAGE,
  WEBKIT_TARGETINFO_URILIST,
  WEBKIT_TARGETINFO_NETSCAPEURL
} WebKitTargetInfo;
//----------------------------------------------------------------------------------------------------------------------------------
typedef enum
{
  WEBKIT_LOADSTATUS_PROVISIONAL,
  WEBKIT_LOADSTATUS_COMMITTED,
  WEBKIT_LOADSTATUS_FINISHED,
  WEBKIT_LOADSTATUS_FIRST_VISUAL,
  WEBKIT_LOADSTATUS_FAILED
} WebKitLoadStatus;
//----------------------------------------------------------------------------------------------------------------------------------
typedef enum
{
  WEBKIT_WEBVIEWMODE_WINDOWED,
  WEBKIT_WEBVIEWMODE_FLOATING,
  WEBKIT_WEBVIEWMODE_FULLSCREEN,
  WEBKIT_WEBVIEWMODE_MAXIMIZED,
  WEBKIT_WEBVIEWMODE_MINIMIZED
} WebKitWebViewMode;

#import <adenosine/WebKitWebView.h>
