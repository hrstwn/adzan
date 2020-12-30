public class MyApplication : Gtk.Application {
    public static GLib.Settings settings;

    public MyApplication () {
        Object (
            application_id: "com.github.hrstwn.adzan",
            flags: ApplicationFlags.FLAGS_NONE
        );
    }

    static construct {
    settings = new Settings ("com.github.hrstwn.adzan");
}

    protected override void activate (){
        var window = new Adzan.Window (this);

        add_window (window);
    }

}
