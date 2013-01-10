//==================================================================================================================================
// GtkWidget.m
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
#define NATIVE_WIDGET ((struct _GtkWidget *)_native)
#define ADENOSINE_NATIVE_LOOKUP_STRING "_adenosine_wrapper_widget"

//==================================================================================================================================
// Signal/Event -> Object Proxies
//==================================================================================================================================
static BOOL ConnectionProxy_Draw(struct _GtkWidget *widget, void *nativeCairoContext, void *data)
{
  GtkWidget *obj = (GtkWidget *)[GtkWidget nativeToWrapper:(void *)widget];
  OMSurface *surface = [[OMSurface alloc] initWithCairoContext:nativeCairoContext
                                                         width:gtk_widget_get_allocated_width(widget)
                                                        height:gtk_widget_get_allocated_height(widget)];
  BOOL retval = [obj onDrawToSurface:surface];
  [surface release];
  return retval;
}
//----------------------------------------------------------------------------------------------------------------------------------
static BOOL ConnectionProxy_Configure(struct _GtkWidget *widget, GdkEventConfigure *event, void *data)
{
  GtkWidget *obj = (GtkWidget *)[GtkWidget nativeToWrapper:(void *)widget];
  return [obj onDimensionsChanged:OMMakeDimensionFloats((float)event->x, (float)event->y, (float)event->width, (float)event->height)];
}
//----------------------------------------------------------------------------------------------------------------------------------
static BOOL ConnectionProxy_ButtonPress(struct _GtkWidget *widget, GdkEventButton *event, void *data)
{
  GtkWidget *obj = (GtkWidget *)[GtkWidget nativeToWrapper:(void *)widget];
  OMCoordinate local = OMMakeCoordinate((float)event->x, (float)event->y);
  OMCoordinate root  = OMMakeCoordinate((float)event->x_root, (float)event->y_root);
  int clickCount = 1;
  if(event->type == GDK_2BUTTON_PRESS) clickCount = 2;
  if(event->type == GDK_3BUTTON_PRESS) clickCount = 3;
  return [obj onButtonPressed:event->button clickCount:clickCount local:local root:root modifiers:(GtkModifier)event->state];
}
//----------------------------------------------------------------------------------------------------------------------------------
static BOOL ConnectionProxy_ButtonRelease(struct _GtkWidget *widget, GdkEventButton *event, void *data)
{
  GtkWidget *obj = (GtkWidget *)[GtkWidget nativeToWrapper:(void *)widget];
  OMCoordinate local = OMMakeCoordinate((float)event->x, (float)event->y);
  OMCoordinate root  = OMMakeCoordinate((float)event->x_root, (float)event->y_root);
  return [obj onButtonReleased:event->button local:local root:root modifiers:(GtkModifier)event->state];
}
//----------------------------------------------------------------------------------------------------------------------------------
static BOOL ConnectionProxy_PointerMotion(struct _GtkWidget *widget, GdkEventMotion *event, void *data)
{
  GtkWidget *obj = (GtkWidget *)[GtkWidget nativeToWrapper:(void *)widget];
  OMCoordinate local = OMMakeCoordinate((float)event->x, (float)event->y);
  OMCoordinate root  = OMMakeCoordinate((float)event->x_root, (float)event->y_root);
  return [obj onPointerMovedAt:local root:root modifiers:(GtkModifier)event->state];
}
//----------------------------------------------------------------------------------------------------------------------------------
static BOOL ConnectionProxy_Scroll(struct _GtkWidget *widget, GdkEventScroll *event, void *data)
{
  GtkWidget *obj = (GtkWidget *)[GtkWidget nativeToWrapper:(void *)widget];
  OMCoordinate local = OMMakeCoordinate((float)event->x, (float)event->y);
  OMCoordinate root  = OMMakeCoordinate((float)event->x_root, (float)event->y_root);
  double dX, dY; gdk_event_get_scroll_deltas((GdkEvent *)event, &dX, &dY); OMCoordinate deltas = OMMakeCoordinate((float)dX, (float)dY);
  return [obj onScrolled:(GtkScrollDirection)event->direction by:deltas at:local root:root modifiers:(GtkModifier)event->state];
}
//----------------------------------------------------------------------------------------------------------------------------------
static BOOL ConnectionProxy_KeyPress(struct _GtkWidget *widget, GdkEventKey *event, void *data)
{
  GtkWidget *obj = (GtkWidget *)[GtkWidget nativeToWrapper:(void *)widget];
  return [obj onKeyPressed:event->keyval raw:event->hardware_keycode group:event->group isModifier:event->is_modifier modifiers:(GtkModifier)event->state];
}
//----------------------------------------------------------------------------------------------------------------------------------
static BOOL ConnectionProxy_KeyRelease(struct _GtkWidget *widget, GdkEventKey *event, void *data)
{
  GtkWidget *obj = (GtkWidget *)[GtkWidget nativeToWrapper:(void *)widget];
  return [obj onKeyReleased:event->keyval raw:event->hardware_keycode group:event->group isModifier:event->is_modifier modifiers:(GtkModifier)event->state];
}

