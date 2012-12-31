#import <adenosine/adenosine.h>

@interface TalkDelegate : OFObject
-(void)gtkButtonClicked:(GtkButton *)button;
@end

@implementation TalkDelegate
-(void)gtkButtonClicked:(GtkButton *)button
{
  printf("Hello World!\n");
  GtkImage *img = (GtkImage *)[button getProperty:@"imageTarget"];
  [img setImageFromStock:@"gtk-dialog-warning" size:GTKICONSIZE_DIALOG];
}
@end

int main(int argc, char **argv)
{
  OFAutoreleasePool *pool = [[OFAutoreleasePool alloc] init];
  [[GtkRuntime sharedRuntime] startup];

  GtkBuilder *builder = [GtkBuilder builderWithFile:@"test5.ui"];

  GtkWindow *wndMain  = [builder widgetByName:@"wndMain"];
  [wndMain wrapAllChildren];
  wndMain.quitOnClose = YES;

  GtkImage *imgIcon = [builder widgetByName:@"imgIcon"];
  [imgIcon setImageFromFile:@"gtkImageLoadTest.png"];

  GtkButton *btnTalk    = [builder widgetByName:@"btnTalk"];
  btnTalk.delegate      = [[[TalkDelegate alloc] init] autorelease];
  btnTalk.text          = @"gtk-about";
  btnTalk.textIsStockId = YES;
  [btnTalk setProperty:@"imageTarget" toValue:imgIcon];

  GtkProgressBar *prgStatus = [builder widgetByName:@"prgStatus"];
  prgStatus.value    = 0.75f;
  prgStatus.text     = @"loading...";
  prgStatus.showText = YES;

  [[GtkRuntime sharedRuntime] mainLoopBegin];
  [pool drain];
  return 0;
}

/*
#include <gtk/gtk.h>

static void sayHello(GtkWidget *widget, gpointer data)
{
  printf("Hello World!\n");
}

int main(int argc, char **argv)
{
  GtkBuilder *builder;
  GObject *window, *button, *image, *progress;

  gtk_init(&argc, &argv);

  builder = gtk_builder_new();
  gtk_builder_add_from_file(builder, "test5.ui", NULL);

  window = gtk_builder_get_object(builder, "wndMain");
  g_signal_connect(window, "destroy", G_CALLBACK(gtk_main_quit), NULL);

  button = gtk_builder_get_object(builder, "btnTalk");
  g_signal_connect(button, "clicked", G_CALLBACK(sayHello), NULL);

  image = gtk_builder_get_object(builder, "imgIcon");
  gtk_image_set_from_file((GtkImage *)image, "gtkImageLoadTest.png");

  progress = gtk_builder_get_object(builder, "prgStatus");
  gtk_progress_bar_set_fraction((GtkProgressBar *)progress, 0.75);
  gtk_progress_bar_set_text((GtkProgressBar *)progress, "loading...");
  gtk_progress_bar_set_show_text((GtkProgressBar *)progress, TRUE);

  gtk_main();
  return 0;
}
*/
