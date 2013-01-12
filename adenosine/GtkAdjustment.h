//==================================================================================================================================
// GtkAdjustment.h
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
@class GtkAdjustment;
@protocol GtkAdjustmentDelegate <OFObject>
@optional
-(void)gtkAdjustmentChanged:(GtkAdjustment *)adjustment;
-(void)gtkAdjustment:(GtkAdjustment *)adjustment valueChangedTo:(float)value;
@end

//==================================================================================================================================
@interface GtkAdjustment : OFObject
{
  void           *_native;
  id              _delegate;
  OFMutableArray *_connections;
}

//----------------------------------------------------------------------------------------------------------------------------------
+ (BOOL) isWrapped:(void *)native;
+ nativeToWrapper:(void *)native;
+ wrapExistingNative:(void *)native;
- initWithExistingNative:(void *)native;
-(void)installNativeLookup;
-(void)destroy;

//----------------------------------------------------------------------------------------------------------------------------------
@property (readonly) void *native;
@property (assign)   float value;
@property (assign)   float lower;
@property (assign)   float upper;
@property (assign)   float pageSize;
@property (assign)   float pageIncrement;
@property (assign)   float stepIncrement;
@property (assign)   id    delegate;

//----------------------------------------------------------------------------------------------------------------------------------
-(void)movePageOverRangeLower:(float)lower upper:(float)upper;
-(void)configureValue:(float)value lower:(float)lower upper:(float)upper pageSize:(float)pageSize pageIncrement:(float)pageInc stepIncrement:(float)stepInc;
-(float)minimumIncrement;
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-(void)emitChanged;
-(void)emitValueChanged;

//----------------------------------------------------------------------------------------------------------------------------------
-(void)onChanged;
-(void)onValueChanged;

//==================================================================================================================================
@end

//==================================================================================================================================
//----------------------------------------------------------------------------------------------------------------------------------
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
