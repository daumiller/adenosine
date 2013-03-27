//==================================================================================================================================
// WebKitWebView.h
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
#import <ObjFW/ObjFW.h>
#import <adenosine/GtkContainer.h>
#import <adenosine/WebKit.h>

//==================================================================================================================================
@class WebKitWebView;
@protocol WebKitWebViewDelegate <OFObject>
@optional
-(void)webkitWebView:(WebKitWebView *)webview titleChanged:(OFString *)title;
-(void)webkitWebView:(WebKitWebView *)webview loadStatusChanged:(WebKitLoadStatus)loadStatus;
@end

//==================================================================================================================================
@interface WebKitWebView : GtkContainer

// !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
// TODO:
//  Properties:
//   webkit_web_view_get_back_forward_list
//   webkit_web_view_get_copy_target_list
//   webkit_web_view_get_paste_target_list
//   webkit_web_view_get_dom_document
//   webkit_web_view_get_editable
//   webkit_web_view_set_editable
//   webkit_web_view_get_focused_frame
//   webkit_web_view_get_full_content_zoom
//   webkit_web_view_set_full_content_zoom
//   webkit_web_view_get_hit_test_result
//   webkit_web_view_get_icon_pixbuf
//   webkit_web_view_try_get_favicon_pixbuf
//   webkit_web_view_get_inspector
//   webkit_web_view_get_main_frame
//   webkit_web_view_get_progress
//   webkit_web_view_get_settings
//   webkit_web_view_set_settings
//   webkit_web_view_get_transparent
//   webkit_web_view_set_transparent
//   webkit_web_view_get_view_mode
//   webkit_web_view_set_view_mode
//   webkit_web_view_get_view_source_mode
//   webkit_web_view_set_view_source_mode
//   webkit_web_view_get_viewport_attributes
//   webkit_web_view_set_highlight_text_matches
//   webkit_web_view_set_maintains_back_forward_list
//   webkit_web_view_get_window_features
//   webkit_web_view_get_snapshot
// Utilities:
//   webkit_web_view_go_to_back_forward_item
//   webkit_web_view_load_request
//   webkit_web_view_mark_text_matches
//   webkit_web_view_unmark_text_matches
//   webkit_web_view_move_cursor
//   webkit_web_view_search_text
// Events:
//   close-web-view
//   console-messages
//   context-menu
//   create-web-view
//   download-requested
//   entering-fullscreen
//   geolocation-policy-decision-cancelled
//   geolocation-policy-decision-requested
//   hovering-over-link
//   icon-loaded
//   leaving-fullscreen
//   load-error
//   mime-type-policy-decision-requested
//   navigation-policy-decision-requested
//   navigation-requested
//   new-window-policy-decision-requested
//   onload-event
//   populate-popup
//   print-requested
//   resource-content-length-received
//   resource-load-failed
//   resource-load-finished
//   resource-response-received
//   run-file-chooser
//   script-alert
//   script-confirm
//   script-prompt
//   status-bar-text-changed
//   title-changed
//   web-view-ready
//   window-object-cleared
// !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

//----------------------------------------------------------------------------------------------------------------------------------
+webView;
-initWebView;

//----------------------------------------------------------------------------------------------------------------------------------
@property (readonly) BOOL canCopyClipboard;
@property (readonly) BOOL canCutClipboard;
@property (readonly) BOOL canPasteClipboard;
@property (readonly) BOOL canUndo;
@property (readonly) BOOL canRedo;
@property (readonly) BOOL canGoBack;
@property (readonly) BOOL canGoForward;
@property (readonly) BOOL hasSelection;
@property (readonly) WebKitLoadStatus loadStatus;
@property (readonly) double           progress;
@property (assign)   float            zoomLevel;
@property (readonly) OFString        *title;
@property (readonly) OFString        *uri;
@property (readonly) OFString        *encoding;
@property (assign)   OFString        *customEncoding;

//----------------------------------------------------------------------------------------------------------------------------------
-(BOOL)canGoBackOrForward:(int)steps;
-(BOOL)canShowMimeType:(OFString *)mimeType;
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-(void)goBack;
-(void)goForward;
-(void)goBackOrForward:(int)steps;
-(void)pasteClipboard;
-(void)undo;
-(void)redo;
-(void)selectAll;
-(void)deleteSelection;
-(void)zoomIn;
-(void)zoomOut;
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-(void)reload;
-(void)reloadBypassCache;
-(void)stopLoading;
-(void)loadString:(OFString *)content baseUri:(OFString *)uri;
-(void)loadString:(OFString *)content mimeType:(OFString *)mimeType baseUri:(OFString *)uri;
-(void)loadString:(OFString *)content mimeType:(OFString *)mimeType encoding:(OFString *)encoding baseUri:(OFString *)uri;
-(void)loadUri:(OFString *)uri;
-(void)executeScript:(OFString *)script;

//----------------------------------------------------------------------------------------------------------------------------------
-(void)onTitleChanged;
-(void)onLoadStatusChanged;

@end
//==================================================================================================================================
//----------------------------------------------------------------------------------------------------------------------------------
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
