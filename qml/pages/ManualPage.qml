import QtQuick
import QtQuick.Controls

Item {
    id: root

    signal backRequested()

    property string currentTab: "categories" // "categories" | "visual" | "bookmarks"
    property string activeCategory: ""
    property var activeArticle: null
    property string searchQuery: ""
    property bool searchActive: false
    property bool showTouchKeyboard: false
    property var searchResults: []
    property bool isShiftActive: false

    // Quick Search Topic Chips (Touch-friendly quick queries)
    readonly property var searchChips: [
        "Brakes", "Headlights", "Cruise Control", "Climate",
        "Airbags", "Tire Pressure", "Child Safety", "Wipers",
        "Charging", "Keyless Entry", "Audio & Media", "Blind Spot"
    ]

    // Real-time Search Indexing
    function updateSearchResults() {
        var q = root.searchQuery.trim().toLowerCase();
        if (q.length === 0) {
            root.searchResults = [];
            return;
        }
        var list = [];
        for (var i = 0; i < root.manualCategories.length; ++i) {
            var cat = root.manualCategories[i];
            for (var t = 0; t < cat.topics.length; ++t) {
                var item = cat.topics[t];
                var tMatch = item.title && item.title.toLowerCase().indexOf(q) !== -1;
                var sMatch = item.summary && item.summary.toLowerCase().indexOf(q) !== -1;
                var cMatch = cat.title && cat.title.toLowerCase().indexOf(q) !== -1;
                var bMatch = false;
                if (item.steps) {
                    for (var s = 0; s < item.steps.length; ++s) {
                        if (item.steps[s].toLowerCase().indexOf(q) !== -1) {
                            bMatch = true;
                            break;
                        }
                    }
                }
                if (tMatch || sMatch || cMatch || bMatch) {
                    list.push({
                        category: cat.title,
                        title: item.title,
                        readTime: item.readTime || "2 min read",
                        summary: item.summary || "",
                        steps: item.steps || [],
                        note: item.note || "",
                        caution: item.caution || ""
                    });
                }
            }
        }
        root.searchResults = list;
    }

    onSearchQueryChanged: updateSearchResults()

    // Touch Keyboard Key Event Handlers
    function appendSearchKey(ch) {
        var charToInsert = root.isShiftActive ? ch.toUpperCase() : ch.toLowerCase();
        searchField.text += charToInsert;
        root.searchQuery = searchField.text;
    }

    function backspaceSearchKey() {
        if (searchField.text.length > 0) {
            searchField.text = searchField.text.substring(0, searchField.text.length - 1);
            root.searchQuery = searchField.text;
        }
    }

    function clearSearchInput() {
        searchField.text = "";
        root.searchQuery = "";
    }

    // Stored bookmarks list (defaults to empty, matching user reference photo 3)
    property var bookmarks: []
    property int visualPageIndex: 0 // 0: Interior (1 of 2), 1: Exterior (2 of 2)
    readonly property int currentTabIndex: currentTab === "categories" ? 0 : (currentTab === "visual" ? 1 : 2)

    // =========================================================================
    // COMPREHENSIVE OWNER'S MANUAL DATABASE
    // =========================================================================
    readonly property var manualCategories: [
        {
            id: "general",
            title: "General Information",
            topics: [
                {
                    title: "Vehicle Identification Number (VIN)",
                    readTime: "2 min read",
                    summary: "Locate the 17-character VIN stamped on the driver-side windshield and door pillar.",
                    steps: [
                        "Look at the lower corner of the front windshield on the driver's side.",
                        "Inspect the safety certification label on the driver's B-pillar door jamb.",
                        "You can also view your electronic VIN inside Settings > General > About Vehicle."
                    ],
                    note: "Never obscure or alter the factory vehicle identification label."
                },
                {
                    title: "Symbols & Warning Lights Glossary",
                    readTime: "4 min read",
                    summary: "Complete guide to instrument cluster warning indicators and telltales.",
                    steps: [
                        "Red Indicators: Immediate critical safety alerts (Brake system, Airbag fault, Engine oil).",
                        "Amber Indicators: Advisory systems requiring prompt attention (Check engine, TPMS, ABS).",
                        "Green / Blue: Active system operations (High beams, Turn signals, Cruise control active)."
                    ],
                    note: "If a red warning telltale illuminates while driving, safely pull over immediately."
                },
                {
                    title: "Event Data Recording (EDR)",
                    readTime: "2 min read",
                    summary: "Overview of crash data recording sensors and privacy policies.",
                    steps: [
                        "EDR records vehicle dynamics, seatbelt status, and driver inputs during impact events.",
                        "Data is stored strictly in non-volatile memory for diagnostic and regulatory safety analysis.",
                        "No audio or video conversations are captured by the EDR module."
                    ],
                    note: "Specialized equipment connected to the OBD-II diagnostic port is required to read EDR logs."
                },
                {
                    title: "Quick Start & Delivery Checklist",
                    readTime: "3 min read",
                    summary: "Essential initial vehicle setup steps for new owners.",
                    steps: [
                        "Pair your mobile smartphone with Bluetooth and enable Phone As A Key.",
                        "Adjust the 30-Way Perfect Position Seat, side mirrors, and save to memory preset 1.",
                        "Configure personalized ambient lighting and climate temperature presets."
                    ],
                    note: "Keep an active key fob inside the cabin when completing initial system configuration."
                }
            ]
        },
        {
            id: "audio_maps",
            title: "Audio, Maps and Connectivity",
            topics: [
                {
                    title: "SYNC 4 & APEX IVI Overview",
                    readTime: "3 min read",
                    summary: "Navigating your multi-display digital cockpit and customizable app ecosystem.",
                    steps: [
                        "Use the permanent left navigation rail to jump between Home, Vehicle, Apps, and Climate.",
                        "Swipe horizontally across the main display to switch between widgets and media tiles.",
                        "Tap the Apps icon in the rail to launch full-screen applications like News, Towing, and Rejuvenate."
                    ],
                    note: "Voice commands can be invoked at any time by tapping the steering wheel push-to-talk button."
                },
                {
                    title: "Navigation & Satellite Maps",
                    readTime: "4 min read",
                    summary: "Connected real-time cloud routing, EV charging stops, and POI search.",
                    steps: [
                        "Type a destination or point-of-interest into the search bar at the top of the map view.",
                        "Select route preferences: Fastest, Shortest, Eco-Route, or Avoid Tolls.",
                        "Charging waypoint recommendations are automatically generated when remaining range falls below 20%."
                    ],
                    note: "Live traffic feeds and construction overlays update automatically via 5G cellular connection."
                },
                {
                    title: "Wireless Apple CarPlay & Android Auto",
                    readTime: "2 min read",
                    summary: "Seamlessly project your smartphone applications wirelessly onto the central screen.",
                    steps: [
                        "Ensure Wi-Fi and Bluetooth are enabled on your compatible smartphone.",
                        "Tap Phone on the left navigation rail and select 'Add Phone'.",
                        "Accept the pairing prompt on both the vehicle display and your mobile device."
                    ],
                    note: "You can toggle between native APEX IVI and smartphone projection at any time without disconnecting."
                },
                {
                    title: "Revel Ultima 3D Audio Experience",
                    readTime: "3 min read",
                    summary: "Fine-tune 28 speakers with QuantumLogic Immersion surround sound profiles.",
                    steps: [
                        "Open the Radio or Media app, then tap Audio Settings.",
                        "Choose between 'Traditional Stereo', 'Audience', or 'On Stage' immersion profiles.",
                        "Adjust the 5-band parametric equalizer to tailor bass punch, vocal clarity, and treble response."
                    ],
                    note: "High-resolution lossless FLAC files are supported via both USB-C front ports."
                }
            ]
        },
        {
            id: "vehicle_care",
            title: "Vehicle Care and Maintenance",
            topics: [
                {
                    title: "Scheduled Maintenance Intervals",
                    readTime: "3 min read",
                    summary: "Factory recommended service milestones and system inspections.",
                    steps: [
                        "Every 10,000 miles (16,000 km): Rotate tires, check brake pad thickness, and inspect suspension.",
                        "Every 20,000 miles (32,000 km): Replace cabin air refresh filter and inspect cooling circuit.",
                        "Every 100,000 miles (160,000 km): High-voltage coolant drain and flush service."
                    ],
                    note: "Your Intelligent Oil-Life & Service Monitor alerts you automatically when maintenance is due."
                },
                {
                    title: "Cleaning and Exterior Paint Protection",
                    readTime: "3 min read",
                    summary: "Proper washing techniques for metallic clearcoats and gloss black exterior trim.",
                    steps: [
                        "Always rinse away loose road grit and abrasive dust with clean water before washing.",
                        "Use pH-neutral automotive shampoo and a soft microfiber wash mitt.",
                        "Avoid automatic car washes with abrasive nylon brushes that cause surface swirl marks."
                    ],
                    note: "Do not apply wax or polish to matte finished trim or camera sensor lenses."
                },
                {
                    title: "Wiper Blade Inspection and Replacement",
                    readTime: "2 min read",
                    summary: "How to place windshield wipers into service mode for easy blade renewal.",
                    steps: [
                        "Turn vehicle power off, then within 10 seconds push the wiper lever to the single-wipe position.",
                        "The wiper arms will move vertically and pause in the upright maintenance position.",
                        "Lift the blade arm, depress the release tab, and slide the wiper blade off the hook."
                    ],
                    note: "Never allow the metal wiper arm to snap down against bare glass without a blade attached."
                },
                {
                    title: "12V Auxiliary Battery Maintenance",
                    readTime: "2 min read",
                    summary: "Safety precautions and jump-start terminal connections for the 12V system.",
                    steps: [
                        "The 12V battery powers cabin electronics, door locks, and high-voltage contactors.",
                        "Under-hood remote jump-start posts are clearly labeled with a red protective (+) terminal cap.",
                        "Attach the positive red clamp first, then connect the black negative clamp to the designated ground lug."
                    ],
                    note: "Never connect jumper cables directly to high-voltage orange traction battery cabling."
                }
            ]
        },
        {
            id: "interior",
            title: "Instrument Panel and Interior",
            topics: [
                {
                    title: "Panoramic Coast-to-Coast Display",
                    readTime: "3 min read",
                    summary: "Customizing visual widgets, calm mode, and horizon display brightness.",
                    steps: [
                        "Access Settings > Display to adjust display theme, brightness, and screen timeout.",
                        "Enable 'Calm Screen' to minimize driver distraction, leaving only critical speedometer readout.",
                        "Configure split-screen layout widgets for navigation, trip computer, and tire pressure monitoring."
                    ],
                    note: "Clean the display glass exclusively with dry microfiber cloths; never spray liquids directly on glass."
                },
                {
                    title: "Ambient Cabin Lighting Customization",
                    readTime: "2 min read",
                    summary: "Choose from 10 distinct cabin glow themes and intensity zones.",
                    steps: [
                        "Open the Vehicle page and tap 'Ambient Lighting'.",
                        "Pick from curated palettes: Ice Blue, Oceanic Cyan, Warm Amber, Emerald, or Sunset Violet.",
                        "Slide the vertical brightness track to dial in the perfect night illumination level."
                    ],
                    note: "Ambient lighting automatically harmonizes with active Rejuvenate wellness sessions."
                },
                {
                    title: "Steering Wheel Controls & Capacitive Switches",
                    readTime: "3 min read",
                    summary: "Operating audio volume, voice command, and adaptive cruise control switches.",
                    steps: [
                        "Left Spokes: Adaptive Cruise speed adjustment, follow distance gap toggles, and Lane Centering.",
                        "Right Spokes: Audio track advance, phone answer/hang-up, and multifunction cluster browser.",
                        "The Push-To-Talk button activates instant conversational AI voice control."
                    ],
                    note: "Haptic feedback pulses confirm valid touch commands on capacitive steering surfaces."
                },
                {
                    title: "Rejuvenate Wellness Sanctuary",
                    readTime: "3 min read",
                    summary: "Using multisensory coordinated programs to de-stress and reset during stops.",
                    steps: [
                        "Park the vehicle safely with transmission in Park (P).",
                        "Launch the Rejuvenate app from the main menu and select 5 min, 10 min, or Preview.",
                        "Relax as the seat reclines, gentle massage pulses activate, digital scent diffuses, and audio plays."
                    ],
                    note: "Rejuvenate operates exclusively while stationary and parked for maximum passenger safety."
                }
            ]
        },
        {
            id: "doors_keys",
            title: "Doors, Windows and Keys",
            topics: [
                {
                    title: "Phone As A Key (PAAK) Setup",
                    readTime: "3 min read",
                    summary: "Use your smartphone via Bluetooth Low Energy as your primary vehicle key.",
                    steps: [
                        "Open your vehicle companion app on your smartphone and log into your owner account.",
                        "Select 'Set Up Phone As A Key' while sitting inside the vehicle with an existing key fob.",
                        "Follow the on-screen prompts to establish the secure encrypted BLE security bond."
                    ],
                    note: "Create a backup starting passcode on the center screen in case your smartphone battery depletes."
                },
                {
                    title: "SecuriCode Keyless Entry Keypad",
                    readTime: "2 min read",
                    summary: "Operate doors and trunk using your personalized 5-digit door pillar keypad.",
                    steps: [
                        "Touch the driver door B-pillar glass to illuminate the invisible red keypad.",
                        "Enter your 5-digit master code to unlock the driver's door instantly.",
                        "Press 3-4 within 5 seconds to unlock all remaining passenger doors and tailgate."
                    ],
                    note: "To lock all doors upon exiting without a key, press and hold buttons 7-8 and 9-0 simultaneously."
                },
                {
                    title: "Hands-Free Foot-Activated Liftgate",
                    readTime: "2 min read",
                    summary: "Opening and closing the rear cargo tailgate with a gentle forward kicking motion.",
                    steps: [
                        "Stand centered behind the rear bumper with your key fob or paired smartphone on your person.",
                        "Make a single, fluid forward kicking motion directly beneath the center bumper license plate.",
                        "Step back one stride; hazard lamps will flash and an audible chime will sound before lifting."
                    ],
                    note: "Do not swing your foot from side to side; use a clean forward kick and withdraw motion."
                },
                {
                    title: "Power Windows & Global Window Opening",
                    readTime: "2 min read",
                    summary: "One-touch up/down controls, anti-pinch sensor protection, and remote window vent.",
                    steps: [
                        "Press or pull window switches firmly past the resistance detent for one-touch automated travel.",
                        "To remotely vent all windows on hot days, press and hold the key fob Unlock button for 4 seconds.",
                        "If an obstruction is encountered, windows reverse automatically to protect occupants."
                    ],
                    note: "To re-calibrate window pinch protection after battery disconnect, hold switch up for 3 seconds after closing."
                }
            ]
        },
        {
            id: "driving",
            title: "Driving and Operating",
            topics: [
                {
                    title: "Push-Button Electronic Transmission Shifter",
                    readTime: "2 min read",
                    summary: "Selecting Park, Reverse, Neutral, and Drive using the piano key center console buttons.",
                    steps: [
                        "Firmly depress the brake pedal with your foot before selecting any drive gear.",
                        "Press 'P' for Park, 'R' for Reverse, 'N' for Neutral, or 'D' for Drive.",
                        "An LED indicator above each button illuminates solid blue to confirm active engagement."
                    ],
                    note: "The vehicle automatically selects Park if the driver door is opened while unbelted."
                },
                {
                    title: "Adaptive Drive Modes & Performance Dynamics",
                    readTime: "3 min read",
                    summary: "Tailor throttle response, steering weight, and suspension damping characteristics.",
                    steps: [
                        "Normal Mode: Effortless steering, balanced throttle mapping, and plush compliance.",
                        "Conserve Mode: Maximizes efficiency and electric driving range with optimized HVAC.",
                        "Excite Mode: Stiffens adaptive dampers, sharpens accelerator curves, and tightens steering feel.",
                        "Slippery Mode: Mitigates wheel spin on ice, packed snow, and slick wet roads."
                    ],
                    note: "Drive mode selections persist across power cycles for seamless daily usability."
                },
                {
                    title: "Adaptive Cruise Control & Lane Centering",
                    readTime: "4 min read",
                    summary: "Hands-on highway speed regulation and steering guidance assistance.",
                    steps: [
                        "Press the Cruise Control icon on the left steering wheel spoke while driving above 15 mph.",
                        "Use the RES(+) / SET(-) rocker toggle to establish your desired cruising speed.",
                        "Tap the gap distance switch to cycle through 4 progressive trailing vehicle intervals."
                    ],
                    note: "Adaptive Cruise Control is a driver aid; always keep your hands on the wheel and attention on the road."
                },
                {
                    title: "Active Park Assist 2.0 Automation",
                    readTime: "3 min read",
                    summary: "Hands-free automated parallel and perpendicular parking maneuvers.",
                    steps: [
                        "Press the Park Assist button on the dashboard console while driving slowly past parking spaces.",
                        "Indicate your desired parking side with the turn signal lever.",
                        "Once a valid space is flagged, follow screen instructions: shift to 'N' and hold the Park Assist button."
                    ],
                    note: "The vehicle controls steering, acceleration, gear shifting, and braking until parking is complete."
                }
            ]
        },
        {
            id: "lighting",
            title: "Lighting and Visibility",
            topics: [
                {
                    title: "Adaptive Matrix LED Headlamps",
                    readTime: "3 min read",
                    summary: "Intelligent dynamic beam shaping and glare-free illumination.",
                    steps: [
                        "Matrix headlamps automatically steer light into corners corresponding with steering wheel angle.",
                        "Camera sensors detect oncoming traffic and selectively dim individual LED segments to avoid glare.",
                        "Turn the rotary headlight switch to 'AUTO' for fully automated daytime/nighttime activation."
                    ],
                    note: "Fog lamps can be activated independently by tapping the fog lamp symbol on the rotary dial."
                },
                {
                    title: "Auto High-Beam System",
                    readTime: "2 min read",
                    summary: "Automated high-beam switching based on surrounding illumination.",
                    steps: [
                        "Enable Auto High Beam in Vehicle Settings > Lighting > Auto High Beam.",
                        "The system engages high beams on dark rural roads when vehicle speed exceeds 25 mph.",
                        "High beams dip to low beams immediately when oncoming headlamps or streetlamps are detected."
                    ],
                    note: "Ensure the windshield area in front of the rearview mirror camera remains clean and clear of frost."
                },
                {
                    title: "360-Degree Camera & Split-Screen Views",
                    readTime: "3 min read",
                    summary: "Four wide-angle cameras generate a seamless birds-eye aerial perspective.",
                    steps: [
                        "Shift into Reverse (R) or press the physical Camera button on the dashboard.",
                        "Toggle between: 360-degree aerial, Front 180-degree wide angle, and Rear hitch guidance.",
                        "Dynamic trajectory guideline lines project vehicle width and predicted tire travel path."
                    ],
                    note: "Washers automatically clean the rear camera lens whenever the rear window washer is activated."
                }
            ]
        },
        {
            id: "climate",
            title: "Climate Control",
            topics: [
                {
                    title: "Tri-Zone Automatic Temperature Regulation",
                    readTime: "3 min read",
                    summary: "Independent micro-climate zones for driver, passenger, and rear cabin.",
                    steps: [
                        "Tap the bottom climate control bar on the central display to expand full controls.",
                        "Adjust temperature sliders to your preferred setpoint (e.g. 70°F / 21°C).",
                        "Tap 'AUTO' to let the system automatically manage fan speed, vent blend, and A/C compressor."
                    ],
                    note: "Press 'SYNC' to instantly align all passenger zones with the driver's current temperature."
                },
                {
                    title: "Auto Air Refresh & Cabin Odor Neutralizer",
                    readTime: "2 min read",
                    summary: "High-efficiency particulate filtration and air quality monitoring.",
                    steps: [
                        "The internal laser air quality sensor measures PM2.5 particulates in real-time.",
                        "When poor air quality or traffic exhaust is detected, recirculation automatically engages.",
                        "Cabin Air Refresh rapidly purges and replaces 100% of cabin air in under 90 seconds."
                    ],
                    note: "Replace the high-efficiency cabin micro-filter annually for peak filtration efficiency."
                },
                {
                    title: "Heated & Ventilated Seat Operation",
                    readTime: "2 min read",
                    summary: "Three-stage cooling airflow and rapid soothing seat warmth.",
                    steps: [
                        "Tap the seat icon on the bottom climate bar to open seat heating and cooling sliders.",
                        "Select Level 1, 2, or 3 for both seat cushion and backrest zones.",
                        "Seat climate synchronization can be automated in synergy with active Rejuvenate themes."
                    ],
                    note: "Ventilated seats draw cabin air through perforations; avoid spilling liquids on perforated leather."
                }
            ]
        },
        {
            id: "seats",
            title: "Seats and Restraints",
            topics: [
                {
                    title: "30-Way Perfect Position Seat Adjustment",
                    readTime: "4 min read",
                    summary: "Individually articulated thigh extensions, upper backrest pivot, and multi-contour massage.",
                    steps: [
                        "Use the door-mounted metallic seat switch pack or the digital Seats page on screen.",
                        "Adjust independent left and right thigh extensions to eliminate fatigue on long journeys.",
                        "Configure Active Motion rolling wave massage modes with variable pressure intensities."
                    ],
                    note: "Store your tailored ergonomics by holding door memory button 1, 2, or 3 until an audible chime sounds."
                },
                {
                    title: "Power-Fold Second & Third Row Seats",
                    readTime: "2 min read",
                    summary: "One-touch power release switches located in the rear cargo luggage compartment.",
                    steps: [
                        "Open the rear tailgate and locate the button panel on the left cargo trim wall.",
                        "Press the corresponding left or right button to fold seats flush into the cargo floor.",
                        "Press the dual-arrow button to fold all rear rows simultaneously for maximum cargo volume."
                    ],
                    note: "Ensure rear seat surfaces are clear of cargo, child seats, and seatbelts before operating power fold."
                },
                {
                    title: "Child Safety Seats & LATCH Anchors",
                    readTime: "3 min read",
                    summary: "Proper child seat securement using ISOFIX / LATCH anchor bars and top tether straps.",
                    steps: [
                        "Locate the two lower LATCH anchor symbols positioned in the seat bight between cushion and backrest.",
                        "Latch child seat connector hooks firmly onto the rigid steel anchor bars until an audible click is felt.",
                        "Route the top tether strap over the headrest and fasten to the anchor loop on the back of the seat."
                    ],
                    note: "Never install a rearward-facing child restraint in the front seat equipped with an active passenger airbag."
                }
            ]
        },
        {
            id: "tires",
            title: "Wheels and Tires",
            topics: [
                {
                    title: "Tire Pressure Monitoring System (TPMS)",
                    readTime: "2 min read",
                    summary: "Real-time individual tire PSI readout and low pressure warning alert thresholds.",
                    steps: [
                        "Navigate to the Vehicle page on the central display to view real-time corner PSI ratings.",
                        "Recommended tire pressure specifications are stamped on the driver's door B-pillar tire placard.",
                        "If the amber TPMS telltale illuminates, check tire pressures promptly when tires are cold."
                    ],
                    note: "Tire pressure readings rise naturally by 3-5 PSI as tires warm up during highway driving."
                },
                {
                    title: "Tire Mobility Inflator & Sealant Kit",
                    readTime: "3 min read",
                    summary: "Temporarily repairing tread punctures without a full spare tire swap.",
                    steps: [
                        "Locate the compressor kit stored beneath the rear trunk luggage compartment floorboard.",
                        "Connect the sealant canister hose securely to the punctured tire's valve stem.",
                        "Plug the 12V power cord into the cargo power outlet and switch compressor power ON."
                    ],
                    note: "Do not exceed 50 mph (80 km/h) after applying sealant; visit an authorized tire service facility promptly."
                },
                {
                    title: "Tire Rotation & Winter Chain Clearances",
                    readTime: "2 min read",
                    summary: "Even tread wear patterns and approved low-profile tire traction chain specs.",
                    steps: [
                        "Rotate tires every 10,000 miles to maximize tread life and balance AWD grip.",
                        "Only use SAE Class S low-profile tire cables to prevent contact with suspension dampers.",
                        "Install traction cables strictly on the rear driving axle for all-wheel drive stability."
                    ],
                    note: "Remove snow chains as soon as you return to dry, plowed pavement."
                }
            ]
        }
    ]

    // =========================================================================
    // VISUAL SEARCH HOTSPOTS DATA: INTERIOR (1 of 2) & EXTERIOR (2 of 2)
    // =========================================================================
    // Hotspots corresponding directly to image copy 10.png (Interior 1 of 2)
    // Laser-accurate coordinates verified against 1536x1024 graphic badges
    readonly property var visualHotspotsInterior: [
        // Top Row Badges (y: 0.1514)
        { name: "Driver Seat Adjust / Memory", category: "Seats and Restraints", topic: "30-Way Perfect Position Seat Adjustment", x: 0.0729, y: 0.1514 },
        { name: "Front Airbags", category: "Safety and Driver Assistance", topic: "Airbag Supplemental Restraint System (SRS)", x: 0.1836, y: 0.1514 },
        { name: "Heated Steering Wheel", category: "Instrument Panel and Interior", topic: "Steering Wheel Controls & Capacitive Switches", x: 0.2904, y: 0.1514 },
        { name: "Front Seat Heating", category: "Climate Control", topic: "Heated & Ventilated Seat Operation", x: 0.3945, y: 0.1514 },
        { name: "Roof Interior Light", category: "Lighting and Visibility", topic: "Ambient Light Customization & Palette", x: 0.4993, y: 0.1514 },
        { name: "Sunroof Tilt / Slide", category: "Doors, Windows and Keys", topic: "Panoramic Vista Roof & Power Sunshade", x: 0.6035, y: 0.1514 },
        { name: "Seat Ventilation", category: "Climate Control", topic: "Heated & Ventilated Seat Operation", x: 0.7083, y: 0.1514 },
        { name: "Seat Massage", category: "Seats and Restraints", topic: "30-Way Perfect Position Seat Adjustment", x: 0.8132, y: 0.1514 },
        { name: "Cabin Air Purifier", category: "Climate Control", topic: "Auto Air Refresh & Cabin Odor Neutralizer", x: 0.9271, y: 0.1514 },
        // Bottom Row Badges (y: 0.8525)
        { name: "Window Control", category: "Doors, Windows and Keys", topic: "Power Windows, Global Open/Close & Child Locks", x: 0.0729, y: 0.8525 },
        { name: "Premium Audio", category: "Audio, Maps and Connectivity", topic: "Revel Ultima 3D Audio Experience & Soundstage", x: 0.1862, y: 0.8525 },
        { name: "Ambient Lighting", category: "Lighting and Visibility", topic: "Ambient Light Customization & Palette", x: 0.2982, y: 0.8525 },
        { name: "HVAC Temperature", category: "Climate Control", topic: "Tri-Zone Automatic Temperature Regulation", x: 0.4076, y: 0.8525 },
        { name: "Wireless Phone Charging", category: "Audio, Maps and Connectivity", topic: "Wireless Device Charging Pad", x: 0.5241, y: 0.8525 },
        { name: "USB-C High-Power Port", category: "Audio, Maps and Connectivity", topic: "SYNC 4 & APEX IVI Overview", x: 0.6432, y: 0.8525 },
        { name: "Cup Holder & Console", category: "Instrument Panel and Interior", topic: "Panoramic 48-Inch Pillar-to-Pillar Display Modes", x: 0.7565, y: 0.8525 },
        { name: "Passenger Seat Adjustment", category: "Seats and Restraints", topic: "30-Way Perfect Position Seat Adjustment", x: 0.9284, y: 0.8525 }
    ]

    // Hotspots corresponding directly to image copy 9.png (Exterior 2 of 2)
    // Laser-accurate coordinates verified against 1536x1024 graphic badges
    readonly property var visualHotspotsExterior: [
        // Left Column Badges
        { name: "Side Mirror Auto Fold", category: "Lighting and Visibility", topic: "Power Folding Heated Mirrors & BLIS Alert", x: 0.0703, y: 0.1289 },
        { name: "Adaptive Matrix LED Headlamp", category: "Lighting and Visibility", topic: "Adaptive Matrix LED Headlamps", x: 0.0710, y: 0.2412 },
        { name: "Tire Pressure System (TPMS)", category: "Wheels and Tires", topic: "Tire Pressure Monitoring System (TPMS)", x: 0.0710, y: 0.3555 },
        { name: "Front Parking Sensors", category: "Safety and Driver Assistance", topic: "Active Park Assist 2.0 (Automated Parking)", x: 0.0710, y: 0.4707 },
        { name: "Front Parking Camera", category: "Lighting and Visibility", topic: "360-Degree Camera & Split-Screen Views", x: 0.0703, y: 0.6416 },
        { name: "Radar Sensor Assist", category: "Safety and Driver Assistance", topic: "Adaptive Cruise Control with Stop-and-Go", x: 0.0703, y: 0.7451 },
        { name: "Fog Light Control", category: "Lighting and Visibility", topic: "Adaptive Matrix LED Headlamps", x: 0.0703, y: 0.8477 },
        // Right Column Badges
        { name: "Panoramic Sunroof", category: "Doors, Windows and Keys", topic: "Panoramic Vista Roof & Power Sunshade", x: 0.8548, y: 0.1270 },
        { name: "Smart Door Lock", category: "Doors, Windows and Keys", topic: "SecuriCode Keyless Entry Keypad", x: 0.8555, y: 0.2207 },
        { name: "Fuel & Charge Port", category: "General Information", topic: "Vehicle Identification Number (VIN)", x: 0.8633, y: 0.3125 },
        { name: "Dynamic LED Tail Light", category: "Lighting and Visibility", topic: "Adaptive Matrix LED Headlamps", x: 0.8685, y: 0.4180 },
        { name: "Rear Backup Camera", category: "Lighting and Visibility", topic: "360-Degree Camera & Split-Screen Views", x: 0.8594, y: 0.6494 },
        { name: "Rear Parking Sensors", category: "Safety and Driver Assistance", topic: "Reverse Brake Assist & Cross-Traffic Alert", x: 0.8594, y: 0.7510 },
        { name: "Reverse Backup Lamp", category: "Lighting and Visibility", topic: "Adaptive Matrix LED Headlamps", x: 0.8594, y: 0.8525 }
    ]

    // =========================================================================
    // LIGHT BACKGROUND: Master Default IVI Background shines through brightly
    // =========================================================================
    Rectangle {
        id: lightBackdropTint
        anchors.fill: parent
        color: Qt.rgba(10/255, 18/255, 32/255, 0.10) // Subtle 10% tint to keep the background light and bright
        z: 0
    }

    // =========================================================================
    // 1. TOP HEADER & NAVIGATION (Matches Reference Photo Exactly)
    // =========================================================================
    Item {
        id: headerItem
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        height: 64
        z: 20

        // Left Action & App Brand Icon
        Row {
            id: headerLeftGroup
            anchors.left: parent.left
            anchors.leftMargin: 36
            anchors.verticalCenter: parent.verticalCenter
            spacing: 20

            // Back Arrow Button (Standard "←" used in vehiclebar)
            Item {
                width: 36
                height: 36
                anchors.verticalCenter: parent.verticalCenter

                Text {
                    anchors.centerIn: parent
                    text: "←"
                    font.family: "Inter"
                    font.pixelSize: 26
                    font.weight: Font.DemiBold
                    color: backMouse.pressed ? "#94A3B8" : (backMouse.containsMouse ? "#FFFFFF" : "#E2E8F0")
                }

                MouseArea {
                    id: backMouse
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        if (root.activeArticle !== null) {
                            root.activeArticle = null;
                            if (root.currentTab === "visual" || root.currentTab === "bookmarks") {
                                root.activeCategory = "";
                            }
                        } else if (root.activeCategory !== "") {
                            root.activeCategory = "";
                        } else {
                            root.backRequested();
                        }
                    }
                }
            }

            // Circular Blue Manual App Icon (matching reference screenshot)
            Image {
                width: 38
                height: 38
                source: "qrc:/ApexVision/qml/assets/icons/app_manual.svg"
                fillMode: Image.PreserveAspectFit
                smooth: true
                anchors.verticalCenter: parent.verticalCenter
            }
        }

        // Top Right: Search Icon
        Row {
            id: headerRightGroup
            anchors.right: parent.right
            anchors.rightMargin: 36
            anchors.verticalCenter: parent.verticalCenter
            spacing: 18

            // Search Icon Button
            Item {
                width: 36
                height: 36
                anchors.verticalCenter: parent.verticalCenter

                Image {
                    anchors.centerIn: parent
                    width: 22
                    height: 22
                    source: "qrc:/ApexVision/qml/assets/icons/icon_search_white.svg"
                    fillMode: Image.PreserveAspectFit
                    smooth: true
                    opacity: root.searchActive ? 1.0 : (searchMouse.pressed ? 0.60 : (searchMouse.containsMouse ? 1.0 : 0.80))
                }

                MouseArea {
                    id: searchMouse
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        root.searchActive = !root.searchActive;
                        if (root.searchActive) {
                            root.showTouchKeyboard = true;
                            searchField.forceActiveFocus();
                        } else {
                            root.showTouchKeyboard = false;
                            searchField.text = "";
                            root.searchQuery = "";
                        }
                    }
                }
            }
        }

        // Center Slot: Smoothly transitions between Top Navigation Tabs and Breadcrumb / Drill-down Title
        Item {
            id: headerCenterSlot
            anchors.left: headerLeftGroup.right
            anchors.leftMargin: 20
            anchors.right: headerRightGroup.left
            anchors.rightMargin: 20
            anchors.verticalCenter: parent.verticalCenter
            height: 44
            clip: true

            // Mode 1: Main Header Tabs (Categories, Visual search, Bookmarks)
            Item {
                id: tabsContainer
                anchors.verticalCenter: parent.verticalCenter
                width: tabsRow.width
                height: 44
                x: (root.activeCategory === "" && root.activeArticle === null) ? 0 : -60
                opacity: (root.activeCategory === "" && root.activeArticle === null) ? 1.0 : 0.0
                visible: opacity > 0.001
                enabled: opacity > 0.5

                Behavior on x { NumberAnimation { duration: 300; easing.type: Easing.OutCubic } }
                Behavior on opacity { NumberAnimation { duration: 240; easing.type: Easing.InOutQuad } }

                Row {
                    id: tabsRow
                    anchors.verticalCenter: parent.verticalCenter
                    spacing: 26

                    // Tab 1: Categories
                    Item {
                        id: tabCatItem
                        width: catText.implicitWidth
                        height: 44

                        Text {
                            id: catText
                            anchors.top: parent.top
                            anchors.topMargin: 6
                            text: "Categories"
                            font.family: "Inter"
                            font.pixelSize: 21
                            font.weight: root.currentTab === "categories" ? Font.Bold : Font.Normal
                            color: root.currentTab === "categories" ? "#FFFFFF" : Qt.rgba(255, 255, 255, 0.65)
                            Behavior on color { ColorAnimation { duration: 180 } }
                        }

                        MouseArea {
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                root.currentTab = "categories";
                                root.searchActive = false;
                            }
                        }
                    }

                    // Tab 2: Visual search
                    Item {
                        id: tabVisualItem
                        width: visualText.implicitWidth
                        height: 44

                        Text {
                            id: visualText
                            anchors.top: parent.top
                            anchors.topMargin: 6
                            text: "Visual search"
                            font.family: "Inter"
                            font.pixelSize: 21
                            font.weight: root.currentTab === "visual" ? Font.Bold : Font.Normal
                            color: root.currentTab === "visual" ? "#FFFFFF" : Qt.rgba(255, 255, 255, 0.65)
                            Behavior on color { ColorAnimation { duration: 180 } }
                        }

                        MouseArea {
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                root.currentTab = "visual";
                                root.searchActive = false;
                            }
                        }
                    }

                    // Tab 3: Bookmarks
                    Item {
                        id: tabBmItem
                        width: bmText.implicitWidth
                        height: 44

                        Text {
                            id: bmText
                            anchors.top: parent.top
                            anchors.topMargin: 6
                            text: "Bookmarks"
                            font.family: "Inter"
                            font.pixelSize: 21
                            font.weight: root.currentTab === "bookmarks" ? Font.Bold : Font.Normal
                            color: root.currentTab === "bookmarks" ? "#FFFFFF" : Qt.rgba(255, 255, 255, 0.65)
                            Behavior on color { ColorAnimation { duration: 180 } }
                        }

                        MouseArea {
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                root.currentTab = "bookmarks";
                                root.searchActive = false;
                            }
                        }
                    }
                }

                // Smooth Sliding Golden/Amber Active Underline Indicator
                Rectangle {
                    id: slidingTabIndicator
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 2
                    height: 3
                    radius: 1.5
                    color: "#E2A968"
                    x: root.currentTab === "categories" ? tabCatItem.x :
                       (root.currentTab === "visual" ? tabVisualItem.x : tabBmItem.x)
                    width: root.currentTab === "categories" ? tabCatItem.width :
                           (root.currentTab === "visual" ? tabVisualItem.width : tabBmItem.width)

                    Behavior on x {
                        NumberAnimation { duration: 280; easing.type: Easing.OutCubic }
                    }
                    Behavior on width {
                        NumberAnimation { duration: 280; easing.type: Easing.OutCubic }
                    }
                }
            }

            // Mode 2: Drill-down Title (e.g. "General Information" or Article Title)
            Item {
                id: drillDownTitleContainer
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                height: 44
                x: (root.activeCategory !== "" || root.activeArticle !== null) ? 0 : 60
                opacity: (root.activeCategory !== "" || root.activeArticle !== null) ? 1.0 : 0.0
                visible: opacity > 0.001

                Behavior on x { NumberAnimation { duration: 300; easing.type: Easing.OutCubic } }
                Behavior on opacity { NumberAnimation { duration: 240; easing.type: Easing.InOutQuad } }

                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.right: parent.right
                    text: root.activeArticle !== null ? root.activeArticle.title : root.activeCategory
                    font.family: "Inter"
                    font.pixelSize: 22
                    font.weight: Font.DemiBold
                    color: "#FFFFFF"
                    elide: Text.ElideRight
                    renderType: Text.NativeRendering
                }
            }
        }
    }

    // Horizontal Divider below Header
    Rectangle {
        id: headerDividerLine
        anchors.top: headerItem.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.leftMargin: 36
        anchors.rightMargin: 36
        height: 1
        color: Qt.rgba(255, 255, 255, 0.12)
    }

    // Inline Search Input Bar (Expands when search icon tapped, perfectly aligned to 36px)
    Rectangle {
        id: searchBarContainer
        anchors.top: headerDividerLine.bottom
        anchors.topMargin: 12
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.leftMargin: 36
        anchors.rightMargin: 36
        height: root.searchActive ? 52 : 0
        radius: 12
        color: Qt.rgba(255, 255, 255, 0.08)
        border.color: (searchField.activeFocus || root.showTouchKeyboard) ? Qt.rgba(255, 255, 255, 0.40) : Qt.rgba(255, 255, 255, 0.18)
        border.width: 1
        visible: height > 0
        clip: true

        Behavior on height { NumberAnimation { duration: 200; easing.type: Easing.OutCubic } }

        Row {
            anchors.fill: parent
            anchors.leftMargin: 16
            anchors.rightMargin: 16
            spacing: 14

            Image {
                width: 22
                height: 22
                source: "qrc:/ApexVision/qml/assets/icons/icon_search_white.svg"
                fillMode: Image.PreserveAspectFit
                smooth: true
                anchors.verticalCenter: parent.verticalCenter
                opacity: 0.85
            }

            TextInput {
                id: searchField
                anchors.verticalCenter: parent.verticalCenter
                width: parent.width - 120
                color: "#FFFFFF"
                font.family: "Inter"
                font.pixelSize: 18
                clip: true
                onTextChanged: root.searchQuery = text
                onActiveFocusChanged: {
                    if (activeFocus) root.showTouchKeyboard = true;
                }

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.IBeamCursor
                    onClicked: {
                        searchField.forceActiveFocus();
                        root.showTouchKeyboard = true;
                    }
                }

                Text {
                    text: "Search manual topics, features, instructions..."
                    color: Qt.rgba(255, 255, 255, 0.40)
                    font.family: "Inter"
                    font.pixelSize: 18
                    visible: !searchField.text
                }
            }

            // Keyboard Toggle Button
            Rectangle {
                width: 32
                height: 32
                radius: 8
                color: root.showTouchKeyboard ? Qt.rgba(255, 255, 255, 0.22) : (keyToggleMa.containsMouse ? Qt.rgba(255, 255, 255, 0.12) : "transparent")
                anchors.verticalCenter: parent.verticalCenter

                Image {
                    anchors.centerIn: parent
                    width: 18
                    height: 18
                    source: "qrc:/ApexVision/qml/assets/icons/yt_keyboard.svg"
                    fillMode: Image.PreserveAspectFit
                    opacity: root.showTouchKeyboard ? 1.0 : 0.65
                }

                MouseArea {
                    id: keyToggleMa
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: root.showTouchKeyboard = !root.showTouchKeyboard
                }
            }

            // Clear Button "✕"
            Text {
                text: "✕"
                color: Qt.rgba(255, 255, 255, 0.70)
                font.pixelSize: 18
                anchors.verticalCenter: parent.verticalCenter
                visible: searchField.text.length > 0
                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: root.clearSearchInput()
                }
            }
        }
    }

    // =========================================================================
    // MAIN CONTENT VIEWPORT (Unified 36px Margins, Smooth Slides & Keyboard Avoidance)
    // =========================================================================
    Item {
        id: contentViewport
        anchors.top: root.searchActive ? searchBarContainer.bottom : headerDividerLine.bottom
        anchors.topMargin: 12
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.leftMargin: 36
        anchors.rightMargin: 36
        anchors.bottom: (root.searchActive && root.showTouchKeyboard) ? touchKeyboard.top : parent.bottom
        anchors.bottomMargin: (root.searchActive && root.showTouchKeyboard) ? 8 : 14
        clip: true

        // =====================================================================
        // 1. VIEW A: MAIN CATEGORIES LIST (Unified alignment & smooth slide)
        // =====================================================================
        Item {
            id: categoriesView
            width: parent.width
            height: parent.height
            readonly property bool isCurrent: root.currentTab === "categories" && root.activeCategory === "" && root.activeArticle === null && (!root.searchActive || root.searchQuery.trim().length === 0)
            x: isCurrent ? 0 : -contentViewport.width * 0.35
            opacity: isCurrent ? 1.0 : 0.0
            visible: opacity > 0.001
            enabled: opacity > 0.9

            Behavior on x { NumberAnimation { duration: 340; easing.type: Easing.OutCubic } }
            Behavior on opacity { NumberAnimation { duration: 260; easing.type: Easing.InOutQuad } }

            // Left Vertical Dragger Track & Fully Interactive Draggable Capsule Thumb
            Item {
                id: catDraggerTrack
                anchors.left: parent.left
                anchors.leftMargin: 6
                anchors.top: parent.top
                anchors.topMargin: 12
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 16
                width: 16
                z: 20

                // Vertical track guide line
                Rectangle {
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    width: 3
                    radius: 1.5
                    color: Qt.rgba(255, 255, 255, 0.16)
                }

                // Interactive Draggable Thumb (White capsule matching photo)
                Rectangle {
                    id: catDraggerThumb
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: 6
                    radius: 3
                    color: catDraggerMouse.pressed ? "#FFFFFF" :
                           (catDraggerMouse.containsMouse ? Qt.rgba(255, 255, 255, 0.95) : Qt.rgba(255, 255, 255, 0.75))
                    border.color: Qt.rgba(255, 255, 255, 0.50)
                    border.width: 1

                    // Dynamic height based on visible content ratio
                    readonly property real visibleRatio: Math.min(1.0, categoriesFlickable.height / Math.max(1, categoriesFlickable.contentHeight))
                    height: Math.max(54, catDraggerTrack.height * visibleRatio)

                    // Position synced with categoriesFlickable.contentY
                    readonly property real maxContentY: Math.max(1, categoriesFlickable.contentHeight - categoriesFlickable.height)
                    readonly property real maxThumbY: Math.max(1, catDraggerTrack.height - height)
                    y: Math.min(maxThumbY, Math.max(0, (categoriesFlickable.contentY / maxContentY) * maxThumbY))

                    Behavior on color { ColorAnimation { duration: 120 } }

                    // Touch drag handle
                    MouseArea {
                        id: catDraggerMouse
                        anchors.fill: parent
                        anchors.margins: -16 // Generous 38px touch target for touchscreen
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        drag.target: catDraggerThumb
                        drag.axis: Drag.YAxis
                        drag.minimumY: 0
                        drag.maximumY: catDraggerTrack.height - catDraggerThumb.height

                        onPositionChanged: {
                            if (drag.active) {
                                var ratio = catDraggerThumb.y / Math.max(1, catDraggerTrack.height - catDraggerThumb.height);
                                categoriesFlickable.contentY = ratio * (categoriesFlickable.contentHeight - categoriesFlickable.height);
                            }
                        }
                    }
                }

                // Click / Tap on track to jump immediately
                MouseArea {
                    anchors.fill: parent
                    z: -1
                    cursorShape: Qt.PointingHandCursor
                    onClicked: function(mouse) {
                        var targetThumbY = mouse.y - catDraggerThumb.height / 2;
                        var maxThumbY = catDraggerTrack.height - catDraggerThumb.height;
                        var clampedY = Math.max(0, Math.min(maxThumbY, targetThumbY));
                        var ratio = clampedY / Math.max(1, maxThumbY);
                        categoriesFlickable.contentY = ratio * (categoriesFlickable.contentHeight - categoriesFlickable.height);
                    }
                }
            }

            // Categories Flickable List (Starting at 28px left margin)
            Flickable {
                id: categoriesFlickable
                anchors.left: catDraggerTrack.right
                anchors.leftMargin: 8
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                contentWidth: width
                contentHeight: categoriesCol.height + 30
                clip: true
                boundsBehavior: Flickable.StopAtBounds

                Column {
                    id: categoriesCol
                    width: parent.width
                    spacing: 0

                    Repeater {
                        model: root.manualCategories

                        Item {
                            width: categoriesCol.width
                            height: 66

                            Rectangle {
                                anchors.fill: parent
                                color: catRowMouse.containsMouse ? Qt.rgba(255, 255, 255, 0.08) : "transparent"
                                radius: 8
                            }

                            // Category Title Text (Pure white, DemiBold, sharp native rendering)
                            Text {
                                anchors.left: parent.left
                                anchors.leftMargin: 12
                                anchors.verticalCenter: parent.verticalCenter
                                text: modelData.title
                                color: "#FFFFFF"
                                font.family: "Inter"
                                font.pixelSize: 22
                                font.weight: Font.DemiBold
                                renderType: Text.NativeRendering
                            }

                            // Chevron Right Indicator (">" Pure white, DemiBold)
                            Text {
                                anchors.right: parent.right
                                anchors.rightMargin: 16
                                anchors.verticalCenter: parent.verticalCenter
                                text: "›"
                                color: "#FFFFFF"
                                font.family: "Inter"
                                font.pixelSize: 28
                                font.weight: Font.DemiBold
                                renderType: Text.NativeRendering
                            }

                            // Subtle Divider Line below each row
                            Rectangle {
                                anchors.bottom: parent.bottom
                                width: parent.width
                                height: 1
                                color: Qt.rgba(255, 255, 255, 0.15)
                            }

                            MouseArea {
                                id: catRowMouse
                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor
                                onClicked: {
                                    root.activeCategory = modelData.title;
                                }
                            }
                        }
                    }
                }
            }
        }

        // =====================================================================
        // 2. VIEW B: TOPICS UNDER SELECTED CATEGORY (Exact alignment match)
        // =====================================================================
        Item {
            id: topicsView
            width: parent.width
            height: parent.height
            readonly property bool isCurrent: root.currentTab === "categories" && root.activeCategory !== "" && root.activeArticle === null && (!root.searchActive || root.searchQuery.trim().length === 0)
            x: isCurrent ? 0 : (root.activeArticle !== null ? -contentViewport.width * 0.35 : contentViewport.width)
            opacity: isCurrent ? 1.0 : 0.0
            visible: opacity > 0.001
            enabled: opacity > 0.9

            Behavior on x { NumberAnimation { duration: 340; easing.type: Easing.OutCubic } }
            Behavior on opacity { NumberAnimation { duration: 260; easing.type: Easing.InOutQuad } }

            // Left Vertical Dragger Track for Topics List
            Item {
                id: topDraggerTrack
                anchors.left: parent.left
                anchors.leftMargin: 6
                anchors.top: parent.top
                anchors.topMargin: 12
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 16
                width: 16
                z: 20

                Rectangle {
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    width: 3
                    radius: 1.5
                    color: Qt.rgba(255, 255, 255, 0.16)
                }

                Rectangle {
                    id: topDraggerThumb
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: 6
                    radius: 3
                    color: topDraggerMouse.pressed ? "#FFFFFF" :
                           (topDraggerMouse.containsMouse ? Qt.rgba(255, 255, 255, 0.95) : Qt.rgba(255, 255, 255, 0.75))
                    border.color: Qt.rgba(255, 255, 255, 0.50)
                    border.width: 1

                    readonly property real visibleRatio: Math.min(1.0, topicsList.height / Math.max(1, topicsList.contentHeight))
                    height: Math.max(54, topDraggerTrack.height * visibleRatio)

                    readonly property real maxContentY: Math.max(1, topicsList.contentHeight - topicsList.height)
                    readonly property real maxThumbY: Math.max(1, topDraggerTrack.height - height)
                    y: Math.min(maxThumbY, Math.max(0, (topicsList.contentY / maxContentY) * maxThumbY))

                    Behavior on color { ColorAnimation { duration: 120 } }

                    MouseArea {
                        id: topDraggerMouse
                        anchors.fill: parent
                        anchors.margins: -16
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        drag.target: topDraggerThumb
                        drag.axis: Drag.YAxis
                        drag.minimumY: 0
                        drag.maximumY: topDraggerTrack.height - topDraggerThumb.height

                        onPositionChanged: {
                            if (drag.active) {
                                var ratio = topDraggerThumb.y / Math.max(1, topDraggerTrack.height - topDraggerThumb.height);
                                topicsList.contentY = ratio * (topicsList.contentHeight - topicsList.height);
                            }
                        }
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    z: -1
                    cursorShape: Qt.PointingHandCursor
                    onClicked: function(mouse) {
                        var targetThumbY = mouse.y - topDraggerThumb.height / 2;
                        var maxThumbY = topDraggerTrack.height - topDraggerThumb.height;
                        var clampedY = Math.max(0, Math.min(maxThumbY, targetThumbY));
                        var ratio = clampedY / Math.max(1, maxThumbY);
                        topicsList.contentY = ratio * (topicsList.contentHeight - topicsList.height);
                    }
                }
            }

            ListView {
                id: topicsList
                anchors.left: topDraggerTrack.right
                anchors.leftMargin: 8
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                clip: true
                boundsBehavior: Flickable.StopAtBounds
                model: {
                    for (var i = 0; i < root.manualCategories.length; ++i) {
                        if (root.manualCategories[i].title === root.activeCategory) {
                            return root.manualCategories[i].topics;
                        }
                    }
                    return [];
                }

                delegate: Item {
                    width: ListView.view.width
                    height: 80

                    Rectangle {
                        anchors.fill: parent
                        color: topicMouse.containsMouse ? Qt.rgba(255, 255, 255, 0.06) : "transparent"
                        radius: 10
                    }

                    Column {
                        anchors.left: parent.left
                        anchors.leftMargin: 12
                        anchors.right: topicChevron.left
                        anchors.rightMargin: 16
                        anchors.verticalCenter: parent.verticalCenter
                        spacing: 4

                        Text {
                            text: modelData.title
                            color: "#FFFFFF"
                            font.family: "Inter"
                            font.pixelSize: 20
                            font.weight: Font.DemiBold
                            renderType: Text.NativeRendering
                            elide: Text.ElideRight
                            width: parent.width
                        }

                        Text {
                            text: modelData.readTime + "  •  " + modelData.summary
                            color: "#E2E8F0"
                            font.family: "Inter"
                            font.pixelSize: 15
                            font.weight: Font.Medium
                            renderType: Text.NativeRendering
                            elide: Text.ElideRight
                            width: parent.width
                        }
                    }

                    Text {
                        id: topicChevron
                        anchors.right: parent.right
                        anchors.rightMargin: 16
                        anchors.verticalCenter: parent.verticalCenter
                        text: "›"
                        color: "#FFFFFF"
                        font.family: "Inter"
                        font.pixelSize: 28
                        font.weight: Font.DemiBold
                        renderType: Text.NativeRendering
                    }

                    Rectangle {
                        anchors.bottom: parent.bottom
                        width: parent.width
                        height: 1
                        color: Qt.rgba(255, 255, 255, 0.15)
                    }

                    MouseArea {
                        id: topicMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            root.activeArticle = modelData;
                        }
                    }
                }
            }
        }

        // =====================================================================
        // 3. VIEW: REAL-TIME SEARCH RESULTS
        // =====================================================================
        Item {
            id: searchResultsView
            width: parent.width
            height: parent.height
            readonly property bool isCurrent: root.searchActive && root.searchQuery.trim().length > 0 && root.activeArticle === null
            x: isCurrent ? 0 : (root.activeArticle !== null ? -contentViewport.width * 0.35 : contentViewport.width)
            opacity: isCurrent ? 1.0 : 0.0
            visible: opacity > 0.001
            enabled: opacity > 0.9

            Behavior on x { NumberAnimation { duration: 340; easing.type: Easing.OutCubic } }
            Behavior on opacity { NumberAnimation { duration: 260; easing.type: Easing.InOutQuad } }

            // Empty state when search yields no matches
            Text {
                anchors.centerIn: parent
                text: "No manual topics found matching \"" + root.searchQuery + "\""
                font.family: "Inter"
                font.pixelSize: 20
                color: Qt.rgba(255, 255, 255, 0.60)
                visible: root.searchResults.length === 0
            }

            // Left Vertical Dragger Track for Search Results List
            Item {
                id: searchDraggerTrack
                anchors.left: parent.left
                anchors.leftMargin: 6
                anchors.top: parent.top
                anchors.topMargin: 12
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 16
                width: 16
                z: 20
                visible: root.searchResults.length > 5

                Rectangle {
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    width: 3
                    radius: 1.5
                    color: Qt.rgba(255, 255, 255, 0.16)
                }

                Rectangle {
                    id: searchDraggerThumb
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: 6
                    radius: 3
                    color: searchDraggerMouse.pressed ? "#FFFFFF" :
                           (searchDraggerMouse.containsMouse ? Qt.rgba(255, 255, 255, 0.95) : Qt.rgba(255, 255, 255, 0.75))
                    border.color: Qt.rgba(255, 255, 255, 0.50)
                    border.width: 1

                    readonly property real visibleRatio: Math.min(1.0, searchResultsList.height / Math.max(1, searchResultsList.contentHeight))
                    height: Math.max(54, searchDraggerTrack.height * visibleRatio)

                    readonly property real maxContentY: Math.max(1, searchResultsList.contentHeight - searchResultsList.height)
                    readonly property real maxThumbY: Math.max(1, searchDraggerTrack.height - height)
                    y: Math.min(maxThumbY, Math.max(0, (searchResultsList.contentY / maxContentY) * maxThumbY))

                    Behavior on color { ColorAnimation { duration: 120 } }

                    MouseArea {
                        id: searchDraggerMouse
                        anchors.fill: parent
                        anchors.margins: -16
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        drag.target: searchDraggerThumb
                        drag.axis: Drag.YAxis
                        drag.minimumY: 0
                        drag.maximumY: searchDraggerTrack.height - searchDraggerThumb.height

                        onPositionChanged: {
                            if (drag.active) {
                                var ratio = searchDraggerThumb.y / Math.max(1, searchDraggerTrack.height - searchDraggerThumb.height);
                                searchResultsList.contentY = ratio * (searchResultsList.contentHeight - searchResultsList.height);
                            }
                        }
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    z: -1
                    cursorShape: Qt.PointingHandCursor
                    onClicked: function(mouse) {
                        var targetThumbY = mouse.y - searchDraggerThumb.height / 2;
                        var maxThumbY = searchDraggerTrack.height - searchDraggerThumb.height;
                        var clampedY = Math.max(0, Math.min(maxThumbY, targetThumbY));
                        var ratio = clampedY / Math.max(1, maxThumbY);
                        searchResultsList.contentY = ratio * (searchResultsList.contentHeight - searchResultsList.height);
                    }
                }
            }

            ListView {
                id: searchResultsList
                anchors.left: searchDraggerTrack.visible ? searchDraggerTrack.right : parent.left
                anchors.leftMargin: searchDraggerTrack.visible ? 8 : 28
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                clip: true
                boundsBehavior: Flickable.StopAtBounds
                visible: root.searchResults.length > 0
                model: root.searchResults

                delegate: Item {
                    width: ListView.view.width
                    height: 80

                    Rectangle {
                        anchors.fill: parent
                        color: resMouse.containsMouse ? Qt.rgba(255, 255, 255, 0.06) : "transparent"
                        radius: 10
                    }

                    Column {
                        anchors.left: parent.left
                        anchors.leftMargin: 12
                        anchors.right: resChevron.left
                        anchors.rightMargin: 16
                        anchors.verticalCenter: parent.verticalCenter
                        spacing: 4

                        Text {
                            text: modelData.title
                            color: "#FFFFFF"
                            font.family: "Inter"
                            font.pixelSize: 20
                            font.weight: Font.DemiBold
                            renderType: Text.NativeRendering
                            elide: Text.ElideRight
                            width: parent.width
                        }

                        Text {
                            text: modelData.category + "  •  " + modelData.readTime + "  •  " + modelData.summary
                            color: Qt.rgba(255, 255, 255, 0.70)
                            font.family: "Inter"
                            font.pixelSize: 14
                            font.weight: Font.Normal
                            renderType: Text.NativeRendering
                            elide: Text.ElideRight
                            width: parent.width
                        }
                    }

                    Text {
                        id: resChevron
                        anchors.right: parent.right
                        anchors.rightMargin: 16
                        anchors.verticalCenter: parent.verticalCenter
                        text: "›"
                        color: "#FFFFFF"
                        font.family: "Inter"
                        font.pixelSize: 28
                        font.weight: Font.DemiBold
                        renderType: Text.NativeRendering
                    }

                    Rectangle {
                        anchors.bottom: parent.bottom
                        width: parent.width
                        height: 1
                        color: Qt.rgba(255, 255, 255, 0.15)
                    }

                    MouseArea {
                        id: resMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            root.activeCategory = modelData.category;
                            root.activeArticle = modelData;
                            root.showTouchKeyboard = false;
                        }
                    }
                }
            }
        }

    // 4. VIEW C: ARTICLE DETAIL READER VIEW
    // =========================================================================
        // =====================================================================
        // 4. VIEW C: ARTICLE DETAIL READER VIEW
        // =====================================================================
        Item {
            id: articleView
            width: parent.width
            height: parent.height
            readonly property bool isCurrent: root.activeArticle !== null
            x: isCurrent ? 0 : contentViewport.width
            opacity: isCurrent ? 1.0 : 0.0
            visible: opacity > 0.001
            enabled: opacity > 0.9

            Behavior on x { NumberAnimation { duration: 340; easing.type: Easing.OutCubic } }
            Behavior on opacity { NumberAnimation { duration: 260; easing.type: Easing.InOutQuad } }

        Flickable {
            anchors.left: parent.left
            anchors.leftMargin: 28
            anchors.right: parent.right
            anchors.rightMargin: 16
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            contentWidth: width
            contentHeight: articleCol.height + 60
            clip: true
            boundsBehavior: Flickable.StopAtBounds

            Column {
                id: articleCol
                width: parent.width
                spacing: 20

                // Top Article Header Row
                Row {
                    width: parent.width
                    spacing: 16

                    Column {
                        width: parent.width - 160
                        spacing: 6

                        Text {
                            text: root.activeArticle ? root.activeArticle.title : ""
                            color: "#FFFFFF"
                            font.family: "Inter"
                            font.pixelSize: 28
                            font.weight: Font.Bold
                            wrapMode: Text.WordWrap
                            width: parent.width
                        }

                        Text {
                            text: root.activeArticle ? (root.activeCategory + "  •  " + root.activeArticle.readTime) : ""
                            color: "#E2A968"
                            font.family: "Inter"
                            font.pixelSize: 15
                            font.weight: Font.Medium
                        }
                    }

                    // Bookmark Toggle Button
                    Rectangle {
                        width: 140
                        height: 42
                        radius: 21
                        color: bmToggleMouse.containsMouse ? Qt.rgba(255, 255, 255, 0.16) : Qt.rgba(255, 255, 255, 0.08)
                        border.color: Qt.rgba(255, 255, 255, 0.25)
                        border.width: 1
                        anchors.verticalCenter: parent.verticalCenter

                        readonly property bool isBookmarked: {
                            if (!root.activeArticle) return false;
                            for (var i = 0; i < root.bookmarks.length; ++i) {
                                if (root.bookmarks[i].title === root.activeArticle.title) return true;
                            }
                            return false;
                        }

                        Row {
                            anchors.centerIn: parent
                            spacing: 8
                            Text {
                                text: parent.parent.isBookmarked ? "★" : "☆"
                                color: parent.parent.isBookmarked ? "#E2A968" : "#FFFFFF"
                                font.pixelSize: 18
                            }
                            Text {
                                text: parent.parent.isBookmarked ? "Bookmarked" : "Bookmark"
                                color: "#FFFFFF"
                                font.family: "Inter"
                                font.pixelSize: 14
                                font.weight: Font.DemiBold
                            }
                        }

                        MouseArea {
                            id: bmToggleMouse
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                if (!root.activeArticle) return;
                                var list = root.bookmarks.slice();
                                var found = -1;
                                for (var i = 0; i < list.length; ++i) {
                                    if (list[i].title === root.activeArticle.title) {
                                        found = i;
                                        break;
                                    }
                                }
                                if (found >= 0) {
                                    list.splice(found, 1);
                                } else {
                                    list.push({
                                        category: root.activeCategory,
                                        title: root.activeArticle.title,
                                        readTime: root.activeArticle.readTime,
                                        summary: root.activeArticle.summary
                                    });
                                }
                                root.bookmarks = list;
                            }
                        }
                    }
                }

                // Summary Callout Box
                Rectangle {
                    width: parent.width
                    height: summaryText.implicitHeight + 28
                    radius: 12
                    color: Qt.rgba(0, 122, 255, 0.12)
                    border.color: Qt.rgba(0, 210, 255, 0.35)
                    border.width: 1

                    Text {
                        id: summaryText
                        anchors.fill: parent
                        anchors.margins: 14
                        text: root.activeArticle ? root.activeArticle.summary : ""
                        color: "#E2E8F0"
                        font.family: "Inter"
                        font.pixelSize: 17
                        lineHeight: 1.35
                        wrapMode: Text.WordWrap
                    }
                }

                // Procedural Step-by-Step Instructions
                Text {
                    text: "Operating Instructions & Procedure"
                    color: "#FFFFFF"
                    font.family: "Inter"
                    font.pixelSize: 20
                    font.weight: Font.DemiBold
                    topPadding: 8
                }

                Column {
                    width: parent.width
                    spacing: 12

                    Repeater {
                        model: root.activeArticle ? root.activeArticle.steps : []

                        Item {
                            width: articleCol.width
                            height: stepRow.implicitHeight

                            Row {
                                id: stepRow
                                width: parent.width
                                spacing: 14

                                Rectangle {
                                    width: 26
                                    height: 26
                                    radius: 13
                                    color: "#1E88E5"
                                    anchors.top: parent.top
                                    anchors.topMargin: 2

                                    Text {
                                        anchors.centerIn: parent
                                        text: (index + 1).toString()
                                        color: "#FFFFFF"
                                        font.family: "Inter"
                                        font.pixelSize: 13
                                        font.weight: Font.Bold
                                    }
                                }

                                Text {
                                    text: modelData
                                    color: "#FFFFFF"
                                    font.family: "Inter"
                                    font.pixelSize: 17
                                    lineHeight: 1.35
                                    wrapMode: Text.WordWrap
                                    width: parent.width - 44
                                }
                            }
                        }
                    }
                }

                // Safety Note Box
                Rectangle {
                    width: parent.width
                    height: noteText.implicitHeight + 24
                    radius: 10
                    color: Qt.rgba(255, 179, 0, 0.12)
                    border.color: Qt.rgba(255, 179, 0, 0.40)
                    border.width: 1
                    visible: root.activeArticle && root.activeArticle.note

                    Row {
                        anchors.fill: parent
                        anchors.margins: 12
                        spacing: 12

                        Text {
                            text: "⚠️"
                            font.pixelSize: 18
                            anchors.top: parent.top
                        }

                        Text {
                            id: noteText
                            text: root.activeArticle ? ("NOTE: " + root.activeArticle.note) : ""
                            color: "#FFD54F"
                            font.family: "Inter"
                            font.pixelSize: 15
                            lineHeight: 1.3
                            wrapMode: Text.WordWrap
                            width: parent.width - 34
                        }
                    }
                }
            }
        }
    }

    // =========================================================================

    // 5. VIEW D: VISUAL SEARCH (2 Main Views with Horizontal Slide Transition)
    // =========================================================================
        // =====================================================================
        // 5. VIEW D: VISUAL SEARCH (2 Main Views with Horizontal Slide Transition)
        // =====================================================================
        Item {
            id: visualSearchView
            width: parent.width
            height: parent.height
            readonly property bool isCurrent: root.currentTab === "visual" && root.activeArticle === null && (!root.searchActive || root.searchQuery.trim().length === 0)
            x: isCurrent ? 0 : (root.activeArticle !== null ? -contentViewport.width * 0.35 :
               (root.currentTabIndex < 1 ? contentViewport.width : -contentViewport.width * 0.35))
            opacity: isCurrent ? 1.0 : 0.0
            visible: opacity > 0.001
            enabled: opacity > 0.9
            z: 10

            Behavior on x { NumberAnimation { duration: 340; easing.type: Easing.OutCubic } }
            Behavior on opacity { NumberAnimation { duration: 260; easing.type: Easing.InOutQuad } }

        // Main Horizontal Slide Container (Interior 1 of 2 & Exterior 2 of 2)
        SwipeView {
            id: visualSwipeView
            anchors.top: parent.top
            anchors.bottom: paginationBar.top
            anchors.bottomMargin: 8
            anchors.left: parent.left
            anchors.right: parent.right
            currentIndex: root.visualPageIndex
            onCurrentIndexChanged: root.visualPageIndex = currentIndex
            clip: true

            // -----------------------------------------------------------------
            // PAGE 1 OF 2: LUXURY COCKPIT INTERIOR VISUAL SEARCH (Matching User Photo 1)
            // -----------------------------------------------------------------
            Item {
                id: interiorPage

                // High-resolution Generated Technical Interior Illustration
                Rectangle {
                    anchors.fill: parent
                    radius: 16
                    color: Qt.rgba(15/255, 23/255, 42/255, 0.40)
                    border.color: Qt.rgba(255, 255, 255, 0.12)
                    border.width: 1
                    clip: true

                    Image {
                        id: interiorImg
                        anchors.fill: parent
                        source: "qrc:/ApexVision/qml/assets/icons/image copy 10.png"
                        fillMode: Image.PreserveAspectFit
                        smooth: true
                        mipmap: true
                    }

                    // Precise Render Bounds that match the actual painted image (accounts for aspect fit letterboxing)
                    Item {
                        id: interiorImgBounds
                        width: interiorImg.paintedWidth
                        height: interiorImg.paintedHeight
                        anchors.centerIn: parent

                        // Interactive Hotspot Pins (White Circular Touch Badges)
                        Repeater {
                            model: root.visualHotspotsInterior

                            Item {
                                width: Math.max(52, interiorImgBounds.width * 0.052)
                                height: width
                                x: Math.round(modelData.x * interiorImgBounds.width - width / 2)
                                y: Math.round(modelData.y * interiorImgBounds.height - height / 2)
                                z: hotspotMouse.containsMouse ? 100 : 10

                                // Outer Beacon Ring
                                Rectangle {
                                    anchors.centerIn: parent
                                    width: hotspotMouse.containsMouse ? parent.width + 12 : parent.width
                                    height: width
                                    radius: width / 2
                                    color: hotspotMouse.pressed ? Qt.rgba(56/255, 189/255, 248/255, 0.35) :
                                           (hotspotMouse.containsMouse ? Qt.rgba(56/255, 189/255, 248/255, 0.18) : "transparent")
                                    border.color: hotspotMouse.containsMouse ? "#38BDF8" : Qt.rgba(56/255, 189/255, 248/255, 0.35)
                                    border.width: hotspotMouse.containsMouse ? 2 : 1
                                    Behavior on width { NumberAnimation { duration: 160 } }
                                }

                                // Interactive Touch Callout Overlay
                                Rectangle {
                                    anchors.centerIn: parent
                                    width: parent.width - 4
                                    height: width
                                    radius: width / 2
                                    color: hotspotMouse.pressed ? Qt.rgba(56/255, 189/255, 248/255, 0.40) :
                                           (hotspotMouse.containsMouse ? Qt.rgba(56/255, 189/255, 248/255, 0.22) : "transparent")
                                    border.color: hotspotMouse.containsMouse ? "#38BDF8" : "transparent"
                                    border.width: 2
                                    scale: hotspotMouse.pressed ? 0.92 : (hotspotMouse.containsMouse ? 1.08 : 1.0)
                                    Behavior on scale { NumberAnimation { duration: 120 } }
                                }

                                // Hover Tooltip Callout Tag (Adaptive placement to prevent edge clipping)
                                Rectangle {
                                    anchors.horizontalCenter: parent.horizontalCenter
                                    y: modelData.y < 0.25 ? parent.height + 8 : -height - 8
                                    width: tipCol.implicitWidth + 24
                                    height: tipCol.implicitHeight + 14
                                    radius: 10
                                    color: Qt.rgba(10/255, 15/255, 28/255, 0.95)
                                    border.color: "#38BDF8"
                                    border.width: 1.2
                                    visible: hotspotMouse.containsMouse
                                    opacity: visible ? 1.0 : 0.0
                                    Behavior on opacity { NumberAnimation { duration: 150 } }

                                    Column {
                                        id: tipCol
                                        anchors.centerIn: parent
                                        spacing: 2

                                        Text {
                                            anchors.horizontalCenter: parent.horizontalCenter
                                            text: modelData.name
                                            color: "#FFFFFF"
                                            font.family: "Inter"
                                            font.pixelSize: 13
                                            font.weight: Font.DemiBold
                                        }
                                        Text {
                                            anchors.horizontalCenter: parent.horizontalCenter
                                            text: "Tap to view guide"
                                            color: "#38BDF8"
                                            font.family: "Inter"
                                            font.pixelSize: 11
                                        }
                                    }
                                }

                                MouseArea {
                                    id: hotspotMouse
                                    anchors.fill: parent
                                    hoverEnabled: true
                                    cursorShape: Qt.PointingHandCursor
                                    onClicked: {
                                        for (var c = 0; c < root.manualCategories.length; ++c) {
                                            if (root.manualCategories[c].title === modelData.category) {
                                                var tops = root.manualCategories[c].topics;
                                                for (var t = 0; t < tops.length; ++t) {
                                                    if (tops[t].title === modelData.topic) {
                                                        root.activeCategory = modelData.category;
                                                        root.activeArticle = tops[t];
                                                        return;
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
            }

            // -----------------------------------------------------------------
            // PAGE 2 OF 2: EXTERIOR SUV VISUAL SEARCH (Matching User Photo 2)
            // -----------------------------------------------------------------
            Item {
                id: exteriorPage

                // High-resolution Generated Technical Exterior Illustration
                Rectangle {
                    anchors.fill: parent
                    radius: 16
                    color: Qt.rgba(15/255, 23/255, 42/255, 0.40)
                    border.color: Qt.rgba(255, 255, 255, 0.12)
                    border.width: 1
                    clip: true

                    Image {
                        id: exteriorImg
                        anchors.fill: parent
                        source: "qrc:/ApexVision/qml/assets/icons/image copy 9.png"
                        fillMode: Image.PreserveAspectFit
                        smooth: true
                        mipmap: true
                    }

                    // Precise Render Bounds that match the actual painted image (accounts for aspect fit letterboxing)
                    Item {
                        id: exteriorImgBounds
                        width: exteriorImg.paintedWidth
                        height: exteriorImg.paintedHeight
                        anchors.centerIn: parent

                        // Interactive Hotspot Pins (Exterior Architecture Badges)
                        Repeater {
                            model: root.visualHotspotsExterior

                            Item {
                                width: Math.max(48, exteriorImgBounds.width * 0.048)
                                height: width
                                x: Math.round(modelData.x * exteriorImgBounds.width - width / 2)
                                y: Math.round(modelData.y * exteriorImgBounds.height - height / 2)
                                z: extHotspotMouse.containsMouse ? 100 : 10

                                // Outer Beacon Ring
                                Rectangle {
                                    anchors.centerIn: parent
                                    width: extHotspotMouse.containsMouse ? parent.width + 12 : parent.width
                                    height: width
                                    radius: width / 2
                                    color: extHotspotMouse.pressed ? Qt.rgba(56/255, 189/255, 248/255, 0.35) :
                                           (extHotspotMouse.containsMouse ? Qt.rgba(56/255, 189/255, 248/255, 0.18) : "transparent")
                                    border.color: extHotspotMouse.containsMouse ? "#38BDF8" : Qt.rgba(56/255, 189/255, 248/255, 0.35)
                                    border.width: extHotspotMouse.containsMouse ? 2 : 1
                                    Behavior on width { NumberAnimation { duration: 160 } }
                                }

                                // Interactive Touch Callout Overlay
                                Rectangle {
                                    anchors.centerIn: parent
                                    width: parent.width - 4
                                    height: width
                                    radius: width / 2
                                    color: extHotspotMouse.pressed ? Qt.rgba(56/255, 189/255, 248/255, 0.40) :
                                           (extHotspotMouse.containsMouse ? Qt.rgba(56/255, 189/255, 248/255, 0.22) : "transparent")
                                    border.color: extHotspotMouse.containsMouse ? "#38BDF8" : "transparent"
                                    border.width: 2
                                    scale: extHotspotMouse.pressed ? 0.92 : (extHotspotMouse.containsMouse ? 1.08 : 1.0)
                                    Behavior on scale { NumberAnimation { duration: 120 } }
                                }

                                // Hover Tooltip Callout Tag (Adaptive placement to prevent edge clipping)
                                Rectangle {
                                    anchors.horizontalCenter: parent.horizontalCenter
                                    y: modelData.y < 0.20 ? parent.height + 8 : -height - 8
                                    width: extTipCol.implicitWidth + 24
                                    height: extTipCol.implicitHeight + 14
                                    radius: 10
                                    color: Qt.rgba(10/255, 15/255, 28/255, 0.95)
                                    border.color: "#38BDF8"
                                    border.width: 1.2
                                    visible: extHotspotMouse.containsMouse
                                    opacity: visible ? 1.0 : 0.0
                                    Behavior on opacity { NumberAnimation { duration: 150 } }

                                    Column {
                                        id: extTipCol
                                        anchors.centerIn: parent
                                        spacing: 2

                                        Text {
                                            anchors.horizontalCenter: parent.horizontalCenter
                                            text: modelData.name
                                            color: "#FFFFFF"
                                            font.family: "Inter"
                                            font.pixelSize: 13
                                            font.weight: Font.DemiBold
                                        }
                                        Text {
                                            anchors.horizontalCenter: parent.horizontalCenter
                                            text: "Tap to view guide"
                                            color: "#38BDF8"
                                            font.family: "Inter"
                                            font.pixelSize: 11
                                        }
                                    }
                                }

                                MouseArea {
                                    id: extHotspotMouse
                                    anchors.fill: parent
                                    hoverEnabled: true
                                    cursorShape: Qt.PointingHandCursor
                                    onClicked: {
                                        for (var c = 0; c < root.manualCategories.length; ++c) {
                                            if (root.manualCategories[c].title === modelData.category) {
                                                var tops = root.manualCategories[c].topics;
                                                for (var t = 0; t < tops.length; ++t) {
                                                    if (tops[t].title === modelData.topic) {
                                                        root.activeCategory = modelData.category;
                                                        root.activeArticle = tops[t];
                                                        return;
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
            }
        }

        // ---------------------------------------------------------------------
        // BOTTOM PAGINATION: "1 of 2" / "2 of 2" (Matching User Request & Photos)
        // ---------------------------------------------------------------------
        Rectangle {
            id: paginationBar
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 10
            anchors.horizontalCenter: parent.horizontalCenter
            width: 180
            height: 44
            radius: 22
            color: Qt.rgba(15/255, 23/255, 42/255, 0.85)
            border.color: Qt.rgba(255, 255, 255, 0.22)
            border.width: 1.2
            z: 25

            // Left Navigation Arrow Button
            Rectangle {
                anchors.left: parent.left
                anchors.leftMargin: 5
                anchors.verticalCenter: parent.verticalCenter
                width: 34
                height: 34
                radius: 17
                color: prevPageMouse.pressed ? Qt.rgba(255, 255, 255, 0.28) :
                       (prevPageMouse.containsMouse ? Qt.rgba(255, 255, 255, 0.18) : "transparent")
                visible: visualSwipeView.currentIndex > 0

                Text {
                    anchors.centerIn: parent
                    text: "‹"
                    font.family: "Inter"
                    font.pixelSize: 26
                    font.weight: Font.DemiBold
                    color: "#FFFFFF"
                }

                MouseArea {
                    id: prevPageMouse
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: visualSwipeView.decrement()
                }
            }

            // Centered Indicator: "1 of 2" (Interior) or "2 of 2" (Exterior)
            Text {
                anchors.centerIn: parent
                text: (visualSwipeView.currentIndex + 1) + " of 2"
                font.family: "Inter"
                font.pixelSize: 18
                font.weight: Font.Bold
                color: "#FFFFFF"
            }

            // Right Navigation Arrow Button
            Rectangle {
                anchors.right: parent.right
                anchors.rightMargin: 5
                anchors.verticalCenter: parent.verticalCenter
                width: 34
                height: 34
                radius: 17
                color: nextPageMouse.pressed ? Qt.rgba(255, 255, 255, 0.28) :
                       (nextPageMouse.containsMouse ? Qt.rgba(255, 255, 255, 0.18) : "transparent")
                visible: visualSwipeView.currentIndex < 1

                Text {
                    anchors.centerIn: parent
                    text: "›"
                    font.family: "Inter"
                    font.pixelSize: 26
                    font.weight: Font.DemiBold
                    color: "#FFFFFF"
                }

                MouseArea {
                    id: nextPageMouse
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: visualSwipeView.increment()
                }
            }
        }
    }

    // =========================================================================

        // =====================================================================
        // 6. VIEW E: BOOKMARKS LIST (With "Content not found" Empty State)
        // =====================================================================
        Item {
            id: bookmarksView
            width: parent.width
            height: parent.height
            readonly property bool isCurrent: root.currentTab === "bookmarks" && root.activeArticle === null && (!root.searchActive || root.searchQuery.trim().length === 0)
            x: isCurrent ? 0 : (root.activeArticle !== null ? -contentViewport.width * 0.35 : contentViewport.width)
            opacity: isCurrent ? 1.0 : 0.0
            visible: opacity > 0.001
            enabled: opacity > 0.9
            z: 10

            Behavior on x { NumberAnimation { duration: 340; easing.type: Easing.OutCubic } }
            Behavior on opacity { NumberAnimation { duration: 260; easing.type: Easing.InOutQuad } }

            // Empty State: "Content not found" (Matches User Photo 3 Exactly)
            Text {
                anchors.centerIn: parent
                text: "Content not found"
                font.family: "Inter"
                font.pixelSize: 24
                font.weight: Font.Normal
                color: Qt.rgba(255, 255, 255, 0.72)
                visible: root.bookmarks.length === 0
            }

            // Active Bookmarks List
            // Left Vertical Dragger Track for Bookmarks List
            Item {
                id: bmDraggerTrack
                anchors.left: parent.left
                anchors.leftMargin: 6
                anchors.top: parent.top
                anchors.topMargin: 12
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 16
                width: 16
                z: 20
                visible: root.bookmarks.length > 5

                Rectangle {
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    width: 3
                    radius: 1.5
                    color: Qt.rgba(255, 255, 255, 0.16)
                }

                Rectangle {
                    id: bmDraggerThumb
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: 6
                    radius: 3
                    color: bmDraggerMouse.pressed ? "#FFFFFF" :
                           (bmDraggerMouse.containsMouse ? Qt.rgba(255, 255, 255, 0.95) : Qt.rgba(255, 255, 255, 0.75))
                    border.color: Qt.rgba(255, 255, 255, 0.50)
                    border.width: 1

                    readonly property real visibleRatio: Math.min(1.0, bookmarksListView.height / Math.max(1, bookmarksListView.contentHeight))
                    height: Math.max(54, bmDraggerTrack.height * visibleRatio)

                    readonly property real maxContentY: Math.max(1, bookmarksListView.contentHeight - bookmarksListView.height)
                    readonly property real maxThumbY: Math.max(1, bmDraggerTrack.height - height)
                    y: Math.min(maxThumbY, Math.max(0, (bookmarksListView.contentY / maxContentY) * maxThumbY))

                    Behavior on color { ColorAnimation { duration: 120 } }

                    MouseArea {
                        id: bmDraggerMouse
                        anchors.fill: parent
                        anchors.margins: -16
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        drag.target: bmDraggerThumb
                        drag.axis: Drag.YAxis
                        drag.minimumY: 0
                        drag.maximumY: bmDraggerTrack.height - bmDraggerThumb.height

                        onPositionChanged: {
                            if (drag.active) {
                                var ratio = bmDraggerThumb.y / Math.max(1, bmDraggerTrack.height - bmDraggerThumb.height);
                                bookmarksListView.contentY = ratio * (bookmarksListView.contentHeight - bookmarksListView.height);
                            }
                        }
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    z: -1
                    cursorShape: Qt.PointingHandCursor
                    onClicked: function(mouse) {
                        var targetThumbY = mouse.y - bmDraggerThumb.height / 2;
                        var maxThumbY = bmDraggerTrack.height - bmDraggerThumb.height;
                        var clampedY = Math.max(0, Math.min(maxThumbY, targetThumbY));
                        var ratio = clampedY / Math.max(1, maxThumbY);
                        bookmarksListView.contentY = ratio * (bookmarksListView.contentHeight - bookmarksListView.height);
                    }
                }
            }

            ListView {
                id: bookmarksListView
                anchors.left: bmDraggerTrack.visible ? bmDraggerTrack.right : parent.left
                anchors.leftMargin: bmDraggerTrack.visible ? 8 : 28
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                clip: true
                boundsBehavior: Flickable.StopAtBounds
                visible: root.bookmarks.length > 0
                model: root.bookmarks

                delegate: Item {
                    width: ListView.view.width
                    height: 80

                    Rectangle {
                        anchors.fill: parent
                        color: bmRowMouse.containsMouse ? Qt.rgba(255, 255, 255, 0.06) : "transparent"
                        radius: 10
                    }

                    Row {
                        anchors.fill: parent
                        anchors.leftMargin: 12
                        anchors.rightMargin: 16
                        spacing: 16

                        Text {
                            text: "★"
                            color: "#E2A968"
                            font.pixelSize: 22
                            anchors.verticalCenter: parent.verticalCenter
                        }

                        Column {
                            anchors.verticalCenter: parent.verticalCenter
                            width: parent.width - 90
                            spacing: 4

                            Text {
                                text: modelData.title
                                color: "#FFFFFF"
                                font.family: "Inter"
                                font.pixelSize: 19
                                font.weight: Font.DemiBold
                            }

                            Text {
                                text: modelData.category + "  •  " + modelData.readTime
                                color: Qt.rgba(255, 255, 255, 0.55)
                                font.family: "Inter"
                                font.pixelSize: 14
                            }
                        }

                        Text {
                            text: "›"
                            color: Qt.rgba(255, 255, 255, 0.65)
                            font.pixelSize: 28
                            anchors.verticalCenter: parent.verticalCenter
                        }
                    }

                    Rectangle {
                        anchors.bottom: parent.bottom
                        width: parent.width
                        height: 1
                        color: Qt.rgba(255, 255, 255, 0.08)
                    }

                    MouseArea {
                        id: bmRowMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            for (var c = 0; c < root.manualCategories.length; ++c) {
                                if (root.manualCategories[c].title === modelData.category) {
                                    var tops = root.manualCategories[c].topics;
                                    for (var t = 0; t < tops.length; ++t) {
                                        if (tops[t].title === modelData.title) {
                                            root.activeCategory = modelData.category;
                                            root.activeArticle = tops[t];
                                            return;
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
    // 7. TOUCH SCREEN KEYBOARD DOCKED AT BOTTOM (Touchscreen Keypad)
    // =========================================================================
    Rectangle {
        id: touchKeyboard
        anchors.left: parent.left
        anchors.right: parent.right
        height: 270
        z: 60

        // Smooth slide-up transition from bottom
        y: (root.searchActive && root.showTouchKeyboard) ? (parent.height - height) : parent.height
        visible: opacity > 0.01 || y < parent.height
        opacity: (root.searchActive && root.showTouchKeyboard) ? 1.0 : 0.0

        Behavior on y {
            NumberAnimation { duration: 300; easing.type: Easing.OutCubic }
        }
        Behavior on opacity {
            NumberAnimation { duration: 220 }
        }

        // Frosted Cockpit Glass Background
        gradient: Gradient {
            GradientStop { position: 0.0; color: Qt.rgba(15/255, 23/255, 42/255, 0.96) }
            GradientStop { position: 1.0; color: Qt.rgba(7/255, 11/255, 20/255, 0.98) }
        }

        // Top highlight line
        Rectangle {
            anchors.top: parent.top
            width: parent.width
            height: 1
            color: Qt.rgba(255, 255, 255, 0.20)
        }

        Column {
            anchors.fill: parent
            anchors.margins: 8
            spacing: 6

            // Top Quick Topic Suggestions Strip + Dismiss Chevron
            Row {
                width: parent.width
                height: 34
                spacing: 8

                Flickable {
                    width: parent.width - 48
                    height: parent.height
                    contentWidth: chipsRow.width
                    clip: true
                    boundsBehavior: Flickable.StopAtBounds

                    Row {
                        id: chipsRow
                        spacing: 8
                        Repeater {
                            model: root.searchChips
                            Rectangle {
                                height: 30
                                width: _chipTxt.implicitWidth + 24
                                radius: 15
                                color: _chipMa.pressed ? Qt.rgba(255, 255, 255, 0.25) :
                                       (_chipMa.containsMouse ? Qt.rgba(255, 255, 255, 0.16) : Qt.rgba(255, 255, 255, 0.08))
                                border.color: Qt.rgba(255, 255, 255, 0.18)
                                border.width: 1

                                Text {
                                    id: _chipTxt
                                    anchors.centerIn: parent
                                    text: modelData
                                    color: "#FFFFFF"
                                    font.family: "Inter"
                                    font.pixelSize: 13
                                    font.weight: Font.Medium
                                }

                                MouseArea {
                                    id: _chipMa
                                    anchors.fill: parent
                                    cursorShape: Qt.PointingHandCursor
                                    onClicked: {
                                        searchField.text = modelData;
                                        root.searchQuery = modelData;
                                    }
                                }
                            }
                        }
                    }
                }

                // Dismiss keyboard button
                Rectangle {
                    width: 38
                    height: 30
                    radius: 8
                    color: _dismissMa.pressed ? Qt.rgba(255, 255, 255, 0.25) :
                           (_dismissMa.containsMouse ? Qt.rgba(255, 255, 255, 0.16) : Qt.rgba(255, 255, 255, 0.08))
                    border.color: Qt.rgba(255, 255, 255, 0.18)
                    border.width: 1

                    Image {
                        anchors.centerIn: parent
                        source: "qrc:/ApexVision/qml/assets/icons/yt_chevron_down.svg"
                        width: 14
                        height: 14
                    }

                    MouseArea {
                        id: _dismissMa
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: root.showTouchKeyboard = false
                    }
                }
            }

            // Row 0: Number keys 1 2 3 4 5 6 7 8 9 0
            Row {
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: 6
                Repeater {
                    model: ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0"]
                    Rectangle {
                        width: (touchKeyboard.width - 32 - 9 * 6) / 10
                        height: 38
                        radius: 8
                        color: _nMa.pressed ? Qt.rgba(255, 255, 255, 0.25) :
                               (_nMa.containsMouse ? Qt.rgba(255, 255, 255, 0.16) : Qt.rgba(255, 255, 255, 0.09))
                        border.color: Qt.rgba(255, 255, 255, 0.16)
                        border.width: 1

                        Text {
                            anchors.centerIn: parent
                            text: modelData
                            color: "#FFFFFF"
                            font.family: "Inter"
                            font.pixelSize: 17
                            font.weight: Font.DemiBold
                        }

                        MouseArea {
                            id: _nMa
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: root.appendSearchKey(modelData)
                        }
                    }
                }
            }

            // Row 1: Q W E R T Y U I O P
            Row {
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: 6
                Repeater {
                    model: ["Q", "W", "E", "R", "T", "Y", "U", "I", "O", "P"]
                    Rectangle {
                        width: (touchKeyboard.width - 32 - 9 * 6) / 10
                        height: 38
                        radius: 8
                        color: _qMa.pressed ? Qt.rgba(255, 255, 255, 0.25) :
                               (_qMa.containsMouse ? Qt.rgba(255, 255, 255, 0.16) : Qt.rgba(255, 255, 255, 0.09))
                        border.color: Qt.rgba(255, 255, 255, 0.16)
                        border.width: 1

                        Text {
                            anchors.centerIn: parent
                            text: root.isShiftActive ? modelData : modelData.toLowerCase()
                            color: "#FFFFFF"
                            font.family: "Inter"
                            font.pixelSize: 17
                            font.weight: Font.DemiBold
                        }

                        MouseArea {
                            id: _qMa
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: root.appendSearchKey(modelData)
                        }
                    }
                }
            }

            // Row 2: A S D F G H J K L
            Row {
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: 6
                Repeater {
                    model: ["A", "S", "D", "F", "G", "H", "J", "K", "L"]
                    Rectangle {
                        width: (touchKeyboard.width - 32 - 9 * 6) / 10
                        height: 38
                        radius: 8
                        color: _aMa.pressed ? Qt.rgba(255, 255, 255, 0.25) :
                               (_aMa.containsMouse ? Qt.rgba(255, 255, 255, 0.16) : Qt.rgba(255, 255, 255, 0.09))
                        border.color: Qt.rgba(255, 255, 255, 0.16)
                        border.width: 1

                        Text {
                            anchors.centerIn: parent
                            text: root.isShiftActive ? modelData : modelData.toLowerCase()
                            color: "#FFFFFF"
                            font.family: "Inter"
                            font.pixelSize: 17
                            font.weight: Font.DemiBold
                        }

                        MouseArea {
                            id: _aMa
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: root.appendSearchKey(modelData)
                        }
                    }
                }
            }

            // Row 3: Shift + Z X C V B N M + Backspace
            Row {
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: 6

                // Shift Key
                Rectangle {
                    width: ((touchKeyboard.width - 32 - 9 * 6) / 10) * 1.35
                    height: 38
                    radius: 8
                    color: root.isShiftActive ? Qt.rgba(255, 255, 255, 0.35) :
                           (_shiftMa.pressed ? Qt.rgba(255, 255, 255, 0.25) :
                           (_shiftMa.containsMouse ? Qt.rgba(255, 255, 255, 0.16) : Qt.rgba(255, 255, 255, 0.09)))
                    border.color: Qt.rgba(255, 255, 255, 0.20)
                    border.width: 1

                    Image {
                        anchors.centerIn: parent
                        source: "qrc:/ApexVision/qml/assets/icons/yt_shift.svg"
                        width: 18
                        height: 18
                    }

                    MouseArea {
                        id: _shiftMa
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: root.isShiftActive = !root.isShiftActive
                    }
                }

                Repeater {
                    model: ["Z", "X", "C", "V", "B", "N", "M"]
                    Rectangle {
                        width: (touchKeyboard.width - 32 - 9 * 6) / 10
                        height: 38
                        radius: 8
                        color: _zMa.pressed ? Qt.rgba(255, 255, 255, 0.25) :
                               (_zMa.containsMouse ? Qt.rgba(255, 255, 255, 0.16) : Qt.rgba(255, 255, 255, 0.09))
                        border.color: Qt.rgba(255, 255, 255, 0.16)
                        border.width: 1

                        Text {
                            anchors.centerIn: parent
                            text: root.isShiftActive ? modelData : modelData.toLowerCase()
                            color: "#FFFFFF"
                            font.family: "Inter"
                            font.pixelSize: 17
                            font.weight: Font.DemiBold
                        }

                        MouseArea {
                            id: _zMa
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: root.appendSearchKey(modelData)
                        }
                    }
                }

                // Backspace Key
                Rectangle {
                    width: ((touchKeyboard.width - 32 - 9 * 6) / 10) * 1.55
                    height: 38
                    radius: 8
                    color: _bkMa.pressed ? Qt.rgba(255, 255, 255, 0.25) :
                           (_bkMa.containsMouse ? Qt.rgba(255, 255, 255, 0.16) : Qt.rgba(255, 255, 255, 0.09))
                    border.color: Qt.rgba(255, 255, 255, 0.20)
                    border.width: 1

                    Image {
                        anchors.centerIn: parent
                        source: "qrc:/ApexVision/qml/assets/icons/yt_backspace.svg"
                        width: 20
                        height: 20
                    }

                    MouseArea {
                        id: _bkMa
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: root.backspaceSearchKey()
                    }
                }
            }

            // Row 4: Clear, Spacebar, Done
            Row {
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: 8

                // Clear
                Rectangle {
                    width: 80
                    height: 38
                    radius: 8
                    color: _clrMa.pressed ? Qt.rgba(255, 255, 255, 0.25) :
                           (_clrMa.containsMouse ? Qt.rgba(255, 255, 255, 0.16) : Qt.rgba(255, 255, 255, 0.09))
                    border.color: Qt.rgba(255, 255, 255, 0.16)
                    border.width: 1

                    Text {
                        anchors.centerIn: parent
                        text: "Clear"
                        color: "#FFFFFF"
                        font.family: "Inter"
                        font.pixelSize: 14
                        font.weight: Font.DemiBold
                    }

                    MouseArea {
                        id: _clrMa
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: root.clearSearchInput()
                    }
                }

                // Spacebar
                Rectangle {
                    width: touchKeyboard.width * 0.50
                    height: 38
                    radius: 8
                    color: _spMa.pressed ? Qt.rgba(255, 255, 255, 0.25) :
                           (_spMa.containsMouse ? Qt.rgba(255, 255, 255, 0.16) : Qt.rgba(255, 255, 255, 0.09))
                    border.color: Qt.rgba(255, 255, 255, 0.16)
                    border.width: 1

                    Text {
                        anchors.centerIn: parent
                        text: "Space"
                        color: Qt.rgba(255, 255, 255, 0.60)
                        font.family: "Inter"
                        font.pixelSize: 14
                    }

                    MouseArea {
                        id: _spMa
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: root.appendSearchKey(" ")
                    }
                }

                // Done / Hide Keypad
                Rectangle {
                    width: 90
                    height: 38
                    radius: 8
                    color: _doneMa.pressed ? "#2563EB" :
                           (_doneMa.containsMouse ? "#3B82F6" : Qt.rgba(37/255, 99/255, 235/255, 0.80))
                    border.color: "#60A5FA"
                    border.width: 1

                    Text {
                        anchors.centerIn: parent
                        text: "Done"
                        color: "#FFFFFF"
                        font.family: "Inter"
                        font.pixelSize: 14
                        font.weight: Font.DemiBold
                    }

                    MouseArea {
                        id: _doneMa
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: root.showTouchKeyboard = false
                    }
                }
            }
        }
    }
}
