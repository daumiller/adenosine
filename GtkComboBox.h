//==================================================================================================================================
// GtkComboBox.h
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
#import <adenosine/GtkBin.h>

//==================================================================================================================================
@class GtkComboBox;
@protocol GtkComboBoxDelegate <OFObject>
@optional
-(void)gtkComboBoxChanged:(GtkComboBox *)combo;
-(OFString *)gtkComboBox:(GtkComboBox *)combo formatEntry:(OFString *)entryText;
@end

//==================================================================================================================================
@interface GtkComboBox : GtkBin

// !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
// TODO: this class is currently just a stub with some shared support for GtkComboBoxText
// !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

//----------------------------------------------------------------------------------------------------------------------------------
@property (readonly) BOOL      hasEntry;
@property (assign)   BOOL      focusOnClick;
@property (assign)   BOOL      forcePopupEqualWidth;
@property (assign)   int       activeIndex;
@property (assign)   OFString *activeId;

//----------------------------------------------------------------------------------------------------------------------------------
-(BOOL)trySetActiveId:(OFString *)activeId;

//----------------------------------------------------------------------------------------------------------------------------------
-(void)onChanged;
-(OFString *)onFormatEntry:(OFString *)entryText;

@end
//==================================================================================================================================
//----------------------------------------------------------------------------------------------------------------------------------
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
