//==================================================================================================================================
#import <adenosine/adenosine.h>
#include <stdio.h>

//==================================================================================================================================
GtkWindow  *wndMain;

//==================================================================================================================================
@interface TestTenDelegate : OFObject
@end
//==================================================================================================================================
@implementation TestTenDelegate
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

  //create ScrolledWindow
  GtkScrolledWindow *scroll = [GtkScrolledWindow scrolledWindow];
  scroll.horizontalPolicy   = scroll.verticalPolicy = GTKSCROLLBARSHOW_AUTOMATIC;
  scroll.horizontalExpand   = scroll.verticalExpand = YES;
  [scroll add:tv];

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
