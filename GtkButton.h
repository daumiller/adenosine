//==================================================================================================================================
// GtkButton.h
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
@class GtkButton;
@protocol GtkButtonDelegate <OFObject>
@optional
-(void)gtkButtonClicked:(GtkButton *)button;
@end

//==================================================================================================================================
@interface GtkButton : GtkBin

//----------------------------------------------------------------------------------------------------------------------------------
+ button;
+ buttonWithText:(OFString *)text;
+ buttonWithAccel:(OFString *)text;
+ buttonFromStock:(OFString *)stockId;
- initButton;
- initWithText:(OFString *)text;
- initWithAccel:(OFString *)text;
- initFromStock:(OFString *)stockId;

//----------------------------------------------------------------------------------------------------------------------------------
@property (assign) OFString   *text;
@property (assign) BOOL        textIsStockId;
@property (assign) BOOL        textIsAccel;
@property (assign) BOOL        focusOnClick;
@property (assign) GtkPosition imagePosition;

//----------------------------------------------------------------------------------------------------------------------------------
-(void) setImageWidget:(GtkWidget *)imageWidget;

//----------------------------------------------------------------------------------------------------------------------------------
-(void)onClicked;

//==================================================================================================================================
@end

//==================================================================================================================================
//----------------------------------------------------------------------------------------------------------------------------------
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
