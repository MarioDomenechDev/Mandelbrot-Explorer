Shader "Explorer/Mandelbrot"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Area ("Area", vector) = (0, 0, 5, 3)
    }
    SubShader
    {
        // No culling or depth
        Cull Off ZWrite Off ZTest Always

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }
            float4 _Area;
            sampler2D _MainTex;

            fixed4 frag (v2f i) : SV_Target
            {
                float2 c = _Area.xy + (i.uv - .5)*_Area.zw;
                float2 z, zPrev;
                float iter;

                float r = 20;
                float r2 = r * r;

                for(iter = 0; iter < 1000; iter++) {
                    zPrev = z;
                    z = float2(z.x * z.x - z.y * z.y, 2*z.x*z.y) + c;
                    if(dot(z, z) > r2) break;
                }

                if(iter > 999) return 0;

                float dist = length(z);
                float fracIter = (dist - r) / (r2 - r);
                fracIter = log2(log(dist) / log(r));

                //iter -= fracIter;

                float m = sqrt((iter / 1000));
                float4 col = sin(float4(.7, .94, 1, 1) * m * 100)*0.5 + 0.5;

                col *= smoothstep(2.5, 0, fracIter);
                return col;
            }
            ENDCG
        }
    }
}
