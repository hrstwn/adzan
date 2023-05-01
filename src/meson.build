executable(
    meson.project_name(),

    'Main.vala',
    'Application.vala',
    'Widgets/Window.vala',
    'Widgets/HeaderBar.vala',
    'Widgets/List.vala',
    'Widgets/Clock.vala',


    dependencies: [
        dependency('gtk+-3.0'),
        dependency('libsoup-2.4'),
        dependency('json-glib-1.0'),
        dependency('libnotify'),
        dependency('granite'),
        dependency('glib-2.0')
    ],
    install:true
)
