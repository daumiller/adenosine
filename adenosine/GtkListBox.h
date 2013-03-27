//==================================================================================================================================
// GtkListBox.h
/*==================================================================================================================================
Copyright © 2013, Dillon Aumiller <dillonaumiller@gmail.com>
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met: 

1. Redistributions of source code must retain the above copyright notice, this
   list of conditions and the following disclaimer. 
2. Redistributions in binary form must reproduce the above copyright notice,
   this list of conditions and the following disclaimer in the documentation
   and/or other materials provided with the distribution. 

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
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
-(BOOL)gtkListBox:(GtkListBox *)list index:(int)index keyPressed:(unsigned int)keyCode raw:(uint16_t)rawCode group:(uint8_t)group isModifier:(BOOL)isModifier modifiers:(GtkModifier)modifiers;
-(BOOL)gtkListBox:(GtkListBox *)list index:(int)index clickedWithButton:(int)button;       //can be used for context-menus/...
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
-(void)swapItemAtIndex:(int)indexA withItemAtIndex:(int)indexB;
-(void)removeItemAtIndex:(int)index;
-(void)removeItemWithText:(OFString *)text;
-(void)removeAllItems;

//----------------------------------------------------------------------------------------------------------------------------------
-(void)onIndexChangedFrom:(int)oldIndex to:(int)newIndex;
-(void)onIndexActivated:(int)index;
-(BOOL)onIndex:(int)index keyPressed:(unsigned int)keyCode raw:(uint16_t)rawCode group:(uint8_t)group isModifier:(BOOL)isModifier modifiers:(GtkModifier)modifiers;
-(BOOL)onIndex:(int)index clickedWithButton:(int)button;

@end
//==================================================================================================================================
//----------------------------------------------------------------------------------------------------------------------------------
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
