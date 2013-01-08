//==================================================================================================================================
// GtkTextBuffer.m
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
#import "GtkNative.h"
#import <adenosine/adenosine.h>

//==================================================================================================================================
#define NATIVE_TEXTBUFFER ((struct _GtkTextBuffer *)_native)
#define ADENOSINE_NATIVE_LOOKUP_STRING "_adenosine_wrapper_textbuffer"

//==================================================================================================================================
// Signal/Event -> Object Proxies
//==================================================================================================================================
static void ConnectionProxy_Changed(struct _GtkTextBuffer *buffer, gpointer data)
{
  GtkTextBuffer *obj = (GtkTextBuffer *)[GtkTextBuffer nativeToWrapper:(void *)buffer];
  [obj onChanged];
}
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
static void ConnectionProxy_ModifiedChanged(struct _GtkTextBuffer *buffer, gpointer data)
{
  GtkTextBuffer *obj = (GtkTextBuffer *)[GtkTextBuffer nativeToWrapper:(void *)buffer];
  [obj onModifiedChanged];
}
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
static void ConnectionProxy_UserActionBegin(struct _GtkTextBuffer *buffer, gpointer data)
{
  GtkTextBuffer *obj = (GtkTextBuffer *)[GtkTextBuffer nativeToWrapper:(void *)buffer];
  [obj onUserActionBegin];
}
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
static void ConnectionProxy_UserActionEnd(struct _GtkTextBuffer *buffer, gpointer data)
{
  GtkTextBuffer *obj = (GtkTextBuffer *)[GtkTextBuffer nativeToWrapper:(void *)buffer];
  [obj onUserActionEnd];
}
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
static void ConnectionProxy_ApplyTag(struct _GtkTextBuffer *buffer, struct _GtkTextTag *tag, struct _GtkTextIter *start, struct _GtkTextIter *end, gpointer data)
{
  GtkTextBuffer *obj = (GtkTextBuffer *)[GtkTextBuffer nativeToWrapper:(void *)buffer];
  OFAutoreleasePool *pool = [[OFAutoreleasePool alloc] init];
  GtkTextTag *wrapTag = [GtkTextTag nativeToWrapper:tag]; if(!wrapTag) wrapTag = [GtkTextTag wrapExistingNative:tag];
  GtkTextIterator *wrapStart = [GtkTextIterator textIteratorWithNative:start];
  GtkTextIterator *wrapEnd   = [GtkTextIterator textIteratorWithNative:end  ];
  [obj onApplyTag:wrapTag from:wrapStart to:wrapEnd];
  [pool drain];
}
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
static void ConnectionProxy_DeleteRange(struct _GtkTextBuffer *buffer, struct _GtkTextIter *start, struct _GtkTextIter *end, gpointer data)
{
  GtkTextBuffer *obj = (GtkTextBuffer *)[GtkTextBuffer nativeToWrapper:(void *)buffer];
  OFAutoreleasePool *pool = [[OFAutoreleasePool alloc] init];
  GtkTextIterator *wrapStart = [GtkTextIterator textIteratorWithNative:start];
  GtkTextIterator *wrapEnd   = [GtkTextIterator textIteratorWithNative:end  ];
  [obj onDeleteRangeFrom:wrapStart to:wrapEnd];
  [pool drain];
}
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
static void ConnectionProxy_InsertChildAnchor(struct _GtkTextBuffer *buffer, struct _GtkTextIter *location, struct _GtkTextChildAnchor *anchor, gpointer data)
{
  GtkTextBuffer *obj = (GtkTextBuffer *)[GtkTextBuffer nativeToWrapper:(void *)buffer];
  OFAutoreleasePool *pool = [[OFAutoreleasePool alloc] init];
  GtkTextIterator *wrapLocation = [GtkTextIterator textIteratorWithNative:location];
  GtkTextChildAnchor *wrapAnchor = [GtkTextChildAnchor nativeToWrapper:anchor]; if(!wrapAnchor) wrapAnchor = [GtkTextChildAnchor wrapExistingNative:anchor];
  [obj onInsertChildAnchor:wrapAnchor at:wrapLocation];
  [pool drain];
}
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
static void ConnectionProxy_InsertText(struct _GtkTextBuffer *buffer, struct _GtkTextIter *location, gchar *text, gint len, gpointer data)
{
  GtkTextBuffer *obj = (GtkTextBuffer *)[GtkTextBuffer nativeToWrapper:(void *)buffer];
  OFAutoreleasePool *pool = [[OFAutoreleasePool alloc] init];
  GtkTextIterator *wrapLocation = [GtkTextIterator textIteratorWithNative:location];
  //hope it's safe to ignore 'len', since it specifies Bytes instead of Chars (which we could handle)...
  OFString *ofText = [OFString stringWithUTF8String:text];
  [obj onInsertText:ofText at:wrapLocation];
  [pool drain];
}
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
static void ConnectionProxy_MarkDeleted(struct _GtkTextBuffer *buffer, struct _GtkTextMark *mark, gpointer data)
{
  GtkTextBuffer *obj = (GtkTextBuffer *)[GtkTextBuffer nativeToWrapper:(void *)buffer];
  OFAutoreleasePool *pool = [[OFAutoreleasePool alloc] init];
  GtkTextMark *wrapMark = [GtkTextMark nativeToWrapper:mark]; if(!wrapMark) wrapMark = [GtkTextMark wrapExistingNative:mark];
  [obj onMarkDeleted:wrapMark];
  [pool drain];
}
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
static void ConnectionProxy_MarkSet(struct _GtkTextBuffer *buffer, struct _GtkTextIter *location, struct _GtkTextMark *mark, gpointer data)
{
  GtkTextBuffer *obj = (GtkTextBuffer *)[GtkTextBuffer nativeToWrapper:(void *)buffer];
  OFAutoreleasePool *pool = [[OFAutoreleasePool alloc] init];
  GtkTextIterator *wrapLocation = [GtkTextIterator textIteratorWithNative:location];
  GtkTextMark *wrapMark = [GtkTextMark nativeToWrapper:mark]; if(!wrapMark) wrapMark = [GtkTextMark wrapExistingNative:mark];
  [obj onMarkSet:wrapMark at:wrapLocation];
  [pool drain];
}
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
static void ConnectionProxy_RemoveTag(struct _GtkTextBuffer *buffer, struct _GtkTextTag *tag, struct _GtkTextIter *start, struct _GtkTextIter *end, gpointer data)
{
  GtkTextBuffer *obj = (GtkTextBuffer *)[GtkTextBuffer nativeToWrapper:(void *)buffer];
  OFAutoreleasePool *pool = [[OFAutoreleasePool alloc] init];
  GtkTextIterator *wrapStart = [GtkTextIterator textIteratorWithNative:start];
  GtkTextIterator *wrapEnd   = [GtkTextIterator textIteratorWithNative:end  ];
  GtkTextTag *wrapTag = [GtkTextTag nativeToWrapper:tag]; if(!wrapTag) wrapTag = [GtkTextTag wrapExistingNative:tag];
  [obj onRemoveTag:wrapTag from:wrapStart to:wrapEnd];
  [pool drain];
}

