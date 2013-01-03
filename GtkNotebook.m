//==================================================================================================================================
// GtkNotebook.m
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
#import "GtkNotebook.h"

//==================================================================================================================================
#define NATIVE_WIDGET   ((struct _GtkWidget   *)_native)
#define NATIVE_NOTEBOOK ((struct _GtkNotebook *)_native)
#define ADENOSINE_NOTEBOOK_LOOKUP_STRING "_adenosine_notebook_id"

//==================================================================================================================================
// Signal/Event -> Object Proxies
//==================================================================================================================================
static void ConnectionProxy_PageAdded(struct _GtkNotebook *notebook, struct _GtkWidget *child, unsigned int index, void *data)
{
  GtkNotebook *obj = (GtkNotebook *)[GtkWidget nativeToWrapper:notebook];
  [obj onPageAdded:[GtkWidget nativeToWrapper:child] atIndex:(int)index];
}
//----------------------------------------------------------------------------------------------------------------------------------
static void ConnectionProxy_PageRemoved(struct _GtkNotebook *notebook, struct _GtkWidget *child, unsigned int index, void *data)
{
  GtkNotebook *obj = (GtkNotebook *)[GtkWidget nativeToWrapper:notebook];
  [obj onPageRemoved:[GtkWidget nativeToWrapper:child] fromIndex:(int)index];
}
//----------------------------------------------------------------------------------------------------------------------------------
static void ConnectionProxy_PageReordered(struct _GtkNotebook *notebook, struct _GtkWidget *child, unsigned int index, void *data)
{
  GtkNotebook *obj = (GtkNotebook *)[GtkWidget nativeToWrapper:notebook];
  [obj onPageReordered:[GtkWidget nativeToWrapper:child] toIndex:(int)index];
}
//----------------------------------------------------------------------------------------------------------------------------------
static void ConnectionProxy_PageChanged(struct _GtkNotebook *notebook, struct _GtkWidget *child, unsigned int index, void *data)
{
  GtkNotebook *obj = (GtkNotebook *)[GtkWidget nativeToWrapper:notebook];
  [obj onPageChanged:[GtkWidget nativeToWrapper:child] toIndex:(int)index];
}

//==================================================================================================================================
@implementation GtkNotebook

//==================================================================================================================================
// Constructors/Desctructor
//==================================================================================================================================
+ notebook
{
  return [[[self alloc] initNotebook] autorelease];
}
//----------------------------------------------------------------------------------------------------------------------------------
- init
{
  self = [super init];
  if(self)
    _isReorderable = NO;
  return self;
}
//----------------------------------------------------------------------------------------------------------------------------------
- initNotebook
{
  self = [super init];
  if(self)
  {
    _native = gtk_notebook_new();
    _isReorderable = NO;
    [self installNativeLookup];
  }
  return self;
}

