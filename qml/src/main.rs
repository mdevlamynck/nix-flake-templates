use cstr::cstr;
use qmetaobject::prelude::*;

// The `QObject` custom derive macro allows to expose a class to Qt and QML
#[derive(QObject, Default)]
struct Greeter {
    // Specify the base class with the qt_base_class macro
    base: qt_base_class!(trait QObject),
    // Declare `name` as a property usable from Qt
    name: qt_property!(QString; NOTIFY name_changed),
    // Declare a signal
    name_changed: qt_signal!(),
    // And even a slot
    compute_greetings: qt_method!(fn compute_greetings(&self, verb: String) -> QString {
        format!("{} {}", verb, self.name.to_string()).into()
    })
}

fn main() {
    // Register the `Greeter` struct to QML
    qml_register_type::<Greeter>(cstr!("Greeter"), 1, 0, cstr!("Greeter"));
    // Create a QML engine from rust
    let mut engine = QmlEngine::new();
    // (Here the QML code is inline, but one can also load from a file)
    engine.load_data(r#"
        import QtQuick 2.6
        import QtQuick.Window 2.0
        import org.kde.kirigami 2.13 as Kirigami

        // Import our Rust classes
        import Greeter 1.0

        Kirigami.ApplicationWindow {
            visible: true
            // Instantiate the rust struct
            Greeter {
                id: greeter;
                // Set a property
                name: "World"
            }
            Text {
                anchors.centerIn: parent
                // Call a method
                text: greeter.compute_greetings("hello")
            }
        }
    "#.into());
    engine.exec();
}
