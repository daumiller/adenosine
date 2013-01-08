//==================================================================================================================================
// GtkTextBuffer.h
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
@class GtkTextTag;
@class GtkTextTagTable;
@class GtkTextMark;
@class GtkTextIterator;
@class GtkTextChildAnchor;
//@class GtkClipboard;

//==================================================================================================================================
@interface GtkTextBuffer : OFObject
{
  void           *_native;
  OFMutableArray *_marks;
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

//==================================================================================================================================
@end

//==================================================================================================================================
//----------------------------------------------------------------------------------------------------------------------------------
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
