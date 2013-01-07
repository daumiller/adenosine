//==================================================================================================================================
// GtkTextIterator.m
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
#define NATIVE_ITERATOR ((struct _GtkTextIter *)_native)

//==================================================================================================================================
@implementation GtkTextIterator

//==================================================================================================================================
// Wrapping
//==================================================================================================================================
+ textIteratorWithNative:(void *)native { return [[[self alloc] initWithExistingNative:native] autorelease]; }
//----------------------------------------------------------------------------------------------------------------------------------
- initWithExistingNative:(void *)native
{
  self = [super init];
  if(self)
  {
    _native = (void *)gtk_text_iter_copy((struct _GtkTextIter *)native);
  }
  return self;
}

//==================================================================================================================================
// Constructors/Destructor
//==================================================================================================================================
+ textIteratorWithIterator:(GtkTextIterator *)copyFrom { return [[[self alloc] initWithIterator:copyFrom] autorelease]; }
- initWithIterator:(GtkTextIterator *)copyFrom
{
  self = [super init];
  if(self)
  {
    _native = (void *)gtk_text_iter_copy((struct _GtkTextIter *)copyFrom.native);
  }
  return self;
}
//----------------------------------------------------------------------------------------------------------------------------------
- copy
{
  return [[GtkTextIterator alloc] initWithIterator:_native];
}
//----------------------------------------------------------------------------------------------------------------------------------
-(void)destroy
{
  gtk_text_iter_free(NATIVE_ITERATOR);
}

//==================================================================================================================================
// Properites
//==================================================================================================================================
-(void *)native { return _native; }
//----------------------------------------------------------------------------------------------------------------------------------
-(int)charOffset                                   { return gtk_text_iter_get_offset             (NATIVE_ITERATOR);             }
-(int)lineNumber                                   { return gtk_text_iter_get_line               (NATIVE_ITERATOR);             }
-(int)lineOffset                                   { return gtk_text_iter_get_line_offset        (NATIVE_ITERATOR);             }
-(int)visibleLineOffset                            { return gtk_text_iter_get_visible_line_offset(NATIVE_ITERATOR);             }
-(void)setCharOffset:(int)charOffset               { gtk_text_iter_set_offset             (NATIVE_ITERATOR, charOffset       ); }
-(void)setLineNumber:(int)lineNumber               { gtk_text_iter_set_line               (NATIVE_ITERATOR, lineNumber       ); }
-(void)setLineOffset:(int)lineOffset               { gtk_text_iter_set_line_offset        (NATIVE_ITERATOR, lineOffset       ); }
-(void)setVisibleLineOffset:(int)visibleLineOffset { gtk_text_iter_set_visible_line_offset(NATIVE_ITERATOR, visibleLineOffset); }
//----------------------------------------------------------------------------------------------------------------------------------
-(BOOL)isEditable       { return gtk_text_iter_editable          (NATIVE_ITERATOR, YES); }
-(BOOL)isInsertable     { return gtk_text_iter_can_insert        (NATIVE_ITERATOR, YES); }
-(BOOL)isCursorPosition { return gtk_text_iter_is_cursor_position(NATIVE_ITERATOR);      }
//----------------------------------------------------------------------------------------------------------------------------------
-(BOOL)isStart        { return gtk_text_iter_is_start       (NATIVE_ITERATOR); }
-(BOOL)isEnd          { return gtk_text_iter_is_end         (NATIVE_ITERATOR); }
-(BOOL)startsWord     { return gtk_text_iter_starts_word    (NATIVE_ITERATOR); }
-(BOOL)endsWord       { return gtk_text_iter_ends_word      (NATIVE_ITERATOR); }
-(BOOL)insideWord     { return gtk_text_iter_inside_word    (NATIVE_ITERATOR); }
-(BOOL)startsLine     { return gtk_text_iter_starts_line    (NATIVE_ITERATOR); }
-(BOOL)endsLine       { return gtk_text_iter_ends_line      (NATIVE_ITERATOR); }
-(BOOL)startsSentence { return gtk_text_iter_starts_sentence(NATIVE_ITERATOR); }
-(BOOL)endsSentence   { return gtk_text_iter_ends_sentence  (NATIVE_ITERATOR); }
-(BOOL)insideSentence { return gtk_text_iter_inside_sentence(NATIVE_ITERATOR); }
//----------------------------------------------------------------------------------------------------------------------------------
-(int)charsInLine    { return gtk_text_iter_get_chars_in_line(NATIVE_ITERATOR); }
-(uint32_t)character { return gtk_text_iter_get_char         (NATIVE_ITERATOR); }

