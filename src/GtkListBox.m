//==================================================================================================================================
// GtkListBox.m
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
#import "GtkNative.h"
#import <adenosine/adenosine.h>
#import <atropine/atropine.h>

//==================================================================================================================================
#define NATIVE_WIDGET   ((struct _GtkWidget         *)_native)
#define NATIVE_SCROLLED ((struct _GtkScrolledWindow *)_native)

//==================================================================================================================================
// Private Helpers
//==================================================================================================================================
static GtkEventBox *GtkListBox_createItem(GtkListBox *listbox, GtkLabel *label, GtkImage *image, int index)
{
  GtkEventBox *parent = [GtkEventBox eventBox];
  GtkGrid     *grid   = [GtkGrid grid];
  if((image) && ((OFNull *)image != [OFNull null]))
  {
         if(listbox.iconMode == GTKLISTBOX_ICONMODE_LEFT ) [grid attachWidget:image left:0 top:0];
    else if(listbox.iconMode == GTKLISTBOX_ICONMODE_RIGHT) [grid attachWidget:image left:2 top:0];
  }
  label.horizontalExpand = YES;
  label.useWrapping  = listbox.labelsWrap;
  label.useMarkup    = listbox.labelsUseMarkup;
  label.useEllipsis  = listbox.labelsUseEllipsis;
  label.isSelectable = listbox.labelsSelectable;
  label.textAlign    = listbox.labelTextAlign;
  [grid attachWidget:label left:1 top:0];
  [parent add:grid];
  [parent setProperty:@"adenosine-listbox-itemIndex" toValue:(void *)(unsigned long)index];
  parent.canGrabFocus  = YES;
  parent.aboveChild    = YES;
  parent.visibleWindow = YES;
  parent.delegate      = listbox;
  return parent;
}

//==================================================================================================================================
@implementation GtkListBox

//==================================================================================================================================
// Constructors/Destructor
//==================================================================================================================================
+ listBox                                                              { return [[(GtkListBox *)[self alloc] initListBox                                ] autorelease]; }
+ listBoxWithText:(OFArray *)textItems                                 { return [[(GtkListBox *)[self alloc] initWithText:textItems                     ] autorelease]; }
+ listBoxWithText:(OFArray *)textItems andImages:(OFArray *)imageItems { return [[(GtkListBox *)[self alloc] initWithText:textItems andImages:imageItems] autorelease]; }
//----------------------------------------------------------------------------------------------------------------------------------
-(void)commonInit
{
  _viewport = [GtkViewport viewport]; [self add:_viewport];
  _grid     = [GtkGrid grid];         [_viewport add:_grid];
  _items    = [[OFMutableArray alloc] init];
  _labels   = [[OFMutableArray alloc] init];
  _images   = [[OFMutableArray alloc] init];
  _labelsWrap        = NO;
  _labelsUseMarkup   = NO;
  _labelsUseEllipsis = YES;
  _labelsSelectable  = NO;
  _labelTextAlign    = GTKTEXT_ALIGN_LEFT;
  _highlightSelected = YES;
  _highlightColor    = OMMakeColorRGB(0.0f, 0.0f, 0.75f);
  _iconMode          = GTKLISTBOX_ICONMODE_NONE;
  _selectedIndex     = -1;
  _count             =  0;
}
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
- initListBox
{
  self = [super initScrolledWindow];
  if(self)
    [self commonInit];
  return self;
}
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
- initWithText:(OFArray *)textItems
{
  self = [super initScrolledWindow];
  if(self)
  {
    [self commonInit];
    [self appendItemsWithText:textItems];
  }
  return self;
}
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
- initWithText:(OFArray *)textItems andImages:(OFArray *)imageItems
{
  self = [super initScrolledWindow];
  if(self)
  {
    [self commonInit];
    [self appendItemsWithText:textItems andImages:imageItems];
  }
  return self;
}
//----------------------------------------------------------------------------------------------------------------------------------
-(void)dealloc
{
  [_images   release];
  [_labels   release];
  [_items    release];
  [_grid     release];
  [_viewport release];
  [super dealloc];
}

