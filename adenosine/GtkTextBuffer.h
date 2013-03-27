//==================================================================================================================================
// GtkTextBuffer.h
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
@class GtkTextTag;
@class GtkTextTagTable;
@class GtkTextMark;
@class GtkTextIterator;
@class GtkTextChildAnchor;
@class GtkTextSearchResult;
//@class GtkClipboard;

//==================================================================================================================================
@class GtkTextBuffer;
@protocol GtkTextBufferDelegate <OFObject>
@optional
-(void)gtkTextBufferChanged        :(GtkTextBuffer *)buffer;
-(void)gtkTextBufferModifiedChanged:(GtkTextBuffer *)buffer;
-(void)gtkTextBufferUserActionBegin:(GtkTextBuffer *)buffer;
-(void)gtkTextBufferUserActionEnd  :(GtkTextBuffer *)buffer;
-(void)gtkTextBuffer:(GtkTextBuffer *)buffer applyTag:(GtkTextTag *)tag from:(GtkTextIterator *)start to:(GtkTextIterator *)end;
-(void)gtkTextBuffer:(GtkTextBuffer *)buffer deleteRangeFrom:(GtkTextIterator *)start to:(GtkTextIterator *)end;
-(void)gtkTextBuffer:(GtkTextBuffer *)buffer insertChildAnchor:(GtkTextChildAnchor *)anchor at:(GtkTextIterator *)location;
-(void)gtkTextBuffer:(GtkTextBuffer *)buffer insertText:(OFString *)text at:(GtkTextIterator *)location;
-(void)gtkTextBuffer:(GtkTextBuffer *)buffer markDeleted:(GtkTextMark *)mark;
-(void)gtkTextBuffer:(GtkTextBuffer *)buffer markSet:(GtkTextMark *)mark at:(GtkTextIterator *)location;
-(void)gtkTextBuffer:(GtkTextBuffer *)buffer removeTag:(GtkTextTag *)tag from:(GtkTextIterator *)start to:(GtkTextIterator *)end;
//TODO: insertPixbuf (???Pixbuf    *)
//TODO: pasteDone    (GtkClipboard *)
@end

//==================================================================================================================================
@interface GtkTextBuffer : OFObject
{
  void           *_native;
  id              _delegate;
  OFMutableArray *_marks;
  OFMutableArray *_connections;
}

//----------------------------------------------------------------------------------------------------------------------------------
+ textBuffer;
+ textBufferWithTable:(GtkTextTagTable *)table;
- initTextBuffer;
- initWithTable:(GtkTextTagTable *)table;

//----------------------------------------------------------------------------------------------------------------------------------
+ (BOOL) isWrapped:(void *)native;
+ nativeToWrapper:(void *)native;
+ wrapExistingNative:(void *)native;
- initWithExistingNative:(void *)native;
-(void)installNativeLookup;
-(void)destroy;

//----------------------------------------------------------------------------------------------------------------------------------
@property (readonly) void            *native;
@property (readonly) OFArray         *textMarks;
@property (readonly) int              lineCount;
@property (readonly) int              charCount;
@property (readonly) BOOL             hasSelection;
@property (readonly) GtkTextTagTable *tagTable;
@property (readonly) GtkTextMark     *insertMark;
@property (readonly) GtkTextMark     *selectionBoundMark;
@property (assign)   BOOL             modified;
@property (assign)   OFString        *text;
@property (assign)   id               delegate;

