aslis_gtk_sources = [
  'main.vala',
  'application.vala',
  'pages/aslis_app.vala',
  'pages/window.vala',
  'pages/add_modal.vala',
  'model/ternak.vala',
  'model/kandang.vala',
  'model/sample.vala',
  'model/grid_ternak.vala',
]

aslis_gtk_deps = [
  dependency('gtk4'),
  dependency('gee-0.8'),
  dependency('glib-2.0'),
]

aslis_gtk_sources += gnome.compile_resources('aslis-gtk-resources',
  'aslis-gtk.gresource.xml',
  c_name: 'aslis_gtk'
)

executable('aslis-gtk', aslis_gtk_sources,
  dependencies: aslis_gtk_deps,
       install: true,
)