//==================================================================================================================================
// Properties
//==================================================================================================================================
-(GtkPosition)tabPosition                      { return (GtkPosition)gtk_notebook_get_tab_pos(NATIVE_NOTEBOOK);           }
-(void)setTabPosition:(GtkPosition)tabPosition { gtk_notebook_set_tab_pos(NATIVE_NOTEBOOK, (GtkPositionType)tabPosition); }
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-(BOOL)showTabs                                { return gtk_notebook_get_show_tabs(NATIVE_NOTEBOOK);                      }
-(void)setShowTabs:(BOOL)showTabs              { gtk_notebook_set_show_tabs(NATIVE_NOTEBOOK, showTabs);                   }
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-(BOOL)showBorder                              { return gtk_notebook_get_show_border(NATIVE_NOTEBOOK);                    }
-(void)setShowBorder:(BOOL)showBorder          { gtk_notebook_set_show_border(NATIVE_NOTEBOOK, showBorder);               }
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-(BOOL)isScrollable                            { return gtk_notebook_get_scrollable(NATIVE_NOTEBOOK);                     }
-(void)setIsScrollable:(BOOL)isScrollable      { gtk_notebook_set_scrollable(NATIVE_NOTEBOOK, isScrollable);              }
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-(int)activeIndex                              { return gtk_notebook_get_current_page(NATIVE_NOTEBOOK);                   }
-(void)setActiveIndex:(int)activeIndex         { gtk_notebook_set_current_page(NATIVE_NOTEBOOK, activeIndex);             }
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-(int)pageCount                                { return gtk_notebook_get_n_pages(NATIVE_NOTEBOOK);                        }
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-(OFString *)groupName { return [OFString stringWithUTF8String:gtk_notebook_get_group_name(NATIVE_NOTEBOOK)]; }
-(void)setGroupName:(OFString *)groupName
{
  if(groupName == nil) { gtk_notebook_set_group_name(NATIVE_NOTEBOOK, NULL); return; }
  OFAutoreleasePool *pool = [[OFAutoreleasePool alloc] init];
  gtk_notebook_set_group_name(NATIVE_NOTEBOOK, [groupName UTF8String]);
  [pool drain];
}
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-(OFString *)activeId { return [self idOfIndex:self.activeIndex]; }
-(void)setActiveId:(OFString *)activeId
{
  int idx = [self indexOfId:activeId];
  if(idx > -1) self.activeIndex = idx;
}
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-(BOOL)isReorderable                           { return _isReorderable; }
-(void)setIsReorderable:(BOOL)isReorderable
{
  _isReorderable = isReorderable;
  int max = self.pageCount;
  for(int i=0; i<max; i++)
    gtk_notebook_set_tab_reorderable(NATIVE_NOTEBOOK, [self pageOfIndex:i].native, isReorderable);
}
//----------------------------------------------------------------------------------------------------------------------------------
-(void)setDelegate:(id)delegate
{
  [super setDelegate:delegate];
  
  if(_delegate)
  {
    if([_delegate respondsToSelector:@selector(gtkNotebook:pageAdded:atIndex:)])
      [_connections addObject:[OFNumber numberWithUnsignedLong:
        g_signal_connect(_native, "page-added", G_CALLBACK(ConnectionProxy_PageAdded),NULL)]];

    if([_delegate respondsToSelector:@selector(gtkNotebook:pageRemoved:fromIndex:)])
      [_connections addObject:[OFNumber numberWithUnsignedLong:
        g_signal_connect(_native, "page-removed", G_CALLBACK(ConnectionProxy_PageRemoved),NULL)]];

    if([_delegate respondsToSelector:@selector(gtkNotebook:pageReordered:toIndex:)])
      [_connections addObject:[OFNumber numberWithUnsignedLong:
        g_signal_connect(_native, "page-reordered", G_CALLBACK(ConnectionProxy_PageReordered),NULL)]];

    if([_delegate respondsToSelector:@selector(gtkNotebook:pageChanged:toIndex:)])
      [_connections addObject:[OFNumber numberWithUnsignedLong:
        g_signal_connect(_native, "switch-page", G_CALLBACK(ConnectionProxy_PageChanged),NULL)]];
  }
}

