//==================================================================================================================================
// GtkMenuRadio.m
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
#import <adenosine/adenosine.h>

//==================================================================================================================================
#define NATIVE_WIDGET    ((struct _GtkWidget        *)_native)
#define NATIVE_MENURADIO ((struct _GtkRadioMenuItem *)_native)

//==================================================================================================================================
@implementation GtkMenuRadio

//==================================================================================================================================
// Constructors/Destructor
//==================================================================================================================================
+ menuRadioWithGroup:(void *)group                           { return [[[self alloc] initWithGroup:group              ] autorelease]; }
+ menuRadioWithGroup:(void *)group andText:(OFString *)text  { return [[[self alloc] initWithGroup:group andText:text ] autorelease]; }
+ menuRadioWithGroup:(void *)group andAccel:(OFString *)text { return [[[self alloc] initWithGroup:group andAccel:text] autorelease]; }
+ menuRadioWithSibling:(GtkMenuRadio *)groupMember                           { return [[[self alloc] initWithSibling:groupMember              ] autorelease]; }
+ menuRadioWithSibling:(GtkMenuRadio *)groupMember andText :(OFString *)text { return [[[self alloc] initWithSibling:groupMember andText:text ] autorelease]; }
+ menuRadioWithSibling:(GtkMenuRadio *)groupMember andAccel:(OFString *)text { return [[[self alloc] initWithSibling:groupMember andAccel:text] autorelease]; }
//----------------------------------------------------------------------------------------------------------------------------------
+ menuRadioWithGroup:(void *)group andDelegate:(id)delegate
{
  GtkMenuRadio *rdio = [self menuRadioWithGroup:group];
  rdio.delegate = delegate;
  return rdio;
}
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
+ menuRadioWithGroup:(void *)group andText:(OFString *)text andDelegate:(id)delegate
{
  GtkMenuRadio *rdio = [self menuRadioWithGroup:group andText:text];
  rdio.delegate = delegate;
  return rdio;
}
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
+ menuRadioWithGroup:(void *)group andAccel:(OFString *)text andDelegate:(id)delegate
{
  GtkMenuRadio *rdio = [self menuRadioWithGroup:group andAccel:text];
  rdio.delegate = delegate;
  return rdio;
}
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
+ menuRadioWithSibling:(GtkMenuRadio *)groupMember andDelegate:(id)delegate
{
  GtkMenuRadio *rdio = [self menuRadioWithSibling:groupMember];
  rdio.delegate = delegate;
  return rdio;
}
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
+ menuRadioWithSibling:(GtkMenuRadio *)groupMember andText:(OFString *)text andDelegate:(id)delegate
{
  GtkMenuRadio *rdio = [self menuRadioWithSibling:groupMember andText:text];
  rdio.delegate = delegate;
  return rdio;
}
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
+ menuRadioWithSibling:(GtkMenuRadio *)groupMember andAccel:(OFString *)text andDelegate:(id)delegate
{
  GtkMenuRadio *rdio = [self menuRadioWithSibling:groupMember andAccel:text];
  rdio.delegate = delegate;
  return rdio;
}
//----------------------------------------------------------------------------------------------------------------------------------
- initWithGroup:(void *)group
{
  self = [super init];
  if(self)
  {
    _native = gtk_radio_menu_item_new(group);
    [self installNativeLookup];
  }
  return self;
}
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
- initWithGroup:(void *)group andText:(OFString *)text
{
  self = [super init];
  if(self)
  {
    OFAutoreleasePool *pool = [[OFAutoreleasePool alloc] init];
    _native = gtk_radio_menu_item_new_with_label(group, [text UTF8String]);
    [self installNativeLookup];
    [pool drain];
  }
  return self;
}
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
- initWithGroup:(void *)group andAccel:(OFString *)text
{
  self = [super init];
  if(self)
  {
    OFAutoreleasePool *pool = [[OFAutoreleasePool alloc] init];
    _native = gtk_radio_menu_item_new_with_mnemonic(group, [text UTF8String]);
    [self installNativeLookup];
    [pool drain];
  }
  return self;
}
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
- initWithSibling:(GtkMenuRadio *)groupMember
{
  self = [super init];
  if(self)
  {
    _native = gtk_radio_menu_item_new_from_widget(groupMember.native);
    [self installNativeLookup];
  }
  return self;
}
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
- initWithSibling:(GtkMenuRadio *)groupMember andText:(OFString *)text
{
  self = [super init];
  if(self)
  {
    OFAutoreleasePool *pool = [[OFAutoreleasePool alloc] init];
    _native = gtk_radio_menu_item_new_with_label_from_widget(groupMember.native, [text UTF8String]);
    [self installNativeLookup];
    [pool drain];
  }
  return self;
}
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
- initWithSibling:(GtkMenuRadio *)groupMember andAccel:(OFString *)text
{
  self = [super init];
  if(self)
  {
    OFAutoreleasePool *pool = [[OFAutoreleasePool alloc] init];
    _native = gtk_radio_menu_item_new_with_mnemonic_from_widget(groupMember.native, [text UTF8String]);
    [self installNativeLookup];
    [pool drain];
  }
  return self;
}

//==================================================================================================================================
// Properites
//==================================================================================================================================
-(void *)groupId                  { return gtk_radio_menu_item_get_group(NATIVE_MENURADIO);   }
-(void)setGroupId:(void *)groupId { gtk_radio_menu_item_set_group(NATIVE_MENURADIO, groupId); }

//==================================================================================================================================
// Utilities
//==================================================================================================================================
-(OFArray *)listGroup
{
  OFMutableArray *ofGroup = [[OFMutableArray alloc] init];

  GSList *goGroup = (GSList *)self.groupId; if(goGroup == NULL) return [OFArray array];
  unsigned int goCount = g_slist_length(goGroup);
  for(unsigned int i=0; i<goCount; i++)
  {
    GtkWidget *wrapped = [GtkWidget nativeToWrapper:g_slist_nth_data(goGroup, i)];
    if(wrapped) [ofGroup addObject:wrapped];
  }
  g_slist_free(goGroup);

  OFArray *retArr = [OFArray arrayWithArray:ofGroup];
  [ofGroup release];
  return retArr;
}

//==================================================================================================================================
@end

//==================================================================================================================================
//----------------------------------------------------------------------------------------------------------------------------------
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
