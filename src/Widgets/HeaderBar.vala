public class Adzan.HeaderBar : Gtk.HeaderBar {
    public Gtk.CssProvider css_header;
    public Adzan.List list;
    
    
    public Gtk.Button reload;

    construct {
        var list = new Adzan.List ();
        
        if(list.message.status_code != 200){
            title = "Adzan";
        }
        else{
            title = list.hijri_date;
            // title = "%s • %s".printf(list.hijri_date,list.current_location);
        }
        

        show_close_button = true;
        css_header = new Gtk.CssProvider ();
        

        var headerbar_style_context = this.get_style_context ();
        headerbar_style_context.add_class ("default-decoration");
        headerbar_style_context.add_class (Gtk.STYLE_CLASS_FLAT);
        
        
        // reload = new Gtk.Button.from_icon_name("view-refresh-symbolic", SMALL_TOOLBAR);
        // pack_end(reload);
        
        
        try {
            css_header.load_from_data(""
                + ".default-decoration {background:#344D67;}"
            );
        }
        catch (GLib.Error e) {
            error (e.message);
        }

        Gtk.StyleContext.add_provider_for_screen (Gdk.Screen.get_default (), css_header, Gtk.STYLE_PROVIDER_PRIORITY_USER);
    }
    
}
