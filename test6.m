//==================================================================================================================================
#import <adenosine/adenosine.h>
#include <stdio.h>

//==================================================================================================================================
typedef struct
{
  GtkWindow       *window;
  GtkNotebook     *tabPages;
  GtkButton       *btnToggle;
  GtkComboBoxText *cmbOptions;
  GtkLabel        *lblOptions;
} wndMainUI;

//==================================================================================================================================
wndMainUI wndMain;

//==================================================================================================================================
@interface TestSixDelegate : OFObject
-(void)gtkButtonClicked:(GtkButton *)button;
-(void)gtkComboBoxChanged:(GtkComboBox *)combo;
-(void)gtkNotebook:(GtkNotebook *)notebook pageReordered:(GtkWidget *)page toIndex:(int)index;
-(void)gtkNotebook:(GtkNotebook *)notebook pageChanged  :(GtkWidget *)page toIndex:(int)index;
@end

//==================================================================================================================================
@implementation TestSixDelegate
-(void)gtkButtonClicked:(GtkButton *)button
{
  if(wndMain.tabPages.isReorderable)
  {
    wndMain.tabPages.isReorderable = NO;
    button.text = @"Enable _Reordering";
  }
  else
  {
    wndMain.tabPages.isReorderable = YES;
    button.text = @"Disable _Reordering";
  }
}
//----------------------------------------------------------------------------------------------------------------------------------
-(void)gtkComboBoxChanged:(GtkComboBox *)combo
{
  wndMain.lblOptions.text = ((GtkComboBoxText *)combo).activeText;
}
//----------------------------------------------------------------------------------------------------------------------------------
-(void)gtkNotebook:(GtkNotebook *)notebook pageReordered:(GtkWidget *)page toIndex:(int)index
{
  OFAutoreleasePool *pool = [[OFAutoreleasePool alloc] init];
  printf("Page %s moved to new index %d\n", [[wndMain.tabPages idOfIndex:index] UTF8String], index);
  [pool drain];
}
//----------------------------------------------------------------------------------------------------------------------------------
-(void)gtkNotebook:(GtkNotebook *)notebook pageChanged:(GtkWidget *)page toIndex:(int)index
{
  OFAutoreleasePool *pool = [[OFAutoreleasePool alloc] init];
  printf("Active page set to %s, index %d\n", [[wndMain.tabPages idOfIndex:index] UTF8String], index);
  [pool drain];
}
@end


//==================================================================================================================================
int main(int argc, char **argv)
{
  OFAutoreleasePool *pool = [[OFAutoreleasePool alloc] init];
  [[GtkRuntime sharedRuntime] startup];

  //create Delegate
  TestSixDelegate *test6D = [[TestSixDelegate alloc] init];

  //create Window
  wndMain.window = [[GtkWindow windowWithType:GTKWINDOWTYPE_TOPLEVEL] retain];
  wndMain.window.title = @"adenosine - test 6";
  wndMain.window.size = OMMakeSize(480.0f, 320.0f);
  wndMain.window.quitOnClose = YES;

  //create Notebook
  wndMain.tabPages = [GtkNotebook notebook];
  wndMain.tabPages.isReorderable = NO;
  wndMain.tabPages.delegate = test6D;
  [wndMain.window add:wndMain.tabPages];

  //create first Notebook Page
  GtkGrid *gridPage1 = [GtkGrid grid];
  gridPage1.forceEqualRows = YES;
  gridPage1.forceEqualColumns = YES;
  wndMain.btnToggle = [GtkButton buttonWithAccel:@"Enable _Reordering"];
  wndMain.btnToggle.delegate = test6D;
  [gridPage1 attachSpacerLeft:0 top:0 width:1 height:1];
  [gridPage1 attachWidget:wndMain.btnToggle left:1 top:1 width:1 height:1];
  [gridPage1 attachSpacerLeft:2 top:2 width:1 height:1];
  [wndMain.tabPages appendPage:gridPage1 withTextLabel:@"Reorder" andID:@"tab.reorder"];

  //create second Notebook Page
  GtkGrid *gridPage2 = [GtkGrid grid];
  [wndMain.tabPages appendPage:gridPage2 withTextLabel:@"              " andID:@"tab.empty"];

  //create third Notebook Page
  GtkGrid *gridPage3 = [GtkGrid grid];
  wndMain.cmbOptions = [GtkComboBoxText comboBoxTextEntry];
  [wndMain.cmbOptions appendText:@"Canned Option O"];
  [wndMain.cmbOptions appendText:@"Canned Option C"];
  [wndMain.cmbOptions appendText:@"Canned Option M"];
  wndMain.cmbOptions.horizontalExpand = YES;
  wndMain.cmbOptions.horizontalAlign  = GTKALIGN_CENTER;
  wndMain.cmbOptions.delegate = test6D;
  wndMain.lblOptions = [GtkLabel labelWithText:@""];

  [gridPage3 attachSpacerLeft:2 top:0 width:1 height:1 hExpand:NO hAlign:GTKALIGN_CENTER vExpand:YES vAlign:GTKALIGN_FILL];
  [gridPage3 attachWidget:wndMain.cmbOptions left:1 top:1 width:3 height:1];
  [gridPage3 attachSpacerLeft:2 top:2 pixelWidth:1 pixelHeight:16];
  [gridPage3 attachWidget:wndMain.lblOptions left:2 top:3 width:1 height:1];
  [gridPage3 attachSpacerLeft:2 top:4 width:1 height:1 hExpand:NO hAlign:GTKALIGN_CENTER vExpand:YES vAlign:GTKALIGN_FILL];

  [wndMain.tabPages appendPage:gridPage3 withTextLabel:@"Options" andID:@"tab.options"];

  [wndMain.window wrapAllChildren]; //will do all non-toplevel retaining for us
  [wndMain.window showAll];

  [[GtkRuntime sharedRuntime] mainLoopBegin];
  //[wndMain.window release];
  //[test6D release];
  [pool drain];
  return 0;
}