//==================================================================================================================================
@implementation GtkWidget

//==================================================================================================================================
// Constructors/Destructor
//==================================================================================================================================
+(BOOL)isWrapped:(void *)native
{
  return ([GtkWidget nativeToWrapper:native] != nil);
}
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
+ (id) wrapExistingNative:(void *)native
{
  if(native == NULL) return nil;

  //NOTE: be sure to check types in reverse hierarchical order.
  //(that is, native_is_gtk_type_named() will return YES for any valid ancenstor names)
  //also, left side strings are Gtk internal names (ex: "GtkMessageDialog" <-> GtkDialogMessage)  
  if(native_is_gtk_type_named(native, "GtkTextView"      )) return [[[GtkTextView       alloc] initWithExistingNative:native] autorelease];
  if(native_is_gtk_type_named(native, "GtkScrolledWindow")) return [[[GtkScrolledWindow alloc] initWithExistingNative:native] autorelease];
  if(native_is_gtk_type_named(native, "GtkMessageDialog" )) return [[[GtkDialogMessage  alloc] initWithExistingNative:native] autorelease];
  if(native_is_gtk_type_named(native, "GtkDialog"        )) return [[[GtkDialog         alloc] initWithExistingNative:native] autorelease];
  if(native_is_gtk_type_named(native, "GtkWindow"        )) return [[[GtkWindow         alloc] initWithExistingNative:native] autorelease];
  if(native_is_gtk_type_named(native, "GtkDrawingArea"   )) return [[[GtkDrawingArea    alloc] initWithExistingNative:native] autorelease];
  if(native_is_gtk_type_named(native, "GtkFontButton"    )) return [[[GtkFontButton     alloc] initWithExistingNative:native] autorelease];
  if(native_is_gtk_type_named(native, "GtkButton"        )) return [[[GtkButton         alloc] initWithExistingNative:native] autorelease];
  if(native_is_gtk_type_named(native, "GtkLabel"         )) return [[[GtkLabel          alloc] initWithExistingNative:native] autorelease];
  if(native_is_gtk_type_named(native, "GtkImage"         )) return [[[GtkImage          alloc] initWithExistingNative:native] autorelease];
  if(native_is_gtk_type_named(native, "GtkProgressBar"   )) return [[[GtkProgressBar    alloc] initWithExistingNative:native] autorelease];
  if(native_is_gtk_type_named(native, "GtkMenuImage"     )) return [[[GtkMenuImage      alloc] initWithExistingNative:native] autorelease];
  if(native_is_gtk_type_named(native, "GtkMenuRadio"     )) return [[[GtkMenuRadio      alloc] initWithExistingNative:native] autorelease];
  if(native_is_gtk_type_named(native, "GtkMenuCheck"     )) return [[[GtkMenuCheck      alloc] initWithExistingNative:native] autorelease];
  if(native_is_gtk_type_named(native, "GtkMenuItem"      )) return [[[GtkMenuItem       alloc] initWithExistingNative:native] autorelease];
  if(native_is_gtk_type_named(native, "GtkMenuBar"       )) return [[[GtkMenuBar        alloc] initWithExistingNative:native] autorelease];
  if(native_is_gtk_type_named(native, "GtkMenu"          )) return [[[GtkMenu           alloc] initWithExistingNative:native] autorelease];
  if(native_is_gtk_type_named(native, "GtkGrid"          )) return [[[GtkGrid           alloc] initWithExistingNative:native] autorelease];
  if(native_is_gtk_type_named(native, "GtkBox"           )) return [[[GtkBox            alloc] initWithExistingNative:native] autorelease];
  if(native_is_gtk_type_named(native, "GtkLayout"        )) return [[[GtkLayout         alloc] initWithExistingNative:native] autorelease];
  if(native_is_gtk_type_named(native, "GtkEventBox"      )) return [[[GtkEventBox       alloc] initWithExistingNative:native] autorelease];
  if(native_is_gtk_type_named(native, "GtkViewport"      )) return [[[GtkViewport       alloc] initWithExistingNative:native] autorelease];
  if(native_is_gtk_type_named(native, "GtkFrame"         )) return [[[GtkFrame          alloc] initWithExistingNative:native] autorelease];
  if(native_is_gtk_type_named(native, "GtkEntry"         )) return [[[GtkEntry          alloc] initWithExistingNative:native] autorelease];

  return [[[self alloc] initWithExistingNative:native] autorelease];
}
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
+ nativeToWrapper:(void *)native
{
  if(!GTK_IS_WIDGET(native)) return nil;
  return (GtkWidget *)g_object_get_data((GObject *)native, ADENOSINE_NATIVE_LOOKUP_STRING);
}
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
- init
{
  self = [super init];
  if(self)
  {
    _connections = [[OFMutableArray alloc] init];
  }
  return self;
}
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
- initWithExistingNative:(void *)native
{
  self = [super init];
  if(self)
  {
    _connections = [[OFMutableArray alloc] init];
    _native      = native;
    [self installNativeLookup];
  }
  return self;
}
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-(void)installNativeLookup
{
  g_object_set_data((gpointer)_native, ADENOSINE_NATIVE_LOOKUP_STRING, (gpointer)self);
}
//----------------------------------------------------------------------------------------------------------------------------------
-(void)destroy
{
  if(GTK_IS_WIDGET(NATIVE_WIDGET)) gtk_widget_destroy(NATIVE_WIDGET);
}
//----------------------------------------------------------------------------------------------------------------------------------
-(void)dealloc
{
  if(GTK_IS_WIDGET(NATIVE_WIDGET))
    self.delegate = nil;
  else
    [_delegate release];

  [_connections release];
  [self destroy];
  [super dealloc]; 
}