//==================================================================================================================================
// Utilities
//==================================================================================================================================
-(BOOL)beginsTag:(GtkTextTag *)tag
{
  void *nativeTag = tag ? tag.native : NULL;
  return gtk_text_iter_begins_tag(NATIVE_ITERATOR, nativeTag);
}
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-(BOOL)endsTag:(GtkTextTag *)tag
{
  void *nativeTag = tag ? tag.native : NULL;
  return gtk_text_iter_ends_tag(NATIVE_ITERATOR, nativeTag);
}
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-(BOOL)togglesTag:(GtkTextTag *)tag
{
  void *nativeTag = tag ? tag.native : NULL;
  return gtk_text_iter_toggles_tag(NATIVE_ITERATOR, nativeTag);
}
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-(BOOL)hasTag:(GtkTextTag *)tag
{
  if(!tag) return NO;
  return gtk_text_iter_begins_tag(NATIVE_ITERATOR, tag.native);
}
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-(BOOL)forwardToTagToggle:(GtkTextTag *)tag
{
  void *nativeTag = tag ? tag.native : NULL;
  return gtk_text_iter_forward_to_tag_toggle(NATIVE_ITERATOR, nativeTag);
}
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-(BOOL)backwardToTagToggle:(GtkTextTag *)tag
{
  void *nativeTag = tag ? tag.native : NULL;
  return gtk_text_iter_backward_to_tag_toggle(NATIVE_ITERATOR, nativeTag);
}
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-(OFArray *)listTags
{
  OFMutableArray *ofTags = [[OFMutableArray alloc] init];
  GSList *goTags = gtk_text_iter_get_tags(NATIVE_ITERATOR);
  unsigned int goCount = g_slist_length(goTags);
  for(unsigned int i=0; i<goCount; i++)
  {
    void *nativeTag = g_slist_nth_data(goTags, i);
    GtkTextTag *ofTag = [GtkTextTag nativeToWrapper:nativeTag];
    if(!ofTag) ofTag = [[GtkTextTag alloc] initWithExistingNative:nativeTag];
    [ofTags addObject:ofTag];
  }
  g_slist_free(goTags);

  OFArray *retArr = [OFArray arrayWithArray:ofTags];
  [ofTags release];
  return retArr;
}
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-(OFArray *)listToggledTags:(BOOL)onOrOff
{
  OFMutableArray *ofTags = [[OFMutableArray alloc] init];
  GSList *goTags = gtk_text_iter_get_toggled_tags(NATIVE_ITERATOR, onOrOff);
  unsigned int goCount = g_slist_length(goTags);
  for(unsigned int i=0; i<goCount; i++)
  {
    void *nativeTag = g_slist_nth_data(goTags, i);
    GtkTextTag *ofTag = [GtkTextTag nativeToWrapper:nativeTag];
    if(!ofTag) ofTag = [[GtkTextTag alloc] initWithExistingNative:nativeTag];
    [ofTags addObject:ofTag];
  }
  g_slist_free(goTags);

  OFArray *retArr = [OFArray arrayWithArray:ofTags];
  [ofTags release];
  return retArr;
}

