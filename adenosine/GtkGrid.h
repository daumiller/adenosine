//==================================================================================================================================
// GtkGrid.h
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
#import <adenosine/GtkContainer.h>

//==================================================================================================================================
@interface GtkGrid : GtkContainer

//----------------------------------------------------------------------------------------------------------------------------------
@property (assign) BOOL forceEqualRows;
@property (assign) BOOL forceEqualColumns;
@property (assign) unsigned int rowSpacing;
@property (assign) unsigned int columnSpacing;

//----------------------------------------------------------------------------------------------------------------------------------
+ grid;
- initGrid;

//----------------------------------------------------------------------------------------------------------------------------------
-(void)attachWidget:(GtkWidget *)widget left:(int)left top:(int)top;
-(void)attachWidget:(GtkWidget *)widget left:(int)left top:(int)top width:(int)colWidth height:(int)rowHeight;
-(void)attachWidget:(GtkWidget *)widget nextTo:(GtkWidget *)sibling onSide:(GtkPosition)position width:(int)colWidth height:(int)rowHeight;
-(GtkWidget *)childAtColumn:(int)x andRow:(int)y;
-(void *)nativeAtColumn:(int)x andRow:(int)y;
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-(void)insertRowAtIndex:(int)index;
-(void)insertColumnAtIndex:(int)index;
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-(void)attachSpacerLeft:(int)left top:(int)top width:(int)colWidth height:(int)rowHeight;
-(void)attachSpacerLeft:(int)left top:(int)top width:(int)colWidth height:(int)rowHeight hExpand:(BOOL)hExpand hAlign:(GtkAlign)hAlign vExpand:(BOOL)vExpand vAlign:(GtkAlign)vAlign;
-(void)attachSpacerLeft:(int)left top:(int)top pixelWidth:(int)width pixelHeight:(int)height;

@end
//==================================================================================================================================
//----------------------------------------------------------------------------------------------------------------------------------
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
