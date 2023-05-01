public class Adzan.Clock : Gtk.Box {
    public Gtk.Label loc;
    private Gtk.Label clock;
    public Gtk.Label cal;
    private Gtk.Box label_container;
    public static Gtk.Button edit_icon;
    
    // public static string location = "gresik";


    construct {

      this.get_style_context ().add_class ("cover");
      this.set_orientation (Gtk.Orientation.VERTICAL);
      this.set_valign (Gtk.Align.CENTER);
      // this.set_size_request(0,200);
      label_container = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 10);
      label_container.set_halign (Gtk.Align.CENTER);
      clock = new Gtk.Label ("");
      clock.get_style_context ().add_class ("clock");
      loc = new Gtk.Label (List.current_location);
      cal = new Gtk.Label (List.hijri_date);
      loc.get_style_context ().add_class ("location");

      edit_icon = new Gtk.Button.from_icon_name ("edit-symbolic");
      edit_icon.set_tooltip_text("Edit");
      edit_icon.set_relief (NONE);
      edit_icon.get_style_context ().add_class ("icon");
      
      // label_container.add (edit_icon);
      var list = new Adzan.List ();

      if(list.message.status_code != 200)
      {
          add (label_container);
          add (clock);
          label_container.add (loc);
          
          loc.set_text ("Can't receive data.");
          return;
      }
      else {
          // add (cal);
          add (label_container);
          add (clock);
          label_container.add (loc);
      }
    }

    public bool update () {
            var now = new DateTime.now_local();
            
            if (now.get_minute () < 10) {
                    clock.set_text ("%i:0%i".printf (now.get_hour (), now.get_minute ()));
                } else {
                    clock.set_text ("%i:%i".printf (now.get_hour (), now.get_minute ()));
            }
            
            return true;
    }
}
