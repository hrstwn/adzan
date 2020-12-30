public class Adzan.HeaderBar : Gtk.HeaderBar {
    public Gtk.CssProvider css_header;

    construct {
        title = "Adzan";

        show_close_button = true;
        css_header = new Gtk.CssProvider ();

        var headerbar_style_context = this.get_style_context ();
        headerbar_style_context.add_class ("default-decoration");
        headerbar_style_context.add_class (Gtk.STYLE_CLASS_FLAT);

        Gtk.StyleContext.add_provider_for_screen (Gdk.Screen.get_default (), css_header, Gtk.STYLE_PROVIDER_PRIORITY_USER);


    }
}
