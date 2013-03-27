//==================================================================================================================================
// GtkTextView.m
//==================================================================================================================================
#import "GtkNative.h"
#import <adenosine/adenosine.h>
#import <atropine/atropine.h>

//==================================================================================================================================
#define NATIVE_WIDGET   ((struct _GtkWidget   *)_native)
#define NATIVE_TEXTVIEW ((struct _GtkTextView *)_native)

//==================================================================================================================================
// Signal/Event -> Object Proxies
//==================================================================================================================================
static void ConnectionProxy_PopulatePopup(struct _GtkTextView *entry, struct _GtkMenu *menu, void *data)
{
  //NOTE: see GtkEntry.m:ConnectionProxy_PopulatePopup for notes/todo on this event...
  GtkTextView *obj  = (GtkTextView *)[GtkWidget nativeToWrapper:(void *)entry];
  GtkMenu  *oMnu    = (GtkMenu  *)[GtkWidget nativeToWrapper:(void *)menu];
  if(!oMnu) oMnu    = (GtkMenu *)[GtkWidget wrapExistingNative:menu];
  [obj onPopulatePopup:oMnu];
}

//==================================================================================================================================
@implementation GtkTextView

//==================================================================================================================================
// Constructors/Destructor
//==================================================================================================================================
+ textView                                   { return [[               [self alloc] initTextView         ] autorelease]; }
+ textViewWithBuffer:(GtkTextBuffer *)buffer { return [[(GtkTextView *)[self alloc] initWithBuffer:buffer] autorelease]; }
//----------------------------------------------------------------------------------------------------------------------------------
- initTextView
{
  self = [super init];
  if(self)
  {
    _native = gtk_text_view_new();
    [self installNativeLookup];
  }
  return self;
}
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
- initWithBuffer:(GtkTextBuffer *)buffer
{
  if(!buffer) return [self initTextView];
  self = [super init];
  if(self)
  {
    _native = gtk_text_view_new_with_buffer(buffer.native);
    [self installNativeLookup];
    _buffer = [buffer retain];
  }
  return self;
}

//==================================================================================================================================
// Properites
//==================================================================================================================================
-(GtkTextBuffer *)buffer
{
  if(_buffer) return _buffer;
  void *nativeBuffer = gtk_text_view_get_buffer(NATIVE_TEXTVIEW);
  if(!nativeBuffer) return nil;
  _buffer = [[GtkTextBuffer alloc] initWithExistingNative:nativeBuffer];
  return _buffer;
}
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-(void)setBuffer:(GtkTextBuffer *)buffer
{
  if(buffer == _buffer) return;
  [_buffer release];
  _buffer = [buffer retain];
}
//----------------------------------------------------------------------------------------------------------------------------------
-(GtkTextWrap)wrapMode                           { return (GtkTextWrap)gtk_text_view_get_wrap_mode(NATIVE_TEXTVIEW);              }
-(void)setWrapMode:(GtkTextWrap)wrapMode         { gtk_text_view_set_wrap_mode(NATIVE_TEXTVIEW, (Native_GtkWrapMode)wrapMode);    }
-(BOOL)editable                                  { return gtk_text_view_get_editable(NATIVE_TEXTVIEW);                            }
-(void)setEditable:(BOOL)editable                { gtk_text_view_set_editable(NATIVE_TEXTVIEW, editable);                         }
-(BOOL)cursorVisible                             { return gtk_text_view_get_cursor_visible(NATIVE_TEXTVIEW);                      }
-(void)setCursorVisible:(BOOL)cursorVisible      { gtk_text_view_set_cursor_visible(NATIVE_TEXTVIEW, cursorVisible);              }
-(BOOL)overwrite                                 { return gtk_text_view_get_overwrite(NATIVE_TEXTVIEW);                           }
-(void)setOverwrite:(BOOL)overwrite              { gtk_text_view_set_overwrite(NATIVE_TEXTVIEW, overwrite);                       }
-(int)pixelsAboveLines                           { return gtk_text_view_get_pixels_above_lines(NATIVE_TEXTVIEW);                  }
-(void)setPixelsAboveLines:(int)pixelsAboveLines { gtk_text_view_set_pixels_above_lines(NATIVE_TEXTVIEW, pixelsAboveLines);       }
-(int)pixelsBelowLines                           { return gtk_text_view_get_pixels_below_lines(NATIVE_TEXTVIEW);                  }
-(void)setPixelsBelowLines:(int)pixelsBelowLines { gtk_text_view_set_pixels_below_lines(NATIVE_TEXTVIEW, pixelsBelowLines);       }
-(int)pixelsInsideWrap                           { return gtk_text_view_get_pixels_inside_wrap(NATIVE_TEXTVIEW);                  }
-(void)setPixelsInsideWrap:(int)pixelsInsideWrap { gtk_text_view_set_pixels_inside_wrap(NATIVE_TEXTVIEW, pixelsInsideWrap);       }
-(GtkTextAlign)alignment                         { return (GtkTextAlign)gtk_text_view_get_justification(NATIVE_TEXTVIEW);         }
-(void)setAlignment:(GtkTextAlign)alignment      { gtk_text_view_set_justification(NATIVE_TEXTVIEW, (GtkJustification)alignment); }
-(int)marginLeft                                 { return gtk_text_view_get_left_margin(NATIVE_TEXTVIEW);                         }
-(void)setMarginLeft:(int)marginLeft             { gtk_text_view_set_left_margin(NATIVE_TEXTVIEW, marginLeft);                    }
-(int)marginRight                                { return gtk_text_view_get_left_margin(NATIVE_TEXTVIEW);                         }
-(void)setMarginRight:(int)marginRight           { gtk_text_view_set_left_margin(NATIVE_TEXTVIEW, marginRight);                   }
-(int)indent                                     { return gtk_text_view_get_indent(NATIVE_TEXTVIEW);                              }
-(void)setIndent:(int)indent                     { gtk_text_view_set_indent(NATIVE_TEXTVIEW, indent);                             }
-(BOOL)acceptsTab                                { return gtk_text_view_get_accepts_tab(NATIVE_TEXTVIEW);                         }
-(void)setAcceptsTab:(BOOL)acceptsTab            { gtk_text_view_set_accepts_tab(NATIVE_TEXTVIEW, acceptsTab);                    }
//----------------------------------------------------------------------------------------------------------------------------------
-(void)setDelegate:(id)delegate
{
  [super setDelegate:delegate];
  
  if(_delegate)
  {
    if([_delegate respondsToSelector:@selector(gtkTextView:populatePopup:)])
      [_connections addObject:[OFNumber numberWithUnsignedLong:
        g_signal_connect(_native, "populate-popup", G_CALLBACK(ConnectionProxy_PopulatePopup),NULL)]];
  }
}

