public class Adzan.List : Gtk.Box {
    private Gtk.Label imsak_time;
    private Gtk.Label sunrise_time;
    // private Gtk.Label fajr_time;
    private Gtk.Label dhuhr_time;
    private Gtk.Label asr_time;
    private Gtk.Label maghrib_time;
    private Gtk.Label isha_time;
    private Gtk.Grid grid;
    private Gtk.Label prayer_now;
    private Gtk.Label countdown;
    public Gtk.Revealer revealer;
    
    private int imsak_hh = 00;
    private int imsak_mm = 00;
    private int fajr_hh = 00;
    private int fajr_mm = 00;
    private int sunrise_hh = 00;
    private int sunrise_mm = 00;
    private int dhuhr_hh = 00;
    private int dhuhr_mm = 00;
    private int asr_hh = 00;
    private int asr_mm = 00;
    private int maghrib_hh = 00;
    private int maghrib_mm = 00;
    private int isha_hh = 00;
    private int isha_mm = 00;

    public Gtk.CssProvider css_list;
    
    public Gtk.Label fajr_time;
    
    public static string current_location = "Gresik";
    public static string hijri_date = "";
    
    // public string uri = "http://api.aladhan.com/v1/timingsByCity?city=%s&country=ID&method=2".printf (current_location);

    Soup.Session session = new Soup.Session ();
    public Soup.Message message;
    Json.Parser parser = new Json.Parser ();
    
    private void load_data () {
        var uri = "http://api.aladhan.com/v1/timingsByCity?city=%s&country=ID&method=11".printf (current_location);
        message = new Soup.Message ("GET", uri);
        session.send_message (message);
        // message.finished.connect (message_cb);
        if(message.status_code == 200){
            get_prayer_times();
          }
    }

    construct {
        this.get_style_context ().add_class ("list");
        this.set_valign (Gtk.Align.CENTER);
        this.set_orientation (Gtk.Orientation.VERTICAL);
        this.set_spacing (20);

        // var uri = "http://api.aladhan.com/v1/timingsByCity?city=%s&country=ID&method=11".printf (current_location);

        // message = new Soup.Message ("GET", uri);
        // session.send_message (message);
        load_data ();


        var imsak_label = new Gtk.Label("Imsak");
        var sunrise_label = new Gtk.Label("Sunrise");
        var fajr_label = new Gtk.Label("Fajr");
        var dhuhr_label = new Gtk.Label("Dhuhr");
        var asr_label = new Gtk.Label("Asr");
        var maghrib_label = new Gtk.Label("Maghrib");
        var isha_label = new Gtk.Label("Isha");
        
        fajr_time.get_style_context ().add_class ("fajr_time");
        dhuhr_time.get_style_context ().add_class ("dhuhr_time");
        asr_time.get_style_context ().add_class ("asr_time");
        maghrib_time.get_style_context ().add_class ("maghrib_time");
        isha_time.get_style_context ().add_class ("isha_time");



        grid = new Gtk.Grid();
        grid.set_column_homogeneous(true);
        grid.set_row_spacing(21);
        grid.get_style_context ().add_class ("grid");
        // add (grid);

        grid.attach(imsak_label, 0,1,1,1);
        grid.attach(fajr_label, 0,2,1,1);
        grid.attach(sunrise_label, 0,3,1,1);
        grid.attach(dhuhr_label, 0,4,1,1);
        grid.attach(asr_label, 0,5,1,1);
        grid.attach(maghrib_label, 0,6,1,1);
        grid.attach(isha_label, 0,7,1,1);

        grid.attach(imsak_time, 1,1,1,1);
        grid.attach(fajr_time, 1,2,1,1);
        grid.attach(sunrise_time, 1,3,1,1);
        grid.attach(dhuhr_time, 1,4,1,1);
        grid.attach(asr_time, 1,5,1,1);
        grid.attach(maghrib_time, 1,6,1,1);
        grid.attach(isha_time, 1,7,1,1);

            // Create a new revealer widget
        var revealer = new Gtk.Revealer ();
        revealer.transition_type = SLIDE_UP;
        revealer.transition_duration = 500;

        // Add the label widget to the revealer
        revealer.add (grid);

        // create the reload button
        var button = new Gtk.ToggleButton();
        var on_image = new Gtk.Image.from_icon_name("pan-up-symbolic", Gtk.IconSize.BUTTON);
        var off_image = new Gtk.Image.from_icon_name("pan-down-symbolic", Gtk.IconSize.BUTTON);

        button.set_image (new Gtk.Image.from_icon_name ("pan-down-symbolic", Gtk.IconSize.BUTTON));

        button.toggled.connect (() => {

            // If the button is active, set a different image
            if (button.get_active ()) {
                button.set_image (new Gtk.Image.from_icon_name ("pan-up-symbolic", Gtk.IconSize.BUTTON));
                revealer.reveal_child = true;
               
            } else {
                // If the button is not active, set the default image
                button.set_image (new Gtk.Image.from_icon_name ("pan-down-symbolic", Gtk.IconSize.BUTTON));
                revealer.reveal_child = false;
            }
        });

        button.tooltip_text = "Toggle prayer times";
        button.halign = END;
        
        var bottom_bar = new Gtk.Grid();
        bottom_bar.set_column_homogeneous(true);
        
        prayer_now = new Gtk.Label("Adzan");
        prayer_now.halign = START;
        prayer_now.valign = BASELINE;
        prayer_now.get_style_context ().add_class ("prayer_now");
        
        countdown = new Gtk.Label ("");
        countdown.valign = BASELINE;
        countdown.get_style_context ().add_class ("location");
        
        bottom_bar.attach(prayer_now, 0,0,1,1);
        bottom_bar.attach(countdown,1,0,1,1);
        bottom_bar.attach(button,2,0,1,1);
        
        add (bottom_bar);
        

        add (revealer);

        var settings = new GLib.Settings ("com.github.hrstwn.adzan");
        settings.bind ("button-stat", button, "active", GLib.SettingsBindFlags.DEFAULT);
        
    }

