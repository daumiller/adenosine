//==================================================================================================================================
#import <adenosine/adenosine.h>
#include <stdio.h>

//==================================================================================================================================
GtkWindow  *wndMain;

//==================================================================================================================================
@interface TestNineDelegate : OFObject
-(void)gtkButtonClicked:(GtkButton *)button;
-(void)gtkEntryTextChanged:(GtkEntry *)entry;
@end
//==================================================================================================================================
@implementation TestNineDelegate
-(void)gtkButtonClicked:(GtkButton *)button
{
  [[GtkRuntime sharedRuntime] mainLoopQuit];
}
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-(void)gtkEntryTextChanged:(GtkEntry *)entry
{
  int len = entry.textLength; if(len > 48) len = 48;
  entry.progressValue = (float)len / 48.0f;
}
@end

//==================================================================================================================================
int main(int argc, char **argv)
{
  OFAutoreleasePool *pool = [[OFAutoreleasePool alloc] init];
  OFAutoreleasePool *pool2 = [[OFAutoreleasePool alloc] init];
  [[GtkRuntime sharedRuntime] startup];

  //create delegate
  TestNineDelegate *test9Del = [[TestNineDelegate alloc] init];

  //create Window
  wndMain = [[GtkWindow windowWithType:GTKWINDOWTYPE_TOPLEVEL] retain];
  wndMain.title = @"adenosine - test 9";
  wndMain.size  = OMMakeSize(480.0f, 240.0f);
  wndMain.quitOnClose = YES;

  //create Entry
  GtkEntry *entry = [GtkEntry entry];
  entry.delegate = test9Del;
  entry.placeholder = @"enter some text already";
  entry.maxLength   = 256;
  entry.textAlign   = 0.5f;
  entry.charWidth   = 48;
  entry.activatesDefault = YES;
  [entry setIcon:GTKENTRY_ICON_SECONDARY fromStock:@"gtk-find"];

  //create Button (to take main focus)
  GtkButton *button     = [GtkButton buttonWithAccel:@"Dismiss"];
  button.delegate       = test9Del;
  button.tooltipText    = @"Dismiss and Exit";
  button.canGrabDefault = YES;

  //create layout Grid
  GtkGrid *grid = [GtkGrid grid];
  [grid attachSpacerLeft:0 top:0 width:1 height:1 hExpand:YES hAlign:GTKALIGN_FILL vExpand:YES vAlign:GTKALIGN_FILL];
  [grid attachSpacerLeft:2 top:2 pixelWidth:1 pixelHeight:16];
  [grid attachSpacerLeft:4 top:4 width:1 height:1 hExpand:YES hAlign:GTKALIGN_FILL vExpand:YES vAlign:GTKALIGN_FILL];
  [grid attachWidget:entry left:1 top:1 width:3 height:1];
  [grid attachWidget:button left:2 top:3];

  //window setup
  [wndMain add:grid];
  [button grabDefault]; //accept ENTER from entry since it .activatesDefault (this needs called _after_ added to a window)
  [button grabFocus];   //so we can see entry's placeholder (this needs to happen _after_ they have a common ancestor)

  //parent, wrap, display
  [wndMain wrapAllChildren];
  [wndMain showAll];
  [pool2 drain]; //verify that all ui controls are correctly retained

  [[GtkRuntime sharedRuntime] mainLoopBegin];
  [pool drain];
  return 0;
}

//==================================================================================================================================
//----------------------------------------------------------------------------------------------------------------------------------
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
