//==================================================================================================================================
#import <adenosine/adenosine.h>
#include <stdio.h>

//==================================================================================================================================
GtkWindow  *wndMain;

//==================================================================================================================================
@interface TestElevenDelegate : OFObject
-(BOOL)gtkListBox:(GtkListBox *)list index:(int)index keyPressed:(unsigned int)keyCode raw:(uint16_t)rawCode group:(uint8_t)group isModifier:(BOOL)isModifier modifiers:(GtkModifier)modifiers;
@end
//==================================================================================================================================
@implementation TestElevenDelegate
-(BOOL)gtkListBox:(GtkListBox *)list index:(int)index keyPressed:(unsigned int)keyCode raw:(uint16_t)rawCode group:(uint8_t)group isModifier:(BOOL)isModifier modifiers:(GtkModifier)modifiers
{
  if(keyCode == 0x0063 /*c*/) //Clone append
  {
    OFAutoreleasePool *pool = [[OFAutoreleasePool alloc] init];
    OFString *text = [[list.labels objectAtIndex:index] text];
    GtkImage *img  = [GtkImage imageFromStock:@"gtk-copy" size:GTKICONSIZE_TOOLBAR_SMALL];
    [list appendItemWithText:text andImage:img];
    [pool drain];
    return YES;
  }

  if((keyCode == 0xFFFF /*Delete*/) || (keyCode == 0xFF08 /*Backspace*/)) //Remove item
  {
    [list removeItemAtIndex:index]; //delete current item
    list.selectedIndex = index;     //select current item in its place
    return YES;
  }

  if((keyCode == 0x002B /*Plus*/) || (keyCode == 0xFFAB /*Add*/)) //Move Down the List
  {
    [list swapItemAtIndex:index withItemAtIndex:index+1];
    list.selectedIndex++;
    return YES;
  }

  if((keyCode == 0x002D /*Minus*/) || (keyCode == 0xFFAD /*Subtract*/)) //Move Up the List
  {
    [list swapItemAtIndex:index withItemAtIndex:index-1];
    if(list.selectedIndex > 0) list.selectedIndex--;
    return YES;
  }

  if(keyCode == 0x0020 /*Space*/) //Cycle Icon Mode
  {
    switch(list.iconMode)
    {
      case GTKLISTBOX_ICONMODE_NONE : list.iconMode = GTKLISTBOX_ICONMODE_LEFT;  break;
      case GTKLISTBOX_ICONMODE_LEFT : list.iconMode = GTKLISTBOX_ICONMODE_RIGHT; break;
      case GTKLISTBOX_ICONMODE_RIGHT: list.iconMode = GTKLISTBOX_ICONMODE_NONE;  break;
    }
    return YES;
  }

  return NO;
}
@end

//==================================================================================================================================
int main(int argc, char **argv)
{
  OFAutoreleasePool *pool = [[OFAutoreleasePool alloc] init];
  OFAutoreleasePool *pool2 = [[OFAutoreleasePool alloc] init];
  [[GtkRuntime sharedRuntime] startup];

  //create Window
  wndMain = [[GtkWindow windowWithType:GTKWINDOWTYPE_TOPLEVEL] retain];
  wndMain.title = @"adenosine - test 11 - GtkListBox";
  wndMain.size  = OMMakeSize(240.0f, 480.0f);
  wndMain.quitOnClose = YES;
  wndMain.borderWidth = 6;

  //create ListBox
  GtkListBox *lb = [GtkListBox listBoxWithText:@[@"List Item Zero", @"List Item One", @"List Item Two"]
                                     andImages:@[[GtkImage imageFromStock:@"gtk-yes"        size:GTKICONSIZE_TOOLBAR_SMALL],
                                                 [GtkImage imageFromStock:@"gtk-no"         size:GTKICONSIZE_TOOLBAR_SMALL],
                                                 [GtkImage imageFromStock:@"gtk-media-stop" size:GTKICONSIZE_TOOLBAR_SMALL]] ];
  lb.scrollScaled     = YES;
  lb.scrollScaleY     = -1.0f;
  lb.verticalExpand   = YES;
  lb.horizontalExpand = YES;
  lb.grid.rowSpacing  = 2;
  lb.iconMode         = GTKLISTBOX_ICONMODE_LEFT;
  lb.shadow           = GTKBORDERSHADOW_BEVEL_IN;
  lb.delegate         = [[[TestElevenDelegate alloc] init] autorelease];

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
