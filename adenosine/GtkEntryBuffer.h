//==================================================================================================================================
// GtkEntryBuffer.h
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

//==================================================================================================================================
@class GtkEntryBuffer;
@protocol GtkEntryBufferDelegate <OFObject>
@optional
-(void)gtkEntryBuffer:(GtkEntryBuffer *)buffer textDeleted:(of_range_t)range;
-(void)gtkEntryBuffer:(GtkEntryBuffer *)buffer textInserted:(of_range_t)range;
@end

//==================================================================================================================================
@interface GtkEntryBuffer : OFObject
{
  id              _delegate;
  void           *_native;
  OFMutableArray *_connections;
}

//----------------------------------------------------------------------------------------------------------------------------------
+ entryBuffer;
+ entryBufferWithText:(OFString *)text;
- initEntryBuffer;
- initWithText:(OFString *)text;

//----------------------------------------------------------------------------------------------------------------------------------
+ (BOOL) isWrapped:(void *)native;
+ nativeToWrapper:(void *)native;
+ wrapExistingNative:(void *)native;
- initWithExistingNative:(void *)native;
-(void)installNativeLookup;
-(void)destroy;

//----------------------------------------------------------------------------------------------------------------------------------
@property (readonly) void     *native;
@property (readonly) int       bytes;
@property (readonly) int       length;
@property (assign)   int       maxLength;
@property (assign)   OFString *text;
@property (retain)   id        delegate;

//----------------------------------------------------------------------------------------------------------------------------------
-(int)insertText:(OFString *)text atIndex:(int)index;
-(int)deleteTextRange:(of_range_t)range;

//----------------------------------------------------------------------------------------------------------------------------------
-(void)onTextDeleted:(of_range_t)range;
-(void)onTextInserted:(of_range_t)range;

//==================================================================================================================================
@end

//==================================================================================================================================
//----------------------------------------------------------------------------------------------------------------------------------
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
