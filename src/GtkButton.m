//==================================================================================================================================
// GtkButton.m
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
#import <adenosine/GtkButton.h>
#import <adenosine/GtkLabel.h>

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
-(void)commonInit:(OFString *)text isAccel:(BOOL)isAccel isStock:(BOOL)isStock;
{
  OFAutoreleasePool *pool = [[OFAutoreleasePool alloc] init];
  if(text == nil)
    _native = (void *)gtk_button_new();
  else if(isStock)
    _native = (void *)gtk_button_new_from_stock([text UTF8String]);
  else if(!isAccel)
    _native = (void *)gtk_button_new_with_label([text UTF8String]);
  else
    _native = (void *)gtk_button_new_with_mnemonic([text UTF8String]);
  [pool drain];
  [self installNativeLookup];
}
//----------------------------------------------------------------------------------------------------------------------------------
+ button                              { return [[[self alloc] initButton           ] autorelease]; }
+ buttonWithText :(OFString *)text    { return [[[self alloc] initWithText:text    ] autorelease]; }
+ buttonWithAccel:(OFString *)text    { return [[[self alloc] initWithAccel:text   ] autorelease]; }
+ buttonFromStock:(OFString *)stockId { return [[[self alloc] initFromStock:stockId] autorelease]; }
//----------------------------------------------------------------------------------------------------------------------------------
- initButton
{
  self = [super init];
  if(self) [self commonInit:nil isAccel:NO isStock:NO];
  return self;
}
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
- initWithText:(OFString *)text
{
  self = [super init];
  if(self) [self commonInit:text isAccel:NO isStock:NO];
  return self;
}
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
- initWithAccel:(OFString *)text
{
  self = [super init];
  if(self) [self commonInit:text isAccel:YES isStock:NO];
  return self;
}
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
- initFromStock:(OFString *)stockId
{
  self = [super init];
  if(self) [self commonInit:stockId isAccel:NO isStock:YES];
  return self;
}

//==================================================================================================================================
// Properites
//==================================================================================================================================
-(void)setDelegate:(id)delegate
{
  [super setDelegate:delegate];
  
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
-(BOOL)textIsStockId                               { return gtk_button_get_use_stock(NATIVE_BUTTON);                               }
-(void)setTextIsStockId:(BOOL)textIsStockId        { gtk_button_set_use_stock(NATIVE_BUTTON, textIsStockId);                       }
//----------------------------------------------------------------------------------------------------------------------------------
-(BOOL)textIsAccel                                { return gtk_button_get_use_underline(NATIVE_BUTTON);                            }
-(void)setTextIsAccel:(BOOL)textIsAccel            { gtk_button_set_use_underline(NATIVE_BUTTON, textIsAccel);                     }
//----------------------------------------------------------------------------------------------------------------------------------
-(BOOL)focusOnClick                                { return gtk_button_get_focus_on_click(NATIVE_BUTTON);                          }
-(void)setFocusOnClick:(BOOL)focusOnClick          { gtk_button_set_focus_on_click(NATIVE_BUTTON, focusOnClick);                   }
//----------------------------------------------------------------------------------------------------------------------------------
-(GtkPosition)imagePosition                        { return (GtkPosition)gtk_button_get_image_position(NATIVE_BUTTON);             }
-(void)setImagePosition:(GtkPosition)imagePosition { gtk_button_set_image_position(NATIVE_BUTTON, (GtkPositionType)imagePosition); }
//----------------------------------------------------------------------------------------------------------------------------------
//GTK+ >= 3.6
//-(BOOL)alwaysShowImage                             { return gtk_button_get_always_show_image(NATIVE_BUTTON);                       }
//-(void)setAlwaysShowImage:(BOOL)alwaysShowImage    { gtk_button_set_always_show_image(NATIVE_BUTTON, alwaysShowImage);             }

//==================================================================================================================================
// Utilities
//==================================================================================================================================
-(void) setImageWidget:(GtkWidget *)imageWidget
{
  gtk_button_set_image(NATIVE_BUTTON, (struct _GtkWidget *)(imageWidget.native));
}

//==================================================================================================================================
// Signal Handlers
//==================================================================================================================================
-(void)onClicked
{
  [_delegate gtkButtonClicked:self];
}

//==================================================================================================================================
@end

//==================================================================================================================================
//----------------------------------------------------------------------------------------------------------------------------------
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