//==================================================================================================================================
// Utilities
//==================================================================================================================================
-(void)appendPage:(GtkWidget *)page withTextLabel:(OFString *)text
{
  OFAutoreleasePool *pool = [[OFAutoreleasePool alloc] init];
  gtk_notebook_append_page(NATIVE_NOTEBOOK, page.native, gtk_label_new([text UTF8String]));
  [pool drain];
}
//----------------------------------------------------------------------------------------------------------------------------------
-(void)prependPage:(GtkWidget *)page withTextLabel:(OFString *)text
{
  OFAutoreleasePool *pool = [[OFAutoreleasePool alloc] init];
  gtk_notebook_prepend_page(NATIVE_NOTEBOOK, page.native, gtk_label_new([text UTF8String]));
  [pool drain];
}
//----------------------------------------------------------------------------------------------------------------------------------
-(void)insertPage:(GtkWidget *)page withTextLabel:(OFString *)text atIndex:(int)index
{
  OFAutoreleasePool *pool = [[OFAutoreleasePool alloc] init];
  gtk_notebook_insert_page(NATIVE_NOTEBOOK, page.native, gtk_label_new([text UTF8String]), index);
  [pool drain];
}
//----------------------------------------------------------------------------------------------------------------------------------
-(void)removePageAtIndex:(int)index
{
  gtk_notebook_remove_page(NATIVE_NOTEBOOK, index);
}
//==================================================================================================================================
-(void)appendPage:(GtkWidget *)page withTextLabel:(OFString *)text andID:(OFString *)id
{
  OFAutoreleasePool *pool = [[OFAutoreleasePool alloc] init];
  [page setProperty:@ADENOSINE_NOTEBOOK_LOOKUP_STRING toValue:id];
  gtk_notebook_append_page(NATIVE_NOTEBOOK, page.native, gtk_label_new([text UTF8String]));
  [pool drain];
}
//----------------------------------------------------------------------------------------------------------------------------------
-(void)prependPage:(GtkWidget *)page withTextLabel:(OFString *)text andID:(OFString *)id
{
  OFAutoreleasePool *pool = [[OFAutoreleasePool alloc] init];
  [page setProperty:@ADENOSINE_NOTEBOOK_LOOKUP_STRING toValue:id];
  gtk_notebook_prepend_page(NATIVE_NOTEBOOK, page.native, gtk_label_new([text UTF8String]));
  [pool drain];
}
//----------------------------------------------------------------------------------------------------------------------------------
-(void)insertPage:(GtkWidget *)page withTextLabel:(OFString *)text andID:(OFString *)idString atIndex:(int)index
{
  OFAutoreleasePool *pool = [[OFAutoreleasePool alloc] init];
  [page setProperty:@ADENOSINE_NOTEBOOK_LOOKUP_STRING toValue:idString];
  gtk_notebook_insert_page(NATIVE_NOTEBOOK, page.native, gtk_label_new([text UTF8String]), index);
  [pool drain];
}
//----------------------------------------------------------------------------------------------------------------------------------
-(void)removePageWithId:(OFString *)id
{
  int idx = [self indexOfId:id];
  if(idx > -1) [self removePageAtIndex:idx];
}
//==================================================================================================================================
-(int)indexOfPage:(GtkWidget *)widget
{
  return gtk_notebook_page_num(NATIVE_NOTEBOOK, widget.native);
}
//----------------------------------------------------------------------------------------------------------------------------------
-(GtkWidget *)pageOfIndex:(int)index
{
  void *noi = gtk_notebook_get_nth_page(NATIVE_NOTEBOOK, index);
  if(noi == NULL) return nil;
  return [GtkWidget nativeToWrapper:noi];
}
//----------------------------------------------------------------------------------------------------------------------------------
-(void)movePage:(GtkWidget *)page toIndex:(int)index
{
  int max = self.pageCount;
  if(index < 0   ) index = 0;     //overriding default -1 behavior here; maybe we shouldn't?
  if(index >= max) index = max-1;
  gtk_notebook_reorder_child(NATIVE_NOTEBOOK, page.native, index);
}
//==================================================================================================================================
-(int)indexOfId:(OFString *)idString
{
  int max = self.pageCount;
  for(int i=0; i<max; i++)
    if([(OFString *)[self idOfIndex:i] caseInsensitiveCompare:idString] == OF_ORDERED_SAME)
      return i;
  return -1;
}
//----------------------------------------------------------------------------------------------------------------------------------
-(OFString *)idOfIndex:(int)index
{
  if(index == -1) return nil;
  GtkWidget *poi = [self pageOfIndex:index];
  return [poi getProperty:@ADENOSINE_NOTEBOOK_LOOKUP_STRING];
}
//----------------------------------------------------------------------------------------------------------------------------------
-(void)moveId:(OFString *)idString toIndex:(int)index
{
  int ioi = [self indexOfId:idString];     if(ioi == -1) return;
  GtkWidget *poi = [self pageOfIndex:ioi]; if(poi == nil) return;
  [self movePage:poi toIndex:index];
}
//==================================================================================================================================
-(void)nextPage { int newIdx = self.activeIndex+1, pc = self.pageCount; if(newIdx >= pc) newIdx -= pc; self.activeIndex = newIdx; }
-(void)prevPage { int newIdx = self.activeIndex-1; if(newIdx < 0) newIdx += self.pageCount;            self.activeIndex = newIdx; }

//==================================================================================================================================
// Signal Handlers
//==================================================================================================================================
-(void)onPageAdded    :(GtkWidget *)page   atIndex:(int)index { [_delegate gtkNotebook:self pageAdded:page     atIndex:index]; }
-(void)onPageRemoved  :(GtkWidget *)page fromIndex:(int)index { [_delegate gtkNotebook:self pageRemoved:page fromIndex:index]; }
-(void)onPageReordered:(GtkWidget *)page   toIndex:(int)index { [_delegate gtkNotebook:self pageReordered:page toIndex:index]; }
-(void)onPageChanged  :(GtkWidget *)page   toIndex:(int)index { [_delegate gtkNotebook:self pageChanged:page   toIndex:index]; }

//==================================================================================================================================
@end

//==================================================================================================================================
//----------------------------------------------------------------------------------------------------------------------------------
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
