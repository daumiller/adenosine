//==================================================================================================================================
#import <adenosine/adenosine.h>
#import <adenosine/WebKit.h>
#include <stdio.h>

//==================================================================================================================================
GtkWindow *wndMain;

//==================================================================================================================================
@interface TestSevenDelegate : OFObject
-(void)webkitWebView:(WebKitWebView *)webView titleChanged:(OFString *)title;
@end
//==================================================================================================================================
@implementation TestSevenDelegate
-(void)webkitWebView:(WebKitWebView *)webView titleChanged:(OFString *)title
{
  if(title != nil) wndMain.title = title;
}
@end

//==================================================================================================================================
int main(int argc, char **argv)
{
  OFAutoreleasePool *pool = [[OFAutoreleasePool alloc] init];
  [[GtkRuntime sharedRuntime] startup];

  //create delegate
  TestSevenDelegate *test7Del = [[TestSevenDelegate alloc] init];

  //create Window
  wndMain = [[GtkWindow windowWithType:GTKWINDOWTYPE_TOPLEVEL] retain];
  wndMain.title = @"adenosine - test 7";
  wndMain.size  = OMMakeSize(1024.0f, 720.0f);
  wndMain.quitOnClose = YES;
  
  //create WebView
  WebKitWebView *webView = [WebKitWebView webView];
  webView.delegate = test7Del;

  //create ScrolledWindow
  GtkScrolledWindow *scroller = [GtkScrolledWindow scrolledWindow];
  scroller.horizontalPolicy   = scroller.verticalPolicy = GTKSCROLLBARSHOW_AUTOMATIC;
  
  //parent, wrap, display
  [scroller add:webView];
  [wndMain add:scroller];
  [wndMain wrapAllChildren];
  [wndMain showAll];

  //navigate, focus
  [webView loadUri:@"https://github.com/daumiller/adenosine"];
  [webView grabFocus];

  [[GtkRuntime sharedRuntime] mainLoopBegin];
  [pool drain];
  return 0;
}

//==================================================================================================================================
//----------------------------------------------------------------------------------------------------------------------------------
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
