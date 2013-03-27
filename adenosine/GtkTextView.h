//==================================================================================================================================
// GtkTextView.h
/*==================================================================================================================================
Copyright © 2013, Dillon Aumiller <dillonaumiller@gmail.com>
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met: 

1. Redistributions of source code must retain the above copyright notice, this
   list of conditions and the following disclaimer. 
2. Redistributions in binary form must reproduce the above copyright notice,
   this list of conditions and the following disclaimer in the documentation
   and/or other materials provided with the distribution. 

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
==================================================================================================================================*/
#import <ObjFW/ObjFW.h>
#import <adenosine/GtkWidget.h>
#import <atropine/OMCoordinate.h>
#import <atropine/OMRectangle.h>
@class GtkMenu;
@class GtkTextBuffer;
@class GtkTextIterator;
@class GtkTextMark;
@class GtkTextChildAnchor;

//==================================================================================================================================
@class GtkTextView;
@protocol GtkTextViewDelegate <OFObject>
@optional
-(void)gtkTextView:(GtkTextView *)textView populatePopup:(GtkMenu *)menu;
@end

//==================================================================================================================================
@interface GtkTextView : GtkContainer
{
  GtkTextBuffer *_buffer;
}

//----------------------------------------------------------------------------------------------------------------------------------
+ textView;
+ textViewWithBuffer:(GtkTextBuffer *)buffer;
- initTextView;
- initWithBuffer:(GtkTextBuffer *)buffer;

//----------------------------------------------------------------------------------------------------------------------------------
@property (retain) GtkTextBuffer *buffer;
@property (assign) GtkTextWrap    wrapMode;
@property (assign) BOOL           editable;
@property (assign) BOOL           cursorVisible;
@property (assign) BOOL           overwrite;
@property (assign) int            pixelsAboveLines;
@property (assign) int            pixelsBelowLines;
@property (assign) int            pixelsInsideWrap;
@property (assign) GtkTextAlign   alignment;
@property (assign) int            marginLeft;
@property (assign) int            marginRight;
@property (assign) int            indent;
@property (assign) BOOL           acceptsTab;

//----------------------------------------------------------------------------------------------------------------------------------
-(OMDimension)bufferToWindowDimension:(OMDimension)dimension forWindow:(GtkTextViewWindow)window;
-(OMCoordinate)bufferToWindowCoordinate:(OMCoordinate)coordinate forWindow:(GtkTextViewWindow)window;
-(OMCoordinate)windowToBufferCoordinate:(OMCoordinate)coordinate forWindow:(GtkTextViewWindow)window;
-(OMDimension)visibleDimension;
-(OMDimension)iteratorDimension:(GtkTextIterator *)iterator;
-(OMDimension)weakCursorDimensionAt:(GtkTextIterator *)iterator;
-(OMDimension)strongCursorDimensionAt:(GtkTextIterator *)iterator;
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-(GtkTextIterator *)iteratorForLineAtY:(int)y;
-(GtkTextIterator *)iteratorForLocationX:(int)x Y:(int)y;
-(GtkTextIterator *)iteratorForLocationCoordinate:(OMCoordinate)coordinate;
-(GtkTextIterator *)iteratorForPositionX:(int)x Y:(int)y;
-(GtkTextIterator *)iteratorForPositionCoordinate:(OMCoordinate)coordinate;
-(OMDimension)verticalRangeOfLineAt:(GtkTextIterator *)iterator;
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-(void)scrollToMark:(GtkTextMark *)mark withinMargin:(float)margin;
-(void)scrollToMark:(GtkTextMark *)mark alignX:(float)x alignY:(float)y;
-(void)scrollMarkOnScreen:(GtkTextMark *)mark;
-(void)moveMarkOnScreen:(GtkTextMark *)mark;
-(void)scrollToIterator:(GtkTextIterator *)iterator withinMargin:(float)margin;
-(void)scrollToIterator:(GtkTextIterator *)iterator alignX:(float)x alignY:(float)y;
-(void)moveCursorOnScreen;
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-(BOOL)forwardDisplayLine      :(GtkTextIterator *)iterator;
-(BOOL)backwardDisplayLine     :(GtkTextIterator *)iterator;
-(BOOL)forwardDisplayLineEnd   :(GtkTextIterator *)iterator;
-(BOOL)backwardDisplayLineStart:(GtkTextIterator *)iterator;
-(BOOL)startsDisplayLine       :(GtkTextIterator *)iterator;
-(BOOL)moveVisually            :(GtkTextIterator *)iterator offset:(int)offset;
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-(void)addChild:(GtkWidget *)child atAnchor:(GtkTextChildAnchor *)anchor;
-(void)addChild:(GtkWidget *)child toWindow:(GtkTextViewWindow)window atX:(int)x andY:(int)y;
-(void)addChild:(GtkWidget *)child toWindow:(GtkTextViewWindow)window at:(OMCoordinate)coordinate;
-(void)moveChild:(GtkWidget *)child toX:(int)x andY:(int)y;
-(void)moveChild:(GtkWidget *)child to:(OMCoordinate)coordinate;
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-(void)setBorder:(GtkPosition)position toSize:(int)size;
-(int)getBorderSize:(GtkPosition)position;

//----------------------------------------------------------------------------------------------------------------------------------
-(void)onPopulatePopup:(GtkMenu *)menu;

//==================================================================================================================================
@end

//==================================================================================================================================
//----------------------------------------------------------------------------------------------------------------------------------
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
