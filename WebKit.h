//==================================================================================================================================
// webkit.h
/*==================================================================================================================================
Copyright © 2013 Dillon Aumiller <dillonaumiller@gmail.com>

This file is part of the adenosine library.

adenosine is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, version 3 of the License.

adenosine is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with adenosine.  If not, see <http://www.gnu.org/licenses/>.
==================================================================================================================================*/
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