//==================================================================================================================================
// Properties
//==================================================================================================================================
@synthesize native = _native;
//----------------------------------------------------------------------------------------------------------------------------------
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
    int eventFlags = gtk_widget_get_events(NATIVE_WIDGET);
    int original = eventFlags;

    if([_delegate respondsToSelector:@selector(gtkWidget:drawToSurface:)])
      [_connections addObject:[OFNumber numberWithUnsignedLong:
        g_signal_connect(_native, "draw", G_CALLBACK(ConnectionProxy_Draw),NULL)]];

    if([_delegate respondsToSelector:@selector(gtkWidget:dimensionsChanged:)])
      [_connections addObject:[OFNumber numberWithUnsignedLong:
        g_signal_connect(_native, "configure-event", G_CALLBACK(ConnectionProxy_Configure),NULL)]];

    if([_delegate respondsToSelector:@selector(gtkWidget:buttonPressed:clickCount:local:root:modifiers:)])
    {
      eventFlags |= GDK_BUTTON_PRESS_MASK;
      [_connections addObject:[OFNumber numberWithUnsignedLong:
        g_signal_connect(_native, "button-press-event", G_CALLBACK(ConnectionProxy_ButtonPress),NULL)]];
    }

    if([_delegate respondsToSelector:@selector(gtkWidget:buttonReleased:local:root:modifiers:)])
    {
      eventFlags |= GDK_BUTTON_RELEASE_MASK;
      [_connections addObject:[OFNumber numberWithUnsignedLong:
        g_signal_connect(_native, "button-release-event", G_CALLBACK(ConnectionProxy_ButtonRelease),NULL)]];
    }

    if([_delegate respondsToSelector:@selector(gtkWidget:pointerMovedAt:root:modifiers:)])
    {
      eventFlags |= GDK_POINTER_MOTION_MASK;
      [_connections addObject:[OFNumber numberWithUnsignedLong:
        g_signal_connect(_native, "motion-notify-event", G_CALLBACK(ConnectionProxy_PointerMotion),NULL)]];
    }

    if([_delegate respondsToSelector:@selector(gtkWidget:scrolled:by:at:root:modifiers:)])
    {
      eventFlags |= GDK_SCROLL_MASK;
      [_connections addObject:[OFNumber numberWithUnsignedLong:
        g_signal_connect(_native, "scroll-event", G_CALLBACK(ConnectionProxy_Scroll),NULL)]];
    }

    if([_delegate respondsToSelector:@selector(gtkWidget:keyPressed:raw:group:isModifier:modifiers:)])
    {
      eventFlags |= GDK_KEY_PRESS_MASK;
      [_connections addObject:[OFNumber numberWithUnsignedLong:
        g_signal_connect(_native, "key-press-event", G_CALLBACK(ConnectionProxy_KeyPress),NULL)]];
    }

    if([_delegate respondsToSelector:@selector(ggtkWidget:keyReleased:raw:group:isModifier:modifiers:)])
    {
      eventFlags |= GDK_KEY_RELEASE_MASK;
      [_connections addObject:[OFNumber numberWithUnsignedLong:
        g_signal_connect(_native, "key-release-event", G_CALLBACK(ConnectionProxy_KeyRelease),NULL)]];
    }

    if(eventFlags != original)
      gtk_widget_set_events(_native, eventFlags);
  }
}
//----------------------------------------------------------------------------------------------------------------------------------
-(OMSize)minimumSize
{
  int iWidth, iHeight;
  gtk_widget_get_size_request(NATIVE_WIDGET, &iWidth, &iHeight);
  return OMMakeSize((float)iWidth, (float)iHeight);
}
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-(void)setMinimumSize:(OMSize)minimumSize
{
  gtk_widget_set_size_request(NATIVE_WIDGET, (int)minimumSize.width, (int)minimumSize.height);
}
//----------------------------------------------------------------------------------------------------------------------------------
-(GtkAlign)horizontalAlign                          { return (GtkAlign)gtk_widget_get_halign(NATIVE_WIDGET);                  }
-(void)setHorizontalAlign:(GtkAlign)horizontalAlign { gtk_widget_set_halign(NATIVE_WIDGET, (Native_GtkAlign)horizontalAlign); }
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-(GtkAlign)verticalAlign                            { return (GtkAlign)gtk_widget_get_valign(NATIVE_WIDGET);                  }
-(void)setVerticalAlign:(GtkAlign)verticalAlign     { gtk_widget_set_valign(NATIVE_WIDGET, (Native_GtkAlign)verticalAlign);   }
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-(BOOL)horizontalExpand                             { return gtk_widget_get_hexpand(NATIVE_WIDGET);                           }
-(void)setHorizontalExpand:(BOOL)horizontalExpand   { gtk_widget_set_hexpand(NATIVE_WIDGET, horizontalExpand);                }
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-(BOOL)verticalExpand                               { return gtk_widget_get_vexpand(NATIVE_WIDGET);                           }
-(void)setVerticalExpand:(BOOL)verticalExpand       { gtk_widget_set_vexpand(NATIVE_WIDGET, verticalExpand);                  }
//----------------------------------------------------------------------------------------------------------------------------------
-(OFString *)tooltipText
{
  char *str = gtk_widget_get_tooltip_text(NATIVE_WIDGET); if(!str) return nil;
  return [OFString stringWithUTF8String:str];
}
-(void)setTooltipText:(OFString *)tooltipText
{
  if(!tooltipText) { gtk_widget_set_tooltip_text(NATIVE_WIDGET, NULL); return; }
  OFAutoreleasePool *pool = [[OFAutoreleasePool alloc] init];
  gtk_widget_set_tooltip_text(NATIVE_WIDGET, [tooltipText UTF8String]);
  [pool drain];
}
//----------------------------------------------------------------------------------------------------------------------------------
-(BOOL)canGrabFocus                           { return gtk_widget_get_can_focus(NATIVE_WIDGET);            }
-(void)setCanGrabFocus:(BOOL)canGrabFocus     { gtk_widget_set_can_focus(NATIVE_WIDGET, canGrabFocus);     }
//----------------------------------------------------------------------------------------------------------------------------------
-(BOOL)canGrabDefault                         { return gtk_widget_get_can_default(NATIVE_WIDGET);          }
-(void)setCanGrabDefault:(BOOL)canGrabDefault { gtk_widget_set_can_default(NATIVE_WIDGET, canGrabDefault); }

