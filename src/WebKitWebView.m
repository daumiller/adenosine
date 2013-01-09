//==================================================================================================================================
// WebKitWebView.m
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
#import "WebKitNative.h"
#import <adenosine/adenosine.h>
#import <adenosine/WebKit.h>

//==================================================================================================================================
#define NATIVE_WIDGET  ((struct _GtkWidget     *)_native)
#define NATIVE_WEBVIEW ((struct _WebKitWebView *)_native)

//==================================================================================================================================
// Signal/Event -> Object Proxies
//==================================================================================================================================
static void ConnectionProxy_TitleChanged(struct _WebKitWebView *webView, void *pspec, void *data)
{
  g_object_freeze_notify((GObject *)webView);
  WebKitWebView *obj = (WebKitWebView *)[GtkWidget nativeToWrapper:(void *)webView];
  [obj onTitleChanged];
  g_object_thaw_notify((GObject *)webView);
}
//----------------------------------------------------------------------------------------------------------------------------------
static void ConnectionProxy_LoadStatusChanged(struct _WebKitWebView *webView, void *pspec, void *data)
{
  g_object_freeze_notify((GObject *)webView);
  WebKitWebView *obj = (WebKitWebView *)[GtkWidget nativeToWrapper:(void *)webView];
  [obj onLoadStatusChanged];
  g_object_thaw_notify((GObject *)webView);
}

//==================================================================================================================================
@implementation WebKitWebView

//==================================================================================================================================
// Constructors/Destructor
//==================================================================================================================================
+ webView { return [[[self alloc] initWebView] autorelease]; }
- initWebView
{
  self = [super init];
  if(self)
  {
    _native = webkit_web_view_new();
    [self installNativeLookup];
  }
  return self;
}

//==================================================================================================================================
// Properites
//==================================================================================================================================
-(BOOL)canCopyClipboard              { return webkit_web_view_can_copy_clipboard(NATIVE_WEBVIEW);                     }
-(BOOL)canCutClipboard               { return webkit_web_view_can_cut_clipboard(NATIVE_WEBVIEW);                      }
-(BOOL)canPasteClipboard             { return webkit_web_view_can_paste_clipboard(NATIVE_WEBVIEW);                    }
-(BOOL)canUndo                       { return webkit_web_view_can_undo(NATIVE_WEBVIEW);                               }
-(BOOL)canRedo                       { return webkit_web_view_can_redo(NATIVE_WEBVIEW);                               }
-(BOOL)canGoBack                     { return webkit_web_view_can_go_back(NATIVE_WEBVIEW);                            }
-(BOOL)canGoForward                  { return webkit_web_view_can_go_forward(NATIVE_WEBVIEW);                         }
-(BOOL)hasSelection                  { return webkit_web_view_has_selection(NATIVE_WEBVIEW);                          }
-(WebKitLoadStatus)loadStatus        { return (WebKitLoadStatus)webkit_web_view_get_load_status(NATIVE_WEBVIEW);      }
-(double)progress                    { return webkit_web_view_get_progress(NATIVE_WEBVIEW);                           }
-(float)zoomLevel                    { return webkit_web_view_get_zoom_level(NATIVE_WEBVIEW);                         }
-(void)setZoomLevel:(float)zoomLevel { webkit_web_view_set_zoom_level(NATIVE_WEBVIEW, zoomLevel);                     }
-(OFString *)title                   { const char *str = webkit_web_view_get_title          (NATIVE_WEBVIEW); if(!str) return nil; return [OFString stringWithUTF8String:str]; }
-(OFString *)uri                     { const char *str = webkit_web_view_get_uri            (NATIVE_WEBVIEW); if(!str) return nil; return [OFString stringWithUTF8String:str]; }
-(OFString *)encoding                { const char *str = webkit_web_view_get_encoding       (NATIVE_WEBVIEW); if(!str) return nil; return [OFString stringWithUTF8String:str]; }
-(OFString *)customEncoding          { const char *str = webkit_web_view_get_custom_encoding(NATIVE_WEBVIEW); if(!str) return nil; return [OFString stringWithUTF8String:str]; }
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-(void)setCustomEncoding:(OFString *)customEncoding
{
  if(customEncoding == nil) { webkit_web_view_set_custom_encoding(NATIVE_WEBVIEW, NULL); return; }
  OFAutoreleasePool *pool = [[OFAutoreleasePool alloc] init];
  webkit_web_view_set_custom_encoding(NATIVE_WEBVIEW, [customEncoding UTF8String]);
  [pool drain];
}
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-(void)setDelegate:(id)delegate
{
  [super setDelegate:delegate];
  
  if(_delegate)
  {
    if([_delegate respondsToSelector:@selector(webkitWebView:titleChanged:)])
      [_connections addObject:[OFNumber numberWithUnsignedLong:
        g_signal_connect(_native, "notify::title", G_CALLBACK(ConnectionProxy_TitleChanged),NULL)]];

    if([_delegate respondsToSelector:@selector(webkitWebView:loadStatusChanged:)])
      [_connections addObject:[OFNumber numberWithUnsignedLong:
        g_signal_connect(_native, "notify::load-status", G_CALLBACK(ConnectionProxy_LoadStatusChanged),NULL)]];
  }
}

