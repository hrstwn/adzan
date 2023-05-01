public class Adzan.Window : Gtk.ApplicationWindow {
    
    
    public int[] repeat;
    private uint timeout_id;

    public GLib.Settings settings;
    public Gtk.CssProvider css_provider;

    private Gtk.Box main;
    private Gtk.Stack stack;
    
    public string window_css = "";

    public Window (MyApplication MyApp){
      Object (
          application : MyApp
      );
    }

    construct {
      get_style_context ().add_class ("rounded");
      settings = new GLib.Settings ("com.github.hrstwn.adzan");

      move (settings.get_int ("pos-x"), settings.get_int ("pos-y"));
      this.set_size_request (450, 100);
      this.set_resizable (false);
      this.set_type_hint (Gdk.WindowTypeHint.DIALOG);

      delete_event.connect (e =>{
          return before_destroy();
      });

      var headerbar = new Adzan.HeaderBar ();
      var list = new Adzan.List ();
      var cover = new Adzan.Clock ();

      set_titlebar (headerbar);

      css_provider = new Gtk.CssProvider ();

      // custom style if offline
      if(list.message.status_code != 200){
        try {
          window_css = "window {background:#344D67;} .main{margin-bottom:20px;}";
        }
        catch (GLib.Error e) {
          error (e.message);
        }
      }
      
      else{
        try {
          window_css = "window {background:#344D67;} .main{background-image:url('/usr/share/images/background.svg');}";
        }
        catch (GLib.Error e) {
          error (e.message);
        }
      }

      
      try {
          css_provider.load_from_data(""
              + ".main {background: #344D67;background-size:cover; background-position:right;border-radius:6px; margin: 0px;margin-top:0px;}"
              + ".cover {color:white;background:transparent; border-radius:0px; padding:0px;font-size: 11pt;margin:-10px 0 0 0;}"
              + ".clock {font-size:64px;font-weight:lighter;margin:5px;}"
              + ".icon {background:transparent;padding:0;}"
              + ".list {margin:-15px 0 0px 0;background:transparent; color:#555;font-size:16px;}"
              + ".sub {font-size:12px;}"
              + ".grid {padding:32px;margin:0;background:white;border-radius:6px;}"
              + ".titlebutton, .image-button, .title{background:transparent;color:white;-gtk-icon-shadow:none;text-shadow:none;} .image-button{padding:15px;margin-bottom:-20px;}"
              + ".prayer_now{color:white; font-weight:bold;padding:15px;margin-bottom:-20px;font-size:12px;}"
              + ".location{color:white;padding:15px;margin-bottom:-20px;font-size:12px;}"
              + "%s".printf(window_css)
          );
      }
      catch (GLib.Error e) {
          error (e.message);
      }
      
      

      Gtk.StyleContext.add_provider_for_screen (Gdk.Screen.get_default (), css_provider, Gtk.STYLE_PROVIDER_PRIORITY_USER);

      main = new Gtk.Box (Gtk.Orientation.VERTICAL, 10);
      main.get_style_context ().add_class ("main");

      stack = new Gtk.Stack();

      stack.add(cover);

      main.add(stack);

      add(main);
      timeout_id = Timeout.add (40, cover.update);


      // Clock.edit_icon.clicked.connect (() => {
      //     list.get_prayer_times ();
      // });

      if(list.message.status_code == 200)
      {
          Timeout.add (40, list.update);
          
          main.add(list);
          show_all ();
      }
      
      show_all ();
    }


    public bool before_destroy(){
      int x, y;

      get_position (out x, out y);

      settings.set_int ("pos-x", x);
      settings.set_int ("pos-y", y);
      
      return false;
    }
}
