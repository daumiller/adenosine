//==================================================================================================================================
// GtkRuntime.m
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
#import "GtkNative.h"
#import "GtkRuntime.h"

//==================================================================================================================================
@implementation GtkRuntime

//==================================================================================================================================
static GtkRuntime *GtkRuntime_shared = nil;
static int    GtkRuntime_noargs_i = 0;
static char **GtkRuntime_noargs_s = NULL;

//----------------------------------------------------------------------------------------------------------------------------------
+ sharedRuntime
{
  if(GtkRuntime_shared == NULL)
    GtkRuntime_shared = [[GtkRuntime alloc] init];
  return GtkRuntime_shared;
}

//----------------------------------------------------------------------------------------------------------------------------------
@synthesize isRunning = _isRunning;

//----------------------------------------------------------------------------------------------------------------------------------
- (void)startup { gtk_init(&GtkRuntime_noargs_i, &GtkRuntime_noargs_s); }
- (void)startupWithArgC:(int *)argc andArgV:(char ***)argv { gtk_init(argc, argv); }
//----------------------------------------------------------------------------------------------------------------------------------
- (void)mainLoopBegin { _isRunning = YES; gtk_main();                        }
- (void)mainLoopQuit  { if(_isRunning) { _isRunning = NO; gtk_main_quit(); } }

@end
//==================================================================================================================================
//----------------------------------------------------------------------------------------------------------------------------------
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
