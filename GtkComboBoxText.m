//==================================================================================================================================
// GtkComboBoxText.m
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
#import "GtkComboBoxText.h"

//==================================================================================================================================
#define NATIVE_WIDGET       ((struct _GtkWidget       *)_native)
#define NATIVE_COMBOBOX     ((struct _GtkComboBox     *)_native)
#define NATIVE_COMBOBOXTEXT ((struct _GtkComboBoxText *)_native)

//==================================================================================================================================
@implementation GtkComboBoxText

//==================================================================================================================================
// Constructors/Destructor
//==================================================================================================================================
+ comboBoxText      { return [[[self alloc] initComboBoxText ] autorelease]; }
+ comboBoxTextEntry { return [[[self alloc] initWithEntry    ] autorelease]; }
//----------------------------------------------------------------------------------------------------------------------------------
- initComboBoxText
{
  self = [super init];
  if(self)
  {
    _native = (void *)gtk_combo_box_text_new();
    [self installNativeLookup];
  }
  return self;
}
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
- initWithEntry
{
  self = [super init];
  if(self)
  {
    _native = (void *)gtk_combo_box_text_new_with_entry();
    [self installNativeLookup];
  }
  return self;
}

//==================================================================================================================================
// Properties
//==================================================================================================================================
-(OFString *)activeText { return [OFString stringWithUTF8String:gtk_combo_box_text_get_active_text(NATIVE_COMBOBOXTEXT)]; }

//==================================================================================================================================
// Utilities
//==================================================================================================================================
-(void)appendText:(OFString *)text
{
  OFAutoreleasePool *pool = [[OFAutoreleasePool alloc] init];
  gtk_combo_box_text_append_text(NATIVE_COMBOBOXTEXT, [text UTF8String]);
  [pool drain];
}
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-(void)appendText:(OFString *)text withId:(OFString *)id
{
  OFAutoreleasePool *pool = [[OFAutoreleasePool alloc] init];
  gtk_combo_box_text_append(NATIVE_COMBOBOXTEXT, [id UTF8String], [text UTF8String]);
  [pool drain];
}
//----------------------------------------------------------------------------------------------------------------------------------
-(void)prependText:(OFString *)text
{
  OFAutoreleasePool *pool = [[OFAutoreleasePool alloc] init];
  gtk_combo_box_text_prepend_text(NATIVE_COMBOBOXTEXT, [text UTF8String]);
  [pool drain];
}
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-(void)prependText:(OFString *)text withId:(OFString *)id
{
  OFAutoreleasePool *pool = [[OFAutoreleasePool alloc] init];
  gtk_combo_box_text_prepend(NATIVE_COMBOBOXTEXT, [id UTF8String], [text UTF8String]);
  [pool drain];
}
//----------------------------------------------------------------------------------------------------------------------------------
-(void)insertText:(OFString *)text atIndex:(int)index
{
  OFAutoreleasePool *pool = [[OFAutoreleasePool alloc] init];
  gtk_combo_box_text_insert_text(NATIVE_COMBOBOXTEXT, index, [text UTF8String]);
  [pool drain];
}
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-(void)insertText:(OFString *)text withId:(OFString *)id atIndex:(int)index
{
  OFAutoreleasePool *pool = [[OFAutoreleasePool alloc] init];
  gtk_combo_box_text_insert(NATIVE_COMBOBOXTEXT, index, [id UTF8String], [text UTF8String]);
  [pool drain];
}
//----------------------------------------------------------------------------------------------------------------------------------
-(void)removeIndex:(int)index { gtk_combo_box_text_remove(NATIVE_COMBOBOXTEXT, index); }
-(void)removeAll              { gtk_combo_box_text_remove_all(NATIVE_COMBOBOXTEXT);    }

//==================================================================================================================================
@end

//==================================================================================================================================
//----------------------------------------------------------------------------------------------------------------------------------
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
