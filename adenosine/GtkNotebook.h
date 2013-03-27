//==================================================================================================================================
// GtkNotebook.h
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
