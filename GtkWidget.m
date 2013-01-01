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
#import "adenosine.h"

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
  return [obj onButtonPressed:event->button local:local root:root modifiers:(GtkModifier)event->state];
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
  if(native_is_gtk_type_named(native, "GtkWindow"     )) return [[[GtkWindow      alloc] initWithExistingNative:native] autorelease];
  if(native_is_gtk_type_named(native, "GtkDrawingArea")) return [[[GtkDrawingArea alloc] initWithExistingNative:native] autorelease];
  if(native_is_gtk_type_named(native, "GtkButton"     )) return [[[GtkButton      alloc] initWithExistingNative:native] autorelease];
  if(native_is_gtk_type_named(native, "GtkLabel"      )) return [[[GtkLabel       alloc] initWithExistingNative:native] autorelease];
  if(native_is_gtk_type_named(native, "GtkImage"      )) return [[[GtkImage       alloc] initWithExistingNative:native] autorelease];
  if(native_is_gtk_type_named(native, "GtkProgressBar")) return [[[GtkProgressBar alloc] initWithExistingNative:native] autorelease];
  if(native_is_gtk_type_named(native, "GtkBox"        )) return [[[GtkBox         alloc] initWithExistingNative:native] autorelease];
  if(native_is_gtk_type_named(native, "GtkFrame"      )) return [[[GtkFrame       alloc] initWithExistingNative:native] autorelease];
  if(native_is_gtk_type_named(native, "GtkGrid"       )) return [[[GtkGrid        alloc] initWithExistingNative:native] autorelease];

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

    if([_delegate respondsToSelector:@selector(gtkWidget:buttonPressed:local:root:modifiers:)])
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

    if(eventFlags != original)
      gtk_widget_set_events(_native, eventFlags);
  }
}

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
-(BOOL)onButtonPressed:(int)button local:(OMCoordinate)local root:(OMCoordinate)root modifiers:(GtkModifier)modifiers
{
  return [_delegate gtkWidget:self buttonPressed:button local:local root:root modifiers:modifiers];
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

//==================================================================================================================================
@end

//==================================================================================================================================
//----------------------------------------------------------------------------------------------------------------------------------
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
