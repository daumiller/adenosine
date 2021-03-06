// Attempting something similar to: https://github.com/aaronvegh/nsregextester
//==================================================================================================================================
#import <adenosine/adenosine.h>
#import <OFRegex.h>
#include <stdio.h>

#define REVERSE_VERTICAL_SCROLLING YES

//==================================================================================================================================
GtkWindow  *wndMain;
GtkWindow  *wndHelp;

//==================================================================================================================================
@interface ExtraTestZeroDelegate : OFObject
-(BOOL)gtkWindowShouldClose:(GtkWindow *)window;
-(void)gtkEntryTextChanged:(GtkEntry *)entry;
-(void)gtkTextBufferChanged:(GtkTextBuffer *)buffer;
-(void)gtkEntry:(GtkEntry *)entry iconReleased:(GtkEntryIcon)icon withButton:(int)button;
-(void)updateRegex;
-(void)highlightRangeFrom:(int)start to:(int)end;
@end
//==================================================================================================================================
@implementation ExtraTestZeroDelegate
//----------------------------------------------------------------------------------------------------------------------------------
-(BOOL)gtkWindowShouldClose:(GtkWindow *)window
{
  [window hide];
  return NO;
}
//----------------------------------------------------------------------------------------------------------------------------------
-(void)gtkEntryTextChanged:(GtkEntry *)entry
{
  [self updateRegex];
}
//----------------------------------------------------------------------------------------------------------------------------------
-(void)gtkTextBufferChanged:(GtkTextBuffer *)buffer
{
  [self updateRegex];
}
//----------------------------------------------------------------------------------------------------------------------------------
-(void)gtkEntry:(GtkEntry *)entry iconReleased:(GtkEntryIcon)icon withButton:(int)button
{
  if(icon == GTKENTRY_ICON_SECONDARY)
    [wndHelp showAll];
}
//----------------------------------------------------------------------------------------------------------------------------------
-(void)updateRegex
{
  GtkEntry    *textRegex  = (GtkEntry    *)[wndMain getProperty:@"textRegex" ];
  GtkTextView *textSource = (GtkTextView *)[wndMain getProperty:@"textSource"];
  GtkTextView *textDest   = (GtkTextView *)[wndMain getProperty:@"textDest"  ];

  OFAutoreleasePool *pool = [[OFAutoreleasePool alloc] init];
  OFString *strRegex = textRegex.text;
  textDest.buffer.text = textSource.buffer.text;
  if(strRegex.length > 0)
  {
    OFRegex  *regex = [OFRegex regexWithPattern:strRegex];
    if(regex.valid)
    {
      textRegex.progressValue = 0.000000f;
      //i think OFRegex could maybe use something more friendly here, like a block match iterator?
      OFString *src = textSource.buffer.text;
      int maxLen = src.length, index = 0, start;
      OFArray *matches = [regex execute:src fromIndex:index];
      while((matches.count > 0) && (index < maxLen))
      {
        index   = [[matches objectAtIndex:1] intValue];
        start   = index - ((OFString *)[matches objectAtIndex:0]).length;
        [self highlightRangeFrom:start to:index];
        matches = [regex execute:src fromIndex:index];
      }
    }
    else
      textRegex.progressValue = 1.0f;
    //this (overrideBackgroundColor) would be sooo much nicer, but doesn't work anymore because GTK+ theming is retarded...
    //[textRegex overrideBackgroundColor:OMMakeColorRGB(1.0f, 0.0f, 0.0f) forState:GTKWIDGET_STATE_NORMAL];
  }
  else
    textRegex.progressValue = 0.000000f;
  [pool drain];
}
//----------------------------------------------------------------------------------------------------------------------------------
-(void)highlightRangeFrom:(int)start to:(int)end
{
  OFAutoreleasePool *pool = [[OFAutoreleasePool alloc] init];
  GtkTextView *textDest = (GtkTextView *)[wndMain getProperty:@"textDest"];
  [textDest.buffer applyTagNamed: @"highlight"
                            from: [textDest.buffer createIteratorForOffset:start]
                              to: [textDest.buffer createIteratorForOffset:end]];
  [pool drain];
}
//----------------------------------------------------------------------------------------------------------------------------------
@end

