public class Adzan.Window : Gtk.ApplicationWindow {
    public int[] repeat;
    private uint timeout_id;

    public GLib.Settings settings;
    public Gtk.CssProvider css_provider;
    public const string location = "surabaya";

    private Gtk.Box main;
    private Gtk.Stack stack;

    public Window (MyApplication MyApp){
      Object (
          application : MyApp
      );
    }

    construct {
      get_style_context ().add_class ("rounded");
      settings = new GLib.Settings ("com.github.hrstwn.adzan");

      move (settings.get_int ("pos-x"), settings.get_int ("pos-y"));
      this.set_size_request (480, 200);
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

      // custom style
      try {
          css_provider.load_from_data(""
              + ".main {margin: 10px;margin-top:0px;}"
              + ".cover {background:url('./../data/image/cover.dawn.png') #a3ba6a;background-size:cover; background-position:bottom; border-radius:4px; color:#fff;box-shadow:0 0px 3px #8C6C61;padding:20px;font-size: 11pt;margin:10px;}"
              + ".clock {font-size:56px;font-weight:lighter;}"
              + ".icon {color:#fff;background:transparent;padding:0;}"
              + ".list {margin: 10px;font-size: 16pt;background:transparent; color:#555;}"
              + ".sub {font-size:12px;}"
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


      Clock.edit_icon.clicked.connect (() => {
          list.get_prayer_times ();
      });

      if(list.message.status_code == 200)
      {
          main.add(list);
          show_all ();
      }
      show_all ();
    }


    public bool before_destroy(){
      int width, height, x, y;

      get_size (out width, out height);
      get_position (out x, out y);

      settings.set_int ("pos-x", x);
      settings.set_int ("pos-y", y);
      settings.set_int ("window-width", width);
      settings.set_int ("window-height", height);

      return false;
    }
}
