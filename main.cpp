/**
 * ==============================================================================
 * Project: Apex VISION IVI - Digital Cockpit & Infotainment System
 * File: main.cpp
 * Author / Developer: Sk Rehan Ahamed
 * License: MIT
 * ==============================================================================
 */

#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QQuickStyle>
#include <QFontDatabase>
#include <QFont>
#include <memory>

#include "backend/PersistenceManager.h"
#include "backend/VehicleSimulator.h"
#include "backend/VehicleBackend.h"
#include "backend/ClimateBackend.h"
#include "backend/MediaBackend.h"
#include "backend/NavigationBackend.h"
#include "backend/PhoneBackend.h"
#include "backend/SystemBackend.h"
#include "backend/VideoBackend.h"
#include "backend/AmbientLightBackend.h"
#include "backend/SeatBackend.h"
#include "backend/RejuvenateController.h"
#ifdef HAVE_WEBENGINE
#include <QtWebEngineQuick/qtwebenginequickglobal.h>
#include <QWebEngineProfile>
#endif
#include <QDir>
#include <QFileInfo>
#include <QDebug>
#include <QQuickWindow>
#include <QTimer>
#include <QImage>
#include <QResource>

#include <QLoggingCategory>

int main(int argc, char *argv[])
{
    // Silence benign font, WebEngine, and debug noise in terminal
    qputenv("QT_LOGGING_RULES", "qt.text.font.*=false;js.warning=false;default.debug=false;*.debug=false");
    QLoggingCategory::setFilterRules("qt.text.font.*=false\njs.warning=false\ndefault.debug=false\n*.debug=false");

    // High DPI and performance flags for Raspberry Pi / desktop
    QGuiApplication::setApplicationName("APEX VISION IVI");
    QGuiApplication::setOrganizationName("APEX");
    QGuiApplication::setOrganizationDomain("apex.vision");

#ifdef HAVE_WEBENGINE
    // Autoplay policy for embedded IVI media playback & WebGL acceleration for Google Maps
    qputenv("QTWEBENGINE_CHROMIUM_FLAGS", "--no-sandbox --autoplay-policy=no-user-gesture-required --disable-features=WebGPU --enable-webgl --ignore-gpu-blocklist");
    QtWebEngineQuick::initialize();
#endif

    QGuiApplication app(argc, argv);
#ifdef HAVE_WEBENGINE
    // Enable persistent disk caching so Google Maps loads rapidly from local storage
    QWebEngineProfile::defaultProfile()->setHttpCacheType(QWebEngineProfile::DiskHttpCache);
    QWebEngineProfile::defaultProfile()->setPersistentCookiesPolicy(QWebEngineProfile::AllowPersistentCookies);
    // Modern Chrome desktop user-agent to ensure Google Maps loads in full WebGL 3D mode
    QWebEngineProfile::defaultProfile()->setHttpUserAgent("Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36");
#endif

    // Dark style for Controls
    QQuickStyle::setStyle("Basic");

    // Register external binary resource bundle (assets.rcc)
    const QStringList rccSearchPaths = {
        QCoreApplication::applicationDirPath() + "/assets.rcc",
        QCoreApplication::applicationDirPath() + "/../Resources/assets.rcc",
        QDir::currentPath() + "/assets.rcc",
        QDir::currentPath() + "/build/assets.rcc"
    };
    for (const QString &rccPath : rccSearchPaths) {
        if (QFileInfo::exists(rccPath) && QResource::registerResource(rccPath)) {
            qInfo() << "[APEX IVI] Successfully registered binary resource:" << rccPath;
            break;
        }
    }

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
    auto persistenceManager = std::make_unique<PersistenceManager>();
    auto simulator = std::make_unique<VehicleSimulator>();
    auto vehicleBackend = std::make_unique<VehicleBackend>(simulator.get(), persistenceManager.get());
    auto climateBackend = std::make_unique<ClimateBackend>();
    auto mediaBackend = std::make_unique<MediaBackend>(simulator.get(), persistenceManager.get());
    auto navigationBackend = std::make_unique<NavigationBackend>(simulator.get());
    auto phoneBackend = std::make_unique<PhoneBackend>();
    auto systemBackend = std::make_unique<SystemBackend>(persistenceManager.get());
    auto videoBackend = std::make_unique<VideoBackend>();
    auto ambientLightBackend = std::make_unique<AmbientLightBackend>();
    auto seatBackend = std::make_unique<SeatBackend>();
    auto rejuvenateController = std::make_unique<RejuvenateController>(
        climateBackend.get(),
        ambientLightBackend.get(),
        seatBackend.get(),
        vehicleBackend.get(),
        mediaBackend.get()
    );

    QQmlApplicationEngine engine;

    // Register backend services into QML context
    QQmlContext *rootContext = engine.rootContext();
    rootContext->setContextProperty("PersistenceManager", persistenceManager.get());
    rootContext->setContextProperty("MemoryManager", persistenceManager.get());
    rootContext->setContextProperty("VehicleBackend", vehicleBackend.get());
    rootContext->setContextProperty("ClimateBackend", climateBackend.get());
    rootContext->setContextProperty("MediaBackend", mediaBackend.get());
    rootContext->setContextProperty("NavigationBackend", navigationBackend.get());
    rootContext->setContextProperty("PhoneBackend", phoneBackend.get());
    rootContext->setContextProperty("SystemBackend", systemBackend.get());
    rootContext->setContextProperty("VideoBackend", videoBackend.get());
    rootContext->setContextProperty("AmbientLightBackend", ambientLightBackend.get());
    rootContext->setContextProperty("SeatBackend", seatBackend.get());
    rootContext->setContextProperty("RejuvenateController", rejuvenateController.get());

    // Register 3D Climate Cabin import paths and QML source URL
    QString appDir = QCoreApplication::applicationDirPath();
    engine.addImportPath(appDir);
    engine.addImportPath(appDir + "/qml");
    engine.addImportPath(appDir + "/qml/climate3d");
    engine.addImportPath(appDir + "/qml/climate3d/CarModel");
    engine.addImportPath(appDir + "/qml/climate3d/SeatModel");
    engine.addImportPath(QDir::currentPath());
    engine.addImportPath(QDir::currentPath() + "/qml/climate3d");
    engine.addImportPath(QDir::currentPath() + "/qml/climate3d/CarModel");
    engine.addImportPath(QDir::currentPath() + "/qml/climate3d/SeatModel");

    QStringList climateCandidates = {
        appDir + "/qml/climate3d/ClimateCabinView.qml",
        appDir + "/../qml/climate3d/ClimateCabinView.qml",
        QDir::currentPath() + "/qml/climate3d/ClimateCabinView.qml",
        "/Users/reno/Projects/APEX_VISION_IVI/qml/climate3d/ClimateCabinView.qml"
    };
    QUrl climate3dUrl;
    for (const QString &cand : climateCandidates) {
        if (QFileInfo::exists(cand)) {
            climate3dUrl = QUrl::fromLocalFile(QFileInfo(cand).canonicalFilePath());
            break;
        }
    }
    qInfo() << "[APEX IVI] Resolved 3D Climate Model View URL:" << climate3dUrl;
    rootContext->setContextProperty("Climate3DViewUrl", climate3dUrl);

    QStringList studioCandidates = {
        appDir + "/qml/climate3d/VehicleStudioView.qml",
        appDir + "/../qml/climate3d/VehicleStudioView.qml",
        QDir::currentPath() + "/qml/climate3d/VehicleStudioView.qml",
        "/Users/reno/Projects/APEX_VISION_IVI/qml/climate3d/VehicleStudioView.qml"
    };
    QUrl vehicleStudioUrl;
    for (const QString &cand : studioCandidates) {
        if (QFileInfo::exists(cand)) {
            vehicleStudioUrl = QUrl::fromLocalFile(QFileInfo(cand).canonicalFilePath());
            break;
        }
    }
    qInfo() << "[APEX IVI] Resolved 3D Vehicle Studio View URL:" << vehicleStudioUrl;
    rootContext->setContextProperty("VehicleStudioViewUrl", vehicleStudioUrl);

    QStringList seatCandidates = {
        appDir + "/qml/climate3d/SeatStudioView.qml",
        appDir + "/../qml/climate3d/SeatStudioView.qml",
        QDir::currentPath() + "/qml/climate3d/SeatStudioView.qml",
        "/Users/reno/Projects/APEX_VISION_IVI/qml/climate3d/SeatStudioView.qml"
    };
    QUrl seatStudioUrl;
    for (const QString &cand : seatCandidates) {
        if (QFileInfo::exists(cand)) {
            seatStudioUrl = QUrl::fromLocalFile(QFileInfo(cand).canonicalFilePath());
            break;
        }
    }
    qInfo() << "[APEX IVI] Resolved 3D Seat Studio View URL:" << seatStudioUrl;
    rootContext->setContextProperty("SeatStudioViewUrl", seatStudioUrl);

    QStringList laneKeepingCandidates = {
        appDir + "/qml/climate3d/LaneKeepingCarView3D.qml",
        appDir + "/../qml/climate3d/LaneKeepingCarView3D.qml",
        QDir::currentPath() + "/qml/climate3d/LaneKeepingCarView3D.qml",
        "/Users/reno/Projects/APEX_VISION_IVI/qml/climate3d/LaneKeepingCarView3D.qml"
    };
    QUrl laneKeeping3dUrl;
    for (const QString &cand : laneKeepingCandidates) {
        if (QFileInfo::exists(cand)) {
            laneKeeping3dUrl = QUrl::fromLocalFile(QFileInfo(cand).canonicalFilePath());
            break;
        }
    }
    qInfo() << "[APEX IVI] Resolved 3D Lane Keeping Car View URL:" << laneKeeping3dUrl;
    rootContext->setContextProperty("LaneKeeping3DCarUrl", laneKeeping3dUrl);

    const QUrl url(QStringLiteral("qrc:/ApexVision/qml/Main.qml"));
    qInfo() << "[APEX IVI] Calling engine.load()...";
    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreated,
        &app,
        [url](QObject *obj, const QUrl &objUrl) {
            qInfo() << "[APEX IVI] objectCreated signal received. obj:" << obj << "url:" << objUrl;
            if (!obj && url == objUrl) {
                qCritical() << "[APEX IVI] FATAL: Failed to load root QML object!";
                QCoreApplication::exit(-1);
            }
        },
        Qt::QueuedConnection);

    engine.load(url);
    qInfo() << "[APEX IVI] engine.load() returned. rootObjects count:" << engine.rootObjects().count();

    if (!engine.rootObjects().isEmpty()) {
        QObject *rootObj = engine.rootObjects().first();
        if (app.arguments().contains("--climate-open")) {
            QObject *climateBar = rootObj->findChild<QObject*>("climateBar");
            if (climateBar) {
                climateBar->setProperty("climate3DOpen", true);
            }
        }

        if (app.arguments().contains("--fan-menu")) {
            QObject *climateBar = rootObj->findChild<QObject*>("climateBar");
            if (climateBar) {
                QTimer::singleShot(500, [climateBar]() {
                    climateBar->setProperty("fanMenuOpen", true);
                });
            }
        }

        if (app.arguments().contains("--seat-menu")) {
            QObject *climateBar = rootObj->findChild<QObject*>("climateBar");
            if (climateBar) {
                QTimer::singleShot(500, [climateBar]() {
                    climateBar->setProperty("driverSeatMenuOpen", true);
                });
            }
        }

        if (app.arguments().contains("--rear-view")) {
            QObject *climate3DPanel = rootObj->findChild<QObject*>("climate3DPanel");
            if (climate3DPanel) {
                climate3DPanel->setProperty("isRearView", true);
            }
        }

        if (app.arguments().contains("--climate-air-refresh") || app.arguments().contains("--climate-air-refresh-active")) {
            QObject *climateBar = rootObj->findChild<QObject*>("climateBar");
            if (climateBar) {
                climateBar->setProperty("climate3DOpen", true);
            }
            const bool setActive = app.arguments().contains("--climate-air-refresh-active");
            QTimer::singleShot(500, [rootObj, setActive]() {
                QObject *climate3DPanel = rootObj->findChild<QObject*>("climate3DPanel");
                if (climate3DPanel) {
                    climate3DPanel->setProperty("airQualityMenuOpen", true);
                }
                if (setActive) {
                    QTimer::singleShot(200, [rootObj]() {
                        QObject *airQualityOverlay = rootObj->findChild<QObject*>("airQualityOverlay");
                        if (airQualityOverlay) {
                            airQualityOverlay->setProperty("isRefreshing", true);
                        }
                    });
                }
            });
        }

        if (app.arguments().contains("--page-vehicle") || app.arguments().contains("--status-tire") || app.arguments().contains("--status-oil") || app.arguments().contains("--seats") || app.arguments().contains("--valet-mode")) {
            QObject *pageStack = rootObj->findChild<QObject*>("pageStack");
            if (pageStack) {
                pageStack->setProperty("currentIndex", 1);
            }
        }

        if (app.arguments().contains("--page-apps")) {
            QObject *pageStack = rootObj->findChild<QObject*>("pageStack");
            if (pageStack) {
                pageStack->setProperty("currentIndex", 2);
            }
        }

        if (app.arguments().contains("--page-video")) {
            QObject *pageStack = rootObj->findChild<QObject*>("pageStack");
            if (pageStack) {
                pageStack->setProperty("currentIndex", 8);
            }
        }

        if (app.arguments().contains("--video-search")) {
            QObject *pageStack = rootObj->findChild<QObject*>("pageStack");
            if (pageStack) {
                pageStack->setProperty("currentIndex", 8);
            }
            QObject *videoPage = rootObj->findChild<QObject*>("videoPage");
            if (videoPage) {
                videoPage->setProperty("searchActive", true);
                videoPage->setProperty("showTouchKeyboard", true);
            }
        }

        if (app.arguments().contains("--open-video")) {
            QObject *pageStack = rootObj->findChild<QObject*>("pageStack");
            if (pageStack) {
                pageStack->setProperty("currentIndex", 8);
            }
            QTimer::singleShot(600, [vb = videoBackend.get()]() {
                QVariantList list = vb->videos();
                if (!list.isEmpty()) {
                    vb->selectVideo(list.first().toMap());
                }
            });
        }

        if (app.arguments().contains("--test-video-fs")) {
            QObject *pageStack = rootObj->findChild<QObject*>("pageStack");
            if (pageStack) {
                pageStack->setProperty("currentIndex", 8);
            }
            QTimer::singleShot(600, [vb = videoBackend.get()]() {
                QVariantList list = vb->videos();
                if (!list.isEmpty()) {
                    vb->selectVideo(list.first().toMap());
                }
            });
            QTimer::singleShot(1500, [rootObj]() {
                QObject *videoPage = rootObj->findChild<QObject*>("videoPage");
                if (videoPage) {
                    QMetaObject::invokeMethod(videoPage, "enterFullScreen");
                }
            });
        }

        if (app.arguments().contains("--seats")) {
            QStringList args = app.arguments();
            QTimer::singleShot(500, [rootObj, args]() {
                QObject *vehiclePage = rootObj->findChild<QObject*>("vehiclePage");
                qInfo() << "[MAIN DEBUG] finding vehiclePage:" << vehiclePage;
                if (vehiclePage) {
                    vehiclePage->setProperty("ambientLightingPageOpen", false);
                    vehiclePage->setProperty("vehicleStatusPageOpen", false);
                    vehiclePage->setProperty("seatsPageOpen", true);

                    if (args.contains("--seats-studio")) {
                        vehiclePage->setProperty("inSeatsStudio", true);
                        vehiclePage->setProperty("seatStudioTab", "seat");
                    } else if (args.contains("--seats-massage")) {
                        vehiclePage->setProperty("inSeatsStudio", true);
                        vehiclePage->setProperty("seatStudioTab", "massage");
                        vehiclePage->setProperty("massageActive", true);
                    } else if (args.contains("--seats-second-row")) {
                        vehiclePage->setProperty("inSeatsStudio", false);
                        vehiclePage->setProperty("seatsSubMenu", "second_row");
                    } else if (args.contains("--seats-passenger")) {
                        vehiclePage->setProperty("inSeatsStudio", false);
                        vehiclePage->setProperty("seatsSubMenu", "passenger");
                    } else {
                        vehiclePage->setProperty("inSeatsStudio", false);
                        vehiclePage->setProperty("seatsSubMenu", "second_row");
                    }

                    if (args.contains("--target-passenger")) {
                        bool ok = vehiclePage->setProperty("seatsActiveTarget", "passenger");
                        qInfo() << "[MAIN DEBUG] set seatsActiveTarget to passenger:" << ok << vehiclePage->property("seatsActiveTarget");
                    } else if (args.contains("--target-driver")) {
                        bool ok = vehiclePage->setProperty("seatsActiveTarget", "driver");
                        qInfo() << "[MAIN DEBUG] set seatsActiveTarget to driver:" << ok << vehiclePage->property("seatsActiveTarget");
                    }

                    for (int i = 0; i < args.size(); ++i) {
                        if (args[i] == "--massage-program" && i + 1 < args.size()) {
                            vehiclePage->setProperty("massageProgram", args[i + 1]);
                        }
                    }
                }
            });
        }

        if (app.arguments().contains("--test-air-quality-close")) {
            QObject *climateBar = rootObj->findChild<QObject*>("climateBar");
            if (climateBar) {
                climateBar->setProperty("climate3DOpen", true);
            }
            QTimer::singleShot(600, [rootObj]() {
                QObject *climate3DPanel = rootObj->findChild<QObject*>("climate3DPanel");
                if (climate3DPanel) {
                    climate3DPanel->setProperty("airQualityMenuOpen", true);
                }
            });
            QTimer::singleShot(1400, [rootObj]() {
                QObject *airQualityOverlay = rootObj->findChild<QObject*>("airQualityOverlay");
                if (airQualityOverlay) {
                    QMetaObject::invokeMethod(airQualityOverlay, "closeRequested");
                }
            });
            QQuickWindow *win = qobject_cast<QQuickWindow*>(rootObj);
            if (win) {
                QTimer::singleShot(2200, [win, &app]() {
                    win->grabWindow().save("/Users/reno/.gemini/antigravity-ide/brain/a7c3fc73-2ee3-47a5-8c9c-e48b19351792/.tempmediaStorage/air_quality_closed_to_main_menu.png");
                    app.quit();
                });
            }
        }

        if (app.arguments().contains("--test-sidebar-reset")) {
            QObject *pageStack = rootObj->findChild<QObject*>("pageStack");
            if (pageStack) {
                pageStack->setProperty("currentIndex", 1);
            }
            QTimer::singleShot(500, [rootObj]() {
                QObject *vehiclePage = rootObj->findChild<QObject*>("vehiclePage");
                if (vehiclePage) {
                    vehiclePage->setProperty("seatsPageOpen", true);
                    vehiclePage->setProperty("inSeatsStudio", true);
                    vehiclePage->setProperty("seatStudioTab", "seat");
                }
            });
            QTimer::singleShot(1200, [rootObj]() {
                QObject *sideNav = rootObj->findChild<QObject*>("sideNav");
                if (sideNav) {
                    QMetaObject::invokeMethod(sideNav, "pageSelected", Q_ARG(int, 1));
                }
            });
            QQuickWindow *win = qobject_cast<QQuickWindow*>(rootObj);
            if (win) {
                QTimer::singleShot(1800, [win, &app]() {
                    win->grabWindow().save("/Users/reno/.gemini/antigravity-ide/brain/a7c3fc73-2ee3-47a5-8c9c-e48b19351792/.tempmediaStorage/sidebar_pressed_resets_to_initial_screen.png");
                    app.quit();
                });
            }
        }

        if (app.arguments().contains("--capture-massage-intro")) {
            QQuickWindow *win = qobject_cast<QQuickWindow*>(rootObj);
            if (win) {
                // Step 1: chair rotating from back to initial pos (mid-rotation, no glow)
                QTimer::singleShot(1000, [win]() {
                    win->grabWindow().save("/Users/reno/.gemini/antigravity-ide/brain/a7c3fc73-2ee3-47a5-8c9c-e48b19351792/.tempmediaStorage/step1_rotating_from_back.png");
                });
                // Step 2: chair settled in initial pos, blue color appears on middle backrest
                QTimer::singleShot(2000, [win]() {
                    win->grabWindow().save("/Users/reno/.gemini/antigravity-ide/brain/a7c3fc73-2ee3-47a5-8c9c-e48b19351792/.tempmediaStorage/step2_blue_color_comes.png");
                });
                // Step 3: light glow comes (firefly active)
                QTimer::singleShot(2800, [win, &app]() {
                    win->grabWindow().save("/Users/reno/.gemini/antigravity-ide/brain/a7c3fc73-2ee3-47a5-8c9c-e48b19351792/.tempmediaStorage/step3_light_glow_comes.png");
                    app.quit();
                });
            }
        }

        if (app.arguments().contains("--capture-seat-studio")) {
            QQuickWindow *win = qobject_cast<QQuickWindow*>(rootObj);
            if (win) {
                QTimer::singleShot(1500, [win, &app]() {
                    win->grabWindow().save("/Users/reno/.gemini/antigravity-ide/brain/a7c3fc73-2ee3-47a5-8c9c-e48b19351792/.tempmediaStorage/seat_mode_clean_dialer.png");
                    app.quit();
                });
            }
        }

        if (app.arguments().contains("--status-tire")) {
            QTimer::singleShot(250, [rootObj]() {
                QObject *vehiclePage = rootObj->findChild<QObject*>("vehiclePage");
                if (vehiclePage) {
                    vehiclePage->setProperty("ambientLightingPageOpen", false);
                    vehiclePage->setProperty("vehicleStatusPageOpen", true);
                    vehiclePage->setProperty("vehicleStatusTab", "tire");
                }
            });
        }

        if (app.arguments().contains("--status-oil")) {
            QTimer::singleShot(250, [rootObj]() {
                QObject *vehiclePage = rootObj->findChild<QObject*>("vehiclePage");
                if (vehiclePage) {
                    vehiclePage->setProperty("ambientLightingPageOpen", false);
                    vehiclePage->setProperty("vehicleStatusPageOpen", true);
                    vehiclePage->setProperty("vehicleStatusTab", "oil");
                }
            });
        }

        if (app.arguments().contains("--valet-mode")) {
            QTimer::singleShot(400, [rootObj]() {
                QObject *vehiclePage = rootObj->findChild<QObject*>("vehiclePage");
                if (vehiclePage) {
                    vehiclePage->setProperty("ambientLightingPageOpen", false);
                    vehiclePage->setProperty("vehicleStatusPageOpen", false);
                    vehiclePage->setProperty("seatsPageOpen", false);
                    vehiclePage->setProperty("valetModePageOpen", true);
                    vehiclePage->setProperty("valetStep", 1);
                }
            });
        }

        if (app.arguments().contains("--valet-locked")) {
            QTimer::singleShot(400, [rootObj]() {
                QObject *vehiclePage = rootObj->findChild<QObject*>("vehiclePage");
                if (vehiclePage) {
                    vehiclePage->setProperty("isValetLocked", true);
                }
            });
        }

        if (app.arguments().contains("--ambient-lighting")) {
            QObject *pageStack = rootObj->findChild<QObject*>("pageStack");
            if (pageStack) {
                pageStack->setProperty("currentIndex", 1);
            }
            QTimer::singleShot(500, [rootObj]() {
                QObject *vehiclePage = rootObj->findChild<QObject*>("vehiclePage");
                if (vehiclePage) {
                    vehiclePage->setProperty("vehicleStatusPageOpen", false);
                    vehiclePage->setProperty("ambientLightingPageOpen", true);
                }
            });

            if (app.arguments().contains("--capture-ambient-frames")) {
                QQuickWindow *win = qobject_cast<QQuickWindow*>(rootObj);
                if (win) {
                    QTimer::singleShot(600, [win]() { win->grabWindow().save("/Users/reno/.gemini/antigravity-ide/brain/a7c3fc73-2ee3-47a5-8c9c-e48b19351792/.tempmediaStorage/ambient_100ms.png"); });
                    QTimer::singleShot(750, [win]() { win->grabWindow().save("/Users/reno/.gemini/antigravity-ide/brain/a7c3fc73-2ee3-47a5-8c9c-e48b19351792/.tempmediaStorage/ambient_250ms.png"); });
                    QTimer::singleShot(900, [win]() { win->grabWindow().save("/Users/reno/.gemini/antigravity-ide/brain/a7c3fc73-2ee3-47a5-8c9c-e48b19351792/.tempmediaStorage/ambient_400ms.png"); });
                    QTimer::singleShot(1100, [win]() { win->grabWindow().save("/Users/reno/.gemini/antigravity-ide/brain/a7c3fc73-2ee3-47a5-8c9c-e48b19351792/.tempmediaStorage/ambient_600ms.png"); });
                    QTimer::singleShot(1400, [win, &app]() {
                        win->grabWindow().save("/Users/reno/.gemini/antigravity-ide/brain/a7c3fc73-2ee3-47a5-8c9c-e48b19351792/.tempmediaStorage/ambient_900ms.png");
                        app.quit();
                    });
                }
            }
        }

        if (app.arguments().contains("--am-source")) {
            mediaBackend->setSource("AM");
        }

        if (app.arguments().contains("--save-preset")) {
            mediaBackend->setSource("AM");
            mediaBackend->saveCurrentAsPreset();
        }

        if (app.arguments().contains("--page-radio")) {
            mediaBackend->setSource("AM");
            QObject *pageStack = rootObj->findChild<QObject*>("pageStack");
            if (pageStack) {
                pageStack->setProperty("currentIndex", 7);
            }
        }

        if (app.arguments().contains("--orbitxm") || app.arguments().contains("--page-orbitxm")) {
            mediaBackend->setSource("OrbitXM");
            QObject *pageStack = rootObj->findChild<QObject*>("pageStack");
            if (pageStack) {
                pageStack->setProperty("currentIndex", 7);
            }
        }

        if (app.arguments().contains("--sxm-channel")) {
            int chIdx = app.arguments().indexOf("--sxm-channel");
            if (chIdx + 1 < app.arguments().size()) {
                int chNum = app.arguments().at(chIdx + 1).toInt();
                mediaBackend->setSource("OrbitXM");
                QObject *pageStack = rootObj->findChild<QObject*>("pageStack");
                if (pageStack) {
                    pageStack->setProperty("currentIndex", 7);
                }
                QTimer::singleShot(200, [mb = mediaBackend.get(), chNum]() {
                    mb->tuneSxmChannelNumber(chNum);
                });
            }
        }

        if (app.arguments().contains("--click-related")) {
            mediaBackend->setSource("OrbitXM");
            QObject *pageStack = rootObj->findChild<QObject*>("pageStack");
            if (pageStack) {
                pageStack->setProperty("currentIndex", 7);
            }
            QTimer::singleShot(500, [rootObj]() {
                QObject *radioPage = rootObj->findChild<QObject*>("radioPage");
                if (radioPage) {
                    QObject *modal = radioPage->findChild<QObject*>("relatedDrawer");
                    if (modal) {
                        QMetaObject::invokeMethod(modal, "openModal");
                    }
                }
            });
        }

        if (app.arguments().contains("--guide-open")) {
            mediaBackend->setSource("OrbitXM");
            QObject *pageStack = rootObj->findChild<QObject*>("pageStack");
            if (pageStack) {
                pageStack->setProperty("currentIndex", 7);
            }
            QTimer::singleShot(800, [rootObj]() {
                QObject *radioPage = rootObj->findChild<QObject*>("radioPage");
                if (radioPage) {
                    QObject *guide = radioPage->findChild<QObject*>("channelGuideModal");
                    if (guide) {
                        QMetaObject::invokeMethod(guide, "openGuide");
                    }
                }
            });
        }

        if (app.arguments().contains("--notif-dialog")) {
            mediaBackend->setSource("OrbitXM");
            QObject *pageStack = rootObj->findChild<QObject*>("pageStack");
            if (pageStack) {
                pageStack->setProperty("currentIndex", 7);
            }
            QTimer::singleShot(600, [rootObj]() {
                QObject *radioPage = rootObj->findChild<QObject*>("radioPage");
                if (radioPage) {
                    QObject *modal = radioPage->findChild<QObject*>("sxmNotificationModal");
                    if (modal) {
                        QMetaObject::invokeMethod(modal, "openDialog");
                    }
                }
            });
        }

        if (app.arguments().contains("--channels-modal")) {
            mediaBackend->setSource("OrbitXM");
            QObject *pageStack = rootObj->findChild<QObject*>("pageStack");
            if (pageStack) {
                pageStack->setProperty("currentIndex", 7);
            }
            QTimer::singleShot(600, [rootObj]() {
                QObject *radioPage = rootObj->findChild<QObject*>("radioPage");
                if (radioPage) {
                    QObject *modal = radioPage->findChild<QObject*>("channelsViewModal");
                    if (modal) {
                        QMetaObject::invokeMethod(modal, "openModal");
                    }
                }
            });
        }

        if (app.arguments().contains("--related-modal")) {
            mediaBackend->setSource("OrbitXM");
            QObject *pageStack = rootObj->findChild<QObject*>("pageStack");
            if (pageStack) {
                pageStack->setProperty("currentIndex", 7);
            }
            QTimer::singleShot(600, [rootObj]() {
                QObject *radioPage = rootObj->findChild<QObject*>("radioPage");
                if (radioPage) {
                    QObject *modal = radioPage->findChild<QObject*>("relatedDrawer");
                    if (modal) {
                        QMetaObject::invokeMethod(modal, "openModal");
                    }
                }
            });
        }

        if (app.arguments().contains("--shows-modal")) {
            mediaBackend->setSource("OrbitXM");
            QObject *pageStack = rootObj->findChild<QObject*>("pageStack");
            if (pageStack) {
                pageStack->setProperty("currentIndex", 7);
            }
            QTimer::singleShot(600, [rootObj]() {
                QObject *radioPage = rootObj->findChild<QObject*>("radioPage");
                if (radioPage) {
                    QObject *modal = radioPage->findChild<QObject*>("relatedDrawer");
                    if (modal) {
                        QMetaObject::invokeMethod(modal, "openModal");
                        modal->setProperty("activeTab", 1);
                    }
                }
            });
        }

        if (app.arguments().contains("--open-source-menu")) {
            mediaBackend->setSource("AM");
            QObject *pageStack = rootObj->findChild<QObject*>("pageStack");
            if (pageStack) {
                pageStack->setProperty("currentIndex", 7);
            }
            QTimer::singleShot(400, [rootObj]() {
                QObject *radioPage = rootObj->findChild<QObject*>("radioPage");
                if (radioPage) {
                    QObject *menu = radioPage->findChild<QObject*>("sourceDropdownMenu");
                    if (menu) {
                        menu->setProperty("visible", true);
                    }
                }
            });
        }

        if (app.arguments().contains("--open-keypad")) {
            mediaBackend->setSource("AM");
            QObject *pageStack = rootObj->findChild<QObject*>("pageStack");
            if (pageStack) {
                pageStack->setProperty("currentIndex", 7);
            }
            QTimer::singleShot(400, [rootObj]() {
                QObject *radioPage = rootObj->findChild<QObject*>("radioPage");
                if (radioPage) {
                    QObject *modal = radioPage->findChild<QObject*>("keypadModal");
                    if (modal) {
                        modal->setProperty("opacity", 1.0);
                        modal->setProperty("enteredFreq", "530");
                    }
                }
            });
        }

        if (app.arguments().contains("--open-card-menu")) {
            mediaBackend->setSource("AM");
            QObject *pageStack = rootObj->findChild<QObject*>("pageStack");
            if (pageStack) {
                pageStack->setProperty("currentIndex", 0);
            }
            QTimer::singleShot(400, [rootObj]() {
                QObject *homePage = rootObj->findChild<QObject*>("homePage");
                if (homePage) {
                    QObject *menu = homePage->findChild<QObject*>("cardSourceDropdown");
                    if (menu) {
                        menu->setProperty("visible", true);
                    }
                }
            });
        }

        if (app.arguments().contains("--rear-feet")) {
            climateBackend->setRearAirflowMode(1);
        }

        if (app.arguments().contains("--test-fade")) {
            QObject *climateBar = rootObj->findChild<QObject*>("climateBar");
            QQuickWindow *win = qobject_cast<QQuickWindow*>(rootObj);
            if (climateBar && win) {
                QTimer::singleShot(1000, [climateBar, win]() {
                    qInfo() << "[FADE TEST] Starting Climate OPEN";
                    climateBar->setProperty("climate3DOpen", true);
                });
                QTimer::singleShot(1100, [win]() { win->grabWindow().save("fade_open_100ms.png"); });
                QTimer::singleShot(1175, [win]() { win->grabWindow().save("fade_open_175ms.png"); });
                QTimer::singleShot(1250, [win]() { win->grabWindow().save("fade_open_250ms.png"); });
                QTimer::singleShot(1400, [win]() { win->grabWindow().save("fade_open_400ms.png"); });

                QTimer::singleShot(2200, [climateBar, win]() {
                    qInfo() << "[FADE TEST] Starting Climate CLOSE";
                    climateBar->setProperty("climate3DOpen", false);
                });
                QTimer::singleShot(2300, [win]() { win->grabWindow().save("fade_close_100ms.png"); });
                QTimer::singleShot(2375, [win]() { win->grabWindow().save("fade_close_175ms.png"); });
                QTimer::singleShot(2450, [win]() { win->grabWindow().save("fade_close_250ms.png"); });
                QTimer::singleShot(2600, [win, &app]() {
                    win->grabWindow().save("fade_close_400ms.png");
                    qInfo() << "[FADE TEST] Complete!";
                    app.quit();
                });
            }
        }

        if (app.arguments().contains("--test-welcome")) {
            QQuickWindow *win = qobject_cast<QQuickWindow*>(rootObj);
            if (win) {
                // 0.6s - Laser Ignition
                QTimer::singleShot(600, [win]() {
                    win->grabWindow().save("welcome_01_laser_ignition.png");
                    qInfo() << "[WELCOME TEST] Captured Phase 1: Laser Ignition";
                });
                // 1.3s - Laser Trace
                QTimer::singleShot(1300, [win]() {
                    win->grabWindow().save("welcome_02_laser_trace.png");
                    qInfo() << "[WELCOME TEST] Captured Phase 2: Laser Trace";
                });
                // 2.2s - Metallic Materialization
                QTimer::singleShot(2200, [win]() {
                    win->grabWindow().save("welcome_03_metallic_reveal.png");
                    qInfo() << "[WELCOME TEST] Captured Phase 3: Metallic Materialization";
                });
                // 3.0s - Specular Shine Sweep
                QTimer::singleShot(3000, [win]() {
                    win->grabWindow().save("welcome_04_specular_shine.png");
                    qInfo() << "[WELCOME TEST] Captured Phase 4: Specular Shine";
                });
                // 3.8s - Vision S Lock
                QTimer::singleShot(3800, [win]() {
                    win->grabWindow().save("welcome_05_vision_s_lock.png");
                    qInfo() << "[WELCOME TEST] Captured Phase 5: Vision S Lock";
                });
                // 4.4s - Brand Hold
                QTimer::singleShot(4400, [win]() {
                    win->grabWindow().save("welcome_06_brand_hold.png");
                    qInfo() << "[WELCOME TEST] Captured Phase 6: Brand Hold";
                });
                // 5.2s - Cockpit Revealed
                QTimer::singleShot(5200, [win, &app]() {
                    win->grabWindow().save("welcome_07_cockpit_revealed.png");
                    qInfo() << "[WELCOME TEST] Captured Phase 7: Cockpit Revealed. Test complete!";
                    app.quit();
                });
            }
        }

        if (app.arguments().contains("--page")) {
            int pIdx = app.arguments().indexOf("--page");
            if (pIdx + 1 < app.arguments().size()) {
                int pageNum = app.arguments().at(pIdx + 1).toInt();
                QObject *stack = rootObj->findChild<QObject*>("pageStack");
                if (stack) {
                    stack->setProperty("currentIndex", pageNum);
                }
            }
        }

        if (app.arguments().contains("--radio-sxm")) {
            QObject *stack = rootObj->findChild<QObject*>("pageStack");
            if (stack) {
                stack->setProperty("currentIndex", 7);
            }
            if (mediaBackend) {
                mediaBackend->setSource("OrbitXM");
            }
        }

        if (app.arguments().contains("--radio-related")) {
            QObject *stack = rootObj->findChild<QObject*>("pageStack");
            if (stack) {
                stack->setProperty("currentIndex", 7);
            }
            if (mediaBackend) {
                mediaBackend->setSource("OrbitXM");
            }
            QTimer::singleShot(800, [rootObj]() {
                QObject *rel = rootObj->findChild<QObject*>("relatedDrawer");
                if (rel) {
                    QMetaObject::invokeMethod(rel, "openModal");
                }
            });
        }

        if (app.arguments().contains("--radio-shows")) {
            QObject *stack = rootObj->findChild<QObject*>("pageStack");
            if (stack) {
                stack->setProperty("currentIndex", 7);
            }
            if (mediaBackend) {
                mediaBackend->setSource("OrbitXM");
            }
            QTimer::singleShot(800, [rootObj]() {
                QObject *rel = rootObj->findChild<QObject*>("relatedDrawer");
                if (rel) {
                    QMetaObject::invokeMethod(rel, "openShows");
                }
            });
        }

        if (app.arguments().contains("--test-player")) {
            QObject *stack = rootObj->findChild<QObject*>("pageStack");
            if (stack) {
                stack->setProperty("currentIndex", 8);
            }
            QTimer::singleShot(1500, [vb = videoBackend.get()]() {
                if (vb && !vb->videos().isEmpty()) {
                    vb->selectVideo(vb->videos().first().toMap());
                }
            });
        }

        if (app.arguments().contains("--test-rejuvenate")) {
            QObject *stack = rootObj->findChild<QObject*>("pageStack");
            if (stack) {
                stack->setProperty("currentIndex", 9);
            }
            QTimer::singleShot(800, [rc = rejuvenateController.get()]() {
                if (rc) {
                    rc->startSession();
                }
            });
        }

        if (app.arguments().contains("--test-safety-alert")) {
            QObject *stack = rootObj->findChild<QObject*>("pageStack");
            if (stack) {
                stack->setProperty("currentIndex", 9);
            }
            QTimer::singleShot(800, [rc = rejuvenateController.get()]() {
                if (rc) {
                    rc->startSession();
                }
            });
            QTimer::singleShot(2500, [rc = rejuvenateController.get()]() {
                if (rc) {
                    rc->simulateDriveMotion(true);
                }
            });
        }

        if (app.arguments().contains("--manual-visual")) {
            QObject *stack = rootObj->findChild<QObject*>("pageStack");
            if (stack) {
                stack->setProperty("currentIndex", 10);
            }
            QTimer::singleShot(600, [rootObj]() {
                QObject *manualPage = rootObj->findChild<QObject*>("manualPage");
                if (manualPage) {
                    manualPage->setProperty("currentTab", "visual");
                }
            });
        }

        if (app.arguments().contains("--test-news-refresh")) {
            QObject *stack = rootObj->findChild<QObject*>("pageStack");
            if (stack) {
                stack->setProperty("currentIndex", 6);
            }
            QTimer::singleShot(800, [rootObj, &app]() {
                QObject *newsPage = rootObj->findChild<QObject*>("newsPage");
                if (newsPage) {
                    QMetaObject::invokeMethod(newsPage, "refreshNewsFromApi");
                    QTimer::singleShot(1600, [&app]() {
                        app.quit();
                    });
                }
            });
        }

        if (app.arguments().contains("--manual-topics")) {
            QObject *stack = rootObj->findChild<QObject*>("pageStack");
            if (stack) {
                stack->setProperty("currentIndex", 10);
            }
            QTimer::singleShot(600, [rootObj]() {
                QObject *manualPage = rootObj->findChild<QObject*>("manualPage");
                if (manualPage) {
                    manualPage->setProperty("activeCategory", "General Information");
                }
            });
        }

        if (app.arguments().contains("--test-nav-app")) {
            QObject *stack = rootObj->findChild<QObject*>("pageStack");
            if (stack) {
                stack->setProperty("currentIndex", 0);
            }
            bool forceDay = app.arguments().contains("--force-day");
            QTimer::singleShot(800, [rootObj, forceDay]() {
                QObject *homePage = rootObj->findChild<QObject*>("homePage");
                if (homePage) {
                    QMetaObject::invokeMethod(homePage, "openFullNavigation", Q_ARG(QVariant, false));
                }
                if (forceDay) {
                    QTimer::singleShot(1500, [rootObj]() {
                        QObject *navPanel = rootObj->findChild<QObject*>("navPanelComponent");
                        if (navPanel) {
                            navPanel->setProperty("mapThemePreference", "day");
                        }
                    });
                }
            });
        }

        if (app.arguments().contains("--test-profile-overview")) {
            QObject *stack = rootObj->findChild<QObject*>("pageStack");
            if (stack) {
                stack->setProperty("currentIndex", 11);
            }
            QTimer::singleShot(800, [rootObj]() {
                QObject *profilePage = rootObj->findChild<QObject*>("profileSwitcherPage");
                if (profilePage) {
                    profilePage->setProperty("currentMode", "overview");
                }
            });
        }

        if (app.arguments().contains("--test-profile-step1-empty")) {
            QObject *stack = rootObj->findChild<QObject*>("pageStack");
            if (stack) {
                stack->setProperty("currentIndex", 11);
            }
            QTimer::singleShot(800, [rootObj]() {
                QObject *profilePage = rootObj->findChild<QObject*>("profileSwitcherPage");
                if (profilePage) {
                    profilePage->setProperty("currentMode", "create_wizard");
                    profilePage->setProperty("wizardStep", 1);
                    profilePage->setProperty("newProfileName", "");
                }
            });
        }

        if (app.arguments().contains("--test-profile-edit")) {
            QObject *stack = rootObj->findChild<QObject*>("pageStack");
            if (stack) {
                stack->setProperty("currentIndex", 11);
            }
            QTimer::singleShot(800, [rootObj]() {
                QObject *profilePage = rootObj->findChild<QObject*>("profileSwitcherPage");
                if (profilePage) {
                    profilePage->setProperty("currentMode", "overview");
                }
            });
            QTimer::singleShot(1400, [rootObj]() {
                QObject *profilePage = rootObj->findChild<QObject*>("profileSwitcherPage");
                if (profilePage) {
                    QMetaObject::invokeMethod(profilePage, "openProfileSettingsRequested");
                }
                QObject *stack = rootObj->findChild<QObject*>("pageStack");
                if (stack) {
                    stack->setProperty("currentIndex", 4);
                }
                QObject *settings = rootObj->findChild<QObject*>("settingsPage");
                if (settings) {
                    settings->setProperty("activeCategory", "profile");
                    settings->setProperty("profCurrentScreen", "main");
                }
            });
        }

        if (app.arguments().contains("--test-profile-wizard-step")) {
            int sIdx = app.arguments().indexOf("--test-profile-wizard-step");
            int stepNum = (sIdx + 1 < app.arguments().size()) ? app.arguments().at(sIdx + 1).toInt() : 1;
            QObject *stack = rootObj->findChild<QObject*>("pageStack");
            if (stack) {
                stack->setProperty("currentIndex", 11);
            }
            QTimer::singleShot(800, [rootObj, stepNum]() {
                QObject *profilePage = rootObj->findChild<QObject*>("profileSwitcherPage");
                if (profilePage) {
                    profilePage->setProperty("currentMode", "create_wizard");
                    profilePage->setProperty("wizardStep", stepNum);
                }
            });
        }

        if (app.arguments().contains("--test-profile-to-lang")) {
            QObject *stack = rootObj->findChild<QObject*>("pageStack");
            if (stack) {
                stack->setProperty("currentIndex", 11);
            }
            QTimer::singleShot(1000, [rootObj]() {
                QObject *profilePage = rootObj->findChild<QObject*>("profileSwitcherPage");
                if (profilePage) {
                    QMetaObject::invokeMethod(profilePage, "openLanguageSettings");
                }
            });
        }

        if (app.arguments().contains("--test-android-auto")) {
            QObject *stack = rootObj->findChild<QObject*>("pageStack");
            if (stack) {
                stack->setProperty("currentIndex", 12);
            }
            QObject *mobPage = rootObj->findChild<QObject*>("mobileDeviceConnectionPage");
            if (mobPage) {
                mobPage->setProperty("projectionType", "android_auto");
                if (app.arguments().contains("--test-usb")) {
                    mobPage->setProperty("connectionTab", "usb");
                }
            }
        }

        if (app.arguments().contains("--test-carplay")) {
            QObject *stack = rootObj->findChild<QObject*>("pageStack");
            if (stack) {
                stack->setProperty("currentIndex", 12);
            }
            QObject *mobPage = rootObj->findChild<QObject*>("mobileDeviceConnectionPage");
            if (mobPage) {
                mobPage->setProperty("projectionType", "carplay");
                if (app.arguments().contains("--test-usb")) {
                    mobPage->setProperty("connectionTab", "usb");
                }
            }
        }

        qInfo() << "[APEX IVI] Root setup complete. Checking screenshot flag:" << app.arguments().contains("--screenshot");
        if (app.arguments().contains("--screenshot")) {
            int idx = app.arguments().indexOf("--screenshot");
            QString outPath = (idx + 1 < app.arguments().size()) ? app.arguments().at(idx + 1) : "apex_screenshot.png";
            QQuickWindow *win = qobject_cast<QQuickWindow*>(rootObj);
            qInfo() << "[APEX IVI] --screenshot requested. win:" << win << "outPath:" << outPath;
            if (win) {
                int delay = (app.arguments().contains("--page") || app.arguments().contains("--test-player") || app.arguments().contains("--test-nav-app")) ? 5000 : 3000;
                QTimer::singleShot(delay, [win, outPath, &app]() {
                    QImage img = win->grabWindow();
                    img.save(outPath);
                    qInfo() << "Saved verification screenshot to:" << outPath;
                    app.quit();
                });
            } else {
                qWarning() << "[APEX IVI] Could not cast rootObj to QQuickWindow!";
            }
        }
    }

    return app.exec();
}
