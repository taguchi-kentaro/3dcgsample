Shader "Custom/TestShader" {
	properties {
		_TextureNo("Texture No", int) = 0
	}
	SubShader {
		Pass {		
			ZWrite Off Cull Off ZTest Off
			CGPROGRAM
			#include "UnityCG.cginc"
			
			#pragma vertex vert_img				// UnityCG.cginc参照
			#pragma fragment frag
			// Use shader model 3.0 target, to get nicer looking lighting
			#pragma target 3.0
			
			#define PI 3.14159

			sampler2D _CameraDepthTexture;	  // Depth texture
			sampler2D _CameraGBufferTexture0; // Diffuse color (RGB), unused (A)
			sampler2D _CameraGBufferTexture1; // Specular color (RGB), roughness (A)
			sampler2D _CameraGBufferTexture2; // World space normal (RGB), unused (A) textureなので0~1
			sampler2D _CameraGBufferTexture3; // AGRBHalf (HDR) format: Emission + lighting + lightmaps + reflection probes buffer			
			int _TextureNo;

			// v2f_imgもUnityCG.cginc参照
			float4 frag( v2f_img i ) : COLOR {
				// 各種GBufferのデータを取得
				//float depth = Linear01Depth(tex2D(_CameraDepthTexture, i.uv.xy).r);
				float depth = UNITY_SAMPLE_DEPTH(tex2D(_CameraDepthTexture,i.uv)) * 4;
				float4 diff = tex2D(_CameraGBufferTexture0, i.uv.xy);
				float4 spec = tex2D(_CameraGBufferTexture1, i.uv.xy);
				float4 norm = tex2D(_CameraGBufferTexture2, i.uv.xy);
				float4 argb = tex2D(_CameraGBufferTexture3, i.uv.xy);

				// ぐるぐる.　http://www.slideshare.net/calmbooks/unity-38485570
				float2 vec = i.uv.xy - float2(0.5, 0.5);
				float l = length(vec);
				float r = atan2(vec.y, vec.x) + PI;
				float t = _Time.y*10;
				float c = 1-sin(l*70+r+t);
				
				float3 rgb;
				// MaterialのPropertyで表示するテクスチャを変更
				switch(_TextureNo) {
				case 0:
				default:
					rgb = diff.rgb;
					break;
				case 1:
					rgb = spec.rgb;
					break;
				case 2:
					rgb = norm.rgb;
					break;
				case 3:
					rgb = depth;
					break;
				case 4:
					rgb = argb.rgb;
					break;
//				case 5:
//					rgb = 0.4*(1.0-depth+c)*argb.rgb;
//					break;
				}			
				return float4(rgb, 1.0);
			}
			ENDCG
		}
	} 
}