//==================================================================================================================================
// Properties
//==================================================================================================================================
-(GtkViewport *)    viewport          { return _viewport;          }
-(GtkGrid *)        grid              { return _grid;              }
-(OFArray *)        items             { return (OFArray *)_items;  }
-(OFArray *)        labels            { return (OFArray *)_labels; }
-(OFArray *)        images            { return (OFArray *)_images; }
-(int)              count             { return _count;             }
-(BOOL)             labelsWrap        { return _labelsWrap;        }
-(BOOL)             labelsUseMarkup   { return _labelsUseMarkup;   }
-(BOOL)             labelsUseEllipsis { return _labelsUseEllipsis; }
-(BOOL)             labelsSelectable  { return _labelsSelectable;  }
-(GtkTextAlign)     labelTextAlign    { return _labelTextAlign;    }
-(BOOL)             highlightSelected { return _highlightSelected; }
-(OMColor)          highlightColor    { return _highlightColor;    } 
-(GtkListBoxIconMode)iconMode         { return _iconMode;          }
-(int)              selectedIndex     { return _selectedIndex;     }
//----------------------------------------------------------------------------------------------------------------------------------
-(void)setLabelsWrap:(BOOL)labelsWrap
{
  if(labelsWrap == _labelsWrap) return;
  _labelsWrap = labelsWrap;
  for(GtkLabel *lbl in _labels)
    lbl.useWrapping = labelsWrap;
}
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-(void)setLabelsUseMarkup:(BOOL)labelsUseMarkup
{
  if(labelsUseMarkup == _labelsUseMarkup) return;
  _labelsUseMarkup = labelsUseMarkup;
  for(GtkLabel *lbl in _labels)
    lbl.useMarkup = labelsUseMarkup;
}
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-(void)setLabelsUseEllipsis:(BOOL)labelsUseEllipsis
{
  if(labelsUseEllipsis == _labelsUseEllipsis) return;
  _labelsUseEllipsis = labelsUseEllipsis;
  for(GtkLabel *lbl in _labels)
    lbl.useEllipsis = labelsUseEllipsis;
}
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-(void)setLabelsSelectable:(BOOL)labelsSelectable
{
  if(labelsSelectable == _labelsSelectable) return;
  _labelsSelectable = labelsSelectable;
  for(GtkLabel *lbl in _labels)
    lbl.isSelectable = labelsSelectable;
}
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-(void)setLabelTextAlign:(GtkTextAlign)labelTextAlign
{
  if(labelTextAlign == _labelTextAlign) return;
  _labelTextAlign = labelTextAlign;
  for(GtkLabel *lbl in _labels)
    lbl.textAlign = labelTextAlign;
}
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-(void)setHighlightSelected:(BOOL)highlightSelected
{
  if(_highlightSelected == highlightSelected) return;
  _highlightSelected = highlightSelected;
  if(_selectedIndex == -1) return;
  if(_highlightSelected)
    [(GtkWidget *)[_items objectAtIndex:_selectedIndex] overrideBackgroundColor:_highlightColor forState:GTKWIDGET_STATE_NORMAL];
  else
    [(GtkWidget *)[_items objectAtIndex:_selectedIndex] resetBackgroundColorForState:GTKWIDGET_STATE_NORMAL];
}
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-(void)setHighlightColor:(OMColor)highlightColor
{
  _highlightColor = highlightColor;
  if(!_highlightSelected) return;
  if(_selectedIndex == -1) return;
  [(GtkWidget *)[_items objectAtIndex:_selectedIndex] overrideBackgroundColor:_highlightColor forState:GTKWIDGET_STATE_NORMAL];
}
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-(void)setIconMode:(GtkListBoxIconMode)iconMode
{
  if(_iconMode == iconMode) return;
  _iconMode = iconMode;
  if(_iconMode == GTKLISTBOX_ICONMODE_NONE)
  {
    for(id imgItem in _images)
      if(imgItem != [OFNull null])
        [(GtkWidget *)imgItem hide];
    return;
  }

  if(_iconMode == GTKLISTBOX_ICONMODE_LEFT)
  {
    GtkGrid *grid;
    for(int i=0; i<_count; i++)
    {
      id imgItem = [_images objectAtIndex:i];
      if(imgItem != [OFNull null])
      {
        grid = (GtkGrid *)((GtkEventBox *)[_items objectAtIndex:i]).child;
        [grid remove:imgItem];
        [grid attachWidget:imgItem left:0 top:i];
        [(GtkWidget *)imgItem show];
      }
    }
    return;
  }

  if(_iconMode == GTKLISTBOX_ICONMODE_RIGHT)
  {
    GtkGrid *grid;
    for(int i=0; i<_count; i++)
    {
      id imgItem = [_images objectAtIndex:i];
      if(imgItem != [OFNull null])
      {
        grid = (GtkGrid *)((GtkEventBox *)[_items objectAtIndex:i]).child;
        [grid remove:imgItem];
        [grid attachWidget:imgItem left:2 top:i];
        [(GtkWidget *)imgItem show];
      }
    }
    return;
  }
}
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-(void)setSelectedIndex:(int)selectedIndex
{
  if(selectedIndex >= _count) selectedIndex = _count-1;
  [self onIndexChangedFrom:_selectedIndex to:selectedIndex];
}

