//==================================================================================================================================
// GtkLabel.h
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
#import <adenosine/GtkMisc.h>

//==================================================================================================================================
@class GtkLabel;
@protocol GtkLabelDelegate <OFObject>
@optional
-(BOOL)gtkLabel:(GtkLabel *)label linkActivated:(OFString *)link;
-(void)gtkLabel:(GtkLabel *)label populateContextMenu:(void *)nativeMenu;
@end

//==================================================================================================================================
@interface GtkLabel : GtkMisc

//----------------------------------------------------------------------------------------------------------------------------------
@property (assign) OFString  *text;
@property (assign) int        maxCharLength;
@property (assign) BOOL       useMarkup;
@property (assign) BOOL       useEllipsis;
@property (assign) BOOL       useWrapping;
@property (assign) BOOL       isSelectable;
@property (assign) BOOL       markVisitedLinks;
@property (assign) float      angle;
@property (assign) GtkWidget *accelWidget;

//----------------------------------------------------------------------------------------------------------------------------------
+ label;
+ labelWithText:(OFString *)text;
+ labelWithMarkup:(OFString *)markup;
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
- initWithText:(OFString *)text;
- initWithMarkup:(OFString *)markup;

//----------------------------------------------------------------------------------------------------------------------------------
-(void)setMarkup:(OFString *)markup;
-(void)setMarkupWithAccel:(OFString *)markup;

//----------------------------------------------------------------------------------------------------------------------------------
-(BOOL)onLinkActivated:(char *)uri;
-(void)onPopulateContextMenu:(void *)nativeMenu;

@end
//==================================================================================================================================
//----------------------------------------------------------------------------------------------------------------------------------
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
