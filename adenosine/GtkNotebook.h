//==================================================================================================================================
// GtkNotebook.h
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
#import <adenosine/GtkContainer.h>

// !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
// TODO: custom Labels
// !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

//==================================================================================================================================
@class GtkNotebook;
@protocol GtkNotebookDelegate <OFObject>
@optional
-(void)gtkNotebook:(GtkNotebook *)notebook pageAdded    :(GtkWidget *)page   atIndex:(int)index;
-(void)gtkNotebook:(GtkNotebook *)notebook pageRemoved  :(GtkWidget *)page fromIndex:(int)index;
-(void)gtkNotebook:(GtkNotebook *)notebook pageReordered:(GtkWidget *)page   toIndex:(int)index;
-(void)gtkNotebook:(GtkNotebook *)notebook pageChanged  :(GtkWidget *)page   toIndex:(int)index;
@end

//==================================================================================================================================
@interface GtkNotebook : GtkContainer
{
  BOOL _isReorderable;
}

//----------------------------------------------------------------------------------------------------------------------------------
+ notebook;
- initNotebook;

//----------------------------------------------------------------------------------------------------------------------------------
@property (assign)   GtkPosition tabPosition;
@property (assign)   BOOL        showTabs;
@property (assign)   BOOL        showBorder;
@property (assign)   BOOL        isScrollable;
@property (assign)   int         activeIndex;
@property (readonly) int         pageCount;
@property (assign)   OFString   *groupName;
@property (assign)   OFString   *activeId;
@property (assign)   BOOL        isReorderable;

//----------------------------------------------------------------------------------------------------------------------------------
-(void) appendPage :(GtkWidget *)page withTextLabel:(OFString *)text;
-(void) prependPage:(GtkWidget *)page withTextLabel:(OFString *)text;
-(void) insertPage :(GtkWidget *)page withTextLabel:(OFString *)text atIndex:(int)index;
-(void) removePageAtIndex:(int)index;
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-(void) appendPage :(GtkWidget *)page withTextLabel:(OFString *)text andID:(OFString *)idString;
-(void) prependPage:(GtkWidget *)page withTextLabel:(OFString *)text andID:(OFString *)idString;
-(void) insertPage :(GtkWidget *)page withTextLabel:(OFString *)text andID:(OFString *)idString atIndex:(int)index;
-(void) removePageWithId:(OFString *)idString;
//----------------------------------------------------------------------------------------------------------------------------------
-(int)indexOfPage:(GtkWidget *)widget;
-(GtkWidget *)pageOfIndex:(int)index;
-(void)movePage:(GtkWidget *)page toIndex:(int)index;
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-(int)indexOfId:(OFString *)idString;
-(OFString *)idOfIndex:(int)index;
-(void)moveId:(OFString *)idString toIndex:(int)index;
//----------------------------------------------------------------------------------------------------------------------------------
-(void)nextPage;
-(void)prevPage;

//----------------------------------------------------------------------------------------------------------------------------------
-(void)onPageAdded    :(GtkWidget *)page   atIndex:(int)index;
-(void)onPageRemoved  :(GtkWidget *)page fromIndex:(int)index;
-(void)onPageReordered:(GtkWidget *)page   toIndex:(int)index;
-(void)onPageChanged  :(GtkWidget *)page   toIndex:(int)index;

//==================================================================================================================================
@end

//==================================================================================================================================
//----------------------------------------------------------------------------------------------------------------------------------
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
