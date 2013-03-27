//==================================================================================================================================
// webkit.h
/*==================================================================================================================================
Copyright © 2013, Dillon Aumiller <dillonaumiller@gmail.com>
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met: 

1. Redistributions of source code must retain the above copyright notice, this
   list of conditions and the following disclaimer. 
2. Redistributions in binary form must reproduce the above copyright notice,
   this list of conditions and the following disclaimer in the documentation
   and/or other materials provided with the distribution. 

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
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