//==================================================================================================================================
// Utilities
//==================================================================================================================================
-(BOOL)canGoBackOrForward:(int)steps { return webkit_web_view_can_go_back_or_forward(NATIVE_WEBVIEW, steps); }
-(BOOL)canShowMimeType:(OFString *)mimeType
{
  OFAutoreleasePool *pool = [[OFAutoreleasePool alloc] init];
  BOOL result =  webkit_web_view_can_show_mime_type(NATIVE_WEBVIEW, [mimeType UTF8String]);
  [pool drain];
  return result;
}
//----------------------------------------------------------------------------------------------------------------------------------
-(void)goBack                        { webkit_web_view_go_back(NATIVE_WEBVIEW);                   }
-(void)goForward                     { webkit_web_view_go_forward(NATIVE_WEBVIEW);                }
-(void)goBackOrForward:(int)steps    { webkit_web_view_go_back_or_forward(NATIVE_WEBVIEW, steps); }
-(void)pasteClipboard                { webkit_web_view_paste_clipboard(NATIVE_WEBVIEW);           }
-(void)undo                          { webkit_web_view_undo(NATIVE_WEBVIEW);                      }
-(void)redo                          { webkit_web_view_redo(NATIVE_WEBVIEW);                      }
-(void)selectAll                     { webkit_web_view_select_all(NATIVE_WEBVIEW);                }
-(void)deleteSelection               { webkit_web_view_delete_selection(NATIVE_WEBVIEW);          }
-(void)zoomIn                        { webkit_web_view_zoom_in(NATIVE_WEBVIEW);                   }
-(void)zoomOut                       { webkit_web_view_zoom_out(NATIVE_WEBVIEW);                  }
//----------------------------------------------------------------------------------------------------------------------------------
-(void)reload                        { webkit_web_view_reload(NATIVE_WEBVIEW);                    }
-(void)reloadBypassCache             { webkit_web_view_reload_bypass_cache(NATIVE_WEBVIEW);       }
-(void)stopLoading                   { webkit_web_view_stop_loading(NATIVE_WEBVIEW);              }
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-(void)loadString:(OFString *)content baseUri:(OFString *)uri
{
  //(mimeType == NULL) -> "text/html"
  //(encoding == NULL) -> "UTF-8"
  OFAutoreleasePool *pool = [[OFAutoreleasePool alloc] init];
  webkit_web_view_load_string(NATIVE_WEBVIEW, [content UTF8String], NULL, NULL, [uri UTF8String]);
  [pool drain];
}
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-(void)loadString:(OFString *)content mimeType:(OFString *)mimeType baseUri:(OFString *)uri
{
  OFAutoreleasePool *pool = [[OFAutoreleasePool alloc] init];
  webkit_web_view_load_string(NATIVE_WEBVIEW, [content UTF8String], [mimeType UTF8String], NULL, [uri UTF8String]);
  [pool drain];
}
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-(void)loadString:(OFString *)content mimeType:(OFString *)mimeType encoding:(OFString *)encoding baseUri:(OFString *)uri
{
  OFAutoreleasePool *pool = [[OFAutoreleasePool alloc] init];
  webkit_web_view_load_string(NATIVE_WEBVIEW, [content UTF8String], [mimeType UTF8String], [encoding UTF8String], [uri UTF8String]);
  [pool drain];
}
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-(void)loadUri:(OFString *)uri
{
  OFAutoreleasePool *pool = [[OFAutoreleasePool alloc] init];
  webkit_web_view_load_uri(NATIVE_WEBVIEW, [uri UTF8String]);
  [pool drain];
}
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-(void)executeScript:(OFString *)script
{
  OFAutoreleasePool *pool = [[OFAutoreleasePool alloc] init];
  webkit_web_view_execute_script(NATIVE_WEBVIEW, [script UTF8String]);
  [pool drain];
}

//==================================================================================================================================
// Signal Handlers
//==================================================================================================================================
-(void)onTitleChanged
{
  OFAutoreleasePool *pool = [[OFAutoreleasePool alloc] init];
  [_delegate webkitWebView:self titleChanged:self.title];
  [pool drain];
}
//----------------------------------------------------------------------------------------------------------------------------------
-(void)onLoadStatusChanged
{
  [_delegate webkitWebView:self loadStatusChanged:self.loadStatus];
}

//==================================================================================================================================
@end

//==================================================================================================================================
//----------------------------------------------------------------------------------------------------------------------------------
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
