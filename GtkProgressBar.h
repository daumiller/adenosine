//==================================================================================================================================
// GtkProgressBar.h
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
#import <adenosine/GtkMisc.h>

//==================================================================================================================================
@interface GtkProgressBar : GtkWidget

//----------------------------------------------------------------------------------------------------------------------------------
+ progressBar;
- init;

//----------------------------------------------------------------------------------------------------------------------------------
@property (assign) float     value;
@property (assign) float     pulseDelta;
@property (assign) BOOL      inverted;
@property (assign) BOOL      showText;
@property (assign) BOOL      textUseEllipsis;
@property (assign) OFString *text;

//----------------------------------------------------------------------------------------------------------------------------------
-(void)pulse;

//==================================================================================================================================
@end

//==================================================================================================================================
//----------------------------------------------------------------------------------------------------------------------------------
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
