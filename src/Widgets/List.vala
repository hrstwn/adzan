public class Adzan.List : Gtk.Box {
    private Gtk.Label imsak_time;
    private Gtk.Label sunrise_time;
    private Gtk.Label fajr_time;
    private Gtk.Label dhuhr_time;
    private Gtk.Label asr_time;
    private Gtk.Label maghrib_time;
    private Gtk.Label isha_time;

    Soup.Session session = new Soup.Session ();
    public Soup.Message message;
    Json.Parser parser = new Json.Parser ();

    construct {
      this.get_style_context ().add_class ("list");
      this.set_valign (Gtk.Align.CENTER);
      this.set_orientation (Gtk.Orientation.VERTICAL);
      this.set_spacing (20);

      var uri = "https://api.pray.zone/v2/times/today.json?city=%s".printf (Window.location);

      message = new Soup.Message ("GET", uri);
      session.send_message (message);

      get_prayer_times();
    }

    public void get_prayer_times (){
      
      try {
          parser.load_from_data ((string) message.response_body.flatten ().data, -1);
          imsak_time = new Gtk.Label ("");
          sunrise_time = new Gtk.Label ("");
          fajr_time = new Gtk.Label ("");
          dhuhr_time = new Gtk.Label ("");
          asr_time = new Gtk.Label ("");
          maghrib_time = new Gtk.Label ("");
          isha_time = new Gtk.Label ("");

          add (imsak_time);
          add (fajr_time);
          add (sunrise_time);
          add (dhuhr_time);
          add (asr_time);
          add (maghrib_time);
          add (isha_time);
      }
      catch(GLib.Error e) {
          error (e.message);
      }
      var root_array = parser.get_root ().get_object ();
      var results = root_array.get_object_member ("results");
      var datetime = results.get_array_member ("datetime");


      foreach (var times in datetime.get_elements ()) {
          var geoname = times.get_object ();
          var prayer_times = geoname.get_object_member ("times");

          imsak_time.set_text ("Imsak %s".printf(prayer_times.get_string_member ("Imsak")));
          sunrise_time.set_text ("Sunrise %s".printf(prayer_times.get_string_member ("Sunrise")));
          fajr_time.set_text ("Fajr %s".printf(prayer_times.get_string_member ("Fajr")));
          dhuhr_time.set_text ("Dhuhr %s".printf(prayer_times.get_string_member ("Dhuhr")));
          asr_time.set_text ("Asr %s".printf(prayer_times.get_string_member ("Asr")));
          maghrib_time.set_text ("Maghrib %s".printf(prayer_times.get_string_member ("Maghrib")));
          isha_time.set_text ("Isha %s".printf(prayer_times.get_string_member ("Isha")));
      }
    }
}
