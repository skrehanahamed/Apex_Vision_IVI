import QtQuick
import QtQuick.Controls

Item {
    id: root

    signal backRequested()

    property int activeCategoryIndex: 0
    property int selectedArticleIndex: 0
    property bool isLoading: false

    // Distinct Briefing Modes: "none", "all", "single"
    property string briefingMode: "none"
    readonly property bool isSpeaking: briefingMode !== "none"
    property bool wasMusicPlayingBeforeDictation: false

    // Persistent in-memory cache for all news stories across categories
    property var newsStore: ({})

    // Automatic Continuous News Dictation Timer (Used only in "all" briefing mode)
    Timer {
        id: autoAdvanceTimer
        interval: 1200 // 1.2-second natural broadcast pause between stories
        repeat: false
        onTriggered: {
            if (root.briefingMode === "all" && newsModel.count > 0) {
                var nextIdx = root.selectedArticleIndex + 1;
                if (nextIdx < newsModel.count) {
                    root.selectedArticleIndex = nextIdx;
                    articlesListView.positionViewAtIndex(nextIdx, ListView.Contain);
                    root.dictateStoryAt(nextIdx);
                } else {
                    // Loop back to the first story to keep reading
                    root.selectedArticleIndex = 0;
                    articlesListView.positionViewAtIndex(0, ListView.Contain);
                    root.dictateStoryAt(0);
                }
            }
        }
    }

    // Precise TTS Completion Listener (Never cuts off early!)
    Connections {
        target: typeof SystemBackend !== "undefined" ? SystemBackend : null
        function onTtsFinished() {
            if (root.briefingMode === "all") {
                autoAdvanceTimer.interval = 1200;
                autoAdvanceTimer.restart();
            } else if (root.briefingMode === "single") {
                // Single story briefing completes: stop cleanly without advancing!
                root.stopBriefing();
            }
        }
    }

    // =========================================================================
    // EXPANDED CATEGORIES WITH RICH STORIES & VERIFIED HD IMAGES
    // =========================================================================
    readonly property var categories: [
        {
            name: "Top Stories",
            heroImage: "qrc:/ApexVision/qml/assets/news_images/photo_1593941707882-a5bba14938c7.jpg",
            stories: [
                {
                    category: "Automotive",
                    headline: "Global EV Sales Hit New Record High in 2024 with Next-Gen Battery Rollouts",
                    authorInfo: "20m ago • By Auto News Desk",
                    timeText: "20m ago",
                    image: "qrc:/ApexVision/qml/assets/news_images/photo_1593941707882-a5bba14938c7.jpg",
                    body: "Global electric vehicle sales have surged past prior annual records, driven by accelerated charging infrastructure, attractive pricing on modular platforms, and breakthrough solid-state battery chemistry. Independent analysts predict momentum will accelerate further throughout the coming quarters as major automakers expand their regional manufacturing corridors.",
                    isBookmarked: false
                },
                {
                    category: "Technology",
                    headline: "Next-Gen LEO Satellite Constellation Brings Ultra-Low Latency Connectivity Globally",
                    authorInfo: "45m ago • By Tech Wire",
                    timeText: "45m ago",
                    image: "qrc:/ApexVision/qml/assets/news_images/photo_1516849841032-87cbac4d88f7.jpg",
                    body: "A newly deployed constellation of low-Earth orbit telecommunication satellites achieved operational orbit today. The network reduces intercontinental latency below twenty milliseconds while extending gigabit wireless data coverage across remote shipping lanes, rural communities, and high-altitude flight routes.",
                    isBookmarked: false
                },
                {
                    category: "Business",
                    headline: "Multilateral Green Energy Initiative Allocates Historic Fifty Billion Dollar Capital Pool",
                    authorInfo: "1 hour ago • By Financial Times",
                    timeText: "1h ago",
                    image: "qrc:/ApexVision/qml/assets/news_images/photo_1466611653911-95081537e5b7.jpg",
                    body: "International financing consortiums have committed substantial capital towards high-capacity energy storage, solar microgrids, and green hydrogen synthesis facilities. The multi-decade investment framework is engineered to accelerate regional industrial decarbonization and enhance grid resilience during seasonal peak consumption.",
                    isBookmarked: false
                },
                {
                    category: "Sports",
                    headline: "Championship Finale Thrills International Spectators with Dramatic Final Over Victory",
                    authorInfo: "2 hours ago • By Global Sports Desk",
                    timeText: "2h ago",
                    image: "qrc:/ApexVision/qml/assets/news_images/photo_1540747913346-19e32dc3e97e.jpg",
                    body: "An electrifying championship showdown concluded in nail-biting fashion as defensive mastery and tactical brilliance in the final moments secured an unforgettable title victory. More than eighty-five thousand electrified spectators cheered on their heroes in one of the most celebrated matches of modern sporting history.",
                    isBookmarked: false
                },
                {
                    category: "Science",
                    headline: "James Webb Telescope Discovers Atmospheric Water Signatures on Earth-Sized Exoplanet",
                    authorInfo: "3 hours ago • By Astrophysical Journal",
                    timeText: "3h ago",
                    image: "qrc:/ApexVision/qml/assets/news_images/photo_1507413245164-6160d8298b31.jpg",
                    body: "Infrared transmission spectroscopy collected by the space telescope has confirmed water vapor and condensable clouds within the habitable zone of an Earth-sized planet forty light-years distant. Researchers highlight this as the strongest atmospheric biosignature candidate detected beyond our solar system to date.",
                    isBookmarked: false
                },
                {
                    category: "Environment",
                    headline: "Autonomous Ocean Barrier Fleets Successfully Clean Hundred Thousand Tons of Ocean Waste",
                    authorInfo: "4 hours ago • By Marine Ecology Wire",
                    timeText: "4h ago",
                    image: "qrc:/ApexVision/qml/assets/news_images/photo_1542601906990-b4d3fb778b09.jpg",
                    body: "Solar-powered maritime recovery craft stationed across oceanic convergence zones have officially collected and recycled over one hundred thousand metric tons of marine plastics. Recovered polymers are being re-engineered into high-grade automotive interior composites and sustainable architectural materials.",
                    isBookmarked: false
                }
            ]
        },
        {
            name: "Automotive",
            heroImage: "qrc:/ApexVision/qml/assets/news_images/photo_1503376780353-7e6692767b70.jpg",
            stories: [
                {
                    category: "Automotive",
                    headline: "Automakers Unveil Ultra-Fast 800V Charging Architectures Across Commercial Fleets",
                    authorInfo: "25m ago • By Motor Intelligence",
                    timeText: "25m ago",
                    image: "qrc:/ApexVision/qml/assets/news_images/photo_1503376780353-7e6692767b70.jpg",
                    body: "Next-generation silicon-carbide inverters and 800-volt high-voltage architectures are reducing standard ten to eighty percent charging intervals to just twelve minutes. Leading automotive engineers emphasize that these rapid replenishment speeds match traditional refueling times, transforming cross-country electric touring.",
                    isBookmarked: false
                },
                {
                    category: "Automotive",
                    headline: "Megawatt EV Highway Fast-Charging Hubs Open Across Major Continental Transport Routes",
                    authorInfo: "1 hour ago • By EV Dynamics",
                    timeText: "1h ago",
                    image: "qrc:/ApexVision/qml/assets/news_images/photo_1563720223185-11003d516935.jpg",
                    body: "A nationwide network of liquid-cooled four-hundred-kilowatt hyper-chargers began commercial operations today along primary freight and passenger arteries. Equipped with automated plug-and-charge billing and integrated buffer batteries, the stations ensure uninterrupted high-power charging even during peak grid strain.",
                    isBookmarked: false
                },
                {
                    category: "Automotive",
                    headline: "Intelligent Cockpits Debut Augmented Reality 3D Windshield Heads-Up Displays",
                    authorInfo: "2 hours ago • By Auto Tech Review",
                    timeText: "2h ago",
                    image: "qrc:/ApexVision/qml/assets/news_images/photo_1552519507-da3b142c6e3d.jpg",
                    body: "High-performance onboard neural coprocessors now project vivid three-dimensional navigation vectors and real-time hazard markers directly onto the windshield surface. The system synchronizes contextual route alerts with dynamic interior ambient lighting to deliver unprecedented situational clarity for drivers.",
                    isBookmarked: false
                },
                {
                    category: "Automotive",
                    headline: "Solid-State Battery Production Pilot Demonstrates 750-Mile Single-Charge Endurance",
                    authorInfo: "3 hours ago • By Battery Horizon",
                    timeText: "3h ago",
                    image: "qrc:/ApexVision/qml/assets/news_images/photo_1617814076367-b759c7d7e738.jpg",
                    body: "Rigorous track and dynamometer testing of newly certified ceramic solid-state battery cells confirmed over seven hundred and fifty miles of continuous highway range. In addition to doubling volumetric energy density, the solid electrolytes eliminate flammability risks across extreme temperature ranges.",
                    isBookmarked: false
                },
                {
                    category: "Automotive",
                    headline: "High-Efficiency Axial-Flux Electric Motors Deliver Double the Torque at Half the Mass",
                    authorInfo: "4 hours ago • By Powertrain Quarterly",
                    timeText: "4h ago",
                    image: "qrc:/ApexVision/qml/assets/news_images/photo_1511919884226-fd3cad34687c.jpg",
                    body: "Breakthrough compact axial-flux electric drive units developed for performance sports coupes deliver exceptional power densities exceeding twelve kilowatts per kilogram. Their ultra-flat packaging enables designers to optimize cabin roominess and lower vehicle centers of gravity for superior cornering dynamics.",
                    isBookmarked: false
                },
                {
                    category: "Automotive",
                    headline: "Centralized Software-Defined Vehicle Architecture Slashes Onboard Wiring Harnesses by 60%",
                    authorInfo: "5 hours ago • By Automotive Weekly",
                    timeText: "5h ago",
                    image: "qrc:/ApexVision/qml/assets/news_images/photo_1542282088-72c9c27ed0cd.jpg",
                    body: "By consolidating dozens of discrete electronic control units into redundant zonal compute hubs, vehicle manufacturers have shaved sixty percent off traditional wiring weight. The streamlined topology enables seamless over-the-air firmware updates and significantly improves manufacturing assembly efficiency.",
                    isBookmarked: false
                }
            ]
        },
        {
            name: "Technology",
            heroImage: "qrc:/ApexVision/qml/assets/news_images/photo_1518770660439-4636190af475.jpg",
            stories: [
                {
                    category: "Technology",
                    headline: "Breakthrough On-Device Edge Neural Processing Delivers Desktop-Class Intelligence",
                    authorInfo: "30m ago • By Silicon Digest",
                    timeText: "30m ago",
                    image: "qrc:/ApexVision/qml/assets/news_images/photo_1518770660439-4636190af475.jpg",
                    body: "Semiconductor innovators unveiled two-nanometer mobile neural processing units capable of executing complex language and computer vision models entirely offline. The chips consume under five watts while safeguarding user privacy through localized hardware encryption and instant sensor telemetry processing.",
                    isBookmarked: false
                },
                {
                    category: "Technology",
                    headline: "Photonic Microprocessors Harness Light Waveguides for Zero-Latency Data Center Computing",
                    authorInfo: "1 hour ago • By Tech Radar",
                    timeText: "1h ago",
                    image: "qrc:/ApexVision/qml/assets/news_images/photo_1526374965328-7f61d4dc18c5.jpg",
                    body: "Researchers have demonstrated integrated optical silicon chips that transfer data using guided laser pulses rather than copper traces. By eliminating thermal resistance and parasitic capacitance, the optical interconnects multiply cluster bandwidth tenfold while reducing server cooling energy demands by forty percent.",
                    isBookmarked: false
                },
                {
                    category: "Technology",
                    headline: "Open-Source Autonomous Robotics Foundation Standardizes Spatial Navigation Telemetry",
                    authorInfo: "2 hours ago • By Robotics World",
                    timeText: "2h ago",
                    image: "qrc:/ApexVision/qml/assets/news_images/photo_1485827404703-89b55fcc595e.jpg",
                    body: "A global alliance of industrial automation leaders announced open standards for robotic localization, simultaneous mapping, and perception pipelines. The shared framework guarantees cross-platform interoperability across autonomous warehouse logistics, drone inspections, and smart manufacturing robotics.",
                    isBookmarked: false
                },
                {
                    category: "Technology",
                    headline: "High-Fidelity Spatial Audio Engine Delivers Naturalistic 3D Soundscapes on Mobile Devices",
                    authorInfo: "3 hours ago • By Audio Engineering Today",
                    timeText: "3h ago",
                    image: "qrc:/ApexVision/qml/assets/news_images/photo_1511671782779-c97d3d27a1d4.jpg",
                    body: "New psychoacoustic modeling algorithms calculate personalized head-related transfer functions using standard camera scans. The resulting spatial binaural acoustics render pin-point acoustic positioning with life-like reverberation, elevating in-cabin media playback and hands-free communications.",
                    isBookmarked: false
                },
                {
                    category: "Technology",
                    headline: "Solid-State Quantum Memory Register Retains Qubit Coherence at Elevated Temperatures",
                    authorInfo: "4 hours ago • By Quantum Wire",
                    timeText: "4h ago",
                    image: "qrc:/ApexVision/qml/assets/news_images/photo_1635070041078-e363dbe005cb.jpg",
                    body: "Physicists have developed diamond nitrogen-vacancy quantum registers capable of retaining coherent state superpositions for hundreds of milliseconds at temperatures ten times higher than cryogenic minimums. The advancement brings distributed quantum internet networks a step closer to practical reality.",
                    isBookmarked: false
                },
                {
                    category: "Technology",
                    headline: "Next-Generation Solid-State Micro-LiDAR Sensors Integrate Entire Optical Bench on Chip",
                    authorInfo: "5 hours ago • By Sensor Horizons",
                    timeText: "5h ago",
                    image: "qrc:/ApexVision/qml/assets/news_images/photo_1504384308090-c894fdcc538d.jpg",
                    body: "A miniature silicon-photonics LiDAR module eliminates all moving mirrors through optical phased-array beam steering. Measuring under five centimeters, the robust solid-state sensor provides millimeter-accurate three-hundred-meter point clouds in heavy fog and glaring sunlight.",
                    isBookmarked: false
                }
            ]
        },
        {
            name: "Business",
            heroImage: "qrc:/ApexVision/qml/assets/news_images/photo_1486406146926-c627a92ad1ab.jpg",
            stories: [
                {
                    category: "Business",
                    headline: "Global Clean Energy Capital Investments Surpass Trillion-Dollar Milestone Ahead of Forecasts",
                    authorInfo: "40m ago • By Market Watch",
                    timeText: "40m ago",
                    image: "qrc:/ApexVision/qml/assets/news_images/photo_1486406146926-c627a92ad1ab.jpg",
                    body: "Annual investment in sustainable technology, battery gigafactories, and clean power grids has crossed one trillion dollars for the second consecutive year. Institutional asset managers credit technological parity, favorable regulatory frameworks, and strong industrial demand for outperforming conventional energy assets.",
                    isBookmarked: false
                },
                {
                    category: "Business",
                    headline: "Advanced Semiconductor Foundries Announce Joint Global Supply Chain Resiliency Pact",
                    authorInfo: "1 hour ago • By Financial Review",
                    timeText: "1h ago",
                    image: "qrc:/ApexVision/qml/assets/news_images/photo_1590283603385-17ffb3a7f29f.jpg",
                    body: "Major semiconductor manufacturing hubs in Europe, North America, and East Asia have ratified cross-regional capacity sharing agreements. The cooperative blueprint establishes buffer inventories for essential automotive and industrial microcontrollers to prevent supply chain bottlenecks.",
                    isBookmarked: false
                },
                {
                    category: "Business",
                    headline: "Electric Commercial Aviation Venture Receives Preliminary Multi-Airline Fleet Orders",
                    authorInfo: "2 hours ago • By Aviation Daily",
                    timeText: "2h ago",
                    image: "qrc:/ApexVision/qml/assets/news_images/photo_1436491865332-7a61a109cc05.jpg",
                    body: "Regional passenger airlines have committed to purchasing three hundred nineteen-seat hybrid-electric aircraft designed for short-haul island and metropolitan feeder routes. The aircraft lower operational direct seat costs by forty-five percent while reducing carbon emissions to zero during takeoff and cruising.",
                    isBookmarked: false
                },
                {
                    category: "Business",
                    headline: "Automated Digital Maritime Ports Reduce Container Turnaround Durations by Thirty Percent",
                    authorInfo: "3 hours ago • By Global Trade Gazette",
                    timeText: "3h ago",
                    image: "qrc:/ApexVision/qml/assets/news_images/photo_1586528116311-ad8dd3c8310d.jpg",
                    body: "Deepwater container hubs employing automated electric gantry cranes and AI logistics dispatch have slashed cargo dwell times from fifty hours down to under thirty-four. Port authorities cite seamless interoperability with electric rail freight for the dramatic operational efficiency boost.",
                    isBookmarked: false
                },
                {
                    category: "Business",
                    headline: "Green Municipal Infrastructure Bonds Attract Record Over-Subscription Among Global Investors",
                    authorInfo: "4 hours ago • By Capital Markets Weekly",
                    timeText: "4h ago",
                    image: "qrc:/ApexVision/qml/assets/news_images/photo_1454165804606-c3d57bc86b40.jpg",
                    body: "City governments across major metropolitan regions successfully issued fifteen billion dollars in certified green bonds designated for electric transit expansion and stormwater capture basins. Strong investor appetite resulted in four-fold over-subscription within three hours of book opening.",
                    isBookmarked: false
                },
                {
                    category: "Business",
                    headline: "Global Circular Economy Index Shows Doubled Recycled Polymer Utilization Across Manufacturing",
                    authorInfo: "5 hours ago • By Sustainability Business",
                    timeText: "5h ago",
                    image: "qrc:/ApexVision/qml/assets/news_images/photo_1532996122724-e3c354a0b15b.jpg",
                    body: "The annual circularity benchmark report highlights a doubling of closed-loop recycled plastics and certified green aluminum across automotive and consumer electronics lines. Cost-parity achievements have driven voluntary industrial adoption faster than mandated governmental timelines.",
                    isBookmarked: false
                }
            ]
        },
        {
            name: "Sports",
            heroImage: "qrc:/ApexVision/qml/assets/news_images/photo_1540747913346-19e32dc3e97e.jpg",
            stories: [
                {
                    category: "Sports",
                    headline: "Historic Championship Finale Decided by Stunner in Stoppage Time Before Capacity Crowd",
                    authorInfo: "35m ago • By Global Sports",
                    timeText: "35m ago",
                    image: "qrc:/ApexVision/qml/assets/news_images/photo_1540747913346-19e32dc3e97e.jpg",
                    body: "A breathless clash of titans ended with a stunning overhead volley in the ninety-fourth minute, sending ninety thousand roaring fans into wild celebrations. The hard-fought triumph seals an undefeated tournament campaign and cements the team's standing as one of the era's greatest dynasties.",
                    isBookmarked: false
                },
                {
                    category: "Sports",
                    headline: "Electric Grand Prix Championship Smashes Circuit Lap Records with Gen-3 Twin Motor Racers",
                    authorInfo: "1 hour ago • By Motorsport Daily",
                    timeText: "1h ago",
                    image: "qrc:/ApexVision/qml/assets/news_images/photo_1568605117036-5fe5e7bab0b7.jpg",
                    body: "Twin-motor all-electric single-seaters capable of six-hundred-kilowatt regeneration shaved three full seconds off the historic harbor street course record. Spectators enjoyed twenty-six overtakes during the fifty-lap sprint, highlighting the intense competitive parity of modern electric motorsport.",
                    isBookmarked: false
                },
                {
                    category: "Sports",
                    headline: "Hydrofoil Sailing Cup Final Sees Record-Breaking Speeds Exceeding Fifty-Five Knots",
                    authorInfo: "2 hours ago • By Regatta World",
                    timeText: "2h ago",
                    image: "qrc:/ApexVision/qml/assets/news_images/photo_1507525428034-b723cf961d3e.jpg",
                    body: "Flying across ocean swells on precision carbon-fiber hydrofoils, the defending champions clinched victory in the decisive seventh match race. The seventy-five-foot foiling monohulls demonstrated extraordinary seamanship while executing high-speed gybes without once touching water.",
                    isBookmarked: false
                },
                {
                    category: "Sports",
                    headline: "Marathon World Record Milestone Lowered as Endurance Athletics Technology Validates Gains",
                    authorInfo: "3 hours ago • By Athletics Gazette",
                    timeText: "3h ago",
                    image: "qrc:/ApexVision/qml/assets/news_images/photo_1461896836934-ffe607ba8211.jpg",
                    body: "Flawless race pacing, custom carbon-infused foam running shoes, and scientific carbohydrate intake plans powered a historic two-hour barrier attempt on the streets of Berlin. Enthusiastic crowds lined every kilometer to witness the breathtaking masterclass in human endurance.",
                    isBookmarked: false
                },
                {
                    category: "Sports",
                    headline: "Alpine Winter Games Introduce Autonomous High-Precision 3D Photogrammetry Timing",
                    authorInfo: "4 hours ago • By Winter Sports Today",
                    timeText: "4h ago",
                    image: "qrc:/ApexVision/qml/assets/news_images/photo_1551698618-1dfe5d97d256.jpg",
                    body: "Olympic downhill skiing officials deployed millimeter-accurate multi-camera LiDAR arrays along the steep downhill course, capturing finish intervals to the ten-thousandth of a second. The system provides broadcast audiences with real-time speed overlays at critical jumps and turns.",
                    isBookmarked: false
                },
                {
                    category: "Sports",
                    headline: "World Cycling Championship Concludes with Grueling Alpine Mountain Stage Triumph",
                    authorInfo: "5 hours ago • By Peloton Digest",
                    timeText: "5h ago",
                    image: "qrc:/ApexVision/qml/assets/news_images/photo_1485965120184-e220f721d03e.jpg",
                    body: "Battling torrential rain and twenty-percent gradients up the iconic mountain pass, a young climbing specialist launched a solo breakaway with twenty kilometers remaining to claim the coveted rainbow jersey. Fans celebrated the courageous display of tactical grit and climbing prowess.",
                    isBookmarked: false
                }
            ]
        },
        {
            name: "Science",
            heroImage: "qrc:/ApexVision/qml/assets/news_images/photo_1507413245164-6160d8298b31.jpg",
            stories: [
                {
                    category: "Science",
                    headline: "Deep Space Telescope Detects Atmospheric Water Vapor on Habitable-Zone Exoplanet",
                    authorInfo: "50m ago • By Astrophysical Journal",
                    timeText: "50m ago",
                    image: "qrc:/ApexVision/qml/assets/news_images/photo_1507413245164-6160d8298b31.jpg",
                    body: "Spectroscopic transmission data gathered during orbital transits confirmed clear signs of condensable vapor and temperate clouds in the upper atmosphere of a rocky world forty-eight light-years away. Planetary scientists consider this target the prime laboratory for atmospheric habitability studies.",
                    isBookmarked: false
                },
                {
                    category: "Science",
                    headline: "Fusion Energy Experiment Sustains Record Core Plasma Confinement for Twenty Minutes",
                    authorInfo: "1 hour ago • By Nuclear Physics Today",
                    timeText: "1h ago",
                    image: "qrc:/ApexVision/qml/assets/news_images/photo_1532094349884-543bc11b234d.jpg",
                    body: "Advanced high-temperature superconducting magnetic coils successfully maintained stellarator plasma equilibrium at one hundred million degrees Celsius without disruptive turbulence. The sustained operation provides crucial engineering validation for next-generation pilot fusion power stations.",
                    isBookmarked: false
                },
                {
                    category: "Science",
                    headline: "Deep Ocean Expedition Discovers Thriving Ecosystems Powered by Hydrogen Vent Chemistry",
                    authorInfo: "2 hours ago • By Ocean Science Review",
                    timeText: "2h ago",
                    image: "qrc:/ApexVision/qml/assets/news_images/photo_1518152006812-edab29b069ac.jpg",
                    body: "Submersible exploratory probes mapping the Mariana Trench encountered unique chemosynthetic communities thriving five miles beneath surface sunlight. The creatures derive metabolic energy from serpentine rock reactions that produce hydrogen, shedding light on the biochemical origins of life on Earth.",
                    isBookmarked: false
                },
                {
                    category: "Science",
                    headline: "Superconducting Room-Temperature Candidate Compound Validated Across Independent Labs",
                    authorInfo: "3 hours ago • By Materials Chemistry",
                    timeText: "3h ago",
                    image: "qrc:/ApexVision/qml/assets/news_images/photo_1507668077129-56e32842fceb.jpg",
                    body: "Replication studies by international condensed matter laboratories confirmed zero electrical resistance and magnetic levitation in a novel copper-substituted apatite structure at room temperatures. If scalable, the material could revolutionize energy grids, magnetic resonance imaging, and magnetic levitation trains.",
                    isBookmarked: false
                },
                {
                    category: "Science",
                    headline: "Gravitational Wave Observatories Capture Rare Intermediate Black Hole Merger Signal",
                    authorInfo: "4 hours ago • By Gravitational Physics",
                    timeText: "4h ago",
                    image: "qrc:/ApexVision/qml/assets/news_images/photo_1451187580459-43490279c0fa.jpg",
                    body: "Laser interferometer detectors identified space-time ripples originating from the collision of two dense stellar remnants three billion light-years distant. The resulting merger produced an intermediate-mass black hole measuring eighty solar masses, filling a long-standing missing link in astrophysical evolution.",
                    isBookmarked: false
                },
                {
                    category: "Science",
                    headline: "AI Structural Biology Platform Predicts Hundred Million Unmapped Protein Conformations",
                    authorInfo: "5 hours ago • By BioTech Frontiers",
                    timeText: "5h ago",
                    image: "qrc:/ApexVision/qml/assets/news_images/photo_1530497610245-94d3c16cda28.jpg",
                    body: "Deep neural folding models solved three-dimensional molecular structures for virtually every known protein sequence, providing an open-access compendium for global biochemists. Pharmaceutical labs are already using the models to synthesize highly specific enzymatic therapies for rare disorders.",
                    isBookmarked: false
                }
            ]
        },
        {
            name: "Entertainment",
            heroImage: "qrc:/ApexVision/qml/assets/news_images/photo_1514525253161-7a46d19cd819.jpg",
            stories: [
                {
                    category: "Entertainment",
                    headline: "International Cinema Gala Announces Golden Laurel Winners Celebrating Breakthrough Sound",
                    authorInfo: "45m ago • By Hollywood Reporter",
                    timeText: "45m ago",
                    image: "qrc:/ApexVision/qml/assets/news_images/photo_1514525253161-7a46d19cd819.jpg",
                    body: "Visionary filmmakers and celebrated actors assembled along the historic waterfront for the gala awards evening, honoring breakthrough independent features and auditory design. A groundbreaking allegorical science drama exploring deep-sea acoustic communication took top honors for Best Picture and Sound Design.",
                    isBookmarked: false
                },
                {
                    category: "Entertainment",
                    headline: "Spatial Audio Concert Broadcast Sets New Global Simultaneous Streaming Record",
                    authorInfo: "1 hour ago • By Billboard Music",
                    timeText: "1h ago",
                    image: "qrc:/ApexVision/qml/assets/news_images/photo_1492684223066-81342ee5ff30.jpg",
                    body: "Over fourteen million music fans tuned into a live stadium concert broadcast mixed natively in spatial 3D audio. Listeners experiencing the performance through vehicle sound systems reported astonishing acoustic dimensionality that mirrored the sensation of sitting in front-row VIP arena seating.",
                    isBookmarked: false
                },
                {
                    category: "Entertainment",
                    headline: "Next-Gen Virtual Production LED Stages Replace Traditional Physical Location Shooting",
                    authorInfo: "2 hours ago • By CineTech Gazette",
                    timeText: "2h ago",
                    image: "qrc:/ApexVision/qml/assets/news_images/photo_1489599849927-2ee91cede3ba.jpg",
                    body: "Massive curved ultra-high-definition LED volumes running real-time ray-traced rendering engines are revolutionizing feature film cinematography. Cameras tracking perspective in real time capture authentic in-camera lighting, reflections, and backgrounds without green screens or expensive location transport.",
                    isBookmarked: false
                },
                {
                    category: "Entertainment",
                    headline: "World Symphony Orchestra Premieres Acoustic Repertoire Built with Neural Synthesis",
                    authorInfo: "3 hours ago • By Classical Today",
                    timeText: "3h ago",
                    image: "qrc:/ApexVision/qml/assets/news_images/photo_1465847899084-d164df4dedc6.jpg",
                    body: "Acclaimed symphonic musicians performed an original four-movement concerto blending traditional string ensembles with microtonal digital synthesizers. The performance garnered an eight-minute standing ovation, celebrating harmonious symbiosis between classic orchestral heritage and modern digital soundscapes.",
                    isBookmarked: false
                },
                {
                    category: "Entertainment",
                    headline: "Documentary Film Festival Honors Indigenous Storytellers Preserving Oral Histories",
                    authorInfo: "4 hours ago • By Cultural Heritage Wire",
                    timeText: "4h ago",
                    image: "qrc:/ApexVision/qml/assets/news_images/photo_1478760329108-5c3ed9d495a0.jpg",
                    body: "Jurors awarded top documentary honors to a collaborative oral history initiative documenting ancient navigational techniques across Polynesian archipelagos. The film showcases how generations passed down precise star and wave-pattern readings without compasses or instruments.",
                    isBookmarked: false
                },
                {
                    category: "Entertainment",
                    headline: "Digital Museum Archives Release Two Million High-Resolution Art Masterpieces to Public",
                    authorInfo: "5 hours ago • By Arts & Heritage",
                    timeText: "5h ago",
                    image: "qrc:/ApexVision/qml/assets/news_images/photo_1544716278-ca5e3f4abd8c.jpg",
                    body: "A consortium of world-renowned galleries launched an open-access gigapixel repository featuring master paintings, sculptures, and rare manuscripts. The high-resolution captures reveal delicate brushstroke textures and underlying sketches previously invisible to the naked human eye.",
                    isBookmarked: false
                }
            ]
        },
        {
            name: "Health",
            heroImage: "qrc:/ApexVision/qml/assets/news_images/photo_1505751172876-fa1923c5c528.jpg",
            stories: [
                {
                    category: "Health",
                    headline: "Targeted Lipid Nanoparticle Therapy Demonstrates Remarkable Cellular Cardiac Healing",
                    authorInfo: "25m ago • By Medical Horizon",
                    timeText: "25m ago",
                    image: "qrc:/ApexVision/qml/assets/news_images/photo_1505751172876-fa1923c5c528.jpg",
                    body: "Precision-guided lipid nanoparticles delivering targeted messenger sequences successfully repaired damaged cardiac muscle fibers following acute ischemia in clinical trials. Patients exhibited significant improvements in cardiac output without any systemic inflammatory reactions or side effects.",
                    isBookmarked: false
                },
                {
                    category: "Health",
                    headline: "Non-Invasive Epidermal Biosensors Provide Continuous Real-Time Metabolic Intelligence",
                    authorInfo: "1 hour ago • By Digital Health Daily",
                    timeText: "1h ago",
                    image: "qrc:/ApexVision/qml/assets/news_images/photo_1576091160399-112ba8d25d1d.jpg",
                    body: "Ultra-thin wearable skin patches continuously sample interstitial fluid to measure glucose, lactate, and hydration levels without skin punctures. The sensors sync encrypted bio-telemetry with vehicle infotainment dashboards to offer personalized driver hydration and break reminders on long journeys.",
                    isBookmarked: false
                },
                {
                    category: "Health",
                    headline: "AI-Assisted Diagnostic Ultrasound Identifies Cardiovascular Anomalies in Under Sixty Seconds",
                    authorInfo: "2 hours ago • By Cardiology Review",
                    timeText: "2h ago",
                    image: "qrc:/ApexVision/qml/assets/news_images/photo_1516549655169-df83a0774514.jpg",
                    body: "Handheld ultrasound scanners powered by real-time computer vision models enable emergency responders to detect arterial blockages and valve irregularities instantly in ambulances. Early trials demonstrated ninety-eight percent diagnostic concordance with full hospital echocardiograms.",
                    isBookmarked: false
                },
                {
                    category: "Health",
                    headline: "Focused Ultrasonic Neuromodulation Therapy Reverses Chronic Migraine and Neural Pain",
                    authorInfo: "3 hours ago • By Neurological Annals",
                    timeText: "3h ago",
                    image: "qrc:/ApexVision/qml/assets/news_images/photo_1559757175-5700dde675bc.jpg",
                    body: "Non-invasive low-intensity focused ultrasound pulses precisely targeted at deep thalamic nerve clusters provided sustained relief for patients suffering from drug-resistant neuropathic pain. Researchers noted zero adverse cognitive impacts following twelve-week clinical follow-up.",
                    isBookmarked: false
                },
                {
                    category: "Health",
                    headline: "Bio-Compatible 3D-Printed Synthetic Tissue Grafts Accelerate Severe Burn Healing",
                    authorInfo: "4 hours ago • By Regenerative Medicine",
                    timeText: "4h ago",
                    image: "qrc:/ApexVision/qml/assets/news_images/photo_1584515979956-d9f6e5d09982.jpg",
                    body: "Surgeons have achieved rapid dermal regeneration using patient-derived autologous hydrogel scaffolds printed on demand in surgical suites. The living matrices integrate seamlessly with existing vasculature, reducing scar formation by seventy percent and halving hospital stay times.",
                    isBookmarked: false
                },
                {
                    category: "Health",
                    headline: "Rapid Genetic Sequencing Platform Identifies Novel Airborne Pathogens in Twenty Minutes",
                    authorInfo: "5 hours ago • By Public Health Gazette",
                    timeText: "5h ago",
                    image: "qrc:/ApexVision/qml/assets/news_images/photo_1579684385127-1ef15d508118.jpg",
                    body: "Compact nanopore sequencing devices deployed at international transit hubs can identify and sequence unknown respiratory viral variants within twenty minutes of air sampling. The proactive monitoring system provides health agencies with unprecedented real-time biosurveillance.",
                    isBookmarked: false
                }
            ]
        },
        {
            name: "World",
            heroImage: "qrc:/ApexVision/qml/assets/news_images/photo_1451187580459-43490279c0fa.jpg",
            stories: [
                {
                    category: "World",
                    headline: "Automated Cross-Border Digital Logistics Corridors Slash Cargo Transit Times Globally",
                    authorInfo: "30m ago • By International Affairs",
                    timeText: "30m ago",
                    image: "qrc:/ApexVision/qml/assets/news_images/photo_1451187580459-43490279c0fa.jpg",
                    body: "A multilateral consortium of forty trading nations launched an interoperable digital customs clearance network today. By replacing physical paperwork with encrypted ledger manifests and automated vehicle weigh-in-motion sensors, border crossing delays dropped from sixteen hours to under twenty minutes.",
                    isBookmarked: false
                },
                {
                    category: "World",
                    headline: "High-Speed Trans-Continental Rail Network Completes Final Alpine Tunnel Breakthrough",
                    authorInfo: "1 hour ago • By Global Infrastructure",
                    timeText: "1h ago",
                    image: "qrc:/ApexVision/qml/assets/news_images/photo_1486406146926-c627a92ad1ab.jpg",
                    body: "Tunnel boring machines completed the final breakthrough of the thirty-four-kilometer high-speed mountain corridor, linking major central European manufacturing centers directly with Mediterranean seaports. The electrified route will divert two million diesel freight trucks onto rail each year.",
                    isBookmarked: false
                },
                {
                    category: "World",
                    headline: "International Clean Desalination Treaty Funds Solar-Powered Coastal Fresh Water Plants",
                    authorInfo: "2 hours ago • By Diplomatic Dispatch",
                    timeText: "2h ago",
                    image: "qrc:/ApexVision/qml/assets/news_images/photo_1507525428034-b723cf961d3e.jpg",
                    body: "Ten arid nations ratified a shared water security charter to build zero-emission solar reverse-osmosis desalination complexes along coastal regions. Advanced brine-recovery crystallization units will produce industrial-grade minerals rather than returning high-salinity discharge to marine habitats.",
                    isBookmarked: false
                },
                {
                    category: "World",
                    headline: "Global Polar Research Consortium Launches Autonomous Arctic Climate Monitoring Floats",
                    authorInfo: "3 hours ago • By Polar Science Wire",
                    timeText: "3h ago",
                    image: "qrc:/ApexVision/qml/assets/news_images/photo_1517411032315-54ef2cb783bb.jpg",
                    body: "Dozens of ice-tethered autonomous sensor arrays were deployed across the polar ice cap to measure salinity, temperature gradients, and current dynamics at depths up to two thousand meters. The continuously transmitting sensors provide vital oceanographic data for global meteorological prediction models.",
                    isBookmarked: false
                },
                {
                    category: "World",
                    headline: "High-Voltage Direct Current Interconnector Links Renewable Wind Power Across Continents",
                    authorInfo: "4 hours ago • By Energy Geopolitics",
                    timeText: "4h ago",
                    image: "qrc:/ApexVision/qml/assets/news_images/photo_1473341304170-971dccb5ac1e.jpg",
                    body: "The world's longest subsea electrical transmission cable achieved commercial power transmission today, delivering three gigawatts of offshore North Sea wind energy directly to Mediterranean urban grids. The bidirectional connection smooths renewable output variations across time zones.",
                    isBookmarked: false
                },
                {
                    category: "World",
                    headline: "Zero-Emission Metropolitan Transport Mandate Adopted by Fifty Major World Capitals",
                    authorInfo: "5 hours ago • By Urban Transit Weekly",
                    timeText: "5h ago",
                    image: "qrc:/ApexVision/qml/assets/news_images/photo_1519501025264-65ba15a82390.jpg",
                    body: "Mayors representing over seventy million urban residents signed an enforceable covenant requiring all public buses, taxis, and municipal maintenance fleets to be fully electric or hydrogen-powered within three years. Financial subsidies will support charging infrastructure expansion in residential districts.",
                    isBookmarked: false
                }
            ]
        },
        {
            name: "Environment",
            heroImage: "qrc:/ApexVision/qml/assets/news_images/photo_1542601906990-b4d3fb778b09.jpg",
            stories: [
                {
                    category: "Environment",
                    headline: "Drone-Assisted Native Afforestation Projects Restore Two Million Hectares of Forest Canopy",
                    authorInfo: "20m ago • By Earth Stewardship",
                    timeText: "20m ago",
                    image: "qrc:/ApexVision/qml/assets/news_images/photo_1542601906990-b4d3fb778b09.jpg",
                    body: "Autonomous agricultural aerial drones dispersing nutrient-encapsulated native tree seed pods achieved remarkable seventy-percent germination rates across degraded watersheds. The restored woodlands have stabilized soil erosion and reconnected vital biodiversity wildlife corridors.",
                    isBookmarked: false
                },
                {
                    category: "Environment",
                    headline: "Direct Air Carbon Capture Facility Powered by Geothermal Heat Reaches Commercial Scale",
                    authorInfo: "1 hour ago • By Clean Air Review",
                    timeText: "1h ago",
                    image: "qrc:/ApexVision/qml/assets/news_images/photo_1497435334941-8c899ee9e8e9.jpg",
                    body: "An industrial-scale direct air capture facility built adjacent to geothermal steam fields successfully sequestered thirty-six thousand tons of atmospheric carbon dioxide into deep basalt formations. The carbon reacts with volcanic rocks to permanently turn into solid stone within eighteen months.",
                    isBookmarked: false
                },
                {
                    category: "Environment",
                    headline: "Acoustic Coral Reef Restoration Trials Spark Rapid Recolonization by Marine Life",
                    authorInfo: "2 hours ago • By Coral Ecology Today",
                    timeText: "2h ago",
                    image: "qrc:/ApexVision/qml/assets/news_images/photo_1544551763-46a013bb70d5.jpg",
                    body: "Underwater acoustic speakers broadcasting soundscapes of healthy thriving reefs attracted double the larval fish and juvenile corals compared to silent degraded reefs. Biologists describe the acoustic enrichment method as an inexpensive breakthrough for regenerating bleached barrier reefs.",
                    isBookmarked: false
                },
                {
                    category: "Environment",
                    headline: "Wetland Re-Wilding Initiative Reverses Decades of Regional Flood and Drought Vulnerability",
                    authorInfo: "3 hours ago • By Watershed Management",
                    timeText: "3h ago",
                    image: "qrc:/ApexVision/qml/assets/news_images/photo_1448375240586-882707db888b.jpg",
                    body: "Removing artificial levees along major floodplains has allowed seasonal rivers to naturally inundate ancient marshlands, creating vast freshwater sponges that absorb excess storms and replenish underground aquifers during dry summer seasons.",
                    isBookmarked: false
                },
                {
                    category: "Environment",
                    headline: "Solar-Powered Water De-Pollution Barges Remove Toxic Algal Blooms from Inland Lakes",
                    authorInfo: "4 hours ago • By Limnology Dispatch",
                    timeText: "4h ago",
                    image: "qrc:/ApexVision/qml/assets/news_images/photo_1470071459604-3b5ec3a7fe05.jpg",
                    body: "Autonomous solar barges deploying micro-bubble ultrasonic cavitation successfully eradicated toxic cyanobacteria blooms across three municipal drinking reservoirs without chemicals. The technique restores dissolved oxygen levels and revitalizes native fish populations.",
                    isBookmarked: false
                },
                {
                    category: "Environment",
                    headline: "Urban Rooftop Biospheres Reduce Downtown Heat Island Temperatures by Five Degrees",
                    authorInfo: "5 hours ago • By Green Architecture Digest",
                    timeText: "5h ago",
                    image: "qrc:/ApexVision/qml/assets/news_images/photo_1518531933037-91b2f5f229cc.jpg",
                    body: "Mandatory municipal green roof bylaws requiring sedum plantings, solar pergolas, and rainwater recycling cisterns have reduced daytime surface temperatures across central business districts by five degrees Celsius, while cutting building air-conditioning electricity usage by twenty percent.",
                    isBookmarked: false
                }
            ]
        }
    ]

    // Unique image URLs across all categories for instant background prefetching
    readonly property var allStoryImages: {
        var urls = [];
        var seen = {};
        for (var i = 0; i < root.categories.length; i++) {
            var cat = root.categories[i];
            if (cat.heroImage && !seen[cat.heroImage]) {
                seen[cat.heroImage] = true;
                urls.push(cat.heroImage);
            }
            if (cat.stories) {
                for (var j = 0; j < cat.stories.length; j++) {
                    var img = cat.stories[j].image;
                    if (img && !seen[img]) {
                        seen[img] = true;
                        urls.push(img);
                    }
                }
            }
        }
        return urls;
    }

    // Background Image Preloader (Loads and caches all story images so subsequent visits are instant)
    Repeater {
        model: root.allStoryImages
        Item {
            Image {
                source: modelData
                asynchronous: true
                cache: true
                visible: false
                width: 1
                height: 1
            }
        }
    }

    ListModel {
        id: newsModel
    }

    // Active Story Accessor
    readonly property var activeStory: {
        if (newsModel.count > 0 && root.selectedArticleIndex >= 0 && root.selectedArticleIndex < newsModel.count) {
            return newsModel.get(root.selectedArticleIndex);
        }
        return null;
    }

    // =========================================================================
    // MASTER CONTAINER (Light VehicleBar Frosted Glass Theme - Shines naturally)
    // =========================================================================
    Item {
        id: masterNewsCard
        anchors.fill: parent

        // =====================================================================
        // 1. TOP HEADER AREA (Borderless Back Button + Title + All News Briefing)
        // =====================================================================
        Item {
            id: topHeaderArea
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            height: 58

            // Left Section: Back Button (Border 0 as requested) + Title
            Row {
                anchors.left: parent.left
                anchors.leftMargin: 24
                anchors.verticalCenter: parent.verticalCenter
                spacing: 12

                // Signature IVI Back Button (Zero border on hover, radiant glow on press matching VehiclePage)
                Item {
                    id: backBtn
                    width: 38
                    height: 38
                    anchors.verticalCenter: parent.verticalCenter

                    Text {
                        anchors.centerIn: parent
                        text: "←"
                        font.family: "Inter"
                        font.pixelSize: 26
                        font.weight: Font.DemiBold
                        color: backMouse.pressed ? "#00D2FF" : (backMouse.containsMouse ? "#FFFFFF" : "#E2E8F0")
                        scale: backMouse.pressed ? 0.90 : 1.0
                        Behavior on scale { NumberAnimation { duration: 80 } }
                        Behavior on color { ColorAnimation { duration: 100 } }
                    }

                    MouseArea {
                        id: backMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            root.stopBriefing();
                            root.backRequested();
                        }
                    }
                }

                // Page Title: "News"
                Text {
                    text: "News"
                    color: "#FFFFFF"
                    font.family: "Inter"
                    font.pixelSize: 25
                    font.weight: Font.Bold
                    anchors.verticalCenter: parent.verticalCenter
                }
            }

            // Right Header Action: "All News Briefing" (Reads all stories sequentially)
            Rectangle {
                id: allBriefingBtn
                anchors.right: parent.right
                anchors.rightMargin: 24
                anchors.verticalCenter: parent.verticalCenter
                height: 38
                width: allBriefingRow.implicitWidth + 30
                radius: 19

                // Active glowing state when "all" briefing is in progress
                gradient: Gradient {
                    GradientStop {
                        position: 0.0
                        color: (root.briefingMode === "all") ?
                            Qt.rgba(0, 168/255, 255/255, 0.42) :
                            (allBriefingMouse.pressed ? Qt.rgba(255, 255, 255, 0.24) :
                            (allBriefingMouse.containsMouse ? Qt.rgba(255, 255, 255, 0.18) : Qt.rgba(255, 255, 255, 0.11)))
                    }
                    GradientStop {
                        position: 1.0
                        color: (root.briefingMode === "all") ?
                            Qt.rgba(0, 110/255, 220/255, 0.32) :
                            (allBriefingMouse.pressed ? Qt.rgba(255, 255, 255, 0.18) :
                            (allBriefingMouse.containsMouse ? Qt.rgba(255, 255, 255, 0.12) : Qt.rgba(255, 255, 255, 0.07)))
                    }
                }

                border.color: (root.briefingMode === "all") ? "#00A8FF" : (allBriefingMouse.containsMouse ? Qt.rgba(255, 255, 255, 0.45) : Qt.rgba(255, 255, 255, 0.22))
                border.width: 1

                Row {
                    id: allBriefingRow
                    anchors.centerIn: parent
                    spacing: 8

                    Item {
                        width: 18
                        height: 18
                        anchors.verticalCenter: parent.verticalCenter

                        Image {
                            anchors.centerIn: parent
                            width: 16
                            height: 16
                            source: (root.briefingMode === "all") ? "qrc:/ApexVision/qml/assets/icons/news_pause.svg" : "qrc:/ApexVision/qml/assets/icons/news_waveform.svg"
                            fillMode: Image.PreserveAspectFit
                            smooth: true
                        }

                        // Pulsing Wave Ring Animation when All Briefing is reading
                        Rectangle {
                            anchors.centerIn: parent
                            width: 22
                            height: 22
                            radius: 11
                            color: "transparent"
                            border.color: "#00A8FF"
                            border.width: 1.5
                            visible: root.briefingMode === "all"

                            SequentialAnimation on scale {
                                running: root.briefingMode === "all"
                                loops: Animation.Infinite
                                NumberAnimation { from: 0.9; to: 1.35; duration: 650; easing.type: Easing.OutQuad }
                                NumberAnimation { from: 1.35; to: 0.9; duration: 650; easing.type: Easing.InQuad }
                            }
                            SequentialAnimation on opacity {
                                running: root.briefingMode === "all"
                                loops: Animation.Infinite
                                NumberAnimation { from: 0.9; to: 0.2; duration: 650 }
                                NumberAnimation { from: 0.2; to: 0.9; duration: 650 }
                            }
                        }
                    }

                    Text {
                        text: (root.briefingMode === "all") ? "Stop Briefing" : "All News Briefing"
                        color: "#FFFFFF"
                        font.family: "Inter"
                        font.pixelSize: 13
                        font.weight: Font.DemiBold
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }

                MouseArea {
                    id: allBriefingMouse
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        if (root.briefingMode === "all") {
                            root.stopBriefing();
                        } else {
                            root.startAllBriefing();
                        }
                    }
                }
            }
        }

        // =====================================================================
        // 2. CATEGORY TABS (Full Width, Direct Scrolling, Arrow Buttons Removed)
        // =====================================================================
        Item {
            id: categoryTabsArea
            anchors.top: topHeaderArea.bottom
            anchors.left: parent.left
            anchors.leftMargin: 24
            anchors.right: parent.right
            anchors.rightMargin: 24
            height: 44

            // Horizontal Smooth-Scrolling Category List
            ListView {
                id: categoryListView
                anchors.fill: parent
                orientation: ListView.Horizontal
                spacing: 10
                clip: true
                boundsBehavior: Flickable.StopAtBounds
                flickableDirection: Flickable.HorizontalFlick
                model: root.categories

                delegate: Item {
                    id: catTabDelegate
                    width: catTabText.implicitWidth + 34
                    height: 38
                    anchors.verticalCenter: parent.verticalCenter

                    readonly property bool isSelected: root.activeCategoryIndex === index

                    Rectangle {
                        id: catTabBg
                        anchors.fill: parent
                        radius: 19

                        // VehicleBar Light Glass Tone
                        gradient: Gradient {
                            GradientStop {
                                position: 0.0
                                color: catTabDelegate.isSelected ?
                                    Qt.rgba(255, 255, 255, 0.32) :
                                    (tabMouse.pressed ? Qt.rgba(255, 255, 255, 0.22) :
                                    (tabMouse.containsMouse ? Qt.rgba(255, 255, 255, 0.16) : Qt.rgba(255, 255, 255, 0.09)))
                            }
                            GradientStop {
                                position: 1.0
                                color: catTabDelegate.isSelected ?
                                    Qt.rgba(255, 255, 255, 0.22) :
                                    (tabMouse.pressed ? Qt.rgba(255, 255, 255, 0.15) :
                                    (tabMouse.containsMouse ? Qt.rgba(255, 255, 255, 0.11) : Qt.rgba(255, 255, 255, 0.05)))
                            }
                        }

                        border.color: catTabDelegate.isSelected ?
                            Qt.rgba(255, 255, 255, 0.85) :
                            (tabMouse.containsMouse ? Qt.rgba(255, 255, 255, 0.50) : Qt.rgba(255, 255, 255, 0.18))
                        border.width: catTabDelegate.isSelected ? 1.5 : 1

                        Behavior on border.color { ColorAnimation { duration: 120 } }

                        Text {
                            id: catTabText
                            anchors.centerIn: parent
                            text: modelData.name
                            color: catTabDelegate.isSelected ? "#FFFFFF" : Qt.rgba(255, 255, 255, 0.78)
                            font.family: "Inter"
                            font.pixelSize: 13
                            font.weight: catTabDelegate.isSelected ? Font.DemiBold : Font.Normal
                        }

                        MouseArea {
                            id: tabMouse
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                if (root.activeCategoryIndex !== index) {
                                    root.switchCategory(index);
                                    categoryListView.positionViewAtIndex(index, ListView.Contain);
                                }
                            }
                        }
                    }
                }
            }
        }

        // =====================================================================
        // 3. MAIN SPLIT CONTENT: FEED LIST (LEFT) & FEATURED HERO (RIGHT)
        // =====================================================================
        Item {
            id: mainSplitArea
            anchors.top: categoryTabsArea.bottom
            anchors.topMargin: 12
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 16
            anchors.left: parent.left
            anchors.leftMargin: 24
            anchors.right: parent.right
            anchors.rightMargin: 24

            // -----------------------------------------------------------------
            // LEFT COLUMN: ARTICLE FEED LIST + FROSTED GLASS DRAGGER
            // -----------------------------------------------------------------
            Item {
                id: leftFeedColumn
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                width: parent.width * 0.475
                clip: true // Clean column boundary clipping

                ListView {
                    id: articlesListView
                    anchors.left: parent.left
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    anchors.right: draggerTrack.visible ? draggerTrack.left : parent.right
                    anchors.rightMargin: draggerTrack.visible ? 8 : 4
                    anchors.leftMargin: 4
                    anchors.topMargin: 4
                    anchors.bottomMargin: 4
                    spacing: 8
                    clip: false // Cards breathe freely within column margins
                    boundsBehavior: Flickable.StopAtBounds
                    model: newsModel

                    delegate: Item {
                        id: cardDelegate
                        width: articlesListView.width
                        height: 94
                        z: cardMouse.containsMouse ? 30 : (isSelected ? 10 : 1) // Elevated on hover above neighbors

                        readonly property bool isSelected: root.selectedArticleIndex === index

                        // Article Card (VehicleBar Light Frosted Glass + Active Radiant Glow)
                        Rectangle {
                            id: articleCard
                            anchors.fill: parent
                            anchors.margins: 3 // Internal clearance ensures border NEVER touches edges
                            radius: 14

                            // VehicleBar Light Frosted Glass Gradient
                            gradient: Gradient {
                                GradientStop {
                                    position: 0.0
                                    color: isSelected ?
                                        Qt.rgba(180/255, 225/255, 255/255, 0.32) :
                                        (cardMouse.pressed ? Qt.rgba(215/255, 238/255, 255/255, 0.30) :
                                        (cardMouse.containsMouse ? Qt.rgba(225/255, 242/255, 255/255, 0.22) : Qt.rgba(215/255, 238/255, 255/255, 0.16)))
                                }
                                GradientStop {
                                    position: 1.0
                                    color: isSelected ?
                                        Qt.rgba(140/255, 205/255, 255/255, 0.24) :
                                        (cardMouse.pressed ? Qt.rgba(195/255, 225/255, 255/255, 0.24) :
                                        (cardMouse.containsMouse ? Qt.rgba(205/255, 230/255, 255/255, 0.16) : Qt.rgba(195/255, 225/255, 255/255, 0.11)))
                                }
                            }

                            border.color: isSelected ?
                                "#00A8FF" :
                                (cardMouse.containsMouse ? Qt.rgba(255, 255, 255, 0.70) : Qt.rgba(225/255, 242/255, 255/255, 0.36))
                            border.width: isSelected ? 1.5 : 1

                            Behavior on color { ColorAnimation { duration: 120 } }
                            Behavior on border.color { ColorAnimation { duration: 120 } }

                            // Card Content Layout
                            Row {
                                anchors.fill: parent
                                anchors.margins: 10
                                spacing: 12

                                // Thumbnail Image
                                Rectangle {
                                    id: thumbContainer
                                    width: 82
                                    height: parent.height
                                    radius: 10
                                    clip: true
                                    color: Qt.rgba(0, 0, 0, 0.15)
                                    anchors.verticalCenter: parent.verticalCenter

                                    Image {
                                        id: cardThumb
                                        anchors.fill: parent
                                        source: model.image
                                        fillMode: Image.PreserveAspectCrop
                                        smooth: true
                                        asynchronous: false
                                        cache: true
                                    }
                                }

                                // Text Content Column
                                Column {
                                    anchors.verticalCenter: parent.verticalCenter
                                    width: parent.width - thumbContainer.width - parent.spacing - 30
                                    spacing: 4

                                    // Category Tag + Time
                                    Row {
                                        spacing: 6
                                        Text {
                                            text: model.category
                                            color: isSelected ? "#00D2FF" : Qt.rgba(200/255, 230/255, 255/255, 0.90)
                                            font.family: "Inter"
                                            font.pixelSize: 11
                                            font.weight: Font.DemiBold
                                        }

                                        Text {
                                            text: "• " + model.timeText
                                            color: Qt.rgba(255, 255, 255, 0.55)
                                            font.family: "Inter"
                                            font.pixelSize: 11
                                        }
                                    }

                                    // Headline
                                    Text {
                                        width: parent.width
                                        text: model.headline
                                        color: "#FFFFFF"
                                        font.family: "Inter"
                                        font.pixelSize: 13
                                        font.weight: Font.DemiBold
                                        elide: Text.ElideRight
                                        maximumLineCount: 2
                                        wrapMode: Text.WordWrap
                                        lineHeight: 1.15
                                    }

                                    // Author Info
                                    Text {
                                        width: parent.width
                                        text: model.authorInfo
                                        color: Qt.rgba(255, 255, 255, 0.60)
                                        font.family: "Inter"
                                        font.pixelSize: 11
                                        elide: Text.ElideRight
                                    }
                                }

                                // Bookmark Action Icon
                                Rectangle {
                                    width: 26
                                    height: 26
                                    radius: 13
                                    color: model.isBookmarked ? Qt.rgba(0, 168/255, 255/255, 0.25) : "transparent"
                                    anchors.verticalCenter: parent.verticalCenter

                                    Image {
                                        anchors.centerIn: parent
                                        width: 14
                                        height: 14
                                        source: model.isBookmarked ? "qrc:/ApexVision/qml/assets/icons/news_bookmark_filled.svg" : "qrc:/ApexVision/qml/assets/icons/news_bookmark.svg"
                                        fillMode: Image.PreserveAspectFit
                                        smooth: true
                                    }

                                    MouseArea {
                                        anchors.fill: parent
                                        cursorShape: Qt.PointingHandCursor
                                        onClicked: {
                                            root.toggleBookmark(index);
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
                                    if (root.briefingMode === "all") {
                                        root.dictateStoryAt(index);
                                    } else if (root.briefingMode === "single") {
                                        root.dictateStoryAt(index);
                                    }
                                }
                            }
                        }
                    }
                }

                // Interactive Frosted Glass Dragger (Exact match with VehicleBar / AppsPage / SettingsPage)
                Item {
                    id: draggerTrack
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    anchors.right: parent.right
                    anchors.topMargin: 4
                    anchors.bottomMargin: 4
                    anchors.rightMargin: 1
                    width: 7
                    visible: articlesListView.contentHeight > articlesListView.height

                    // Track background line
                    Rectangle {
                        anchors.fill: parent
                        radius: 3.5
                        color: Qt.rgba(255, 255, 255, 0.08)
                    }

                    // Draggable frosted glass thumb
                    Rectangle {
                        id: draggerThumb
                        width: parent.width
                        radius: 3.5
                        color: draggerMouse.pressed ? Qt.rgba(255, 255, 255, 0.50) :
                               (draggerMouse.containsMouse ? Qt.rgba(255, 255, 255, 0.36) : Qt.rgba(255, 255, 255, 0.22))
                        border.color: Qt.rgba(255, 255, 255, 0.40)
                        border.width: 1

                        readonly property real visibleRatio: Math.min(1.0, articlesListView.height / Math.max(1, articlesListView.contentHeight))
                        height: Math.max(44, parent.height * visibleRatio)

                        readonly property real maxContentY: Math.max(1, articlesListView.contentHeight - articlesListView.height)
                        readonly property real maxThumbY: Math.max(1, parent.height - height)
                        y: Math.min(maxThumbY, Math.max(0, (articlesListView.contentY / maxContentY) * maxThumbY))

                        Behavior on color { ColorAnimation { duration: 120 } }

                        MouseArea {
                            id: draggerMouse
                            anchors.fill: parent
                            anchors.margins: -10
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            drag.target: draggerThumb
                            drag.axis: Drag.YAxis
                            drag.minimumY: 0
                            drag.maximumY: draggerTrack.height - draggerThumb.height

                            onPositionChanged: {
                                if (drag.active) {
                                    var ratio = draggerThumb.y / Math.max(1, draggerTrack.height - draggerThumb.height);
                                    articlesListView.contentY = ratio * (articlesListView.contentHeight - articlesListView.height);
                                }
                            }
                        }
                    }

                    // Click-to-jump on track
                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        z: -1
                        onClicked: function(mouse) {
                            var targetRatio = mouse.y / draggerTrack.height;
                            articlesListView.contentY = targetRatio * (articlesListView.contentHeight - articlesListView.height);
                        }
                    }
                }
            }

            // -----------------------------------------------------------------
            // RIGHT COLUMN: FEATURED HERO & FULL ARTICLE VIEW (VehicleBar Theme)
            // -----------------------------------------------------------------
            Item {
                id: rightDetailColumn
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                width: parent.width * 0.505

                Rectangle {
                    id: heroDetailCard
                    anchors.fill: parent
                    radius: 16
                    clip: true

                    // VehicleBar Light Translucent Glass Gradient
                    gradient: Gradient {
                        GradientStop {
                            position: 0.0
                            color: Qt.rgba(215/255, 238/255, 255/255, 0.20)
                        }
                        GradientStop {
                            position: 1.0
                            color: Qt.rgba(195/255, 225/255, 255/255, 0.13)
                        }
                    }

                    border.color: Qt.rgba(225/255, 242/255, 255/255, 0.38)
                    border.width: 1

                    // Scrollable Article Details
                    Flickable {
                        id: detailFlickable
                        anchors.fill: parent
                        contentHeight: detailColumn.height + 24
                        clip: true
                        boundsBehavior: Flickable.StopAtBounds

                        Column {
                            id: detailColumn
                            anchors.left: parent.left
                            anchors.leftMargin: 18
                            anchors.right: parent.right
                            anchors.rightMargin: 18
                            anchors.top: parent.top
                            anchors.topMargin: 16
                            spacing: 12

                            // 1. Hero Image with Translucent Gradient Overlay
                            Rectangle {
                                id: heroImageContainer
                                width: parent.width
                                height: 185
                                radius: 14
                                clip: true
                                color: Qt.rgba(0, 0, 0, 0.15)

                                Image {
                                    id: heroImage
                                    anchors.fill: parent
                                    source: (root.activeStory && root.activeStory.image) ? root.activeStory.image : (root.categories[root.activeCategoryIndex].heroImage)
                                    fillMode: Image.PreserveAspectCrop
                                    smooth: true
                                    asynchronous: false
                                    cache: true
                                }

                                // Soft Dark Gradient Overlay at Bottom of Image for text readability
                                Rectangle {
                                    anchors.bottom: parent.bottom
                                    anchors.left: parent.left
                                    anchors.right: parent.right
                                    height: 80
                                    gradient: Gradient {
                                        GradientStop { position: 0.0; color: "transparent" }
                                        GradientStop { position: 1.0; color: Qt.rgba(0, 0, 0, 0.70) }
                                    }
                                }

                                // Category Text on Hero Image (Clean text only, no background box or border)
                                Text {
                                    id: heroCategoryText
                                    anchors.left: parent.left
                                    anchors.leftMargin: 14
                                    anchors.bottom: parent.bottom
                                    anchors.bottomMargin: 14
                                    text: (root.activeStory && root.activeStory.category) ? root.activeStory.category : root.categories[root.activeCategoryIndex].name
                                    color: "#00D2FF"
                                    font.family: "Inter"
                                    font.pixelSize: 13
                                    font.weight: Font.DemiBold
                                }

                                // Action Buttons (Bookmark & Share - Clean borderless icons without background box)
                                Row {
                                    anchors.right: parent.right
                                    anchors.rightMargin: 14
                                    anchors.bottom: parent.bottom
                                    anchors.bottomMargin: 12
                                    spacing: 12

                                    // Bookmark Button
                                    Item {
                                        width: 28
                                        height: 28

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
                                                root.toggleBookmark(root.selectedArticleIndex);
                                            }
                                        }
                                    }

                                    // Share Button
                                    Item {
                                        width: 28
                                        height: 28

                                        Image {
                                            anchors.centerIn: parent
                                            width: 17
                                            height: 17
                                            source: "qrc:/ApexVision/qml/assets/icons/news_trending.svg"
                                            fillMode: Image.PreserveAspectFit
                                            smooth: true
                                        }

                                        MouseArea {
                                            anchors.fill: parent
                                            cursorShape: Qt.PointingHandCursor
                                            onClicked: {
                                                // Shared telematics feedback hook
                                            }
                                        }
                                    }
                                }
                            }

                            // 2. Headline
                            Text {
                                width: parent.width
                                text: (root.activeStory && root.activeStory.headline) ? root.activeStory.headline : "Select a story to explore"
                                color: "#FFFFFF"
                                font.family: "Inter"
                                font.pixelSize: 18
                                font.weight: Font.Bold
                                wrapMode: Text.WordWrap
                                lineHeight: 1.22
                            }

                            // 3. Author & Publication Time Meta Row
                            Row {
                                spacing: 8
                                Text {
                                    text: (root.activeStory && root.activeStory.authorInfo) ? root.activeStory.authorInfo : "Live Wire"
                                    color: Qt.rgba(255, 255, 255, 0.65)
                                    font.family: "Inter"
                                    font.pixelSize: 12
                                }
                            }

                            // 4. Full Article Body Paragraph
                            Text {
                                width: parent.width
                                text: (root.activeStory && root.activeStory.body) ? root.activeStory.body : ""
                                color: Qt.rgba(255, 255, 255, 0.90)
                                font.family: "Inter"
                                font.pixelSize: 13
                                wrapMode: Text.WordWrap
                                lineHeight: 1.45
                            }

                            // 5. Individual Story Dictation Action ("Listen to Story" - Single Briefing)
                            Rectangle {
                                width: storyDictateRow.implicitWidth + 30
                                height: 34
                                radius: 17
                                gradient: Gradient {
                                    GradientStop {
                                        position: 0.0
                                        color: (root.briefingMode === "single") ?
                                            Qt.rgba(0, 168/255, 255/255, 0.40) :
                                            (storyDictateMouse.pressed ? Qt.rgba(215/255, 238/255, 255/255, 0.28) :
                                            (storyDictateMouse.containsMouse ? Qt.rgba(225/255, 242/255, 255/255, 0.20) : Qt.rgba(215/255, 238/255, 255/255, 0.14)))
                                    }
                                    GradientStop {
                                        position: 1.0
                                        color: (root.briefingMode === "single") ?
                                            Qt.rgba(0, 110/255, 220/255, 0.30) :
                                            (storyDictateMouse.pressed ? Qt.rgba(195/255, 225/255, 255/255, 0.20) :
                                            (storyDictateMouse.containsMouse ? Qt.rgba(205/255, 230/255, 255/255, 0.14) : Qt.rgba(195/255, 225/255, 255/255, 0.08)))
                                    }
                                }
                                border.color: (root.briefingMode === "single") ? "#00A8FF" : (storyDictateMouse.containsMouse ? Qt.rgba(255, 255, 255, 0.65) : Qt.rgba(225/255, 242/255, 255/255, 0.36))
                                border.width: (root.briefingMode === "single") ? 1.5 : 1

                                Row {
                                    id: storyDictateRow
                                    anchors.centerIn: parent
                                    spacing: 6

                                    Image {
                                        width: 14
                                        height: 14
                                        source: (root.briefingMode === "single") ? "qrc:/ApexVision/qml/assets/icons/news_pause.svg" : "qrc:/ApexVision/qml/assets/icons/news_waveform.svg"
                                        fillMode: Image.PreserveAspectFit
                                        anchors.verticalCenter: parent.verticalCenter
                                    }

                                    Text {
                                        text: (root.briefingMode === "single") ? "Stop Story" : "Listen to Story"
                                        color: "#FFFFFF"
                                        font.family: "Inter"
                                        font.pixelSize: 12
                                        font.weight: Font.Medium
                                        anchors.verticalCenter: parent.verticalCenter
                                    }
                                }

                                MouseArea {
                                    id: storyDictateMouse
                                    anchors.fill: parent
                                    hoverEnabled: true
                                    cursorShape: Qt.PointingHandCursor
                                    onClicked: {
                                        if (root.briefingMode === "single") {
                                            root.stopBriefing();
                                        } else {
                                            root.startSingleBriefing();
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    // =========================================================================
    // VOICE AUDIO BRIEFING (CONTINUOUS ALL VS SINGLE STORY MODES)
    // =========================================================================
    function dictateStoryAt(idx) {
        if (idx < 0 || idx >= newsModel.count) return;
        var story = newsModel.get(idx);
        if (!story) return;

        // Pause background music if playing
        if (typeof MediaBackend !== "undefined" && !root.wasMusicPlayingBeforeDictation) {
            root.wasMusicPlayingBeforeDictation = MediaBackend.isPlaying;
            if (MediaBackend.isPlaying) {
                if (typeof MediaBackend.fadeOutAndPause === "function") {
                    MediaBackend.fadeOutAndPause(350);
                } else if (typeof MediaBackend.pausePlayback === "function") {
                    MediaBackend.pausePlayback();
                } else if (typeof MediaBackend.setIsPlaying === "function") {
                    MediaBackend.setIsPlaying(false);
                }
            }
        }

        // Broadcast format: Category, Headline, and full Story body
        var textToSpeak = "Category: " + story.category + ". " 
                        + story.headline + ". " 
                        + story.body;

        autoAdvanceTimer.stop();

        if (typeof SystemBackend !== "undefined" && SystemBackend.playTtsSample) {
            SystemBackend.playTtsSample(textToSpeak, 1.0, 1.0);
        }
    }

    function startAllBriefing() {
        if (newsModel.count === 0) return;
        root.briefingMode = "all";
        root.dictateStoryAt(root.selectedArticleIndex);
    }

    function startSingleBriefing() {
        if (newsModel.count === 0) return;
        root.briefingMode = "single";
        root.dictateStoryAt(root.selectedArticleIndex);
    }

    function stopBriefing() {
        autoAdvanceTimer.stop();
        root.briefingMode = "none";
        if (typeof SystemBackend !== "undefined" && SystemBackend.stopTts) {
            SystemBackend.stopTts();
        }
        // Resume background music if it was playing before dictation
        if (root.wasMusicPlayingBeforeDictation && typeof MediaBackend !== "undefined") {
            if (typeof MediaBackend.setIsPlaying === "function") {
                MediaBackend.setIsPlaying(true);
            }
            root.wasMusicPlayingBeforeDictation = false;
        }
    }

    function stopDictating() {
        root.stopBriefing();
    }

    function stopSpeaking() {
        root.stopBriefing();
    }

    function toggleBookmark(idx) {
        if (idx < 0 || idx >= newsModel.count) return;
        var isBm = !newsModel.get(idx).isBookmarked;
        newsModel.setProperty(idx, "isBookmarked", isBm);
        if (root.newsStore && root.newsStore[root.activeCategoryIndex] && root.newsStore[root.activeCategoryIndex][idx]) {
            root.newsStore[root.activeCategoryIndex][idx].isBookmarked = isBm;
        }
    }

    function preloadAllNews() {
        var store = {};
        for (var c = 0; c < root.categories.length; c++) {
            var cat = root.categories[c];
            var list = [];
            if (cat.stories) {
                for (var s = 0; s < cat.stories.length; s++) {
                    var story = cat.stories[s];
                    list.push({
                        category: story.category,
                        headline: story.headline,
                        authorInfo: story.authorInfo,
                        timeText: story.timeText,
                        image: story.image,
                        body: story.body,
                        isBookmarked: story.isBookmarked || false
                    });
                }
            }
            store[c] = list;
        }
        root.newsStore = store;
    }

    function switchCategory(catIdx) {
        if (root.briefingMode !== "none") {
            root.stopBriefing();
        }
        root.activeCategoryIndex = catIdx;
        root.selectedArticleIndex = 0;

        // Load instantly from preloaded background store
        if (!root.newsStore || !root.newsStore[catIdx]) {
            root.preloadAllNews();
        }

        var cachedList = root.newsStore[catIdx];
        newsModel.clear();
        for (var i = 0; i < cachedList.length; i++) {
            newsModel.append(cachedList[i]);
        }
    }

    Component.onCompleted: {
        preloadAllNews();
        switchCategory(0);
    }
}
