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
+ menuRadio;
+ menuRadioWithText:(OFString *)text;
+ menuRadioWithAccel:(OFString *)text;
+ menuRadioGroupedWith:(GtkMenuRadio *)groupMember;
+ menuRadioWithText:(OFString *)text groupedWith:(GtkMenuRadio *)groupMember;
+ menuRadioWithAccel:(OFString *)text groupedWidth:(GtkMenuRadio *)groupMember;
- initMenuRadio;
- initWithText:(OFString *)text;
- initWithAccel:(OFString *)text;
- initWithGroup:(GtkMenuRadio *)groupMember;
- initWithText:(OFString *)text andGroup:(GtkMenuRadio *)groupMember;
- initWithAccel:(OFString *)text andGroup:(GtkMenuRadio *)groupMember;

//----------------------------------------------------------------------------------------------------------------------------------
@property (assign) void *groupId;

//----------------------------------------------------------------------------------------------------------------------------------
-(OFArray *)listGroup;

//==================================================================================================================================
@end

//==================================================================================================================================
//----------------------------------------------------------------------------------------------------------------------------------
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
