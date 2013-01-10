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
  label.useWrapping   = listbox.labelsWrap;
  label.useMarkup     = listbox.labelsUseMarkup;
  label.useEllipsis   = listbox.labelsUseEllipsis;
  label.isSelectable  = listbox.labelsSelectable;
  label.textAlign     = listbox.labelTextAlign;
  [grid attachWidget:label left:1 top:0];
  [parent add:grid];
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
  
  GtkListBoxIconMode oldIconMode = _iconMode;
  _iconMode = iconMode;

  //if new mode is none, then remove everything
  //if old mode was Not none, then we'll need to remove before repositioning
  if((_iconMode == GTKLISTBOX_ICONMODE_NONE) || (oldIconMode != GTKLISTBOX_ICONMODE_NONE))
  {
    GtkGrid *grid; GtkImage *image;
    for(int i=0; i<_count; i++)
    {
      image = [_images objectAtIndex:i];
      if((id)image != (id)[OFNull null])
      {
        //_item is GtkEventBox, which is GtkBin with single child GtkGrid
        grid = (GtkGrid *)[[_items objectAtIndex:i] child];
        [grid remove:image];
      }
    }
    //if new mode, then we're done here
    if(_iconMode == GTKLISTBOX_ICONMODE_NONE)
      return;
  }

  //icon mode is now Left | Right
  int left = (_iconMode == GTKLISTBOX_ICONMODE_LEFT) ? 0 : 2;
  GtkGrid *grid; GtkImage *image;
  for(int i=0; i<_count; i++)
  {
    image = [_images objectAtIndex:i];
    if((id)image != (id)[OFNull null])
    {
      //_item is GtkEventBox, which is GtkBin with single child GtkGrid
      grid = (GtkGrid *)[[_items objectAtIndex:i] child];
      [grid attachWidget:image left:left top:0];
      [image show];
    }
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
  [item showAll];
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
  [item showAll];
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
  [item showAll];
  if(index <= _selectedIndex) _selectedIndex++;
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
  [item showAll];
  if(index <= _selectedIndex) _selectedIndex++;
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
-(void)swapItemAtIndex:(int)indexA withItemAtIndex:(int)indexB;
{
  if(indexA < 0) return; if(indexA >= _count) return;
  if(indexB < 0) return; if(indexB >= _count) return;
  
  //first do a visual swap
  //NOTE: our listbox doesn't hold any reference to these Grids, so we'll need to make sure to keep them alive during reassignment
  GtkEventBox *itemA = (GtkEventBox *)[_items objectAtIndex:indexA]; GtkGrid *gridA = [(GtkGrid *)itemA.child retain]; [itemA remove:gridA];
  GtkEventBox *itemB = (GtkEventBox *)[_items objectAtIndex:indexB]; GtkGrid *gridB = [(GtkGrid *)itemB.child retain]; [itemB remove:gridB];
  [itemA add:gridB]; [gridB release];
  [itemB add:gridA]; [gridA release];

  //then swap our non-affected arrays
  [_labels exchangeObjectAtIndex:indexA withObjectAtIndex:indexB];
  [_images exchangeObjectAtIndex:indexA withObjectAtIndex:indexB];
}
//----------------------------------------------------------------------------------------------------------------------------------
-(void)removeItemAtIndex:(int)index
{
  if(index >= _count) return;
  if(index < 0) return;
  if(index == _selectedIndex) _selectedIndex = -1;
  if(index <  _selectedIndex) _selectedIndex--;
  GtkEventBox *item = (GtkEventBox *)[_items objectAtIndex:index];
  [_labels removeObjectAtIndex:index];
  [_images removeObjectAtIndex:index];
  [_items  removeObjectAtIndex:index];

  //unfortunately, it seems rebuilding the grid is the only sane thing to do here...
  //i really wish there was a gtk_grid_delete_row/gtk_grid_remove_row.
  //(the real solution is probably not using a GtkGrid at all...)
  GtkGrid *newGrid = [GtkGrid grid];
  newGrid.forceEqualRows    = _grid.forceEqualRows;
  newGrid.forceEqualColumns = _grid.forceEqualColumns;
  newGrid.rowSpacing        = _grid.rowSpacing;
  newGrid.columnSpacing     = _grid.columnSpacing;
  int newGridIndex = 0;
  for(GtkWidget *widget in _items)
  {
    [_grid remove:widget];
    [newGrid attachWidget:widget left:0 top:newGridIndex++];
  }
  [_viewport remove:_grid];
  _grid = newGrid;
  [_viewport add:_grid];
  [_viewport showAll];
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
      //make sure currently selected item is visible
      {
        //TODO: once we get GtkAdjustments implemented (DO NEED!), rewrite this block
        //NOTE: and maybe some helpers in GtkWidget or GtkViewport?
        void *vAdjust   = gtk_scrolled_window_get_vadjustment(NATIVE_SCROLLED);
        float maxScroll = (float)gtk_adjustment_get_upper(vAdjust);
        
             if(_selectedIndex == 0)          { gtk_adjustment_set_value(vAdjust, 0.0      ); } //easy case
        else if(_selectedIndex == (_count-1)) { gtk_adjustment_set_value(vAdjust, maxScroll); } //easy case
        else
        {
          GtkEventBox *nextItem = (GtkEventBox *)[_items objectAtIndex:_selectedIndex+1];
          int canvasInt; 
          gtk_widget_translate_coordinates(item.native, _grid.native, 0,0, NULL,&canvasInt);
          float canvasTop    = (float)canvasInt;
          gtk_widget_translate_coordinates(nextItem.native, _grid.native, 0,0, NULL,&canvasInt);
          float canvasBottom = (float)canvasInt;

          float windowSize   = (float)gtk_adjustment_get_page_size(vAdjust);
          float windowTop    = (float)gtk_adjustment_get_value(vAdjust);
          float windowBottom = windowTop + windowSize;

          //see if we need to scroll into view
          if(windowTop > canvasTop)
            gtk_adjustment_set_value(vAdjust, (double)canvasTop);
          else if(windowBottom < canvasBottom)
            gtk_adjustment_set_value(vAdjust, (double)(windowTop + (canvasBottom - windowBottom)));
        }
      }
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
-(BOOL)onIndex:(int)index keyPressed:(unsigned int)keyCode raw:(uint16_t)rawCode group:(uint8_t)group isModifier:(BOOL)isModifier modifiers:(GtkModifier)modifiers
{
  if([_delegate respondsToSelector:@selector(gtkListBox:index:keyPressed:raw:group:isModifier:modifiers:)])
    return [_delegate gtkListBox:self index:index keyPressed:keyCode raw:rawCode group:group isModifier:isModifier modifiers:modifiers];
  return NO; //we didn't eat this event
}
//----------------------------------------------------------------------------------------------------------------------------------
-(BOOL)onIndex:(int)index clickedWithButton:(int)button
{
  if([_delegate respondsToSelector:@selector(gtkListBox:index:clickedWithButton:)])
    return [_delegate gtkListBox:self index:index clickedWithButton:button];
  return NO; //continue processing
}

//==================================================================================================================================
// Child Events
//==================================================================================================================================
-(BOOL)gtkWidget:(GtkWidget *)widget buttonPressed:(int)button clickCount:(int)clickCount local:(OMCoordinate)local root:(OMCoordinate)root modifiers:(GtkModifier)modifiers
{
  if(!native_is_gtk_type_named(widget.native,"GtkEventBox")) return NO;
  int keyedIndex = (int)[_items indexOfObjectIdenticalTo:widget];
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  if(clickCount == 2)
  {
    if(button == 1)
    {
      [self onIndexActivated:keyedIndex];
      return YES;
    }
    return NO;
  }
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  if(clickCount == 1)
  {
    BOOL retval = NO;
    if(button == 1)
    {
      [self onIndexChangedFrom:_selectedIndex to:keyedIndex];
      retval = YES;
    }
    return retval ? YES : [self onIndex:keyedIndex clickedWithButton:button];
  }
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  return NO;
}
//----------------------------------------------------------------------------------------------------------------------------------
-(BOOL)gtkWidget:(GtkWidget *)widget keyPressed:(unsigned int)keyCode raw:(uint16_t)rawCode group:(uint8_t)group isModifier:(BOOL)isModifier modifiers:(GtkModifier)modifiers
{
  if(!native_is_gtk_type_named(widget.native,"GtkEventBox")) return NO;
  int keyedIndex = (int)[_items indexOfObjectIdenticalTo:widget];

  //allow delegate to process key event first; and stop processing if they eat it
  if([self onIndex:keyedIndex keyPressed:keyCode raw:rawCode group:group isModifier:isModifier modifiers:modifiers])
    return YES;

  switch(keyCode)
  {
    //http://git.gnome.org/browse/gtk+/tree/gdk/gdkkeysyms.h
    case GDK_KEY_Up       : if(_selectedIndex > 0) self.selectedIndex--; return YES;
    case GDK_KEY_Down     :                        self.selectedIndex++; return YES;
    case GDK_KEY_Return   : [self onIndexActivated:keyedIndex];          return YES;
    case GDK_KEY_KP_Enter : [self onIndexActivated:keyedIndex];          return YES;
  }
  
  return NO; //not something we were interested in...
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
//----------------------------------------------------------------------------------------------------------------------------------
-(void)grabFocus
{
  if(_selectedIndex == -1) { [super grabFocus]; return; }
  [(GtkEventBox *)[_items objectAtIndex:_selectedIndex] grabFocus];
}

//==================================================================================================================================
@end

//==================================================================================================================================
//----------------------------------------------------------------------------------------------------------------------------------
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
