using UnityEngine;

/// <summary>
/// Generates a triangle and modifies the mesh of the <see cref="MeshFilter"/>
/// </summary>
[RequireComponent(typeof(MeshFilter)), ExecuteAlways]
public class TriangleMesh : MonoBehaviour
{
    private MeshFilter m_MeshFilter;
    private Mesh m_Mesh;
    
    private void Awake()
    {
        m_MeshFilter = GetComponent<MeshFilter>();
        m_MeshFilter.mesh = CreateMesh();
    }

    private Mesh CreateMesh()
    {
        var mesh = new Mesh(); // Create a new mesh

        mesh.vertices = new [] // Set points
        {
            new Vector3(-0.5f, -0.5f),
            new Vector3(0.5f, -0.5f),
            new Vector3(0.5f, 0.5f),
        };

        mesh.colors = new[] { Color.blue, Color.red, Color.yellow }; // Set colors for each point
        
        mesh.SetIndices(new [] {0, 2, 1}, MeshTopology.Triangles, 0); // Describe how triangles are constructed. Clockwise so it faces the camera.

        return mesh;
    }
}