//==================================================================================================================================
// Utilities
//==================================================================================================================================
-(OMDimension)bufferToWindowDimension:(OMDimension)dimension forWindow:(GtkTextViewWindow)window
{
  int windowX, windowY;
  int bufferX = (int)dimension.origin.x;
  int bufferY = (int)dimension.origin.y;
  gtk_text_view_buffer_to_window_coords(NATIVE_TEXTVIEW, (Native_GtkTextWindowType)window, bufferX, bufferY, &windowX, &windowY);
  return OMMakeDimensionFloats((float)windowX, (float)windowY, dimension.size.width, dimension.size.height);
}
-(OMCoordinate)bufferToWindowCoordinate:(OMCoordinate)coordinate forWindow:(GtkTextViewWindow)window
{
  int windowX, windowY;
  int bufferX = (int)coordinate.x;
  int bufferY = (int)coordinate.y;
  gtk_text_view_buffer_to_window_coords(NATIVE_TEXTVIEW, (Native_GtkTextWindowType)window, bufferX, bufferY, &windowX, &windowY);
  return OMMakeCoordinate((float)windowX, (float)windowY);
}
-(OMCoordinate)windowToBufferCoordinate:(OMCoordinate)coordinate forWindow:(GtkTextViewWindow)window
{
  int bufferX, bufferY;
  int windowX = (int)coordinate.x;
  int windowY = (int)coordinate.y;
  gtk_text_view_window_to_buffer_coords(NATIVE_TEXTVIEW, (Native_GtkTextWindowType)window, windowX, windowY, &bufferX, &bufferY);
  return OMMakeCoordinate((float)bufferX, (float)bufferY);
}
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-(OMDimension)visibleDimension
{
  GdkRectangle rect;
  gtk_text_view_get_visible_rect(NATIVE_TEXTVIEW, &rect);
  return OMMakeDimensionFloats((float)rect.x, (float)rect.y, (float)rect.width, (float)rect.height);
}
-(OMDimension)iteratorDimension:(GtkTextIterator *)iterator
{
  GdkRectangle rect;
  gtk_text_view_get_iter_location(NATIVE_TEXTVIEW, iterator.native, &rect);
  return OMMakeDimensionFloats((float)rect.x, (float)rect.y, (float)rect.width, (float)rect.height);
}
-(OMDimension)weakCursorDimensionAt:(GtkTextIterator *)iterator
{
  GdkRectangle rect;
  gtk_text_view_get_cursor_locations(NATIVE_TEXTVIEW, iterator.native, NULL, &rect);
  return OMMakeDimensionFloats((float)rect.x, (float)rect.y, (float)rect.width, (float)rect.height);
}
-(OMDimension)strongCursorDimensionAt:(GtkTextIterator *)iterator
{
  GdkRectangle rect;
  gtk_text_view_get_cursor_locations(NATIVE_TEXTVIEW, iterator.native, &rect, NULL);
  return OMMakeDimensionFloats((float)rect.x, (float)rect.y, (float)rect.width, (float)rect.height);
}
//----------------------------------------------------------------------------------------------------------------------------------
-(GtkTextIterator *)iteratorForLineAtY:(int)y
{
  struct _GtkTextIter nativeIter;
  gtk_text_view_get_line_at_y(NATIVE_TEXTVIEW, &nativeIter, y, NULL);
  return [GtkTextIterator textIteratorWithNative:&nativeIter];
}