    public void get_prayer_times (){
    
      css_list = new Gtk.CssProvider ();
      
      try {
          parser.load_from_data ((string) message.response_body.flatten ().data, -1);
          imsak_time = new Gtk.Label ("");
          fajr_time = new Gtk.Label ("");
          sunrise_time = new Gtk.Label ("");
          dhuhr_time = new Gtk.Label ("");
          asr_time = new Gtk.Label ("");
          maghrib_time = new Gtk.Label ("");
          isha_time = new Gtk.Label ("");
          
      }
      
      
      catch(GLib.Error e) {
          error (e.message);
      }
      
      
      var root_array = parser.get_root ().get_object ();
      var data = root_array.get_object_member ("data");

      var date = "%s".printf(data.get_object_member ("date").get_string_member ("readable"));
      
      hijri_date = "%s".printf(data.get_object_member ("date").get_object_member ("hijri").get_string_member ("day")) + " %s".printf(data.get_object_member ("date").get_object_member ("hijri").get_object_member ("month").get_string_member("en")) + " %s".printf(data.get_object_member ("date").get_object_member ("hijri").get_string_member("year"));
      
      var imsak_date = new Soup.Date.from_string("%s".printf(date) + " " + "%s:00".printf(data.get_object_member ("timings").get_string_member ("Imsak")));
      var fajr_date = new Soup.Date.from_string("%s".printf(date) + " " + "%s:00".printf(data.get_object_member ("timings").get_string_member ("Fajr")));
      var sunrise_date = new Soup.Date.from_string("%s".printf(date) + " " + "%s:00".printf(data.get_object_member ("timings").get_string_member ("Sunrise")));
      var dhuhr_date = new Soup.Date.from_string("%s".printf(date) + " " + "%s:00".printf(data.get_object_member ("timings").get_string_member ("Dhuhr")));
      var asr_date = new Soup.Date.from_string("%s".printf(date) + " " + "%s:00".printf(data.get_object_member ("timings").get_string_member ("Asr")));
      var maghrib_date = new Soup.Date.from_string("%s".printf(date) + " " + "%s:00".printf(data.get_object_member ("timings").get_string_member ("Maghrib")));
      var isha_date = new Soup.Date.from_string("%s".printf(date) + " " + "%s:00".printf(data.get_object_member ("timings").get_string_member ("Isha")));
      
      imsak_mm = imsak_date.get_minute();
      imsak_hh = imsak_date.get_hour();
      
      fajr_mm = fajr_date.get_minute();
      fajr_hh = fajr_date.get_hour();
      
      sunrise_mm = sunrise_date.get_minute();
      sunrise_hh = sunrise_date.get_hour();
      
      dhuhr_mm = dhuhr_date.get_minute();
      dhuhr_hh = dhuhr_date.get_hour();
      
      asr_mm = asr_date.get_minute();
      asr_hh = asr_date.get_hour();
      
      maghrib_mm = maghrib_date.get_minute();
      maghrib_hh = maghrib_date.get_hour();
      
      isha_mm = isha_date.get_minute();
      isha_hh = isha_date.get_hour();
      
      imsak_time.set_text ("%i:%i".printf(imsak_hh, imsak_mm));
      
      if (imsak_mm < 10) {
                imsak_time.set_text ("%i:0%i".printf(imsak_hh, imsak_mm));
            } else {
                imsak_time.set_text ("%i:%i".printf(imsak_hh, imsak_mm));
      }
      
      if (fajr_mm < 10) {
                fajr_time.set_text ("%i:0%i".printf(fajr_hh, fajr_mm));
            } else {
                fajr_time.set_text ("%i:%i".printf(fajr_hh, fajr_mm));
      }
      
      if (sunrise_mm < 10) {
                sunrise_time.set_text ("%i:0%i".printf(sunrise_hh, sunrise_mm));
            } else {
                sunrise_time.set_text ("%i:%i".printf(sunrise_hh, sunrise_mm));
      }
      
      if (dhuhr_mm < 10) {
                dhuhr_time.set_text ("%i:0%i".printf(dhuhr_hh, dhuhr_mm));
            } else {
                dhuhr_time.set_text ("%i:%i".printf(dhuhr_hh, dhuhr_mm));
      }
      
      if (asr_mm < 10) {
                asr_time.set_text ("%i:0%i".printf(asr_hh, asr_mm));
            } else {
                asr_time.set_text ("%i:%i".printf(asr_hh, asr_mm));
      }
      
      if (maghrib_mm < 10) {
                maghrib_time.set_text ("%i:0%i".printf(maghrib_hh, maghrib_mm));
            } else {
                maghrib_time.set_text ("%i:%i".printf(maghrib_hh, maghrib_mm));
      }
      
      if (isha_mm < 10) {
                isha_time.set_text ("%i:0%i".printf(isha_hh, isha_mm));
            } else {
                isha_time.set_text ("%i:%i".printf(isha_hh, isha_mm));
      }
      
      // fajr_time.set_text ("%s".printf(fajr_hh.to_string()) + ":" + "%s".printf (fajr_mm.to_string()));
      // sunrise_time.set_text ("%s".printf(sunrise_hh.to_string()) + ":" + "%s".printf (sunrise_mm.to_string()));
      // dhuhr_time.set_text ("%s".printf(dhuhr_hh.to_string()) + ":" + "%s".printf (dhuhr_mm.to_string()));
      // asr_time.set_text ("%s".printf(asr_hh.to_string()) + ":" + "%s".printf (asr_mm.to_string()));
      // maghrib_time.set_text ("%s".printf(maghrib_hh.to_string()) + ":" + "%s".printf (maghrib_mm.to_string()));
      // isha_time.set_text ("%s".printf(isha_hh.to_string()) + ":" + "%s".printf (isha_mm.to_string()));
      
      // isha_time.set_text ("Isha %s".printf(data.get_object_member ("timings").get_string_member ("Isha")));
    }
    
