import QtQuick
import QtQuick3D

Node {
    id: node

    // Resources
    PrincipledMaterial {
        id: defaultMaterial_material
        objectName: "DefaultMaterial"
        baseColor: "#ff999999"
        indexOfRefraction: 1
    }

    // Nodes:
    Node {
        id: airflow_ground_driver_obj
        objectName: "airflow_ground_driver.obj"
        Model {
            id: airflow_ground_driver
            objectName: "airflow_ground_driver"
            source: "meshes/airflow_ground_driver_mesh.mesh"
            materials: [
                defaultMaterial_material
            ]
        }
    }

    // Animations:
}