//----------------------------------------------------------------------------------------------------------------------------------
-(BOOL)forwardChar                   { return gtk_text_iter_forward_char                    (NATIVE_ITERATOR); }
-(BOOL)backwardChar                  { return gtk_text_iter_backward_char                   (NATIVE_ITERATOR); }
-(BOOL)forwardLine                   { return gtk_text_iter_forward_line                    (NATIVE_ITERATOR); }
-(BOOL)backwardLine                  { return gtk_text_iter_backward_line                   (NATIVE_ITERATOR); }
-(BOOL)forwardWordEnd                { return gtk_text_iter_forward_word_end                (NATIVE_ITERATOR); }
-(BOOL)backwardWordStart             { return gtk_text_iter_backward_word_start             (NATIVE_ITERATOR); }
-(BOOL)forwardCursorPosition         { return gtk_text_iter_forward_cursor_position         (NATIVE_ITERATOR); }
-(BOOL)backwardCursorPosition        { return gtk_text_iter_backward_cursor_position        (NATIVE_ITERATOR); }
-(BOOL)forwardSentenceEnd            { return gtk_text_iter_forward_sentence_end            (NATIVE_ITERATOR); }
-(BOOL)backwardSentenceStart         { return gtk_text_iter_backward_sentence_start         (NATIVE_ITERATOR); }
-(BOOL)forwardVisibleWordEnd         { return gtk_text_iter_forward_visible_word_end        (NATIVE_ITERATOR); }
-(BOOL)backwardVisibleWordStart      { return gtk_text_iter_backward_visible_word_start     (NATIVE_ITERATOR); }
-(BOOL)forwardVisibleCursorPosition  { return gtk_text_iter_forward_visible_cursor_position (NATIVE_ITERATOR); }
-(BOOL)backwardVisibleCursorPosition { return gtk_text_iter_backward_visible_cursor_position(NATIVE_ITERATOR); }
-(BOOL)forwardVisibleLine            { return gtk_text_iter_forward_visible_line            (NATIVE_ITERATOR); }
-(BOOL)backwardVisibleLine           { return gtk_text_iter_backward_visible_line           (NATIVE_ITERATOR); }
-(BOOL)forwardToLineEnd              { return gtk_text_iter_forward_to_line_end             (NATIVE_ITERATOR); }
-(void)forwardToEnd                  { return gtk_text_iter_forward_to_end                  (NATIVE_ITERATOR); }
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-(BOOL)forwardChars                  :(int)chars     { return gtk_text_iter_forward_chars                    (NATIVE_ITERATOR, chars    ); }
-(BOOL)backwardChar                  :(int)chars     { return gtk_text_iter_backward_chars                   (NATIVE_ITERATOR, chars    ); }
-(BOOL)forwardLines                  :(int)lines     { return gtk_text_iter_forward_lines                    (NATIVE_ITERATOR, lines    ); }
-(BOOL)backwardLines                 :(int)lines     { return gtk_text_iter_backward_lines                   (NATIVE_ITERATOR, lines    ); }
-(BOOL)forwardWordEnds               :(int)ends      { return gtk_text_iter_forward_word_ends                (NATIVE_ITERATOR, ends     ); }
-(BOOL)backwardWordStarts            :(int)starts    { return gtk_text_iter_backward_word_starts             (NATIVE_ITERATOR, starts   ); }
-(BOOL)forwardCursorPositions        :(int)positions { return gtk_text_iter_forward_cursor_positions         (NATIVE_ITERATOR, positions); }
-(BOOL)backwardCursorPositions       :(int)positions { return gtk_text_iter_backward_cursor_positions        (NATIVE_ITERATOR, positions); }
-(BOOL)forwardSentencEnds            :(int)ends      { return gtk_text_iter_forward_sentence_ends            (NATIVE_ITERATOR, ends     ); }
-(BOOL)backwardSentenceStarts        :(int)starts    { return gtk_text_iter_backward_sentence_starts         (NATIVE_ITERATOR, starts   ); }
-(BOOL)forwardVisibleWordEnds        :(int)ends      { return gtk_text_iter_forward_visible_word_ends        (NATIVE_ITERATOR, ends     ); }
-(BOOL)backwardVisibleWordStarts     :(int)starts    { return gtk_text_iter_backward_visible_word_starts     (NATIVE_ITERATOR, starts   ); }
-(BOOL)forwardVisibleCursorPositions :(int)positions { return gtk_text_iter_forward_visible_cursor_positions (NATIVE_ITERATOR, positions); }
-(BOOL)backwardVisibleCursorPositions:(int)positions { return gtk_text_iter_backward_visible_cursor_positions(NATIVE_ITERATOR, positions); }
-(BOOL)forwardVisibleLines           :(int)lines     { return gtk_text_iter_forward_visible_lines            (NATIVE_ITERATOR, lines    ); }
-(BOOL)backwardVisibleLines          :(int)lines     { return gtk_text_iter_backward_visible_lines           (NATIVE_ITERATOR, lines    ); }
//----------------------------------------------------------------------------------------------------------------------------------
-(BOOL)equals:(GtkTextIterator *)equalTo
{
  return gtk_text_iter_equal(NATIVE_ITERATOR, equalTo.native);
}
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-(of_comparison_result_t)compare:(GtkTextIterator *)compareTo
{
  int result = gtk_text_iter_compare(NATIVE_ITERATOR, compareTo.native);
  if(result == 0) return OF_ORDERED_SAME;
  return (result < 0) ? OF_ORDERED_ASCENDING : OF_ORDERED_DESCENDING;
}
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-(BOOL)isBetween:(GtkTextIterator *)begin and:(GtkTextIterator *)end
{
  return gtk_text_iter_in_range(NATIVE_ITERATOR, begin.native, end.native);
}

//==================================================================================================================================
@end

//==================================================================================================================================
//----------------------------------------------------------------------------------------------------------------------------------
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
