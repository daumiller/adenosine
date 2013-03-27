//==================================================================================================================================
// GtkEntry.m
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
#import <atropine/atropine.h>

//==================================================================================================================================
#define NATIVE_WIDGET ((struct _GtkWidget *)_native)
#define NATIVE_ENTRY  ((struct _GtkEntry  *)_native)

//==================================================================================================================================
// Signal/Event -> Object Proxies
//==================================================================================================================================
static void ConnectionProxy_TextChanged(struct _GtkEntry *entry, void *pspec, void *data)
{
  g_object_freeze_notify((GObject *)entry);
  GtkEntry *obj = (GtkEntry *)[GtkWidget nativeToWrapper:(void *)entry];
  [obj onTextChanged];
  g_object_thaw_notify((GObject *)entry);
}
static void ConnectionProxy_IconPressed(struct _GtkEntry *entry, GtkEntryIconPosition icon, GdkEventButton *event, void *data)
{
  GtkEntry *obj = (GtkEntry *)[GtkWidget nativeToWrapper:(void *)entry];
  [obj onIconPressed:(GtkEntryIcon)icon withButton:(int)event->button];
}
static void ConnectionProxy_IconReleased(struct _GtkEntry *entry, GtkEntryIconPosition icon, GdkEventButton *event, void *data)
{
  GtkEntry *obj = (GtkEntry *)[GtkWidget nativeToWrapper:(void *)entry];
  [obj onIconReleased:(GtkEntryIcon)icon withButton:(int)event->button];
}
static void ConnectionProxy_PopulatePopup(struct _GtkEntry *entry, struct _GtkMenu *menu, void *data)
{
  //be mindful of the lifetime of this autoreleased menu...
  //TODO: to be useful, i believe you would need a signal handler for any menu item activation (even those we didn't add),
  //that could be used to accurately control the lifetime of the wrapped Menu
  GtkEntry *obj  = (GtkEntry *)[GtkWidget nativeToWrapper:(void *)entry];
  GtkMenu  *oMnu = (GtkMenu  *)[GtkWidget nativeToWrapper:(void *)menu]; // <-- don't believe this would ever actually be valid
  if(!oMnu) oMnu = (GtkMenu *)[GtkWidget wrapExistingNative:menu];        // <-- this should always be the case
  [obj onPopulatePopup:oMnu];
}

//==================================================================================================================================
@implementation GtkEntry

//==================================================================================================================================
// Constructors/Destructor
//==================================================================================================================================
+ entry                                    { return [[[self alloc] initEntry            ] autorelease]; }
+ entryWithBuffer:(GtkEntryBuffer *)buffer { return [[[self alloc] initWithBuffer:buffer] autorelease]; }
//----------------------------------------------------------------------------------------------------------------------------------
- initEntry
{
  self = [super init];
  if(self)
  {
    _native = gtk_entry_new();
    [self installNativeLookup];
  }
  return self;
}
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
- initWithBuffer:(GtkEntryBuffer *)buffer
{
  if(!buffer) return [self initEntry];
  self = [super init];
  if(self)
  {
    _native = gtk_entry_new_with_buffer(buffer.native);
    [self installNativeLookup];
    _buffer = [buffer retain];
  }
  return self;
}

