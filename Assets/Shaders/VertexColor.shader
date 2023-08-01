Shader "Custom/VertexColor"
{
    Properties
    {
        
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" } // Opaque algorithm, doesn't support transparency

        Pass
        {
            CGPROGRAM
            #pragma vertex vert // Name of the vertex shader
            #pragma fragment frag // Name of the fragment shader

            #include "UnityCG.cginc" // File containing helpful Unity functions

            struct VertexInput  // Structure coming from CPU, per vertex
            {
                float4 vertex : POSITION;
                float4 color : COLOR;
            };

            struct VertexToFragment // Structure we return from vertex to fragment shaders
            {
                float4 vertex : SV_POSITION;
                float4 color : COLOR;
            };

            VertexToFragment vert(VertexInput input) // Vertex shader method
            {
                VertexToFragment output;
                output.vertex = UnityObjectToClipPos(input.vertex); // input.vertex is in local space, here we transform to clip space (almost screen space)
                output.color = input.color; // send vertex color directly to fragment shader
                return output;
            }

            fixed4 frag(VertexToFragment input) : SV_Target // Fragment shader method
            {
                return input.color; // Return color interpolated from vertex shader
            }
            ENDCG
        }
    }
}