//==================================================================================================================================
// Utilities
//==================================================================================================================================
- (void) show         { gtk_widget_show         (NATIVE_WIDGET); }
- (void) showAll      { gtk_widget_show_all     (NATIVE_WIDGET); }
- (void) hide         { gtk_widget_hide         (NATIVE_WIDGET); }
- (void) activate     { gtk_widget_activate     (NATIVE_WIDGET); }
- (void) grabFocus    { gtk_widget_grab_focus   (NATIVE_WIDGET); }
- (void) grabDefault  { gtk_widget_grab_default (NATIVE_WIDGET); }
- (BOOL) isFocused    { return (gtk_widget_is_focus(NATIVE_WIDGET) == TRUE); }
//----------------------------------------------------------------------------------------------------------------------------------
- (OMSize) allocatedSize
{
  return OMMakeSize((float)gtk_widget_get_allocated_width(NATIVE_WIDGET), (float)gtk_widget_get_allocated_height(NATIVE_WIDGET));
}
//----------------------------------------------------------------------------------------------------------------------------------
- (void)overrideBackgroundColor:(OMColor)color forState:(GtkWidgetState)state
{
  GdkRGBA gdkColor;
  gdkColor.red   = (double)color.r;
  gdkColor.green = (double)color.g;
  gdkColor.blue  = (double)color.b;
  gdkColor.alpha = (double)color.a;
  gtk_widget_override_background_color(NATIVE_WIDGET, (Native_GtkStateFlags)state, &gdkColor);
}
- (void)resetBackgroundColorForState:(GtkWidgetState)state
{
  gtk_widget_override_background_color(NATIVE_WIDGET, (Native_GtkStateFlags)state, NULL);
}
//----------------------------------------------------------------------------------------------------------------------------------
- (void) queueDrawDimension:(OMDimension)dimension
{
  gtk_widget_queue_draw_area(NATIVE_WIDGET, (int)dimension.origin.x  , (int)dimension.origin.y,
                                            (int)dimension.size.width, (int)dimension.size.height);
}
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
- (void) queueDrawAll
{
  gtk_widget_queue_draw_area(NATIVE_WIDGET, 0, 0,
    gtk_widget_get_allocated_width(NATIVE_WIDGET), gtk_widget_get_allocated_height(NATIVE_WIDGET));
}
//----------------------------------------------------------------------------------------------------------------------------------
- (void) setProperty:(OFString *)property toValue:(void *)value
{
  OFAutoreleasePool *pool = [[OFAutoreleasePool alloc] init];
  g_object_set_data((gpointer)_native, [property UTF8String], (gpointer)value);
  [pool drain];
}
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
- (void *)getProperty:(OFString *)property
{
  if(!GTK_IS_WIDGET(_native)) return NULL;
  OFAutoreleasePool *pool = [[OFAutoreleasePool alloc] init];
  void *data = (void *)g_object_get_data((GObject *)_native, [property UTF8String]);
  [pool drain];
  return data;
}