//==================================================================================================================================
// Properites
//==================================================================================================================================
-(GtkEntryBuffer *)buffer
{
  if(_buffer) return _buffer;
  void *nativeBuffer = gtk_entry_get_buffer(NATIVE_ENTRY);
  if(!nativeBuffer) return nil;
  _buffer = [[GtkEntryBuffer alloc] initWithExistingNative:nativeBuffer];
  return _buffer;
}
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-(void)setBuffer:(GtkEntryBuffer *)buffer
{
  if(buffer == _buffer) return;
  [_buffer release];
  _buffer = [buffer retain];
}
//----------------------------------------------------------------------------------------------------------------------------------
-(OFString *)text { return [OFString stringWithUTF8String:gtk_entry_get_text(NATIVE_ENTRY)]; }
-(void)setText:(OFString *)text
{
  OFAutoreleasePool *pool = [[OFAutoreleasePool alloc] init];
  gtk_entry_set_text(NATIVE_ENTRY, [text UTF8String]);
  [pool drain];
}
//----------------------------------------------------------------------------------------------------------------------------------
-(OFString *)placeholder { return [OFString stringWithUTF8String:gtk_entry_get_placeholder_text(NATIVE_ENTRY)]; }
-(void)setPlaceholder:(OFString *)placeholder
{
  OFAutoreleasePool *pool = [[OFAutoreleasePool alloc] init];
  gtk_entry_set_placeholder_text(NATIVE_ENTRY, [placeholder UTF8String]);
  [pool drain];
}
//----------------------------------------------------------------------------------------------------------------------------------
-(int)textLength                                        { return gtk_entry_get_text_length(NATIVE_ENTRY);                          }
//----------------------------------------------------------------------------------------------------------------------------------
-(int)maxLength                                         { return gtk_entry_get_max_length(NATIVE_ENTRY);                           }
-(void)setMaxLength:(int)maxLength                      { gtk_entry_set_max_length(NATIVE_ENTRY, maxLength);                       }
//----------------------------------------------------------------------------------------------------------------------------------
-(float)textAlign                                       { return gtk_entry_get_alignment(NATIVE_ENTRY);                            }
-(void)setTextAlign:(float)textAlign                    { gtk_entry_set_alignment(NATIVE_ENTRY, textAlign);                        }
//----------------------------------------------------------------------------------------------------------------------------------
-(int)charWidth                                         { return gtk_entry_get_width_chars(NATIVE_ENTRY);                          }
-(void)setCharWidth:(int)charWidth                      { gtk_entry_set_width_chars(NATIVE_ENTRY, charWidth);                      }
//----------------------------------------------------------------------------------------------------------------------------------
-(BOOL)isPrivate                                        { return gtk_entry_get_visibility(NATIVE_ENTRY);                           }
-(void)setIsPrivate:(BOOL)isPrivate                     { gtk_entry_set_visibility(NATIVE_ENTRY, isPrivate);                       }
//----------------------------------------------------------------------------------------------------------------------------------
-(uint32_t)privateChar                                  { return gtk_entry_get_invisible_char(NATIVE_ENTRY);                       }
-(void)setPrivateChar:(uint32_t)privateChar             { gtk_entry_set_invisible_char(NATIVE_ENTRY, privateChar);                 }
//----------------------------------------------------------------------------------------------------------------------------------
-(BOOL)activatesDefault                                 { return gtk_entry_get_activates_default(NATIVE_ENTRY);                    }
-(void)setActivatesDefault:(BOOL)activatesDefault       { gtk_entry_set_activates_default(NATIVE_ENTRY, activatesDefault);         }
//----------------------------------------------------------------------------------------------------------------------------------
-(BOOL)hasFrame                                         { return gtk_entry_get_has_frame(NATIVE_ENTRY);                            }
-(void)setHasFrame:(BOOL)hasFrame                       { gtk_entry_set_has_frame(NATIVE_ENTRY, hasFrame);                         }
//----------------------------------------------------------------------------------------------------------------------------------
//Requires GTK+ v3.6+ :
//-(GtkTextInput)textInput                                { return (GtkTextInput)gtk_entry_get_input_purpose(NATIVE_ENTRY);          }
//-(void)setTextInput:(GtkTextInput)textInput             { gtk_entry_set_input_purpose(NATIVE_ENTRY, (GtkInputPurpose)textInput);   }
//----------------------------------------------------------------------------------------------------------------------------------
//-(GtkTextInputHint)textInputHint                        { return (GtkTextInputHint)gtk_entry_get_input_hints(NATIVE_ENTRY);        }
//-(void)setTextInputHint:(GtkTextInputHint)textInputHint { gtk_entry_set_input_hints(NATIVE_ENTRY, (GtkInputHints)textInputHint);   }
//----------------------------------------------------------------------------------------------------------------------------------
-(BOOL)overwriteMode                                    { return gtk_entry_get_overwrite_mode(NATIVE_ENTRY);                       }
-(void)setOverwriteMode:(BOOL)overwriteMode             { gtk_entry_set_overwrite_mode(NATIVE_ENTRY, overwriteMode);               }
//----------------------------------------------------------------------------------------------------------------------------------
-(float)progressValue                                   { return (float)gtk_entry_get_progress_fraction(NATIVE_ENTRY);             }
-(void)setProgressValue:(float)progressValue            { gtk_entry_set_progress_fraction(NATIVE_ENTRY, (double)progressValue);    }
//----------------------------------------------------------------------------------------------------------------------------------
-(float)progressPulseDelta                              { return (float)gtk_entry_get_progress_pulse_step(NATIVE_ENTRY);           }
-(void)setProgressPulseDelta:(float)progressPulseDelta  { gtk_entry_set_progress_pulse_step(NATIVE_ENTRY, (float)progressPulseDelta); }
//----------------------------------------------------------------------------------------------------------------------------------
-(BOOL)iconPrimaryActivatable { return gtk_entry_get_icon_activatable(NATIVE_ENTRY, (GtkEntryIconPosition)GTKENTRY_ICON_PRIMARY); }
-(void)setIconPrimaryActivatable:(BOOL)iconPrimaryActivatable
{
  gtk_entry_set_icon_activatable(NATIVE_ENTRY, (GtkEntryIconPosition)GTKENTRY_ICON_PRIMARY, iconPrimaryActivatable);
}
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-(BOOL)iconPrimarySensitive   { return gtk_entry_get_icon_sensitive  (NATIVE_ENTRY, (GtkEntryIconPosition)GTKENTRY_ICON_PRIMARY); }
-(void)setIconPrimarySensitive:(BOOL)iconPrimarySensitive
{
  gtk_entry_set_icon_sensitive(NATIVE_ENTRY, (GtkEntryIconPosition)GTKENTRY_ICON_PRIMARY, iconPrimarySensitive);
}
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-(OFString *)iconPrimaryTooltipText
{
  return [OFString stringWithUTF8String:gtk_entry_get_icon_tooltip_text(NATIVE_ENTRY, (GtkEntryIconPosition)GTKENTRY_ICON_PRIMARY)];
}
-(void)setIconPrimaryTooltipText:(OFString *)iconPrimaryTooltipText
{
  OFAutoreleasePool *pool = [[OFAutoreleasePool alloc] init];
  gtk_entry_set_icon_tooltip_text(NATIVE_ENTRY, (GtkEntryIconPosition)GTKENTRY_ICON_PRIMARY, [iconPrimaryTooltipText UTF8String]);
  [pool drain];
}
//----------------------------------------------------------------------------------------------------------------------------------
-(BOOL)iconSecondaryActivatable { return gtk_entry_get_icon_activatable(NATIVE_ENTRY, (GtkEntryIconPosition)GTKENTRY_ICON_SECONDARY); }
-(void)setIconSecondaryActivatable:(BOOL)iconSecondaryActivatable
{
  gtk_entry_set_icon_activatable(NATIVE_ENTRY, (GtkEntryIconPosition)GTKENTRY_ICON_SECONDARY, iconSecondaryActivatable);
}
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-(BOOL)iconSecondarySensitive   { return gtk_entry_get_icon_sensitive  (NATIVE_ENTRY, (GtkEntryIconPosition)GTKENTRY_ICON_SECONDARY); }
-(void)setIconSecondarySensitive:(BOOL)iconSecondarySensitive
{
  gtk_entry_set_icon_sensitive(NATIVE_ENTRY, (GtkEntryIconPosition)GTKENTRY_ICON_SECONDARY, iconSecondarySensitive);
}
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-(OFString *)iconSecondaryTooltipText
{
  return [OFString stringWithUTF8String:gtk_entry_get_icon_tooltip_text(NATIVE_ENTRY, (GtkEntryIconPosition)GTKENTRY_ICON_SECONDARY)];
}
-(void)setIconSecondaryTooltipText:(OFString *)iconSecondaryTooltipText
{
  OFAutoreleasePool *pool = [[OFAutoreleasePool alloc] init];
  gtk_entry_set_icon_tooltip_text(NATIVE_ENTRY, (GtkEntryIconPosition)GTKENTRY_ICON_SECONDARY, [iconSecondaryTooltipText UTF8String]);
  [pool drain];
}
//----------------------------------------------------------------------------------------------------------------------------------
-(void)setDelegate:(id)delegate
{
  [super setDelegate:delegate];
  
  if(_delegate)
  {
    if([_delegate respondsToSelector:@selector(gtkEntryTextChanged:)])
      [_connections addObject:[OFNumber numberWithUnsignedLong:
        g_signal_connect(_native, "notify::text", G_CALLBACK(ConnectionProxy_TextChanged),NULL)]];

    if([_delegate respondsToSelector:@selector(gtkEntry:iconPressed:withButton:)])
      [_connections addObject:[OFNumber numberWithUnsignedLong:
        g_signal_connect(_native, "icon-press", G_CALLBACK(ConnectionProxy_IconPressed),NULL)]];

    if([_delegate respondsToSelector:@selector(gtkEntry:iconReleased:withButton:)])
      [_connections addObject:[OFNumber numberWithUnsignedLong:
        g_signal_connect(_native, "icon-release", G_CALLBACK(ConnectionProxy_IconReleased),NULL)]];

    if([_delegate respondsToSelector:@selector(gtkEntry:populatePopup:)])
      [_connections addObject:[OFNumber numberWithUnsignedLong:
        g_signal_connect(_native, "populate-popup", G_CALLBACK(ConnectionProxy_PopulatePopup),NULL)]];
  }
}