//==================================================================================================================================
@implementation GtkTextBuffer

//==================================================================================================================================
// Wrapping
//==================================================================================================================================
+ (BOOL) isWrapped:(void *)native
{
  return ([GtkTextBuffer nativeToWrapper:native] != nil);
}
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
+ nativeToWrapper:(void *)native
{
  if(!G_IS_OBJECT(native)) return nil;
  return (GtkTextBuffer *)g_object_get_data((GObject *)native, ADENOSINE_NATIVE_LOOKUP_STRING);
}
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
+ wrapExistingNative:(void *)native
{
  return [[[self alloc] initWithExistingNative:native] autorelease];
}
//----------------------------------------------------------------------------------------------------------------------------------
- initWithExistingNative:(void *)native
{
  self = [super init];
  if(self)
  {
    _native = native;
    g_object_ref(_native);
    [self installNativeLookup];
    _marks = [[OFMutableArray alloc] init];
    //unfortunately there's no good way to wrap all of our existing marks here
    //but there shouldn't really be a way to create native marks in a buffer without a proper wrapper
  }
  return self;
}
//----------------------------------------------------------------------------------------------------------------------------------
-(void)installNativeLookup { g_object_set_data((gpointer)_native, ADENOSINE_NATIVE_LOOKUP_STRING, (gpointer)self); }
-(void)destroy             { g_object_unref(_native);                                                              }

