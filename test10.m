//==================================================================================================================================
#import <adenosine/adenosine.h>
#include <stdio.h>

//==================================================================================================================================
GtkWindow  *wndMain;

//==================================================================================================================================
@interface TestTenDelegate : OFObject
-(void)gtkTextBufferChanged:(GtkTextBuffer *)buffer;
@end
//==================================================================================================================================
@implementation TestTenDelegate
-(void)gtkTextBufferChanged:(GtkTextBuffer *)buffer
{
  if(!buffer.modified)
  {
    buffer.modified = YES;
    OFAutoreleasePool *pool = [[OFAutoreleasePool alloc] init];
    wndMain.title = [wndMain.title stringByAppendingString:@"*"];
    [pool drain];
  }
}
@end

//==================================================================================================================================
int main(int argc, char **argv)
{
  OFAutoreleasePool *pool = [[OFAutoreleasePool alloc] init];
  OFAutoreleasePool *pool2 = [[OFAutoreleasePool alloc] init];
  [[GtkRuntime sharedRuntime] startup];

  //create delegate
  TestTenDelegate *test10Del = [[TestTenDelegate alloc] init];

  //create Window
  wndMain = [[GtkWindow windowWithType:GTKWINDOWTYPE_TOPLEVEL] retain];
  wndMain.title = @"adenosine - test 10 - GtkTextView";
  wndMain.size  = OMMakeSize(480.0f, 240.0f);
  wndMain.quitOnClose = YES;

  //create TextView
  GtkTextView *tv = [GtkTextView textView];
  tv.buffer.text = @"Hello TextView World!!!";
  tv.buffer.modified = NO;
  tv.buffer.delegate = test10Del;

  //create ScrolledWindow
  GtkScrolledWindow *scroll = [GtkScrolledWindow scrolledWindow];
  scroll.horizontalPolicy   = scroll.verticalPolicy = GTKSCROLLBARSHOW_AUTOMATIC;
  scroll.horizontalExpand   = scroll.verticalExpand = YES;
  [scroll add:tv];
  //i really, really HATE this...
  //a WebKitWebView contained in a ScrolledWindow respect's the System's reverse/natural device scrolling,
  //but for whatever reason, a TextView in a ScrolledWindow does not.
  //i found zero answers on #gtk+, and googling turns up nothing but a couple of only-possibly related os-level bug reports.
  //it would probably be worth putting some global into GtkRuntime that ScrolledWindow's would look up,
  //but i don't want to look into finding this value per-OS and per-device right now...
  //for now, we'll rely on per-app user-settings, and a "scrollScale" ScrolledWindow property as work-arounds... :|
  scroll.scrollScaleY = -1.0f;
  scroll.scrollScaled = YES;

  //create layout Grid
  GtkGrid *grid  = [GtkGrid grid];
  [grid attachSpacerLeft:0 top:0 pixelWidth:16 pixelHeight:16];
  [grid attachSpacerLeft:2 top:2 pixelWidth:16 pixelHeight:16];
  [grid attachWidget:scroll left:1 top:1];

  //window setup
  [wndMain add:grid];
  [tv grabFocus];

  //parent, wrap, display
  [wndMain wrapAllChildren];
  [wndMain showAll];
  [pool2 drain];

  [[GtkRuntime sharedRuntime] mainLoopBegin];
  [pool drain];
  return 0;
}

//==================================================================================================================================
//----------------------------------------------------------------------------------------------------------------------------------
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
