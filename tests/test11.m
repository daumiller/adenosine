//==================================================================================================================================
#import <adenosine/adenosine.h>
#include <stdio.h>

//==================================================================================================================================
GtkWindow  *wndMain;

//==================================================================================================================================
int main(int argc, char **argv)
{
  OFAutoreleasePool *pool = [[OFAutoreleasePool alloc] init];
  OFAutoreleasePool *pool2 = [[OFAutoreleasePool alloc] init];
  [[GtkRuntime sharedRuntime] startup];

  //create Window
  wndMain = [[GtkWindow windowWithType:GTKWINDOWTYPE_TOPLEVEL] retain];
  wndMain.title = @"adenosine - test 10 - GtkTextView";
  wndMain.size  = OMMakeSize(240.0f, 480.0f);
  wndMain.quitOnClose = YES;
  wndMain.borderWidth = 6;

  //create ListBox
  GtkListBox *lb = [GtkListBox listBoxWithText:@[@"List Item Zero", @"List Item One", @"List Item Two"]];
  lb.scrollScaled     = YES;
  lb.scrollScaleY     = -1.0f;
  lb.verticalExpand   = YES;
  lb.horizontalExpand = YES;
  lb.grid.rowSpacing  = 2;
  lb.shadow = GTKBORDERSHADOW_BEVEL_IN;

  //window setup
  [wndMain add:lb];

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