//==================================================================================================================================
// Constructors/Destructor
//==================================================================================================================================
+ textBuffer                                   { return [[[self alloc] initTextBuffer     ] autorelease]; }
+ textBufferWithTable:(GtkTextTagTable *)table { return [[[self alloc] initWithTable:table] autorelease]; }
//----------------------------------------------------------------------------------------------------------------------------------
- initTextBuffer
{
  self = [super init];
  if(self)
  {
    _native = gtk_text_buffer_new(NULL);
    [self installNativeLookup];
    _marks = [[OFMutableArray alloc] init];
  }
  return self;
}
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
- initWithTable:(GtkTextTagTable *)table
{
  self = [super init];
  if(self)
  {
    _native = gtk_text_buffer_new(table ? table.native : NULL);
    [self installNativeLookup];
    _marks = [[OFMutableArray alloc] init];
  }
  return self;
}
//----------------------------------------------------------------------------------------------------------------------------------
-(void)dealloc
{
  self.delegate = nil;
  [_connections release];
  [_marks release];
  [self destroy];
  [super dealloc]; 
}

//==================================================================================================================================
// Properites
//==================================================================================================================================
-(void *)native       { return _native;           }
-(OFArray *)textMarks { return (OFArray *)_marks; }
//----------------------------------------------------------------------------------------------------------------------------------
-(int)lineCount       { return gtk_text_buffer_get_line_count(NATIVE_TEXTBUFFER);    }
-(int)charCount       { return gtk_text_buffer_get_char_count(NATIVE_TEXTBUFFER);    }
-(BOOL)hasSelection   { return gtk_text_buffer_get_has_selection(NATIVE_TEXTBUFFER); }
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-(GtkTextTagTable *)tagTable
{
  void *nativeTable = gtk_text_buffer_get_tag_table(NATIVE_TEXTBUFFER);
  if(!nativeTable) return nil;
  GtkTextTagTable *wrap = [GtkTextTagTable nativeToWrapper:nativeTable];
  if(!wrap) wrap = [GtkTextTagTable wrapExistingNative:nativeTable];
  return wrap;
}
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-(GtkTextMark *)insertMark
{
  void *nativeMark = gtk_text_buffer_get_insert(NATIVE_TEXTBUFFER);
  if(!nativeMark) return nil;
  GtkTextMark *wrap = [GtkTextMark nativeToWrapper:nativeMark];
  if(!wrap) wrap = [GtkTextTagTable wrapExistingNative:nativeMark];
  return wrap;
}
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-(GtkTextMark *)selectionBoundMark
{
  void *nativeMark = gtk_text_buffer_get_selection_bound(NATIVE_TEXTBUFFER);
  if(!nativeMark) return nil;
  GtkTextMark *wrap = [GtkTextMark nativeToWrapper:nativeMark];
  if(!wrap) wrap = [GtkTextTagTable wrapExistingNative:nativeMark];
  return wrap;
}
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-(BOOL)modified                   { return gtk_text_buffer_get_modified(NATIVE_TEXTBUFFER);    }
-(void)setModified:(BOOL)modified { gtk_text_buffer_set_modified(NATIVE_TEXTBUFFER, modified); }
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-(OFString *)text
{
  OFAutoreleasePool *pool = [[OFAutoreleasePool alloc] init];
  OFString *allText = [self getTextFrom:[self createIteratorForStart] to:[self createIteratorForEnd]];
  OFString *retStr = [[OFString alloc] initWithString:allText];
  [pool drain];
  return [retStr autorelease];
}
-(void)setText:(OFString *)text
{
  OFAutoreleasePool *pool = [[OFAutoreleasePool alloc] init];
  gtk_text_buffer_set_text(NATIVE_TEXTBUFFER, [text UTF8String], -1);
  [pool drain];
}
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-(id)delegate { return _delegate; }
-(void)setDelegate:(id)delegate
{
  for(OFNumber *idNumber in _connections)
    g_signal_handler_disconnect(_native, [idNumber unsignedLongValue]);
  [_connections release];
  _connections = [[OFMutableArray alloc] init];

  if(_delegate) [_delegate release];
  _delegate = [delegate retain];
  if(_delegate)
  {
    if([_delegate respondsToSelector:@selector(gtkTextBufferChanged:)])
      [_connections addObject:[OFNumber numberWithUnsignedLong:
        g_signal_connect(_native, "changed", G_CALLBACK(ConnectionProxy_Changed),NULL)]];

    if([_delegate respondsToSelector:@selector(gtkTextBufferModifiedChanged:)])
      [_connections addObject:[OFNumber numberWithUnsignedLong:
        g_signal_connect(_native, "modified-changed", G_CALLBACK(ConnectionProxy_ModifiedChanged),NULL)]];

    if([_delegate respondsToSelector:@selector(gtkTextBufferUserActionBegin:)])
      [_connections addObject:[OFNumber numberWithUnsignedLong:
        g_signal_connect(_native, "begin-user-action", G_CALLBACK(ConnectionProxy_UserActionBegin),NULL)]];

    if([_delegate respondsToSelector:@selector(gtkTextBufferUserActionEnd:)])
      [_connections addObject:[OFNumber numberWithUnsignedLong:
        g_signal_connect(_native, "end-user-action", G_CALLBACK(ConnectionProxy_UserActionEnd),NULL)]];

    if([_delegate respondsToSelector:@selector(gtkTextBuffer:applyTag:from:to:)])
      [_connections addObject:[OFNumber numberWithUnsignedLong:
        g_signal_connect(_native, "apply-tag", G_CALLBACK(ConnectionProxy_ApplyTag),NULL)]];

    if([_delegate respondsToSelector:@selector(gtkTextBuffer:deleteRangeFrom:to:)])
      [_connections addObject:[OFNumber numberWithUnsignedLong:
        g_signal_connect(_native, "delete-range", G_CALLBACK(ConnectionProxy_DeleteRange),NULL)]];

    if([_delegate respondsToSelector:@selector(gtkTextBuffer:insertChildAnchor:at:)])
      [_connections addObject:[OFNumber numberWithUnsignedLong:
        g_signal_connect(_native, "insert-child-anchor", G_CALLBACK(ConnectionProxy_InsertChildAnchor),NULL)]];

    if([_delegate respondsToSelector:@selector(gtkTextBuffer:insertText:at:)])
      [_connections addObject:[OFNumber numberWithUnsignedLong:
        g_signal_connect(_native, "insert-text", G_CALLBACK(ConnectionProxy_InsertText),NULL)]];

    if([_delegate respondsToSelector:@selector(gtkTextBuffer:markDeleted:)])
      [_connections addObject:[OFNumber numberWithUnsignedLong:
        g_signal_connect(_native, "mark-deleted", G_CALLBACK(ConnectionProxy_MarkDeleted),NULL)]];

    if([_delegate respondsToSelector:@selector(gtkTextBuffer:markSet:at:)])
      [_connections addObject:[OFNumber numberWithUnsignedLong:
        g_signal_connect(_native, "mark-set", G_CALLBACK(ConnectionProxy_MarkSet),NULL)]];

    if([_delegate respondsToSelector:@selector(gtkTextBuffer:removeTag:from:to:)])
      [_connections addObject:[OFNumber numberWithUnsignedLong:
        g_signal_connect(_native, "remove-tag", G_CALLBACK(ConnectionProxy_RemoveTag),NULL)]];
  }
}

