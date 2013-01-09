//==================================================================================================================================
// GtkTextView.h
/*==================================================================================================================================
Copyright © 2013 Dillon Aumiller <dillonaumiller@gmail.com>

This file is part of the adenosine library.

adenosine is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, version 3 of the License.

adenosine is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with adenosine.  If not, see <http://www.gnu.org/licenses/>.
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
