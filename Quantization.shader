Shader "Unlit/Quantization"
{
    Properties
    {
        _MainTex ("col", color) = (1,1,0,1)
        _ColNum ("Bands", int) = 2
        _Coloffset ("offset", float) = 0.5
      
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        CGINCLUDE

        #include "UnityCG.cginc"
            #include "AutoLight.cginc"
        #include "Lighting.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float3 Norm : NORMAL;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float3 N : TEXCOORD1;
                float4 wpos : TEXCOORD2;
                float4 vertex : SV_POSITION;
                LIGHTING_COORDS(4,5)
            };

           float4 _MainTex;
          
            int _ColNum;
        float _Coloffset ;
        

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.N = UnityObjectToWorldNormal(v.Norm);
                o.wpos = mul(unity_ObjectToWorld,v.vertex);
                TRANSFER_VERTEX_TO_FRAGMENT(o);
                
                return o;
            }



        
            fixed4 frag (v2f i) : SV_Target
            {

                
                fixed4 col = _MainTex;
    
    float3 N = normalize(i.N);
    float3 L =  normalize(UnityWorldSpaceLightDir(i.wpos));
    float Lambert = saturate(dot(N,L));
    float a =  LIGHT_ATTENUATION(i);



          //  Another method by acerola: https://www.youtube.com/watch?v=8wOUe32Pt-E&t=429s at 6:20
          //  make very low
    // return floor(trucol*(_ColNum-1)+0.5)/(_ColNum-1);


                float col1 = Lambert *a;
               
    col1 = floor(col1*_ColNum+_Coloffset)/_ColNum;
  return col1*col;

             
            }

        ENDCG
        
        
        
        Pass
        {
            Tags { "LightMode" = "ForwardBase" }
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
           
           

           

           
            ENDCG
        }
        
        Pass
        {
            Tags { "LightMode" = "ForwardAdd" }
            Blend One One
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma multi_compile_fwdadd
            
           

            
           
            ENDCG
        }
    }
    Fallback "VertexLit"
}