//==================================================================================================================================
// Utilities
//==================================================================================================================================
-(void)insertTextAtCursor:(OFString *)text
{
  OFAutoreleasePool *pool = [[OFAutoreleasePool alloc] init];
  gtk_text_buffer_insert_at_cursor(NATIVE_TEXTBUFFER, [text UTF8String], -1);
  [pool drain];
}

-(void)insertTextAtCursor:(OFString *)text ofLength:(int)length
{
  OFAutoreleasePool *pool = [[OFAutoreleasePool alloc] init];
  gtk_text_buffer_insert_at_cursor(NATIVE_TEXTBUFFER, [text UTF8String], length);
  [pool drain];
}

-(void)insertText:(OFString *)text at:(GtkTextIterator *)iterator
{
  OFAutoreleasePool *pool = [[OFAutoreleasePool alloc] init];
  gtk_text_buffer_insert(NATIVE_TEXTBUFFER, iterator.native, [text UTF8String], -1);
  [pool drain];
}

-(void)insertText:(OFString *)text ofLength:(int)length at:(GtkTextIterator *)iterator
{
  OFAutoreleasePool *pool = [[OFAutoreleasePool alloc] init];
  gtk_text_buffer_insert(NATIVE_TEXTBUFFER, iterator.native, [text UTF8String], length);
  [pool drain];
}