//==================================================================================================================================
// (Default) Signal Handlers
//==================================================================================================================================
-(BOOL)onDrawToSurface:(OMSurface *)surface
{
  return [_delegate gtkWidget:self drawToSurface:surface];
}
//----------------------------------------------------------------------------------------------------------------------------------
-(BOOL)onDimensionsChanged:(OMDimension)dimension
{
  return [_delegate gtkWidget:self dimensionsChanged:dimension];
}
//----------------------------------------------------------------------------------------------------------------------------------
-(BOOL)onButtonPressed:(int)button clickCount:(int)clickCount local:(OMCoordinate)local root:(OMCoordinate)root modifiers:(GtkModifier)modifiers
{
  return [_delegate gtkWidget:self buttonPressed:button clickCount:clickCount local:local root:root modifiers:modifiers];
}
//----------------------------------------------------------------------------------------------------------------------------------
-(BOOL)onButtonReleased:(int)button local:(OMCoordinate)local root:(OMCoordinate)root modifiers:(GtkModifier)modifiers
{
  return [_delegate gtkWidget:self buttonReleased:button local:local root:root modifiers:modifiers];
}
//----------------------------------------------------------------------------------------------------------------------------------
-(BOOL)onPointerMovedAt:(OMCoordinate)local root:(OMCoordinate)root modifiers:(GtkModifier)modifiers
{
  return [_delegate gtkWidget:self pointerMovedAt:local root:root modifiers:modifiers];
}
//----------------------------------------------------------------------------------------------------------------------------------
-(BOOL)onScrolled:(GtkScrollDirection)direction by:(OMCoordinate)deltas at:(OMCoordinate)local root:(OMCoordinate)root modifiers:(GtkModifier)modifiers
{
  return [_delegate gtkWidget:self scrolled:direction by:deltas at:local root:root modifiers:modifiers];
}
//----------------------------------------------------------------------------------------------------------------------------------
-(BOOL)onKeyPressed:(unsigned int)keyCode raw:(uint16_t)rawCode group:(uint8_t)group isModifier:(BOOL)isModifier modifiers:(GtkModifier)modifiers
{
  return [_delegate gtkWidget:self keyPressed:keyCode raw:rawCode group:group isModifier:isModifier modifiers:modifiers];
}
//----------------------------------------------------------------------------------------------------------------------------------
-(BOOL)onKeyReleased:(unsigned int)keyCode raw:(uint16_t)rawCode group:(uint8_t)group isModifier:(BOOL)isModifier modifiers:(GtkModifier)modifiers
{
  return [_delegate gtkWidget:self keyPressed:keyCode raw:rawCode group:group isModifier:isModifier modifiers:modifiers];
}

//==================================================================================================================================
@end

//==================================================================================================================================
//----------------------------------------------------------------------------------------------------------------------------------
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
