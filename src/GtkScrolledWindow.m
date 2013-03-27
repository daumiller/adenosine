//==================================================================================================================================
// GtkScrolledWindow.m
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
#import "GtkNative.h"
#import <adenosine/adenosine.h>

//==================================================================================================================================
#define NATIVE_WIDGET   ((struct _GtkWidget         *)_native)
#define NATIVE_SCROLLED ((struct _GtkScrolledWindow *)_native)

//==================================================================================================================================
// Signal/Event -> Object Proxies
//==================================================================================================================================
static BOOL ConnectionProxy_Scroll(struct _GtkWidget *widget, GdkEventScroll *event, void *data)
{
  GtkScrolledWindow *obj = (GtkScrolledWindow *)[GtkWidget nativeToWrapper:(void *)widget];
  //create friendly variables
  OMCoordinate local = OMMakeCoordinate((float)event->x, (float)event->y);
  OMCoordinate root  = OMMakeCoordinate((float)event->x_root, (float)event->y_root);
  double dX, dY; gdk_event_get_scroll_deltas((GdkEvent *)event, &dX, &dY); OMCoordinate deltas = OMMakeCoordinate((float)dX, (float)dY);
  GtkScrollDirection direction = (GtkScrollDirection)event->direction;
  GtkModifier modifiers = (GtkModifier)event->state;
  //call our instance
  BOOL retval = [obj onScrollModifier:&direction by:&deltas at:&local root:&root modifiers:&modifiers];
  //write (modified) values back to event
  event->state     = (guint)modifiers;
  event->x_root    = (gdouble)root.x;
  event->y_root    = (gdouble)root.y;
  event->x         = (gdouble)local.x;
  event->y         = (gdouble)local.y;
  event->delta_x   = (gdouble)deltas.x;
  event->delta_y   = (gdouble)deltas.y;
  event->direction = (GdkScrollDirection)direction;
  return retval;
}

//==================================================================================================================================
@implementation GtkScrolledWindow

//==================================================================================================================================
// Wrapper (overrides)
//==================================================================================================================================
-(void)destroy
{
  [_horizontalAdjustment release];
  [_verticalAdjustment release];
  [super destroy];
}

//==================================================================================================================================
// Constructors/Destructor
//==================================================================================================================================
+ scrolledWindow { return [[[self alloc] initScrolledWindow] autorelease]; }
- initScrolledWindow
{
  self = [super init];
  if(self)
  {
    _native = gtk_scrolled_window_new(NULL,NULL);
    [self installNativeLookup];
    _scrollScaleX   = 1.0f;
    _scrollScaleY   = 1.0f;
    _scrollScaled   = NO;
    _scaleScrollingConnectionId = 0;
    int eventFlags = gtk_widget_get_events(NATIVE_WIDGET) | GDK_SCROLL_MASK;
    gtk_widget_set_events(_native, eventFlags);
  }
  return self;
}

