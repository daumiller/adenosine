//==================================================================================================================================
// GtkBuilder.h
/*==================================================================================================================================
Copyright © 2012 Dillon Aumiller <dillonaumiller@gmail.com>

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

@class GtkWidget;

//==================================================================================================================================
@interface GtkBuilder : OFObject
{
  void *_native;
}

//----------------------------------------------------------------------------------------------------------------------------------
+ builder;
+ builderWithFile:(OFString *)filename;
+ builderWithString:(OFString *)string;
- init;
- initWithFile:(OFString *)filename;
- initWithString:(OFString *)string;

//----------------------------------------------------------------------------------------------------------------------------------
@property (readonly) void *native;

//----------------------------------------------------------------------------------------------------------------------------------
-(void *)nativeByName:(OFString *)name;
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-(GtkWidget      *)widgetByName     :(OFString *)name;
-(GtkLabel       *)labelByName      :(OFString *)name;
-(GtkButton      *)buttonByName     :(OFString *)name;
-(GtkImage       *)imageByName      :(OFString *)name;
-(GtkProgressBar *)progressBarByName:(OFString *)name;
-(GtkWindow      *)windowByName     :(OFString *)name;

//----------------------------------------------------------------------------------------------------------------------------------
-(BOOL)addFromFile:(OFString *)filename;
-(BOOL)addFromString:(OFString *)string;

//==================================================================================================================================
@end

//==================================================================================================================================
//----------------------------------------------------------------------------------------------------------------------------------
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
