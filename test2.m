#import <adenosine/adenosine.h>
#include <stdio.h>

//==================================================================================================================================
@interface TestDelegateA : OFObject <GtkButtonDelegate>
-(void)gtkButtonClicked:(GtkButton *)button;
@end
//----------------------------------------------------------------------------------------------------------------------------------
@interface TestDelegateB : OFObject <GtkButtonDelegate>
-(void)gtkButtonClicked:(GtkButton *)button;
@end

//==================================================================================================================================
@implementation TestDelegateA
-(void)gtkButtonClicked:(GtkButton *)button
{
  printf("Hello from Button \"%s\"...\n", [button.text UTF8String]);
}
@end
//----------------------------------------------------------------------------------------------------------------------------------
@implementation TestDelegateB
-(void)gtkButtonClicked:(GtkButton *)button
{
  [[GtkRuntime sharedRuntime] mainLoopQuit];
}
@end

//==================================================================================================================================
int main(int argc, char **argv)
{
  OFAutoreleasePool *pool = [[OFAutoreleasePool alloc] init];
  [[GtkRuntime sharedRuntime] startup];

  GtkWindow *window = [GtkWindow windowWithType:GTKWINDOWTYPE_TOPLEVEL];
  window.title = @"Gtk Grid Test";
  window.quitOnClose = YES;
  [window setBorderWidth:10];

  GtkGrid *grid = [GtkGrid grid];
  [window add:grid];

  GtkButton *button1 = [GtkButton buttonWithText:@"Button One"];
  [grid attachWidget:button1 left:0 top:0 width:1 height:1];

  GtkButton *button2 = [GtkButton buttonWithText:@"Button Two"];
  [grid attachWidget:button2 left:1 top:0 width:1 height:1];

  GtkButton *buttonQ = [GtkButton buttonWithAccel:@"_Quit"];
  [grid attachWidget:buttonQ left:0 top:1 width:2 height:1];

  TestDelegateA *delA = [[TestDelegateA alloc] init];
  button1.delegate = delA;
  button2.delegate = delA;

  TestDelegateB *delB = [[TestDelegateB alloc] init];
  buttonQ.delegate = delB;

  [window showAll];

  [[GtkRuntime sharedRuntime] mainLoopBegin];
  [pool drain];
  return 0;
}

/*
#include <gtk/gtk.h>
#include <stdio.h>

void sayHello(GtkWidget *widget, gpointer data)
{
  printf("Hello from Button %s!\n", (char *)data);
}

int main(int argc, char **argv)
{
  gtk_init(&argc, &argv);
  GtkWidget *window = gtk_window_new(GTK_WINDOW_TOPLEVEL);
  gtk_window_set_title(GTK_WINDOW(window), "Gtk Grid Test");
  g_signal_connect(window, "destroy", G_CALLBACK(gtk_main_quit), NULL);
  gtk_container_set_border_width(GTK_CONTAINER(window), 10);

  GtkWidget *grid = gtk_grid_new();
  gtk_container_add(GTK_CONTAINER(window), grid);

  GtkWidget *button1 = gtk_button_new_with_label("Button 1");
  g_signal_connect(button1, "clicked", G_CALLBACK(sayHello), "1");
  gtk_grid_attach(GTK_GRID(grid), button1, 0, 0, 1, 1);

  GtkWidget *button2 = gtk_button_new_with_label("Button 2");
  g_signal_connect(button2, "clicked", G_CALLBACK(sayHello), "2");
  gtk_grid_attach(GTK_GRID(grid), button2, 1, 0, 1, 1);

  GtkWidget *buttonQ = gtk_button_new_with_label("Quit");
  g_signal_connect(buttonQ, "clicked", G_CALLBACK(gtk_main_quit), NULL);
  gtk_grid_attach(GTK_GRID(grid), buttonQ, 0, 1, 2, 1);

  gtk_widget_show_all(window);

  gtk_main();
  return 0;
}
*/