//==================================================================================================================================
// Properites
//==================================================================================================================================
-(GtkAdjustment *)horizontalAdjustment
{
  if(_horizontalAdjustment) return _horizontalAdjustment;
  GtkAdjustment *adj = [GtkAdjustment wrapExistingNative:gtk_scrolled_window_get_hadjustment(NATIVE_SCROLLED)];
  _horizontalAdjustment = [adj retain];
  return _horizontalAdjustment;
}
-(GtkAdjustment *)verticalAdjustment
{
  if(_verticalAdjustment) return _verticalAdjustment;
  GtkAdjustment *adj = [GtkAdjustment wrapExistingNative:gtk_scrolled_window_get_vadjustment(NATIVE_SCROLLED)];
  _verticalAdjustment = [adj retain];
  return _verticalAdjustment;
}
//----------------------------------------------------------------------------------------------------------------------------------
@synthesize scrollScaleX = _scrollScaleX;
@synthesize scrollScaleY = _scrollScaleY;
//----------------------------------------------------------------------------------------------------------------------------------
-(BOOL)scrollScaled { return _scrollScaled; }
-(void)setScrollScaled:(BOOL)scrollScaled
{
  if(scrollScaled == _scrollScaled) return;
  _scrollScaled = scrollScaled;
  if(scrollScaled)
    _scaleScrollingConnectionId = g_signal_connect(_native, "scroll-event", G_CALLBACK(ConnectionProxy_Scroll),NULL);
  else
    g_signal_handler_disconnect(_native, _scaleScrollingConnectionId);
}
//----------------------------------------------------------------------------------------------------------------------------------
-(GtkBorderShadow)shadow                 { return (GtkBorderShadow)gtk_scrolled_window_get_shadow_type(NATIVE_SCROLLED); }
-(void)setShadow:(GtkBorderShadow)shadow { gtk_scrolled_window_set_shadow_type(NATIVE_SCROLLED, (GtkShadowType)shadow);  }
//----------------------------------------------------------------------------------------------------------------------------------
-(GtkCorner)placement                    { return (GtkCorner)gtk_scrolled_window_get_placement(NATIVE_SCROLLED);         }
-(void)setPlacement:(GtkCorner)placement
{
  if(placement == GTKCORNER_UNSET)
    gtk_scrolled_window_unset_placement(NATIVE_SCROLLED);
  else
    gtk_scrolled_window_set_placement(NATIVE_SCROLLED, (GtkCornerType)placement);
}
//----------------------------------------------------------------------------------------------------------------------------------
-(GtkScrollbarShow)horizontalPolicy
{
  GtkPolicyType horz;
  gtk_scrolled_window_get_policy(NATIVE_SCROLLED, &horz, NULL);
  return (GtkScrollbarShow)horz;
}
-(void)setHorizontalPolicy:(GtkScrollbarShow)horizontalPolicy
{
  gtk_scrolled_window_set_policy(NATIVE_SCROLLED, (GtkPolicyType)horizontalPolicy, (GtkPolicyType)self.verticalPolicy);
}
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-(GtkScrollbarShow)verticalPolicy
{
  GtkPolicyType vert;
  gtk_scrolled_window_get_policy(NATIVE_SCROLLED, NULL, &vert);
  return (GtkScrollbarShow)vert;
}
-(void)setVerticalPolicy:(GtkScrollbarShow)verticalPolicy
{
  gtk_scrolled_window_set_policy(NATIVE_SCROLLED, (GtkPolicyType)self.horizontalPolicy, (GtkPolicyType)verticalPolicy);
}
//----------------------------------------------------------------------------------------------------------------------------------
-(OMSize)minimumContentSize
{
  return OMMakeSize((float)gtk_scrolled_window_get_min_content_width (NATIVE_SCROLLED),
                    (float)gtk_scrolled_window_get_min_content_height(NATIVE_SCROLLED));
}
-(void)setMinimumContentSize:(OMSize)minimumContentSize
{
  gtk_scrolled_window_set_min_content_width (NATIVE_SCROLLED, (int)minimumContentSize.width );
  gtk_scrolled_window_set_min_content_height(NATIVE_SCROLLED, (int)minimumContentSize.height);
}

//==================================================================================================================================
// Utilities
//==================================================================================================================================
-(void)addWithViewport:(GtkWidget *)child
{
  gtk_scrolled_window_add_with_viewport(NATIVE_SCROLLED, (struct _GtkWidget *)child.native);
}

//==================================================================================================================================
// (Default) Signal Handlers
//==================================================================================================================================
-(BOOL)onScrollModifier:(GtkScrollDirection *)direction by:(OMCoordinate *)deltas at:(OMCoordinate *)local root:(OMCoordinate *)root modifiers:(GtkModifier *)modifiers
{
  if(_scrollScaleX < 0.0f)
  {
    if(*direction == GTKSCROLL_DIRECTION_LEFT)
    {
      deltas->x *= -1.0f;
      *direction = GTKSCROLL_DIRECTION_RIGHT;
    }
    else if(*direction == GTKSCROLL_DIRECTION_RIGHT)
    {
      deltas->x *= -1.0f;
      *direction = GTKSCROLL_DIRECTION_LEFT;
    }
  }

  if(_scrollScaleY < 0.0f)
  {
    if(*direction == GTKSCROLL_DIRECTION_UP)
    {
      deltas->y *= -1.0f;
      *direction = GTKSCROLL_DIRECTION_DOWN;
    }
    else if(*direction == GTKSCROLL_DIRECTION_DOWN)
    {
      deltas->y *= -1.0f;
      *direction = GTKSCROLL_DIRECTION_UP;
    }
  }

  deltas->x *= _scrollScaleX;
  deltas->y *= _scrollScaleY;
  return NO; //don't stop processing / do continue procesing
}

@end
//==================================================================================================================================
//----------------------------------------------------------------------------------------------------------------------------------
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
