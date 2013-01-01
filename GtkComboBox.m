//==================================================================================================================================
// GtkComboBox.m
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
#import "GtkComboBox.h"

//==================================================================================================================================
#define NATIVE_WIDGET   ((struct _GtkWidget   *)_native)
#define NATIVE_COMBOBOX ((struct _GtkComboBox *)_native)

// !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
// TODO: this class is currently just a stub with some shared support for GtkComboBoxText
// !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

//==================================================================================================================================
// Signal/Event -> Object Proxies
//==================================================================================================================================
static void ConnectionProxy_Changed(struct _GtkComboBox *combo, void *data)
{
  GtkComboBox *obj = (GtkComboBox *)[GtkWidget nativeToWrapper:(void *)combo];
  [obj onChanged];
}
//----------------------------------------------------------------------------------------------------------------------------------
static char *ConnectionProxy_FormatEntry(struct _GtkComboBox *combo, char *text, void *data)
{
  GtkComboBox *obj = (GtkComboBox *)[GtkWidget nativeToWrapper:(void *)combo];
  OFAutoreleasePool *pool = [[OFAutoreleasePool alloc] init];
  OFString *result = [obj onFormatEntry:[OFString stringWithUTF8String:text]];
  gchar *retval = g_strdup([result UTF8String]);
  [pool drain];
  return retval;
}

//==================================================================================================================================
@implementation GtkComboBox

//==================================================================================================================================
// Properites
//==================================================================================================================================
-(BOOL)hasEntry                           { return gtk_combo_box_get_has_entry(NATIVE_COMBOBOX);             }
//----------------------------------------------------------------------------------------------------------------------------------
-(BOOL)focusOnClick                       { return gtk_combo_box_get_focus_on_click(NATIVE_COMBOBOX);        }
-(void)setFocusOnClick:(BOOL)focusOnClick { gtk_combo_box_set_focus_on_click(NATIVE_COMBOBOX, focusOnClick); }
//----------------------------------------------------------------------------------------------------------------------------------
-(BOOL)forcePopupEqualWidth               { return gtk_combo_box_get_popup_fixed_width(NATIVE_COMBOBOX);     }
-(void)setForcePopupEqualWidth:(BOOL)forcePopupEqualWidth { gtk_combo_box_set_popup_fixed_width(NATIVE_COMBOBOX, forcePopupEqualWidth); }
//----------------------------------------------------------------------------------------------------------------------------------
-(int)activeIndex                         { return gtk_combo_box_get_active(NATIVE_COMBOBOX);                }
-(void)setActiveIndex:(int)activeIndex    { gtk_combo_box_set_active(NATIVE_COMBOBOX, activeIndex);          }
//----------------------------------------------------------------------------------------------------------------------------------
-(OFString *)activeId { return [OFString stringWithUTF8String:gtk_combo_box_get_active_id(NATIVE_COMBOBOX)]; }
-(void)setActiveId:(OFString *)activeId { [self trySetActiveId:activeId]; }
//----------------------------------------------------------------------------------------------------------------------------------
-(void)setDelegate:(id)delegate
{
  [super setDelegate:delegate];
  
  if(_delegate)
  {
    if([_delegate respondsToSelector:@selector(gtkComboBoxChanged:)])
      [_connections addObject:[OFNumber numberWithUnsignedLong:
        g_signal_connect(_native, "changed", G_CALLBACK(ConnectionProxy_Changed),NULL)]];

    if([_delegate respondsToSelector:@selector(gtkComboBox:formatEntry:)])
      [_connections addObject:[OFNumber numberWithUnsignedLong:
        g_signal_connect(_native, "format-entry-text", G_CALLBACK(ConnectionProxy_FormatEntry),NULL)]];
  }
}

//==================================================================================================================================
// Utilities
//==================================================================================================================================
-(BOOL)trySetActiveId:(OFString *)activeId
{
  if(activeId == nil) return gtk_combo_box_set_active_id(NATIVE_COMBOBOX, NULL);
  
  OFAutoreleasePool *pool = [[OFAutoreleasePool alloc] init];
  BOOL retval = gtk_combo_box_set_active_id(NATIVE_COMBOBOX, [activeId UTF8String]);
  [pool drain];
  return retval;
}

//==================================================================================================================================
// Signal Handlers
//==================================================================================================================================
-(void)onChanged
{
  [_delegate gtkComboBoxChanged:self];
}
//----------------------------------------------------------------------------------------------------------------------------------
-(OFString *)onFormatEntry:(OFString *)entryText
{
  return [_delegate gtkComboBox:self formatEntry:entryText];
}

//==================================================================================================================================
@end

//==================================================================================================================================
//----------------------------------------------------------------------------------------------------------------------------------
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