-(void)insertRangeAt:(GtkTextIterator *)iterator rangeBegin:(GtkTextIterator *)begin rangeEnd:(GtkTextIterator *)end
{
  gtk_text_buffer_insert_range(NATIVE_TEXTBUFFER, iterator.native, begin.native, end.native);
}

-(void)insertText:(OFString *)text at:(GtkTextIterator *)iterator withTag:(GtkTextTag *)tag
{
  OFAutoreleasePool *pool = [[OFAutoreleasePool alloc] init];
  gtk_text_buffer_insert_with_tags(NATIVE_TEXTBUFFER, iterator.native, [text UTF8String], -1, tag.native, NULL);
  [pool drain];
}

-(void)insertText:(OFString *)text at:(GtkTextIterator *)iterator withTags:(OFArray *)tags
{
  OFAutoreleasePool *pool = [[OFAutoreleasePool alloc] init];
  int offset = iterator.offset;
  gtk_text_buffer_insert(NATIVE_TEXTBUFFER, iterator.native, [text UTF8String], -1);
  GtkTextIterator *begin = [self createIteratorForOffset:offset];
  GtkTextIterator *end   = [self createIteratorForOffset:offset]; [end forwardChars:text.length];
  for(GtkTextTag *tag in tags)
    [self applyTag:tag from:begin to:end];
  [pool drain];
}

-(void)insertText:(OFString *)text ofLength:(int)length at:(GtkTextIterator *)iterator withTag:(GtkTextTag *)tag
{
  OFAutoreleasePool *pool = [[OFAutoreleasePool alloc] init];
  gtk_text_buffer_insert_with_tags(NATIVE_TEXTBUFFER, iterator.native, [text UTF8String], length, tag.native, NULL);
  [pool drain];
}

-(void)insertText:(OFString *)text ofLength:(int)length at:(GtkTextIterator *)iterator withTags:(OFArray *)tags
{
  OFAutoreleasePool *pool = [[OFAutoreleasePool alloc] init];
  int offset = iterator.offset;
  gtk_text_buffer_insert(NATIVE_TEXTBUFFER, iterator.native, [text UTF8String], length);
  GtkTextIterator *begin = [self createIteratorForOffset:offset];
  GtkTextIterator *end   = [self createIteratorForOffset:offset]; [end forwardChars:length];
  for(GtkTextTag *tag in tags)
    [self applyTag:tag from:begin to:end];
  [pool drain];
}

-(void)deleteSelection
{
  gtk_text_buffer_delete_selection(NATIVE_TEXTBUFFER, NO, YES);
}

-(void)deleteFrom:(GtkTextIterator *)begin to:(GtkTextIterator *)end
{
  gtk_text_buffer_delete(NATIVE_TEXTBUFFER, begin.native, end.native);
}

-(void)backspaceAt:(GtkTextIterator *)position
{
  gtk_text_buffer_backspace(NATIVE_TEXTBUFFER, position.native, NO, YES);
}

//----------------------------------------------------------------------------------------------------------------------------------
-(void)interactiveInsertTextAtCursor:(OFString *)text
{
  OFAutoreleasePool *pool = [[OFAutoreleasePool alloc] init];
  gtk_text_buffer_insert_interactive_at_cursor(NATIVE_TEXTBUFFER, [text UTF8String], -1, YES);
  [pool drain];
}

