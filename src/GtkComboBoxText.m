//==================================================================================================================================
// GtkComboBoxText.m
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
#import <adenosine/GtkComboBoxText.h>

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
