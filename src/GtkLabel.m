//==================================================================================================================================
// GtkLabel.m
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
#import <adenosine/GtkLabel.h>

//==================================================================================================================================
#define NATIVE_WIDGET ((struct _GtkWidget *)_native)
#define NATIVE_LABEL  ((struct _GtkLabel  *)_native)

//==================================================================================================================================
// Signal/Event -> Object Proxies
//==================================================================================================================================
static BOOL ConnectionProxy_LinkActivated(struct _GtkLabel *label, char *uri, void *data)
{
  GtkLabel *obj = (GtkLabel *)[GtkWidget nativeToWrapper:(void *)label];
  return [obj onLinkActivated:uri];
}
//----------------------------------------------------------------------------------------------------------------------------------
static void ConnectionProxy_PopulateContext(struct _GtkLabel *label, struct _GtkMenu *menu, void *data)
{
  GtkLabel *obj = (GtkLabel *)[GtkWidget nativeToWrapper:(void *)label];
  [obj onPopulateContextMenu:menu];
}

//==================================================================================================================================
@implementation GtkLabel

//==================================================================================================================================
// Constructors/Destructor
//==================================================================================================================================
-(void)commonInit:(OFString *)string isMarkup:(BOOL)isMarkup
{
  _native = (void *)gtk_label_new(NULL);
  [self installNativeLookup];
  if(string != nil)
  {
    if(isMarkup)
      self.markup = string;
    else
      self.text = string;
  }
}
//----------------------------------------------------------------------------------------------------------------------------------
+ label                              { return [[[self alloc] initLabel            ] autorelease]; }
+ labelWithText  :(OFString *)text   { return [[[self alloc] initWithText:text    ] autorelease]; }
+ labelWithMarkup:(OFString *)markup { return [[[self alloc] initWithMarkup:markup] autorelease]; }
//----------------------------------------------------------------------------------------------------------------------------------
- initLabel
{
  self = [super init];
  if(self) [self commonInit:nil isMarkup:NO];
  return self;
}
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
- initWithText:(OFString *)text
{
  self = [super init];
  if(self) [self commonInit:text isMarkup:NO];
  return self;
}
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
- initWithMarkup:(OFString *)markup
{
  self = [super init];
  if(self) [self commonInit:markup isMarkup:YES];
  return self;
}

//==================================================================================================================================
// Properties
//==================================================================================================================================
-(void)setDelegate:(id)delegate
{
  [super setDelegate:delegate];

  if(_delegate)
  {
    if([_delegate respondsToSelector:@selector(gtkLabel:populateContextMenu:)])
      [_connections addObject:[OFNumber numberWithUnsignedLong:
        g_signal_connect(_native, "activate-link", G_CALLBACK(ConnectionProxy_LinkActivated),NULL)]];
    if([_delegate respondsToSelector:@selector(gtkLabel:linkActivated:)])
      [_connections addObject:[OFNumber numberWithUnsignedLong:
        g_signal_connect(_native, "populate-popup", G_CALLBACK(ConnectionProxy_PopulateContext), NULL)]];
  }
}
//----------------------------------------------------------------------------------------------------------------------------------
- (OFString *)text { return [OFString stringWithUTF8String:gtk_label_get_text(NATIVE_LABEL)]; }
- (void)setText:(OFString *)text
{
  OFAutoreleasePool *pool = [[OFAutoreleasePool alloc] init];
  gtk_label_set_text(NATIVE_LABEL, [text UTF8String]);
  [pool drain];
}
//----------------------------------------------------------------------------------------------------------------------------------
-(int)maxCharLength                               { return gtk_label_get_max_width_chars(NATIVE_LABEL);                  }
-(void)setMaxCharLength:(int)maxCharLength        { gtk_label_set_max_width_chars(NATIVE_LABEL, maxCharLength);          }
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-(BOOL)useMarkup                                  { return gtk_label_get_use_markup(NATIVE_LABEL);                       }
-(void)setUseMarkup:(BOOL)useMarkup               { gtk_label_set_use_markup(NATIVE_LABEL, useMarkup);                   }
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-(BOOL)useEllipsis                                { return (gtk_label_get_ellipsize(NATIVE_LABEL) != 0);                 }
-(void)setUseEllipsis:(BOOL)useEllipsis           { gtk_label_set_ellipsize(NATIVE_LABEL, useEllipsis ? 3 : 0);          }
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-(BOOL)useWrapping                                { return gtk_label_get_line_wrap(NATIVE_LABEL);                        }
-(void)setUseWrapping:(BOOL)useWrapping           { gtk_label_set_line_wrap(NATIVE_LABEL, useWrapping);                  }
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-(BOOL)isSelectable                               { return gtk_label_get_selectable(NATIVE_LABEL);                       }
-(void)setIsSelectable:(BOOL)isSelectable         { gtk_label_set_selectable(NATIVE_LABEL, isSelectable);                }
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-(BOOL)markVisitedLinks                           { return gtk_label_get_track_visited_links(NATIVE_LABEL);              }
-(void)setMarkVisitedLinks:(BOOL)markVisitedLinks { gtk_label_set_track_visited_links(NATIVE_LABEL, markVisitedLinks);   }
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-(float)angle                                     { return (float)gtk_label_get_angle(NATIVE_LABEL);                     }
-(void)setAngle:(float)angle                      { gtk_label_set_angle(NATIVE_LABEL, (double)angle);                    }
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-(GtkTextAlign)textAlign                          { return (GtkTextAlign)gtk_label_get_justify(NATIVE_LABEL);            }
-(void)setTextAlign:(GtkTextAlign)textAlign       { gtk_label_set_justify(NATIVE_LABEL, (GtkJustification)textAlign); }
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-(GtkWidget *)accelWidget                         { return [GtkWidget nativeToWrapper:gtk_label_get_mnemonic_widget(NATIVE_LABEL)]; }
-(void)setAccelWidget:(GtkWidget *)accelWidget    { gtk_label_set_mnemonic_widget(NATIVE_LABEL, accelWidget.native);     }

//==================================================================================================================================
// Utilities
//==================================================================================================================================
-(void)setMarkup:(OFString *)markup
{
  OFAutoreleasePool *pool = [[OFAutoreleasePool alloc] init];
  gtk_label_set_markup(NATIVE_LABEL, [markup UTF8String]);
  [pool drain];
}
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-(void)setMarkupWithAccel:(OFString *)markup
{
  OFAutoreleasePool *pool = [[OFAutoreleasePool alloc] init];
  gtk_label_set_markup_with_mnemonic(NATIVE_LABEL, [markup UTF8String]);
  [pool drain];
}

//==================================================================================================================================
// Signal Handlers
//==================================================================================================================================
-(BOOL)onLinkActivated:(char *)uri
{
  //return TRUE if link was activated
  OFAutoreleasePool *pool = [[OFAutoreleasePool alloc] init];
  OFString *link = [OFString stringWithUTF8String:uri];
  BOOL result = [_delegate gtkLabel:self linkActivated:link];
  [pool drain];
  return result;
}
//----------------------------------------------------------------------------------------------------------------------------------
-(void)onPopulateContextMenu:(void *)nativeMenu
{
  [_delegate gtkLabel:self populateContextMenu:(void *)nativeMenu];
}

@end
//==================================================================================================================================
//----------------------------------------------------------------------------------------------------------------------------------
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