-(void)interactiveInsertTextAtCursor:(OFString *)text ofLength:(int)length
{
  OFAutoreleasePool *pool = [[OFAutoreleasePool alloc] init];
  gtk_text_buffer_insert_interactive_at_cursor(NATIVE_TEXTBUFFER, [text UTF8String], length, YES);
  [pool drain];
}

-(void)interactiveInsertText:(OFString *)text at:(GtkTextIterator *)iterator
{
  OFAutoreleasePool *pool = [[OFAutoreleasePool alloc] init];
  gtk_text_buffer_insert_interactive(NATIVE_TEXTBUFFER, iterator.native, [text UTF8String], -1, YES);
  [pool drain];
}

-(void)interactiveInsertText:(OFString *)text ofLength:(int)length at:(GtkTextIterator *)iterator
{
  OFAutoreleasePool *pool = [[OFAutoreleasePool alloc] init];
  gtk_text_buffer_insert_interactive(NATIVE_TEXTBUFFER, iterator.native, [text UTF8String], length, YES);
  [pool drain];
}

-(void)interactiveInsertRangeAt:(GtkTextIterator *)iterator rangeBegin:(GtkTextIterator *)begin rangeEnd:(GtkTextIterator *)end
{
  gtk_text_buffer_insert_range_interactive(NATIVE_TEXTBUFFER, iterator.native, begin.native, end.native, YES);
}

-(void)interactiveDeleteSelection
{
  gtk_text_buffer_delete_selection(NATIVE_TEXTBUFFER, YES, YES);
}

-(void)interactiveDeleteFrom:(GtkTextIterator *)begin to:(GtkTextIterator *)end
{
  gtk_text_buffer_delete_interactive(NATIVE_TEXTBUFFER, begin.native, end.native, YES);
}

-(void)interactiveBackspaceAt:(GtkTextIterator *)position
{
  gtk_text_buffer_backspace(NATIVE_TEXTBUFFER, position.native, YES, YES);
}

//----------------------------------------------------------------------------------------------------------------------------------
-(void)insertChildAnchor:(GtkTextChildAnchor *)anchor at:(GtkTextIterator *)iterator
{
  gtk_text_buffer_insert_child_anchor(NATIVE_TEXTBUFFER, iterator.native, anchor.native);
}

-(void)addTextMark:(GtkTextMark *)mark at:(GtkTextIterator *)iterator
{
  gtk_text_buffer_add_mark(NATIVE_TEXTBUFFER, mark.native, iterator.native);
  [_marks addObject:mark];
}

-(void)removeTextMark:(GtkTextMark *)mark
{
  gtk_text_buffer_delete_mark(NATIVE_TEXTBUFFER, mark.native);
  [_marks removeObjectIdenticalTo:mark];
}

-(void)removeTextMarkNamed:(OFString *)name
{
  GtkTextMark *mark = [self getTextMarkNamed:name];
  if(!mark) return;
  gtk_text_buffer_delete_mark(NATIVE_TEXTBUFFER, mark.native);
  [_marks removeObjectIdenticalTo:mark];
}

-(void)moveTextMark:(GtkTextMark *)mark to:(GtkTextIterator *)iterator
{
  gtk_text_buffer_move_mark(NATIVE_TEXTBUFFER, mark.native, iterator.native);
}

-(void)moveTextMarkNamed:(OFString *)name to:(GtkTextIterator *)iterator
{
  OFAutoreleasePool *pool = [[OFAutoreleasePool alloc] init];
  gtk_text_buffer_move_mark_by_name(NATIVE_TEXTBUFFER, [name UTF8String], iterator.native);
  [pool drain];
}

-(GtkTextMark *)getTextMarkNamed:(OFString *)name
{
  OFAutoreleasePool *pool = [[OFAutoreleasePool alloc] init];
  void *nativeMark = gtk_text_buffer_get_mark(NATIVE_TEXTBUFFER, [name UTF8String]);
  [pool drain];
  if(!nativeMark) return nil;
  GtkTextMark *wrap = [GtkTextMark nativeToWrapper:nativeMark];
  if(!wrap) wrap = [GtkTextMark wrapExistingNative:nativeMark];
  return wrap;
}

