import QtQuick
import QtQuick.Controls

Item {
    id: root

    signal backRequested()

    property int activeCategoryIndex: 0
    property int selectedArticleIndex: 0
    property bool isLoading: false
    property bool isSpeaking: false

    // Real-Time Update Timer (Polls live feeds automatically every 60 seconds)
    Timer {
        id: autoUpdateTimer
        interval: 60000
        repeat: true
        running: true
        onTriggered: {
            root.fetchLiveNews(root.categories[root.activeCategoryIndex].query, root.categories[root.activeCategoryIndex].name, false);
        }
    }

    // =========================================================================
    // CATEGORIES WITH VERIFIED HD IMAGES & TOPIC-MATCHED FEEDS
    // =========================================================================
    readonly property var categories: [
        {
            name: "Top Stories",
            query: "https://news.google.com/rss?hl=en-US&gl=US&ceid=US:en",
            heroImage: "https://images.unsplash.com/photo-1593941707882-a5bba14938c7?auto=format&fit=crop&w=1200&q=80",
            categoryImages: [
                "https://images.unsplash.com/photo-1593941707882-a5bba14938c7?auto=format&fit=crop&w=1200&q=80",
                "https://images.unsplash.com/photo-1516849841032-87cbac4d88f7?auto=format&fit=crop&w=1200&q=80",
                "https://images.unsplash.com/photo-1466611653911-95081537e5b7?auto=format&fit=crop&w=1200&q=80",
                "https://images.unsplash.com/photo-1540747913346-19e32dc3e97e?auto=format&fit=crop&w=1200&q=80",
                "https://images.unsplash.com/photo-1545208942-e1c9c916524b?auto=format&fit=crop&w=1200&q=80"
            ],
            stories: [
                {
                    category: "Automotive",
                    headline: "Global EV sales hit new record in 2024, analysts see stronger growth ahead",
                    authorInfo: "2 hours ago • By Auto News Desk",
                    timeText: "2 hours ago",
                    image: "https://images.unsplash.com/photo-1593941707882-a5bba14938c7?auto=format&fit=crop&w=1200&q=80",
                    body: "Global electric vehicle (EV) sales have reached a new record in 2024, driven by stronger demand, expanded charging infrastructure and increased model availability across major markets. Analysts predict the growth momentum will continue into next year, with several manufacturers planning new launches and technological upgrades.",
                    isBookmarked: true
                },
                {
                    category: "Technology",
                    headline: "New satellite launch to improve internet connectivity worldwide",
                    authorInfo: "4 hours ago • By Tech Wire",
                    timeText: "4 hours ago",
                    image: "https://images.unsplash.com/photo-1516849841032-87cbac4d88f7?auto=format&fit=crop&w=1200&q=80",
                    body: "A next-generation low-earth orbit communication constellation deployed today, reducing transmission latency and bringing gigabit-speed satellite connectivity to remote oceanic and continental corridors.",
                    isBookmarked: false
                },
                {
                    category: "Business",
                    headline: "Global green energy initiative expands clean power deployment",
                    authorInfo: "6 hours ago • By Financial Times",
                    timeText: "6 hours ago",
                    image: "https://images.unsplash.com/photo-1466611653911-95081537e5b7?auto=format&fit=crop&w=1200&q=80",
                    body: "International clean energy partnerships allocate multi-billion capital reserves towards next-generation solid-state grid storage, solar farms, and green hydrogen synthesis facilities.",
                    isBookmarked: false
                },
                {
                    category: "Sports",
                    headline: "Championship thriller goes down to final moments in spectacular finish",
                    authorInfo: "8 hours ago • By Sports Desk",
                    timeText: "8 hours ago",
                    image: "https://images.unsplash.com/photo-1540747913346-19e32dc3e97e?auto=format&fit=crop&w=1200&q=80",
                    body: "A historic final saw record-breaking attendance as defensive mastery and overtime drama culminated in a championship victory before an ecstatic crowd of over eighty thousand fans.",
                    isBookmarked: false
                },
                {
                    category: "Environment",
                    headline: "Solar power adoption reaches all-time high in 2024",
                    authorInfo: "10 hours ago • By Climate Horizon",
                    timeText: "10 hours ago",
                    image: "https://images.unsplash.com/photo-1545208942-e1c9c916524b?auto=format&fit=crop&w=1200&q=80",
                    body: "Rooftop photovoltaic installations and utility-scale solar corridors exceeded annual output projections by thirty percent, marking a milestone year for renewable grid integration.",
                    isBookmarked: false
                }
            ]
        },
        {
            name: "Automotive",
            query: "https://news.google.com/rss/search?q=electric+vehicles+OR+automotive+industry+OR+EV+cars&hl=en-US&gl=US&ceid=US:en",
            heroImage: "https://images.unsplash.com/photo-1503376780353-7e6692767b70?auto=format&fit=crop&w=1200&q=80",
            categoryImages: [
                "https://images.unsplash.com/photo-1503376780353-7e6692767b70?auto=format&fit=crop&w=1200&q=80",
                "https://images.unsplash.com/photo-1563720223185-11003d516935?auto=format&fit=crop&w=1200&q=80",
                "https://images.unsplash.com/photo-1552519507-da3b142c6e3d?auto=format&fit=crop&w=1200&q=80",
                "https://images.unsplash.com/photo-1617814076367-b759c7d7e738?auto=format&fit=crop&w=1200&q=80",
                "https://images.unsplash.com/photo-1511919884226-fd3cad34687c?auto=format&fit=crop&w=1200&q=80",
                "https://images.unsplash.com/photo-1542282088-72c9c27ed0cd?auto=format&fit=crop&w=1200&q=80"
            ],
            stories: [
                {
                    category: "Automotive",
                    headline: "Automakers Unveil Ultra-Fast 800V Charging Architectures Across New Fleet",
                    authorInfo: "1 hour ago • By Motor Intelligence",
                    timeText: "1 hour ago",
                    image: "https://images.unsplash.com/photo-1503376780353-7e6692767b70?auto=format&fit=crop&w=1200&q=80",
                    body: "High-voltage 800-volt architectures with silicon carbide inverters are cutting 10-80% charge intervals to under 12 minutes, accelerating mass transition for long-distance highway travel.",
                    isBookmarked: false
                },
                {
                    category: "Automotive",
                    headline: "Megawatt EV Highway Fast-Charging Hubs Expand Across Continental Corridors",
                    authorInfo: "2 hours ago • By EV Dynamics",
                    timeText: "2 hours ago",
                    image: "https://images.unsplash.com/photo-1563720223185-11003d516935?auto=format&fit=crop&w=1200&q=80",
                    body: "New liquid-cooled 400kW charging stations open nationwide, providing seamless long-range touring capabilities with automated plug-and-charge billing.",
                    isBookmarked: false
                },
                {
                    category: "Automotive",
                    headline: "Next-Gen Intelligent Cockpit Operating Systems Unveil Spatial 3D AR HUD",
                    authorInfo: "3 hours ago • By Auto Tech Review",
                    timeText: "3 hours ago",
                    image: "https://images.unsplash.com/photo-1552519507-da3b142c6e3d?auto=format&fit=crop&w=1200&q=80",
                    body: "Onboard neural processing chips project augmented reality navigation arrows directly onto the windshield glass, synchronizing real-time lane alerts with cabin ambient lighting.",
                    isBookmarked: true
                },
                {
                    category: "Automotive",
                    headline: "Solid-State Battery Production Pilot Validates 750-Mile Highway Endurance",
                    authorInfo: "4 hours ago • By Battery Horizon",
                    timeText: "4 hours ago",
                    image: "https://images.unsplash.com/photo-1617814076367-b759c7d7e738?auto=format&fit=crop&w=1200&q=80",
                    body: "Pilot vehicle track evaluations confirm unmatched energy density, non-flammable thermal stability, and consistent high-discharge power across freezing winter temperatures.",
                    isBookmarked: false
                },
                {
                    category: "Automotive",
                    headline: "Autonomous Highway Pilot L3 Certified for Hands-Free High Speed Cruising",
                    authorInfo: "6 hours ago • By Apex Telematics",
                    timeText: "6 hours ago",
                    image: "https://images.unsplash.com/photo-1511919884226-fd3cad34687c?auto=format&fit=crop&w=1200&q=80",
                    body: "Regulatory clearance grants drivers true eyes-off-the-road assistance in designated freeway zones with multi-layer redundant lidar and radar safety meshes.",
                    isBookmarked: false
                },
                {
                    category: "Automotive",
                    headline: "Advanced Active Aerodynamics & Chassis Dynamics Redefine Cornering Precision",
                    authorInfo: "8 hours ago • By Track Performance",
                    timeText: "8 hours ago",
                    image: "https://images.unsplash.com/photo-1542282088-72c9c27ed0cd?auto=format&fit=crop&w=1200&q=80",
                    body: "Adaptive variable spoilers and 48-volt active anti-roll bars react in under two milliseconds, eliminating body roll while maximizing highway aerodynamic efficiency.",
                    isBookmarked: false
                }
            ]
        },
        {
            name: "Technology",
            query: "https://news.google.com/rss/headlines/section/topic/TECHNOLOGY?hl=en-US&gl=US&ceid=US:en",
            heroImage: "https://images.unsplash.com/photo-1518770660439-4636190af475?auto=format&fit=crop&w=1200&q=80",
            categoryImages: [
                "https://images.unsplash.com/photo-1518770660439-4636190af475?auto=format&fit=crop&w=1200&q=80",
                "https://images.unsplash.com/photo-1451187580459-43490279c0fa?auto=format&fit=crop&w=1200&q=80",
                "https://images.unsplash.com/photo-1526374965328-7f61d4dc18c5?auto=format&fit=crop&w=1200&q=80",
                "https://images.unsplash.com/photo-1635070041078-e363dbe005cb?auto=format&fit=crop&w=1200&q=80"
            ],
            stories: [
                {
                    category: "Technology",
                    headline: "Next-Generation Optical Microprocessors Achieve Breakthrough Processing Speeds",
                    authorInfo: "2 hours ago • By Silicon Digest",
                    timeText: "2 hours ago",
                    image: "https://images.unsplash.com/photo-1518770660439-4636190af475?auto=format&fit=crop&w=1200&q=80",
                    body: "Photonic chip interconnects harness light pulses to transmit multi-terabit datastreams while reducing thermal dissipation by over forty percent.",
                    isBookmarked: false
                },
                {
                    category: "Technology",
                    headline: "Low-Earth Orbit Satellite Constellation Completes Global Direct-to-Device Mesh",
                    authorInfo: "4 hours ago • By Orbit Wire",
                    timeText: "4 hours ago",
                    image: "https://images.unsplash.com/photo-1451187580459-43490279c0fa?auto=format&fit=crop&w=1200&q=80",
                    body: "Seamless emergency SOS and broadband internet links directly to standard consumer smartphones and automotive telematics without specialized dish equipment.",
                    isBookmarked: true
                },
                {
                    category: "Technology",
                    headline: "Neural AI Processors Accelerate Autonomous Vision Comprehension",
                    authorInfo: "5 hours ago • By AI Chronicle",
                    timeText: "5 hours ago",
                    image: "https://images.unsplash.com/photo-1526374965328-7f61d4dc18c5?auto=format&fit=crop&w=1200&q=80",
                    body: "Dedicated edge neural models process multi-camera visual odometry at five hundred frames per second with sub-watt power efficiency.",
                    isBookmarked: false
                },
                {
                    category: "Technology",
                    headline: "Quantum Simulation Algorithms Accurately Model Superconductor Materials",
                    authorInfo: "7 hours ago • By Science Computing",
                    timeText: "7 hours ago",
                    image: "https://images.unsplash.com/photo-1635070041078-e363dbe005cb?auto=format&fit=crop&w=1200&q=80",
                    body: "Fault-tolerant quantum processor architectures solve complex molecular lattices, pointing to room-temperature zero-loss power transmission.",
                    isBookmarked: false
                }
            ]
        },
        {
            name: "Business",
            query: "https://news.google.com/rss/headlines/section/topic/BUSINESS?hl=en-US&gl=US&ceid=US:en",
            heroImage: "https://images.unsplash.com/photo-1611974789855-9c2a0a7236a3?auto=format&fit=crop&w=1200&q=80",
            categoryImages: [
                "https://images.unsplash.com/photo-1611974789855-9c2a0a7236a3?auto=format&fit=crop&w=1200&q=80",
                "https://images.unsplash.com/photo-1486406146926-c627a92ad1ab?auto=format&fit=crop&w=1200&q=80",
                "https://images.unsplash.com/photo-1590283603385-17ffb3a7f29f?auto=format&fit=crop&w=1200&q=80",
                "https://images.unsplash.com/photo-1507679799987-c73779587ccf?auto=format&fit=crop&w=1200&q=80"
            ],
            stories: [
                {
                    category: "Business",
                    headline: "Global Green Capital Allocations Reach Multi-Trillion Record Milestone",
                    authorInfo: "2 hours ago • By Financial Chronicle",
                    timeText: "2 hours ago",
                    image: "https://images.unsplash.com/photo-1611974789855-9c2a0a7236a3?auto=format&fit=crop&w=1200&q=80",
                    body: "Sovereign wealth funds and pension portfolios double sustainable technology debt purchases, fueling massive battery factory and smart grid infrastructure buildouts.",
                    isBookmarked: true
                },
                {
                    category: "Business",
                    headline: "Enterprise Cloud Infrastructure Investments Surge on AI Model Deployments",
                    authorInfo: "4 hours ago • By Wall Street Wire",
                    timeText: "4 hours ago",
                    image: "https://images.unsplash.com/photo-1486406146926-c627a92ad1ab?auto=format&fit=crop&w=1200&q=80",
                    body: "Global corporations report unprecedented capital expenditure towards hyperscale computing clusters and private data centers.",
                    isBookmarked: false
                },
                {
                    category: "Business",
                    headline: "Autonomous Commercial Freight Fleets Cut Regional Transport Overhead by 28%",
                    authorInfo: "6 hours ago • By Logistics Today",
                    timeText: "6 hours ago",
                    image: "https://images.unsplash.com/photo-1590283603385-17ffb3a7f29f?auto=format&fit=crop&w=1200&q=80",
                    body: "Initial operational audits of electric autonomous hauler corridors between major logistics hubs show significant efficiency gains in fuel and turnaround intervals.",
                    isBookmarked: false
                },
                {
                    category: "Business",
                    headline: "Semiconductor Foundry Expansions Modernize Domestic Supply Chains",
                    authorInfo: "8 hours ago • By Global Markets",
                    timeText: "8 hours ago",
                    image: "https://images.unsplash.com/photo-1507679799987-c73779587ccf?auto=format&fit=crop&w=1200&q=80",
                    body: "Advanced 2-nanometer extreme ultraviolet lithography plants begin commercial wafer fabrication, ensuring redundant automotive microcontroller availability.",
                    isBookmarked: false
                }
            ]
        },
        {
            name: "Sports",
            query: "https://news.google.com/rss/headlines/section/topic/SPORTS?hl=en-US&gl=US&ceid=US:en",
            heroImage: "https://images.unsplash.com/photo-1540747913346-19e32dc3e97e?auto=format&fit=crop&w=1200&q=80",
            categoryImages: [
                "https://images.unsplash.com/photo-1540747913346-19e32dc3e97e?auto=format&fit=crop&w=1200&q=80",
                "https://images.unsplash.com/photo-1579952363873-27f3bade9f55?auto=format&fit=crop&w=1200&q=80",
                "https://images.unsplash.com/photo-1568605117036-5fe5e7bab0b7?auto=format&fit=crop&w=1200&q=80",
                "https://images.unsplash.com/photo-1461896836934-ffe607ba8211?auto=format&fit=crop&w=1200&q=80"
            ],
            stories: [
                {
                    category: "Sports",
                    headline: "Championship Finale Grips International Audience in Historic Overtime Victory",
                    authorInfo: "2 hours ago • By Global Sports",
                    timeText: "2 hours ago",
                    image: "https://images.unsplash.com/photo-1540747913346-19e32dc3e97e?auto=format&fit=crop&w=1200&q=80",
                    body: "A relentless counter-attack in the final seconds of extra time delivered the winning goal before eighty-five thousand electrified spectators.",
                    isBookmarked: false
                },
                {
                    category: "Sports",
                    headline: "World Tournament Group Stages Produce Thrilling Last-Gasp Qualifiers",
                    authorInfo: "3 hours ago • By Sports Illustrated",
                    timeText: "3 hours ago",
                    image: "https://images.unsplash.com/photo-1579952363873-27f3bade9f55?auto=format&fit=crop&w=1200&q=80",
                    body: "Underdog squads stunned reigning champions with high-tempo pressing and masterclass finishing to secure spots in the knockout rounds.",
                    isBookmarked: false
                },
                {
                    category: "Sports",
                    headline: "Electric Grand Prix Series Smashes Track Lap Records with Twin-Motor Racers",
                    authorInfo: "5 hours ago • By Motorsport Daily",
                    timeText: "5 hours ago",
                    image: "https://images.unsplash.com/photo-1568605117036-5fe5e7bab0b7?auto=format&fit=crop&w=1200&q=80",
                    body: "Gen-3 electric racing single-seaters boasting 600kW regenerative braking systems displayed intense overtaking duels around the iconic harbor street circuit.",
                    isBookmarked: true
                },
                {
                    category: "Sports",
                    headline: "World Athletics Tour Concludes with Spectacular Record-Breaking Sprints",
                    authorInfo: "7 hours ago • By Track & Field Wire",
                    timeText: "7 hours ago",
                    image: "https://images.unsplash.com/photo-1461896836934-ffe607ba8211?auto=format&fit=crop&w=1200&q=80",
                    body: "Flawless track conditions and optimal tailwinds propelled sprinters to the fastest 200m splits recorded in international championship history.",
                    isBookmarked: false
                }
            ]
        }
    ]

    ListModel {
        id: newsModel
    }

    // Active Story Accessor
    readonly property var activeStory: {
        if (newsModel.count > 0 && root.selectedArticleIndex < newsModel.count) {
            return newsModel.get(root.selectedArticleIndex);
        }
        return null;
    }

    // =========================================================================
    // BACKGROUND VIGNETTE (Consistent with APEX Cockpit Theme)
    // =========================================================================
    Rectangle {
        anchors.fill: parent
        gradient: Gradient {
            GradientStop { position: 0.0; color: Qt.rgba(7/255, 11/255, 20/255, 0.40) }
            GradientStop { position: 0.5; color: Qt.rgba(7/255, 11/255, 20/255, 0.55) }
            GradientStop { position: 1.0; color: Qt.rgba(7/255, 11/255, 20/255, 0.75) }
        }
    }

    // =========================================================================
    // MASTER CONTAINER (Seamless Cockpit Integration - Zero Outer Border)
    // =========================================================================
    Item {
        id: masterNewsCard
        anchors.fill: parent

        // =====================================================================
        // 1. TOP HEADER: Official News Logo & "News" Title
        // =====================================================================
        Item {
            id: topHeaderArea
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            height: 58

            Row {
                anchors.left: parent.left
                anchors.leftMargin: 28
                anchors.verticalCenter: parent.verticalCenter
                spacing: 12

                // News App Official Logo (No outer border, authentic brand icon)
                Image {
                    width: 32
                    height: 32
                    source: "qrc:/ApexVision/qml/assets/icons/app_news.svg"
                    fillMode: Image.PreserveAspectFit
                    anchors.verticalCenter: parent.verticalCenter
                    smooth: true
                    mipmap: true
                }

                Text {
                    text: "News"
                    color: "#FFFFFF"
                    font.family: "Inter"
                    font.pixelSize: 28
                    font.weight: Font.Bold
                    anchors.verticalCenter: parent.verticalCenter
                }
            }

            // Real-Time Refresh Button (Top Right)
            Rectangle {
                anchors.right: parent.right
                anchors.rightMargin: 28
                anchors.verticalCenter: parent.verticalCenter
                width: 36
                height: 36
                radius: 18
                // Vehiclebar Glass Styling
                gradient: Gradient {
                    GradientStop {
                        position: 0.0
                        color: refreshMouse.pressed ? Qt.rgba(215/255, 238/255, 255/255, 0.28) : (refreshMouse.containsMouse ? Qt.rgba(225/255, 242/255, 255/255, 0.20) : Qt.rgba(215/255, 238/255, 255/255, 0.12))
                    }
                    GradientStop {
                        position: 1.0
                        color: refreshMouse.pressed ? Qt.rgba(195/255, 225/255, 255/255, 0.22) : (refreshMouse.containsMouse ? Qt.rgba(205/255, 232/255, 255/255, 0.15) : Qt.rgba(195/255, 225/255, 255/255, 0.08))
                    }
                }
                border.color: refreshMouse.containsMouse ? Qt.rgba(255, 255, 255, 0.65) : Qt.rgba(225/255, 242/255, 255/255, 0.36)
                border.width: 1

                Image {
                    id: refreshIcon
                    anchors.centerIn: parent
                    width: 16
                    height: 16
                    source: "qrc:/ApexVision/qml/assets/icons/news_refresh.svg"
                    fillMode: Image.PreserveAspectFit
                    smooth: true
                }

                NumberAnimation {
                    id: refreshSpin
                    target: refreshIcon
                    property: "rotation"
                    from: 0
                    to: 360
                    duration: 650
                    easing.type: Easing.OutCubic
                }

                MouseArea {
                    id: refreshMouse
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        refreshSpin.restart();
                        root.fetchLiveNews(root.categories[root.activeCategoryIndex].query, root.categories[root.activeCategoryIndex].name, false);
                    }
                }
            }
        }

        // =====================================================================
        // 2. CATEGORY TABS (Pills: VehicleMenuCard Authentic Glass Styling)
        // =====================================================================
        Item {
            id: categoryTabsArea
            anchors.top: topHeaderArea.bottom
            anchors.left: parent.left
            anchors.leftMargin: 28
            anchors.right: parent.right
            anchors.rightMargin: 28
            height: 44

            Row {
                anchors.fill: parent
                spacing: 12

                Repeater {
                    model: root.categories

                    Rectangle {
                        id: catPill
                        height: 38
                        width: pillText.implicitWidth + 30
                        radius: 19
                        anchors.verticalCenter: parent.verticalCenter

                        readonly property bool isSelected: root.activeCategoryIndex === index

                        // VehicleMenuCard Frosted Glass Gradient
                        gradient: Gradient {
                            GradientStop {
                                position: 0.0
                                color: catMouse.pressed ?
                                    Qt.rgba(215/255, 238/255, 255/255, 0.32) :
                                    (catMouse.containsMouse ? Qt.rgba(225/255, 242/255, 255/255, 0.24) :
                                    (isSelected ? Qt.rgba(225/255, 242/255, 255/255, 0.22) : Qt.rgba(215/255, 238/255, 255/255, 0.12)))
                            }
                            GradientStop {
                                position: 1.0
                                color: catMouse.pressed ?
                                    Qt.rgba(195/255, 225/255, 255/255, 0.26) :
                                    (catMouse.containsMouse ? Qt.rgba(205/255, 232/255, 255/255, 0.18) :
                                    (isSelected ? Qt.rgba(205/255, 232/255, 255/255, 0.16) : Qt.rgba(195/255, 225/255, 255/255, 0.07)))
                            }
                        }

                        // VehicleMenuCard Luminous Light Glass Border (NO harsh saturated blue)
                        border.color: isSelected ?
                            Qt.rgba(255, 255, 255, 0.85) :
                            (catMouse.containsMouse ? Qt.rgba(255, 255, 255, 0.65) : Qt.rgba(225/255, 242/255, 255/255, 0.36))
                        border.width: isSelected ? 1.5 : 1

                        Behavior on border.color { ColorAnimation { duration: 180 } }

                        // Vehiclebar Spring Scale Animation
                        scale: catMouse.pressed ? 0.96 : (catMouse.containsMouse ? 1.02 : 1.0)
                        Behavior on scale { NumberAnimation { duration: 140; easing.type: Easing.OutQuad } }

                        Text {
                            id: pillText
                            anchors.centerIn: parent
                            text: modelData.name
                            color: isSelected ? "#FFFFFF" : Qt.rgba(255, 255, 255, 0.75)
                            font.family: "Inter"
                            font.pixelSize: 13
                            font.weight: isSelected ? Font.DemiBold : Font.Normal
                            Behavior on color { ColorAnimation { duration: 150 } }
                        }

                        MouseArea {
                            id: catMouse
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                if (root.activeCategoryIndex !== index) {
                                    root.switchCategory(index);
                                }
                            }
                        }
                    }
                }
            }
        }

        // =====================================================================
        // 3. MAIN SPLIT CONTENT AREA: Left Article List (44%) | Right Hero (56%)
        // =====================================================================
        Item {
            id: mainSplitArea
            anchors.top: categoryTabsArea.bottom
            anchors.topMargin: 16
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 20
            anchors.left: parent.left
            anchors.leftMargin: 28
            anchors.right: parent.right
            anchors.rightMargin: 28

            // -----------------------------------------------------------------
            // LEFT COLUMN: ARTICLE FEED LIST
            // -----------------------------------------------------------------
            Item {
                id: leftFeedColumn
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                width: parent.width * 0.44

                ListView {
                    id: articlesListView
                    anchors.fill: parent
                    spacing: 4
                    clip: false // Disable clipping so hover expansion NEVER cuts edges!
                    model: newsModel

                    delegate: Item {
                        width: articlesListView.width
                        height: 90 // Extra headroom so 80px card never gets cut off
                        z: cardMouse.containsMouse ? 10 : 1 // Elevate hovered card above neighbors

                        readonly property bool isSelected: root.selectedArticleIndex === index

                        // Article Card (Authentic VehicleMenuCard Glass Fill & Border)
                        Rectangle {
                            id: articleCard
                            anchors.left: parent.left
                            anchors.right: parent.right
                            anchors.top: parent.top
                            anchors.bottom: parent.bottom
                            anchors.margins: 4 // Internal margin gives space for scale without clipping
                            radius: 14
                            clip: false

                            // VehicleMenuCard Frosted Glass Gradient
                            gradient: Gradient {
                                GradientStop {
                                    position: 0.0
                                    color: cardMouse.pressed ?
                                        Qt.rgba(215/255, 238/255, 255/255, 0.32) :
                                        (cardMouse.containsMouse ? Qt.rgba(225/255, 242/255, 255/255, 0.24) :
                                        (isSelected ? Qt.rgba(225/255, 242/255, 255/255, 0.22) : Qt.rgba(215/255, 238/255, 255/255, 0.17)))
                                }
                                GradientStop {
                                    position: 1.0
                                    color: cardMouse.pressed ?
                                        Qt.rgba(195/255, 225/255, 255/255, 0.26) :
                                        (cardMouse.containsMouse ? Qt.rgba(205/255, 232/255, 255/255, 0.18) :
                                        (isSelected ? Qt.rgba(205/255, 232/255, 255/255, 0.16) : Qt.rgba(195/255, 225/255, 255/255, 0.11)))
                                }
                            }

                            // VehicleMenuCard Luminous Glass Border
                            border.color: isSelected ?
                                Qt.rgba(255, 255, 255, 0.85) :
                                (cardMouse.containsMouse ? Qt.rgba(255, 255, 255, 0.65) : Qt.rgba(225/255, 242/255, 255/255, 0.36))
                            border.width: isSelected ? 1.5 : 1

                            Behavior on border.color { ColorAnimation { duration: 180 } }

                            // Vehiclebar-style Scale Animation
                            scale: cardMouse.pressed ? 0.98 : (cardMouse.containsMouse ? 1.015 : 1.0)
                            Behavior on scale { NumberAnimation { duration: 140; easing.type: Easing.OutQuad } }

                            // Card Content
                            Row {
                                anchors.fill: parent
                                anchors.margins: 10
                                spacing: 12

                                // Thumbnail with HD Image
                                Rectangle {
                                    width: 86
                                    height: 62
                                    radius: 9
                                    clip: true
                                    color: "#0F1A2A"
                                    anchors.verticalCenter: parent.verticalCenter

                                    Image {
                                        anchors.fill: parent
                                        source: model.image
                                        fillMode: Image.PreserveAspectCrop
                                        smooth: true
                                        mipmap: true
                                        cache: true
                                        asynchronous: true
                                    }
                                }

                                // Center Content Column (Category, Headline, Time)
                                Column {
                                    anchors.verticalCenter: parent.verticalCenter
                                    width: parent.width - 86 - 36 - 24
                                    spacing: 3

                                    // Category Tag
                                    Text {
                                        text: model.category
                                        color: Qt.rgba(255, 255, 255, 0.70)
                                        font.family: "Inter"
                                        font.pixelSize: 11
                                        font.weight: Font.DemiBold
                                        elide: Text.ElideRight
                                        width: parent.width
                                    }

                                    // Headline
                                    Text {
                                        text: model.headline
                                        color: "#FFFFFF"
                                        font.family: "Inter"
                                        font.pixelSize: 13
                                        font.weight: isSelected ? Font.Bold : Font.DemiBold
                                        wrapMode: Text.WordWrap
                                        maximumLineCount: 2
                                        elide: Text.ElideRight
                                        lineHeight: 1.15
                                        width: parent.width
                                    }

                                    // Timestamp
                                    Text {
                                        text: model.timeText
                                        color: Qt.rgba(255, 255, 255, 0.45)
                                        font.family: "Inter"
                                        font.pixelSize: 10
                                        font.weight: Font.Normal
                                    }
                                }

                                // Right Bookmark Icon Button
                                Item {
                                    width: 32
                                    height: parent.height
                                    anchors.verticalCenter: parent.verticalCenter

                                    Image {
                                        anchors.centerIn: parent
                                        width: 18
                                        height: 18
                                        source: model.isBookmarked ? "qrc:/ApexVision/qml/assets/icons/news_bookmark_filled.svg" : "qrc:/ApexVision/qml/assets/icons/news_bookmark.svg"
                                        fillMode: Image.PreserveAspectFit
                                        opacity: model.isBookmarked ? 1.0 : (isSelected ? 0.90 : 0.45)
                                        smooth: true
                                    }

                                    MouseArea {
                                        anchors.fill: parent
                                        cursorShape: Qt.PointingHandCursor
                                        onClicked: {
                                            model.isBookmarked = !model.isBookmarked;
                                        }
                                    }
                                }
                            }

                            // Card Click MouseArea
                            MouseArea {
                                id: cardMouse
                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor
                                onClicked: {
                                    root.selectedArticleIndex = index;
                                }
                            }
                        }
                    }
                }
            }

            // -----------------------------------------------------------------
            // RIGHT COLUMN: FEATURED ARTICLE / HERO DETAIL VIEW
            // -----------------------------------------------------------------
            Item {
                id: rightDetailColumn
                anchors.left: leftFeedColumn.right
                anchors.leftMargin: 24
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.bottom: parent.bottom

                // Smooth Fade Animation on Article Selection Change
                Behavior on opacity {
                    NumberAnimation { duration: 180 }
                }

                // Top Hero Image Container (HD Photo)
                Rectangle {
                    id: heroImageContainer
                    anchors.top: parent.top
                    anchors.left: parent.left
                    anchors.right: parent.right
                    height: parent.height * 0.52
                    radius: 16
                    clip: true
                    color: "#0F1A2A"

                    // VehicleMenuCard Glass Border
                    border.color: Qt.rgba(225/255, 242/255, 255/255, 0.36)
                    border.width: 1

                    Image {
                        id: heroImage
                        anchors.fill: parent
                        source: root.activeStory ? root.activeStory.image : root.categories[root.activeCategoryIndex].heroImage
                        fillMode: Image.PreserveAspectCrop
                        smooth: true
                        mipmap: true
                        cache: true
                        asynchronous: true
                    }

                    // Floating Bookmark Button on Top-Right of Hero Image (Matching Image)
                    Rectangle {
                        anchors.top: parent.top
                        anchors.right: parent.right
                        anchors.margins: 14
                        width: 38
                        height: 38
                        radius: 10
                        gradient: Gradient {
                            GradientStop { position: 0.0; color: Qt.rgba(215/255, 238/255, 255/255, 0.28) }
                            GradientStop { position: 1.0; color: Qt.rgba(195/255, 225/255, 255/255, 0.18) }
                        }
                        border.color: Qt.rgba(255, 255, 255, 0.40)
                        border.width: 1

                        Image {
                            anchors.centerIn: parent
                            width: 18
                            height: 18
                            source: (root.activeStory && root.activeStory.isBookmarked) ? "qrc:/ApexVision/qml/assets/icons/news_bookmark_filled.svg" : "qrc:/ApexVision/qml/assets/icons/news_bookmark.svg"
                            fillMode: Image.PreserveAspectFit
                            smooth: true
                        }

                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                if (root.activeStory) {
                                    root.activeStory.isBookmarked = !root.activeStory.isBookmarked;
                                }
                            }
                        }
                    }

                    // Floating Voice Audio Readout Action (Vehiclebar Glass Button)
                    Rectangle {
                        anchors.top: parent.top
                        anchors.left: parent.left
                        anchors.margins: 14
                        height: 32
                        width: audioListenRow.implicitWidth + 20
                        radius: 16
                        gradient: Gradient {
                            GradientStop {
                                position: 0.0
                                color: root.isSpeaking ? Qt.rgba(225/255, 242/255, 255/255, 0.38) : Qt.rgba(215/255, 238/255, 255/255, 0.25)
                            }
                            GradientStop {
                                position: 1.0
                                color: root.isSpeaking ? Qt.rgba(205/255, 232/255, 255/255, 0.30) : Qt.rgba(195/255, 225/255, 255/255, 0.15)
                            }
                        }
                        border.color: root.isSpeaking ? Qt.rgba(255, 255, 255, 0.85) : Qt.rgba(255, 255, 255, 0.40)
                        border.width: 1

                        Row {
                            id: audioListenRow
                            anchors.centerIn: parent
                            spacing: 6

                            Image {
                                width: 14
                                height: 14
                                source: root.isSpeaking ? "qrc:/ApexVision/qml/assets/icons/news_pause.svg" : "qrc:/ApexVision/qml/assets/icons/news_speaker.svg"
                                fillMode: Image.PreserveAspectFit
                                anchors.verticalCenter: parent.verticalCenter
                                smooth: true
                            }

                            Text {
                                text: root.isSpeaking ? "Speaking" : "Listen Aloud"
                                color: "#FFFFFF"
                                font.family: "Inter"
                                font.pixelSize: 11
                                font.weight: Font.DemiBold
                                anchors.verticalCenter: parent.verticalCenter
                            }
                        }

                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                if (root.isSpeaking) {
                                    root.stopSpeaking();
                                } else {
                                    root.speakCurrentStory();
                                }
                            }
                        }
                    }
                }

                // Bottom Story Details Area
                Item {
                    id: heroDetailsArea
                    anchors.top: heroImageContainer.bottom
                    anchors.topMargin: 14
                    anchors.bottom: parent.bottom
                    anchors.left: parent.left
                    anchors.right: parent.right

                    Column {
                        anchors.fill: parent
                        spacing: 8

                        // Category Tag
                        Text {
                            text: root.activeStory ? root.activeStory.category : root.categories[root.activeCategoryIndex].name
                            color: Qt.rgba(255, 255, 255, 0.70)
                            font.family: "Inter"
                            font.pixelSize: 13
                            font.weight: Font.DemiBold
                        }

                        // Big Bold Headline (Matching 2-line layout in reference image)
                        Text {
                            text: root.activeStory ? root.activeStory.headline : "Loading latest wire story..."
                            color: "#FFFFFF"
                            font.family: "Inter"
                            font.pixelSize: 21
                            font.weight: Font.Bold
                            wrapMode: Text.WordWrap
                            maximumLineCount: 2
                            elide: Text.ElideRight
                            lineHeight: 1.2
                            width: parent.width
                        }

                        // Author & Timestamp Row
                        Text {
                            text: root.activeStory ? root.activeStory.authorInfo : ""
                            color: Qt.rgba(255, 255, 255, 0.50)
                            font.family: "Inter"
                            font.pixelSize: 11
                            font.weight: Font.Medium
                        }

                        // Full Article Excerpt Paragraph
                        Text {
                            text: root.activeStory ? root.activeStory.body : ""
                            color: Qt.rgba(255, 255, 255, 0.80)
                            font.family: "Inter"
                            font.pixelSize: 14
                            font.weight: Font.Normal
                            wrapMode: Text.WordWrap
                            maximumLineCount: 4
                            elide: Text.ElideRight
                            lineHeight: 1.35
                            width: parent.width
                        }
                    }
                }
            }
        }
    }

    // =========================================================================
    // CATEGORY SWITCHER & REAL-TIME NEWS ENGINE
    // =========================================================================
    function switchCategory(catIdx) {
        root.activeCategoryIndex = catIdx;
        root.selectedArticleIndex = 0;

        // Populate from category verified HD stories (zero flicker!)
        var cat = root.categories[catIdx];
        newsModel.clear();
        for (var i = 0; i < cat.stories.length; i++) {
            newsModel.append(cat.stories[i]);
        }

        // Live wire update query in background for non-curated categories
        if (catIdx !== 0 && cat.query && cat.query.length > 0) {
            root.fetchLiveNews(cat.query, cat.name, true);
        }
    }

    function speakCurrentStory() {
        if (!root.activeStory) return;
        root.isSpeaking = true;
        var text = root.activeStory.headline + ". " + root.activeStory.body;
        if (typeof SystemBackend !== "undefined" && SystemBackend.playTtsSample) {
            SystemBackend.playTtsSample(text, 1.0, 1.0);
        }
    }

    function stopSpeaking() {
        root.isSpeaking = false;
        if (typeof SystemBackend !== "undefined" && SystemBackend.stopTts) {
            SystemBackend.stopTts();
        }
    }

    function fetchLiveNews(queryUrl, expectedCatName, isTabSwitch) {
        root.isLoading = true;
        var xhr = new XMLHttpRequest();
        xhr.open("GET", queryUrl, true);
        xhr.setRequestHeader("User-Agent", "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36");
        xhr.timeout = 7000;

        xhr.onreadystatechange = function() {
            if (xhr.readyState === XMLHttpRequest.DONE) {
                root.isLoading = false;
                if (xhr.status === 200 && xhr.responseText.length > 100) {
                    // Only apply if the user is still on this category
                    if (root.categories[root.activeCategoryIndex].name === expectedCatName) {
                        parseLiveRss(xhr.responseText, expectedCatName, isTabSwitch);
                    }
                }
            }
        };

        xhr.ontimeout = function() { root.isLoading = false; };
        xhr.onerror = function() { root.isLoading = false; };

        try {
            xhr.send();
        } catch (e) {
            root.isLoading = false;
        }
    }

    function parseLiveRss(xmlText, expectedCatName, isTabSwitch) {
        var cat = root.categories[root.activeCategoryIndex];
        var imagePool = (cat && cat.categoryImages && cat.categoryImages.length > 0) ? cat.categoryImages : [];
        var items = [];
        var itemPattern = /<item>([\s\S]*?)<\/item>/gi;
        var match;
        var count = 0;

        while ((match = itemPattern.exec(xmlText)) !== null && count < 6) {
            var itemXml = match[1];

            // Title
            var titleMatch = itemXml.match(/<title>([\s\S]*?)<\/title>/i);
            var rawTitle = titleMatch ? titleMatch[1] : "News Update";
            rawTitle = stripHtml(stripCdata(rawTitle)).trim();

            // Publisher
            var publisher = "News Wire";
            var lastDash = rawTitle.lastIndexOf(" - ");
            if (lastDash !== -1) {
                publisher = rawTitle.substring(lastDash + 3).trim();
                rawTitle = rawTitle.substring(0, lastDash).trim();
            }

            // PubDate
            var dateMatch = itemXml.match(/<pubDate>([\s\S]*?)<\/pubDate>/i);
            var rawDate = dateMatch ? dateMatch[1] : "";
            var timeText = "Just now";
            if (rawDate) {
                try {
                    var d = new Date(rawDate);
                    var diffMins = Math.floor((new Date() - d) / 60000);
                    if (diffMins < 60) timeText = Math.max(1, diffMins) + "m ago";
                    else if (diffMins < 1440) timeText = Math.floor(diffMins / 60) + "h ago";
                    else timeText = Math.floor(diffMins / 1440) + "d ago";
                } catch (e) {
                    timeText = "Recent";
                }
            }

            // Description / Body
            var descMatch = itemXml.match(/<description>([\s\S]*?)<\/description>/i);
            var rawDesc = descMatch ? descMatch[1] : "";
            var body = "";

            var firstItemMatch = rawDesc.match(/<li[^>]*>([\s\S]*?)<\/li>/i);
            if (firstItemMatch) {
                body = stripHtml(stripCdata(firstItemMatch[1])).trim();
            } else {
                body = stripHtml(stripCdata(rawDesc)).trim();
            }

            if (body.length > 260) {
                var cut = body.substring(0, 250);
                var lastSpace = cut.lastIndexOf(" ");
                if (lastSpace !== -1) cut = cut.substring(0, lastSpace);
                body = cut + "...";
            }

            if (body.length < 20 || body === rawTitle) {
                body = "Continuous live telematics wire broadcast from " + publisher + ". Comprehensive automotive report on " + rawTitle + ".";
            }

            // Topic-matched image strictly from this category pool
            var thumb = (imagePool.length > 0) ? imagePool[count % imagePool.length] : (cat.heroImage || "");

            items.push({
                category: expectedCatName,
                headline: rawTitle,
                authorInfo: timeText + " • By " + publisher,
                timeText: timeText,
                image: thumb,
                body: body,
                isBookmarked: (count === 0)
            });

            count++;
        }

        if (items.length > 0) {
            newsModel.clear();
            for (var j = 0; j < items.length; j++) {
                newsModel.append(items[j]);
            }
            if (isTabSwitch) {
                root.selectedArticleIndex = 0;
            }
        }
    }

    function stripCdata(text) {
        return text.replace(/<!\[CDATA\[([\s\S]*?)\]\]>/g, '$1');
    }

    function stripHtml(html) {
        if (!html) return "";
        var clean = html.replace(/&lt;/g, '<')
                        .replace(/&gt;/g, '>')
                        .replace(/&quot;/g, '"')
                        .replace(/&apos;/g, "'")
                        .replace(/&#39;/g, "'")
                        .replace(/&amp;/g, '&')
                        .replace(/&nbsp;/g, ' ');
        clean = clean.replace(/<[^>]*>?/gm, ' ');
        return clean.replace(/\s+/g, ' ').trim();
    }

    Component.onCompleted: {
        switchCategory(0);
    }
}
