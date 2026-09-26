# APEX VISION IVI - 3D Vehicle Model Object Reference

This document catalogs the exact 3D objects, meshes, materials, and bounding box coordinates extracted directly from the 3D model asset pipeline (`qml/climate3d/CarModel/Scene.qml`).

---

## 1. Tire & Wheel Objects

| Object ID | Component | Wheel Location | Blender Center (X, Y, Z) | Mesh Dimensions (X, Y, Z) | Material |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **Object_21** | Tire FL | **Front Left** | `( +3.061, -6.057, +1.384 )` | `0.938 x 2.769 x 2.769` | `Meshesuntitled2wheelflowheeltire1Mtl` |
| **Object_9**  | Tire FR | **Front Right** | `( -3.060, -6.057, +1.384 )` | `0.938 x 2.769 x 2.769` | `Meshesuntitled1wheelfrowheeltire1Mtl` |
| **Object_29** | Tire RL | **Rear Left** | `( +3.061, +5.718, +1.385 )` | `0.938 x 2.769 x 2.769` | `Meshesuntitled3wheelblowheeltire1Mtl` |
| **Object_10** | Tire RR | **Rear Right** | `( -3.060, +5.719, +1.384 )` | `0.938 x 2.769 x 2.769` | `Meshesuntitled1wheelbrowheeltire1Mtl` |

### Rims / Wheel Center Caps
- **Object_38, Object_39, Object_47**: Wheel rims and chrome rim elements (`Meshesuntitled1bodyfrontgrillechorme0011Mtl`).

---

## 2. Glass & Roof Elements

| Object ID | Description | Notes |
| :--- | :--- | :--- |
| **Object_55** | Windshield & Window Glass | Glass material `Meshesuntitled1bodyglassglass1Mtl`. Tinted black for exterior privacy. |
| **Object_11** | Panoramic Glass Skylight | Skylight roof glass. Hidden in Top-Down Ambient Mode. |
| **Object_57, 63, 12, 73** | Roof Header & Rails | Removed/hidden in Top-Down Cabin Ambient lighting view. |
| **Object_46** | Upper Trim / Roof pillar element | Preserved in exterior view. |

---

## 3. Badges, Emblems & Tailgate

- **Apex_Emblem**: Center badge / emblem with emissive glow backing (`Apex_Emblem_Mtl`, `Apex_Backing_Mtl`).
- **Object_8**: Trunk lid plate and license plate mount.
- **Steering Wheel**: Custom modeled APEX badge mounted to center hub.
- **Rear Lightbar**: Integrated LED strip with chrome "V I S I O N" lettering.
- **Rear Badges**:
  - Left rear badge: "दृष्टि" (Hindi)
  - Right rear badge: "VISION"

---

## 4. Vehicle Coordinate System & Alignments in IVI

- **Front Axle Center**: Y = -6.057 (towards front bumper)
- **Rear Axle Center**: Y = +5.718 (towards rear bumper)
- **Track Width (Left-to-Right Wheel Distance)**: 6.121 units (`+/- 3.061`)
- **Wheelbase (Front-to-Rear Axle Distance)**: 11.775 units
- **Wheel Diameter**: 2.769 units (Radius ~ 1.385)
- **Tire Width**: 0.938 units
- **Wheel Rotation Symmetry**: Exact bilateral symmetry around X = 0.000.
