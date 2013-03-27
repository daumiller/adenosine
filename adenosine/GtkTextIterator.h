//==================================================================================================================================
// GtkTextIterator.h
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

/*
  TODO:
  @property (readonly) Pixbuf *pixbuf --> gtk_text_iter_get_pixbuf(native *)
*/


//==================================================================================================================================
@end

//==================================================================================================================================
//----------------------------------------------------------------------------------------------------------------------------------
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