//==================================================================================================================================
// Utilities
//==================================================================================================================================
-(void)progressPulse { gtk_entry_progress_pulse(NATIVE_ENTRY); }
//----------------------------------------------------------------------------------------------------------------------------------
-(OMDimension)getTextArea
{
  GdkRectangle rc; gtk_entry_get_text_area(NATIVE_ENTRY, &rc);
  return OMMakeDimensionFloats((float)rc.x, (float)rc.y, (float)rc.width, (float)rc.height);
}
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-(OMDimension)getIconArea:(GtkEntryIcon)icon
{
  GdkRectangle rc; gtk_entry_get_icon_area(NATIVE_ENTRY, (GtkEntryIconPosition)icon, &rc);
  return OMMakeDimensionFloats((float)rc.x, (float)rc.y, (float)rc.width, (float)rc.height);
}
//----------------------------------------------------------------------------------------------------------------------------------
-(void)setIcon:(GtkEntryIcon)icon fromStock:(OFString *)stockId
{
  OFAutoreleasePool *pool = [[OFAutoreleasePool alloc] init];
  gtk_entry_set_icon_from_stock(NATIVE_ENTRY, (GtkEntryIconPosition)icon, [stockId UTF8String]);
  [pool drain];
}

//==================================================================================================================================
// Signal Handlers
//==================================================================================================================================
-(void)onTextChanged                                            { [_delegate gtkEntryTextChanged:self];                            }
-(void)onIconPressed:(GtkEntryIcon)icon withButton:(int)button  { [_delegate gtkEntry:self iconPressed :icon withButton:button];   }
-(void)onIconReleased:(GtkEntryIcon)icon withButton:(int)button { [_delegate gtkEntry:self iconReleased:icon withButton:button];   }
-(void)onPopulatePopup:(GtkMenu *)menu                          { [_delegate gtkEntry:self populatePopup:menu];                    }

//==================================================================================================================================
@end

//==================================================================================================================================
//----------------------------------------------------------------------------------------------------------------------------------
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
