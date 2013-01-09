//==================================================================================================================================
// GtkFontChooser.h
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
@class OMFont;

//==================================================================================================================================
@protocol GtkFontChooser <OFObject>

@required
//----------------------------------------------------------------------------------------------------------------------------------
@property (assign)   OFString *previewText;
@property (assign)   BOOL      showPreviewEntry;
@property (assign)   OFString *fontString;
@property (retain)   OMFont   *font;
@property (readonly) OFString *fontFamilyName;
@property (readonly) int       fontSize;

//----------------------------------------------------------------------------------------------------------------------------------
-(void)setFontFilter:(BOOL (^)(OMFont *))block;

@end
//==================================================================================================================================
//----------------------------------------------------------------------------------------------------------------------------------
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