//==================================================================================================================================
int main(int argc, char **argv)
{
  OFAutoreleasePool *pool = [[OFAutoreleasePool alloc] init];
  OFAutoreleasePool *pool2 = [[OFAutoreleasePool alloc] init];
  [[GtkRuntime sharedRuntime] startup];

  //create delegate
  ExtraTestZeroDelegate *exTest0Del = [[ExtraTestZeroDelegate alloc] init];

  //create help Window
  wndHelp = [[GtkWindow windowWithType:GTKWINDOWTYPE_TOPLEVEL] retain];
  wndHelp.title    = @"OFRegexTester - Help";
  wndHelp.size     = OMMakeSize(750.0f, 400.0f);
  wndHelp.delegate = exTest0Del;
  //create help Image
  GtkImage *imgHelp = [GtkImage imageWithFile:@"./regex.png"];
  //and its container
  GtkScrolledWindow *scrollHelp = [GtkScrolledWindow scrolledWindow];
  scrollHelp.horizontalExpand = scrollHelp.verticalExpand = YES;
  scrollHelp.scrollScaleY = -1.0f; scrollHelp.scrollScaled = REVERSE_VERTICAL_SCROLLING;
  [scrollHelp addWithViewport:imgHelp];
  [wndHelp add:scrollHelp];
  [wndHelp wrapAllChildren];

  //create main Window
  wndMain = [[GtkWindow windowWithType:GTKWINDOWTYPE_TOPLEVEL] retain];
  wndMain.title = @"OFRegexTester";
  wndMain.size  = OMMakeSize(600.0f, 400.0f);
  wndMain.quitOnClose = YES;

  //create regex Entry
  GtkEntry *textRegex        = [GtkEntry entry];
  textRegex.delegate         = exTest0Del;
  textRegex.placeholder      = @"enter your regular expression";
  textRegex.textAlign        = 0.5f;
  textRegex.horizontalExpand = YES;
  [textRegex setIcon:GTKENTRY_ICON_SECONDARY fromStock:@"gtk-help"];
  textRegex.iconSecondaryTooltipText = @"Display Regex Help";

  //create source TextView
  GtkTextView *textSource     = [GtkTextView textView];
  textSource.buffer.delegate  = exTest0Del;
  textSource.marginLeft = textSource.marginRight = 6;
  //and its container
  GtkScrolledWindow *scrollSource = [GtkScrolledWindow scrolledWindow];
  scrollSource.horizontalExpand = scrollSource.verticalExpand = YES;
  scrollSource.scrollScaleY = -1.0f; scrollSource.scrollScaled = REVERSE_VERTICAL_SCROLLING;
  [scrollSource add:textSource];
  //set default font size
  GtkTextTag *tagSourceSize = [GtkTextTag textTagWithName:@"fontSizeSetter"];
  tagSourceSize.sizePoints = 12.0;
  [textSource.buffer.tagTable add:tagSourceSize];
  [textSource.buffer applyTagNamed: @"fontSizeSetter"
                              from: [textSource.buffer createIteratorForStart]
                                to: [textSource.buffer createIteratorForEnd]];

  //create destination TextView
  GtkTextView *textDest = [GtkTextView textView];
  textDest.editable     = NO;
  textDest.marginLeft = textDest.marginRight = 6;
  //and its highlighter
  GtkTextTag *tagHighlight   = [GtkTextTag textTagWithName:@"highlight"];
  tagHighlight.background    = OMMakeColorRGB(1.0f, 1.0f, 0.0f);
  tagHighlight.foreground    = OMMakeColorRGB(0.0f, 0.0f, 0.0f);
  [textDest.buffer.tagTable add:tagHighlight];
  //and its container
  GtkScrolledWindow *scrollDest = [GtkScrolledWindow scrolledWindow];
  scrollDest.horizontalExpand   = scrollDest.verticalExpand = YES;
  scrollDest.scrollScaleY = -1.0f; scrollDest.scrollScaled = REVERSE_VERTICAL_SCROLLING;
  [scrollDest add:textDest];
  //set default font size
  GtkTextTag *tagDestSize = [GtkTextTag textTagWithName:@"fontSizeSetter"];
  tagDestSize.sizePoints = 12.0;
  [textDest.buffer.tagTable add:tagDestSize];
  [textDest.buffer applyTagNamed: @"fontSizeSetter"
                              from: [textDest.buffer createIteratorForStart]
                                to: [textDest.buffer createIteratorForEnd]];

  //create Grid
  GtkGrid *layout = [GtkGrid grid];
  [layout attachSpacerLeft:0 top:0 pixelWidth:16 pixelHeight:16];
  [layout attachWidget:textRegex left:1 top:1 width:3 height:1];
  [layout attachSpacerLeft:0 top:2 pixelWidth:16 pixelHeight: 8];
  [layout attachWidget:[GtkLabel labelWithText:@"Your Test Text:"] left:1 top:3];
  [layout attachWidget:[GtkLabel labelWithText:@"Matches:"] left:3 top:3];
  [layout attachWidget:scrollSource left:1 top:4];
  [layout attachSpacerLeft:2 top:4 pixelWidth:12 pixelHeight:12];
  [layout attachWidget:scrollDest left:3 top:4];
  [layout attachSpacerLeft:4 top:5 pixelWidth:16 pixelHeight:16];

  //window setup
  [wndMain setProperty:@"textSource" toValue:textSource];
  [wndMain setProperty:@"textDest"   toValue:textDest  ];
  [wndMain setProperty:@"textRegex"  toValue:textRegex ];
  [wndMain add:layout];
  [textRegex grabFocus];

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