    public bool update () {
        var now = new DateTime.now_local();
        var hour = now.get_hour();
        var minute = now.get_minute();
        var time_int = int.parse("%i%02d".printf(hour, minute));
        
        
        var sunrise_time_str = sunrise_time.get_text();
        var sunrise_time_int = int.parse(sunrise_time_str.replace(":", ""));
        
        var fajr_time_str = fajr_time.get_text();
        var fajr_time_int = int.parse(fajr_time_str.replace(":", ""));
        
        var dhuhr_time_str = dhuhr_time.get_text();
        var dhuhr_time_int = int.parse(dhuhr_time_str.replace(":", ""));
        
        var asr_time_str = asr_time.get_text();
        var asr_time_int = int.parse(asr_time_str.replace(":", ""));
        
        var maghrib_time_str = maghrib_time.get_text();
        var maghrib_time_int = int.parse(maghrib_time_str.replace(":", ""));
        
        var isha_time_str = isha_time.get_text();
        var isha_time_int = int.parse(isha_time_str.replace(":", ""));
        
        // prayer_now.set_text("%i".printf (time_int));
        
        if (time_int >= fajr_time_int && time_int < sunrise_time_int) {
                prayer_now.set_text("Fajr");
                if (sunrise_hh-hour > 0){
                    countdown.set_text("%ih %i m".printf(sunrise_hh-hour,sunrise_mm-minute));
                }
                else {
                    countdown.set_text("%i min".printf(sunrise_mm-minute));
                }
            } 
        else if (time_int >= dhuhr_time_int && time_int < asr_time_int) {
                prayer_now.set_text("Dhuhr");
                if (asr_hh-hour > 0){
                    countdown.set_text("%ih %i m".printf(asr_hh-hour,asr_mm-minute));
                }
                else {
                    countdown.set_text("%i min".printf(asr_mm-minute));
                }
            } 
        else if (time_int >= asr_time_int && time_int < maghrib_time_int) {
                prayer_now.set_text("Asr");
                if (maghrib_hh-hour > 0){
                    countdown.set_text("%ih %i m".printf(maghrib_hh-hour,maghrib_mm-minute));
                }
                else {
                    countdown.set_text("%i min".printf(maghrib_mm-minute));
                }
        }
        else if (time_int >= maghrib_time_int && time_int < isha_time_int) {
                prayer_now.set_text("Maghrib");
                if (isha_hh-hour > 0){
                    countdown.set_text("%ih %i m".printf(isha_hh-hour,isha_mm-minute));
                }
                else {
                    countdown.set_text("%i min".printf(isha_mm-minute));
                }
        }
        else if (time_int >= isha_time_int || time_int < fajr_time_int) {
                prayer_now.set_text("Isha");
                if (fajr_hh+24-hour > 0 && fajr_hh+24-hour < 24 ){
                    countdown.set_text("%ih %i m".printf(fajr_hh+24-hour,fajr_mm+60-minute));
                }
                else if (fajr_hh+24-hour > 24) {
                    countdown.set_text("%ih %i m".printf(fajr_hh-hour,fajr_mm+60-minute));
                }
                else {
                    countdown.set_text("%i min".printf(fajr_mm+60-minute));
                }
        }
        
        else {
                prayer_now.set_text(" ");
        }
        
        return true;
    }
}
