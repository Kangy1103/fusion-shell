qt_add_qml_module(fusionshell-internal-niri
    URI FusionShell.Internal.Niri
    VERSION 1.0
    SOURCES
        niriipc.hpp niriipc.cpp
        nirisocket.hpp nirisocket.cpp
    NO_PLUGIN_OPTIONAL
)

target_link_libraries(fusionshell-internal-niri PRIVATE Qt::Quick Qt::Network)

set(MODULE_DIR "${CMAKE_INSTALL_PREFIX}/lib/qt6/qml/FusionShell/Internal/Niri")

install(TARGETS fusionshell-internal-niriplugin
    LIBRARY DESTINATION "${MODULE_DIR}"
)

install(FILES
    "${CMAKE_BINARY_DIR}/qml/FusionShell/Internal/Niri/qmldir"
    "${CMAKE_BINARY_DIR}/qml/FusionShell/Internal/Niri/fusionshell-internal-niri.qmltypes"
    DESTINATION "${MODULE_DIR}"
)

install(TARGETS fusionshell-internal-niri
    LIBRARY DESTINATION lib
)
