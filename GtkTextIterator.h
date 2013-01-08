//==================================================================================================================================
// GtkTextIterator.h
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
#import <adenosine/GtkEnums.h>
@class GtkTextTag;

//==================================================================================================================================
@interface GtkTextIterator : OFObject
{
  void *_native;
}

//----------------------------------------------------------------------------------------------------------------------------------
+ textIteratorWithIterator:(GtkTextIterator *)copyFrom;
- initWithIterator:(GtkTextIterator *)copyFrom;
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
- copy;

//----------------------------------------------------------------------------------------------------------------------------------
+ textIteratorWithNative:(void *)native;
- initWithExistingNative:(void *)native;
-(void)destroy;

//----------------------------------------------------------------------------------------------------------------------------------
@property (readonly) void *native;
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
@property (assign) int offset;
@property (assign) int lineNumber;
@property (assign) int lineOffset;
@property (assign) int visibleLineOffset;
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
@property (readonly) BOOL isEditable;
@property (readonly) BOOL isInsertable;
@property (readonly) BOOL isCursorPosition;
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
@property (readonly) BOOL isStart;
@property (readonly) BOOL isEnd;
@property (readonly) BOOL startsWord;
@property (readonly) BOOL endsWord;
@property (readonly) BOOL insideWord;
@property (readonly) BOOL startsLine;
@property (readonly) BOOL endsLine;
@property (readonly) BOOL startsSentence;
@property (readonly) BOOL endsSentence;
@property (readonly) BOOL insideSentence;
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
@property (readonly) int charsInLine;
@property (readonly) uint32_t character;
@property (readonly) GtkTextChildAnchor *anchor;

//----------------------------------------------------------------------------------------------------------------------------------
-(BOOL)beginsTag          :(GtkTextTag *)tag;
-(BOOL)endsTag            :(GtkTextTag *)tag;
-(BOOL)togglesTag         :(GtkTextTag *)tag;
-(BOOL)hasTag             :(GtkTextTag *)tag;
-(BOOL)forwardToTagToggle :(GtkTextTag *)tag;
-(BOOL)backwardToTagToggle:(GtkTextTag *)tag;
-(OFArray *)listTags;
-(OFArray *)listToggledTags:(BOOL)onOrOff;
-(OFArray *)listMarks;
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-(BOOL)forwardChar;
-(BOOL)backwardChar;
-(BOOL)forwardLine;
-(BOOL)backwardLine;
-(BOOL)forwardWordEnd;
-(BOOL)backwardWordStart;
-(BOOL)forwardCursorPosition;
-(BOOL)backwardCursorPosition;
-(BOOL)forwardSentenceEnd;
-(BOOL)backwardSentenceStart;
-(BOOL)forwardVisibleWordEnd;
-(BOOL)backwardVisibleWordStart;
-(BOOL)forwardVisibleCursorPosition;
-(BOOL)backwardVisibleCursorPosition;
-(BOOL)forwardVisibleLine;
-(BOOL)backwardVisibleLine;
-(BOOL)forwardToLineEnd;
-(void)forwardToEnd;
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-(BOOL)forwardChars:(int)chars;
-(BOOL)backwardChar:(int)chars;
-(BOOL)forwardLines:(int)lines;
-(BOOL)backwardLines:(int)lines;
-(BOOL)forwardWordEnds:(int)ends;
-(BOOL)backwardWordStarts:(int)starts;
-(BOOL)forwardCursorPositions:(int)positions;
-(BOOL)backwardCursorPositions:(int)positions;
-(BOOL)forwardSentencEnds:(int)ends;
-(BOOL)backwardSentenceStarts:(int)starts;
-(BOOL)forwardVisibleWordEnds:(int)ends;
-(BOOL)backwardVisibleWordStarts:(int)starts;
-(BOOL)forwardVisibleCursorPositions:(int)positions;
-(BOOL)backwardVisibleCursorPositions:(int)positions;
-(BOOL)forwardVisibleLines:(int)lines;
-(BOOL)backwardVisibleLines:(int)lines;
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-(BOOL)equals:(GtkTextIterator *)equalTo;
-(of_comparison_result_t)compare:(GtkTextIterator *)compareTo;
-(BOOL)isBetween:(GtkTextIterator *)begin and:(GtkTextIterator *)end;

// !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
//  TODO:
// !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
/*
  //------------------------------------------
  Functions waiting on other classes/code
  //------------------------------------------
  @property (readonly) Pixbuf *pixbuf --> gtk_text_iter_get_pixbuf(native *)

  //------------------------------------------
  Functions to Add to GtkTextBuffer
  //------------------------------------------
  findCharForward(GtkTextIterator *start, GtkTextIterator *max, BOOL (^predicateBlock)(uint32_t)) --> gtk_text_iter_forward_find_char
  findCharBackward(GtkTextIterator *start, GtkTextIterator *min, BOOL (^predicateBlock)(uint32_t)) --> gtk_text_iter_backward_find_char
  findForward(...) --> gtk_text_iter_forward_search
  findBackward(...) ---> gtk_text_iter_backward_search
*/


//==================================================================================================================================
@end

//==================================================================================================================================
//----------------------------------------------------------------------------------------------------------------------------------
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
