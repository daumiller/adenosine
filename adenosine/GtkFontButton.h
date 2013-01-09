//==================================================================================================================================
// GtkFontButton.h
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
#import <adenosine/GtkButton.h>
#import <adenosine/GtkFontChooser.h>
@class OMFont;

//==================================================================================================================================
@class GtkFontButton;
@protocol GtkFontButtonDelegate <OFObject>
@optional
-(void)gtkFontButton:(GtkFontButton *)fontButton fontSet:(OMFont *)font;
@end

//==================================================================================================================================
@interface GtkFontButton : GtkButton <GtkFontChooser>
{
  OMFont *_font;
}

//----------------------------------------------------------------------------------------------------------------------------------
+ fontButton;
+ fontButtonWithFont:(OMFont *)font;
+ fontButtonWithFontString:(OFString *)fontString;
- initFontButton;
- initWithFont:(OMFont *)font;
- initWithFontString:(OFString *)fontString;

//----------------------------------------------------------------------------------------------------------------------------------
@property (assign) BOOL      showStyle;
@property (assign) BOOL      showSize;
@property (assign) BOOL      useFont;
@property (assign) BOOL      useSize;
@property (assign) OFString *dialogTitle;

//----------------------------------------------------------------------------------------------------------------------------------
-(void)onFontSet:(OMFont *)font;

//==================================================================================================================================
@end

//==================================================================================================================================
//----------------------------------------------------------------------------------------------------------------------------------
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
