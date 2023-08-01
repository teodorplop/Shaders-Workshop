Shader "Custom/QuadToCircle2D_Smooth"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _InnerRadius ("Inner Radius", Float) = 0.2
        _OuterRadius ("Outer Radius", Float) = 0.2
    }
    SubShader
    {
        Tags { "RenderType"="Transparent" "Queue"="Transparent" } // Mark it as transparent and make it use transparent queue
        
        Blend SrcAlpha OneMinusSrcAlpha // Blend Type - how will colors of this transparent mesh combine with the ones behind it?

        Pass
        {
            CGPROGRAM
            #pragma vertex vert // Name of the vertex shader
            #pragma fragment frag // Name of the fragment shader

            #include "UnityCG.cginc" // File containing helpful Unity functions

            struct VertexInput // Structure coming from CPU, per vertex
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct VertexToFragment // Structure we return from vertex to fragment shaders
            {
                float4 vertex : SV_POSITION;
                float2 uv : TEXCOORD0;
            };

            // Declare material properties
            sampler2D _MainTex; // Declare texture
            float4 _MainTex_ST; // Utils variable required by Unity to compute UVs on specific platforms

            float _InnerRadius; 
            float _OuterRadius;

            VertexToFragment vert(VertexInput input) // Vertex shader method
            {
                VertexToFragment output;
                output.vertex = UnityObjectToClipPos(input.vertex); // input.vertex is in local space, here we transform to clip space (almost screen space) 
                output.uv = TRANSFORM_TEX(input.uv, _MainTex); // Transforms texture coordinates. You can also use output.uv = input.uv; However, it's safer this way for multiple platforms
                return output;
            }

            fixed4 frag(VertexToFragment input) : SV_Target // Fragment shader method
            {
                fixed4 color = tex2D(_MainTex, input.uv); // Sample pixel from fragment's UV

                float dist = distance(input.uv, float2(0.5, 0.5)); // Distance from center of the object

                // Change alpha based on distance
                if (dist < _InnerRadius)
                    color.a = 1;
                else if (dist < _InnerRadius + _OuterRadius)
                    color.a = 1 - clamp((dist - _InnerRadius) / _OuterRadius, 0, 1);
                else
                    color.a = 0;
                
                return color;
            }
            ENDCG
        }
    }
}