//----------------------------------------------------------------------------------------------------------------------------------
-(void)insertTextAtCursor:(OFString *)text;
-(void)insertTextAtCursor:(OFString *)text ofLength:(int)length;
-(void)insertText:(OFString *)text at:(GtkTextIterator *)iterator;
-(void)insertText:(OFString *)text ofLength:(int)length at:(GtkTextIterator *)iterator;
-(void)insertRangeAt:(GtkTextIterator *)iterator rangeBegin:(GtkTextIterator *)begin rangeEnd:(GtkTextIterator *)end;
-(void)insertText:(OFString *)text at:(GtkTextIterator *)iterator withTag:(GtkTextTag *)tag;
-(void)insertText:(OFString *)text at:(GtkTextIterator *)iterator withTags:(OFArray *)tags;
-(void)insertText:(OFString *)text ofLength:(int)length at:(GtkTextIterator *)iterator withTag:(GtkTextTag *)tag;
-(void)insertText:(OFString *)text ofLength:(int)length at:(GtkTextIterator *)iterator withTags:(OFArray *)tags;
-(void)deleteSelection;
-(void)deleteFrom:(GtkTextIterator *)begin to:(GtkTextIterator *)end;
-(void)backspaceAt:(GtkTextIterator *)position;
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-(void)interactiveInsertTextAtCursor:(OFString *)text;
-(void)interactiveInsertTextAtCursor:(OFString *)text ofLength:(int)length;
-(void)interactiveInsertText:(OFString *)text at:(GtkTextIterator *)iterator;
-(void)interactiveInsertText:(OFString *)text ofLength:(int)length at:(GtkTextIterator *)iterator;
-(void)interactiveInsertRangeAt:(GtkTextIterator *)iterator rangeBegin:(GtkTextIterator *)begin rangeEnd:(GtkTextIterator *)end;
-(void)interactiveDeleteSelection;
-(void)interactiveDeleteFrom:(GtkTextIterator *)begin to:(GtkTextIterator *)end;
-(void)interactiveBackspaceAt:(GtkTextIterator *)position;
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
//-(void)insertPixbuf:(???Pixbuf *)pixbuff At:(GtkTextIterator *)iterator; // TODO:
-(void)insertChildAnchor:(GtkTextChildAnchor *)anchor at:(GtkTextIterator *)iterator;
-(void)addTextMark:(GtkTextMark *)mark at:(GtkTextIterator *)iterator;
-(void)removeTextMark:(GtkTextMark *)mark;
-(void)removeTextMarkNamed:(OFString *)name;
-(void)moveTextMark:(GtkTextMark *)mark to:(GtkTextIterator *)iterator;
-(void)moveTextMarkNamed:(OFString *)name to:(GtkTextIterator *)iterator;
-(GtkTextMark *)getTextMarkNamed:(OFString *)name;
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-(void)beginUserAction;
-(void)endUserAction;
-(void)placeCursorAt:(GtkTextIterator *)iterator;
-(void)selectRangeFrom:(GtkTextIterator *)begin to:(GtkTextIterator *)end;
-(void)applyTag:(GtkTextTag *)tag from:(GtkTextIterator *)begin to:(GtkTextIterator *)end;
-(void)removeTag:(GtkTextTag *)tag from:(GtkTextIterator *)begin to:(GtkTextIterator *)end;
-(void)applyTagNamed:(OFString *)name from:(GtkTextIterator *)begin to:(GtkTextIterator *)end;
-(void)removeTagNamed:(OFString *)name from:(GtkTextIterator *)begin to:(GtkTextIterator *)end;
-(void)removeAllTagsFrom:(GtkTextIterator *)begin to:(GtkTextIterator *)end;
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-(GtkTextIterator *)createIteratorForOffset:(int)offset;
-(GtkTextIterator *)createIteratorForLine:(int)lineNumber;
-(GtkTextIterator *)createIteratorForLine:(int)lineNumber andOffset:(int)offset;
-(GtkTextIterator *)createIteratorForMark:(GtkTextMark *)mark;
-(GtkTextIterator *)createIteratorForChildAnchor:(GtkTextChildAnchor *)anchor;
-(GtkTextIterator *)createIteratorForStart;
-(GtkTextIterator *)createIteratorForEnd;
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-(BOOL)findCharForwardFrom:(GtkTextIterator *)start to:(GtkTextIterator *)limit withBlock:(BOOL(^)(uint32_t))block;
-(BOOL)findCharBackwardFrom:(GtkTextIterator *)start to:(GtkTextIterator *)limit withBlock:(BOOL (^)(uint32_t))block;
-(GtkTextSearchResult *)find:(OFString *)string forwardFrom:(GtkTextIterator *)start to:(GtkTextIterator *)end flags:(GtkTextSearchFlags)flags;
-(GtkTextSearchResult *)find:(OFString *)string backwardFrom:(GtkTextIterator *)start to:(GtkTextIterator *)end flags:(GtkTextSearchFlags)flags;
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-(void)setText:(OFString *)text ofLength:(int)length;
-(OFString *)getTextFrom:(GtkTextIterator *)begin to:(GtkTextIterator *)end;
-(OFString *)getTextFrom:(GtkTextIterator *)begin to:(GtkTextIterator *)end withInvisible:(BOOL)invisible;
-(OFString *)getSliceFrom:(GtkTextIterator *)begin to:(GtkTextIterator *)end;
-(OFString *)getSliceFrom:(GtkTextIterator *)begin to:(GtkTextIterator *)end withInvisible:(BOOL)invisible;
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
/* !!!!! TODO: !!!!!
-(void)pasteClipboard:(GtkClipboard *)clipboard;
-(void)pasteClipboard:(GtkClipboard *)clipboard at:(GtkTextIterator *)iterator;
-(void)copySelectionToClipboard:(GtkClipboard *)clipboard;
-(void)cutSelectionToClipboard:(GtkClipboard *)clipboard; */
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
/* !!!!! TODO: !!!!!
  all of the serializing/deserialzing stuff... (implement functs with blocks?)
  all of the TargetList stuff
*/

//----------------------------------------------------------------------------------------------------------------------------------
-(void)onChanged;
-(void)onModifiedChanged;
-(void)onUserActionBegin;
-(void)onUserActionEnd;
-(void)onApplyTag:(GtkTextTag *)tag from:(GtkTextIterator *)start to:(GtkTextIterator *)end;
-(void)onDeleteRangeFrom:(GtkTextIterator *)start to:(GtkTextIterator *)end;
-(void)onInsertChildAnchor:(GtkTextChildAnchor *)anchor at:(GtkTextIterator *)location;
-(void)onInsertText:(OFString *)text at:(GtkTextIterator *)location;
-(void)onMarkDeleted:(GtkTextMark *)mark;
-(void)onMarkSet:(GtkTextMark *)mark at:(GtkTextIterator *)location;
-(void)onRemoveTag:(GtkTextTag *)tag from:(GtkTextIterator *)start to:(GtkTextIterator *)end;

//==================================================================================================================================
@end

//==================================================================================================================================
//----------------------------------------------------------------------------------------------------------------------------------
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
