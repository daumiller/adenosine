//==================================================================================================================================
#import <adenosine/adenosine.h>
#include <stdio.h>

//==================================================================================================================================
GtkWindow  *wndMain;

//==================================================================================================================================
@interface TestEightDelegate : OFObject
-(void)gtkMenuItemActivated:(GtkMenuItem *)menuItem;
@end
//==================================================================================================================================
@implementation TestEightDelegate
-(void)gtkMenuItemActivated:(GtkMenuItem *)menuItem
{
  if([menuItem.text compare:@"E_xit"] == OF_ORDERED_SAME)
    [[GtkRuntime sharedRuntime] mainLoopQuit];
}
@end

//==================================================================================================================================
int main(int argc, char **argv)
{
  OFAutoreleasePool *pool = [[OFAutoreleasePool alloc] init];
  OFAutoreleasePool *pool2 = [[OFAutoreleasePool alloc] init];
  [[GtkRuntime sharedRuntime] startup];

  //create delegate
  TestEightDelegate *test8Del = [[TestEightDelegate alloc] init];

  //create Window
  wndMain = [[GtkWindow windowWithType:GTKWINDOWTYPE_TOPLEVEL] retain];
  wndMain.title = @"adenosine - test 8";
  wndMain.size  = OMMakeSize(800.0f, 640.0f);
  wndMain.quitOnClose = YES;

  //create "File" menu
  GtkMenuItem *mnuFile = [GtkMenuItem menuItemWithAccel:@"_File"];
  GtkMenu *mnuFileSub  = [GtkMenu menu];
  [mnuFileSub append:[GtkMenuItem menuItemWithAccel:@"_Open" andDelegate:test8Del]];
  [mnuFileSub append:[GtkMenuItem menuItemWithAccel:@"_Save" andDelegate:test8Del]];
  [mnuFileSub append:[GtkMenuSeparator separator]];
  [mnuFileSub append:[GtkMenuItem menuItemWithAccel:@"E_xit" andDelegate:test8Del]];
  mnuFile.submenu = mnuFileSub;

  //create MenuBar
  GtkMenuBar *mnuMain = [[GtkMenuBar alloc] initMenuBar];
  [mnuMain append:mnuFile];
  mnuMain.horizontalExpand = YES;

  //create layout
  GtkGrid *grid = [GtkGrid grid];
  [grid attachWidget:mnuMain left:0 top:0];
  [grid insertRowAtIndex:1];
  
  //parent, wrap, display
  [wndMain add:grid];
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