//----------------------------------------------------------------------------------------------------------------------------------
-(void)beginUserAction { gtk_text_buffer_begin_user_action(NATIVE_TEXTBUFFER); }
-(void)endUserAction   { gtk_text_buffer_end_user_action  (NATIVE_TEXTBUFFER); }

-(void)placeCursorAt:(GtkTextIterator *)iterator
{
  gtk_text_buffer_place_cursor(NATIVE_TEXTBUFFER, iterator.native);
}

-(void)selectRangeFrom:(GtkTextIterator *)begin to:(GtkTextIterator *)end
{
  gtk_text_buffer_select_range(NATIVE_TEXTBUFFER, begin.native, end.native);
}

-(void)applyTag:(GtkTextTag *)tag from:(GtkTextIterator *)begin to:(GtkTextIterator *)end
{
  gtk_text_buffer_apply_tag(NATIVE_TEXTBUFFER, tag.native, begin.native, end.native);
}

-(void)removeTag:(GtkTextTag *)tag from:(GtkTextIterator *)begin to:(GtkTextIterator *)end
{
  gtk_text_buffer_remove_tag(NATIVE_TEXTBUFFER, tag.native, begin.native, end.native);
}

-(void)applyTagNamed:(OFString *)name from:(GtkTextIterator *)begin to:(GtkTextIterator *)end
{
  OFAutoreleasePool *pool = [[OFAutoreleasePool alloc] init];
  gtk_text_buffer_apply_tag_by_name(NATIVE_TEXTBUFFER, [name UTF8String], begin.native, end.native);
  [pool drain];
}

-(void)removeTagNamed:(OFString *)name from:(GtkTextIterator *)begin to:(GtkTextIterator *)end
{
  OFAutoreleasePool *pool = [[OFAutoreleasePool alloc] init];
  gtk_text_buffer_remove_tag_by_name(NATIVE_TEXTBUFFER, [name UTF8String], begin.native, end.native);
  [pool drain];
}

-(void)removeAllTagsFrom:(GtkTextIterator *)begin to:(GtkTextIterator *)end
{
  gtk_text_buffer_remove_all_tags(NATIVE_TEXTBUFFER, begin.native, end.native);
}

//----------------------------------------------------------------------------------------------------------------------------------
-(GtkTextIterator *)createIteratorForOffset:(int)offset
{
  struct _GtkTextIter nativeIter;
  gtk_text_buffer_get_iter_at_offset(NATIVE_TEXTBUFFER, &nativeIter, offset);
  return [GtkTextIterator textIteratorWithNative:&nativeIter];
}

-(GtkTextIterator *)createIteratorForLine:(int)lineNumber
{
  struct _GtkTextIter nativeIter;  
  gtk_text_buffer_get_iter_at_line(NATIVE_TEXTBUFFER, &nativeIter, lineNumber);
  return [GtkTextIterator textIteratorWithNative:&nativeIter];
}

-(GtkTextIterator *)createIteratorForLine:(int)lineNumber andOffset:(int)offset
{
  struct _GtkTextIter nativeIter;
  gtk_text_buffer_get_iter_at_line_offset(NATIVE_TEXTBUFFER, &nativeIter, lineNumber, offset);
  return [GtkTextIterator textIteratorWithNative:&nativeIter];
}

-(GtkTextIterator *)createIteratorForMark:(GtkTextMark *)mark
{
  struct _GtkTextIter nativeIter;
  gtk_text_buffer_get_iter_at_mark(NATIVE_TEXTBUFFER, &nativeIter, mark.native);
  return [GtkTextIterator textIteratorWithNative:&nativeIter];
}

-(GtkTextIterator *)createIteratorForChildAnchor:(GtkTextChildAnchor *)anchor
{
  struct _GtkTextIter nativeIter;
  gtk_text_buffer_get_iter_at_child_anchor(NATIVE_TEXTBUFFER, &nativeIter, anchor.native);
  return [GtkTextIterator textIteratorWithNative:&nativeIter];
}

-(GtkTextIterator *)createIteratorForStart
{
  struct _GtkTextIter nativeIter;
  gtk_text_buffer_get_start_iter(NATIVE_TEXTBUFFER, &nativeIter);
  return [GtkTextIterator textIteratorWithNative:&nativeIter];
}