//==================================================================================================================================
// Utilities
//==================================================================================================================================
-(void)appendItemWithText:(OFString *)text
{
  GtkLabel    *lbl  = [GtkLabel labelWithText:text];
  GtkEventBox *item = GtkListBox_createItem(self, lbl, NULL, _count);
  [_labels addObject:lbl];
  [_images addObject:[OFNull null]];
  [_items addObject:item];
  [_grid attachWidget:item left:0 top:_count];
  _count++;
}
//----------------------------------------------------------------------------------------------------------------------------------
-(void)appendItemWithText:(OFString *)text andImage:(GtkImage *)image
{
  GtkLabel    *lbl  = [GtkLabel labelWithText:text];
  GtkEventBox *item = GtkListBox_createItem(self, lbl, image, _count);
  [_labels addObject:lbl];
  [_images addObject:image];
  [_items addObject:item];
  [_grid attachWidget:item left:0 top:_count];
  _count++;
}
//----------------------------------------------------------------------------------------------------------------------------------
-(void)insertItemWithText:(OFString *)text atIndex:(int)index
{
  if(index >= _count) { [self appendItemWithText:text]; return; }
  if(index < 0) index = 0;

  GtkLabel    *lbl  = [GtkLabel labelWithText:text];
  GtkEventBox *item = GtkListBox_createItem(self, lbl, NULL, index);
  [_labels insertObject:lbl           atIndex:index];
  [_images insertObject:[OFNull null] atIndex:index];
  [_items  insertObject:item          atIndex:index];
  [_grid insertRowAtIndex:index];
  [_grid attachWidget:item left:0 top:index];
  _count++;
}
//----------------------------------------------------------------------------------------------------------------------------------
-(void)insertItemWithText:(OFString *)text andImage:(GtkImage *)image atIndex:(int)index
{
  if(index >= _count) { [self appendItemWithText:text]; return; }
  if(index < 0) index = 0;

  GtkLabel    *lbl  = [GtkLabel labelWithText:text];
  GtkEventBox *item = GtkListBox_createItem(self, lbl, NULL, index);
  [_labels insertObject:lbl   atIndex:index];
  [_images insertObject:image atIndex:index];
  [_items  insertObject:item  atIndex:index];
  [_grid insertRowAtIndex:index];
  [_grid attachWidget:item left:0 top:index];
  _count++;
}
//----------------------------------------------------------------------------------------------------------------------------------
-(void)appendItemsWithText:(OFArray *)textItems
{
  for(OFString *str in textItems)
    [self appendItemWithText:str];
}
//----------------------------------------------------------------------------------------------------------------------------------
-(void)appendItemsWithText:(OFArray *)textItems andImages:(OFArray *)imageItems
{
  int a = textItems.count, b = imageItems.count;
  int max = (a < b) ? a : b;
  for(int i=0; i<max; i++)
    [self appendItemWithText:[textItems objectAtIndex:i] andImage:[imageItems objectAtIndex:i]];
}
//----------------------------------------------------------------------------------------------------------------------------------
-(void)removeItemAtIndex:(int)index
{
  if(index >= _count) return;
  if(index < 0) return;
  GtkEventBox *item = (GtkEventBox *)[_items objectAtIndex:index];
  [_grid remove:item];
  [_labels removeObjectAtIndex:index];
  [_images removeObjectAtIndex:index];
  [_items  removeObjectAtIndex:index];
  _count--;
}
//----------------------------------------------------------------------------------------------------------------------------------
-(void)removeItemWithText:(OFString *)text
{
  int index = -1;
  for(int i=0; i<_count; i++)
  {
    if([((GtkLabel *)[_labels objectAtIndex:i]).text compare:text] == OF_ORDERED_SAME)
    {
      index = i;
      break;
    }
  }
  if(index < 0) return;
  [self removeItemAtIndex:index];
}
//----------------------------------------------------------------------------------------------------------------------------------
-(void)removeAllItems
{
  while(_count > 0)
    [self removeItemAtIndex:0];
}

