Shader "Custom/QuadToCircle2D"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Radius ("Radius", Float) = 0.1
    }
    
    SubShader
    {
        Tags { "RenderType"="Opaque" } // Opaque algorithm, doesn't support transparency
        
        Pass
        {
            CGPROGRAM
            #pragma vertex vert // Name of the vertex shader
            #pragma fragment frag // Name of the fragment shader

            #include "UnityCG.cginc"  // File containing helpful Unity functions

            struct VertexInput  // Structure coming from CPU, per vertex
            {
                float4 vertex : POSITION;
                float2 color : TEXCOORD0;
            };

            struct FragmentInput  // Structure we return from vertex to fragment shaders
            {
                float4 vertex : SV_POSITION;
                float2 uv : TEXCOORD0;
            };

            // Declare material properties
            sampler2D _MainTex; // Declare texture
            float4 _MainTex_ST; // Utils variable required by Unity to compute UVs on specific platforms

            float _Radius;

            FragmentInput vert(VertexInput input) // Vertex shader method
            {
                FragmentInput output;
                output.vertex = UnityObjectToClipPos(input.vertex); // input.vertex is in local space, here we transform to clip space (almost screen space) 
                output.uv = TRANSFORM_TEX(input.color, _MainTex); // Transforms texture coordinates. You can also use output.uv = input.uv; However, it's safer this way for multiple platforms
                return output;
            }

            fixed4 frag(FragmentInput input) : SV_Target // Fragment shader method
            {
                if (distance(float2(0.5, 0.5), input.uv) > _Radius)  // If distance from center of the object is smaller than the radius
                    discard; // We can discard fragments completely
                return tex2D(_MainTex, input.uv); // Sample pixel from texture based on fragment's UV
            }
            ENDCG
        }
    }
}
