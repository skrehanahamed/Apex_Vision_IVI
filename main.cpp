#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QQuickStyle>
#include <QFontDatabase>
#include <QFont>
#include <memory>

#include "backend/VehicleSimulator.h"
#include "backend/VehicleBackend.h"
#include "backend/ClimateBackend.h"
#include "backend/MediaBackend.h"
#include "backend/NavigationBackend.h"
#include "backend/PhoneBackend.h"
#include "backend/SystemBackend.h"
#include <QtWebEngineQuick/qtwebenginequickglobal.h>

int main(int argc, char *argv[])
{
    // High DPI and performance flags for Raspberry Pi / desktop
    QGuiApplication::setApplicationName("APEX VISION IVI");
    QGuiApplication::setOrganizationName("APEX");
    QGuiApplication::setOrganizationDomain("apex.vision");

    QGuiApplication app(argc, argv);
    QtWebEngineQuick::initialize();

    // Dark style for Controls
    QQuickStyle::setStyle("Basic");

    // Load bundled Inter fonts into Qt application font database
    QFontDatabase::addApplicationFont(":/qt/qml/ApexVision/qml/assets/fonts/Inter-Regular.ttf");
    QFontDatabase::addApplicationFont(":/qt/qml/ApexVision/qml/assets/fonts/Inter-Medium.ttf");
    QFontDatabase::addApplicationFont(":/qt/qml/ApexVision/qml/assets/fonts/Inter-SemiBold.ttf");
    QFontDatabase::addApplicationFont(":/qt/qml/ApexVision/qml/assets/fonts/Inter-Bold.ttf");
    QFontDatabase::addApplicationFont(":/ApexVision/qml/assets/fonts/Inter-Regular.ttf");
    QFontDatabase::addApplicationFont(":/ApexVision/qml/assets/fonts/Inter-Medium.ttf");
    QFontDatabase::addApplicationFont(":/ApexVision/qml/assets/fonts/Inter-SemiBold.ttf");
    QFontDatabase::addApplicationFont(":/ApexVision/qml/assets/fonts/Inter-Bold.ttf");

    // Set Inter as global UI default typeface
    QFont interFont("Inter", 16);
    interFont.setStyleStrategy(QFont::PreferAntialias);
    QGuiApplication::setFont(interFont);

    // Instantiate simulation and IVI backend services
    auto simulator = std::make_unique<VehicleSimulator>();
    auto vehicleBackend = std::make_unique<VehicleBackend>(simulator.get());
    auto climateBackend = std::make_unique<ClimateBackend>();
    auto mediaBackend = std::make_unique<MediaBackend>(simulator.get());
    auto navigationBackend = std::make_unique<NavigationBackend>(simulator.get());
    auto phoneBackend = std::make_unique<PhoneBackend>();
    auto systemBackend = std::make_unique<SystemBackend>();

    QQmlApplicationEngine engine;

    // Register backend services into QML context
    QQmlContext *rootContext = engine.rootContext();
    rootContext->setContextProperty("VehicleBackend", vehicleBackend.get());
    rootContext->setContextProperty("ClimateBackend", climateBackend.get());
    rootContext->setContextProperty("MediaBackend", mediaBackend.get());
    rootContext->setContextProperty("NavigationBackend", navigationBackend.get());
    rootContext->setContextProperty("PhoneBackend", phoneBackend.get());
    rootContext->setContextProperty("SystemBackend", systemBackend.get());

    const QUrl url(QStringLiteral("qrc:/ApexVision/qml/Main.qml"));
    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreated,
        &app,
        [url](QObject *obj, const QUrl &objUrl) {
            if (!obj && url == objUrl) {
                QCoreApplication::exit(-1);
            }
        },
        Qt::QueuedConnection);

    engine.load(url);

    return app.exec();
}
