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
+ menuRadio                           { return [[[self alloc] initMenuRadio     ] autorelease]; }
+ menuRadioWithText:(OFString *)text  { return [[[self alloc] initWithText:text ] autorelease]; }
+ menuRadioWithAccel:(OFString *)text { return [[[self alloc] initWithAccel:text] autorelease]; }
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
+ menuRadioGroupedWith:(GtkMenuRadio *)groupMember                             { return [[[self alloc] initWithGroup:groupMember              ] autorelease]; }
+ menuRadioWithText:(OFString *)text groupedWith:(GtkMenuRadio *)groupMember   { return [[[self alloc] initWithText:text  andGroup:groupMember] autorelease]; }
+ menuRadioWithAccel:(OFString *)text groupedWidth:(GtkMenuRadio *)groupMember { return [[[self alloc] initWithAccel:text andGroup:groupMember] autorelease]; }
//----------------------------------------------------------------------------------------------------------------------------------
- initMenuRadio
{
  self = [super init];
  if(self)
  {
    _native = gtk_radio_menu_item_new(NULL);
    [self installNativeLookup];
  }
  return self;
}
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
- initWithText:(OFString *)text
{
  self = [super init];
  if(self)
  {
    OFAutoreleasePool *pool = [[OFAutoreleasePool alloc] init];
    _native = gtk_radio_menu_item_new_with_label(NULL, [text UTF8String]);
    [self installNativeLookup];
    [pool drain];
  }
  return self;
}
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
- initWithAccel:(OFString *)text
{
  self = [super init];
  if(self)
  {
    OFAutoreleasePool *pool = [[OFAutoreleasePool alloc] init];
    _native = gtk_radio_menu_item_new_with_mnemonic(NULL, [text UTF8String]);
    [self installNativeLookup];
    [pool drain];
  }
  return self;
}
//----------------------------------------------------------------------------------------------------------------------------------
- initWithGroup:(GtkMenuRadio *)groupMember
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
- initWithText:(OFString *)text andGroup:(GtkMenuRadio *)groupMember
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
- initWithAccel:(OFString *)text andGroup:(GtkMenuRadio *)groupMember
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
