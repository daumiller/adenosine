//==================================================================================================================================
// GtkButton.m
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
#import "GtkButton.h"
#import "GtkLabel.h"

//==================================================================================================================================
#define NATIVE_WIDGET ((struct _GtkWidget *)_native)
#define NATIVE_BUTTON ((struct _GtkButton *)_native)

//==================================================================================================================================
// Signal/Event -> Object Proxies
//==================================================================================================================================
static void ConnectionProxy_Clicked(struct _GtkButton *button, void *data)
{
  GtkButton *obj = (GtkButton *)[GtkWidget nativeToWrapper:(void *)button];
  [obj onClicked];
}

//==================================================================================================================================
@implementation GtkButton

//==================================================================================================================================
// Constructors/Destructor
//==================================================================================================================================
-(void)commonInit:(OFString *)text isAccel:(BOOL)isAccel
{
  OFAutoreleasePool *pool = [[OFAutoreleasePool alloc] init];
  if(text == nil)
    _native = (void *)gtk_button_new();
  else if(!isAccel)
    _native = (void *)gtk_button_new_with_label([text UTF8String]);
  else
    _native = (void *)gtk_button_new_with_mnemonic([text UTF8String]);
  [pool drain];
  [self installNativeLookup];
  _connections = [[OFMutableArray alloc] init];
}
//----------------------------------------------------------------------------------------------------------------------------------
+ button                           { return [[[self alloc] init              ] autorelease]; }
+ buttonWithText :(OFString *)text { return [[[self alloc] initWithText:text ] autorelease]; }
+ buttonWithAccel:(OFString *)text { return [[[self alloc] initWithAccel:text] autorelease]; }
//----------------------------------------------------------------------------------------------------------------------------------
- init
{
  self = [super init];
  if(self) [self commonInit:nil isAccel:NO];
  return self;
}
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
- initWithText:(OFString *)text
{
  self = [super init];
  if(self) [self commonInit:text isAccel:NO];
  return self;
}
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
- initWithAccel:(OFString *)text
{
  self = [super init];
  if(self) [self commonInit:text isAccel:YES];
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
// Properites
//==================================================================================================================================
-(id <GtkButtonDelegate>)delegate { return _delegate; }
-(void)setDelegate:(id <GtkButtonDelegate>)delegate
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
    if([_delegate respondsToSelector:@selector(gtkButtonClicked:)])
      [_connections addObject:[OFNumber numberWithUnsignedLong:
        g_signal_connect(_native, "clicked", G_CALLBACK(ConnectionProxy_Clicked),NULL)]];
  }
}
//----------------------------------------------------------------------------------------------------------------------------------
- (OFString *)text { return [OFString stringWithUTF8String:gtk_button_get_label(NATIVE_BUTTON)]; }
- (void)setText:(OFString *)text
{
  OFAutoreleasePool *pool = [[OFAutoreleasePool alloc] init];
  gtk_button_set_label(NATIVE_BUTTON, [text UTF8String]);
  [pool drain];
}
//----------------------------------------------------------------------------------------------------------------------------------
-(BOOL)focusOnClick                       { return gtk_button_get_focus_on_click(NATIVE_BUTTON);        }
-(void)setFocusOnClick:(BOOL)focusOnClick { gtk_button_set_focus_on_click(NATIVE_BUTTON, focusOnClick); }

//==================================================================================================================================
// Signal Handlers
//==================================================================================================================================
-(void)onClicked
{
  [_delegate gtkButtonClicked:self];
}

@end
//==================================================================================================================================
//----------------------------------------------------------------------------------------------------------------------------------
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