-(GtkTextIterator *)iteratorForLocationX:(int)x Y:(int)y
{
  struct _GtkTextIter nativeIter;
  gtk_text_view_get_iter_at_location(NATIVE_TEXTVIEW, &nativeIter, x, y);
  return [GtkTextIterator textIteratorWithNative:&nativeIter];
}

-(GtkTextIterator *)iteratorForLocationCoordinate:(OMCoordinate)coordinate
{
  struct _GtkTextIter nativeIter;
  gtk_text_view_get_iter_at_location(NATIVE_TEXTVIEW, &nativeIter, (int)coordinate.x, (int)coordinate.y);
  return [GtkTextIterator textIteratorWithNative:&nativeIter];
}

-(GtkTextIterator *)iteratorForPositionX:(int)x Y:(int)y
{
  struct _GtkTextIter nativeIter;
  gtk_text_view_get_iter_at_position(NATIVE_TEXTVIEW, &nativeIter, NULL, x, y);
  return [GtkTextIterator textIteratorWithNative:&nativeIter];
}

-(GtkTextIterator *)iteratorForPositionCoordinate:(OMCoordinate)coordinate
{
  struct _GtkTextIter nativeIter;
  gtk_text_view_get_iter_at_position(NATIVE_TEXTVIEW, &nativeIter, NULL, (int)coordinate.x, (int)coordinate.y);
  return [GtkTextIterator textIteratorWithNative:&nativeIter];
}

-(OMDimension)verticalRangeOfLineAt:(GtkTextIterator *)iterator
{
  int top, height;
  gtk_text_view_get_line_yrange(NATIVE_TEXTVIEW, iterator.native, &top, &height);
  return OMMakeDimensionFloats(0.0f, (float)top, 0.0f, (float)height);
}
//----------------------------------------------------------------------------------------------------------------------------------
-(void)scrollToMark:(GtkTextMark *)mark withinMargin:(float)margin
{
  gtk_text_view_scroll_to_mark(NATIVE_TEXTVIEW, mark.native, margin, NO, 0.0, 0.0);
}

-(void)scrollToMark:(GtkTextMark *)mark alignX:(float)x alignY:(float)y
{
  gtk_text_view_scroll_to_mark(NATIVE_TEXTVIEW, mark.native, 0.5, YES, (double)x, (double)y);
}

-(void)scrollMarkOnScreen:(GtkTextMark *)mark
{
  gtk_text_view_scroll_mark_onscreen(NATIVE_TEXTVIEW, mark.native);
}

-(void)moveMarkOnScreen:(GtkTextMark *)mark
{
  gtk_text_view_move_mark_onscreen(NATIVE_TEXTVIEW, mark.native);
}

-(void)scrollToIterator:(GtkTextIterator *)iterator withinMargin:(float)margin
{
  gtk_text_view_scroll_to_iter(NATIVE_TEXTVIEW, iterator.native, margin, NO, 0.0, 0.0);
}

-(void)scrollToIterator:(GtkTextIterator *)iterator alignX:(float)x alignY:(float)y
{
  gtk_text_view_scroll_to_iter(NATIVE_TEXTVIEW, iterator.native, 0.5, YES, (double)x, (double)y);
}

