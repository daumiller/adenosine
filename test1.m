//==================================================================================================================================
#import <ObjFW/ObjFW.h>
#import <adenosine/adenosine.h>
#include <stdio.h>

//==================================================================================================================================
@interface TestDelegate : OFObject <GtkWindowDelegate, GtkButtonDelegate>
-(BOOL)gtkWindowShouldClose:(GtkWindow *)window;
-(void)gtkWindowDidClose:(GtkWindow *)window;
-(void)gtkButtonClicked:(GtkButton *)button;
@end

//==================================================================================================================================
@implementation TestDelegate
-(BOOL)gtkWindowShouldClose:(GtkWindow *)window
{
  printf("Deciding if we should close window \"%s\"\n", [window.title UTF8String]);
  return NO;
}
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-(void)gtkWindowDidClose:(GtkWindow *)window
{
  printf("Window did close...\n");
}
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-(void)gtkButtonClicked:(GtkButton *)button
{
  printf("Button was Clicked...\n");
  GtkWindow *window = [button getProperty:@"myTargetWindow"];
  [window destroy];
}
@end

//==================================================================================================================================
int main(int argc, char **argv)
{
  OFAutoreleasePool *pool = [[OFAutoreleasePool alloc] init];
  [[GtkRuntime sharedRuntime] startup];

  TestDelegate *testDel = [[TestDelegate alloc] init];
  GtkWindow *window = [GtkWindow windowWithType:GTKWINDOWTYPE_TOPLEVEL];
  window.title = @"Gtk Test 1";
  window.quitOnClose = YES;

  window.delegate = testDel;
  [window setBorderWidth:10];

  GtkButton *button = [GtkButton buttonWithText:@"Gtk Button"];
  button.delegate = testDel;
  [button setProperty:@"myTargetWindow" toValue:window];

  [window add:button];
  [button show];
  [window show];

  [[GtkRuntime sharedRuntime] mainLoopBegin];
  [pool drain];
  return 0;
}

/*
#include <gtk/gtk.h>
#include <stdio.h>

void sayHello(GtkWidget *widget, gpointer data)
{
  printf("Hello World!\n");
}

gboolean shouldCloseWindow(GtkWidget *widget, GdkEvent *event, gpointer data)
{
  printf("delete-event occured\n");
  return TRUE;
}

int main(int argc, char **argv)
{
  gtk_init(&argc, &argv);
  GtkWidget *window = gtk_window_new(GTK_WINDOW_TOPLEVEL);
  gtk_window_set_title(GTK_WINDOW(window), "Gtk Test 1");

  g_signal_connect(window, "delete-event", G_CALLBACK(shouldCloseWindow), NULL);
  g_signal_connect(window, "destroy", G_CALLBACK(gtk_main_quit), NULL);
  gtk_container_set_border_width(GTK_CONTAINER(window), 10);

  GtkWidget *button = gtk_button_new_with_label("GTK Button");
  g_signal_connect(button, "clicked", G_CALLBACK(sayHello), NULL);
  g_signal_connect_swapped(button, "clicked", G_CALLBACK(gtk_widget_destroy), window);

  gtk_container_add(GTK_CONTAINER(window), button);
  gtk_widget_show(button);
  gtk_widget_show(window);

  gtk_main();
  return 0;
}
*/
