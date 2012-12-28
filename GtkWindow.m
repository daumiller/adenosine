//==================================================================================================================================
// GtkWindow.m
/*==================================================================================================================================
Copyright © 2012 Dillon Aumiller <dillonaumiller@gmail.com>

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
#import "GtkWindow.h"
#import "GtkRuntime.h"

//==================================================================================================================================
#define NATIVE_WIDGET ((struct _GtkWidget *)_native)
#define NATIVE_WINDOW ((struct _GtkWindow *)_native)

//==================================================================================================================================
// Signal/Event -> Object Proxies
//==================================================================================================================================
static BOOL ConnectionProxy_ShouldClose(struct _GtkWindow *window, void *data)
{
  GtkWindow *obj = (GtkWindow *)[GtkWidget nativeToWrapper:(void *)window];
  return ![obj onShouldClose];
}
//----------------------------------------------------------------------------------------------------------------------------------
static void ConnectionProxy_DidClose(struct _GtkWindow *window, void *data)
{
  GtkWindow *obj = (GtkWindow *)[GtkWidget nativeToWrapper:(void *)window];
  [obj onDidClose];
}

//==================================================================================================================================
@implementation GtkWindow

//==================================================================================================================================
// Constructors/Destructor
//==================================================================================================================================
+ windowWithType:(GtkWindowType)type;
{
  return [[[self alloc] initWithType:type] autorelease];
}
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
- initWithType:(GtkWindowType)type
{
  self = [super init];
  if(self)
  {
    _native = (void *)gtk_window_new((Native_GtkWindowType)type);
    [self installNativeLookup];
    _connections = [[OFMutableArray alloc] init];
    g_signal_connect(_native, "destroy", G_CALLBACK(ConnectionProxy_DidClose),NULL);
  }
  return self;
}
//----------------------------------------------------------------------------------------------------------------------------------
-(void)dealloc
{
  if(GTK_IS_WIDGET(NATIVE_WIDGET))
  {
    self.delegate = nil;
    [_connections release];
  }
  else
    [_delegate release];
  [super dealloc];
}

//==================================================================================================================================
// Properties
//==================================================================================================================================
@synthesize quitOnClose = _quitOnClose;
//----------------------------------------------------------------------------------------------------------------------------------
-(id <GtkWindowDelegate>)delegate { return _delegate; }
-(void)setDelegate:(id <GtkWindowDelegate>)delegate
{
  if(_connections)
  {
    for(OFNumber *idNumber in _connections)
      g_signal_handler_disconnect(_native, [idNumber unsignedLongValue]);
    [_connections release];
  }
  _connections = [[OFMutableArray alloc] init];

  if(_delegate) [_delegate release];
  _delegate = [delegate retain];
  if(_delegate)
  {
    if([_delegate respondsToSelector:@selector(gtkWindowShouldClose:)])
      [_connections addObject:[OFNumber numberWithUnsignedLong:
        g_signal_connect(_native, "delete-event", G_CALLBACK(ConnectionProxy_ShouldClose),NULL)]];
  }
}
//----------------------------------------------------------------------------------------------------------------------------------
- (OFString *)title { return [OFString stringWithUTF8String:gtk_window_get_title(NATIVE_WINDOW)]; }
- (void)setTitle:(OFString *)title
{
  OFAutoreleasePool *pool = [[OFAutoreleasePool alloc] init];
  gtk_window_set_title(NATIVE_WINDOW, [title UTF8String]);
  [pool drain];
}
//----------------------------------------------------------------------------------------------------------------------------------
-(GtkWidget *)modalParent                      { return [GtkWidget nativeToWrapper:gtk_window_get_transient_for(NATIVE_WINDOW)]; }
-(void)setModalParent:(GtkWidget *)modalParent { gtk_window_set_transient_for(NATIVE_WINDOW, modalParent.native);                }
//----------------------------------------------------------------------------------------------------------------------------------
-(BOOL)isResizable                      { return gtk_window_get_resizable(NATIVE_WINDOW);       }
-(void)setIsResizable:(BOOL)isResizable { gtk_window_set_resizable(NATIVE_WINDOW, isResizable); }
//----------------------------------------------------------------------------------------------------------------------------------
-(BOOL)isModal                  { return gtk_window_get_modal(NATIVE_WINDOW);   }
-(void)setIsModal:(BOOL)isModal { gtk_window_set_modal(NATIVE_WINDOW, isModal); }
//----------------------------------------------------------------------------------------------------------------------------------
-(BOOL)isUrgent                   { return gtk_window_get_urgency_hint(NATIVE_WINDOW);    }
-(void)setIsUrgent:(BOOL)isUrgent { gtk_window_set_urgency_hint(NATIVE_WINDOW, isUrgent); }
//----------------------------------------------------------------------------------------------------------------------------------
-(BOOL)isDecorated                      { return gtk_window_get_decorated(NATIVE_WINDOW);       }
-(void)setIsDecorated:(BOOL)isDecorated { gtk_window_set_decorated(NATIVE_WINDOW, isDecorated); }
//----------------------------------------------------------------------------------------------------------------------------------
-(BOOL)showInTaskbar                        { return !gtk_window_get_skip_taskbar_hint(NATIVE_WINDOW);         }
-(void)setShowInTaskbar:(BOOL)showInTaskbar { gtk_window_set_skip_taskbar_hint(NATIVE_WINDOW, !showInTaskbar); }
//----------------------------------------------------------------------------------------------------------------------------------
-(BOOL)showInPager                      { return !gtk_window_get_skip_pager_hint(NATIVE_WINDOW);       }
-(void)setShowInPager:(BOOL)showInPager { gtk_window_set_skip_pager_hint(NATIVE_WINDOW, !showInPager); }
//----------------------------------------------------------------------------------------------------------------------------------
-(OMSize)size
{
  int width, height;
  gtk_window_get_size(NATIVE_WINDOW, &width, &height);
  return OMMakeSize((float)width, (float)height);
}
-(void)setSize:(OMSize)size
{
  gtk_window_resize(NATIVE_WINDOW, (int)size.width, (int)size.height);
}
//----------------------------------------------------------------------------------------------------------------------------------
-(OMCoordinate)position
{
  int x, y;
  gtk_window_get_position(NATIVE_WINDOW, &x, &y);
  return OMMakeCoordinate((float)x, (float)y);
}
-(void)setPosition:(OMCoordinate)position
{
  gtk_window_move(NATIVE_WINDOW, (int)position.x, (int)position.y);
}
//----------------------------------------------------------------------------------------------------------------------------------
-(GtkWindowState)state
{
  //TODO:
  return GTKWINDOWSTATE_NORMAL;
}
-(void)setState:(GtkWindowState)state
{
  //TODO:
}

//==================================================================================================================================
// Signal Handlers
//==================================================================================================================================
-(BOOL)onShouldClose
{
  return [_delegate gtkWindowShouldClose:self];
}
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-(void)onDidClose
{
  if([_delegate respondsToSelector:@selector(gtkWindowDidClose:)])
    [_delegate gtkWindowDidClose:self];
  if(_quitOnClose)
    [[GtkRuntime sharedRuntime] mainLoopQuit];
}

//==================================================================================================================================
@end

//==================================================================================================================================
//----------------------------------------------------------------------------------------------------------------------------------
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