//==================================================================================================================================
// Events
//==================================================================================================================================
-(void)onIndexChangedFrom:(int)oldIndex to:(int)newIndex
{
  if(oldIndex == newIndex) return;
  _selectedIndex = newIndex;
  if(_highlightSelected)
  {
    if(oldIndex > -1)
      [(GtkEventBox *)[_items objectAtIndex:oldIndex] resetBackgroundColorForState:GTKWIDGET_STATE_NORMAL];
    if(_selectedIndex > -1)
    {
      GtkEventBox *item = (GtkEventBox *)[_items objectAtIndex:_selectedIndex];
      [item overrideBackgroundColor:_highlightColor forState:GTKWIDGET_STATE_NORMAL];
      [item grabFocus];
    }
  }
  if([_delegate respondsToSelector:@selector(gtkListBox:indexChangedFrom:to:)])
    [_delegate gtkListBox:self indexChangedFrom:oldIndex to:_selectedIndex];
}
//----------------------------------------------------------------------------------------------------------------------------------
-(void)onIndexActivated:(int)index
{
  printf("Item %d Activated\n", index);
  //...
  if([_delegate respondsToSelector:@selector(gtkListBox:indexActivated:)])
    [_delegate gtkListBox:self indexActivated:index];
}
//----------------------------------------------------------------------------------------------------------------------------------
//-(BOOL)onIndexKeyPressed:(int)index ...;
//----------------------------------------------------------------------------------------------------------------------------------
//-(void)onPopulateContextMenu:(GtkMenu *)menu forIndex:(int)index;

//==================================================================================================================================
// Child Events
//==================================================================================================================================
-(BOOL)gtkWidget:(GtkWidget *)widget buttonPressed:(int)button clickCount:(int)clickCount local:(OMCoordinate)local root:(OMCoordinate)root modifiers:(GtkModifier)modifiers
{
  if(!native_is_gtk_type_named(widget.native,"GtkEventBox")) return NO;
  int index = (int)(unsigned long)[widget getProperty:@"adenosine-listbox-itemIndex"];
  if(clickCount == 2) [self onIndexActivated:index];
  return YES;
}
//----------------------------------------------------------------------------------------------------------------------------------
-(BOOL)gtkWidget:(GtkWidget *)widget buttonReleased:(int)button local:(OMCoordinate)local root:(OMCoordinate)root modifiers:(GtkModifier)modifiers
{
  if(!native_is_gtk_type_named(widget.native,"GtkEventBox")) return NO;
  int newIndex = (int)(unsigned long)[widget getProperty:@"adenosine-listbox-itemIndex"];
  [self onIndexChangedFrom:_selectedIndex to:newIndex];
  return YES;
}
//----------------------------------------------------------------------------------------------------------------------------------
-(BOOL)gtkWidget:(GtkWidget *)widget keyPressed:(unsigned int)keyCode raw:(uint16_t)rawCode group:(uint8_t)group isModifier:(BOOL)isModifier modifiers:(GtkModifier)modifiers
{
  if(!native_is_gtk_type_named(widget.native,"GtkEventBox")) return NO;
  switch(keyCode)
  {
    //http://git.gnome.org/browse/gtk+/tree/gdk/gdkkeysyms.h
    case 0xFF52: if(_selectedIndex > 0) self.selectedIndex--; break; //UP
    case 0xFF54:                        self.selectedIndex++; break; //DOWN
  }
  return YES; 
}

//==================================================================================================================================
// Overrides
//==================================================================================================================================
-(void)wrapAllChildren
{
  return; //no need
}
//----------------------------------------------------------------------------------------------------------------------------------
-(void)show
{
  gtk_widget_show_all(NATIVE_WIDGET); //always want our children shown w/ us
}

//==================================================================================================================================
@end

//==================================================================================================================================
//----------------------------------------------------------------------------------------------------------------------------------
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
