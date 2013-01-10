//==================================================================================================================================
// GtkListBox.h
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
#import <adenosine/GtkScrolledWindow.h>
#import <atropine/atropine.h>
@class GtkViewport;
@class GtkGrid;
@class GtkImage;

//==================================================================================================================================
typedef enum
{
  GTKLISTBOX_ICONMODE_NONE  = 0,
  GTKLISTBOX_ICONMODE_LEFT  = 1,
  GTKLISTBOX_ICONMODE_RIGHT = 2
} GtkListBoxIconMode;

//==================================================================================================================================
@class GtkListBox;
@protocol GtkListBoxDelegate <OFObject>
@optional
-(void)gtkListBox:(GtkListBox *)list indexChangedFrom:(int)oldIndex to:(int)newIndex;       //left-click or arrow keys
-(void)gtkListBox:(GtkListBox *)list indexActivated:(int)index;                             //enter or double click
//-(BOOL)gtkListBox:(GtkListBox *)list indexKeyPressed:(int)index ...                           //stop processing/did eat event?
//-(void)gtkListBox:(GtkListBox *)list populateContextMenu:(GMenu *)menu forIndex:(int)index; //right-click
@end

//==================================================================================================================================
@interface GtkListBox : GtkScrolledWindow
{
  GtkViewport       *_viewport;
  GtkGrid           *_grid;
  OFMutableArray    *_items;
  OFMutableArray    *_labels;
  OFMutableArray    *_images;
  BOOL               _labelsWrap;
  BOOL               _labelsUseMarkup;
  BOOL               _labelsUseEllipsis;
  BOOL               _labelsSelectable;
  GtkTextAlign       _labelTextAlign;
  BOOL               _highlightSelected;
  OMColor            _highlightColor;
  GtkListBoxIconMode _iconMode;
  int                _selectedIndex;
  int                _count;
}

//----------------------------------------------------------------------------------------------------------------------------------
@property (readonly) GtkViewport       *viewport;
@property (readonly) GtkGrid           *grid;
@property (readonly) OFArray           *items;
@property (readonly) OFArray           *labels;
@property (readonly) OFArray           *images;
@property (readonly) int                count;
@property (assign)   BOOL               labelsWrap;
@property (assign)   BOOL               labelsUseMarkup;
@property (assign)   BOOL               labelsUseEllipsis;
@property (assign)   BOOL               labelsSelectable;
@property (assign)   GtkTextAlign       labelTextAlign;
@property (assign)   BOOL               highlightSelected;
@property (assign)   OMColor            highlightColor;
@property (assign)   GtkListBoxIconMode iconMode;
@property (assign)   int                selectedIndex;

//----------------------------------------------------------------------------------------------------------------------------------
+ listBox;
+ listBoxWithText:(OFArray *)textItems;
+ listBoxWithText:(OFArray *)textItems andImages:(OFArray *)imageItems;
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
- initListBox;
- initWithText:(OFArray *)textItems;
- initWithText:(OFArray *)textItems andImages:(OFArray *)imageItems;

//----------------------------------------------------------------------------------------------------------------------------------
-(void)appendItemWithText:(OFString *)text;
-(void)appendItemWithText:(OFString *)text andImage:(GtkImage *)image;
-(void)insertItemWithText:(OFString *)text atIndex:(int)index;
-(void)insertItemWithText:(OFString *)text andImage:(GtkImage *)image atIndex:(int)index;
-(void)appendItemsWithText:(OFArray *)textItems;
-(void)appendItemsWithText:(OFArray *)textItems andImages:(OFArray *)imageItems;
-(void)removeItemAtIndex:(int)index;
-(void)removeItemWithText:(OFString *)text;
-(void)removeAllItems;

//----------------------------------------------------------------------------------------------------------------------------------
-(void)onIndexChangedFrom:(int)oldIndex to:(int)newIndex;
-(void)onIndexActivated:(int)index;
//-(BOOL)onIndexKeyPressed:(int)index ...;
//-(void)onPopulateContextMenu:(GtkMenu *)menu forIndex:(int)index;

@end
//==================================================================================================================================
//----------------------------------------------------------------------------------------------------------------------------------
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