-(GtkTextIterator *)createIteratorForEnd
{
  struct _GtkTextIter nativeIter;
  gtk_text_buffer_get_end_iter(NATIVE_TEXTBUFFER, &nativeIter);
  return [GtkTextIterator textIteratorWithNative:&nativeIter];
}
//----------------------------------------------------------------------------------------------------------------------------------
-(void)setText:(OFString *)text ofLength:(int)length
{
  OFAutoreleasePool *pool = [[OFAutoreleasePool alloc] init];
  gtk_text_buffer_set_text(NATIVE_TEXTBUFFER, [text UTF8String], length);
  [pool drain];
}
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-(OFString *)getTextFrom:(GtkTextIterator *)begin to:(GtkTextIterator *)end
{
  gchar *str = gtk_text_buffer_get_text(NATIVE_TEXTBUFFER, begin.native, end.native, NO);
  OFString *retStr = [OFString stringWithUTF8String:str];
  g_free(str);
  return retStr;
}

-(OFString *)getTextFrom:(GtkTextIterator *)begin to:(GtkTextIterator *)end withInvisible:(BOOL)invisible
{
  gchar *str = gtk_text_buffer_get_text(NATIVE_TEXTBUFFER, begin.native, end.native, invisible);
  OFString *retStr = [OFString stringWithUTF8String:str];
  g_free(str);
  return retStr;
}
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-(OFString *)getSliceFrom:(GtkTextIterator *)begin to:(GtkTextIterator *)end
{
  gchar *str = gtk_text_buffer_get_slice(NATIVE_TEXTBUFFER, begin.native, end.native, NO);
  OFString *retStr = [OFString stringWithUTF8String:str];
  g_free(str);
  return retStr;
}

-(OFString *)getSliceFrom:(GtkTextIterator *)begin to:(GtkTextIterator *)end withInvisible:(BOOL)invisible
{
  gchar *str = gtk_text_buffer_get_slice(NATIVE_TEXTBUFFER, begin.native, end.native, invisible);
  OFString *retStr = [OFString stringWithUTF8String:str];
  g_free(str);
  return retStr;
}

//==================================================================================================================================
// Signal Handlers
//==================================================================================================================================
-(void)onChanged
{
  [_delegate gtkTextBufferChanged:self];
}
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-(void)onModifiedChanged
{
  [_delegate gtkTextBufferModifiedChanged:self];
}
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-(void)onUserActionBegin
{
  [_delegate gtkTextBufferUserActionBegin:self];
}
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-(void)onUserActionEnd
{
  [_delegate gtkTextBufferUserActionEnd:self];
}
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-(void)onApplyTag:(GtkTextTag *)tag from:(GtkTextIterator *)start to:(GtkTextIterator *)end;
{
  [_delegate gtkTextBuffer:self applyTag:tag from:start to:end];
}
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-(void)onDeleteRangeFrom:(GtkTextIterator *)start to:(GtkTextIterator *)end
{
  [_delegate gtkTextBuffer:self deleteRangeFrom:start to:end];
}
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-(void)onInsertChildAnchor:(GtkTextChildAnchor *)anchor at:(GtkTextIterator *)location
{
  [_delegate gtkTextBuffer:self insertChildAnchor:anchor at:location];
}
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-(void)onInsertText:(OFString *)text at:(GtkTextIterator *)location
{
  [_delegate gtkTextBuffer:self insertText:text at:location];
}
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-(void)onMarkDeleted:(GtkTextMark *)mark
{
  [_delegate gtkTextBuffer:self markDeleted:mark];
}
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-(void)onMarkSet:(GtkTextMark *)mark at:(GtkTextIterator *)location
{
  [_delegate gtkTextBuffer:self markSet:mark at:location];
}
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-(void)onRemoveTag:(GtkTextTag *)tag from:(GtkTextIterator *)start to:(GtkTextIterator *)end
{
  [_delegate gtkTextBuffer:self removeTag:tag from:start to:end];
}

//==================================================================================================================================
@end

//==================================================================================================================================
//----------------------------------------------------------------------------------------------------------------------------------
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
