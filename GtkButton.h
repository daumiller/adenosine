//==================================================================================================================================
// GtkButton.h
/*==================================================================================================================================
Copyright © 2012 Dillon Aumiller <dillonaumiller@gmail.com>

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
{
  id <GtkButtonDelegate> _delegate;
  OFMutableArray        *_connections;
}

//----------------------------------------------------------------------------------------------------------------------------------
+ button;
+ buttonWithText:(OFString *)text;
+ buttonWithAccel:(OFString *)text;
- initWithText:(OFString *)text;
- initWithAccel:(OFString *)text;
// + stockButton(...)

//----------------------------------------------------------------------------------------------------------------------------------
@property (retain) id <GtkButtonDelegate> delegate;
@property (assign) OFString *text;
@property (assign) BOOL focusOnClick;
//image...
//imagePosition...
//imageAlwaysShown

//----------------------------------------------------------------------------------------------------------------------------------
-(void)onClicked;

@end
//==================================================================================================================================
//----------------------------------------------------------------------------------------------------------------------------------
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
