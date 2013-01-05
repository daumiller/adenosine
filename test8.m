//==================================================================================================================================
#import <adenosine/adenosine.h>
#include <stdio.h>

//==================================================================================================================================
GtkWindow  *wndMain;

//==================================================================================================================================
@interface TestEightDelegate : OFObject
-(void)gtkMenuItemActivated:(GtkMenuItem *)menuItem;
-(void)gtkMenuCheck:(GtkMenuCheck *)menuCheck toggled:(BOOL)isChecked;
@end
//==================================================================================================================================
@implementation TestEightDelegate
-(void)gtkMenuItemActivated:(GtkMenuItem *)menuItem
{
  if([menuItem.text compare:@"E_xit"] == OF_ORDERED_SAME)
    [[GtkRuntime sharedRuntime] mainLoopQuit];
}
-(void)gtkMenuCheck:(GtkMenuCheck *)menuCheck toggled:(BOOL)isChecked
{
  OFAutoreleasePool *pool = [[OFAutoreleasePool alloc] init];
  printf("Check or Radio menu item \"%s\" isChecked set to %s\n", [menuCheck.text UTF8String], isChecked ? "YES" : "NO");
  [pool drain];
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

  //create "Settings" menu
  GtkMenuItem *mnuSettings = [GtkMenuItem menuItemWithAccel:@"Settings"];
  GtkMenu *mnuSettingsSub  = [GtkMenu menu];
  [mnuSettingsSub append:[GtkMenuCheck menuCheckWithAccel:@"_Toggle Me" andDelegate:test8Del]];
  [mnuSettingsSub appendSeparator];
  GtkMenuRadio *optA = [GtkMenuRadio menuRadioWithGroup:NULL andAccel:@"Option _A" andDelegate:test8Del];
  GtkMenuRadio *optB = [GtkMenuRadio menuRadioWithSibling:optA andAccel:@"Option _B" andDelegate:test8Del];
  [mnuSettingsSub append:optA];
  [mnuSettingsSub append:optB];
  [mnuSettingsSub append:[GtkMenuRadio menuRadioWithSibling:optA andAccel:@"Option _C" andDelegate:test8Del]];
  optB.isChecked = YES;
  mnuSettings.submenu = mnuSettingsSub;

  //create "Help" menu
  GtkMenuItem *mnuHelp = [GtkMenuItem menuItemWithAccel:@"_Help"];
  GtkMenu *mnuHelpSub = [GtkMenu menu];
  [mnuHelpSub append:[GtkMenuImage menuImageFromStock:@"gtk-about"]];
  mnuHelp.submenu = mnuHelpSub;

  //create MenuBar
  GtkMenuBar *mnuMain = [[GtkMenuBar alloc] initMenuBar];
  [mnuMain append:mnuFile];
  [mnuMain append:mnuSettings];
  [mnuMain append:mnuHelp];
  mnuMain.horizontalExpand = YES;

  //create layout
  GtkGrid *grid = [GtkGrid grid];
  [grid attachWidget:mnuMain left:0 top:0];
  [grid insertRowAtIndex:1];
  
  //parent, wrap, display
  [wndMain add:grid];
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
