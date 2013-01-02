//==================================================================================================================================
// GtkComboBoxText.h
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
#import <adenosine/GtkComboBox.h>

//==================================================================================================================================
@interface GtkComboBoxText : GtkComboBox

//----------------------------------------------------------------------------------------------------------------------------------
@property (readonly) OFString *activeText;

//----------------------------------------------------------------------------------------------------------------------------------
+ comboBoxText;
+ comboBoxTextEntry;
- initComboBoxText;
- initWithEntry;

//----------------------------------------------------------------------------------------------------------------------------------
-(void)appendText:(OFString *)text;
-(void)appendText:(OFString *)text withId:(OFString *)id;
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-(void)prependText:(OFString *)text;
-(void)prependText:(OFString *)text withId:(OFString *)id;
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-(void)insertText:(OFString *)text                         atIndex:(int)index;
-(void)insertText:(OFString *)text withId:(OFString *)text atIndex:(int)index;
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-(void)removeIndex:(int)index;
-(void)removeAll;

@end
//==================================================================================================================================
//----------------------------------------------------------------------------------------------------------------------------------
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