-(void)moveCursorOnScreen
{
  gtk_text_view_place_cursor_onscreen(NATIVE_TEXTVIEW);
}
//----------------------------------------------------------------------------------------------------------------------------------
-(BOOL)forwardDisplayLine:(GtkTextIterator *)iterator
{
  return gtk_text_view_forward_display_line(NATIVE_TEXTVIEW, iterator.native);
}

-(BOOL)backwardDisplayLine:(GtkTextIterator *)iterator
{
  return gtk_text_view_backward_display_line(NATIVE_TEXTVIEW, iterator.native);
}

-(BOOL)forwardDisplayLineEnd:(GtkTextIterator *)iterator
{
  return gtk_text_view_forward_display_line_end(NATIVE_TEXTVIEW, iterator.native);
}

-(BOOL)backwardDisplayLineStart:(GtkTextIterator *)iterator
{
  return gtk_text_view_backward_display_line_start(NATIVE_TEXTVIEW, iterator.native);
}

-(BOOL)startsDisplayLine:(GtkTextIterator *)iterator
{
  return gtk_text_view_starts_display_line(NATIVE_TEXTVIEW, iterator.native);
}

-(BOOL)moveVisually:(GtkTextIterator *)iterator offset:(int)offset
{
  return gtk_text_view_move_visually(NATIVE_TEXTVIEW, iterator.native, offset);
}
//----------------------------------------------------------------------------------------------------------------------------------
-(void)addChild:(GtkWidget *)child atAnchor:(GtkTextChildAnchor *)anchor
{
  [_children addObject:child];
  gtk_text_view_add_child_at_anchor(NATIVE_TEXTVIEW, child.native, anchor.native);
}

-(void)addChild:(GtkWidget *)child toWindow:(GtkTextViewWindow)window atX:(int)x andY:(int)y
{
  [_children addObject:child];
  gtk_text_view_add_child_in_window(NATIVE_TEXTVIEW, child.native, (Native_GtkTextWindowType)window, x, y);
}

-(void)addChild:(GtkWidget *)child toWindow:(GtkTextViewWindow)window at:(OMCoordinate)coordinate
{
  [_children addObject:child];
  gtk_text_view_add_child_in_window(NATIVE_TEXTVIEW, child.native, (Native_GtkTextWindowType)window, (int)coordinate.x, (int)coordinate.y);
}

-(void)moveChild:(GtkWidget *)child toX:(int)x andY:(int)y
{
  gtk_text_view_move_child(NATIVE_TEXTVIEW, child.native, x, y);
}

-(void)moveChild:(GtkWidget *)child to:(OMCoordinate)coordinate
{
  gtk_text_view_move_child(NATIVE_TEXTVIEW, child.native, (int)coordinate.x, (int)coordinate.y);
}

//----------------------------------------------------------------------------------------------------------------------------------
-(void)setBorder:(GtkPosition)position toSize:(int)size
{
  Native_GtkTextWindowType windowType;
  switch(position)
  {
    case GTKPOSITION_LEFT   : windowType = GTK_TEXT_WINDOW_LEFT;   break;
    case GTKPOSITION_RIGHT  : windowType = GTK_TEXT_WINDOW_RIGHT;  break;
    case GTKPOSITION_TOP    : windowType = GTK_TEXT_WINDOW_TOP;    break;
    case GTKPOSITION_BOTTOM : windowType = GTK_TEXT_WINDOW_BOTTOM; break;
    default: return;
  }
  gtk_text_view_set_border_window_size(NATIVE_TEXTVIEW, windowType, size);
}

-(int)getBorderSize:(GtkPosition)position
{
  Native_GtkTextWindowType windowType;
  switch(position)
  {
    case GTKPOSITION_LEFT   : windowType = GTK_TEXT_WINDOW_LEFT;   break;
    case GTKPOSITION_RIGHT  : windowType = GTK_TEXT_WINDOW_RIGHT;  break;
    case GTKPOSITION_TOP    : windowType = GTK_TEXT_WINDOW_TOP;    break;
    case GTKPOSITION_BOTTOM : windowType = GTK_TEXT_WINDOW_BOTTOM; break;
    default: return 0;
  }
  return gtk_text_view_get_border_window_size(NATIVE_TEXTVIEW, windowType);
}

//==================================================================================================================================
// Signal Handlers
//==================================================================================================================================
-(void)onPopulatePopup:(GtkMenu *)menu { [_delegate gtkTextView:self populatePopup:menu]; }

//==================================================================================================================================
@end

//==================================================================================================================================
//----------------------------------------------------------------------------------------------------------------------------------
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
