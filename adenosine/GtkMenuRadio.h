//==================================================================================================================================
// GtkMenuRadio.h
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
#import <ObjFW/ObjFW.h>
#import <adenosine/GtkMenuCheck.h>

//==================================================================================================================================
@interface GtkMenuRadio : GtkMenuCheck

//----------------------------------------------------------------------------------------------------------------------------------
+ menuRadioWithGroup:(void *)group;
+ menuRadioWithGroup:(void *)group andText:(OFString *)text;
+ menuRadioWithGroup:(void *)group andAccel:(OFString *)text;
+ menuRadioWithSibling:(GtkMenuRadio *)groupMember;
+ menuRadioWithSibling:(GtkMenuRadio *)groupMember andText :(OFString *)text;
+ menuRadioWithSibling:(GtkMenuRadio *)groupMember andAccel:(OFString *)text;
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
+ menuRadioWithGroup:(void *)group                                           andDelegate:(id)delegate;
+ menuRadioWithGroup:(void *)group andText:(OFString *)text                  andDelegate:(id)delegate;
+ menuRadioWithGroup:(void *)group andAccel:(OFString *)text                 andDelegate:(id)delegate;
+ menuRadioWithSibling:(GtkMenuRadio *)groupMember                           andDelegate:(id)delegate;
+ menuRadioWithSibling:(GtkMenuRadio *)groupMember andText :(OFString *)text andDelegate:(id)delegate;
+ menuRadioWithSibling:(GtkMenuRadio *)groupMember andAccel:(OFString *)text andDelegate:(id)delegate;
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
- initWithGroup:(void *)group;
- initWithGroup:(void *)group andText:(OFString *)text;
- initWithGroup:(void *)group andAccel:(OFString *)text;
- initWithSibling:(GtkMenuRadio *)groupMember;
- initWithSibling:(GtkMenuRadio *)groupMember andText:(OFString *)text;
- initWithSibling:(GtkMenuRadio *)groupMember andAccel:(OFString *)text;

//----------------------------------------------------------------------------------------------------------------------------------
@property (assign) void *groupId;

//----------------------------------------------------------------------------------------------------------------------------------
-(OFArray *)listGroup;

//==================================================================================================================================
@end

//==================================================================================================================================
//----------------------------------------------------------------------------------------------------------------------------------
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
