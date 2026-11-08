Shader "NMP/Wall" {
	Properties {
		_MainTexture ("Main Texture", 2D) = "gray" {}
		_Specular ("Specular", 2D) = "white" {}
		[NoScaleOffset] [Normal] _NormalMap ("Normal Map", 2D) = "bump" {}
		_Heightmap ("Heightmap", 2D) = "black" {}
		_AmbientOcculsion ("Ambient Occulsion", 2D) = "white" {}
		_Color ("Color", Vector) = (1,1,1,1)
		_Bumpiness ("Bumpiness", Range(0, 0.5)) = 0.3271323
		_NormalSharpness ("Normal Sharpness", Range(0, 1)) = 1
		_Shadows ("Shadows", Range(0, 1)) = 0.991453
		[MaterialToggle] _BumpAttune ("Bump Attune", Float) = 0.05187402
	}
	SubShader {
		LOD 2
		Tags { "RenderType" = "Opaque" }
		Pass {
			Name "FORWARD"
			LOD 2
			Tags { "LIGHTMODE" = "FORWARDBASE" "RenderType" = "Opaque" "SHADOWSUPPORT" = "true" }
			Cull Off
			GpuProgramID 18417
			Program "vp" {
				SubProgram "d3d11 " {
					Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "DYNAMICLIGHTMAP_OFF" }
					"vs_4_0
					
					#version 330
					#extension GL_ARB_explicit_attrib_location : require
					#extension GL_ARB_explicit_uniform_location : require
					
					#define HLSLCC_ENABLE_UNIFORM_BUFFERS 1
					#if HLSLCC_ENABLE_UNIFORM_BUFFERS
					#define UNITY_UNIFORM
					#else
					#define UNITY_UNIFORM uniform
					#endif
					#define UNITY_SUPPORTS_UNIFORM_LOCATION 1
					#if UNITY_SUPPORTS_UNIFORM_LOCATION
					#define UNITY_LOCATION(x) layout(location = x)
					#define UNITY_BINDING(x) layout(binding = x, std140)
					#else
					#define UNITY_LOCATION(x)
					#define UNITY_BINDING(x) layout(std140)
					#endif
					layout(std140) uniform VGlobals {
						vec4 unused_0_0[4];
						vec4 _MainTexture_ST;
						vec4 unused_0_2[2];
						vec4 _Color;
						vec4 _Heightmap_ST;
						float _Bumpiness;
						vec4 unused_0_6;
						float _BumpAttune;
					};
					layout(std140) uniform UnityPerDraw {
						mat4x4 unity_ObjectToWorld;
						mat4x4 unity_WorldToObject;
						vec4 unused_1_2[2];
					};
					layout(std140) uniform UnityPerFrame {
						vec4 unused_2_0[17];
						mat4x4 unity_MatrixVP;
						vec4 unused_2_2[2];
					};
					uniform  sampler2D _Heightmap;
					uniform  sampler2D _MainTexture;
					in  vec4 in_POSITION0;
					in  vec3 in_NORMAL0;
					in  vec4 in_TANGENT0;
					in  vec2 in_TEXCOORD0;
					in  vec2 in_TEXCOORD1;
					in  vec2 in_TEXCOORD2;
					out vec2 vs_TEXCOORD0;
					out vec2 vs_TEXCOORD1;
					out vec2 vs_TEXCOORD2;
					out vec4 vs_TEXCOORD3;
					out vec3 vs_TEXCOORD4;
					out vec3 vs_TEXCOORD5;
					out vec3 vs_TEXCOORD6;
					out vec4 vs_TEXCOORD10;
					vec4 u_xlat0;
					vec4 u_xlat1;
					vec4 u_xlat2;
					vec3 u_xlat3;
					float u_xlat12;
					void main()
					{
					    u_xlat0.xy = in_TEXCOORD0.xy * _MainTexture_ST.xy + _MainTexture_ST.zw;
					    u_xlat0 = textureLod(_MainTexture, u_xlat0.xy, 0.0);
					    u_xlat0.xyz = u_xlat0.xyz * _Color.xyz;
					    u_xlat1.xyz = u_xlat0.xyz * vec3(-1.0, -1.0, 1.0);
					    u_xlat2.xy = in_TEXCOORD0.xy * _Heightmap_ST.xy + _Heightmap_ST.zw;
					    u_xlat2 = textureLod(_Heightmap, u_xlat2.xy, 0.0);
					    u_xlat2.xyz = u_xlat2.xyz * vec3(_Bumpiness);
					    u_xlat2.xyz = clamp(u_xlat2.xyz, 0.0, 1.0);
					    u_xlat3.xyz = u_xlat2.xyz + vec3(0.0, 0.0, 1.0);
					    u_xlat2.xyz = u_xlat2.xyz * in_NORMAL0.xyz;
					    u_xlat12 = dot(u_xlat3.xyz, u_xlat1.xyz);
					    u_xlat1.xyz = vec3(u_xlat12) * u_xlat3.xyz;
					    u_xlat1.xyz = u_xlat1.xyz / u_xlat3.zzz;
					    u_xlat0.xyz = (-u_xlat0.xyz) * vec3(-1.0, -1.0, 1.0) + u_xlat1.xyz;
					    u_xlat0.x = dot(u_xlat0.xyz, vec3(0.300000012, 0.589999974, 0.109999999));
					    u_xlat0.xyz = u_xlat2.xyz * u_xlat0.xxx + (-u_xlat2.xyz);
					    u_xlat0.xyz = vec3(vec3(_BumpAttune, _BumpAttune, _BumpAttune)) * u_xlat0.xyz + u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz + in_POSITION0.xyz;
					    u_xlat1 = u_xlat0.yyyy * unity_ObjectToWorld[1];
					    u_xlat1 = unity_ObjectToWorld[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat0 = unity_ObjectToWorld[2] * u_xlat0.zzzz + u_xlat1;
					    u_xlat1 = u_xlat0 + unity_ObjectToWorld[3];
					    vs_TEXCOORD3 = unity_ObjectToWorld[3] * in_POSITION0.wwww + u_xlat0;
					    u_xlat0 = u_xlat1.yyyy * unity_MatrixVP[1];
					    u_xlat0 = unity_MatrixVP[0] * u_xlat1.xxxx + u_xlat0;
					    u_xlat0 = unity_MatrixVP[2] * u_xlat1.zzzz + u_xlat0;
					    gl_Position = unity_MatrixVP[3] * u_xlat1.wwww + u_xlat0;
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
					    vs_TEXCOORD1.xy = in_TEXCOORD1.xy;
					    vs_TEXCOORD2.xy = in_TEXCOORD2.xy;
					    u_xlat0.x = dot(in_NORMAL0.xyz, unity_WorldToObject[0].xyz);
					    u_xlat0.y = dot(in_NORMAL0.xyz, unity_WorldToObject[1].xyz);
					    u_xlat0.z = dot(in_NORMAL0.xyz, unity_WorldToObject[2].xyz);
					    u_xlat12 = dot(u_xlat0.xyz, u_xlat0.xyz);
					    u_xlat12 = inversesqrt(u_xlat12);
					    u_xlat0.xyz = vec3(u_xlat12) * u_xlat0.xyz;
					    vs_TEXCOORD4.xyz = u_xlat0.xyz;
					    u_xlat1.xyz = in_TANGENT0.yyy * unity_ObjectToWorld[1].xyz;
					    u_xlat1.xyz = unity_ObjectToWorld[0].xyz * in_TANGENT0.xxx + u_xlat1.xyz;
					    u_xlat1.xyz = unity_ObjectToWorld[2].xyz * in_TANGENT0.zzz + u_xlat1.xyz;
					    u_xlat12 = dot(u_xlat1.xyz, u_xlat1.xyz);
					    u_xlat12 = inversesqrt(u_xlat12);
					    u_xlat1.xyz = vec3(u_xlat12) * u_xlat1.xyz;
					    vs_TEXCOORD5.xyz = u_xlat1.xyz;
					    u_xlat2.xyz = u_xlat0.zxy * u_xlat1.yzx;
					    u_xlat0.xyz = u_xlat0.yzx * u_xlat1.zxy + (-u_xlat2.xyz);
					    u_xlat0.xyz = u_xlat0.xyz * in_TANGENT0.www;
					    u_xlat12 = dot(u_xlat0.xyz, u_xlat0.xyz);
					    u_xlat12 = inversesqrt(u_xlat12);
					    vs_TEXCOORD6.xyz = vec3(u_xlat12) * u_xlat0.xyz;
					    vs_TEXCOORD10 = vec4(0.0, 0.0, 0.0, 0.0);
					    return;
					}"
				}
				SubProgram "d3d11 " {
					Keywords { "DIRECTIONAL" "LIGHTPROBE_SH" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "DYNAMICLIGHTMAP_OFF" }
					"vs_4_0
					
					#version 330
					#extension GL_ARB_explicit_attrib_location : require
					#extension GL_ARB_explicit_uniform_location : require
					
					#define HLSLCC_ENABLE_UNIFORM_BUFFERS 1
					#if HLSLCC_ENABLE_UNIFORM_BUFFERS
					#define UNITY_UNIFORM
					#else
					#define UNITY_UNIFORM uniform
					#endif
					#define UNITY_SUPPORTS_UNIFORM_LOCATION 1
					#if UNITY_SUPPORTS_UNIFORM_LOCATION
					#define UNITY_LOCATION(x) layout(location = x)
					#define UNITY_BINDING(x) layout(binding = x, std140)
					#else
					#define UNITY_LOCATION(x)
					#define UNITY_BINDING(x) layout(std140)
					#endif
					layout(std140) uniform VGlobals {
						vec4 unused_0_0[4];
						vec4 _MainTexture_ST;
						vec4 unused_0_2[2];
						vec4 _Color;
						vec4 _Heightmap_ST;
						float _Bumpiness;
						vec4 unused_0_6;
						float _BumpAttune;
					};
					layout(std140) uniform UnityPerDraw {
						mat4x4 unity_ObjectToWorld;
						mat4x4 unity_WorldToObject;
						vec4 unused_1_2[2];
					};
					layout(std140) uniform UnityPerFrame {
						vec4 unused_2_0[17];
						mat4x4 unity_MatrixVP;
						vec4 unused_2_2[2];
					};
					uniform  sampler2D _Heightmap;
					uniform  sampler2D _MainTexture;
					in  vec4 in_POSITION0;
					in  vec3 in_NORMAL0;
					in  vec4 in_TANGENT0;
					in  vec2 in_TEXCOORD0;
					in  vec2 in_TEXCOORD1;
					in  vec2 in_TEXCOORD2;
					out vec2 vs_TEXCOORD0;
					out vec2 vs_TEXCOORD1;
					out vec2 vs_TEXCOORD2;
					out vec4 vs_TEXCOORD3;
					out vec3 vs_TEXCOORD4;
					out vec3 vs_TEXCOORD5;
					out vec3 vs_TEXCOORD6;
					out vec4 vs_TEXCOORD10;
					vec4 u_xlat0;
					vec4 u_xlat1;
					vec4 u_xlat2;
					vec3 u_xlat3;
					float u_xlat12;
					void main()
					{
					    u_xlat0.xy = in_TEXCOORD0.xy * _MainTexture_ST.xy + _MainTexture_ST.zw;
					    u_xlat0 = textureLod(_MainTexture, u_xlat0.xy, 0.0);
					    u_xlat0.xyz = u_xlat0.xyz * _Color.xyz;
					    u_xlat1.xyz = u_xlat0.xyz * vec3(-1.0, -1.0, 1.0);
					    u_xlat2.xy = in_TEXCOORD0.xy * _Heightmap_ST.xy + _Heightmap_ST.zw;
					    u_xlat2 = textureLod(_Heightmap, u_xlat2.xy, 0.0);
					    u_xlat2.xyz = u_xlat2.xyz * vec3(_Bumpiness);
					    u_xlat2.xyz = clamp(u_xlat2.xyz, 0.0, 1.0);
					    u_xlat3.xyz = u_xlat2.xyz + vec3(0.0, 0.0, 1.0);
					    u_xlat2.xyz = u_xlat2.xyz * in_NORMAL0.xyz;
					    u_xlat12 = dot(u_xlat3.xyz, u_xlat1.xyz);
					    u_xlat1.xyz = vec3(u_xlat12) * u_xlat3.xyz;
					    u_xlat1.xyz = u_xlat1.xyz / u_xlat3.zzz;
					    u_xlat0.xyz = (-u_xlat0.xyz) * vec3(-1.0, -1.0, 1.0) + u_xlat1.xyz;
					    u_xlat0.x = dot(u_xlat0.xyz, vec3(0.300000012, 0.589999974, 0.109999999));
					    u_xlat0.xyz = u_xlat2.xyz * u_xlat0.xxx + (-u_xlat2.xyz);
					    u_xlat0.xyz = vec3(vec3(_BumpAttune, _BumpAttune, _BumpAttune)) * u_xlat0.xyz + u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz + in_POSITION0.xyz;
					    u_xlat1 = u_xlat0.yyyy * unity_ObjectToWorld[1];
					    u_xlat1 = unity_ObjectToWorld[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat0 = unity_ObjectToWorld[2] * u_xlat0.zzzz + u_xlat1;
					    u_xlat1 = u_xlat0 + unity_ObjectToWorld[3];
					    vs_TEXCOORD3 = unity_ObjectToWorld[3] * in_POSITION0.wwww + u_xlat0;
					    u_xlat0 = u_xlat1.yyyy * unity_MatrixVP[1];
					    u_xlat0 = unity_MatrixVP[0] * u_xlat1.xxxx + u_xlat0;
					    u_xlat0 = unity_MatrixVP[2] * u_xlat1.zzzz + u_xlat0;
					    gl_Position = unity_MatrixVP[3] * u_xlat1.wwww + u_xlat0;
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
					    vs_TEXCOORD1.xy = in_TEXCOORD1.xy;
					    vs_TEXCOORD2.xy = in_TEXCOORD2.xy;
					    u_xlat0.x = dot(in_NORMAL0.xyz, unity_WorldToObject[0].xyz);
					    u_xlat0.y = dot(in_NORMAL0.xyz, unity_WorldToObject[1].xyz);
					    u_xlat0.z = dot(in_NORMAL0.xyz, unity_WorldToObject[2].xyz);
					    u_xlat12 = dot(u_xlat0.xyz, u_xlat0.xyz);
					    u_xlat12 = inversesqrt(u_xlat12);
					    u_xlat0.xyz = vec3(u_xlat12) * u_xlat0.xyz;
					    vs_TEXCOORD4.xyz = u_xlat0.xyz;
					    u_xlat1.xyz = in_TANGENT0.yyy * unity_ObjectToWorld[1].xyz;
					    u_xlat1.xyz = unity_ObjectToWorld[0].xyz * in_TANGENT0.xxx + u_xlat1.xyz;
					    u_xlat1.xyz = unity_ObjectToWorld[2].xyz * in_TANGENT0.zzz + u_xlat1.xyz;
					    u_xlat12 = dot(u_xlat1.xyz, u_xlat1.xyz);
					    u_xlat12 = inversesqrt(u_xlat12);
					    u_xlat1.xyz = vec3(u_xlat12) * u_xlat1.xyz;
					    vs_TEXCOORD5.xyz = u_xlat1.xyz;
					    u_xlat2.xyz = u_xlat0.zxy * u_xlat1.yzx;
					    u_xlat0.xyz = u_xlat0.yzx * u_xlat1.zxy + (-u_xlat2.xyz);
					    u_xlat0.xyz = u_xlat0.xyz * in_TANGENT0.www;
					    u_xlat12 = dot(u_xlat0.xyz, u_xlat0.xyz);
					    u_xlat12 = inversesqrt(u_xlat12);
					    vs_TEXCOORD6.xyz = vec3(u_xlat12) * u_xlat0.xyz;
					    vs_TEXCOORD10 = vec4(0.0, 0.0, 0.0, 0.0);
					    return;
					}"
				}
				SubProgram "d3d11 " {
					Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "DYNAMICLIGHTMAP_OFF" }
					"vs_4_0
					
					#version 330
					#extension GL_ARB_explicit_attrib_location : require
					#extension GL_ARB_explicit_uniform_location : require
					
					#define HLSLCC_ENABLE_UNIFORM_BUFFERS 1
					#if HLSLCC_ENABLE_UNIFORM_BUFFERS
					#define UNITY_UNIFORM
					#else
					#define UNITY_UNIFORM uniform
					#endif
					#define UNITY_SUPPORTS_UNIFORM_LOCATION 1
					#if UNITY_SUPPORTS_UNIFORM_LOCATION
					#define UNITY_LOCATION(x) layout(location = x)
					#define UNITY_BINDING(x) layout(binding = x, std140)
					#else
					#define UNITY_LOCATION(x)
					#define UNITY_BINDING(x) layout(std140)
					#endif
					layout(std140) uniform VGlobals {
						vec4 unused_0_0[4];
						vec4 _MainTexture_ST;
						vec4 unused_0_2[2];
						vec4 _Color;
						vec4 _Heightmap_ST;
						float _Bumpiness;
						vec4 unused_0_6;
						float _BumpAttune;
					};
					layout(std140) uniform UnityPerCamera {
						vec4 unused_1_0[5];
						vec4 _ProjectionParams;
						vec4 unused_1_2[3];
					};
					layout(std140) uniform UnityPerDraw {
						mat4x4 unity_ObjectToWorld;
						mat4x4 unity_WorldToObject;
						vec4 unused_2_2[2];
					};
					layout(std140) uniform UnityPerFrame {
						vec4 unused_3_0[17];
						mat4x4 unity_MatrixVP;
						vec4 unused_3_2[2];
					};
					uniform  sampler2D _Heightmap;
					uniform  sampler2D _MainTexture;
					in  vec4 in_POSITION0;
					in  vec3 in_NORMAL0;
					in  vec4 in_TANGENT0;
					in  vec2 in_TEXCOORD0;
					in  vec2 in_TEXCOORD1;
					in  vec2 in_TEXCOORD2;
					out vec2 vs_TEXCOORD0;
					out vec2 vs_TEXCOORD1;
					out vec2 vs_TEXCOORD2;
					out vec4 vs_TEXCOORD3;
					out vec3 vs_TEXCOORD4;
					out vec3 vs_TEXCOORD5;
					out vec3 vs_TEXCOORD6;
					out vec4 vs_TEXCOORD8;
					out vec4 vs_TEXCOORD10;
					vec4 u_xlat0;
					vec4 u_xlat1;
					vec4 u_xlat2;
					vec3 u_xlat3;
					float u_xlat12;
					float u_xlat13;
					void main()
					{
					    u_xlat0.xy = in_TEXCOORD0.xy * _MainTexture_ST.xy + _MainTexture_ST.zw;
					    u_xlat0 = textureLod(_MainTexture, u_xlat0.xy, 0.0);
					    u_xlat0.xyz = u_xlat0.xyz * _Color.xyz;
					    u_xlat1.xyz = u_xlat0.xyz * vec3(-1.0, -1.0, 1.0);
					    u_xlat2.xy = in_TEXCOORD0.xy * _Heightmap_ST.xy + _Heightmap_ST.zw;
					    u_xlat2 = textureLod(_Heightmap, u_xlat2.xy, 0.0);
					    u_xlat2.xyz = u_xlat2.xyz * vec3(_Bumpiness);
					    u_xlat2.xyz = clamp(u_xlat2.xyz, 0.0, 1.0);
					    u_xlat3.xyz = u_xlat2.xyz + vec3(0.0, 0.0, 1.0);
					    u_xlat2.xyz = u_xlat2.xyz * in_NORMAL0.xyz;
					    u_xlat12 = dot(u_xlat3.xyz, u_xlat1.xyz);
					    u_xlat1.xyz = vec3(u_xlat12) * u_xlat3.xyz;
					    u_xlat1.xyz = u_xlat1.xyz / u_xlat3.zzz;
					    u_xlat0.xyz = (-u_xlat0.xyz) * vec3(-1.0, -1.0, 1.0) + u_xlat1.xyz;
					    u_xlat0.x = dot(u_xlat0.xyz, vec3(0.300000012, 0.589999974, 0.109999999));
					    u_xlat0.xyz = u_xlat2.xyz * u_xlat0.xxx + (-u_xlat2.xyz);
					    u_xlat0.xyz = vec3(vec3(_BumpAttune, _BumpAttune, _BumpAttune)) * u_xlat0.xyz + u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz + in_POSITION0.xyz;
					    u_xlat1 = u_xlat0.yyyy * unity_ObjectToWorld[1];
					    u_xlat1 = unity_ObjectToWorld[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat0 = unity_ObjectToWorld[2] * u_xlat0.zzzz + u_xlat1;
					    u_xlat1 = u_xlat0 + unity_ObjectToWorld[3];
					    vs_TEXCOORD3 = unity_ObjectToWorld[3] * in_POSITION0.wwww + u_xlat0;
					    u_xlat0 = u_xlat1.yyyy * unity_MatrixVP[1];
					    u_xlat0 = unity_MatrixVP[0] * u_xlat1.xxxx + u_xlat0;
					    u_xlat0 = unity_MatrixVP[2] * u_xlat1.zzzz + u_xlat0;
					    u_xlat0 = unity_MatrixVP[3] * u_xlat1.wwww + u_xlat0;
					    gl_Position = u_xlat0;
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
					    vs_TEXCOORD1.xy = in_TEXCOORD1.xy;
					    vs_TEXCOORD2.xy = in_TEXCOORD2.xy;
					    u_xlat1.x = dot(in_NORMAL0.xyz, unity_WorldToObject[0].xyz);
					    u_xlat1.y = dot(in_NORMAL0.xyz, unity_WorldToObject[1].xyz);
					    u_xlat1.z = dot(in_NORMAL0.xyz, unity_WorldToObject[2].xyz);
					    u_xlat13 = dot(u_xlat1.xyz, u_xlat1.xyz);
					    u_xlat13 = inversesqrt(u_xlat13);
					    u_xlat1.xyz = vec3(u_xlat13) * u_xlat1.xyz;
					    vs_TEXCOORD4.xyz = u_xlat1.xyz;
					    u_xlat2.xyz = in_TANGENT0.yyy * unity_ObjectToWorld[1].xyz;
					    u_xlat2.xyz = unity_ObjectToWorld[0].xyz * in_TANGENT0.xxx + u_xlat2.xyz;
					    u_xlat2.xyz = unity_ObjectToWorld[2].xyz * in_TANGENT0.zzz + u_xlat2.xyz;
					    u_xlat13 = dot(u_xlat2.xyz, u_xlat2.xyz);
					    u_xlat13 = inversesqrt(u_xlat13);
					    u_xlat2.xyz = vec3(u_xlat13) * u_xlat2.xyz;
					    vs_TEXCOORD5.xyz = u_xlat2.xyz;
					    u_xlat3.xyz = u_xlat1.zxy * u_xlat2.yzx;
					    u_xlat1.xyz = u_xlat1.yzx * u_xlat2.zxy + (-u_xlat3.xyz);
					    u_xlat1.xyz = u_xlat1.xyz * in_TANGENT0.www;
					    u_xlat13 = dot(u_xlat1.xyz, u_xlat1.xyz);
					    u_xlat13 = inversesqrt(u_xlat13);
					    vs_TEXCOORD6.xyz = vec3(u_xlat13) * u_xlat1.xyz;
					    u_xlat0.y = u_xlat0.y * _ProjectionParams.x;
					    u_xlat1.xzw = u_xlat0.xwy * vec3(0.5, 0.5, 0.5);
					    vs_TEXCOORD8.zw = u_xlat0.zw;
					    vs_TEXCOORD8.xy = u_xlat1.zz + u_xlat1.xw;
					    vs_TEXCOORD10 = vec4(0.0, 0.0, 0.0, 0.0);
					    return;
					}"
				}
				SubProgram "d3d11 " {
					Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "LIGHTPROBE_SH" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "DYNAMICLIGHTMAP_OFF" }
					"vs_4_0
					
					#version 330
					#extension GL_ARB_explicit_attrib_location : require
					#extension GL_ARB_explicit_uniform_location : require
					
					#define HLSLCC_ENABLE_UNIFORM_BUFFERS 1
					#if HLSLCC_ENABLE_UNIFORM_BUFFERS
					#define UNITY_UNIFORM
					#else
					#define UNITY_UNIFORM uniform
					#endif
					#define UNITY_SUPPORTS_UNIFORM_LOCATION 1
					#if UNITY_SUPPORTS_UNIFORM_LOCATION
					#define UNITY_LOCATION(x) layout(location = x)
					#define UNITY_BINDING(x) layout(binding = x, std140)
					#else
					#define UNITY_LOCATION(x)
					#define UNITY_BINDING(x) layout(std140)
					#endif
					layout(std140) uniform VGlobals {
						vec4 unused_0_0[4];
						vec4 _MainTexture_ST;
						vec4 unused_0_2[2];
						vec4 _Color;
						vec4 _Heightmap_ST;
						float _Bumpiness;
						vec4 unused_0_6;
						float _BumpAttune;
					};
					layout(std140) uniform UnityPerCamera {
						vec4 unused_1_0[5];
						vec4 _ProjectionParams;
						vec4 unused_1_2[3];
					};
					layout(std140) uniform UnityPerDraw {
						mat4x4 unity_ObjectToWorld;
						mat4x4 unity_WorldToObject;
						vec4 unused_2_2[2];
					};
					layout(std140) uniform UnityPerFrame {
						vec4 unused_3_0[17];
						mat4x4 unity_MatrixVP;
						vec4 unused_3_2[2];
					};
					uniform  sampler2D _Heightmap;
					uniform  sampler2D _MainTexture;
					in  vec4 in_POSITION0;
					in  vec3 in_NORMAL0;
					in  vec4 in_TANGENT0;
					in  vec2 in_TEXCOORD0;
					in  vec2 in_TEXCOORD1;
					in  vec2 in_TEXCOORD2;
					out vec2 vs_TEXCOORD0;
					out vec2 vs_TEXCOORD1;
					out vec2 vs_TEXCOORD2;
					out vec4 vs_TEXCOORD3;
					out vec3 vs_TEXCOORD4;
					out vec3 vs_TEXCOORD5;
					out vec3 vs_TEXCOORD6;
					out vec4 vs_TEXCOORD8;
					out vec4 vs_TEXCOORD10;
					vec4 u_xlat0;
					vec4 u_xlat1;
					vec4 u_xlat2;
					vec3 u_xlat3;
					float u_xlat12;
					float u_xlat13;
					void main()
					{
					    u_xlat0.xy = in_TEXCOORD0.xy * _MainTexture_ST.xy + _MainTexture_ST.zw;
					    u_xlat0 = textureLod(_MainTexture, u_xlat0.xy, 0.0);
					    u_xlat0.xyz = u_xlat0.xyz * _Color.xyz;
					    u_xlat1.xyz = u_xlat0.xyz * vec3(-1.0, -1.0, 1.0);
					    u_xlat2.xy = in_TEXCOORD0.xy * _Heightmap_ST.xy + _Heightmap_ST.zw;
					    u_xlat2 = textureLod(_Heightmap, u_xlat2.xy, 0.0);
					    u_xlat2.xyz = u_xlat2.xyz * vec3(_Bumpiness);
					    u_xlat2.xyz = clamp(u_xlat2.xyz, 0.0, 1.0);
					    u_xlat3.xyz = u_xlat2.xyz + vec3(0.0, 0.0, 1.0);
					    u_xlat2.xyz = u_xlat2.xyz * in_NORMAL0.xyz;
					    u_xlat12 = dot(u_xlat3.xyz, u_xlat1.xyz);
					    u_xlat1.xyz = vec3(u_xlat12) * u_xlat3.xyz;
					    u_xlat1.xyz = u_xlat1.xyz / u_xlat3.zzz;
					    u_xlat0.xyz = (-u_xlat0.xyz) * vec3(-1.0, -1.0, 1.0) + u_xlat1.xyz;
					    u_xlat0.x = dot(u_xlat0.xyz, vec3(0.300000012, 0.589999974, 0.109999999));
					    u_xlat0.xyz = u_xlat2.xyz * u_xlat0.xxx + (-u_xlat2.xyz);
					    u_xlat0.xyz = vec3(vec3(_BumpAttune, _BumpAttune, _BumpAttune)) * u_xlat0.xyz + u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz + in_POSITION0.xyz;
					    u_xlat1 = u_xlat0.yyyy * unity_ObjectToWorld[1];
					    u_xlat1 = unity_ObjectToWorld[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat0 = unity_ObjectToWorld[2] * u_xlat0.zzzz + u_xlat1;
					    u_xlat1 = u_xlat0 + unity_ObjectToWorld[3];
					    vs_TEXCOORD3 = unity_ObjectToWorld[3] * in_POSITION0.wwww + u_xlat0;
					    u_xlat0 = u_xlat1.yyyy * unity_MatrixVP[1];
					    u_xlat0 = unity_MatrixVP[0] * u_xlat1.xxxx + u_xlat0;
					    u_xlat0 = unity_MatrixVP[2] * u_xlat1.zzzz + u_xlat0;
					    u_xlat0 = unity_MatrixVP[3] * u_xlat1.wwww + u_xlat0;
					    gl_Position = u_xlat0;
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
					    vs_TEXCOORD1.xy = in_TEXCOORD1.xy;
					    vs_TEXCOORD2.xy = in_TEXCOORD2.xy;
					    u_xlat1.x = dot(in_NORMAL0.xyz, unity_WorldToObject[0].xyz);
					    u_xlat1.y = dot(in_NORMAL0.xyz, unity_WorldToObject[1].xyz);
					    u_xlat1.z = dot(in_NORMAL0.xyz, unity_WorldToObject[2].xyz);
					    u_xlat13 = dot(u_xlat1.xyz, u_xlat1.xyz);
					    u_xlat13 = inversesqrt(u_xlat13);
					    u_xlat1.xyz = vec3(u_xlat13) * u_xlat1.xyz;
					    vs_TEXCOORD4.xyz = u_xlat1.xyz;
					    u_xlat2.xyz = in_TANGENT0.yyy * unity_ObjectToWorld[1].xyz;
					    u_xlat2.xyz = unity_ObjectToWorld[0].xyz * in_TANGENT0.xxx + u_xlat2.xyz;
					    u_xlat2.xyz = unity_ObjectToWorld[2].xyz * in_TANGENT0.zzz + u_xlat2.xyz;
					    u_xlat13 = dot(u_xlat2.xyz, u_xlat2.xyz);
					    u_xlat13 = inversesqrt(u_xlat13);
					    u_xlat2.xyz = vec3(u_xlat13) * u_xlat2.xyz;
					    vs_TEXCOORD5.xyz = u_xlat2.xyz;
					    u_xlat3.xyz = u_xlat1.zxy * u_xlat2.yzx;
					    u_xlat1.xyz = u_xlat1.yzx * u_xlat2.zxy + (-u_xlat3.xyz);
					    u_xlat1.xyz = u_xlat1.xyz * in_TANGENT0.www;
					    u_xlat13 = dot(u_xlat1.xyz, u_xlat1.xyz);
					    u_xlat13 = inversesqrt(u_xlat13);
					    vs_TEXCOORD6.xyz = vec3(u_xlat13) * u_xlat1.xyz;
					    u_xlat0.y = u_xlat0.y * _ProjectionParams.x;
					    u_xlat1.xzw = u_xlat0.xwy * vec3(0.5, 0.5, 0.5);
					    vs_TEXCOORD8.zw = u_xlat0.zw;
					    vs_TEXCOORD8.xy = u_xlat1.zz + u_xlat1.xw;
					    vs_TEXCOORD10 = vec4(0.0, 0.0, 0.0, 0.0);
					    return;
					}"
				}
				SubProgram "d3d11 " {
					Keywords { "DIRECTIONAL" "VERTEXLIGHT_ON" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "DYNAMICLIGHTMAP_OFF" }
					"vs_4_0
					
					#version 330
					#extension GL_ARB_explicit_attrib_location : require
					#extension GL_ARB_explicit_uniform_location : require
					
					#define HLSLCC_ENABLE_UNIFORM_BUFFERS 1
					#if HLSLCC_ENABLE_UNIFORM_BUFFERS
					#define UNITY_UNIFORM
					#else
					#define UNITY_UNIFORM uniform
					#endif
					#define UNITY_SUPPORTS_UNIFORM_LOCATION 1
					#if UNITY_SUPPORTS_UNIFORM_LOCATION
					#define UNITY_LOCATION(x) layout(location = x)
					#define UNITY_BINDING(x) layout(binding = x, std140)
					#else
					#define UNITY_LOCATION(x)
					#define UNITY_BINDING(x) layout(std140)
					#endif
					layout(std140) uniform VGlobals {
						vec4 unused_0_0[4];
						vec4 _MainTexture_ST;
						vec4 unused_0_2[2];
						vec4 _Color;
						vec4 _Heightmap_ST;
						float _Bumpiness;
						vec4 unused_0_6;
						float _BumpAttune;
					};
					layout(std140) uniform UnityPerDraw {
						mat4x4 unity_ObjectToWorld;
						mat4x4 unity_WorldToObject;
						vec4 unused_1_2[2];
					};
					layout(std140) uniform UnityPerFrame {
						vec4 unused_2_0[17];
						mat4x4 unity_MatrixVP;
						vec4 unused_2_2[2];
					};
					uniform  sampler2D _Heightmap;
					uniform  sampler2D _MainTexture;
					in  vec4 in_POSITION0;
					in  vec3 in_NORMAL0;
					in  vec4 in_TANGENT0;
					in  vec2 in_TEXCOORD0;
					in  vec2 in_TEXCOORD1;
					in  vec2 in_TEXCOORD2;
					out vec2 vs_TEXCOORD0;
					out vec2 vs_TEXCOORD1;
					out vec2 vs_TEXCOORD2;
					out vec4 vs_TEXCOORD3;
					out vec3 vs_TEXCOORD4;
					out vec3 vs_TEXCOORD5;
					out vec3 vs_TEXCOORD6;
					out vec4 vs_TEXCOORD10;
					vec4 u_xlat0;
					vec4 u_xlat1;
					vec4 u_xlat2;
					vec3 u_xlat3;
					float u_xlat12;
					void main()
					{
					    u_xlat0.xy = in_TEXCOORD0.xy * _MainTexture_ST.xy + _MainTexture_ST.zw;
					    u_xlat0 = textureLod(_MainTexture, u_xlat0.xy, 0.0);
					    u_xlat0.xyz = u_xlat0.xyz * _Color.xyz;
					    u_xlat1.xyz = u_xlat0.xyz * vec3(-1.0, -1.0, 1.0);
					    u_xlat2.xy = in_TEXCOORD0.xy * _Heightmap_ST.xy + _Heightmap_ST.zw;
					    u_xlat2 = textureLod(_Heightmap, u_xlat2.xy, 0.0);
					    u_xlat2.xyz = u_xlat2.xyz * vec3(_Bumpiness);
					    u_xlat2.xyz = clamp(u_xlat2.xyz, 0.0, 1.0);
					    u_xlat3.xyz = u_xlat2.xyz + vec3(0.0, 0.0, 1.0);
					    u_xlat2.xyz = u_xlat2.xyz * in_NORMAL0.xyz;
					    u_xlat12 = dot(u_xlat3.xyz, u_xlat1.xyz);
					    u_xlat1.xyz = vec3(u_xlat12) * u_xlat3.xyz;
					    u_xlat1.xyz = u_xlat1.xyz / u_xlat3.zzz;
					    u_xlat0.xyz = (-u_xlat0.xyz) * vec3(-1.0, -1.0, 1.0) + u_xlat1.xyz;
					    u_xlat0.x = dot(u_xlat0.xyz, vec3(0.300000012, 0.589999974, 0.109999999));
					    u_xlat0.xyz = u_xlat2.xyz * u_xlat0.xxx + (-u_xlat2.xyz);
					    u_xlat0.xyz = vec3(vec3(_BumpAttune, _BumpAttune, _BumpAttune)) * u_xlat0.xyz + u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz + in_POSITION0.xyz;
					    u_xlat1 = u_xlat0.yyyy * unity_ObjectToWorld[1];
					    u_xlat1 = unity_ObjectToWorld[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat0 = unity_ObjectToWorld[2] * u_xlat0.zzzz + u_xlat1;
					    u_xlat1 = u_xlat0 + unity_ObjectToWorld[3];
					    vs_TEXCOORD3 = unity_ObjectToWorld[3] * in_POSITION0.wwww + u_xlat0;
					    u_xlat0 = u_xlat1.yyyy * unity_MatrixVP[1];
					    u_xlat0 = unity_MatrixVP[0] * u_xlat1.xxxx + u_xlat0;
					    u_xlat0 = unity_MatrixVP[2] * u_xlat1.zzzz + u_xlat0;
					    gl_Position = unity_MatrixVP[3] * u_xlat1.wwww + u_xlat0;
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
					    vs_TEXCOORD1.xy = in_TEXCOORD1.xy;
					    vs_TEXCOORD2.xy = in_TEXCOORD2.xy;
					    u_xlat0.x = dot(in_NORMAL0.xyz, unity_WorldToObject[0].xyz);
					    u_xlat0.y = dot(in_NORMAL0.xyz, unity_WorldToObject[1].xyz);
					    u_xlat0.z = dot(in_NORMAL0.xyz, unity_WorldToObject[2].xyz);
					    u_xlat12 = dot(u_xlat0.xyz, u_xlat0.xyz);
					    u_xlat12 = inversesqrt(u_xlat12);
					    u_xlat0.xyz = vec3(u_xlat12) * u_xlat0.xyz;
					    vs_TEXCOORD4.xyz = u_xlat0.xyz;
					    u_xlat1.xyz = in_TANGENT0.yyy * unity_ObjectToWorld[1].xyz;
					    u_xlat1.xyz = unity_ObjectToWorld[0].xyz * in_TANGENT0.xxx + u_xlat1.xyz;
					    u_xlat1.xyz = unity_ObjectToWorld[2].xyz * in_TANGENT0.zzz + u_xlat1.xyz;
					    u_xlat12 = dot(u_xlat1.xyz, u_xlat1.xyz);
					    u_xlat12 = inversesqrt(u_xlat12);
					    u_xlat1.xyz = vec3(u_xlat12) * u_xlat1.xyz;
					    vs_TEXCOORD5.xyz = u_xlat1.xyz;
					    u_xlat2.xyz = u_xlat0.zxy * u_xlat1.yzx;
					    u_xlat0.xyz = u_xlat0.yzx * u_xlat1.zxy + (-u_xlat2.xyz);
					    u_xlat0.xyz = u_xlat0.xyz * in_TANGENT0.www;
					    u_xlat12 = dot(u_xlat0.xyz, u_xlat0.xyz);
					    u_xlat12 = inversesqrt(u_xlat12);
					    vs_TEXCOORD6.xyz = vec3(u_xlat12) * u_xlat0.xyz;
					    vs_TEXCOORD10 = vec4(0.0, 0.0, 0.0, 0.0);
					    return;
					}"
				}
				SubProgram "d3d11 " {
					Keywords { "DIRECTIONAL" "LIGHTPROBE_SH" "VERTEXLIGHT_ON" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "DYNAMICLIGHTMAP_OFF" }
					"vs_4_0
					
					#version 330
					#extension GL_ARB_explicit_attrib_location : require
					#extension GL_ARB_explicit_uniform_location : require
					
					#define HLSLCC_ENABLE_UNIFORM_BUFFERS 1
					#if HLSLCC_ENABLE_UNIFORM_BUFFERS
					#define UNITY_UNIFORM
					#else
					#define UNITY_UNIFORM uniform
					#endif
					#define UNITY_SUPPORTS_UNIFORM_LOCATION 1
					#if UNITY_SUPPORTS_UNIFORM_LOCATION
					#define UNITY_LOCATION(x) layout(location = x)
					#define UNITY_BINDING(x) layout(binding = x, std140)
					#else
					#define UNITY_LOCATION(x)
					#define UNITY_BINDING(x) layout(std140)
					#endif
					layout(std140) uniform VGlobals {
						vec4 unused_0_0[4];
						vec4 _MainTexture_ST;
						vec4 unused_0_2[2];
						vec4 _Color;
						vec4 _Heightmap_ST;
						float _Bumpiness;
						vec4 unused_0_6;
						float _BumpAttune;
					};
					layout(std140) uniform UnityPerDraw {
						mat4x4 unity_ObjectToWorld;
						mat4x4 unity_WorldToObject;
						vec4 unused_1_2[2];
					};
					layout(std140) uniform UnityPerFrame {
						vec4 unused_2_0[17];
						mat4x4 unity_MatrixVP;
						vec4 unused_2_2[2];
					};
					uniform  sampler2D _Heightmap;
					uniform  sampler2D _MainTexture;
					in  vec4 in_POSITION0;
					in  vec3 in_NORMAL0;
					in  vec4 in_TANGENT0;
					in  vec2 in_TEXCOORD0;
					in  vec2 in_TEXCOORD1;
					in  vec2 in_TEXCOORD2;
					out vec2 vs_TEXCOORD0;
					out vec2 vs_TEXCOORD1;
					out vec2 vs_TEXCOORD2;
					out vec4 vs_TEXCOORD3;
					out vec3 vs_TEXCOORD4;
					out vec3 vs_TEXCOORD5;
					out vec3 vs_TEXCOORD6;
					out vec4 vs_TEXCOORD10;
					vec4 u_xlat0;
					vec4 u_xlat1;
					vec4 u_xlat2;
					vec3 u_xlat3;
					float u_xlat12;
					void main()
					{
					    u_xlat0.xy = in_TEXCOORD0.xy * _MainTexture_ST.xy + _MainTexture_ST.zw;
					    u_xlat0 = textureLod(_MainTexture, u_xlat0.xy, 0.0);
					    u_xlat0.xyz = u_xlat0.xyz * _Color.xyz;
					    u_xlat1.xyz = u_xlat0.xyz * vec3(-1.0, -1.0, 1.0);
					    u_xlat2.xy = in_TEXCOORD0.xy * _Heightmap_ST.xy + _Heightmap_ST.zw;
					    u_xlat2 = textureLod(_Heightmap, u_xlat2.xy, 0.0);
					    u_xlat2.xyz = u_xlat2.xyz * vec3(_Bumpiness);
					    u_xlat2.xyz = clamp(u_xlat2.xyz, 0.0, 1.0);
					    u_xlat3.xyz = u_xlat2.xyz + vec3(0.0, 0.0, 1.0);
					    u_xlat2.xyz = u_xlat2.xyz * in_NORMAL0.xyz;
					    u_xlat12 = dot(u_xlat3.xyz, u_xlat1.xyz);
					    u_xlat1.xyz = vec3(u_xlat12) * u_xlat3.xyz;
					    u_xlat1.xyz = u_xlat1.xyz / u_xlat3.zzz;
					    u_xlat0.xyz = (-u_xlat0.xyz) * vec3(-1.0, -1.0, 1.0) + u_xlat1.xyz;
					    u_xlat0.x = dot(u_xlat0.xyz, vec3(0.300000012, 0.589999974, 0.109999999));
					    u_xlat0.xyz = u_xlat2.xyz * u_xlat0.xxx + (-u_xlat2.xyz);
					    u_xlat0.xyz = vec3(vec3(_BumpAttune, _BumpAttune, _BumpAttune)) * u_xlat0.xyz + u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz + in_POSITION0.xyz;
					    u_xlat1 = u_xlat0.yyyy * unity_ObjectToWorld[1];
					    u_xlat1 = unity_ObjectToWorld[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat0 = unity_ObjectToWorld[2] * u_xlat0.zzzz + u_xlat1;
					    u_xlat1 = u_xlat0 + unity_ObjectToWorld[3];
					    vs_TEXCOORD3 = unity_ObjectToWorld[3] * in_POSITION0.wwww + u_xlat0;
					    u_xlat0 = u_xlat1.yyyy * unity_MatrixVP[1];
					    u_xlat0 = unity_MatrixVP[0] * u_xlat1.xxxx + u_xlat0;
					    u_xlat0 = unity_MatrixVP[2] * u_xlat1.zzzz + u_xlat0;
					    gl_Position = unity_MatrixVP[3] * u_xlat1.wwww + u_xlat0;
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
					    vs_TEXCOORD1.xy = in_TEXCOORD1.xy;
					    vs_TEXCOORD2.xy = in_TEXCOORD2.xy;
					    u_xlat0.x = dot(in_NORMAL0.xyz, unity_WorldToObject[0].xyz);
					    u_xlat0.y = dot(in_NORMAL0.xyz, unity_WorldToObject[1].xyz);
					    u_xlat0.z = dot(in_NORMAL0.xyz, unity_WorldToObject[2].xyz);
					    u_xlat12 = dot(u_xlat0.xyz, u_xlat0.xyz);
					    u_xlat12 = inversesqrt(u_xlat12);
					    u_xlat0.xyz = vec3(u_xlat12) * u_xlat0.xyz;
					    vs_TEXCOORD4.xyz = u_xlat0.xyz;
					    u_xlat1.xyz = in_TANGENT0.yyy * unity_ObjectToWorld[1].xyz;
					    u_xlat1.xyz = unity_ObjectToWorld[0].xyz * in_TANGENT0.xxx + u_xlat1.xyz;
					    u_xlat1.xyz = unity_ObjectToWorld[2].xyz * in_TANGENT0.zzz + u_xlat1.xyz;
					    u_xlat12 = dot(u_xlat1.xyz, u_xlat1.xyz);
					    u_xlat12 = inversesqrt(u_xlat12);
					    u_xlat1.xyz = vec3(u_xlat12) * u_xlat1.xyz;
					    vs_TEXCOORD5.xyz = u_xlat1.xyz;
					    u_xlat2.xyz = u_xlat0.zxy * u_xlat1.yzx;
					    u_xlat0.xyz = u_xlat0.yzx * u_xlat1.zxy + (-u_xlat2.xyz);
					    u_xlat0.xyz = u_xlat0.xyz * in_TANGENT0.www;
					    u_xlat12 = dot(u_xlat0.xyz, u_xlat0.xyz);
					    u_xlat12 = inversesqrt(u_xlat12);
					    vs_TEXCOORD6.xyz = vec3(u_xlat12) * u_xlat0.xyz;
					    vs_TEXCOORD10 = vec4(0.0, 0.0, 0.0, 0.0);
					    return;
					}"
				}
				SubProgram "d3d11 " {
					Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "VERTEXLIGHT_ON" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "DYNAMICLIGHTMAP_OFF" }
					"vs_4_0
					
					#version 330
					#extension GL_ARB_explicit_attrib_location : require
					#extension GL_ARB_explicit_uniform_location : require
					
					#define HLSLCC_ENABLE_UNIFORM_BUFFERS 1
					#if HLSLCC_ENABLE_UNIFORM_BUFFERS
					#define UNITY_UNIFORM
					#else
					#define UNITY_UNIFORM uniform
					#endif
					#define UNITY_SUPPORTS_UNIFORM_LOCATION 1
					#if UNITY_SUPPORTS_UNIFORM_LOCATION
					#define UNITY_LOCATION(x) layout(location = x)
					#define UNITY_BINDING(x) layout(binding = x, std140)
					#else
					#define UNITY_LOCATION(x)
					#define UNITY_BINDING(x) layout(std140)
					#endif
					layout(std140) uniform VGlobals {
						vec4 unused_0_0[4];
						vec4 _MainTexture_ST;
						vec4 unused_0_2[2];
						vec4 _Color;
						vec4 _Heightmap_ST;
						float _Bumpiness;
						vec4 unused_0_6;
						float _BumpAttune;
					};
					layout(std140) uniform UnityPerCamera {
						vec4 unused_1_0[5];
						vec4 _ProjectionParams;
						vec4 unused_1_2[3];
					};
					layout(std140) uniform UnityPerDraw {
						mat4x4 unity_ObjectToWorld;
						mat4x4 unity_WorldToObject;
						vec4 unused_2_2[2];
					};
					layout(std140) uniform UnityPerFrame {
						vec4 unused_3_0[17];
						mat4x4 unity_MatrixVP;
						vec4 unused_3_2[2];
					};
					uniform  sampler2D _Heightmap;
					uniform  sampler2D _MainTexture;
					in  vec4 in_POSITION0;
					in  vec3 in_NORMAL0;
					in  vec4 in_TANGENT0;
					in  vec2 in_TEXCOORD0;
					in  vec2 in_TEXCOORD1;
					in  vec2 in_TEXCOORD2;
					out vec2 vs_TEXCOORD0;
					out vec2 vs_TEXCOORD1;
					out vec2 vs_TEXCOORD2;
					out vec4 vs_TEXCOORD3;
					out vec3 vs_TEXCOORD4;
					out vec3 vs_TEXCOORD5;
					out vec3 vs_TEXCOORD6;
					out vec4 vs_TEXCOORD8;
					out vec4 vs_TEXCOORD10;
					vec4 u_xlat0;
					vec4 u_xlat1;
					vec4 u_xlat2;
					vec3 u_xlat3;
					float u_xlat12;
					float u_xlat13;
					void main()
					{
					    u_xlat0.xy = in_TEXCOORD0.xy * _MainTexture_ST.xy + _MainTexture_ST.zw;
					    u_xlat0 = textureLod(_MainTexture, u_xlat0.xy, 0.0);
					    u_xlat0.xyz = u_xlat0.xyz * _Color.xyz;
					    u_xlat1.xyz = u_xlat0.xyz * vec3(-1.0, -1.0, 1.0);
					    u_xlat2.xy = in_TEXCOORD0.xy * _Heightmap_ST.xy + _Heightmap_ST.zw;
					    u_xlat2 = textureLod(_Heightmap, u_xlat2.xy, 0.0);
					    u_xlat2.xyz = u_xlat2.xyz * vec3(_Bumpiness);
					    u_xlat2.xyz = clamp(u_xlat2.xyz, 0.0, 1.0);
					    u_xlat3.xyz = u_xlat2.xyz + vec3(0.0, 0.0, 1.0);
					    u_xlat2.xyz = u_xlat2.xyz * in_NORMAL0.xyz;
					    u_xlat12 = dot(u_xlat3.xyz, u_xlat1.xyz);
					    u_xlat1.xyz = vec3(u_xlat12) * u_xlat3.xyz;
					    u_xlat1.xyz = u_xlat1.xyz / u_xlat3.zzz;
					    u_xlat0.xyz = (-u_xlat0.xyz) * vec3(-1.0, -1.0, 1.0) + u_xlat1.xyz;
					    u_xlat0.x = dot(u_xlat0.xyz, vec3(0.300000012, 0.589999974, 0.109999999));
					    u_xlat0.xyz = u_xlat2.xyz * u_xlat0.xxx + (-u_xlat2.xyz);
					    u_xlat0.xyz = vec3(vec3(_BumpAttune, _BumpAttune, _BumpAttune)) * u_xlat0.xyz + u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz + in_POSITION0.xyz;
					    u_xlat1 = u_xlat0.yyyy * unity_ObjectToWorld[1];
					    u_xlat1 = unity_ObjectToWorld[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat0 = unity_ObjectToWorld[2] * u_xlat0.zzzz + u_xlat1;
					    u_xlat1 = u_xlat0 + unity_ObjectToWorld[3];
					    vs_TEXCOORD3 = unity_ObjectToWorld[3] * in_POSITION0.wwww + u_xlat0;
					    u_xlat0 = u_xlat1.yyyy * unity_MatrixVP[1];
					    u_xlat0 = unity_MatrixVP[0] * u_xlat1.xxxx + u_xlat0;
					    u_xlat0 = unity_MatrixVP[2] * u_xlat1.zzzz + u_xlat0;
					    u_xlat0 = unity_MatrixVP[3] * u_xlat1.wwww + u_xlat0;
					    gl_Position = u_xlat0;
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
					    vs_TEXCOORD1.xy = in_TEXCOORD1.xy;
					    vs_TEXCOORD2.xy = in_TEXCOORD2.xy;
					    u_xlat1.x = dot(in_NORMAL0.xyz, unity_WorldToObject[0].xyz);
					    u_xlat1.y = dot(in_NORMAL0.xyz, unity_WorldToObject[1].xyz);
					    u_xlat1.z = dot(in_NORMAL0.xyz, unity_WorldToObject[2].xyz);
					    u_xlat13 = dot(u_xlat1.xyz, u_xlat1.xyz);
					    u_xlat13 = inversesqrt(u_xlat13);
					    u_xlat1.xyz = vec3(u_xlat13) * u_xlat1.xyz;
					    vs_TEXCOORD4.xyz = u_xlat1.xyz;
					    u_xlat2.xyz = in_TANGENT0.yyy * unity_ObjectToWorld[1].xyz;
					    u_xlat2.xyz = unity_ObjectToWorld[0].xyz * in_TANGENT0.xxx + u_xlat2.xyz;
					    u_xlat2.xyz = unity_ObjectToWorld[2].xyz * in_TANGENT0.zzz + u_xlat2.xyz;
					    u_xlat13 = dot(u_xlat2.xyz, u_xlat2.xyz);
					    u_xlat13 = inversesqrt(u_xlat13);
					    u_xlat2.xyz = vec3(u_xlat13) * u_xlat2.xyz;
					    vs_TEXCOORD5.xyz = u_xlat2.xyz;
					    u_xlat3.xyz = u_xlat1.zxy * u_xlat2.yzx;
					    u_xlat1.xyz = u_xlat1.yzx * u_xlat2.zxy + (-u_xlat3.xyz);
					    u_xlat1.xyz = u_xlat1.xyz * in_TANGENT0.www;
					    u_xlat13 = dot(u_xlat1.xyz, u_xlat1.xyz);
					    u_xlat13 = inversesqrt(u_xlat13);
					    vs_TEXCOORD6.xyz = vec3(u_xlat13) * u_xlat1.xyz;
					    u_xlat0.y = u_xlat0.y * _ProjectionParams.x;
					    u_xlat1.xzw = u_xlat0.xwy * vec3(0.5, 0.5, 0.5);
					    vs_TEXCOORD8.zw = u_xlat0.zw;
					    vs_TEXCOORD8.xy = u_xlat1.zz + u_xlat1.xw;
					    vs_TEXCOORD10 = vec4(0.0, 0.0, 0.0, 0.0);
					    return;
					}"
				}
				SubProgram "d3d11 " {
					Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "LIGHTPROBE_SH" "VERTEXLIGHT_ON" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "DYNAMICLIGHTMAP_OFF" }
					"vs_4_0
					
					#version 330
					#extension GL_ARB_explicit_attrib_location : require
					#extension GL_ARB_explicit_uniform_location : require
					
					#define HLSLCC_ENABLE_UNIFORM_BUFFERS 1
					#if HLSLCC_ENABLE_UNIFORM_BUFFERS
					#define UNITY_UNIFORM
					#else
					#define UNITY_UNIFORM uniform
					#endif
					#define UNITY_SUPPORTS_UNIFORM_LOCATION 1
					#if UNITY_SUPPORTS_UNIFORM_LOCATION
					#define UNITY_LOCATION(x) layout(location = x)
					#define UNITY_BINDING(x) layout(binding = x, std140)
					#else
					#define UNITY_LOCATION(x)
					#define UNITY_BINDING(x) layout(std140)
					#endif
					layout(std140) uniform VGlobals {
						vec4 unused_0_0[4];
						vec4 _MainTexture_ST;
						vec4 unused_0_2[2];
						vec4 _Color;
						vec4 _Heightmap_ST;
						float _Bumpiness;
						vec4 unused_0_6;
						float _BumpAttune;
					};
					layout(std140) uniform UnityPerCamera {
						vec4 unused_1_0[5];
						vec4 _ProjectionParams;
						vec4 unused_1_2[3];
					};
					layout(std140) uniform UnityPerDraw {
						mat4x4 unity_ObjectToWorld;
						mat4x4 unity_WorldToObject;
						vec4 unused_2_2[2];
					};
					layout(std140) uniform UnityPerFrame {
						vec4 unused_3_0[17];
						mat4x4 unity_MatrixVP;
						vec4 unused_3_2[2];
					};
					uniform  sampler2D _Heightmap;
					uniform  sampler2D _MainTexture;
					in  vec4 in_POSITION0;
					in  vec3 in_NORMAL0;
					in  vec4 in_TANGENT0;
					in  vec2 in_TEXCOORD0;
					in  vec2 in_TEXCOORD1;
					in  vec2 in_TEXCOORD2;
					out vec2 vs_TEXCOORD0;
					out vec2 vs_TEXCOORD1;
					out vec2 vs_TEXCOORD2;
					out vec4 vs_TEXCOORD3;
					out vec3 vs_TEXCOORD4;
					out vec3 vs_TEXCOORD5;
					out vec3 vs_TEXCOORD6;
					out vec4 vs_TEXCOORD8;
					out vec4 vs_TEXCOORD10;
					vec4 u_xlat0;
					vec4 u_xlat1;
					vec4 u_xlat2;
					vec3 u_xlat3;
					float u_xlat12;
					float u_xlat13;
					void main()
					{
					    u_xlat0.xy = in_TEXCOORD0.xy * _MainTexture_ST.xy + _MainTexture_ST.zw;
					    u_xlat0 = textureLod(_MainTexture, u_xlat0.xy, 0.0);
					    u_xlat0.xyz = u_xlat0.xyz * _Color.xyz;
					    u_xlat1.xyz = u_xlat0.xyz * vec3(-1.0, -1.0, 1.0);
					    u_xlat2.xy = in_TEXCOORD0.xy * _Heightmap_ST.xy + _Heightmap_ST.zw;
					    u_xlat2 = textureLod(_Heightmap, u_xlat2.xy, 0.0);
					    u_xlat2.xyz = u_xlat2.xyz * vec3(_Bumpiness);
					    u_xlat2.xyz = clamp(u_xlat2.xyz, 0.0, 1.0);
					    u_xlat3.xyz = u_xlat2.xyz + vec3(0.0, 0.0, 1.0);
					    u_xlat2.xyz = u_xlat2.xyz * in_NORMAL0.xyz;
					    u_xlat12 = dot(u_xlat3.xyz, u_xlat1.xyz);
					    u_xlat1.xyz = vec3(u_xlat12) * u_xlat3.xyz;
					    u_xlat1.xyz = u_xlat1.xyz / u_xlat3.zzz;
					    u_xlat0.xyz = (-u_xlat0.xyz) * vec3(-1.0, -1.0, 1.0) + u_xlat1.xyz;
					    u_xlat0.x = dot(u_xlat0.xyz, vec3(0.300000012, 0.589999974, 0.109999999));
					    u_xlat0.xyz = u_xlat2.xyz * u_xlat0.xxx + (-u_xlat2.xyz);
					    u_xlat0.xyz = vec3(vec3(_BumpAttune, _BumpAttune, _BumpAttune)) * u_xlat0.xyz + u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz + in_POSITION0.xyz;
					    u_xlat1 = u_xlat0.yyyy * unity_ObjectToWorld[1];
					    u_xlat1 = unity_ObjectToWorld[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat0 = unity_ObjectToWorld[2] * u_xlat0.zzzz + u_xlat1;
					    u_xlat1 = u_xlat0 + unity_ObjectToWorld[3];
					    vs_TEXCOORD3 = unity_ObjectToWorld[3] * in_POSITION0.wwww + u_xlat0;
					    u_xlat0 = u_xlat1.yyyy * unity_MatrixVP[1];
					    u_xlat0 = unity_MatrixVP[0] * u_xlat1.xxxx + u_xlat0;
					    u_xlat0 = unity_MatrixVP[2] * u_xlat1.zzzz + u_xlat0;
					    u_xlat0 = unity_MatrixVP[3] * u_xlat1.wwww + u_xlat0;
					    gl_Position = u_xlat0;
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
					    vs_TEXCOORD1.xy = in_TEXCOORD1.xy;
					    vs_TEXCOORD2.xy = in_TEXCOORD2.xy;
					    u_xlat1.x = dot(in_NORMAL0.xyz, unity_WorldToObject[0].xyz);
					    u_xlat1.y = dot(in_NORMAL0.xyz, unity_WorldToObject[1].xyz);
					    u_xlat1.z = dot(in_NORMAL0.xyz, unity_WorldToObject[2].xyz);
					    u_xlat13 = dot(u_xlat1.xyz, u_xlat1.xyz);
					    u_xlat13 = inversesqrt(u_xlat13);
					    u_xlat1.xyz = vec3(u_xlat13) * u_xlat1.xyz;
					    vs_TEXCOORD4.xyz = u_xlat1.xyz;
					    u_xlat2.xyz = in_TANGENT0.yyy * unity_ObjectToWorld[1].xyz;
					    u_xlat2.xyz = unity_ObjectToWorld[0].xyz * in_TANGENT0.xxx + u_xlat2.xyz;
					    u_xlat2.xyz = unity_ObjectToWorld[2].xyz * in_TANGENT0.zzz + u_xlat2.xyz;
					    u_xlat13 = dot(u_xlat2.xyz, u_xlat2.xyz);
					    u_xlat13 = inversesqrt(u_xlat13);
					    u_xlat2.xyz = vec3(u_xlat13) * u_xlat2.xyz;
					    vs_TEXCOORD5.xyz = u_xlat2.xyz;
					    u_xlat3.xyz = u_xlat1.zxy * u_xlat2.yzx;
					    u_xlat1.xyz = u_xlat1.yzx * u_xlat2.zxy + (-u_xlat3.xyz);
					    u_xlat1.xyz = u_xlat1.xyz * in_TANGENT0.www;
					    u_xlat13 = dot(u_xlat1.xyz, u_xlat1.xyz);
					    u_xlat13 = inversesqrt(u_xlat13);
					    vs_TEXCOORD6.xyz = vec3(u_xlat13) * u_xlat1.xyz;
					    u_xlat0.y = u_xlat0.y * _ProjectionParams.x;
					    u_xlat1.xzw = u_xlat0.xwy * vec3(0.5, 0.5, 0.5);
					    vs_TEXCOORD8.zw = u_xlat0.zw;
					    vs_TEXCOORD8.xy = u_xlat1.zz + u_xlat1.xw;
					    vs_TEXCOORD10 = vec4(0.0, 0.0, 0.0, 0.0);
					    return;
					}"
				}
				SubProgram "d3d11 " {
					Keywords { "DIRECTIONAL" "DIRLIGHTMAP_COMBINED" "LIGHTMAP_OFF" "DYNAMICLIGHTMAP_OFF" }
					"vs_4_0
					
					#version 330
					#extension GL_ARB_explicit_attrib_location : require
					#extension GL_ARB_explicit_uniform_location : require
					
					#define HLSLCC_ENABLE_UNIFORM_BUFFERS 1
					#if HLSLCC_ENABLE_UNIFORM_BUFFERS
					#define UNITY_UNIFORM
					#else
					#define UNITY_UNIFORM uniform
					#endif
					#define UNITY_SUPPORTS_UNIFORM_LOCATION 1
					#if UNITY_SUPPORTS_UNIFORM_LOCATION
					#define UNITY_LOCATION(x) layout(location = x)
					#define UNITY_BINDING(x) layout(binding = x, std140)
					#else
					#define UNITY_LOCATION(x)
					#define UNITY_BINDING(x) layout(std140)
					#endif
					layout(std140) uniform VGlobals {
						vec4 unused_0_0[4];
						vec4 _MainTexture_ST;
						vec4 unused_0_2[2];
						vec4 _Color;
						vec4 _Heightmap_ST;
						float _Bumpiness;
						vec4 unused_0_6;
						float _BumpAttune;
					};
					layout(std140) uniform UnityPerDraw {
						mat4x4 unity_ObjectToWorld;
						mat4x4 unity_WorldToObject;
						vec4 unused_1_2[2];
					};
					layout(std140) uniform UnityPerFrame {
						vec4 unused_2_0[17];
						mat4x4 unity_MatrixVP;
						vec4 unused_2_2[2];
					};
					uniform  sampler2D _Heightmap;
					uniform  sampler2D _MainTexture;
					in  vec4 in_POSITION0;
					in  vec3 in_NORMAL0;
					in  vec4 in_TANGENT0;
					in  vec2 in_TEXCOORD0;
					in  vec2 in_TEXCOORD1;
					in  vec2 in_TEXCOORD2;
					out vec2 vs_TEXCOORD0;
					out vec2 vs_TEXCOORD1;
					out vec2 vs_TEXCOORD2;
					out vec4 vs_TEXCOORD3;
					out vec3 vs_TEXCOORD4;
					out vec3 vs_TEXCOORD5;
					out vec3 vs_TEXCOORD6;
					out vec4 vs_TEXCOORD10;
					vec4 u_xlat0;
					vec4 u_xlat1;
					vec4 u_xlat2;
					vec3 u_xlat3;
					float u_xlat12;
					void main()
					{
					    u_xlat0.xy = in_TEXCOORD0.xy * _MainTexture_ST.xy + _MainTexture_ST.zw;
					    u_xlat0 = textureLod(_MainTexture, u_xlat0.xy, 0.0);
					    u_xlat0.xyz = u_xlat0.xyz * _Color.xyz;
					    u_xlat1.xyz = u_xlat0.xyz * vec3(-1.0, -1.0, 1.0);
					    u_xlat2.xy = in_TEXCOORD0.xy * _Heightmap_ST.xy + _Heightmap_ST.zw;
					    u_xlat2 = textureLod(_Heightmap, u_xlat2.xy, 0.0);
					    u_xlat2.xyz = u_xlat2.xyz * vec3(_Bumpiness);
					    u_xlat2.xyz = clamp(u_xlat2.xyz, 0.0, 1.0);
					    u_xlat3.xyz = u_xlat2.xyz + vec3(0.0, 0.0, 1.0);
					    u_xlat2.xyz = u_xlat2.xyz * in_NORMAL0.xyz;
					    u_xlat12 = dot(u_xlat3.xyz, u_xlat1.xyz);
					    u_xlat1.xyz = vec3(u_xlat12) * u_xlat3.xyz;
					    u_xlat1.xyz = u_xlat1.xyz / u_xlat3.zzz;
					    u_xlat0.xyz = (-u_xlat0.xyz) * vec3(-1.0, -1.0, 1.0) + u_xlat1.xyz;
					    u_xlat0.x = dot(u_xlat0.xyz, vec3(0.300000012, 0.589999974, 0.109999999));
					    u_xlat0.xyz = u_xlat2.xyz * u_xlat0.xxx + (-u_xlat2.xyz);
					    u_xlat0.xyz = vec3(vec3(_BumpAttune, _BumpAttune, _BumpAttune)) * u_xlat0.xyz + u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz + in_POSITION0.xyz;
					    u_xlat1 = u_xlat0.yyyy * unity_ObjectToWorld[1];
					    u_xlat1 = unity_ObjectToWorld[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat0 = unity_ObjectToWorld[2] * u_xlat0.zzzz + u_xlat1;
					    u_xlat1 = u_xlat0 + unity_ObjectToWorld[3];
					    vs_TEXCOORD3 = unity_ObjectToWorld[3] * in_POSITION0.wwww + u_xlat0;
					    u_xlat0 = u_xlat1.yyyy * unity_MatrixVP[1];
					    u_xlat0 = unity_MatrixVP[0] * u_xlat1.xxxx + u_xlat0;
					    u_xlat0 = unity_MatrixVP[2] * u_xlat1.zzzz + u_xlat0;
					    gl_Position = unity_MatrixVP[3] * u_xlat1.wwww + u_xlat0;
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
					    vs_TEXCOORD1.xy = in_TEXCOORD1.xy;
					    vs_TEXCOORD2.xy = in_TEXCOORD2.xy;
					    u_xlat0.x = dot(in_NORMAL0.xyz, unity_WorldToObject[0].xyz);
					    u_xlat0.y = dot(in_NORMAL0.xyz, unity_WorldToObject[1].xyz);
					    u_xlat0.z = dot(in_NORMAL0.xyz, unity_WorldToObject[2].xyz);
					    u_xlat12 = dot(u_xlat0.xyz, u_xlat0.xyz);
					    u_xlat12 = inversesqrt(u_xlat12);
					    u_xlat0.xyz = vec3(u_xlat12) * u_xlat0.xyz;
					    vs_TEXCOORD4.xyz = u_xlat0.xyz;
					    u_xlat1.xyz = in_TANGENT0.yyy * unity_ObjectToWorld[1].xyz;
					    u_xlat1.xyz = unity_ObjectToWorld[0].xyz * in_TANGENT0.xxx + u_xlat1.xyz;
					    u_xlat1.xyz = unity_ObjectToWorld[2].xyz * in_TANGENT0.zzz + u_xlat1.xyz;
					    u_xlat12 = dot(u_xlat1.xyz, u_xlat1.xyz);
					    u_xlat12 = inversesqrt(u_xlat12);
					    u_xlat1.xyz = vec3(u_xlat12) * u_xlat1.xyz;
					    vs_TEXCOORD5.xyz = u_xlat1.xyz;
					    u_xlat2.xyz = u_xlat0.zxy * u_xlat1.yzx;
					    u_xlat0.xyz = u_xlat0.yzx * u_xlat1.zxy + (-u_xlat2.xyz);
					    u_xlat0.xyz = u_xlat0.xyz * in_TANGENT0.www;
					    u_xlat12 = dot(u_xlat0.xyz, u_xlat0.xyz);
					    u_xlat12 = inversesqrt(u_xlat12);
					    vs_TEXCOORD6.xyz = vec3(u_xlat12) * u_xlat0.xyz;
					    vs_TEXCOORD10 = vec4(0.0, 0.0, 0.0, 0.0);
					    return;
					}"
				}
				SubProgram "d3d11 " {
					Keywords { "DIRECTIONAL" "DIRLIGHTMAP_COMBINED" "LIGHTPROBE_SH" "LIGHTMAP_OFF" "DYNAMICLIGHTMAP_OFF" }
					"vs_4_0
					
					#version 330
					#extension GL_ARB_explicit_attrib_location : require
					#extension GL_ARB_explicit_uniform_location : require
					
					#define HLSLCC_ENABLE_UNIFORM_BUFFERS 1
					#if HLSLCC_ENABLE_UNIFORM_BUFFERS
					#define UNITY_UNIFORM
					#else
					#define UNITY_UNIFORM uniform
					#endif
					#define UNITY_SUPPORTS_UNIFORM_LOCATION 1
					#if UNITY_SUPPORTS_UNIFORM_LOCATION
					#define UNITY_LOCATION(x) layout(location = x)
					#define UNITY_BINDING(x) layout(binding = x, std140)
					#else
					#define UNITY_LOCATION(x)
					#define UNITY_BINDING(x) layout(std140)
					#endif
					layout(std140) uniform VGlobals {
						vec4 unused_0_0[4];
						vec4 _MainTexture_ST;
						vec4 unused_0_2[2];
						vec4 _Color;
						vec4 _Heightmap_ST;
						float _Bumpiness;
						vec4 unused_0_6;
						float _BumpAttune;
					};
					layout(std140) uniform UnityPerDraw {
						mat4x4 unity_ObjectToWorld;
						mat4x4 unity_WorldToObject;
						vec4 unused_1_2[2];
					};
					layout(std140) uniform UnityPerFrame {
						vec4 unused_2_0[17];
						mat4x4 unity_MatrixVP;
						vec4 unused_2_2[2];
					};
					uniform  sampler2D _Heightmap;
					uniform  sampler2D _MainTexture;
					in  vec4 in_POSITION0;
					in  vec3 in_NORMAL0;
					in  vec4 in_TANGENT0;
					in  vec2 in_TEXCOORD0;
					in  vec2 in_TEXCOORD1;
					in  vec2 in_TEXCOORD2;
					out vec2 vs_TEXCOORD0;
					out vec2 vs_TEXCOORD1;
					out vec2 vs_TEXCOORD2;
					out vec4 vs_TEXCOORD3;
					out vec3 vs_TEXCOORD4;
					out vec3 vs_TEXCOORD5;
					out vec3 vs_TEXCOORD6;
					out vec4 vs_TEXCOORD10;
					vec4 u_xlat0;
					vec4 u_xlat1;
					vec4 u_xlat2;
					vec3 u_xlat3;
					float u_xlat12;
					void main()
					{
					    u_xlat0.xy = in_TEXCOORD0.xy * _MainTexture_ST.xy + _MainTexture_ST.zw;
					    u_xlat0 = textureLod(_MainTexture, u_xlat0.xy, 0.0);
					    u_xlat0.xyz = u_xlat0.xyz * _Color.xyz;
					    u_xlat1.xyz = u_xlat0.xyz * vec3(-1.0, -1.0, 1.0);
					    u_xlat2.xy = in_TEXCOORD0.xy * _Heightmap_ST.xy + _Heightmap_ST.zw;
					    u_xlat2 = textureLod(_Heightmap, u_xlat2.xy, 0.0);
					    u_xlat2.xyz = u_xlat2.xyz * vec3(_Bumpiness);
					    u_xlat2.xyz = clamp(u_xlat2.xyz, 0.0, 1.0);
					    u_xlat3.xyz = u_xlat2.xyz + vec3(0.0, 0.0, 1.0);
					    u_xlat2.xyz = u_xlat2.xyz * in_NORMAL0.xyz;
					    u_xlat12 = dot(u_xlat3.xyz, u_xlat1.xyz);
					    u_xlat1.xyz = vec3(u_xlat12) * u_xlat3.xyz;
					    u_xlat1.xyz = u_xlat1.xyz / u_xlat3.zzz;
					    u_xlat0.xyz = (-u_xlat0.xyz) * vec3(-1.0, -1.0, 1.0) + u_xlat1.xyz;
					    u_xlat0.x = dot(u_xlat0.xyz, vec3(0.300000012, 0.589999974, 0.109999999));
					    u_xlat0.xyz = u_xlat2.xyz * u_xlat0.xxx + (-u_xlat2.xyz);
					    u_xlat0.xyz = vec3(vec3(_BumpAttune, _BumpAttune, _BumpAttune)) * u_xlat0.xyz + u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz + in_POSITION0.xyz;
					    u_xlat1 = u_xlat0.yyyy * unity_ObjectToWorld[1];
					    u_xlat1 = unity_ObjectToWorld[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat0 = unity_ObjectToWorld[2] * u_xlat0.zzzz + u_xlat1;
					    u_xlat1 = u_xlat0 + unity_ObjectToWorld[3];
					    vs_TEXCOORD3 = unity_ObjectToWorld[3] * in_POSITION0.wwww + u_xlat0;
					    u_xlat0 = u_xlat1.yyyy * unity_MatrixVP[1];
					    u_xlat0 = unity_MatrixVP[0] * u_xlat1.xxxx + u_xlat0;
					    u_xlat0 = unity_MatrixVP[2] * u_xlat1.zzzz + u_xlat0;
					    gl_Position = unity_MatrixVP[3] * u_xlat1.wwww + u_xlat0;
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
					    vs_TEXCOORD1.xy = in_TEXCOORD1.xy;
					    vs_TEXCOORD2.xy = in_TEXCOORD2.xy;
					    u_xlat0.x = dot(in_NORMAL0.xyz, unity_WorldToObject[0].xyz);
					    u_xlat0.y = dot(in_NORMAL0.xyz, unity_WorldToObject[1].xyz);
					    u_xlat0.z = dot(in_NORMAL0.xyz, unity_WorldToObject[2].xyz);
					    u_xlat12 = dot(u_xlat0.xyz, u_xlat0.xyz);
					    u_xlat12 = inversesqrt(u_xlat12);
					    u_xlat0.xyz = vec3(u_xlat12) * u_xlat0.xyz;
					    vs_TEXCOORD4.xyz = u_xlat0.xyz;
					    u_xlat1.xyz = in_TANGENT0.yyy * unity_ObjectToWorld[1].xyz;
					    u_xlat1.xyz = unity_ObjectToWorld[0].xyz * in_TANGENT0.xxx + u_xlat1.xyz;
					    u_xlat1.xyz = unity_ObjectToWorld[2].xyz * in_TANGENT0.zzz + u_xlat1.xyz;
					    u_xlat12 = dot(u_xlat1.xyz, u_xlat1.xyz);
					    u_xlat12 = inversesqrt(u_xlat12);
					    u_xlat1.xyz = vec3(u_xlat12) * u_xlat1.xyz;
					    vs_TEXCOORD5.xyz = u_xlat1.xyz;
					    u_xlat2.xyz = u_xlat0.zxy * u_xlat1.yzx;
					    u_xlat0.xyz = u_xlat0.yzx * u_xlat1.zxy + (-u_xlat2.xyz);
					    u_xlat0.xyz = u_xlat0.xyz * in_TANGENT0.www;
					    u_xlat12 = dot(u_xlat0.xyz, u_xlat0.xyz);
					    u_xlat12 = inversesqrt(u_xlat12);
					    vs_TEXCOORD6.xyz = vec3(u_xlat12) * u_xlat0.xyz;
					    vs_TEXCOORD10 = vec4(0.0, 0.0, 0.0, 0.0);
					    return;
					}"
				}
				SubProgram "d3d11 " {
					Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "DIRLIGHTMAP_COMBINED" "LIGHTMAP_OFF" "DYNAMICLIGHTMAP_OFF" }
					"vs_4_0
					
					#version 330
					#extension GL_ARB_explicit_attrib_location : require
					#extension GL_ARB_explicit_uniform_location : require
					
					#define HLSLCC_ENABLE_UNIFORM_BUFFERS 1
					#if HLSLCC_ENABLE_UNIFORM_BUFFERS
					#define UNITY_UNIFORM
					#else
					#define UNITY_UNIFORM uniform
					#endif
					#define UNITY_SUPPORTS_UNIFORM_LOCATION 1
					#if UNITY_SUPPORTS_UNIFORM_LOCATION
					#define UNITY_LOCATION(x) layout(location = x)
					#define UNITY_BINDING(x) layout(binding = x, std140)
					#else
					#define UNITY_LOCATION(x)
					#define UNITY_BINDING(x) layout(std140)
					#endif
					layout(std140) uniform VGlobals {
						vec4 unused_0_0[4];
						vec4 _MainTexture_ST;
						vec4 unused_0_2[2];
						vec4 _Color;
						vec4 _Heightmap_ST;
						float _Bumpiness;
						vec4 unused_0_6;
						float _BumpAttune;
					};
					layout(std140) uniform UnityPerCamera {
						vec4 unused_1_0[5];
						vec4 _ProjectionParams;
						vec4 unused_1_2[3];
					};
					layout(std140) uniform UnityPerDraw {
						mat4x4 unity_ObjectToWorld;
						mat4x4 unity_WorldToObject;
						vec4 unused_2_2[2];
					};
					layout(std140) uniform UnityPerFrame {
						vec4 unused_3_0[17];
						mat4x4 unity_MatrixVP;
						vec4 unused_3_2[2];
					};
					uniform  sampler2D _Heightmap;
					uniform  sampler2D _MainTexture;
					in  vec4 in_POSITION0;
					in  vec3 in_NORMAL0;
					in  vec4 in_TANGENT0;
					in  vec2 in_TEXCOORD0;
					in  vec2 in_TEXCOORD1;
					in  vec2 in_TEXCOORD2;
					out vec2 vs_TEXCOORD0;
					out vec2 vs_TEXCOORD1;
					out vec2 vs_TEXCOORD2;
					out vec4 vs_TEXCOORD3;
					out vec3 vs_TEXCOORD4;
					out vec3 vs_TEXCOORD5;
					out vec3 vs_TEXCOORD6;
					out vec4 vs_TEXCOORD8;
					out vec4 vs_TEXCOORD10;
					vec4 u_xlat0;
					vec4 u_xlat1;
					vec4 u_xlat2;
					vec3 u_xlat3;
					float u_xlat12;
					float u_xlat13;
					void main()
					{
					    u_xlat0.xy = in_TEXCOORD0.xy * _MainTexture_ST.xy + _MainTexture_ST.zw;
					    u_xlat0 = textureLod(_MainTexture, u_xlat0.xy, 0.0);
					    u_xlat0.xyz = u_xlat0.xyz * _Color.xyz;
					    u_xlat1.xyz = u_xlat0.xyz * vec3(-1.0, -1.0, 1.0);
					    u_xlat2.xy = in_TEXCOORD0.xy * _Heightmap_ST.xy + _Heightmap_ST.zw;
					    u_xlat2 = textureLod(_Heightmap, u_xlat2.xy, 0.0);
					    u_xlat2.xyz = u_xlat2.xyz * vec3(_Bumpiness);
					    u_xlat2.xyz = clamp(u_xlat2.xyz, 0.0, 1.0);
					    u_xlat3.xyz = u_xlat2.xyz + vec3(0.0, 0.0, 1.0);
					    u_xlat2.xyz = u_xlat2.xyz * in_NORMAL0.xyz;
					    u_xlat12 = dot(u_xlat3.xyz, u_xlat1.xyz);
					    u_xlat1.xyz = vec3(u_xlat12) * u_xlat3.xyz;
					    u_xlat1.xyz = u_xlat1.xyz / u_xlat3.zzz;
					    u_xlat0.xyz = (-u_xlat0.xyz) * vec3(-1.0, -1.0, 1.0) + u_xlat1.xyz;
					    u_xlat0.x = dot(u_xlat0.xyz, vec3(0.300000012, 0.589999974, 0.109999999));
					    u_xlat0.xyz = u_xlat2.xyz * u_xlat0.xxx + (-u_xlat2.xyz);
					    u_xlat0.xyz = vec3(vec3(_BumpAttune, _BumpAttune, _BumpAttune)) * u_xlat0.xyz + u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz + in_POSITION0.xyz;
					    u_xlat1 = u_xlat0.yyyy * unity_ObjectToWorld[1];
					    u_xlat1 = unity_ObjectToWorld[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat0 = unity_ObjectToWorld[2] * u_xlat0.zzzz + u_xlat1;
					    u_xlat1 = u_xlat0 + unity_ObjectToWorld[3];
					    vs_TEXCOORD3 = unity_ObjectToWorld[3] * in_POSITION0.wwww + u_xlat0;
					    u_xlat0 = u_xlat1.yyyy * unity_MatrixVP[1];
					    u_xlat0 = unity_MatrixVP[0] * u_xlat1.xxxx + u_xlat0;
					    u_xlat0 = unity_MatrixVP[2] * u_xlat1.zzzz + u_xlat0;
					    u_xlat0 = unity_MatrixVP[3] * u_xlat1.wwww + u_xlat0;
					    gl_Position = u_xlat0;
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
					    vs_TEXCOORD1.xy = in_TEXCOORD1.xy;
					    vs_TEXCOORD2.xy = in_TEXCOORD2.xy;
					    u_xlat1.x = dot(in_NORMAL0.xyz, unity_WorldToObject[0].xyz);
					    u_xlat1.y = dot(in_NORMAL0.xyz, unity_WorldToObject[1].xyz);
					    u_xlat1.z = dot(in_NORMAL0.xyz, unity_WorldToObject[2].xyz);
					    u_xlat13 = dot(u_xlat1.xyz, u_xlat1.xyz);
					    u_xlat13 = inversesqrt(u_xlat13);
					    u_xlat1.xyz = vec3(u_xlat13) * u_xlat1.xyz;
					    vs_TEXCOORD4.xyz = u_xlat1.xyz;
					    u_xlat2.xyz = in_TANGENT0.yyy * unity_ObjectToWorld[1].xyz;
					    u_xlat2.xyz = unity_ObjectToWorld[0].xyz * in_TANGENT0.xxx + u_xlat2.xyz;
					    u_xlat2.xyz = unity_ObjectToWorld[2].xyz * in_TANGENT0.zzz + u_xlat2.xyz;
					    u_xlat13 = dot(u_xlat2.xyz, u_xlat2.xyz);
					    u_xlat13 = inversesqrt(u_xlat13);
					    u_xlat2.xyz = vec3(u_xlat13) * u_xlat2.xyz;
					    vs_TEXCOORD5.xyz = u_xlat2.xyz;
					    u_xlat3.xyz = u_xlat1.zxy * u_xlat2.yzx;
					    u_xlat1.xyz = u_xlat1.yzx * u_xlat2.zxy + (-u_xlat3.xyz);
					    u_xlat1.xyz = u_xlat1.xyz * in_TANGENT0.www;
					    u_xlat13 = dot(u_xlat1.xyz, u_xlat1.xyz);
					    u_xlat13 = inversesqrt(u_xlat13);
					    vs_TEXCOORD6.xyz = vec3(u_xlat13) * u_xlat1.xyz;
					    u_xlat0.y = u_xlat0.y * _ProjectionParams.x;
					    u_xlat1.xzw = u_xlat0.xwy * vec3(0.5, 0.5, 0.5);
					    vs_TEXCOORD8.zw = u_xlat0.zw;
					    vs_TEXCOORD8.xy = u_xlat1.zz + u_xlat1.xw;
					    vs_TEXCOORD10 = vec4(0.0, 0.0, 0.0, 0.0);
					    return;
					}"
				}
				SubProgram "d3d11 " {
					Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "DIRLIGHTMAP_COMBINED" "LIGHTPROBE_SH" "LIGHTMAP_OFF" "DYNAMICLIGHTMAP_OFF" }
					"vs_4_0
					
					#version 330
					#extension GL_ARB_explicit_attrib_location : require
					#extension GL_ARB_explicit_uniform_location : require
					
					#define HLSLCC_ENABLE_UNIFORM_BUFFERS 1
					#if HLSLCC_ENABLE_UNIFORM_BUFFERS
					#define UNITY_UNIFORM
					#else
					#define UNITY_UNIFORM uniform
					#endif
					#define UNITY_SUPPORTS_UNIFORM_LOCATION 1
					#if UNITY_SUPPORTS_UNIFORM_LOCATION
					#define UNITY_LOCATION(x) layout(location = x)
					#define UNITY_BINDING(x) layout(binding = x, std140)
					#else
					#define UNITY_LOCATION(x)
					#define UNITY_BINDING(x) layout(std140)
					#endif
					layout(std140) uniform VGlobals {
						vec4 unused_0_0[4];
						vec4 _MainTexture_ST;
						vec4 unused_0_2[2];
						vec4 _Color;
						vec4 _Heightmap_ST;
						float _Bumpiness;
						vec4 unused_0_6;
						float _BumpAttune;
					};
					layout(std140) uniform UnityPerCamera {
						vec4 unused_1_0[5];
						vec4 _ProjectionParams;
						vec4 unused_1_2[3];
					};
					layout(std140) uniform UnityPerDraw {
						mat4x4 unity_ObjectToWorld;
						mat4x4 unity_WorldToObject;
						vec4 unused_2_2[2];
					};
					layout(std140) uniform UnityPerFrame {
						vec4 unused_3_0[17];
						mat4x4 unity_MatrixVP;
						vec4 unused_3_2[2];
					};
					uniform  sampler2D _Heightmap;
					uniform  sampler2D _MainTexture;
					in  vec4 in_POSITION0;
					in  vec3 in_NORMAL0;
					in  vec4 in_TANGENT0;
					in  vec2 in_TEXCOORD0;
					in  vec2 in_TEXCOORD1;
					in  vec2 in_TEXCOORD2;
					out vec2 vs_TEXCOORD0;
					out vec2 vs_TEXCOORD1;
					out vec2 vs_TEXCOORD2;
					out vec4 vs_TEXCOORD3;
					out vec3 vs_TEXCOORD4;
					out vec3 vs_TEXCOORD5;
					out vec3 vs_TEXCOORD6;
					out vec4 vs_TEXCOORD8;
					out vec4 vs_TEXCOORD10;
					vec4 u_xlat0;
					vec4 u_xlat1;
					vec4 u_xlat2;
					vec3 u_xlat3;
					float u_xlat12;
					float u_xlat13;
					void main()
					{
					    u_xlat0.xy = in_TEXCOORD0.xy * _MainTexture_ST.xy + _MainTexture_ST.zw;
					    u_xlat0 = textureLod(_MainTexture, u_xlat0.xy, 0.0);
					    u_xlat0.xyz = u_xlat0.xyz * _Color.xyz;
					    u_xlat1.xyz = u_xlat0.xyz * vec3(-1.0, -1.0, 1.0);
					    u_xlat2.xy = in_TEXCOORD0.xy * _Heightmap_ST.xy + _Heightmap_ST.zw;
					    u_xlat2 = textureLod(_Heightmap, u_xlat2.xy, 0.0);
					    u_xlat2.xyz = u_xlat2.xyz * vec3(_Bumpiness);
					    u_xlat2.xyz = clamp(u_xlat2.xyz, 0.0, 1.0);
					    u_xlat3.xyz = u_xlat2.xyz + vec3(0.0, 0.0, 1.0);
					    u_xlat2.xyz = u_xlat2.xyz * in_NORMAL0.xyz;
					    u_xlat12 = dot(u_xlat3.xyz, u_xlat1.xyz);
					    u_xlat1.xyz = vec3(u_xlat12) * u_xlat3.xyz;
					    u_xlat1.xyz = u_xlat1.xyz / u_xlat3.zzz;
					    u_xlat0.xyz = (-u_xlat0.xyz) * vec3(-1.0, -1.0, 1.0) + u_xlat1.xyz;
					    u_xlat0.x = dot(u_xlat0.xyz, vec3(0.300000012, 0.589999974, 0.109999999));
					    u_xlat0.xyz = u_xlat2.xyz * u_xlat0.xxx + (-u_xlat2.xyz);
					    u_xlat0.xyz = vec3(vec3(_BumpAttune, _BumpAttune, _BumpAttune)) * u_xlat0.xyz + u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz + in_POSITION0.xyz;
					    u_xlat1 = u_xlat0.yyyy * unity_ObjectToWorld[1];
					    u_xlat1 = unity_ObjectToWorld[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat0 = unity_ObjectToWorld[2] * u_xlat0.zzzz + u_xlat1;
					    u_xlat1 = u_xlat0 + unity_ObjectToWorld[3];
					    vs_TEXCOORD3 = unity_ObjectToWorld[3] * in_POSITION0.wwww + u_xlat0;
					    u_xlat0 = u_xlat1.yyyy * unity_MatrixVP[1];
					    u_xlat0 = unity_MatrixVP[0] * u_xlat1.xxxx + u_xlat0;
					    u_xlat0 = unity_MatrixVP[2] * u_xlat1.zzzz + u_xlat0;
					    u_xlat0 = unity_MatrixVP[3] * u_xlat1.wwww + u_xlat0;
					    gl_Position = u_xlat0;
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
					    vs_TEXCOORD1.xy = in_TEXCOORD1.xy;
					    vs_TEXCOORD2.xy = in_TEXCOORD2.xy;
					    u_xlat1.x = dot(in_NORMAL0.xyz, unity_WorldToObject[0].xyz);
					    u_xlat1.y = dot(in_NORMAL0.xyz, unity_WorldToObject[1].xyz);
					    u_xlat1.z = dot(in_NORMAL0.xyz, unity_WorldToObject[2].xyz);
					    u_xlat13 = dot(u_xlat1.xyz, u_xlat1.xyz);
					    u_xlat13 = inversesqrt(u_xlat13);
					    u_xlat1.xyz = vec3(u_xlat13) * u_xlat1.xyz;
					    vs_TEXCOORD4.xyz = u_xlat1.xyz;
					    u_xlat2.xyz = in_TANGENT0.yyy * unity_ObjectToWorld[1].xyz;
					    u_xlat2.xyz = unity_ObjectToWorld[0].xyz * in_TANGENT0.xxx + u_xlat2.xyz;
					    u_xlat2.xyz = unity_ObjectToWorld[2].xyz * in_TANGENT0.zzz + u_xlat2.xyz;
					    u_xlat13 = dot(u_xlat2.xyz, u_xlat2.xyz);
					    u_xlat13 = inversesqrt(u_xlat13);
					    u_xlat2.xyz = vec3(u_xlat13) * u_xlat2.xyz;
					    vs_TEXCOORD5.xyz = u_xlat2.xyz;
					    u_xlat3.xyz = u_xlat1.zxy * u_xlat2.yzx;
					    u_xlat1.xyz = u_xlat1.yzx * u_xlat2.zxy + (-u_xlat3.xyz);
					    u_xlat1.xyz = u_xlat1.xyz * in_TANGENT0.www;
					    u_xlat13 = dot(u_xlat1.xyz, u_xlat1.xyz);
					    u_xlat13 = inversesqrt(u_xlat13);
					    vs_TEXCOORD6.xyz = vec3(u_xlat13) * u_xlat1.xyz;
					    u_xlat0.y = u_xlat0.y * _ProjectionParams.x;
					    u_xlat1.xzw = u_xlat0.xwy * vec3(0.5, 0.5, 0.5);
					    vs_TEXCOORD8.zw = u_xlat0.zw;
					    vs_TEXCOORD8.xy = u_xlat1.zz + u_xlat1.xw;
					    vs_TEXCOORD10 = vec4(0.0, 0.0, 0.0, 0.0);
					    return;
					}"
				}
				SubProgram "d3d11 " {
					Keywords { "DIRECTIONAL" "DIRLIGHTMAP_COMBINED" "VERTEXLIGHT_ON" "LIGHTMAP_OFF" "DYNAMICLIGHTMAP_OFF" }
					"vs_4_0
					
					#version 330
					#extension GL_ARB_explicit_attrib_location : require
					#extension GL_ARB_explicit_uniform_location : require
					
					#define HLSLCC_ENABLE_UNIFORM_BUFFERS 1
					#if HLSLCC_ENABLE_UNIFORM_BUFFERS
					#define UNITY_UNIFORM
					#else
					#define UNITY_UNIFORM uniform
					#endif
					#define UNITY_SUPPORTS_UNIFORM_LOCATION 1
					#if UNITY_SUPPORTS_UNIFORM_LOCATION
					#define UNITY_LOCATION(x) layout(location = x)
					#define UNITY_BINDING(x) layout(binding = x, std140)
					#else
					#define UNITY_LOCATION(x)
					#define UNITY_BINDING(x) layout(std140)
					#endif
					layout(std140) uniform VGlobals {
						vec4 unused_0_0[4];
						vec4 _MainTexture_ST;
						vec4 unused_0_2[2];
						vec4 _Color;
						vec4 _Heightmap_ST;
						float _Bumpiness;
						vec4 unused_0_6;
						float _BumpAttune;
					};
					layout(std140) uniform UnityPerDraw {
						mat4x4 unity_ObjectToWorld;
						mat4x4 unity_WorldToObject;
						vec4 unused_1_2[2];
					};
					layout(std140) uniform UnityPerFrame {
						vec4 unused_2_0[17];
						mat4x4 unity_MatrixVP;
						vec4 unused_2_2[2];
					};
					uniform  sampler2D _Heightmap;
					uniform  sampler2D _MainTexture;
					in  vec4 in_POSITION0;
					in  vec3 in_NORMAL0;
					in  vec4 in_TANGENT0;
					in  vec2 in_TEXCOORD0;
					in  vec2 in_TEXCOORD1;
					in  vec2 in_TEXCOORD2;
					out vec2 vs_TEXCOORD0;
					out vec2 vs_TEXCOORD1;
					out vec2 vs_TEXCOORD2;
					out vec4 vs_TEXCOORD3;
					out vec3 vs_TEXCOORD4;
					out vec3 vs_TEXCOORD5;
					out vec3 vs_TEXCOORD6;
					out vec4 vs_TEXCOORD10;
					vec4 u_xlat0;
					vec4 u_xlat1;
					vec4 u_xlat2;
					vec3 u_xlat3;
					float u_xlat12;
					void main()
					{
					    u_xlat0.xy = in_TEXCOORD0.xy * _MainTexture_ST.xy + _MainTexture_ST.zw;
					    u_xlat0 = textureLod(_MainTexture, u_xlat0.xy, 0.0);
					    u_xlat0.xyz = u_xlat0.xyz * _Color.xyz;
					    u_xlat1.xyz = u_xlat0.xyz * vec3(-1.0, -1.0, 1.0);
					    u_xlat2.xy = in_TEXCOORD0.xy * _Heightmap_ST.xy + _Heightmap_ST.zw;
					    u_xlat2 = textureLod(_Heightmap, u_xlat2.xy, 0.0);
					    u_xlat2.xyz = u_xlat2.xyz * vec3(_Bumpiness);
					    u_xlat2.xyz = clamp(u_xlat2.xyz, 0.0, 1.0);
					    u_xlat3.xyz = u_xlat2.xyz + vec3(0.0, 0.0, 1.0);
					    u_xlat2.xyz = u_xlat2.xyz * in_NORMAL0.xyz;
					    u_xlat12 = dot(u_xlat3.xyz, u_xlat1.xyz);
					    u_xlat1.xyz = vec3(u_xlat12) * u_xlat3.xyz;
					    u_xlat1.xyz = u_xlat1.xyz / u_xlat3.zzz;
					    u_xlat0.xyz = (-u_xlat0.xyz) * vec3(-1.0, -1.0, 1.0) + u_xlat1.xyz;
					    u_xlat0.x = dot(u_xlat0.xyz, vec3(0.300000012, 0.589999974, 0.109999999));
					    u_xlat0.xyz = u_xlat2.xyz * u_xlat0.xxx + (-u_xlat2.xyz);
					    u_xlat0.xyz = vec3(vec3(_BumpAttune, _BumpAttune, _BumpAttune)) * u_xlat0.xyz + u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz + in_POSITION0.xyz;
					    u_xlat1 = u_xlat0.yyyy * unity_ObjectToWorld[1];
					    u_xlat1 = unity_ObjectToWorld[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat0 = unity_ObjectToWorld[2] * u_xlat0.zzzz + u_xlat1;
					    u_xlat1 = u_xlat0 + unity_ObjectToWorld[3];
					    vs_TEXCOORD3 = unity_ObjectToWorld[3] * in_POSITION0.wwww + u_xlat0;
					    u_xlat0 = u_xlat1.yyyy * unity_MatrixVP[1];
					    u_xlat0 = unity_MatrixVP[0] * u_xlat1.xxxx + u_xlat0;
					    u_xlat0 = unity_MatrixVP[2] * u_xlat1.zzzz + u_xlat0;
					    gl_Position = unity_MatrixVP[3] * u_xlat1.wwww + u_xlat0;
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
					    vs_TEXCOORD1.xy = in_TEXCOORD1.xy;
					    vs_TEXCOORD2.xy = in_TEXCOORD2.xy;
					    u_xlat0.x = dot(in_NORMAL0.xyz, unity_WorldToObject[0].xyz);
					    u_xlat0.y = dot(in_NORMAL0.xyz, unity_WorldToObject[1].xyz);
					    u_xlat0.z = dot(in_NORMAL0.xyz, unity_WorldToObject[2].xyz);
					    u_xlat12 = dot(u_xlat0.xyz, u_xlat0.xyz);
					    u_xlat12 = inversesqrt(u_xlat12);
					    u_xlat0.xyz = vec3(u_xlat12) * u_xlat0.xyz;
					    vs_TEXCOORD4.xyz = u_xlat0.xyz;
					    u_xlat1.xyz = in_TANGENT0.yyy * unity_ObjectToWorld[1].xyz;
					    u_xlat1.xyz = unity_ObjectToWorld[0].xyz * in_TANGENT0.xxx + u_xlat1.xyz;
					    u_xlat1.xyz = unity_ObjectToWorld[2].xyz * in_TANGENT0.zzz + u_xlat1.xyz;
					    u_xlat12 = dot(u_xlat1.xyz, u_xlat1.xyz);
					    u_xlat12 = inversesqrt(u_xlat12);
					    u_xlat1.xyz = vec3(u_xlat12) * u_xlat1.xyz;
					    vs_TEXCOORD5.xyz = u_xlat1.xyz;
					    u_xlat2.xyz = u_xlat0.zxy * u_xlat1.yzx;
					    u_xlat0.xyz = u_xlat0.yzx * u_xlat1.zxy + (-u_xlat2.xyz);
					    u_xlat0.xyz = u_xlat0.xyz * in_TANGENT0.www;
					    u_xlat12 = dot(u_xlat0.xyz, u_xlat0.xyz);
					    u_xlat12 = inversesqrt(u_xlat12);
					    vs_TEXCOORD6.xyz = vec3(u_xlat12) * u_xlat0.xyz;
					    vs_TEXCOORD10 = vec4(0.0, 0.0, 0.0, 0.0);
					    return;
					}"
				}
				SubProgram "d3d11 " {
					Keywords { "DIRECTIONAL" "DIRLIGHTMAP_COMBINED" "LIGHTPROBE_SH" "VERTEXLIGHT_ON" "LIGHTMAP_OFF" "DYNAMICLIGHTMAP_OFF" }
					"vs_4_0
					
					#version 330
					#extension GL_ARB_explicit_attrib_location : require
					#extension GL_ARB_explicit_uniform_location : require
					
					#define HLSLCC_ENABLE_UNIFORM_BUFFERS 1
					#if HLSLCC_ENABLE_UNIFORM_BUFFERS
					#define UNITY_UNIFORM
					#else
					#define UNITY_UNIFORM uniform
					#endif
					#define UNITY_SUPPORTS_UNIFORM_LOCATION 1
					#if UNITY_SUPPORTS_UNIFORM_LOCATION
					#define UNITY_LOCATION(x) layout(location = x)
					#define UNITY_BINDING(x) layout(binding = x, std140)
					#else
					#define UNITY_LOCATION(x)
					#define UNITY_BINDING(x) layout(std140)
					#endif
					layout(std140) uniform VGlobals {
						vec4 unused_0_0[4];
						vec4 _MainTexture_ST;
						vec4 unused_0_2[2];
						vec4 _Color;
						vec4 _Heightmap_ST;
						float _Bumpiness;
						vec4 unused_0_6;
						float _BumpAttune;
					};
					layout(std140) uniform UnityPerDraw {
						mat4x4 unity_ObjectToWorld;
						mat4x4 unity_WorldToObject;
						vec4 unused_1_2[2];
					};
					layout(std140) uniform UnityPerFrame {
						vec4 unused_2_0[17];
						mat4x4 unity_MatrixVP;
						vec4 unused_2_2[2];
					};
					uniform  sampler2D _Heightmap;
					uniform  sampler2D _MainTexture;
					in  vec4 in_POSITION0;
					in  vec3 in_NORMAL0;
					in  vec4 in_TANGENT0;
					in  vec2 in_TEXCOORD0;
					in  vec2 in_TEXCOORD1;
					in  vec2 in_TEXCOORD2;
					out vec2 vs_TEXCOORD0;
					out vec2 vs_TEXCOORD1;
					out vec2 vs_TEXCOORD2;
					out vec4 vs_TEXCOORD3;
					out vec3 vs_TEXCOORD4;
					out vec3 vs_TEXCOORD5;
					out vec3 vs_TEXCOORD6;
					out vec4 vs_TEXCOORD10;
					vec4 u_xlat0;
					vec4 u_xlat1;
					vec4 u_xlat2;
					vec3 u_xlat3;
					float u_xlat12;
					void main()
					{
					    u_xlat0.xy = in_TEXCOORD0.xy * _MainTexture_ST.xy + _MainTexture_ST.zw;
					    u_xlat0 = textureLod(_MainTexture, u_xlat0.xy, 0.0);
					    u_xlat0.xyz = u_xlat0.xyz * _Color.xyz;
					    u_xlat1.xyz = u_xlat0.xyz * vec3(-1.0, -1.0, 1.0);
					    u_xlat2.xy = in_TEXCOORD0.xy * _Heightmap_ST.xy + _Heightmap_ST.zw;
					    u_xlat2 = textureLod(_Heightmap, u_xlat2.xy, 0.0);
					    u_xlat2.xyz = u_xlat2.xyz * vec3(_Bumpiness);
					    u_xlat2.xyz = clamp(u_xlat2.xyz, 0.0, 1.0);
					    u_xlat3.xyz = u_xlat2.xyz + vec3(0.0, 0.0, 1.0);
					    u_xlat2.xyz = u_xlat2.xyz * in_NORMAL0.xyz;
					    u_xlat12 = dot(u_xlat3.xyz, u_xlat1.xyz);
					    u_xlat1.xyz = vec3(u_xlat12) * u_xlat3.xyz;
					    u_xlat1.xyz = u_xlat1.xyz / u_xlat3.zzz;
					    u_xlat0.xyz = (-u_xlat0.xyz) * vec3(-1.0, -1.0, 1.0) + u_xlat1.xyz;
					    u_xlat0.x = dot(u_xlat0.xyz, vec3(0.300000012, 0.589999974, 0.109999999));
					    u_xlat0.xyz = u_xlat2.xyz * u_xlat0.xxx + (-u_xlat2.xyz);
					    u_xlat0.xyz = vec3(vec3(_BumpAttune, _BumpAttune, _BumpAttune)) * u_xlat0.xyz + u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz + in_POSITION0.xyz;
					    u_xlat1 = u_xlat0.yyyy * unity_ObjectToWorld[1];
					    u_xlat1 = unity_ObjectToWorld[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat0 = unity_ObjectToWorld[2] * u_xlat0.zzzz + u_xlat1;
					    u_xlat1 = u_xlat0 + unity_ObjectToWorld[3];
					    vs_TEXCOORD3 = unity_ObjectToWorld[3] * in_POSITION0.wwww + u_xlat0;
					    u_xlat0 = u_xlat1.yyyy * unity_MatrixVP[1];
					    u_xlat0 = unity_MatrixVP[0] * u_xlat1.xxxx + u_xlat0;
					    u_xlat0 = unity_MatrixVP[2] * u_xlat1.zzzz + u_xlat0;
					    gl_Position = unity_MatrixVP[3] * u_xlat1.wwww + u_xlat0;
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
					    vs_TEXCOORD1.xy = in_TEXCOORD1.xy;
					    vs_TEXCOORD2.xy = in_TEXCOORD2.xy;
					    u_xlat0.x = dot(in_NORMAL0.xyz, unity_WorldToObject[0].xyz);
					    u_xlat0.y = dot(in_NORMAL0.xyz, unity_WorldToObject[1].xyz);
					    u_xlat0.z = dot(in_NORMAL0.xyz, unity_WorldToObject[2].xyz);
					    u_xlat12 = dot(u_xlat0.xyz, u_xlat0.xyz);
					    u_xlat12 = inversesqrt(u_xlat12);
					    u_xlat0.xyz = vec3(u_xlat12) * u_xlat0.xyz;
					    vs_TEXCOORD4.xyz = u_xlat0.xyz;
					    u_xlat1.xyz = in_TANGENT0.yyy * unity_ObjectToWorld[1].xyz;
					    u_xlat1.xyz = unity_ObjectToWorld[0].xyz * in_TANGENT0.xxx + u_xlat1.xyz;
					    u_xlat1.xyz = unity_ObjectToWorld[2].xyz * in_TANGENT0.zzz + u_xlat1.xyz;
					    u_xlat12 = dot(u_xlat1.xyz, u_xlat1.xyz);
					    u_xlat12 = inversesqrt(u_xlat12);
					    u_xlat1.xyz = vec3(u_xlat12) * u_xlat1.xyz;
					    vs_TEXCOORD5.xyz = u_xlat1.xyz;
					    u_xlat2.xyz = u_xlat0.zxy * u_xlat1.yzx;
					    u_xlat0.xyz = u_xlat0.yzx * u_xlat1.zxy + (-u_xlat2.xyz);
					    u_xlat0.xyz = u_xlat0.xyz * in_TANGENT0.www;
					    u_xlat12 = dot(u_xlat0.xyz, u_xlat0.xyz);
					    u_xlat12 = inversesqrt(u_xlat12);
					    vs_TEXCOORD6.xyz = vec3(u_xlat12) * u_xlat0.xyz;
					    vs_TEXCOORD10 = vec4(0.0, 0.0, 0.0, 0.0);
					    return;
					}"
				}
				SubProgram "d3d11 " {
					Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "DIRLIGHTMAP_COMBINED" "VERTEXLIGHT_ON" "LIGHTMAP_OFF" "DYNAMICLIGHTMAP_OFF" }
					"vs_4_0
					
					#version 330
					#extension GL_ARB_explicit_attrib_location : require
					#extension GL_ARB_explicit_uniform_location : require
					
					#define HLSLCC_ENABLE_UNIFORM_BUFFERS 1
					#if HLSLCC_ENABLE_UNIFORM_BUFFERS
					#define UNITY_UNIFORM
					#else
					#define UNITY_UNIFORM uniform
					#endif
					#define UNITY_SUPPORTS_UNIFORM_LOCATION 1
					#if UNITY_SUPPORTS_UNIFORM_LOCATION
					#define UNITY_LOCATION(x) layout(location = x)
					#define UNITY_BINDING(x) layout(binding = x, std140)
					#else
					#define UNITY_LOCATION(x)
					#define UNITY_BINDING(x) layout(std140)
					#endif
					layout(std140) uniform VGlobals {
						vec4 unused_0_0[4];
						vec4 _MainTexture_ST;
						vec4 unused_0_2[2];
						vec4 _Color;
						vec4 _Heightmap_ST;
						float _Bumpiness;
						vec4 unused_0_6;
						float _BumpAttune;
					};
					layout(std140) uniform UnityPerCamera {
						vec4 unused_1_0[5];
						vec4 _ProjectionParams;
						vec4 unused_1_2[3];
					};
					layout(std140) uniform UnityPerDraw {
						mat4x4 unity_ObjectToWorld;
						mat4x4 unity_WorldToObject;
						vec4 unused_2_2[2];
					};
					layout(std140) uniform UnityPerFrame {
						vec4 unused_3_0[17];
						mat4x4 unity_MatrixVP;
						vec4 unused_3_2[2];
					};
					uniform  sampler2D _Heightmap;
					uniform  sampler2D _MainTexture;
					in  vec4 in_POSITION0;
					in  vec3 in_NORMAL0;
					in  vec4 in_TANGENT0;
					in  vec2 in_TEXCOORD0;
					in  vec2 in_TEXCOORD1;
					in  vec2 in_TEXCOORD2;
					out vec2 vs_TEXCOORD0;
					out vec2 vs_TEXCOORD1;
					out vec2 vs_TEXCOORD2;
					out vec4 vs_TEXCOORD3;
					out vec3 vs_TEXCOORD4;
					out vec3 vs_TEXCOORD5;
					out vec3 vs_TEXCOORD6;
					out vec4 vs_TEXCOORD8;
					out vec4 vs_TEXCOORD10;
					vec4 u_xlat0;
					vec4 u_xlat1;
					vec4 u_xlat2;
					vec3 u_xlat3;
					float u_xlat12;
					float u_xlat13;
					void main()
					{
					    u_xlat0.xy = in_TEXCOORD0.xy * _MainTexture_ST.xy + _MainTexture_ST.zw;
					    u_xlat0 = textureLod(_MainTexture, u_xlat0.xy, 0.0);
					    u_xlat0.xyz = u_xlat0.xyz * _Color.xyz;
					    u_xlat1.xyz = u_xlat0.xyz * vec3(-1.0, -1.0, 1.0);
					    u_xlat2.xy = in_TEXCOORD0.xy * _Heightmap_ST.xy + _Heightmap_ST.zw;
					    u_xlat2 = textureLod(_Heightmap, u_xlat2.xy, 0.0);
					    u_xlat2.xyz = u_xlat2.xyz * vec3(_Bumpiness);
					    u_xlat2.xyz = clamp(u_xlat2.xyz, 0.0, 1.0);
					    u_xlat3.xyz = u_xlat2.xyz + vec3(0.0, 0.0, 1.0);
					    u_xlat2.xyz = u_xlat2.xyz * in_NORMAL0.xyz;
					    u_xlat12 = dot(u_xlat3.xyz, u_xlat1.xyz);
					    u_xlat1.xyz = vec3(u_xlat12) * u_xlat3.xyz;
					    u_xlat1.xyz = u_xlat1.xyz / u_xlat3.zzz;
					    u_xlat0.xyz = (-u_xlat0.xyz) * vec3(-1.0, -1.0, 1.0) + u_xlat1.xyz;
					    u_xlat0.x = dot(u_xlat0.xyz, vec3(0.300000012, 0.589999974, 0.109999999));
					    u_xlat0.xyz = u_xlat2.xyz * u_xlat0.xxx + (-u_xlat2.xyz);
					    u_xlat0.xyz = vec3(vec3(_BumpAttune, _BumpAttune, _BumpAttune)) * u_xlat0.xyz + u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz + in_POSITION0.xyz;
					    u_xlat1 = u_xlat0.yyyy * unity_ObjectToWorld[1];
					    u_xlat1 = unity_ObjectToWorld[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat0 = unity_ObjectToWorld[2] * u_xlat0.zzzz + u_xlat1;
					    u_xlat1 = u_xlat0 + unity_ObjectToWorld[3];
					    vs_TEXCOORD3 = unity_ObjectToWorld[3] * in_POSITION0.wwww + u_xlat0;
					    u_xlat0 = u_xlat1.yyyy * unity_MatrixVP[1];
					    u_xlat0 = unity_MatrixVP[0] * u_xlat1.xxxx + u_xlat0;
					    u_xlat0 = unity_MatrixVP[2] * u_xlat1.zzzz + u_xlat0;
					    u_xlat0 = unity_MatrixVP[3] * u_xlat1.wwww + u_xlat0;
					    gl_Position = u_xlat0;
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
					    vs_TEXCOORD1.xy = in_TEXCOORD1.xy;
					    vs_TEXCOORD2.xy = in_TEXCOORD2.xy;
					    u_xlat1.x = dot(in_NORMAL0.xyz, unity_WorldToObject[0].xyz);
					    u_xlat1.y = dot(in_NORMAL0.xyz, unity_WorldToObject[1].xyz);
					    u_xlat1.z = dot(in_NORMAL0.xyz, unity_WorldToObject[2].xyz);
					    u_xlat13 = dot(u_xlat1.xyz, u_xlat1.xyz);
					    u_xlat13 = inversesqrt(u_xlat13);
					    u_xlat1.xyz = vec3(u_xlat13) * u_xlat1.xyz;
					    vs_TEXCOORD4.xyz = u_xlat1.xyz;
					    u_xlat2.xyz = in_TANGENT0.yyy * unity_ObjectToWorld[1].xyz;
					    u_xlat2.xyz = unity_ObjectToWorld[0].xyz * in_TANGENT0.xxx + u_xlat2.xyz;
					    u_xlat2.xyz = unity_ObjectToWorld[2].xyz * in_TANGENT0.zzz + u_xlat2.xyz;
					    u_xlat13 = dot(u_xlat2.xyz, u_xlat2.xyz);
					    u_xlat13 = inversesqrt(u_xlat13);
					    u_xlat2.xyz = vec3(u_xlat13) * u_xlat2.xyz;
					    vs_TEXCOORD5.xyz = u_xlat2.xyz;
					    u_xlat3.xyz = u_xlat1.zxy * u_xlat2.yzx;
					    u_xlat1.xyz = u_xlat1.yzx * u_xlat2.zxy + (-u_xlat3.xyz);
					    u_xlat1.xyz = u_xlat1.xyz * in_TANGENT0.www;
					    u_xlat13 = dot(u_xlat1.xyz, u_xlat1.xyz);
					    u_xlat13 = inversesqrt(u_xlat13);
					    vs_TEXCOORD6.xyz = vec3(u_xlat13) * u_xlat1.xyz;
					    u_xlat0.y = u_xlat0.y * _ProjectionParams.x;
					    u_xlat1.xzw = u_xlat0.xwy * vec3(0.5, 0.5, 0.5);
					    vs_TEXCOORD8.zw = u_xlat0.zw;
					    vs_TEXCOORD8.xy = u_xlat1.zz + u_xlat1.xw;
					    vs_TEXCOORD10 = vec4(0.0, 0.0, 0.0, 0.0);
					    return;
					}"
				}
				SubProgram "d3d11 " {
					Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "DIRLIGHTMAP_COMBINED" "LIGHTPROBE_SH" "VERTEXLIGHT_ON" "LIGHTMAP_OFF" "DYNAMICLIGHTMAP_OFF" }
					"vs_4_0
					
					#version 330
					#extension GL_ARB_explicit_attrib_location : require
					#extension GL_ARB_explicit_uniform_location : require
					
					#define HLSLCC_ENABLE_UNIFORM_BUFFERS 1
					#if HLSLCC_ENABLE_UNIFORM_BUFFERS
					#define UNITY_UNIFORM
					#else
					#define UNITY_UNIFORM uniform
					#endif
					#define UNITY_SUPPORTS_UNIFORM_LOCATION 1
					#if UNITY_SUPPORTS_UNIFORM_LOCATION
					#define UNITY_LOCATION(x) layout(location = x)
					#define UNITY_BINDING(x) layout(binding = x, std140)
					#else
					#define UNITY_LOCATION(x)
					#define UNITY_BINDING(x) layout(std140)
					#endif
					layout(std140) uniform VGlobals {
						vec4 unused_0_0[4];
						vec4 _MainTexture_ST;
						vec4 unused_0_2[2];
						vec4 _Color;
						vec4 _Heightmap_ST;
						float _Bumpiness;
						vec4 unused_0_6;
						float _BumpAttune;
					};
					layout(std140) uniform UnityPerCamera {
						vec4 unused_1_0[5];
						vec4 _ProjectionParams;
						vec4 unused_1_2[3];
					};
					layout(std140) uniform UnityPerDraw {
						mat4x4 unity_ObjectToWorld;
						mat4x4 unity_WorldToObject;
						vec4 unused_2_2[2];
					};
					layout(std140) uniform UnityPerFrame {
						vec4 unused_3_0[17];
						mat4x4 unity_MatrixVP;
						vec4 unused_3_2[2];
					};
					uniform  sampler2D _Heightmap;
					uniform  sampler2D _MainTexture;
					in  vec4 in_POSITION0;
					in  vec3 in_NORMAL0;
					in  vec4 in_TANGENT0;
					in  vec2 in_TEXCOORD0;
					in  vec2 in_TEXCOORD1;
					in  vec2 in_TEXCOORD2;
					out vec2 vs_TEXCOORD0;
					out vec2 vs_TEXCOORD1;
					out vec2 vs_TEXCOORD2;
					out vec4 vs_TEXCOORD3;
					out vec3 vs_TEXCOORD4;
					out vec3 vs_TEXCOORD5;
					out vec3 vs_TEXCOORD6;
					out vec4 vs_TEXCOORD8;
					out vec4 vs_TEXCOORD10;
					vec4 u_xlat0;
					vec4 u_xlat1;
					vec4 u_xlat2;
					vec3 u_xlat3;
					float u_xlat12;
					float u_xlat13;
					void main()
					{
					    u_xlat0.xy = in_TEXCOORD0.xy * _MainTexture_ST.xy + _MainTexture_ST.zw;
					    u_xlat0 = textureLod(_MainTexture, u_xlat0.xy, 0.0);
					    u_xlat0.xyz = u_xlat0.xyz * _Color.xyz;
					    u_xlat1.xyz = u_xlat0.xyz * vec3(-1.0, -1.0, 1.0);
					    u_xlat2.xy = in_TEXCOORD0.xy * _Heightmap_ST.xy + _Heightmap_ST.zw;
					    u_xlat2 = textureLod(_Heightmap, u_xlat2.xy, 0.0);
					    u_xlat2.xyz = u_xlat2.xyz * vec3(_Bumpiness);
					    u_xlat2.xyz = clamp(u_xlat2.xyz, 0.0, 1.0);
					    u_xlat3.xyz = u_xlat2.xyz + vec3(0.0, 0.0, 1.0);
					    u_xlat2.xyz = u_xlat2.xyz * in_NORMAL0.xyz;
					    u_xlat12 = dot(u_xlat3.xyz, u_xlat1.xyz);
					    u_xlat1.xyz = vec3(u_xlat12) * u_xlat3.xyz;
					    u_xlat1.xyz = u_xlat1.xyz / u_xlat3.zzz;
					    u_xlat0.xyz = (-u_xlat0.xyz) * vec3(-1.0, -1.0, 1.0) + u_xlat1.xyz;
					    u_xlat0.x = dot(u_xlat0.xyz, vec3(0.300000012, 0.589999974, 0.109999999));
					    u_xlat0.xyz = u_xlat2.xyz * u_xlat0.xxx + (-u_xlat2.xyz);
					    u_xlat0.xyz = vec3(vec3(_BumpAttune, _BumpAttune, _BumpAttune)) * u_xlat0.xyz + u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz + in_POSITION0.xyz;
					    u_xlat1 = u_xlat0.yyyy * unity_ObjectToWorld[1];
					    u_xlat1 = unity_ObjectToWorld[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat0 = unity_ObjectToWorld[2] * u_xlat0.zzzz + u_xlat1;
					    u_xlat1 = u_xlat0 + unity_ObjectToWorld[3];
					    vs_TEXCOORD3 = unity_ObjectToWorld[3] * in_POSITION0.wwww + u_xlat0;
					    u_xlat0 = u_xlat1.yyyy * unity_MatrixVP[1];
					    u_xlat0 = unity_MatrixVP[0] * u_xlat1.xxxx + u_xlat0;
					    u_xlat0 = unity_MatrixVP[2] * u_xlat1.zzzz + u_xlat0;
					    u_xlat0 = unity_MatrixVP[3] * u_xlat1.wwww + u_xlat0;
					    gl_Position = u_xlat0;
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
					    vs_TEXCOORD1.xy = in_TEXCOORD1.xy;
					    vs_TEXCOORD2.xy = in_TEXCOORD2.xy;
					    u_xlat1.x = dot(in_NORMAL0.xyz, unity_WorldToObject[0].xyz);
					    u_xlat1.y = dot(in_NORMAL0.xyz, unity_WorldToObject[1].xyz);
					    u_xlat1.z = dot(in_NORMAL0.xyz, unity_WorldToObject[2].xyz);
					    u_xlat13 = dot(u_xlat1.xyz, u_xlat1.xyz);
					    u_xlat13 = inversesqrt(u_xlat13);
					    u_xlat1.xyz = vec3(u_xlat13) * u_xlat1.xyz;
					    vs_TEXCOORD4.xyz = u_xlat1.xyz;
					    u_xlat2.xyz = in_TANGENT0.yyy * unity_ObjectToWorld[1].xyz;
					    u_xlat2.xyz = unity_ObjectToWorld[0].xyz * in_TANGENT0.xxx + u_xlat2.xyz;
					    u_xlat2.xyz = unity_ObjectToWorld[2].xyz * in_TANGENT0.zzz + u_xlat2.xyz;
					    u_xlat13 = dot(u_xlat2.xyz, u_xlat2.xyz);
					    u_xlat13 = inversesqrt(u_xlat13);
					    u_xlat2.xyz = vec3(u_xlat13) * u_xlat2.xyz;
					    vs_TEXCOORD5.xyz = u_xlat2.xyz;
					    u_xlat3.xyz = u_xlat1.zxy * u_xlat2.yzx;
					    u_xlat1.xyz = u_xlat1.yzx * u_xlat2.zxy + (-u_xlat3.xyz);
					    u_xlat1.xyz = u_xlat1.xyz * in_TANGENT0.www;
					    u_xlat13 = dot(u_xlat1.xyz, u_xlat1.xyz);
					    u_xlat13 = inversesqrt(u_xlat13);
					    vs_TEXCOORD6.xyz = vec3(u_xlat13) * u_xlat1.xyz;
					    u_xlat0.y = u_xlat0.y * _ProjectionParams.x;
					    u_xlat1.xzw = u_xlat0.xwy * vec3(0.5, 0.5, 0.5);
					    vs_TEXCOORD8.zw = u_xlat0.zw;
					    vs_TEXCOORD8.xy = u_xlat1.zz + u_xlat1.xw;
					    vs_TEXCOORD10 = vec4(0.0, 0.0, 0.0, 0.0);
					    return;
					}"
				}
				SubProgram "d3d11 " {
					Keywords { "DIRECTIONAL" "DIRLIGHTMAP_SEPARATE" "LIGHTMAP_OFF" "DYNAMICLIGHTMAP_OFF" }
					"vs_4_0
					
					#version 330
					#extension GL_ARB_explicit_attrib_location : require
					#extension GL_ARB_explicit_uniform_location : require
					
					#define HLSLCC_ENABLE_UNIFORM_BUFFERS 1
					#if HLSLCC_ENABLE_UNIFORM_BUFFERS
					#define UNITY_UNIFORM
					#else
					#define UNITY_UNIFORM uniform
					#endif
					#define UNITY_SUPPORTS_UNIFORM_LOCATION 1
					#if UNITY_SUPPORTS_UNIFORM_LOCATION
					#define UNITY_LOCATION(x) layout(location = x)
					#define UNITY_BINDING(x) layout(binding = x, std140)
					#else
					#define UNITY_LOCATION(x)
					#define UNITY_BINDING(x) layout(std140)
					#endif
					layout(std140) uniform VGlobals {
						vec4 unused_0_0[4];
						vec4 _MainTexture_ST;
						vec4 unused_0_2[2];
						vec4 _Color;
						vec4 _Heightmap_ST;
						float _Bumpiness;
						vec4 unused_0_6;
						float _BumpAttune;
					};
					layout(std140) uniform UnityPerDraw {
						mat4x4 unity_ObjectToWorld;
						mat4x4 unity_WorldToObject;
						vec4 unused_1_2[2];
					};
					layout(std140) uniform UnityPerFrame {
						vec4 unused_2_0[17];
						mat4x4 unity_MatrixVP;
						vec4 unused_2_2[2];
					};
					uniform  sampler2D _Heightmap;
					uniform  sampler2D _MainTexture;
					in  vec4 in_POSITION0;
					in  vec3 in_NORMAL0;
					in  vec4 in_TANGENT0;
					in  vec2 in_TEXCOORD0;
					in  vec2 in_TEXCOORD1;
					in  vec2 in_TEXCOORD2;
					out vec2 vs_TEXCOORD0;
					out vec2 vs_TEXCOORD1;
					out vec2 vs_TEXCOORD2;
					out vec4 vs_TEXCOORD3;
					out vec3 vs_TEXCOORD4;
					out vec3 vs_TEXCOORD5;
					out vec3 vs_TEXCOORD6;
					out vec4 vs_TEXCOORD10;
					vec4 u_xlat0;
					vec4 u_xlat1;
					vec4 u_xlat2;
					vec3 u_xlat3;
					float u_xlat12;
					void main()
					{
					    u_xlat0.xy = in_TEXCOORD0.xy * _MainTexture_ST.xy + _MainTexture_ST.zw;
					    u_xlat0 = textureLod(_MainTexture, u_xlat0.xy, 0.0);
					    u_xlat0.xyz = u_xlat0.xyz * _Color.xyz;
					    u_xlat1.xyz = u_xlat0.xyz * vec3(-1.0, -1.0, 1.0);
					    u_xlat2.xy = in_TEXCOORD0.xy * _Heightmap_ST.xy + _Heightmap_ST.zw;
					    u_xlat2 = textureLod(_Heightmap, u_xlat2.xy, 0.0);
					    u_xlat2.xyz = u_xlat2.xyz * vec3(_Bumpiness);
					    u_xlat2.xyz = clamp(u_xlat2.xyz, 0.0, 1.0);
					    u_xlat3.xyz = u_xlat2.xyz + vec3(0.0, 0.0, 1.0);
					    u_xlat2.xyz = u_xlat2.xyz * in_NORMAL0.xyz;
					    u_xlat12 = dot(u_xlat3.xyz, u_xlat1.xyz);
					    u_xlat1.xyz = vec3(u_xlat12) * u_xlat3.xyz;
					    u_xlat1.xyz = u_xlat1.xyz / u_xlat3.zzz;
					    u_xlat0.xyz = (-u_xlat0.xyz) * vec3(-1.0, -1.0, 1.0) + u_xlat1.xyz;
					    u_xlat0.x = dot(u_xlat0.xyz, vec3(0.300000012, 0.589999974, 0.109999999));
					    u_xlat0.xyz = u_xlat2.xyz * u_xlat0.xxx + (-u_xlat2.xyz);
					    u_xlat0.xyz = vec3(vec3(_BumpAttune, _BumpAttune, _BumpAttune)) * u_xlat0.xyz + u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz + in_POSITION0.xyz;
					    u_xlat1 = u_xlat0.yyyy * unity_ObjectToWorld[1];
					    u_xlat1 = unity_ObjectToWorld[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat0 = unity_ObjectToWorld[2] * u_xlat0.zzzz + u_xlat1;
					    u_xlat1 = u_xlat0 + unity_ObjectToWorld[3];
					    vs_TEXCOORD3 = unity_ObjectToWorld[3] * in_POSITION0.wwww + u_xlat0;
					    u_xlat0 = u_xlat1.yyyy * unity_MatrixVP[1];
					    u_xlat0 = unity_MatrixVP[0] * u_xlat1.xxxx + u_xlat0;
					    u_xlat0 = unity_MatrixVP[2] * u_xlat1.zzzz + u_xlat0;
					    gl_Position = unity_MatrixVP[3] * u_xlat1.wwww + u_xlat0;
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
					    vs_TEXCOORD1.xy = in_TEXCOORD1.xy;
					    vs_TEXCOORD2.xy = in_TEXCOORD2.xy;
					    u_xlat0.x = dot(in_NORMAL0.xyz, unity_WorldToObject[0].xyz);
					    u_xlat0.y = dot(in_NORMAL0.xyz, unity_WorldToObject[1].xyz);
					    u_xlat0.z = dot(in_NORMAL0.xyz, unity_WorldToObject[2].xyz);
					    u_xlat12 = dot(u_xlat0.xyz, u_xlat0.xyz);
					    u_xlat12 = inversesqrt(u_xlat12);
					    u_xlat0.xyz = vec3(u_xlat12) * u_xlat0.xyz;
					    vs_TEXCOORD4.xyz = u_xlat0.xyz;
					    u_xlat1.xyz = in_TANGENT0.yyy * unity_ObjectToWorld[1].xyz;
					    u_xlat1.xyz = unity_ObjectToWorld[0].xyz * in_TANGENT0.xxx + u_xlat1.xyz;
					    u_xlat1.xyz = unity_ObjectToWorld[2].xyz * in_TANGENT0.zzz + u_xlat1.xyz;
					    u_xlat12 = dot(u_xlat1.xyz, u_xlat1.xyz);
					    u_xlat12 = inversesqrt(u_xlat12);
					    u_xlat1.xyz = vec3(u_xlat12) * u_xlat1.xyz;
					    vs_TEXCOORD5.xyz = u_xlat1.xyz;
					    u_xlat2.xyz = u_xlat0.zxy * u_xlat1.yzx;
					    u_xlat0.xyz = u_xlat0.yzx * u_xlat1.zxy + (-u_xlat2.xyz);
					    u_xlat0.xyz = u_xlat0.xyz * in_TANGENT0.www;
					    u_xlat12 = dot(u_xlat0.xyz, u_xlat0.xyz);
					    u_xlat12 = inversesqrt(u_xlat12);
					    vs_TEXCOORD6.xyz = vec3(u_xlat12) * u_xlat0.xyz;
					    vs_TEXCOORD10 = vec4(0.0, 0.0, 0.0, 0.0);
					    return;
					}"
				}
				SubProgram "d3d11 " {
					Keywords { "DIRECTIONAL" "LIGHTPROBE_SH" "DIRLIGHTMAP_SEPARATE" "LIGHTMAP_OFF" "DYNAMICLIGHTMAP_OFF" }
					"vs_4_0
					
					#version 330
					#extension GL_ARB_explicit_attrib_location : require
					#extension GL_ARB_explicit_uniform_location : require
					
					#define HLSLCC_ENABLE_UNIFORM_BUFFERS 1
					#if HLSLCC_ENABLE_UNIFORM_BUFFERS
					#define UNITY_UNIFORM
					#else
					#define UNITY_UNIFORM uniform
					#endif
					#define UNITY_SUPPORTS_UNIFORM_LOCATION 1
					#if UNITY_SUPPORTS_UNIFORM_LOCATION
					#define UNITY_LOCATION(x) layout(location = x)
					#define UNITY_BINDING(x) layout(binding = x, std140)
					#else
					#define UNITY_LOCATION(x)
					#define UNITY_BINDING(x) layout(std140)
					#endif
					layout(std140) uniform VGlobals {
						vec4 unused_0_0[4];
						vec4 _MainTexture_ST;
						vec4 unused_0_2[2];
						vec4 _Color;
						vec4 _Heightmap_ST;
						float _Bumpiness;
						vec4 unused_0_6;
						float _BumpAttune;
					};
					layout(std140) uniform UnityPerDraw {
						mat4x4 unity_ObjectToWorld;
						mat4x4 unity_WorldToObject;
						vec4 unused_1_2[2];
					};
					layout(std140) uniform UnityPerFrame {
						vec4 unused_2_0[17];
						mat4x4 unity_MatrixVP;
						vec4 unused_2_2[2];
					};
					uniform  sampler2D _Heightmap;
					uniform  sampler2D _MainTexture;
					in  vec4 in_POSITION0;
					in  vec3 in_NORMAL0;
					in  vec4 in_TANGENT0;
					in  vec2 in_TEXCOORD0;
					in  vec2 in_TEXCOORD1;
					in  vec2 in_TEXCOORD2;
					out vec2 vs_TEXCOORD0;
					out vec2 vs_TEXCOORD1;
					out vec2 vs_TEXCOORD2;
					out vec4 vs_TEXCOORD3;
					out vec3 vs_TEXCOORD4;
					out vec3 vs_TEXCOORD5;
					out vec3 vs_TEXCOORD6;
					out vec4 vs_TEXCOORD10;
					vec4 u_xlat0;
					vec4 u_xlat1;
					vec4 u_xlat2;
					vec3 u_xlat3;
					float u_xlat12;
					void main()
					{
					    u_xlat0.xy = in_TEXCOORD0.xy * _MainTexture_ST.xy + _MainTexture_ST.zw;
					    u_xlat0 = textureLod(_MainTexture, u_xlat0.xy, 0.0);
					    u_xlat0.xyz = u_xlat0.xyz * _Color.xyz;
					    u_xlat1.xyz = u_xlat0.xyz * vec3(-1.0, -1.0, 1.0);
					    u_xlat2.xy = in_TEXCOORD0.xy * _Heightmap_ST.xy + _Heightmap_ST.zw;
					    u_xlat2 = textureLod(_Heightmap, u_xlat2.xy, 0.0);
					    u_xlat2.xyz = u_xlat2.xyz * vec3(_Bumpiness);
					    u_xlat2.xyz = clamp(u_xlat2.xyz, 0.0, 1.0);
					    u_xlat3.xyz = u_xlat2.xyz + vec3(0.0, 0.0, 1.0);
					    u_xlat2.xyz = u_xlat2.xyz * in_NORMAL0.xyz;
					    u_xlat12 = dot(u_xlat3.xyz, u_xlat1.xyz);
					    u_xlat1.xyz = vec3(u_xlat12) * u_xlat3.xyz;
					    u_xlat1.xyz = u_xlat1.xyz / u_xlat3.zzz;
					    u_xlat0.xyz = (-u_xlat0.xyz) * vec3(-1.0, -1.0, 1.0) + u_xlat1.xyz;
					    u_xlat0.x = dot(u_xlat0.xyz, vec3(0.300000012, 0.589999974, 0.109999999));
					    u_xlat0.xyz = u_xlat2.xyz * u_xlat0.xxx + (-u_xlat2.xyz);
					    u_xlat0.xyz = vec3(vec3(_BumpAttune, _BumpAttune, _BumpAttune)) * u_xlat0.xyz + u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz + in_POSITION0.xyz;
					    u_xlat1 = u_xlat0.yyyy * unity_ObjectToWorld[1];
					    u_xlat1 = unity_ObjectToWorld[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat0 = unity_ObjectToWorld[2] * u_xlat0.zzzz + u_xlat1;
					    u_xlat1 = u_xlat0 + unity_ObjectToWorld[3];
					    vs_TEXCOORD3 = unity_ObjectToWorld[3] * in_POSITION0.wwww + u_xlat0;
					    u_xlat0 = u_xlat1.yyyy * unity_MatrixVP[1];
					    u_xlat0 = unity_MatrixVP[0] * u_xlat1.xxxx + u_xlat0;
					    u_xlat0 = unity_MatrixVP[2] * u_xlat1.zzzz + u_xlat0;
					    gl_Position = unity_MatrixVP[3] * u_xlat1.wwww + u_xlat0;
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
					    vs_TEXCOORD1.xy = in_TEXCOORD1.xy;
					    vs_TEXCOORD2.xy = in_TEXCOORD2.xy;
					    u_xlat0.x = dot(in_NORMAL0.xyz, unity_WorldToObject[0].xyz);
					    u_xlat0.y = dot(in_NORMAL0.xyz, unity_WorldToObject[1].xyz);
					    u_xlat0.z = dot(in_NORMAL0.xyz, unity_WorldToObject[2].xyz);
					    u_xlat12 = dot(u_xlat0.xyz, u_xlat0.xyz);
					    u_xlat12 = inversesqrt(u_xlat12);
					    u_xlat0.xyz = vec3(u_xlat12) * u_xlat0.xyz;
					    vs_TEXCOORD4.xyz = u_xlat0.xyz;
					    u_xlat1.xyz = in_TANGENT0.yyy * unity_ObjectToWorld[1].xyz;
					    u_xlat1.xyz = unity_ObjectToWorld[0].xyz * in_TANGENT0.xxx + u_xlat1.xyz;
					    u_xlat1.xyz = unity_ObjectToWorld[2].xyz * in_TANGENT0.zzz + u_xlat1.xyz;
					    u_xlat12 = dot(u_xlat1.xyz, u_xlat1.xyz);
					    u_xlat12 = inversesqrt(u_xlat12);
					    u_xlat1.xyz = vec3(u_xlat12) * u_xlat1.xyz;
					    vs_TEXCOORD5.xyz = u_xlat1.xyz;
					    u_xlat2.xyz = u_xlat0.zxy * u_xlat1.yzx;
					    u_xlat0.xyz = u_xlat0.yzx * u_xlat1.zxy + (-u_xlat2.xyz);
					    u_xlat0.xyz = u_xlat0.xyz * in_TANGENT0.www;
					    u_xlat12 = dot(u_xlat0.xyz, u_xlat0.xyz);
					    u_xlat12 = inversesqrt(u_xlat12);
					    vs_TEXCOORD6.xyz = vec3(u_xlat12) * u_xlat0.xyz;
					    vs_TEXCOORD10 = vec4(0.0, 0.0, 0.0, 0.0);
					    return;
					}"
				}
				SubProgram "d3d11 " {
					Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "DIRLIGHTMAP_SEPARATE" "LIGHTMAP_OFF" "DYNAMICLIGHTMAP_OFF" }
					"vs_4_0
					
					#version 330
					#extension GL_ARB_explicit_attrib_location : require
					#extension GL_ARB_explicit_uniform_location : require
					
					#define HLSLCC_ENABLE_UNIFORM_BUFFERS 1
					#if HLSLCC_ENABLE_UNIFORM_BUFFERS
					#define UNITY_UNIFORM
					#else
					#define UNITY_UNIFORM uniform
					#endif
					#define UNITY_SUPPORTS_UNIFORM_LOCATION 1
					#if UNITY_SUPPORTS_UNIFORM_LOCATION
					#define UNITY_LOCATION(x) layout(location = x)
					#define UNITY_BINDING(x) layout(binding = x, std140)
					#else
					#define UNITY_LOCATION(x)
					#define UNITY_BINDING(x) layout(std140)
					#endif
					layout(std140) uniform VGlobals {
						vec4 unused_0_0[4];
						vec4 _MainTexture_ST;
						vec4 unused_0_2[2];
						vec4 _Color;
						vec4 _Heightmap_ST;
						float _Bumpiness;
						vec4 unused_0_6;
						float _BumpAttune;
					};
					layout(std140) uniform UnityPerCamera {
						vec4 unused_1_0[5];
						vec4 _ProjectionParams;
						vec4 unused_1_2[3];
					};
					layout(std140) uniform UnityPerDraw {
						mat4x4 unity_ObjectToWorld;
						mat4x4 unity_WorldToObject;
						vec4 unused_2_2[2];
					};
					layout(std140) uniform UnityPerFrame {
						vec4 unused_3_0[17];
						mat4x4 unity_MatrixVP;
						vec4 unused_3_2[2];
					};
					uniform  sampler2D _Heightmap;
					uniform  sampler2D _MainTexture;
					in  vec4 in_POSITION0;
					in  vec3 in_NORMAL0;
					in  vec4 in_TANGENT0;
					in  vec2 in_TEXCOORD0;
					in  vec2 in_TEXCOORD1;
					in  vec2 in_TEXCOORD2;
					out vec2 vs_TEXCOORD0;
					out vec2 vs_TEXCOORD1;
					out vec2 vs_TEXCOORD2;
					out vec4 vs_TEXCOORD3;
					out vec3 vs_TEXCOORD4;
					out vec3 vs_TEXCOORD5;
					out vec3 vs_TEXCOORD6;
					out vec4 vs_TEXCOORD8;
					out vec4 vs_TEXCOORD10;
					vec4 u_xlat0;
					vec4 u_xlat1;
					vec4 u_xlat2;
					vec3 u_xlat3;
					float u_xlat12;
					float u_xlat13;
					void main()
					{
					    u_xlat0.xy = in_TEXCOORD0.xy * _MainTexture_ST.xy + _MainTexture_ST.zw;
					    u_xlat0 = textureLod(_MainTexture, u_xlat0.xy, 0.0);
					    u_xlat0.xyz = u_xlat0.xyz * _Color.xyz;
					    u_xlat1.xyz = u_xlat0.xyz * vec3(-1.0, -1.0, 1.0);
					    u_xlat2.xy = in_TEXCOORD0.xy * _Heightmap_ST.xy + _Heightmap_ST.zw;
					    u_xlat2 = textureLod(_Heightmap, u_xlat2.xy, 0.0);
					    u_xlat2.xyz = u_xlat2.xyz * vec3(_Bumpiness);
					    u_xlat2.xyz = clamp(u_xlat2.xyz, 0.0, 1.0);
					    u_xlat3.xyz = u_xlat2.xyz + vec3(0.0, 0.0, 1.0);
					    u_xlat2.xyz = u_xlat2.xyz * in_NORMAL0.xyz;
					    u_xlat12 = dot(u_xlat3.xyz, u_xlat1.xyz);
					    u_xlat1.xyz = vec3(u_xlat12) * u_xlat3.xyz;
					    u_xlat1.xyz = u_xlat1.xyz / u_xlat3.zzz;
					    u_xlat0.xyz = (-u_xlat0.xyz) * vec3(-1.0, -1.0, 1.0) + u_xlat1.xyz;
					    u_xlat0.x = dot(u_xlat0.xyz, vec3(0.300000012, 0.589999974, 0.109999999));
					    u_xlat0.xyz = u_xlat2.xyz * u_xlat0.xxx + (-u_xlat2.xyz);
					    u_xlat0.xyz = vec3(vec3(_BumpAttune, _BumpAttune, _BumpAttune)) * u_xlat0.xyz + u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz + in_POSITION0.xyz;
					    u_xlat1 = u_xlat0.yyyy * unity_ObjectToWorld[1];
					    u_xlat1 = unity_ObjectToWorld[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat0 = unity_ObjectToWorld[2] * u_xlat0.zzzz + u_xlat1;
					    u_xlat1 = u_xlat0 + unity_ObjectToWorld[3];
					    vs_TEXCOORD3 = unity_ObjectToWorld[3] * in_POSITION0.wwww + u_xlat0;
					    u_xlat0 = u_xlat1.yyyy * unity_MatrixVP[1];
					    u_xlat0 = unity_MatrixVP[0] * u_xlat1.xxxx + u_xlat0;
					    u_xlat0 = unity_MatrixVP[2] * u_xlat1.zzzz + u_xlat0;
					    u_xlat0 = unity_MatrixVP[3] * u_xlat1.wwww + u_xlat0;
					    gl_Position = u_xlat0;
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
					    vs_TEXCOORD1.xy = in_TEXCOORD1.xy;
					    vs_TEXCOORD2.xy = in_TEXCOORD2.xy;
					    u_xlat1.x = dot(in_NORMAL0.xyz, unity_WorldToObject[0].xyz);
					    u_xlat1.y = dot(in_NORMAL0.xyz, unity_WorldToObject[1].xyz);
					    u_xlat1.z = dot(in_NORMAL0.xyz, unity_WorldToObject[2].xyz);
					    u_xlat13 = dot(u_xlat1.xyz, u_xlat1.xyz);
					    u_xlat13 = inversesqrt(u_xlat13);
					    u_xlat1.xyz = vec3(u_xlat13) * u_xlat1.xyz;
					    vs_TEXCOORD4.xyz = u_xlat1.xyz;
					    u_xlat2.xyz = in_TANGENT0.yyy * unity_ObjectToWorld[1].xyz;
					    u_xlat2.xyz = unity_ObjectToWorld[0].xyz * in_TANGENT0.xxx + u_xlat2.xyz;
					    u_xlat2.xyz = unity_ObjectToWorld[2].xyz * in_TANGENT0.zzz + u_xlat2.xyz;
					    u_xlat13 = dot(u_xlat2.xyz, u_xlat2.xyz);
					    u_xlat13 = inversesqrt(u_xlat13);
					    u_xlat2.xyz = vec3(u_xlat13) * u_xlat2.xyz;
					    vs_TEXCOORD5.xyz = u_xlat2.xyz;
					    u_xlat3.xyz = u_xlat1.zxy * u_xlat2.yzx;
					    u_xlat1.xyz = u_xlat1.yzx * u_xlat2.zxy + (-u_xlat3.xyz);
					    u_xlat1.xyz = u_xlat1.xyz * in_TANGENT0.www;
					    u_xlat13 = dot(u_xlat1.xyz, u_xlat1.xyz);
					    u_xlat13 = inversesqrt(u_xlat13);
					    vs_TEXCOORD6.xyz = vec3(u_xlat13) * u_xlat1.xyz;
					    u_xlat0.y = u_xlat0.y * _ProjectionParams.x;
					    u_xlat1.xzw = u_xlat0.xwy * vec3(0.5, 0.5, 0.5);
					    vs_TEXCOORD8.zw = u_xlat0.zw;
					    vs_TEXCOORD8.xy = u_xlat1.zz + u_xlat1.xw;
					    vs_TEXCOORD10 = vec4(0.0, 0.0, 0.0, 0.0);
					    return;
					}"
				}
				SubProgram "d3d11 " {
					Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "LIGHTPROBE_SH" "DIRLIGHTMAP_SEPARATE" "LIGHTMAP_OFF" "DYNAMICLIGHTMAP_OFF" }
					"vs_4_0
					
					#version 330
					#extension GL_ARB_explicit_attrib_location : require
					#extension GL_ARB_explicit_uniform_location : require
					
					#define HLSLCC_ENABLE_UNIFORM_BUFFERS 1
					#if HLSLCC_ENABLE_UNIFORM_BUFFERS
					#define UNITY_UNIFORM
					#else
					#define UNITY_UNIFORM uniform
					#endif
					#define UNITY_SUPPORTS_UNIFORM_LOCATION 1
					#if UNITY_SUPPORTS_UNIFORM_LOCATION
					#define UNITY_LOCATION(x) layout(location = x)
					#define UNITY_BINDING(x) layout(binding = x, std140)
					#else
					#define UNITY_LOCATION(x)
					#define UNITY_BINDING(x) layout(std140)
					#endif
					layout(std140) uniform VGlobals {
						vec4 unused_0_0[4];
						vec4 _MainTexture_ST;
						vec4 unused_0_2[2];
						vec4 _Color;
						vec4 _Heightmap_ST;
						float _Bumpiness;
						vec4 unused_0_6;
						float _BumpAttune;
					};
					layout(std140) uniform UnityPerCamera {
						vec4 unused_1_0[5];
						vec4 _ProjectionParams;
						vec4 unused_1_2[3];
					};
					layout(std140) uniform UnityPerDraw {
						mat4x4 unity_ObjectToWorld;
						mat4x4 unity_WorldToObject;
						vec4 unused_2_2[2];
					};
					layout(std140) uniform UnityPerFrame {
						vec4 unused_3_0[17];
						mat4x4 unity_MatrixVP;
						vec4 unused_3_2[2];
					};
					uniform  sampler2D _Heightmap;
					uniform  sampler2D _MainTexture;
					in  vec4 in_POSITION0;
					in  vec3 in_NORMAL0;
					in  vec4 in_TANGENT0;
					in  vec2 in_TEXCOORD0;
					in  vec2 in_TEXCOORD1;
					in  vec2 in_TEXCOORD2;
					out vec2 vs_TEXCOORD0;
					out vec2 vs_TEXCOORD1;
					out vec2 vs_TEXCOORD2;
					out vec4 vs_TEXCOORD3;
					out vec3 vs_TEXCOORD4;
					out vec3 vs_TEXCOORD5;
					out vec3 vs_TEXCOORD6;
					out vec4 vs_TEXCOORD8;
					out vec4 vs_TEXCOORD10;
					vec4 u_xlat0;
					vec4 u_xlat1;
					vec4 u_xlat2;
					vec3 u_xlat3;
					float u_xlat12;
					float u_xlat13;
					void main()
					{
					    u_xlat0.xy = in_TEXCOORD0.xy * _MainTexture_ST.xy + _MainTexture_ST.zw;
					    u_xlat0 = textureLod(_MainTexture, u_xlat0.xy, 0.0);
					    u_xlat0.xyz = u_xlat0.xyz * _Color.xyz;
					    u_xlat1.xyz = u_xlat0.xyz * vec3(-1.0, -1.0, 1.0);
					    u_xlat2.xy = in_TEXCOORD0.xy * _Heightmap_ST.xy + _Heightmap_ST.zw;
					    u_xlat2 = textureLod(_Heightmap, u_xlat2.xy, 0.0);
					    u_xlat2.xyz = u_xlat2.xyz * vec3(_Bumpiness);
					    u_xlat2.xyz = clamp(u_xlat2.xyz, 0.0, 1.0);
					    u_xlat3.xyz = u_xlat2.xyz + vec3(0.0, 0.0, 1.0);
					    u_xlat2.xyz = u_xlat2.xyz * in_NORMAL0.xyz;
					    u_xlat12 = dot(u_xlat3.xyz, u_xlat1.xyz);
					    u_xlat1.xyz = vec3(u_xlat12) * u_xlat3.xyz;
					    u_xlat1.xyz = u_xlat1.xyz / u_xlat3.zzz;
					    u_xlat0.xyz = (-u_xlat0.xyz) * vec3(-1.0, -1.0, 1.0) + u_xlat1.xyz;
					    u_xlat0.x = dot(u_xlat0.xyz, vec3(0.300000012, 0.589999974, 0.109999999));
					    u_xlat0.xyz = u_xlat2.xyz * u_xlat0.xxx + (-u_xlat2.xyz);
					    u_xlat0.xyz = vec3(vec3(_BumpAttune, _BumpAttune, _BumpAttune)) * u_xlat0.xyz + u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz + in_POSITION0.xyz;
					    u_xlat1 = u_xlat0.yyyy * unity_ObjectToWorld[1];
					    u_xlat1 = unity_ObjectToWorld[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat0 = unity_ObjectToWorld[2] * u_xlat0.zzzz + u_xlat1;
					    u_xlat1 = u_xlat0 + unity_ObjectToWorld[3];
					    vs_TEXCOORD3 = unity_ObjectToWorld[3] * in_POSITION0.wwww + u_xlat0;
					    u_xlat0 = u_xlat1.yyyy * unity_MatrixVP[1];
					    u_xlat0 = unity_MatrixVP[0] * u_xlat1.xxxx + u_xlat0;
					    u_xlat0 = unity_MatrixVP[2] * u_xlat1.zzzz + u_xlat0;
					    u_xlat0 = unity_MatrixVP[3] * u_xlat1.wwww + u_xlat0;
					    gl_Position = u_xlat0;
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
					    vs_TEXCOORD1.xy = in_TEXCOORD1.xy;
					    vs_TEXCOORD2.xy = in_TEXCOORD2.xy;
					    u_xlat1.x = dot(in_NORMAL0.xyz, unity_WorldToObject[0].xyz);
					    u_xlat1.y = dot(in_NORMAL0.xyz, unity_WorldToObject[1].xyz);
					    u_xlat1.z = dot(in_NORMAL0.xyz, unity_WorldToObject[2].xyz);
					    u_xlat13 = dot(u_xlat1.xyz, u_xlat1.xyz);
					    u_xlat13 = inversesqrt(u_xlat13);
					    u_xlat1.xyz = vec3(u_xlat13) * u_xlat1.xyz;
					    vs_TEXCOORD4.xyz = u_xlat1.xyz;
					    u_xlat2.xyz = in_TANGENT0.yyy * unity_ObjectToWorld[1].xyz;
					    u_xlat2.xyz = unity_ObjectToWorld[0].xyz * in_TANGENT0.xxx + u_xlat2.xyz;
					    u_xlat2.xyz = unity_ObjectToWorld[2].xyz * in_TANGENT0.zzz + u_xlat2.xyz;
					    u_xlat13 = dot(u_xlat2.xyz, u_xlat2.xyz);
					    u_xlat13 = inversesqrt(u_xlat13);
					    u_xlat2.xyz = vec3(u_xlat13) * u_xlat2.xyz;
					    vs_TEXCOORD5.xyz = u_xlat2.xyz;
					    u_xlat3.xyz = u_xlat1.zxy * u_xlat2.yzx;
					    u_xlat1.xyz = u_xlat1.yzx * u_xlat2.zxy + (-u_xlat3.xyz);
					    u_xlat1.xyz = u_xlat1.xyz * in_TANGENT0.www;
					    u_xlat13 = dot(u_xlat1.xyz, u_xlat1.xyz);
					    u_xlat13 = inversesqrt(u_xlat13);
					    vs_TEXCOORD6.xyz = vec3(u_xlat13) * u_xlat1.xyz;
					    u_xlat0.y = u_xlat0.y * _ProjectionParams.x;
					    u_xlat1.xzw = u_xlat0.xwy * vec3(0.5, 0.5, 0.5);
					    vs_TEXCOORD8.zw = u_xlat0.zw;
					    vs_TEXCOORD8.xy = u_xlat1.zz + u_xlat1.xw;
					    vs_TEXCOORD10 = vec4(0.0, 0.0, 0.0, 0.0);
					    return;
					}"
				}
				SubProgram "d3d11 " {
					Keywords { "DIRECTIONAL" "VERTEXLIGHT_ON" "DIRLIGHTMAP_SEPARATE" "LIGHTMAP_OFF" "DYNAMICLIGHTMAP_OFF" }
					"vs_4_0
					
					#version 330
					#extension GL_ARB_explicit_attrib_location : require
					#extension GL_ARB_explicit_uniform_location : require
					
					#define HLSLCC_ENABLE_UNIFORM_BUFFERS 1
					#if HLSLCC_ENABLE_UNIFORM_BUFFERS
					#define UNITY_UNIFORM
					#else
					#define UNITY_UNIFORM uniform
					#endif
					#define UNITY_SUPPORTS_UNIFORM_LOCATION 1
					#if UNITY_SUPPORTS_UNIFORM_LOCATION
					#define UNITY_LOCATION(x) layout(location = x)
					#define UNITY_BINDING(x) layout(binding = x, std140)
					#else
					#define UNITY_LOCATION(x)
					#define UNITY_BINDING(x) layout(std140)
					#endif
					layout(std140) uniform VGlobals {
						vec4 unused_0_0[4];
						vec4 _MainTexture_ST;
						vec4 unused_0_2[2];
						vec4 _Color;
						vec4 _Heightmap_ST;
						float _Bumpiness;
						vec4 unused_0_6;
						float _BumpAttune;
					};
					layout(std140) uniform UnityPerDraw {
						mat4x4 unity_ObjectToWorld;
						mat4x4 unity_WorldToObject;
						vec4 unused_1_2[2];
					};
					layout(std140) uniform UnityPerFrame {
						vec4 unused_2_0[17];
						mat4x4 unity_MatrixVP;
						vec4 unused_2_2[2];
					};
					uniform  sampler2D _Heightmap;
					uniform  sampler2D _MainTexture;
					in  vec4 in_POSITION0;
					in  vec3 in_NORMAL0;
					in  vec4 in_TANGENT0;
					in  vec2 in_TEXCOORD0;
					in  vec2 in_TEXCOORD1;
					in  vec2 in_TEXCOORD2;
					out vec2 vs_TEXCOORD0;
					out vec2 vs_TEXCOORD1;
					out vec2 vs_TEXCOORD2;
					out vec4 vs_TEXCOORD3;
					out vec3 vs_TEXCOORD4;
					out vec3 vs_TEXCOORD5;
					out vec3 vs_TEXCOORD6;
					out vec4 vs_TEXCOORD10;
					vec4 u_xlat0;
					vec4 u_xlat1;
					vec4 u_xlat2;
					vec3 u_xlat3;
					float u_xlat12;
					void main()
					{
					    u_xlat0.xy = in_TEXCOORD0.xy * _MainTexture_ST.xy + _MainTexture_ST.zw;
					    u_xlat0 = textureLod(_MainTexture, u_xlat0.xy, 0.0);
					    u_xlat0.xyz = u_xlat0.xyz * _Color.xyz;
					    u_xlat1.xyz = u_xlat0.xyz * vec3(-1.0, -1.0, 1.0);
					    u_xlat2.xy = in_TEXCOORD0.xy * _Heightmap_ST.xy + _Heightmap_ST.zw;
					    u_xlat2 = textureLod(_Heightmap, u_xlat2.xy, 0.0);
					    u_xlat2.xyz = u_xlat2.xyz * vec3(_Bumpiness);
					    u_xlat2.xyz = clamp(u_xlat2.xyz, 0.0, 1.0);
					    u_xlat3.xyz = u_xlat2.xyz + vec3(0.0, 0.0, 1.0);
					    u_xlat2.xyz = u_xlat2.xyz * in_NORMAL0.xyz;
					    u_xlat12 = dot(u_xlat3.xyz, u_xlat1.xyz);
					    u_xlat1.xyz = vec3(u_xlat12) * u_xlat3.xyz;
					    u_xlat1.xyz = u_xlat1.xyz / u_xlat3.zzz;
					    u_xlat0.xyz = (-u_xlat0.xyz) * vec3(-1.0, -1.0, 1.0) + u_xlat1.xyz;
					    u_xlat0.x = dot(u_xlat0.xyz, vec3(0.300000012, 0.589999974, 0.109999999));
					    u_xlat0.xyz = u_xlat2.xyz * u_xlat0.xxx + (-u_xlat2.xyz);
					    u_xlat0.xyz = vec3(vec3(_BumpAttune, _BumpAttune, _BumpAttune)) * u_xlat0.xyz + u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz + in_POSITION0.xyz;
					    u_xlat1 = u_xlat0.yyyy * unity_ObjectToWorld[1];
					    u_xlat1 = unity_ObjectToWorld[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat0 = unity_ObjectToWorld[2] * u_xlat0.zzzz + u_xlat1;
					    u_xlat1 = u_xlat0 + unity_ObjectToWorld[3];
					    vs_TEXCOORD3 = unity_ObjectToWorld[3] * in_POSITION0.wwww + u_xlat0;
					    u_xlat0 = u_xlat1.yyyy * unity_MatrixVP[1];
					    u_xlat0 = unity_MatrixVP[0] * u_xlat1.xxxx + u_xlat0;
					    u_xlat0 = unity_MatrixVP[2] * u_xlat1.zzzz + u_xlat0;
					    gl_Position = unity_MatrixVP[3] * u_xlat1.wwww + u_xlat0;
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
					    vs_TEXCOORD1.xy = in_TEXCOORD1.xy;
					    vs_TEXCOORD2.xy = in_TEXCOORD2.xy;
					    u_xlat0.x = dot(in_NORMAL0.xyz, unity_WorldToObject[0].xyz);
					    u_xlat0.y = dot(in_NORMAL0.xyz, unity_WorldToObject[1].xyz);
					    u_xlat0.z = dot(in_NORMAL0.xyz, unity_WorldToObject[2].xyz);
					    u_xlat12 = dot(u_xlat0.xyz, u_xlat0.xyz);
					    u_xlat12 = inversesqrt(u_xlat12);
					    u_xlat0.xyz = vec3(u_xlat12) * u_xlat0.xyz;
					    vs_TEXCOORD4.xyz = u_xlat0.xyz;
					    u_xlat1.xyz = in_TANGENT0.yyy * unity_ObjectToWorld[1].xyz;
					    u_xlat1.xyz = unity_ObjectToWorld[0].xyz * in_TANGENT0.xxx + u_xlat1.xyz;
					    u_xlat1.xyz = unity_ObjectToWorld[2].xyz * in_TANGENT0.zzz + u_xlat1.xyz;
					    u_xlat12 = dot(u_xlat1.xyz, u_xlat1.xyz);
					    u_xlat12 = inversesqrt(u_xlat12);
					    u_xlat1.xyz = vec3(u_xlat12) * u_xlat1.xyz;
					    vs_TEXCOORD5.xyz = u_xlat1.xyz;
					    u_xlat2.xyz = u_xlat0.zxy * u_xlat1.yzx;
					    u_xlat0.xyz = u_xlat0.yzx * u_xlat1.zxy + (-u_xlat2.xyz);
					    u_xlat0.xyz = u_xlat0.xyz * in_TANGENT0.www;
					    u_xlat12 = dot(u_xlat0.xyz, u_xlat0.xyz);
					    u_xlat12 = inversesqrt(u_xlat12);
					    vs_TEXCOORD6.xyz = vec3(u_xlat12) * u_xlat0.xyz;
					    vs_TEXCOORD10 = vec4(0.0, 0.0, 0.0, 0.0);
					    return;
					}"
				}
				SubProgram "d3d11 " {
					Keywords { "DIRECTIONAL" "LIGHTPROBE_SH" "VERTEXLIGHT_ON" "DIRLIGHTMAP_SEPARATE" "LIGHTMAP_OFF" "DYNAMICLIGHTMAP_OFF" }
					"vs_4_0
					
					#version 330
					#extension GL_ARB_explicit_attrib_location : require
					#extension GL_ARB_explicit_uniform_location : require
					
					#define HLSLCC_ENABLE_UNIFORM_BUFFERS 1
					#if HLSLCC_ENABLE_UNIFORM_BUFFERS
					#define UNITY_UNIFORM
					#else
					#define UNITY_UNIFORM uniform
					#endif
					#define UNITY_SUPPORTS_UNIFORM_LOCATION 1
					#if UNITY_SUPPORTS_UNIFORM_LOCATION
					#define UNITY_LOCATION(x) layout(location = x)
					#define UNITY_BINDING(x) layout(binding = x, std140)
					#else
					#define UNITY_LOCATION(x)
					#define UNITY_BINDING(x) layout(std140)
					#endif
					layout(std140) uniform VGlobals {
						vec4 unused_0_0[4];
						vec4 _MainTexture_ST;
						vec4 unused_0_2[2];
						vec4 _Color;
						vec4 _Heightmap_ST;
						float _Bumpiness;
						vec4 unused_0_6;
						float _BumpAttune;
					};
					layout(std140) uniform UnityPerDraw {
						mat4x4 unity_ObjectToWorld;
						mat4x4 unity_WorldToObject;
						vec4 unused_1_2[2];
					};
					layout(std140) uniform UnityPerFrame {
						vec4 unused_2_0[17];
						mat4x4 unity_MatrixVP;
						vec4 unused_2_2[2];
					};
					uniform  sampler2D _Heightmap;
					uniform  sampler2D _MainTexture;
					in  vec4 in_POSITION0;
					in  vec3 in_NORMAL0;
					in  vec4 in_TANGENT0;
					in  vec2 in_TEXCOORD0;
					in  vec2 in_TEXCOORD1;
					in  vec2 in_TEXCOORD2;
					out vec2 vs_TEXCOORD0;
					out vec2 vs_TEXCOORD1;
					out vec2 vs_TEXCOORD2;
					out vec4 vs_TEXCOORD3;
					out vec3 vs_TEXCOORD4;
					out vec3 vs_TEXCOORD5;
					out vec3 vs_TEXCOORD6;
					out vec4 vs_TEXCOORD10;
					vec4 u_xlat0;
					vec4 u_xlat1;
					vec4 u_xlat2;
					vec3 u_xlat3;
					float u_xlat12;
					void main()
					{
					    u_xlat0.xy = in_TEXCOORD0.xy * _MainTexture_ST.xy + _MainTexture_ST.zw;
					    u_xlat0 = textureLod(_MainTexture, u_xlat0.xy, 0.0);
					    u_xlat0.xyz = u_xlat0.xyz * _Color.xyz;
					    u_xlat1.xyz = u_xlat0.xyz * vec3(-1.0, -1.0, 1.0);
					    u_xlat2.xy = in_TEXCOORD0.xy * _Heightmap_ST.xy + _Heightmap_ST.zw;
					    u_xlat2 = textureLod(_Heightmap, u_xlat2.xy, 0.0);
					    u_xlat2.xyz = u_xlat2.xyz * vec3(_Bumpiness);
					    u_xlat2.xyz = clamp(u_xlat2.xyz, 0.0, 1.0);
					    u_xlat3.xyz = u_xlat2.xyz + vec3(0.0, 0.0, 1.0);
					    u_xlat2.xyz = u_xlat2.xyz * in_NORMAL0.xyz;
					    u_xlat12 = dot(u_xlat3.xyz, u_xlat1.xyz);
					    u_xlat1.xyz = vec3(u_xlat12) * u_xlat3.xyz;
					    u_xlat1.xyz = u_xlat1.xyz / u_xlat3.zzz;
					    u_xlat0.xyz = (-u_xlat0.xyz) * vec3(-1.0, -1.0, 1.0) + u_xlat1.xyz;
					    u_xlat0.x = dot(u_xlat0.xyz, vec3(0.300000012, 0.589999974, 0.109999999));
					    u_xlat0.xyz = u_xlat2.xyz * u_xlat0.xxx + (-u_xlat2.xyz);
					    u_xlat0.xyz = vec3(vec3(_BumpAttune, _BumpAttune, _BumpAttune)) * u_xlat0.xyz + u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz + in_POSITION0.xyz;
					    u_xlat1 = u_xlat0.yyyy * unity_ObjectToWorld[1];
					    u_xlat1 = unity_ObjectToWorld[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat0 = unity_ObjectToWorld[2] * u_xlat0.zzzz + u_xlat1;
					    u_xlat1 = u_xlat0 + unity_ObjectToWorld[3];
					    vs_TEXCOORD3 = unity_ObjectToWorld[3] * in_POSITION0.wwww + u_xlat0;
					    u_xlat0 = u_xlat1.yyyy * unity_MatrixVP[1];
					    u_xlat0 = unity_MatrixVP[0] * u_xlat1.xxxx + u_xlat0;
					    u_xlat0 = unity_MatrixVP[2] * u_xlat1.zzzz + u_xlat0;
					    gl_Position = unity_MatrixVP[3] * u_xlat1.wwww + u_xlat0;
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
					    vs_TEXCOORD1.xy = in_TEXCOORD1.xy;
					    vs_TEXCOORD2.xy = in_TEXCOORD2.xy;
					    u_xlat0.x = dot(in_NORMAL0.xyz, unity_WorldToObject[0].xyz);
					    u_xlat0.y = dot(in_NORMAL0.xyz, unity_WorldToObject[1].xyz);
					    u_xlat0.z = dot(in_NORMAL0.xyz, unity_WorldToObject[2].xyz);
					    u_xlat12 = dot(u_xlat0.xyz, u_xlat0.xyz);
					    u_xlat12 = inversesqrt(u_xlat12);
					    u_xlat0.xyz = vec3(u_xlat12) * u_xlat0.xyz;
					    vs_TEXCOORD4.xyz = u_xlat0.xyz;
					    u_xlat1.xyz = in_TANGENT0.yyy * unity_ObjectToWorld[1].xyz;
					    u_xlat1.xyz = unity_ObjectToWorld[0].xyz * in_TANGENT0.xxx + u_xlat1.xyz;
					    u_xlat1.xyz = unity_ObjectToWorld[2].xyz * in_TANGENT0.zzz + u_xlat1.xyz;
					    u_xlat12 = dot(u_xlat1.xyz, u_xlat1.xyz);
					    u_xlat12 = inversesqrt(u_xlat12);
					    u_xlat1.xyz = vec3(u_xlat12) * u_xlat1.xyz;
					    vs_TEXCOORD5.xyz = u_xlat1.xyz;
					    u_xlat2.xyz = u_xlat0.zxy * u_xlat1.yzx;
					    u_xlat0.xyz = u_xlat0.yzx * u_xlat1.zxy + (-u_xlat2.xyz);
					    u_xlat0.xyz = u_xlat0.xyz * in_TANGENT0.www;
					    u_xlat12 = dot(u_xlat0.xyz, u_xlat0.xyz);
					    u_xlat12 = inversesqrt(u_xlat12);
					    vs_TEXCOORD6.xyz = vec3(u_xlat12) * u_xlat0.xyz;
					    vs_TEXCOORD10 = vec4(0.0, 0.0, 0.0, 0.0);
					    return;
					}"
				}
				SubProgram "d3d11 " {
					Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "VERTEXLIGHT_ON" "DIRLIGHTMAP_SEPARATE" "LIGHTMAP_OFF" "DYNAMICLIGHTMAP_OFF" }
					"vs_4_0
					
					#version 330
					#extension GL_ARB_explicit_attrib_location : require
					#extension GL_ARB_explicit_uniform_location : require
					
					#define HLSLCC_ENABLE_UNIFORM_BUFFERS 1
					#if HLSLCC_ENABLE_UNIFORM_BUFFERS
					#define UNITY_UNIFORM
					#else
					#define UNITY_UNIFORM uniform
					#endif
					#define UNITY_SUPPORTS_UNIFORM_LOCATION 1
					#if UNITY_SUPPORTS_UNIFORM_LOCATION
					#define UNITY_LOCATION(x) layout(location = x)
					#define UNITY_BINDING(x) layout(binding = x, std140)
					#else
					#define UNITY_LOCATION(x)
					#define UNITY_BINDING(x) layout(std140)
					#endif
					layout(std140) uniform VGlobals {
						vec4 unused_0_0[4];
						vec4 _MainTexture_ST;
						vec4 unused_0_2[2];
						vec4 _Color;
						vec4 _Heightmap_ST;
						float _Bumpiness;
						vec4 unused_0_6;
						float _BumpAttune;
					};
					layout(std140) uniform UnityPerCamera {
						vec4 unused_1_0[5];
						vec4 _ProjectionParams;
						vec4 unused_1_2[3];
					};
					layout(std140) uniform UnityPerDraw {
						mat4x4 unity_ObjectToWorld;
						mat4x4 unity_WorldToObject;
						vec4 unused_2_2[2];
					};
					layout(std140) uniform UnityPerFrame {
						vec4 unused_3_0[17];
						mat4x4 unity_MatrixVP;
						vec4 unused_3_2[2];
					};
					uniform  sampler2D _Heightmap;
					uniform  sampler2D _MainTexture;
					in  vec4 in_POSITION0;
					in  vec3 in_NORMAL0;
					in  vec4 in_TANGENT0;
					in  vec2 in_TEXCOORD0;
					in  vec2 in_TEXCOORD1;
					in  vec2 in_TEXCOORD2;
					out vec2 vs_TEXCOORD0;
					out vec2 vs_TEXCOORD1;
					out vec2 vs_TEXCOORD2;
					out vec4 vs_TEXCOORD3;
					out vec3 vs_TEXCOORD4;
					out vec3 vs_TEXCOORD5;
					out vec3 vs_TEXCOORD6;
					out vec4 vs_TEXCOORD8;
					out vec4 vs_TEXCOORD10;
					vec4 u_xlat0;
					vec4 u_xlat1;
					vec4 u_xlat2;
					vec3 u_xlat3;
					float u_xlat12;
					float u_xlat13;
					void main()
					{
					    u_xlat0.xy = in_TEXCOORD0.xy * _MainTexture_ST.xy + _MainTexture_ST.zw;
					    u_xlat0 = textureLod(_MainTexture, u_xlat0.xy, 0.0);
					    u_xlat0.xyz = u_xlat0.xyz * _Color.xyz;
					    u_xlat1.xyz = u_xlat0.xyz * vec3(-1.0, -1.0, 1.0);
					    u_xlat2.xy = in_TEXCOORD0.xy * _Heightmap_ST.xy + _Heightmap_ST.zw;
					    u_xlat2 = textureLod(_Heightmap, u_xlat2.xy, 0.0);
					    u_xlat2.xyz = u_xlat2.xyz * vec3(_Bumpiness);
					    u_xlat2.xyz = clamp(u_xlat2.xyz, 0.0, 1.0);
					    u_xlat3.xyz = u_xlat2.xyz + vec3(0.0, 0.0, 1.0);
					    u_xlat2.xyz = u_xlat2.xyz * in_NORMAL0.xyz;
					    u_xlat12 = dot(u_xlat3.xyz, u_xlat1.xyz);
					    u_xlat1.xyz = vec3(u_xlat12) * u_xlat3.xyz;
					    u_xlat1.xyz = u_xlat1.xyz / u_xlat3.zzz;
					    u_xlat0.xyz = (-u_xlat0.xyz) * vec3(-1.0, -1.0, 1.0) + u_xlat1.xyz;
					    u_xlat0.x = dot(u_xlat0.xyz, vec3(0.300000012, 0.589999974, 0.109999999));
					    u_xlat0.xyz = u_xlat2.xyz * u_xlat0.xxx + (-u_xlat2.xyz);
					    u_xlat0.xyz = vec3(vec3(_BumpAttune, _BumpAttune, _BumpAttune)) * u_xlat0.xyz + u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz + in_POSITION0.xyz;
					    u_xlat1 = u_xlat0.yyyy * unity_ObjectToWorld[1];
					    u_xlat1 = unity_ObjectToWorld[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat0 = unity_ObjectToWorld[2] * u_xlat0.zzzz + u_xlat1;
					    u_xlat1 = u_xlat0 + unity_ObjectToWorld[3];
					    vs_TEXCOORD3 = unity_ObjectToWorld[3] * in_POSITION0.wwww + u_xlat0;
					    u_xlat0 = u_xlat1.yyyy * unity_MatrixVP[1];
					    u_xlat0 = unity_MatrixVP[0] * u_xlat1.xxxx + u_xlat0;
					    u_xlat0 = unity_MatrixVP[2] * u_xlat1.zzzz + u_xlat0;
					    u_xlat0 = unity_MatrixVP[3] * u_xlat1.wwww + u_xlat0;
					    gl_Position = u_xlat0;
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
					    vs_TEXCOORD1.xy = in_TEXCOORD1.xy;
					    vs_TEXCOORD2.xy = in_TEXCOORD2.xy;
					    u_xlat1.x = dot(in_NORMAL0.xyz, unity_WorldToObject[0].xyz);
					    u_xlat1.y = dot(in_NORMAL0.xyz, unity_WorldToObject[1].xyz);
					    u_xlat1.z = dot(in_NORMAL0.xyz, unity_WorldToObject[2].xyz);
					    u_xlat13 = dot(u_xlat1.xyz, u_xlat1.xyz);
					    u_xlat13 = inversesqrt(u_xlat13);
					    u_xlat1.xyz = vec3(u_xlat13) * u_xlat1.xyz;
					    vs_TEXCOORD4.xyz = u_xlat1.xyz;
					    u_xlat2.xyz = in_TANGENT0.yyy * unity_ObjectToWorld[1].xyz;
					    u_xlat2.xyz = unity_ObjectToWorld[0].xyz * in_TANGENT0.xxx + u_xlat2.xyz;
					    u_xlat2.xyz = unity_ObjectToWorld[2].xyz * in_TANGENT0.zzz + u_xlat2.xyz;
					    u_xlat13 = dot(u_xlat2.xyz, u_xlat2.xyz);
					    u_xlat13 = inversesqrt(u_xlat13);
					    u_xlat2.xyz = vec3(u_xlat13) * u_xlat2.xyz;
					    vs_TEXCOORD5.xyz = u_xlat2.xyz;
					    u_xlat3.xyz = u_xlat1.zxy * u_xlat2.yzx;
					    u_xlat1.xyz = u_xlat1.yzx * u_xlat2.zxy + (-u_xlat3.xyz);
					    u_xlat1.xyz = u_xlat1.xyz * in_TANGENT0.www;
					    u_xlat13 = dot(u_xlat1.xyz, u_xlat1.xyz);
					    u_xlat13 = inversesqrt(u_xlat13);
					    vs_TEXCOORD6.xyz = vec3(u_xlat13) * u_xlat1.xyz;
					    u_xlat0.y = u_xlat0.y * _ProjectionParams.x;
					    u_xlat1.xzw = u_xlat0.xwy * vec3(0.5, 0.5, 0.5);
					    vs_TEXCOORD8.zw = u_xlat0.zw;
					    vs_TEXCOORD8.xy = u_xlat1.zz + u_xlat1.xw;
					    vs_TEXCOORD10 = vec4(0.0, 0.0, 0.0, 0.0);
					    return;
					}"
				}
				SubProgram "d3d11 " {
					Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "LIGHTPROBE_SH" "VERTEXLIGHT_ON" "DIRLIGHTMAP_SEPARATE" "LIGHTMAP_OFF" "DYNAMICLIGHTMAP_OFF" }
					"vs_4_0
					
					#version 330
					#extension GL_ARB_explicit_attrib_location : require
					#extension GL_ARB_explicit_uniform_location : require
					
					#define HLSLCC_ENABLE_UNIFORM_BUFFERS 1
					#if HLSLCC_ENABLE_UNIFORM_BUFFERS
					#define UNITY_UNIFORM
					#else
					#define UNITY_UNIFORM uniform
					#endif
					#define UNITY_SUPPORTS_UNIFORM_LOCATION 1
					#if UNITY_SUPPORTS_UNIFORM_LOCATION
					#define UNITY_LOCATION(x) layout(location = x)
					#define UNITY_BINDING(x) layout(binding = x, std140)
					#else
					#define UNITY_LOCATION(x)
					#define UNITY_BINDING(x) layout(std140)
					#endif
					layout(std140) uniform VGlobals {
						vec4 unused_0_0[4];
						vec4 _MainTexture_ST;
						vec4 unused_0_2[2];
						vec4 _Color;
						vec4 _Heightmap_ST;
						float _Bumpiness;
						vec4 unused_0_6;
						float _BumpAttune;
					};
					layout(std140) uniform UnityPerCamera {
						vec4 unused_1_0[5];
						vec4 _ProjectionParams;
						vec4 unused_1_2[3];
					};
					layout(std140) uniform UnityPerDraw {
						mat4x4 unity_ObjectToWorld;
						mat4x4 unity_WorldToObject;
						vec4 unused_2_2[2];
					};
					layout(std140) uniform UnityPerFrame {
						vec4 unused_3_0[17];
						mat4x4 unity_MatrixVP;
						vec4 unused_3_2[2];
					};
					uniform  sampler2D _Heightmap;
					uniform  sampler2D _MainTexture;
					in  vec4 in_POSITION0;
					in  vec3 in_NORMAL0;
					in  vec4 in_TANGENT0;
					in  vec2 in_TEXCOORD0;
					in  vec2 in_TEXCOORD1;
					in  vec2 in_TEXCOORD2;
					out vec2 vs_TEXCOORD0;
					out vec2 vs_TEXCOORD1;
					out vec2 vs_TEXCOORD2;
					out vec4 vs_TEXCOORD3;
					out vec3 vs_TEXCOORD4;
					out vec3 vs_TEXCOORD5;
					out vec3 vs_TEXCOORD6;
					out vec4 vs_TEXCOORD8;
					out vec4 vs_TEXCOORD10;
					vec4 u_xlat0;
					vec4 u_xlat1;
					vec4 u_xlat2;
					vec3 u_xlat3;
					float u_xlat12;
					float u_xlat13;
					void main()
					{
					    u_xlat0.xy = in_TEXCOORD0.xy * _MainTexture_ST.xy + _MainTexture_ST.zw;
					    u_xlat0 = textureLod(_MainTexture, u_xlat0.xy, 0.0);
					    u_xlat0.xyz = u_xlat0.xyz * _Color.xyz;
					    u_xlat1.xyz = u_xlat0.xyz * vec3(-1.0, -1.0, 1.0);
					    u_xlat2.xy = in_TEXCOORD0.xy * _Heightmap_ST.xy + _Heightmap_ST.zw;
					    u_xlat2 = textureLod(_Heightmap, u_xlat2.xy, 0.0);
					    u_xlat2.xyz = u_xlat2.xyz * vec3(_Bumpiness);
					    u_xlat2.xyz = clamp(u_xlat2.xyz, 0.0, 1.0);
					    u_xlat3.xyz = u_xlat2.xyz + vec3(0.0, 0.0, 1.0);
					    u_xlat2.xyz = u_xlat2.xyz * in_NORMAL0.xyz;
					    u_xlat12 = dot(u_xlat3.xyz, u_xlat1.xyz);
					    u_xlat1.xyz = vec3(u_xlat12) * u_xlat3.xyz;
					    u_xlat1.xyz = u_xlat1.xyz / u_xlat3.zzz;
					    u_xlat0.xyz = (-u_xlat0.xyz) * vec3(-1.0, -1.0, 1.0) + u_xlat1.xyz;
					    u_xlat0.x = dot(u_xlat0.xyz, vec3(0.300000012, 0.589999974, 0.109999999));
					    u_xlat0.xyz = u_xlat2.xyz * u_xlat0.xxx + (-u_xlat2.xyz);
					    u_xlat0.xyz = vec3(vec3(_BumpAttune, _BumpAttune, _BumpAttune)) * u_xlat0.xyz + u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz + in_POSITION0.xyz;
					    u_xlat1 = u_xlat0.yyyy * unity_ObjectToWorld[1];
					    u_xlat1 = unity_ObjectToWorld[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat0 = unity_ObjectToWorld[2] * u_xlat0.zzzz + u_xlat1;
					    u_xlat1 = u_xlat0 + unity_ObjectToWorld[3];
					    vs_TEXCOORD3 = unity_ObjectToWorld[3] * in_POSITION0.wwww + u_xlat0;
					    u_xlat0 = u_xlat1.yyyy * unity_MatrixVP[1];
					    u_xlat0 = unity_MatrixVP[0] * u_xlat1.xxxx + u_xlat0;
					    u_xlat0 = unity_MatrixVP[2] * u_xlat1.zzzz + u_xlat0;
					    u_xlat0 = unity_MatrixVP[3] * u_xlat1.wwww + u_xlat0;
					    gl_Position = u_xlat0;
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
					    vs_TEXCOORD1.xy = in_TEXCOORD1.xy;
					    vs_TEXCOORD2.xy = in_TEXCOORD2.xy;
					    u_xlat1.x = dot(in_NORMAL0.xyz, unity_WorldToObject[0].xyz);
					    u_xlat1.y = dot(in_NORMAL0.xyz, unity_WorldToObject[1].xyz);
					    u_xlat1.z = dot(in_NORMAL0.xyz, unity_WorldToObject[2].xyz);
					    u_xlat13 = dot(u_xlat1.xyz, u_xlat1.xyz);
					    u_xlat13 = inversesqrt(u_xlat13);
					    u_xlat1.xyz = vec3(u_xlat13) * u_xlat1.xyz;
					    vs_TEXCOORD4.xyz = u_xlat1.xyz;
					    u_xlat2.xyz = in_TANGENT0.yyy * unity_ObjectToWorld[1].xyz;
					    u_xlat2.xyz = unity_ObjectToWorld[0].xyz * in_TANGENT0.xxx + u_xlat2.xyz;
					    u_xlat2.xyz = unity_ObjectToWorld[2].xyz * in_TANGENT0.zzz + u_xlat2.xyz;
					    u_xlat13 = dot(u_xlat2.xyz, u_xlat2.xyz);
					    u_xlat13 = inversesqrt(u_xlat13);
					    u_xlat2.xyz = vec3(u_xlat13) * u_xlat2.xyz;
					    vs_TEXCOORD5.xyz = u_xlat2.xyz;
					    u_xlat3.xyz = u_xlat1.zxy * u_xlat2.yzx;
					    u_xlat1.xyz = u_xlat1.yzx * u_xlat2.zxy + (-u_xlat3.xyz);
					    u_xlat1.xyz = u_xlat1.xyz * in_TANGENT0.www;
					    u_xlat13 = dot(u_xlat1.xyz, u_xlat1.xyz);
					    u_xlat13 = inversesqrt(u_xlat13);
					    vs_TEXCOORD6.xyz = vec3(u_xlat13) * u_xlat1.xyz;
					    u_xlat0.y = u_xlat0.y * _ProjectionParams.x;
					    u_xlat1.xzw = u_xlat0.xwy * vec3(0.5, 0.5, 0.5);
					    vs_TEXCOORD8.zw = u_xlat0.zw;
					    vs_TEXCOORD8.xy = u_xlat1.zz + u_xlat1.xw;
					    vs_TEXCOORD10 = vec4(0.0, 0.0, 0.0, 0.0);
					    return;
					}"
				}
			}
			Program "fp" {
				SubProgram "d3d11 " {
					Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "DYNAMICLIGHTMAP_OFF" }
					"ps_4_0
					
					#version 330
					#extension GL_ARB_explicit_attrib_location : require
					#extension GL_ARB_explicit_uniform_location : require
					
					#define HLSLCC_ENABLE_UNIFORM_BUFFERS 1
					#if HLSLCC_ENABLE_UNIFORM_BUFFERS
					#define UNITY_UNIFORM
					#else
					#define UNITY_UNIFORM uniform
					#endif
					#define UNITY_SUPPORTS_UNIFORM_LOCATION 1
					#if UNITY_SUPPORTS_UNIFORM_LOCATION
					#define UNITY_LOCATION(x) layout(location = x)
					#define UNITY_BINDING(x) layout(binding = x, std140)
					#else
					#define UNITY_LOCATION(x)
					#define UNITY_BINDING(x) layout(std140)
					#endif
					layout(std140) uniform PGlobals {
						vec4 unused_0_0[2];
						vec4 _LightColor0;
						vec4 unused_0_2;
						vec4 _MainTexture_ST;
						vec4 _Specular_ST;
						vec4 _NormalMap_ST;
						vec4 _Color;
						vec4 unused_0_7;
						float _NormalSharpness;
						vec4 _AmbientOcculsion_ST;
						float _Shadows;
					};
					layout(std140) uniform UnityPerCamera {
						vec4 unused_1_0[4];
						vec3 _WorldSpaceCameraPos;
						vec4 unused_1_2[4];
					};
					layout(std140) uniform UnityLighting {
						vec4 _WorldSpaceLightPos0;
						vec4 unused_2_1[47];
					};
					layout(std140) uniform UnityReflectionProbes {
						vec4 unity_SpecCube0_BoxMax;
						vec4 unity_SpecCube0_BoxMin;
						vec4 unity_SpecCube0_ProbePosition;
						vec4 unity_SpecCube0_HDR;
						vec4 unity_SpecCube1_BoxMax;
						vec4 unity_SpecCube1_BoxMin;
						vec4 unity_SpecCube1_ProbePosition;
						vec4 unity_SpecCube1_HDR;
					};
					uniform  sampler2D _NormalMap;
					uniform  sampler2D _AmbientOcculsion;
					uniform  sampler2D _Specular;
					uniform  sampler2D _MainTexture;
					uniform  samplerCube unity_SpecCube0;
					uniform  samplerCube unity_SpecCube1;
					in  vec2 vs_TEXCOORD0;
					in  vec4 vs_TEXCOORD3;
					in  vec3 vs_TEXCOORD4;
					in  vec3 vs_TEXCOORD5;
					in  vec3 vs_TEXCOORD6;
					layout(location = 0) out vec4 SV_Target0;
					vec4 u_xlat0;
					int u_xlati0;
					vec3 u_xlat1;
					vec4 u_xlat2;
					vec4 u_xlat3;
					vec4 u_xlat4;
					vec4 u_xlat5;
					vec3 u_xlat6;
					vec3 u_xlat7;
					vec3 u_xlat8;
					bvec3 u_xlatb8;
					vec3 u_xlat9;
					bvec3 u_xlatb10;
					vec2 u_xlat11;
					int u_xlati11;
					float u_xlat12;
					vec3 u_xlat15;
					float u_xlat22;
					float u_xlat23;
					float u_xlat33;
					bool u_xlatb33;
					float u_xlat34;
					bool u_xlatb34;
					float u_xlat35;
					void main()
					{
					    u_xlat0.x = dot(vs_TEXCOORD4.xyz, vs_TEXCOORD4.xyz);
					    u_xlat0.x = inversesqrt(u_xlat0.x);
					    u_xlat0.xyz = u_xlat0.xxx * vs_TEXCOORD4.xyz;
					    u_xlat1.xyz = (-vs_TEXCOORD3.xyz) + _WorldSpaceCameraPos.xyz;
					    u_xlat33 = dot(u_xlat1.xyz, u_xlat1.xyz);
					    u_xlat33 = inversesqrt(u_xlat33);
					    u_xlat2.xyz = vec3(u_xlat33) * u_xlat1.xyz;
					    u_xlat3.xy = vs_TEXCOORD0.xy * _NormalMap_ST.xy + _NormalMap_ST.zw;
					    u_xlat3 = texture(_NormalMap, u_xlat3.xy);
					    u_xlat3.x = u_xlat3.w * u_xlat3.x;
					    u_xlat3.xy = u_xlat3.xy * vec2(2.0, 2.0) + vec2(-1.0, -1.0);
					    u_xlat34 = dot(u_xlat3.xy, u_xlat3.xy);
					    u_xlat34 = min(u_xlat34, 1.0);
					    u_xlat34 = (-u_xlat34) + 1.0;
					    u_xlat3.z = sqrt(u_xlat34);
					    u_xlat34 = (-_NormalSharpness) + 1.0;
					    u_xlat3.xyz = u_xlat3.xyz / vec3(u_xlat34);
					    u_xlat3.xyz = clamp(u_xlat3.xyz, 0.0, 1.0);
					    u_xlat4.xyz = u_xlat3.yyy * vs_TEXCOORD6.xyz;
					    u_xlat3.xyw = u_xlat3.xxx * vs_TEXCOORD5.xyz + u_xlat4.xyz;
					    u_xlat3.xyz = u_xlat3.zzz * u_xlat0.xyz + u_xlat3.xyw;
					    u_xlat34 = dot(u_xlat3.xyz, u_xlat3.xyz);
					    u_xlat34 = inversesqrt(u_xlat34);
					    u_xlat3.xyz = vec3(u_xlat34) * u_xlat3.xyz;
					    u_xlat0.x = dot(u_xlat2.xyz, u_xlat0.xyz);
					    u_xlati11 = int((0.0<u_xlat0.x) ? 0xFFFFFFFFu : uint(0));
					    u_xlati0 = int((u_xlat0.x<0.0) ? 0xFFFFFFFFu : uint(0));
					    u_xlati0 = (-u_xlati11) + u_xlati0;
					    u_xlat0.x = float(u_xlati0);
					    u_xlat0.xyz = u_xlat0.xxx * u_xlat3.xyz;
					    u_xlat34 = dot(_WorldSpaceLightPos0.xyz, _WorldSpaceLightPos0.xyz);
					    u_xlat34 = inversesqrt(u_xlat34);
					    u_xlat3.xyz = vec3(u_xlat34) * _WorldSpaceLightPos0.xyz;
					    u_xlat1.xyz = u_xlat1.xyz * vec3(u_xlat33) + u_xlat3.xyz;
					    u_xlat33 = dot(u_xlat1.xyz, u_xlat1.xyz);
					    u_xlat33 = inversesqrt(u_xlat33);
					    u_xlat1.xyz = vec3(u_xlat33) * u_xlat1.xyz;
					    u_xlat33 = dot((-u_xlat2.xyz), u_xlat0.xyz);
					    u_xlat33 = u_xlat33 + u_xlat33;
					    u_xlat4.xyz = u_xlat0.xyz * (-vec3(u_xlat33)) + (-u_xlat2.xyz);
					    u_xlatb33 = 0.0<unity_SpecCube0_ProbePosition.w;
					    if(u_xlatb33){
					        u_xlat33 = dot(u_xlat4.xyz, u_xlat4.xyz);
					        u_xlat33 = inversesqrt(u_xlat33);
					        u_xlat5.xyz = vec3(u_xlat33) * u_xlat4.xyz;
					        u_xlat6.xyz = (-vs_TEXCOORD3.xyz) + unity_SpecCube0_BoxMax.xyz;
					        u_xlat6.xyz = u_xlat6.xyz / u_xlat5.xyz;
					        u_xlat7.xyz = (-vs_TEXCOORD3.xyz) + unity_SpecCube0_BoxMin.xyz;
					        u_xlat7.xyz = u_xlat7.xyz / u_xlat5.xyz;
					        u_xlatb8.xyz = lessThan(vec4(0.0, 0.0, 0.0, 0.0), u_xlat5.xyzx).xyz;
					        {
					            vec3 hlslcc_movcTemp = u_xlat6;
					            hlslcc_movcTemp.x = (u_xlatb8.x) ? u_xlat6.x : u_xlat7.x;
					            hlslcc_movcTemp.y = (u_xlatb8.y) ? u_xlat6.y : u_xlat7.y;
					            hlslcc_movcTemp.z = (u_xlatb8.z) ? u_xlat6.z : u_xlat7.z;
					            u_xlat6 = hlslcc_movcTemp;
					        }
					        u_xlat33 = min(u_xlat6.y, u_xlat6.x);
					        u_xlat33 = min(u_xlat6.z, u_xlat33);
					        u_xlat6.xyz = vs_TEXCOORD3.xyz + (-unity_SpecCube0_ProbePosition.xyz);
					        u_xlat5.xyz = u_xlat5.xyz * vec3(u_xlat33) + u_xlat6.xyz;
					    } else {
					        u_xlat5.xyz = u_xlat4.xyz;
					    }
					    u_xlat5 = textureLod(unity_SpecCube0, u_xlat5.xyz, 6.0);
					    u_xlat33 = u_xlat5.w + -1.0;
					    u_xlat33 = unity_SpecCube0_HDR.w * u_xlat33 + 1.0;
					    u_xlat33 = u_xlat33 * unity_SpecCube0_HDR.x;
					    u_xlat6.xyz = u_xlat5.xyz * vec3(u_xlat33);
					    u_xlatb34 = unity_SpecCube0_BoxMin.w<0.999989986;
					    if(u_xlatb34){
					        u_xlatb34 = 0.0<unity_SpecCube1_ProbePosition.w;
					        if(u_xlatb34){
					            u_xlat34 = dot(u_xlat4.xyz, u_xlat4.xyz);
					            u_xlat34 = inversesqrt(u_xlat34);
					            u_xlat7.xyz = vec3(u_xlat34) * u_xlat4.xyz;
					            u_xlat8.xyz = (-vs_TEXCOORD3.xyz) + unity_SpecCube1_BoxMax.xyz;
					            u_xlat8.xyz = u_xlat8.xyz / u_xlat7.xyz;
					            u_xlat9.xyz = (-vs_TEXCOORD3.xyz) + unity_SpecCube1_BoxMin.xyz;
					            u_xlat9.xyz = u_xlat9.xyz / u_xlat7.xyz;
					            u_xlatb10.xyz = lessThan(vec4(0.0, 0.0, 0.0, 0.0), u_xlat7.xyzx).xyz;
					            {
					                vec3 hlslcc_movcTemp = u_xlat8;
					                hlslcc_movcTemp.x = (u_xlatb10.x) ? u_xlat8.x : u_xlat9.x;
					                hlslcc_movcTemp.y = (u_xlatb10.y) ? u_xlat8.y : u_xlat9.y;
					                hlslcc_movcTemp.z = (u_xlatb10.z) ? u_xlat8.z : u_xlat9.z;
					                u_xlat8 = hlslcc_movcTemp;
					            }
					            u_xlat34 = min(u_xlat8.y, u_xlat8.x);
					            u_xlat34 = min(u_xlat8.z, u_xlat34);
					            u_xlat8.xyz = vs_TEXCOORD3.xyz + (-unity_SpecCube1_ProbePosition.xyz);
					            u_xlat4.xyz = u_xlat7.xyz * vec3(u_xlat34) + u_xlat8.xyz;
					        }
					        u_xlat4 = textureLod(unity_SpecCube1, u_xlat4.xyz, 6.0);
					        u_xlat34 = u_xlat4.w + -1.0;
					        u_xlat34 = unity_SpecCube1_HDR.w * u_xlat34 + 1.0;
					        u_xlat34 = u_xlat34 * unity_SpecCube1_HDR.x;
					        u_xlat4.xyz = u_xlat4.xyz * vec3(u_xlat34);
					        u_xlat5.xyz = vec3(u_xlat33) * u_xlat5.xyz + (-u_xlat4.xyz);
					        u_xlat6.xyz = unity_SpecCube0_BoxMin.www * u_xlat5.xyz + u_xlat4.xyz;
					    }
					    u_xlat0.w = dot(u_xlat0.xyz, u_xlat3.xyz);
					    u_xlat4.xy = vs_TEXCOORD0.xy * _AmbientOcculsion_ST.xy + _AmbientOcculsion_ST.zw;
					    u_xlat4 = texture(_AmbientOcculsion, u_xlat4.xy);
					    u_xlat15.xy = vs_TEXCOORD0.xy * _Specular_ST.xy + _Specular_ST.zw;
					    u_xlat5 = texture(_Specular, u_xlat15.xy);
					    u_xlat34 = dot(u_xlat3.xyz, u_xlat1.xyz);
					    u_xlat34 = max(u_xlat34, 0.0);
					    u_xlat3.xy = vs_TEXCOORD0.xy * _MainTexture_ST.xy + _MainTexture_ST.zw;
					    u_xlat3 = texture(_MainTexture, u_xlat3.xy);
					    u_xlat3.xyz = _Color.xyz * u_xlat3.xyz + vec3(_Shadows);
					    u_xlat3.xyz = u_xlat3.xyz + vec3(-1.0, -1.0, -1.0);
					    u_xlat3.xyz = clamp(u_xlat3.xyz, 0.0, 1.0);
					    u_xlat35 = u_xlat5.x * 0.449999988;
					    u_xlat15.xyz = u_xlat3.xyz + vec3(-0.220916301, -0.220916301, -0.220916301);
					    u_xlat15.xyz = vec3(u_xlat35) * u_xlat15.xyz + vec3(0.220916301, 0.220916301, 0.220916301);
					    u_xlat35 = (-u_xlat5.x) * 0.350587666 + 0.779083729;
					    u_xlat3.xyz = vec3(u_xlat35) * u_xlat3.xyz;
					    u_xlat35 = (-u_xlat35) + 1.0;
					    u_xlat35 = clamp(u_xlat35, 0.0, 1.0);
					    u_xlat2.x = dot(u_xlat0.xyz, u_xlat2.xyz);
					    u_xlat2.x = max(u_xlat2.x, 0.0);
					    u_xlat0.x = dot(u_xlat0.xyz, u_xlat1.xyz);
					    u_xlat0.xw = max(u_xlat0.xw, vec2(0.0, 0.0));
					    u_xlat11.x = u_xlat0.w * 0.202115417 + 0.797884583;
					    u_xlat22 = u_xlat2.x * 0.202115417 + 0.797884583;
					    u_xlat11.x = u_xlat11.x * u_xlat22 + 9.99999975e-06;
					    u_xlat11.x = float(1.0) / u_xlat11.x;
					    u_xlat11.y = log2(u_xlat0.x);
					    u_xlat0.yz = u_xlat11.xy * vec2(0.25, 9.99999975e-05);
					    u_xlat22 = exp2(u_xlat0.z);
					    u_xlat22 = u_xlat22 * 0.318325758;
					    u_xlat0.xy = u_xlat0.xy * u_xlat0.xw;
					    u_xlat11.x = u_xlat22 * u_xlat0.y;
					    u_xlat11.x = u_xlat11.x * 0.616850257;
					    u_xlat0.x = u_xlat11.x * u_xlat0.x;
					    u_xlat0.xyz = u_xlat0.xxx * _LightColor0.xyz;
					    u_xlat1.x = (-u_xlat34) + 1.0;
					    u_xlat12 = u_xlat1.x * u_xlat1.x;
					    u_xlat12 = u_xlat12 * u_xlat12;
					    u_xlat1.x = u_xlat1.x * u_xlat12;
					    u_xlat7.xyz = (-u_xlat15.xyz) + vec3(1.0, 1.0, 1.0);
					    u_xlat1.xyz = u_xlat7.xyz * u_xlat1.xxx + u_xlat15.xyz;
					    u_xlat5.xyz = u_xlat5.xyz * vec3(0.0199999996, 0.0199999996, 0.0199999996) + u_xlat6.xyz;
					    u_xlat5.xyz = u_xlat4.xxx * u_xlat5.xyz;
					    u_xlat2.xy = (-u_xlat2.xx) + vec2(1.0, 1.00001001);
					    u_xlat6.xy = u_xlat2.xy * u_xlat2.xy;
					    u_xlat6.xy = u_xlat6.xy * u_xlat6.xy;
					    u_xlat2.xy = u_xlat2.xy * u_xlat6.xy;
					    u_xlat6.xyz = (-u_xlat15.xyz) + vec3(u_xlat35);
					    u_xlat2.xzw = u_xlat2.xxx * u_xlat6.xyz + u_xlat15.xyz;
					    u_xlat2.xzw = u_xlat2.xzw * u_xlat5.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz + u_xlat2.xzw;
					    u_xlat1.x = u_xlat34 + u_xlat34;
					    u_xlat1.x = u_xlat1.x * u_xlat34 + -0.5;
					    u_xlat12 = (-u_xlat0.w) + 1.00001001;
					    u_xlat23 = u_xlat12 * u_xlat12;
					    u_xlat23 = u_xlat23 * u_xlat23;
					    u_xlat12 = u_xlat23 * u_xlat12;
					    u_xlat12 = u_xlat1.x * u_xlat12 + 1.0;
					    u_xlat1.x = u_xlat1.x * u_xlat2.y + 1.0;
					    u_xlat1.x = u_xlat1.x * u_xlat12;
					    u_xlat33 = u_xlat0.w * u_xlat1.x;
					    u_xlat1.xyz = vec3(u_xlat33) * _LightColor0.xyz;
					    SV_Target0.xyz = u_xlat1.xyz * u_xlat3.xyz + u_xlat0.xyz;
					    SV_Target0.w = 1.0;
					    return;
					}"
				}
				SubProgram "d3d11 " {
					Keywords { "DIRECTIONAL" "LIGHTPROBE_SH" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "DYNAMICLIGHTMAP_OFF" }
					"ps_4_0
					
					#version 330
					#extension GL_ARB_explicit_attrib_location : require
					#extension GL_ARB_explicit_uniform_location : require
					
					#define HLSLCC_ENABLE_UNIFORM_BUFFERS 1
					#if HLSLCC_ENABLE_UNIFORM_BUFFERS
					#define UNITY_UNIFORM
					#else
					#define UNITY_UNIFORM uniform
					#endif
					#define UNITY_SUPPORTS_UNIFORM_LOCATION 1
					#if UNITY_SUPPORTS_UNIFORM_LOCATION
					#define UNITY_LOCATION(x) layout(location = x)
					#define UNITY_BINDING(x) layout(binding = x, std140)
					#else
					#define UNITY_LOCATION(x)
					#define UNITY_BINDING(x) layout(std140)
					#endif
					layout(std140) uniform PGlobals {
						vec4 unused_0_0[2];
						vec4 _LightColor0;
						vec4 unused_0_2;
						vec4 _MainTexture_ST;
						vec4 _Specular_ST;
						vec4 _NormalMap_ST;
						vec4 _Color;
						vec4 unused_0_7;
						float _NormalSharpness;
						vec4 _AmbientOcculsion_ST;
						float _Shadows;
					};
					layout(std140) uniform UnityPerCamera {
						vec4 unused_1_0[4];
						vec3 _WorldSpaceCameraPos;
						vec4 unused_1_2[4];
					};
					layout(std140) uniform UnityLighting {
						vec4 _WorldSpaceLightPos0;
						vec4 unused_2_1[38];
						vec4 unity_SHAr;
						vec4 unity_SHAg;
						vec4 unity_SHAb;
						vec4 unused_2_5[6];
					};
					layout(std140) uniform UnityReflectionProbes {
						vec4 unity_SpecCube0_BoxMax;
						vec4 unity_SpecCube0_BoxMin;
						vec4 unity_SpecCube0_ProbePosition;
						vec4 unity_SpecCube0_HDR;
						vec4 unity_SpecCube1_BoxMax;
						vec4 unity_SpecCube1_BoxMin;
						vec4 unity_SpecCube1_ProbePosition;
						vec4 unity_SpecCube1_HDR;
					};
					layout(std140) uniform UnityProbeVolume {
						vec4 unity_ProbeVolumeParams;
						mat4x4 unity_ProbeVolumeWorldToObject;
						vec3 unity_ProbeVolumeSizeInv;
						vec3 unity_ProbeVolumeMin;
					};
					uniform  sampler2D _NormalMap;
					uniform  sampler2D _AmbientOcculsion;
					uniform  sampler2D _Specular;
					uniform  sampler2D _MainTexture;
					uniform  samplerCube unity_SpecCube0;
					uniform  samplerCube unity_SpecCube1;
					uniform  sampler3D unity_ProbeVolumeSH;
					in  vec2 vs_TEXCOORD0;
					in  vec4 vs_TEXCOORD3;
					in  vec3 vs_TEXCOORD4;
					in  vec3 vs_TEXCOORD5;
					in  vec3 vs_TEXCOORD6;
					in  vec4 vs_TEXCOORD10;
					layout(location = 0) out vec4 SV_Target0;
					vec4 u_xlat0;
					int u_xlati0;
					vec3 u_xlat1;
					vec3 u_xlat2;
					vec4 u_xlat3;
					vec4 u_xlat4;
					vec4 u_xlat5;
					vec4 u_xlat6;
					vec4 u_xlat7;
					vec4 u_xlat8;
					vec3 u_xlat9;
					bvec3 u_xlatb9;
					vec3 u_xlat10;
					bvec3 u_xlatb11;
					vec3 u_xlat12;
					int u_xlati12;
					vec2 u_xlat13;
					vec3 u_xlat16;
					float u_xlat24;
					float u_xlat25;
					vec2 u_xlat30;
					float u_xlat36;
					bool u_xlatb36;
					float u_xlat37;
					bool u_xlatb37;
					float u_xlat38;
					void main()
					{
					    u_xlat0.x = dot(vs_TEXCOORD4.xyz, vs_TEXCOORD4.xyz);
					    u_xlat0.x = inversesqrt(u_xlat0.x);
					    u_xlat0.xyz = u_xlat0.xxx * vs_TEXCOORD4.xyz;
					    u_xlat1.xyz = (-vs_TEXCOORD3.xyz) + _WorldSpaceCameraPos.xyz;
					    u_xlat36 = dot(u_xlat1.xyz, u_xlat1.xyz);
					    u_xlat36 = inversesqrt(u_xlat36);
					    u_xlat2.xyz = vec3(u_xlat36) * u_xlat1.xyz;
					    u_xlat3.xy = vs_TEXCOORD0.xy * _NormalMap_ST.xy + _NormalMap_ST.zw;
					    u_xlat3 = texture(_NormalMap, u_xlat3.xy);
					    u_xlat3.x = u_xlat3.w * u_xlat3.x;
					    u_xlat3.xy = u_xlat3.xy * vec2(2.0, 2.0) + vec2(-1.0, -1.0);
					    u_xlat37 = dot(u_xlat3.xy, u_xlat3.xy);
					    u_xlat37 = min(u_xlat37, 1.0);
					    u_xlat37 = (-u_xlat37) + 1.0;
					    u_xlat3.z = sqrt(u_xlat37);
					    u_xlat37 = (-_NormalSharpness) + 1.0;
					    u_xlat3.xyz = u_xlat3.xyz / vec3(u_xlat37);
					    u_xlat3.xyz = clamp(u_xlat3.xyz, 0.0, 1.0);
					    u_xlat4.xyz = u_xlat3.yyy * vs_TEXCOORD6.xyz;
					    u_xlat3.xyw = u_xlat3.xxx * vs_TEXCOORD5.xyz + u_xlat4.xyz;
					    u_xlat3.xyz = u_xlat3.zzz * u_xlat0.xyz + u_xlat3.xyw;
					    u_xlat37 = dot(u_xlat3.xyz, u_xlat3.xyz);
					    u_xlat37 = inversesqrt(u_xlat37);
					    u_xlat3.xyz = vec3(u_xlat37) * u_xlat3.xyz;
					    u_xlat0.x = dot(u_xlat2.xyz, u_xlat0.xyz);
					    u_xlati12 = int((0.0<u_xlat0.x) ? 0xFFFFFFFFu : uint(0));
					    u_xlati0 = int((u_xlat0.x<0.0) ? 0xFFFFFFFFu : uint(0));
					    u_xlati0 = (-u_xlati12) + u_xlati0;
					    u_xlat0.x = float(u_xlati0);
					    u_xlat3.xyz = u_xlat0.xxx * u_xlat3.xyz;
					    u_xlat0.x = dot(_WorldSpaceLightPos0.xyz, _WorldSpaceLightPos0.xyz);
					    u_xlat0.x = inversesqrt(u_xlat0.x);
					    u_xlat0.xyz = u_xlat0.xxx * _WorldSpaceLightPos0.xyz;
					    u_xlat1.xyz = u_xlat1.xyz * vec3(u_xlat36) + u_xlat0.xyz;
					    u_xlat36 = dot(u_xlat1.xyz, u_xlat1.xyz);
					    u_xlat36 = inversesqrt(u_xlat36);
					    u_xlat1.xyz = vec3(u_xlat36) * u_xlat1.xyz;
					    u_xlat36 = dot((-u_xlat2.xyz), u_xlat3.xyz);
					    u_xlat36 = u_xlat36 + u_xlat36;
					    u_xlat4.xyz = u_xlat3.xyz * (-vec3(u_xlat36)) + (-u_xlat2.xyz);
					    u_xlatb36 = unity_ProbeVolumeParams.x==1.0;
					    if(u_xlatb36){
					        u_xlatb36 = unity_ProbeVolumeParams.y==1.0;
					        u_xlat5.xyz = vs_TEXCOORD3.yyy * unity_ProbeVolumeWorldToObject[1].xyz;
					        u_xlat5.xyz = unity_ProbeVolumeWorldToObject[0].xyz * vs_TEXCOORD3.xxx + u_xlat5.xyz;
					        u_xlat5.xyz = unity_ProbeVolumeWorldToObject[2].xyz * vs_TEXCOORD3.zzz + u_xlat5.xyz;
					        u_xlat5.xyz = u_xlat5.xyz + unity_ProbeVolumeWorldToObject[3].xyz;
					        u_xlat5.xyz = (bool(u_xlatb36)) ? u_xlat5.xyz : vs_TEXCOORD3.xyz;
					        u_xlat5.xyz = u_xlat5.xyz + (-unity_ProbeVolumeMin.xyz);
					        u_xlat5.yzw = u_xlat5.xyz * unity_ProbeVolumeSizeInv.xyz;
					        u_xlat36 = u_xlat5.y * 0.25;
					        u_xlat37 = unity_ProbeVolumeParams.z * 0.5;
					        u_xlat38 = (-unity_ProbeVolumeParams.z) * 0.5 + 0.25;
					        u_xlat36 = max(u_xlat36, u_xlat37);
					        u_xlat5.x = min(u_xlat38, u_xlat36);
					        u_xlat6 = texture(unity_ProbeVolumeSH, u_xlat5.xzw);
					        u_xlat7.xyz = u_xlat5.xzw + vec3(0.25, 0.0, 0.0);
					        u_xlat7 = texture(unity_ProbeVolumeSH, u_xlat7.xyz);
					        u_xlat5.xyz = u_xlat5.xzw + vec3(0.5, 0.0, 0.0);
					        u_xlat5 = texture(unity_ProbeVolumeSH, u_xlat5.xyz);
					        u_xlat3.w = 1.0;
					        u_xlat6.x = dot(u_xlat6, u_xlat3);
					        u_xlat6.y = dot(u_xlat7, u_xlat3);
					        u_xlat6.z = dot(u_xlat5, u_xlat3);
					    } else {
					        u_xlat3.w = 1.0;
					        u_xlat6.x = dot(unity_SHAr, u_xlat3);
					        u_xlat6.y = dot(unity_SHAg, u_xlat3);
					        u_xlat6.z = dot(unity_SHAb, u_xlat3);
					    }
					    u_xlat5.xyz = u_xlat6.xyz + vs_TEXCOORD10.xyz;
					    u_xlat5.xyz = max(u_xlat5.xyz, vec3(0.0, 0.0, 0.0));
					    u_xlat5.xyz = log2(u_xlat5.xyz);
					    u_xlat5.xyz = u_xlat5.xyz * vec3(0.416666657, 0.416666657, 0.416666657);
					    u_xlat5.xyz = exp2(u_xlat5.xyz);
					    u_xlat5.xyz = u_xlat5.xyz * vec3(1.05499995, 1.05499995, 1.05499995) + vec3(-0.0549999997, -0.0549999997, -0.0549999997);
					    u_xlat5.xyz = max(u_xlat5.xyz, vec3(0.0, 0.0, 0.0));
					    u_xlatb36 = 0.0<unity_SpecCube0_ProbePosition.w;
					    if(u_xlatb36){
					        u_xlat36 = dot(u_xlat4.xyz, u_xlat4.xyz);
					        u_xlat36 = inversesqrt(u_xlat36);
					        u_xlat6.xyz = vec3(u_xlat36) * u_xlat4.xyz;
					        u_xlat7.xyz = (-vs_TEXCOORD3.xyz) + unity_SpecCube0_BoxMax.xyz;
					        u_xlat7.xyz = u_xlat7.xyz / u_xlat6.xyz;
					        u_xlat8.xyz = (-vs_TEXCOORD3.xyz) + unity_SpecCube0_BoxMin.xyz;
					        u_xlat8.xyz = u_xlat8.xyz / u_xlat6.xyz;
					        u_xlatb9.xyz = lessThan(vec4(0.0, 0.0, 0.0, 0.0), u_xlat6.xyzx).xyz;
					        {
					            vec4 hlslcc_movcTemp = u_xlat7;
					            hlslcc_movcTemp.x = (u_xlatb9.x) ? u_xlat7.x : u_xlat8.x;
					            hlslcc_movcTemp.y = (u_xlatb9.y) ? u_xlat7.y : u_xlat8.y;
					            hlslcc_movcTemp.z = (u_xlatb9.z) ? u_xlat7.z : u_xlat8.z;
					            u_xlat7 = hlslcc_movcTemp;
					        }
					        u_xlat36 = min(u_xlat7.y, u_xlat7.x);
					        u_xlat36 = min(u_xlat7.z, u_xlat36);
					        u_xlat7.xyz = vs_TEXCOORD3.xyz + (-unity_SpecCube0_ProbePosition.xyz);
					        u_xlat6.xyz = u_xlat6.xyz * vec3(u_xlat36) + u_xlat7.xyz;
					    } else {
					        u_xlat6.xyz = u_xlat4.xyz;
					    }
					    u_xlat6 = textureLod(unity_SpecCube0, u_xlat6.xyz, 6.0);
					    u_xlat36 = u_xlat6.w + -1.0;
					    u_xlat36 = unity_SpecCube0_HDR.w * u_xlat36 + 1.0;
					    u_xlat36 = u_xlat36 * unity_SpecCube0_HDR.x;
					    u_xlat7.xyz = u_xlat6.xyz * vec3(u_xlat36);
					    u_xlatb37 = unity_SpecCube0_BoxMin.w<0.999989986;
					    if(u_xlatb37){
					        u_xlatb37 = 0.0<unity_SpecCube1_ProbePosition.w;
					        if(u_xlatb37){
					            u_xlat37 = dot(u_xlat4.xyz, u_xlat4.xyz);
					            u_xlat37 = inversesqrt(u_xlat37);
					            u_xlat8.xyz = vec3(u_xlat37) * u_xlat4.xyz;
					            u_xlat9.xyz = (-vs_TEXCOORD3.xyz) + unity_SpecCube1_BoxMax.xyz;
					            u_xlat9.xyz = u_xlat9.xyz / u_xlat8.xyz;
					            u_xlat10.xyz = (-vs_TEXCOORD3.xyz) + unity_SpecCube1_BoxMin.xyz;
					            u_xlat10.xyz = u_xlat10.xyz / u_xlat8.xyz;
					            u_xlatb11.xyz = lessThan(vec4(0.0, 0.0, 0.0, 0.0), u_xlat8.xyzx).xyz;
					            {
					                vec3 hlslcc_movcTemp = u_xlat9;
					                hlslcc_movcTemp.x = (u_xlatb11.x) ? u_xlat9.x : u_xlat10.x;
					                hlslcc_movcTemp.y = (u_xlatb11.y) ? u_xlat9.y : u_xlat10.y;
					                hlslcc_movcTemp.z = (u_xlatb11.z) ? u_xlat9.z : u_xlat10.z;
					                u_xlat9 = hlslcc_movcTemp;
					            }
					            u_xlat37 = min(u_xlat9.y, u_xlat9.x);
					            u_xlat37 = min(u_xlat9.z, u_xlat37);
					            u_xlat9.xyz = vs_TEXCOORD3.xyz + (-unity_SpecCube1_ProbePosition.xyz);
					            u_xlat4.xyz = u_xlat8.xyz * vec3(u_xlat37) + u_xlat9.xyz;
					        }
					        u_xlat4 = textureLod(unity_SpecCube1, u_xlat4.xyz, 6.0);
					        u_xlat37 = u_xlat4.w + -1.0;
					        u_xlat37 = unity_SpecCube1_HDR.w * u_xlat37 + 1.0;
					        u_xlat37 = u_xlat37 * unity_SpecCube1_HDR.x;
					        u_xlat4.xyz = u_xlat4.xyz * vec3(u_xlat37);
					        u_xlat6.xyz = vec3(u_xlat36) * u_xlat6.xyz + (-u_xlat4.xyz);
					        u_xlat7.xyz = unity_SpecCube0_BoxMin.www * u_xlat6.xyz + u_xlat4.xyz;
					    }
					    u_xlat0.w = dot(u_xlat3.xyz, u_xlat0.xyz);
					    u_xlat4.xy = vs_TEXCOORD0.xy * _AmbientOcculsion_ST.xy + _AmbientOcculsion_ST.zw;
					    u_xlat4 = texture(_AmbientOcculsion, u_xlat4.xy);
					    u_xlat16.xy = vs_TEXCOORD0.xy * _Specular_ST.xy + _Specular_ST.zw;
					    u_xlat6 = texture(_Specular, u_xlat16.xy);
					    u_xlat0.x = dot(u_xlat0.xyz, u_xlat1.xyz);
					    u_xlat12.xy = vs_TEXCOORD0.xy * _MainTexture_ST.xy + _MainTexture_ST.zw;
					    u_xlat8 = texture(_MainTexture, u_xlat12.xy);
					    u_xlat16.xyz = _Color.xyz * u_xlat8.xyz + vec3(_Shadows);
					    u_xlat16.xyz = u_xlat16.xyz + vec3(-1.0, -1.0, -1.0);
					    u_xlat16.xyz = clamp(u_xlat16.xyz, 0.0, 1.0);
					    u_xlat12.x = u_xlat6.x * 0.449999988;
					    u_xlat8.xyz = u_xlat16.xyz + vec3(-0.220916301, -0.220916301, -0.220916301);
					    u_xlat8.xyz = u_xlat12.xxx * u_xlat8.xyz + vec3(0.220916301, 0.220916301, 0.220916301);
					    u_xlat12.x = (-u_xlat6.x) * 0.350587666 + 0.779083729;
					    u_xlat16.xyz = u_xlat12.xxx * u_xlat16.xyz;
					    u_xlat12.x = (-u_xlat12.x) + 1.0;
					    u_xlat12.x = clamp(u_xlat12.x, 0.0, 1.0);
					    u_xlat0.z = dot(u_xlat3.xyz, u_xlat2.xyz);
					    u_xlat0.xzw = max(u_xlat0.xzw, vec3(0.0, 0.0, 0.0));
					    u_xlat1.x = dot(u_xlat3.xyz, u_xlat1.xyz);
					    u_xlat1.x = max(u_xlat1.x, 0.0);
					    u_xlat13.x = u_xlat0.w * 0.202115417 + 0.797884583;
					    u_xlat25 = u_xlat0.z * 0.202115417 + 0.797884583;
					    u_xlat13.x = u_xlat13.x * u_xlat25 + 9.99999975e-06;
					    u_xlat13.x = float(1.0) / u_xlat13.x;
					    u_xlat13.y = log2(u_xlat1.x);
					    u_xlat13.xy = u_xlat13.xy * vec2(0.25, 9.99999975e-05);
					    u_xlat25 = exp2(u_xlat13.y);
					    u_xlat1.z = u_xlat25 * 0.318325758;
					    u_xlat1.y = u_xlat0.w * u_xlat13.x;
					    u_xlat1.xy = u_xlat1.xz * u_xlat1.xy;
					    u_xlat13.x = u_xlat1.y * 0.616850257;
					    u_xlat1.x = u_xlat13.x * u_xlat1.x;
					    u_xlat1.xyz = u_xlat1.xxx * _LightColor0.xyz;
					    u_xlat37 = (-u_xlat0.x) + 1.0;
					    u_xlat2.x = u_xlat37 * u_xlat37;
					    u_xlat2.x = u_xlat2.x * u_xlat2.x;
					    u_xlat37 = u_xlat37 * u_xlat2.x;
					    u_xlat2.xyz = (-u_xlat8.xyz) + vec3(1.0, 1.0, 1.0);
					    u_xlat2.xyz = u_xlat2.xyz * vec3(u_xlat37) + u_xlat8.xyz;
					    u_xlat3.xyz = u_xlat6.xyz * vec3(0.0199999996, 0.0199999996, 0.0199999996) + u_xlat7.xyz;
					    u_xlat3.xyz = u_xlat4.xxx * u_xlat3.xyz;
					    u_xlat6.xy = (-u_xlat0.zz) + vec2(1.0, 1.00001001);
					    u_xlat30.xy = u_xlat6.xy * u_xlat6.xy;
					    u_xlat30.xy = u_xlat30.xy * u_xlat30.xy;
					    u_xlat6.xy = u_xlat6.xy * u_xlat30.xy;
					    u_xlat7.xyz = (-u_xlat8.xyz) + u_xlat12.xxx;
					    u_xlat6.xzw = u_xlat6.xxx * u_xlat7.xyz + u_xlat8.xyz;
					    u_xlat3.xyz = u_xlat3.xyz * u_xlat6.xzw;
					    u_xlat1.xyz = u_xlat1.xyz * u_xlat2.xyz + u_xlat3.xyz;
					    u_xlat12.x = u_xlat0.x + u_xlat0.x;
					    u_xlat0.x = u_xlat12.x * u_xlat0.x + -0.5;
					    u_xlat12.x = (-u_xlat0.w) + 1.00001001;
					    u_xlat24 = u_xlat12.x * u_xlat12.x;
					    u_xlat24 = u_xlat24 * u_xlat24;
					    u_xlat12.x = u_xlat24 * u_xlat12.x;
					    u_xlat12.x = u_xlat0.x * u_xlat12.x + 1.0;
					    u_xlat0.x = u_xlat0.x * u_xlat6.y + 1.0;
					    u_xlat0.x = u_xlat0.x * u_xlat12.x;
					    u_xlat0.x = u_xlat0.w * u_xlat0.x;
					    u_xlat12.xyz = u_xlat4.xxx * u_xlat5.xyz;
					    u_xlat0.xyz = u_xlat0.xxx * _LightColor0.xyz + u_xlat12.xyz;
					    SV_Target0.xyz = u_xlat0.xyz * u_xlat16.xyz + u_xlat1.xyz;
					    SV_Target0.w = 1.0;
					    return;
					}"
				}
				SubProgram "d3d11 " {
					Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "DYNAMICLIGHTMAP_OFF" }
					"ps_4_0
					
					#version 330
					#extension GL_ARB_explicit_attrib_location : require
					#extension GL_ARB_explicit_uniform_location : require
					
					#define HLSLCC_ENABLE_UNIFORM_BUFFERS 1
					#if HLSLCC_ENABLE_UNIFORM_BUFFERS
					#define UNITY_UNIFORM
					#else
					#define UNITY_UNIFORM uniform
					#endif
					#define UNITY_SUPPORTS_UNIFORM_LOCATION 1
					#if UNITY_SUPPORTS_UNIFORM_LOCATION
					#define UNITY_LOCATION(x) layout(location = x)
					#define UNITY_BINDING(x) layout(binding = x, std140)
					#else
					#define UNITY_LOCATION(x)
					#define UNITY_BINDING(x) layout(std140)
					#endif
					layout(std140) uniform PGlobals {
						vec4 unused_0_0[2];
						vec4 _LightColor0;
						vec4 unused_0_2;
						vec4 _MainTexture_ST;
						vec4 _Specular_ST;
						vec4 _NormalMap_ST;
						vec4 _Color;
						vec4 unused_0_7;
						float _NormalSharpness;
						vec4 _AmbientOcculsion_ST;
						float _Shadows;
					};
					layout(std140) uniform UnityPerCamera {
						vec4 unused_1_0[4];
						vec3 _WorldSpaceCameraPos;
						vec4 unused_1_2[4];
					};
					layout(std140) uniform UnityLighting {
						vec4 _WorldSpaceLightPos0;
						vec4 unused_2_1[47];
					};
					layout(std140) uniform UnityReflectionProbes {
						vec4 unity_SpecCube0_BoxMax;
						vec4 unity_SpecCube0_BoxMin;
						vec4 unity_SpecCube0_ProbePosition;
						vec4 unity_SpecCube0_HDR;
						vec4 unity_SpecCube1_BoxMax;
						vec4 unity_SpecCube1_BoxMin;
						vec4 unity_SpecCube1_ProbePosition;
						vec4 unity_SpecCube1_HDR;
					};
					uniform  sampler2D _NormalMap;
					uniform  sampler2D _ShadowMapTexture;
					uniform  sampler2D _AmbientOcculsion;
					uniform  sampler2D _Specular;
					uniform  sampler2D _MainTexture;
					uniform  samplerCube unity_SpecCube0;
					uniform  samplerCube unity_SpecCube1;
					in  vec2 vs_TEXCOORD0;
					in  vec4 vs_TEXCOORD3;
					in  vec3 vs_TEXCOORD4;
					in  vec3 vs_TEXCOORD5;
					in  vec3 vs_TEXCOORD6;
					in  vec4 vs_TEXCOORD8;
					layout(location = 0) out vec4 SV_Target0;
					vec4 u_xlat0;
					int u_xlati0;
					vec3 u_xlat1;
					vec4 u_xlat2;
					vec4 u_xlat3;
					vec4 u_xlat4;
					vec4 u_xlat5;
					vec4 u_xlat6;
					vec3 u_xlat7;
					vec3 u_xlat8;
					vec3 u_xlat9;
					bvec3 u_xlatb9;
					vec3 u_xlat10;
					bvec3 u_xlatb11;
					vec2 u_xlat12;
					int u_xlati12;
					float u_xlat13;
					vec3 u_xlat17;
					float u_xlat24;
					float u_xlat25;
					float u_xlat36;
					bool u_xlatb36;
					float u_xlat37;
					bool u_xlatb37;
					float u_xlat38;
					void main()
					{
					    u_xlat0.x = dot(vs_TEXCOORD4.xyz, vs_TEXCOORD4.xyz);
					    u_xlat0.x = inversesqrt(u_xlat0.x);
					    u_xlat0.xyz = u_xlat0.xxx * vs_TEXCOORD4.xyz;
					    u_xlat1.xyz = (-vs_TEXCOORD3.xyz) + _WorldSpaceCameraPos.xyz;
					    u_xlat36 = dot(u_xlat1.xyz, u_xlat1.xyz);
					    u_xlat36 = inversesqrt(u_xlat36);
					    u_xlat2.xyz = vec3(u_xlat36) * u_xlat1.xyz;
					    u_xlat3.xy = vs_TEXCOORD0.xy * _NormalMap_ST.xy + _NormalMap_ST.zw;
					    u_xlat3 = texture(_NormalMap, u_xlat3.xy);
					    u_xlat3.x = u_xlat3.w * u_xlat3.x;
					    u_xlat3.xy = u_xlat3.xy * vec2(2.0, 2.0) + vec2(-1.0, -1.0);
					    u_xlat37 = dot(u_xlat3.xy, u_xlat3.xy);
					    u_xlat37 = min(u_xlat37, 1.0);
					    u_xlat37 = (-u_xlat37) + 1.0;
					    u_xlat3.z = sqrt(u_xlat37);
					    u_xlat37 = (-_NormalSharpness) + 1.0;
					    u_xlat3.xyz = u_xlat3.xyz / vec3(u_xlat37);
					    u_xlat3.xyz = clamp(u_xlat3.xyz, 0.0, 1.0);
					    u_xlat4.xyz = u_xlat3.yyy * vs_TEXCOORD6.xyz;
					    u_xlat3.xyw = u_xlat3.xxx * vs_TEXCOORD5.xyz + u_xlat4.xyz;
					    u_xlat3.xyz = u_xlat3.zzz * u_xlat0.xyz + u_xlat3.xyw;
					    u_xlat37 = dot(u_xlat3.xyz, u_xlat3.xyz);
					    u_xlat37 = inversesqrt(u_xlat37);
					    u_xlat3.xyz = vec3(u_xlat37) * u_xlat3.xyz;
					    u_xlat0.x = dot(u_xlat2.xyz, u_xlat0.xyz);
					    u_xlati12 = int((0.0<u_xlat0.x) ? 0xFFFFFFFFu : uint(0));
					    u_xlati0 = int((u_xlat0.x<0.0) ? 0xFFFFFFFFu : uint(0));
					    u_xlati0 = (-u_xlati12) + u_xlati0;
					    u_xlat0.x = float(u_xlati0);
					    u_xlat0.xyz = u_xlat0.xxx * u_xlat3.xyz;
					    u_xlat37 = dot(_WorldSpaceLightPos0.xyz, _WorldSpaceLightPos0.xyz);
					    u_xlat37 = inversesqrt(u_xlat37);
					    u_xlat3.xyz = vec3(u_xlat37) * _WorldSpaceLightPos0.xyz;
					    u_xlat1.xyz = u_xlat1.xyz * vec3(u_xlat36) + u_xlat3.xyz;
					    u_xlat36 = dot(u_xlat1.xyz, u_xlat1.xyz);
					    u_xlat36 = inversesqrt(u_xlat36);
					    u_xlat1.xyz = vec3(u_xlat36) * u_xlat1.xyz;
					    u_xlat4.xy = vs_TEXCOORD8.xy / vs_TEXCOORD8.ww;
					    u_xlat4 = texture(_ShadowMapTexture, u_xlat4.xy);
					    u_xlat4.xyz = u_xlat4.xxx * _LightColor0.xyz;
					    u_xlat36 = dot((-u_xlat2.xyz), u_xlat0.xyz);
					    u_xlat36 = u_xlat36 + u_xlat36;
					    u_xlat5.xyz = u_xlat0.xyz * (-vec3(u_xlat36)) + (-u_xlat2.xyz);
					    u_xlatb36 = 0.0<unity_SpecCube0_ProbePosition.w;
					    if(u_xlatb36){
					        u_xlat36 = dot(u_xlat5.xyz, u_xlat5.xyz);
					        u_xlat36 = inversesqrt(u_xlat36);
					        u_xlat6.xyz = vec3(u_xlat36) * u_xlat5.xyz;
					        u_xlat7.xyz = (-vs_TEXCOORD3.xyz) + unity_SpecCube0_BoxMax.xyz;
					        u_xlat7.xyz = u_xlat7.xyz / u_xlat6.xyz;
					        u_xlat8.xyz = (-vs_TEXCOORD3.xyz) + unity_SpecCube0_BoxMin.xyz;
					        u_xlat8.xyz = u_xlat8.xyz / u_xlat6.xyz;
					        u_xlatb9.xyz = lessThan(vec4(0.0, 0.0, 0.0, 0.0), u_xlat6.xyzx).xyz;
					        {
					            vec3 hlslcc_movcTemp = u_xlat7;
					            hlslcc_movcTemp.x = (u_xlatb9.x) ? u_xlat7.x : u_xlat8.x;
					            hlslcc_movcTemp.y = (u_xlatb9.y) ? u_xlat7.y : u_xlat8.y;
					            hlslcc_movcTemp.z = (u_xlatb9.z) ? u_xlat7.z : u_xlat8.z;
					            u_xlat7 = hlslcc_movcTemp;
					        }
					        u_xlat36 = min(u_xlat7.y, u_xlat7.x);
					        u_xlat36 = min(u_xlat7.z, u_xlat36);
					        u_xlat7.xyz = vs_TEXCOORD3.xyz + (-unity_SpecCube0_ProbePosition.xyz);
					        u_xlat6.xyz = u_xlat6.xyz * vec3(u_xlat36) + u_xlat7.xyz;
					    } else {
					        u_xlat6.xyz = u_xlat5.xyz;
					    }
					    u_xlat6 = textureLod(unity_SpecCube0, u_xlat6.xyz, 6.0);
					    u_xlat36 = u_xlat6.w + -1.0;
					    u_xlat36 = unity_SpecCube0_HDR.w * u_xlat36 + 1.0;
					    u_xlat36 = u_xlat36 * unity_SpecCube0_HDR.x;
					    u_xlat7.xyz = u_xlat6.xyz * vec3(u_xlat36);
					    u_xlatb37 = unity_SpecCube0_BoxMin.w<0.999989986;
					    if(u_xlatb37){
					        u_xlatb37 = 0.0<unity_SpecCube1_ProbePosition.w;
					        if(u_xlatb37){
					            u_xlat37 = dot(u_xlat5.xyz, u_xlat5.xyz);
					            u_xlat37 = inversesqrt(u_xlat37);
					            u_xlat8.xyz = vec3(u_xlat37) * u_xlat5.xyz;
					            u_xlat9.xyz = (-vs_TEXCOORD3.xyz) + unity_SpecCube1_BoxMax.xyz;
					            u_xlat9.xyz = u_xlat9.xyz / u_xlat8.xyz;
					            u_xlat10.xyz = (-vs_TEXCOORD3.xyz) + unity_SpecCube1_BoxMin.xyz;
					            u_xlat10.xyz = u_xlat10.xyz / u_xlat8.xyz;
					            u_xlatb11.xyz = lessThan(vec4(0.0, 0.0, 0.0, 0.0), u_xlat8.xyzx).xyz;
					            {
					                vec3 hlslcc_movcTemp = u_xlat9;
					                hlslcc_movcTemp.x = (u_xlatb11.x) ? u_xlat9.x : u_xlat10.x;
					                hlslcc_movcTemp.y = (u_xlatb11.y) ? u_xlat9.y : u_xlat10.y;
					                hlslcc_movcTemp.z = (u_xlatb11.z) ? u_xlat9.z : u_xlat10.z;
					                u_xlat9 = hlslcc_movcTemp;
					            }
					            u_xlat37 = min(u_xlat9.y, u_xlat9.x);
					            u_xlat37 = min(u_xlat9.z, u_xlat37);
					            u_xlat9.xyz = vs_TEXCOORD3.xyz + (-unity_SpecCube1_ProbePosition.xyz);
					            u_xlat5.xyz = u_xlat8.xyz * vec3(u_xlat37) + u_xlat9.xyz;
					        }
					        u_xlat5 = textureLod(unity_SpecCube1, u_xlat5.xyz, 6.0);
					        u_xlat37 = u_xlat5.w + -1.0;
					        u_xlat37 = unity_SpecCube1_HDR.w * u_xlat37 + 1.0;
					        u_xlat37 = u_xlat37 * unity_SpecCube1_HDR.x;
					        u_xlat5.xyz = u_xlat5.xyz * vec3(u_xlat37);
					        u_xlat6.xyz = vec3(u_xlat36) * u_xlat6.xyz + (-u_xlat5.xyz);
					        u_xlat7.xyz = unity_SpecCube0_BoxMin.www * u_xlat6.xyz + u_xlat5.xyz;
					    }
					    u_xlat0.w = dot(u_xlat0.xyz, u_xlat3.xyz);
					    u_xlat5.xy = vs_TEXCOORD0.xy * _AmbientOcculsion_ST.xy + _AmbientOcculsion_ST.zw;
					    u_xlat5 = texture(_AmbientOcculsion, u_xlat5.xy);
					    u_xlat17.xy = vs_TEXCOORD0.xy * _Specular_ST.xy + _Specular_ST.zw;
					    u_xlat6 = texture(_Specular, u_xlat17.xy);
					    u_xlat37 = dot(u_xlat3.xyz, u_xlat1.xyz);
					    u_xlat37 = max(u_xlat37, 0.0);
					    u_xlat3.xy = vs_TEXCOORD0.xy * _MainTexture_ST.xy + _MainTexture_ST.zw;
					    u_xlat3 = texture(_MainTexture, u_xlat3.xy);
					    u_xlat3.xyz = _Color.xyz * u_xlat3.xyz + vec3(_Shadows);
					    u_xlat3.xyz = u_xlat3.xyz + vec3(-1.0, -1.0, -1.0);
					    u_xlat3.xyz = clamp(u_xlat3.xyz, 0.0, 1.0);
					    u_xlat38 = u_xlat6.x * 0.449999988;
					    u_xlat17.xyz = u_xlat3.xyz + vec3(-0.220916301, -0.220916301, -0.220916301);
					    u_xlat17.xyz = vec3(u_xlat38) * u_xlat17.xyz + vec3(0.220916301, 0.220916301, 0.220916301);
					    u_xlat38 = (-u_xlat6.x) * 0.350587666 + 0.779083729;
					    u_xlat3.xyz = vec3(u_xlat38) * u_xlat3.xyz;
					    u_xlat38 = (-u_xlat38) + 1.0;
					    u_xlat38 = clamp(u_xlat38, 0.0, 1.0);
					    u_xlat2.x = dot(u_xlat0.xyz, u_xlat2.xyz);
					    u_xlat2.x = max(u_xlat2.x, 0.0);
					    u_xlat0.x = dot(u_xlat0.xyz, u_xlat1.xyz);
					    u_xlat0.xw = max(u_xlat0.xw, vec2(0.0, 0.0));
					    u_xlat12.x = u_xlat0.w * 0.202115417 + 0.797884583;
					    u_xlat24 = u_xlat2.x * 0.202115417 + 0.797884583;
					    u_xlat12.x = u_xlat12.x * u_xlat24 + 9.99999975e-06;
					    u_xlat12.x = float(1.0) / u_xlat12.x;
					    u_xlat12.y = log2(u_xlat0.x);
					    u_xlat0.yz = u_xlat12.xy * vec2(0.25, 9.99999975e-05);
					    u_xlat24 = exp2(u_xlat0.z);
					    u_xlat24 = u_xlat24 * 0.318325758;
					    u_xlat0.xy = u_xlat0.xy * u_xlat0.xw;
					    u_xlat12.x = u_xlat24 * u_xlat0.y;
					    u_xlat12.x = u_xlat12.x * 0.616850257;
					    u_xlat0.x = u_xlat12.x * u_xlat0.x;
					    u_xlat0.xyz = u_xlat4.xyz * u_xlat0.xxx;
					    u_xlat1.x = (-u_xlat37) + 1.0;
					    u_xlat13 = u_xlat1.x * u_xlat1.x;
					    u_xlat13 = u_xlat13 * u_xlat13;
					    u_xlat1.x = u_xlat1.x * u_xlat13;
					    u_xlat8.xyz = (-u_xlat17.xyz) + vec3(1.0, 1.0, 1.0);
					    u_xlat1.xyz = u_xlat8.xyz * u_xlat1.xxx + u_xlat17.xyz;
					    u_xlat6.xyz = u_xlat6.xyz * vec3(0.0199999996, 0.0199999996, 0.0199999996) + u_xlat7.xyz;
					    u_xlat6.xyz = u_xlat5.xxx * u_xlat6.xyz;
					    u_xlat2.xy = (-u_xlat2.xx) + vec2(1.0, 1.00001001);
					    u_xlat7.xy = u_xlat2.xy * u_xlat2.xy;
					    u_xlat7.xy = u_xlat7.xy * u_xlat7.xy;
					    u_xlat2.xy = u_xlat2.xy * u_xlat7.xy;
					    u_xlat7.xyz = (-u_xlat17.xyz) + vec3(u_xlat38);
					    u_xlat2.xzw = u_xlat2.xxx * u_xlat7.xyz + u_xlat17.xyz;
					    u_xlat2.xzw = u_xlat2.xzw * u_xlat6.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz + u_xlat2.xzw;
					    u_xlat1.x = u_xlat37 + u_xlat37;
					    u_xlat1.x = u_xlat1.x * u_xlat37 + -0.5;
					    u_xlat13 = (-u_xlat0.w) + 1.00001001;
					    u_xlat25 = u_xlat13 * u_xlat13;
					    u_xlat25 = u_xlat25 * u_xlat25;
					    u_xlat13 = u_xlat25 * u_xlat13;
					    u_xlat13 = u_xlat1.x * u_xlat13 + 1.0;
					    u_xlat1.x = u_xlat1.x * u_xlat2.y + 1.0;
					    u_xlat1.x = u_xlat1.x * u_xlat13;
					    u_xlat36 = u_xlat0.w * u_xlat1.x;
					    u_xlat1.xyz = u_xlat4.xyz * vec3(u_xlat36);
					    SV_Target0.xyz = u_xlat1.xyz * u_xlat3.xyz + u_xlat0.xyz;
					    SV_Target0.w = 1.0;
					    return;
					}"
				}
				SubProgram "d3d11 " {
					Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "LIGHTPROBE_SH" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "DYNAMICLIGHTMAP_OFF" }
					"ps_4_0
					
					#version 330
					#extension GL_ARB_explicit_attrib_location : require
					#extension GL_ARB_explicit_uniform_location : require
					
					#define HLSLCC_ENABLE_UNIFORM_BUFFERS 1
					#if HLSLCC_ENABLE_UNIFORM_BUFFERS
					#define UNITY_UNIFORM
					#else
					#define UNITY_UNIFORM uniform
					#endif
					#define UNITY_SUPPORTS_UNIFORM_LOCATION 1
					#if UNITY_SUPPORTS_UNIFORM_LOCATION
					#define UNITY_LOCATION(x) layout(location = x)
					#define UNITY_BINDING(x) layout(binding = x, std140)
					#else
					#define UNITY_LOCATION(x)
					#define UNITY_BINDING(x) layout(std140)
					#endif
					layout(std140) uniform PGlobals {
						vec4 unused_0_0[2];
						vec4 _LightColor0;
						vec4 unused_0_2;
						vec4 _MainTexture_ST;
						vec4 _Specular_ST;
						vec4 _NormalMap_ST;
						vec4 _Color;
						vec4 unused_0_7;
						float _NormalSharpness;
						vec4 _AmbientOcculsion_ST;
						float _Shadows;
					};
					layout(std140) uniform UnityPerCamera {
						vec4 unused_1_0[4];
						vec3 _WorldSpaceCameraPos;
						vec4 unused_1_2[4];
					};
					layout(std140) uniform UnityLighting {
						vec4 _WorldSpaceLightPos0;
						vec4 unused_2_1[38];
						vec4 unity_SHAr;
						vec4 unity_SHAg;
						vec4 unity_SHAb;
						vec4 unused_2_5[6];
					};
					layout(std140) uniform UnityReflectionProbes {
						vec4 unity_SpecCube0_BoxMax;
						vec4 unity_SpecCube0_BoxMin;
						vec4 unity_SpecCube0_ProbePosition;
						vec4 unity_SpecCube0_HDR;
						vec4 unity_SpecCube1_BoxMax;
						vec4 unity_SpecCube1_BoxMin;
						vec4 unity_SpecCube1_ProbePosition;
						vec4 unity_SpecCube1_HDR;
					};
					layout(std140) uniform UnityProbeVolume {
						vec4 unity_ProbeVolumeParams;
						mat4x4 unity_ProbeVolumeWorldToObject;
						vec3 unity_ProbeVolumeSizeInv;
						vec3 unity_ProbeVolumeMin;
					};
					uniform  sampler2D _NormalMap;
					uniform  sampler2D _ShadowMapTexture;
					uniform  sampler2D _AmbientOcculsion;
					uniform  sampler2D _Specular;
					uniform  sampler2D _MainTexture;
					uniform  samplerCube unity_SpecCube0;
					uniform  samplerCube unity_SpecCube1;
					uniform  sampler3D unity_ProbeVolumeSH;
					in  vec2 vs_TEXCOORD0;
					in  vec4 vs_TEXCOORD3;
					in  vec3 vs_TEXCOORD4;
					in  vec3 vs_TEXCOORD5;
					in  vec3 vs_TEXCOORD6;
					in  vec4 vs_TEXCOORD8;
					in  vec4 vs_TEXCOORD10;
					layout(location = 0) out vec4 SV_Target0;
					vec4 u_xlat0;
					int u_xlati0;
					vec3 u_xlat1;
					vec3 u_xlat2;
					vec4 u_xlat3;
					vec4 u_xlat4;
					vec4 u_xlat5;
					vec4 u_xlat6;
					vec4 u_xlat7;
					vec4 u_xlat8;
					vec4 u_xlat9;
					vec3 u_xlat10;
					bvec3 u_xlatb10;
					vec3 u_xlat11;
					bvec3 u_xlatb12;
					vec3 u_xlat13;
					int u_xlati13;
					vec2 u_xlat14;
					vec3 u_xlat18;
					float u_xlat26;
					float u_xlat27;
					vec2 u_xlat33;
					float u_xlat39;
					bool u_xlatb39;
					float u_xlat40;
					bool u_xlatb40;
					float u_xlat41;
					void main()
					{
					    u_xlat0.x = dot(vs_TEXCOORD4.xyz, vs_TEXCOORD4.xyz);
					    u_xlat0.x = inversesqrt(u_xlat0.x);
					    u_xlat0.xyz = u_xlat0.xxx * vs_TEXCOORD4.xyz;
					    u_xlat1.xyz = (-vs_TEXCOORD3.xyz) + _WorldSpaceCameraPos.xyz;
					    u_xlat39 = dot(u_xlat1.xyz, u_xlat1.xyz);
					    u_xlat39 = inversesqrt(u_xlat39);
					    u_xlat2.xyz = vec3(u_xlat39) * u_xlat1.xyz;
					    u_xlat3.xy = vs_TEXCOORD0.xy * _NormalMap_ST.xy + _NormalMap_ST.zw;
					    u_xlat3 = texture(_NormalMap, u_xlat3.xy);
					    u_xlat3.x = u_xlat3.w * u_xlat3.x;
					    u_xlat3.xy = u_xlat3.xy * vec2(2.0, 2.0) + vec2(-1.0, -1.0);
					    u_xlat40 = dot(u_xlat3.xy, u_xlat3.xy);
					    u_xlat40 = min(u_xlat40, 1.0);
					    u_xlat40 = (-u_xlat40) + 1.0;
					    u_xlat3.z = sqrt(u_xlat40);
					    u_xlat40 = (-_NormalSharpness) + 1.0;
					    u_xlat3.xyz = u_xlat3.xyz / vec3(u_xlat40);
					    u_xlat3.xyz = clamp(u_xlat3.xyz, 0.0, 1.0);
					    u_xlat4.xyz = u_xlat3.yyy * vs_TEXCOORD6.xyz;
					    u_xlat3.xyw = u_xlat3.xxx * vs_TEXCOORD5.xyz + u_xlat4.xyz;
					    u_xlat3.xyz = u_xlat3.zzz * u_xlat0.xyz + u_xlat3.xyw;
					    u_xlat40 = dot(u_xlat3.xyz, u_xlat3.xyz);
					    u_xlat40 = inversesqrt(u_xlat40);
					    u_xlat3.xyz = vec3(u_xlat40) * u_xlat3.xyz;
					    u_xlat0.x = dot(u_xlat2.xyz, u_xlat0.xyz);
					    u_xlati13 = int((0.0<u_xlat0.x) ? 0xFFFFFFFFu : uint(0));
					    u_xlati0 = int((u_xlat0.x<0.0) ? 0xFFFFFFFFu : uint(0));
					    u_xlati0 = (-u_xlati13) + u_xlati0;
					    u_xlat0.x = float(u_xlati0);
					    u_xlat3.xyz = u_xlat0.xxx * u_xlat3.xyz;
					    u_xlat0.x = dot(_WorldSpaceLightPos0.xyz, _WorldSpaceLightPos0.xyz);
					    u_xlat0.x = inversesqrt(u_xlat0.x);
					    u_xlat0.xyz = u_xlat0.xxx * _WorldSpaceLightPos0.xyz;
					    u_xlat1.xyz = u_xlat1.xyz * vec3(u_xlat39) + u_xlat0.xyz;
					    u_xlat39 = dot(u_xlat1.xyz, u_xlat1.xyz);
					    u_xlat39 = inversesqrt(u_xlat39);
					    u_xlat1.xyz = vec3(u_xlat39) * u_xlat1.xyz;
					    u_xlat4.xy = vs_TEXCOORD8.xy / vs_TEXCOORD8.ww;
					    u_xlat4 = texture(_ShadowMapTexture, u_xlat4.xy);
					    u_xlat4.xyz = u_xlat4.xxx * _LightColor0.xyz;
					    u_xlat39 = dot((-u_xlat2.xyz), u_xlat3.xyz);
					    u_xlat39 = u_xlat39 + u_xlat39;
					    u_xlat5.xyz = u_xlat3.xyz * (-vec3(u_xlat39)) + (-u_xlat2.xyz);
					    u_xlatb39 = unity_ProbeVolumeParams.x==1.0;
					    if(u_xlatb39){
					        u_xlatb39 = unity_ProbeVolumeParams.y==1.0;
					        u_xlat6.xyz = vs_TEXCOORD3.yyy * unity_ProbeVolumeWorldToObject[1].xyz;
					        u_xlat6.xyz = unity_ProbeVolumeWorldToObject[0].xyz * vs_TEXCOORD3.xxx + u_xlat6.xyz;
					        u_xlat6.xyz = unity_ProbeVolumeWorldToObject[2].xyz * vs_TEXCOORD3.zzz + u_xlat6.xyz;
					        u_xlat6.xyz = u_xlat6.xyz + unity_ProbeVolumeWorldToObject[3].xyz;
					        u_xlat6.xyz = (bool(u_xlatb39)) ? u_xlat6.xyz : vs_TEXCOORD3.xyz;
					        u_xlat6.xyz = u_xlat6.xyz + (-unity_ProbeVolumeMin.xyz);
					        u_xlat6.yzw = u_xlat6.xyz * unity_ProbeVolumeSizeInv.xyz;
					        u_xlat39 = u_xlat6.y * 0.25;
					        u_xlat40 = unity_ProbeVolumeParams.z * 0.5;
					        u_xlat41 = (-unity_ProbeVolumeParams.z) * 0.5 + 0.25;
					        u_xlat39 = max(u_xlat39, u_xlat40);
					        u_xlat6.x = min(u_xlat41, u_xlat39);
					        u_xlat7 = texture(unity_ProbeVolumeSH, u_xlat6.xzw);
					        u_xlat8.xyz = u_xlat6.xzw + vec3(0.25, 0.0, 0.0);
					        u_xlat8 = texture(unity_ProbeVolumeSH, u_xlat8.xyz);
					        u_xlat6.xyz = u_xlat6.xzw + vec3(0.5, 0.0, 0.0);
					        u_xlat6 = texture(unity_ProbeVolumeSH, u_xlat6.xyz);
					        u_xlat3.w = 1.0;
					        u_xlat7.x = dot(u_xlat7, u_xlat3);
					        u_xlat7.y = dot(u_xlat8, u_xlat3);
					        u_xlat7.z = dot(u_xlat6, u_xlat3);
					    } else {
					        u_xlat3.w = 1.0;
					        u_xlat7.x = dot(unity_SHAr, u_xlat3);
					        u_xlat7.y = dot(unity_SHAg, u_xlat3);
					        u_xlat7.z = dot(unity_SHAb, u_xlat3);
					    }
					    u_xlat6.xyz = u_xlat7.xyz + vs_TEXCOORD10.xyz;
					    u_xlat6.xyz = max(u_xlat6.xyz, vec3(0.0, 0.0, 0.0));
					    u_xlat6.xyz = log2(u_xlat6.xyz);
					    u_xlat6.xyz = u_xlat6.xyz * vec3(0.416666657, 0.416666657, 0.416666657);
					    u_xlat6.xyz = exp2(u_xlat6.xyz);
					    u_xlat6.xyz = u_xlat6.xyz * vec3(1.05499995, 1.05499995, 1.05499995) + vec3(-0.0549999997, -0.0549999997, -0.0549999997);
					    u_xlat6.xyz = max(u_xlat6.xyz, vec3(0.0, 0.0, 0.0));
					    u_xlatb39 = 0.0<unity_SpecCube0_ProbePosition.w;
					    if(u_xlatb39){
					        u_xlat39 = dot(u_xlat5.xyz, u_xlat5.xyz);
					        u_xlat39 = inversesqrt(u_xlat39);
					        u_xlat7.xyz = vec3(u_xlat39) * u_xlat5.xyz;
					        u_xlat8.xyz = (-vs_TEXCOORD3.xyz) + unity_SpecCube0_BoxMax.xyz;
					        u_xlat8.xyz = u_xlat8.xyz / u_xlat7.xyz;
					        u_xlat9.xyz = (-vs_TEXCOORD3.xyz) + unity_SpecCube0_BoxMin.xyz;
					        u_xlat9.xyz = u_xlat9.xyz / u_xlat7.xyz;
					        u_xlatb10.xyz = lessThan(vec4(0.0, 0.0, 0.0, 0.0), u_xlat7.xyzx).xyz;
					        {
					            vec4 hlslcc_movcTemp = u_xlat8;
					            hlslcc_movcTemp.x = (u_xlatb10.x) ? u_xlat8.x : u_xlat9.x;
					            hlslcc_movcTemp.y = (u_xlatb10.y) ? u_xlat8.y : u_xlat9.y;
					            hlslcc_movcTemp.z = (u_xlatb10.z) ? u_xlat8.z : u_xlat9.z;
					            u_xlat8 = hlslcc_movcTemp;
					        }
					        u_xlat39 = min(u_xlat8.y, u_xlat8.x);
					        u_xlat39 = min(u_xlat8.z, u_xlat39);
					        u_xlat8.xyz = vs_TEXCOORD3.xyz + (-unity_SpecCube0_ProbePosition.xyz);
					        u_xlat7.xyz = u_xlat7.xyz * vec3(u_xlat39) + u_xlat8.xyz;
					    } else {
					        u_xlat7.xyz = u_xlat5.xyz;
					    }
					    u_xlat7 = textureLod(unity_SpecCube0, u_xlat7.xyz, 6.0);
					    u_xlat39 = u_xlat7.w + -1.0;
					    u_xlat39 = unity_SpecCube0_HDR.w * u_xlat39 + 1.0;
					    u_xlat39 = u_xlat39 * unity_SpecCube0_HDR.x;
					    u_xlat8.xyz = u_xlat7.xyz * vec3(u_xlat39);
					    u_xlatb40 = unity_SpecCube0_BoxMin.w<0.999989986;
					    if(u_xlatb40){
					        u_xlatb40 = 0.0<unity_SpecCube1_ProbePosition.w;
					        if(u_xlatb40){
					            u_xlat40 = dot(u_xlat5.xyz, u_xlat5.xyz);
					            u_xlat40 = inversesqrt(u_xlat40);
					            u_xlat9.xyz = vec3(u_xlat40) * u_xlat5.xyz;
					            u_xlat10.xyz = (-vs_TEXCOORD3.xyz) + unity_SpecCube1_BoxMax.xyz;
					            u_xlat10.xyz = u_xlat10.xyz / u_xlat9.xyz;
					            u_xlat11.xyz = (-vs_TEXCOORD3.xyz) + unity_SpecCube1_BoxMin.xyz;
					            u_xlat11.xyz = u_xlat11.xyz / u_xlat9.xyz;
					            u_xlatb12.xyz = lessThan(vec4(0.0, 0.0, 0.0, 0.0), u_xlat9.xyzx).xyz;
					            {
					                vec3 hlslcc_movcTemp = u_xlat10;
					                hlslcc_movcTemp.x = (u_xlatb12.x) ? u_xlat10.x : u_xlat11.x;
					                hlslcc_movcTemp.y = (u_xlatb12.y) ? u_xlat10.y : u_xlat11.y;
					                hlslcc_movcTemp.z = (u_xlatb12.z) ? u_xlat10.z : u_xlat11.z;
					                u_xlat10 = hlslcc_movcTemp;
					            }
					            u_xlat40 = min(u_xlat10.y, u_xlat10.x);
					            u_xlat40 = min(u_xlat10.z, u_xlat40);
					            u_xlat10.xyz = vs_TEXCOORD3.xyz + (-unity_SpecCube1_ProbePosition.xyz);
					            u_xlat5.xyz = u_xlat9.xyz * vec3(u_xlat40) + u_xlat10.xyz;
					        }
					        u_xlat5 = textureLod(unity_SpecCube1, u_xlat5.xyz, 6.0);
					        u_xlat40 = u_xlat5.w + -1.0;
					        u_xlat40 = unity_SpecCube1_HDR.w * u_xlat40 + 1.0;
					        u_xlat40 = u_xlat40 * unity_SpecCube1_HDR.x;
					        u_xlat5.xyz = u_xlat5.xyz * vec3(u_xlat40);
					        u_xlat7.xyz = vec3(u_xlat39) * u_xlat7.xyz + (-u_xlat5.xyz);
					        u_xlat8.xyz = unity_SpecCube0_BoxMin.www * u_xlat7.xyz + u_xlat5.xyz;
					    }
					    u_xlat0.w = dot(u_xlat3.xyz, u_xlat0.xyz);
					    u_xlat5.xy = vs_TEXCOORD0.xy * _AmbientOcculsion_ST.xy + _AmbientOcculsion_ST.zw;
					    u_xlat5 = texture(_AmbientOcculsion, u_xlat5.xy);
					    u_xlat18.xy = vs_TEXCOORD0.xy * _Specular_ST.xy + _Specular_ST.zw;
					    u_xlat7 = texture(_Specular, u_xlat18.xy);
					    u_xlat0.x = dot(u_xlat0.xyz, u_xlat1.xyz);
					    u_xlat13.xy = vs_TEXCOORD0.xy * _MainTexture_ST.xy + _MainTexture_ST.zw;
					    u_xlat9 = texture(_MainTexture, u_xlat13.xy);
					    u_xlat18.xyz = _Color.xyz * u_xlat9.xyz + vec3(_Shadows);
					    u_xlat18.xyz = u_xlat18.xyz + vec3(-1.0, -1.0, -1.0);
					    u_xlat18.xyz = clamp(u_xlat18.xyz, 0.0, 1.0);
					    u_xlat13.x = u_xlat7.x * 0.449999988;
					    u_xlat9.xyz = u_xlat18.xyz + vec3(-0.220916301, -0.220916301, -0.220916301);
					    u_xlat9.xyz = u_xlat13.xxx * u_xlat9.xyz + vec3(0.220916301, 0.220916301, 0.220916301);
					    u_xlat13.x = (-u_xlat7.x) * 0.350587666 + 0.779083729;
					    u_xlat18.xyz = u_xlat13.xxx * u_xlat18.xyz;
					    u_xlat13.x = (-u_xlat13.x) + 1.0;
					    u_xlat13.x = clamp(u_xlat13.x, 0.0, 1.0);
					    u_xlat0.z = dot(u_xlat3.xyz, u_xlat2.xyz);
					    u_xlat0.xzw = max(u_xlat0.xzw, vec3(0.0, 0.0, 0.0));
					    u_xlat1.x = dot(u_xlat3.xyz, u_xlat1.xyz);
					    u_xlat1.x = max(u_xlat1.x, 0.0);
					    u_xlat14.x = u_xlat0.w * 0.202115417 + 0.797884583;
					    u_xlat27 = u_xlat0.z * 0.202115417 + 0.797884583;
					    u_xlat14.x = u_xlat14.x * u_xlat27 + 9.99999975e-06;
					    u_xlat14.x = float(1.0) / u_xlat14.x;
					    u_xlat14.y = log2(u_xlat1.x);
					    u_xlat14.xy = u_xlat14.xy * vec2(0.25, 9.99999975e-05);
					    u_xlat27 = exp2(u_xlat14.y);
					    u_xlat1.z = u_xlat27 * 0.318325758;
					    u_xlat1.y = u_xlat0.w * u_xlat14.x;
					    u_xlat1.xy = u_xlat1.xz * u_xlat1.xy;
					    u_xlat14.x = u_xlat1.y * 0.616850257;
					    u_xlat1.x = u_xlat14.x * u_xlat1.x;
					    u_xlat1.xyz = u_xlat4.xyz * u_xlat1.xxx;
					    u_xlat40 = (-u_xlat0.x) + 1.0;
					    u_xlat2.x = u_xlat40 * u_xlat40;
					    u_xlat2.x = u_xlat2.x * u_xlat2.x;
					    u_xlat40 = u_xlat40 * u_xlat2.x;
					    u_xlat2.xyz = (-u_xlat9.xyz) + vec3(1.0, 1.0, 1.0);
					    u_xlat2.xyz = u_xlat2.xyz * vec3(u_xlat40) + u_xlat9.xyz;
					    u_xlat3.xyz = u_xlat7.xyz * vec3(0.0199999996, 0.0199999996, 0.0199999996) + u_xlat8.xyz;
					    u_xlat3.xyz = u_xlat5.xxx * u_xlat3.xyz;
					    u_xlat7.xy = (-u_xlat0.zz) + vec2(1.0, 1.00001001);
					    u_xlat33.xy = u_xlat7.xy * u_xlat7.xy;
					    u_xlat33.xy = u_xlat33.xy * u_xlat33.xy;
					    u_xlat7.xy = u_xlat7.xy * u_xlat33.xy;
					    u_xlat8.xyz = (-u_xlat9.xyz) + u_xlat13.xxx;
					    u_xlat7.xzw = u_xlat7.xxx * u_xlat8.xyz + u_xlat9.xyz;
					    u_xlat3.xyz = u_xlat3.xyz * u_xlat7.xzw;
					    u_xlat1.xyz = u_xlat1.xyz * u_xlat2.xyz + u_xlat3.xyz;
					    u_xlat13.x = u_xlat0.x + u_xlat0.x;
					    u_xlat0.x = u_xlat13.x * u_xlat0.x + -0.5;
					    u_xlat13.x = (-u_xlat0.w) + 1.00001001;
					    u_xlat26 = u_xlat13.x * u_xlat13.x;
					    u_xlat26 = u_xlat26 * u_xlat26;
					    u_xlat13.x = u_xlat26 * u_xlat13.x;
					    u_xlat13.x = u_xlat0.x * u_xlat13.x + 1.0;
					    u_xlat0.x = u_xlat0.x * u_xlat7.y + 1.0;
					    u_xlat0.x = u_xlat0.x * u_xlat13.x;
					    u_xlat0.x = u_xlat0.w * u_xlat0.x;
					    u_xlat13.xyz = u_xlat5.xxx * u_xlat6.xyz;
					    u_xlat0.xyz = u_xlat0.xxx * u_xlat4.xyz + u_xlat13.xyz;
					    SV_Target0.xyz = u_xlat0.xyz * u_xlat18.xyz + u_xlat1.xyz;
					    SV_Target0.w = 1.0;
					    return;
					}"
				}
				SubProgram "d3d11 " {
					Keywords { "DIRECTIONAL" "DIRLIGHTMAP_COMBINED" "LIGHTMAP_OFF" "DYNAMICLIGHTMAP_OFF" }
					"ps_4_0
					
					#version 330
					#extension GL_ARB_explicit_attrib_location : require
					#extension GL_ARB_explicit_uniform_location : require
					
					#define HLSLCC_ENABLE_UNIFORM_BUFFERS 1
					#if HLSLCC_ENABLE_UNIFORM_BUFFERS
					#define UNITY_UNIFORM
					#else
					#define UNITY_UNIFORM uniform
					#endif
					#define UNITY_SUPPORTS_UNIFORM_LOCATION 1
					#if UNITY_SUPPORTS_UNIFORM_LOCATION
					#define UNITY_LOCATION(x) layout(location = x)
					#define UNITY_BINDING(x) layout(binding = x, std140)
					#else
					#define UNITY_LOCATION(x)
					#define UNITY_BINDING(x) layout(std140)
					#endif
					layout(std140) uniform PGlobals {
						vec4 unused_0_0[2];
						vec4 _LightColor0;
						vec4 unused_0_2;
						vec4 _MainTexture_ST;
						vec4 _Specular_ST;
						vec4 _NormalMap_ST;
						vec4 _Color;
						vec4 unused_0_7;
						float _NormalSharpness;
						vec4 _AmbientOcculsion_ST;
						float _Shadows;
					};
					layout(std140) uniform UnityPerCamera {
						vec4 unused_1_0[4];
						vec3 _WorldSpaceCameraPos;
						vec4 unused_1_2[4];
					};
					layout(std140) uniform UnityLighting {
						vec4 _WorldSpaceLightPos0;
						vec4 unused_2_1[47];
					};
					layout(std140) uniform UnityReflectionProbes {
						vec4 unity_SpecCube0_BoxMax;
						vec4 unity_SpecCube0_BoxMin;
						vec4 unity_SpecCube0_ProbePosition;
						vec4 unity_SpecCube0_HDR;
						vec4 unity_SpecCube1_BoxMax;
						vec4 unity_SpecCube1_BoxMin;
						vec4 unity_SpecCube1_ProbePosition;
						vec4 unity_SpecCube1_HDR;
					};
					uniform  sampler2D _NormalMap;
					uniform  sampler2D _AmbientOcculsion;
					uniform  sampler2D _Specular;
					uniform  sampler2D _MainTexture;
					uniform  samplerCube unity_SpecCube0;
					uniform  samplerCube unity_SpecCube1;
					in  vec2 vs_TEXCOORD0;
					in  vec4 vs_TEXCOORD3;
					in  vec3 vs_TEXCOORD4;
					in  vec3 vs_TEXCOORD5;
					in  vec3 vs_TEXCOORD6;
					layout(location = 0) out vec4 SV_Target0;
					vec4 u_xlat0;
					int u_xlati0;
					vec3 u_xlat1;
					vec4 u_xlat2;
					vec4 u_xlat3;
					vec4 u_xlat4;
					vec4 u_xlat5;
					vec3 u_xlat6;
					vec3 u_xlat7;
					vec3 u_xlat8;
					bvec3 u_xlatb8;
					vec3 u_xlat9;
					bvec3 u_xlatb10;
					vec2 u_xlat11;
					int u_xlati11;
					float u_xlat12;
					vec3 u_xlat15;
					float u_xlat22;
					float u_xlat23;
					float u_xlat33;
					bool u_xlatb33;
					float u_xlat34;
					bool u_xlatb34;
					float u_xlat35;
					void main()
					{
					    u_xlat0.x = dot(vs_TEXCOORD4.xyz, vs_TEXCOORD4.xyz);
					    u_xlat0.x = inversesqrt(u_xlat0.x);
					    u_xlat0.xyz = u_xlat0.xxx * vs_TEXCOORD4.xyz;
					    u_xlat1.xyz = (-vs_TEXCOORD3.xyz) + _WorldSpaceCameraPos.xyz;
					    u_xlat33 = dot(u_xlat1.xyz, u_xlat1.xyz);
					    u_xlat33 = inversesqrt(u_xlat33);
					    u_xlat2.xyz = vec3(u_xlat33) * u_xlat1.xyz;
					    u_xlat3.xy = vs_TEXCOORD0.xy * _NormalMap_ST.xy + _NormalMap_ST.zw;
					    u_xlat3 = texture(_NormalMap, u_xlat3.xy);
					    u_xlat3.x = u_xlat3.w * u_xlat3.x;
					    u_xlat3.xy = u_xlat3.xy * vec2(2.0, 2.0) + vec2(-1.0, -1.0);
					    u_xlat34 = dot(u_xlat3.xy, u_xlat3.xy);
					    u_xlat34 = min(u_xlat34, 1.0);
					    u_xlat34 = (-u_xlat34) + 1.0;
					    u_xlat3.z = sqrt(u_xlat34);
					    u_xlat34 = (-_NormalSharpness) + 1.0;
					    u_xlat3.xyz = u_xlat3.xyz / vec3(u_xlat34);
					    u_xlat3.xyz = clamp(u_xlat3.xyz, 0.0, 1.0);
					    u_xlat4.xyz = u_xlat3.yyy * vs_TEXCOORD6.xyz;
					    u_xlat3.xyw = u_xlat3.xxx * vs_TEXCOORD5.xyz + u_xlat4.xyz;
					    u_xlat3.xyz = u_xlat3.zzz * u_xlat0.xyz + u_xlat3.xyw;
					    u_xlat34 = dot(u_xlat3.xyz, u_xlat3.xyz);
					    u_xlat34 = inversesqrt(u_xlat34);
					    u_xlat3.xyz = vec3(u_xlat34) * u_xlat3.xyz;
					    u_xlat0.x = dot(u_xlat2.xyz, u_xlat0.xyz);
					    u_xlati11 = int((0.0<u_xlat0.x) ? 0xFFFFFFFFu : uint(0));
					    u_xlati0 = int((u_xlat0.x<0.0) ? 0xFFFFFFFFu : uint(0));
					    u_xlati0 = (-u_xlati11) + u_xlati0;
					    u_xlat0.x = float(u_xlati0);
					    u_xlat0.xyz = u_xlat0.xxx * u_xlat3.xyz;
					    u_xlat34 = dot(_WorldSpaceLightPos0.xyz, _WorldSpaceLightPos0.xyz);
					    u_xlat34 = inversesqrt(u_xlat34);
					    u_xlat3.xyz = vec3(u_xlat34) * _WorldSpaceLightPos0.xyz;
					    u_xlat1.xyz = u_xlat1.xyz * vec3(u_xlat33) + u_xlat3.xyz;
					    u_xlat33 = dot(u_xlat1.xyz, u_xlat1.xyz);
					    u_xlat33 = inversesqrt(u_xlat33);
					    u_xlat1.xyz = vec3(u_xlat33) * u_xlat1.xyz;
					    u_xlat33 = dot((-u_xlat2.xyz), u_xlat0.xyz);
					    u_xlat33 = u_xlat33 + u_xlat33;
					    u_xlat4.xyz = u_xlat0.xyz * (-vec3(u_xlat33)) + (-u_xlat2.xyz);
					    u_xlatb33 = 0.0<unity_SpecCube0_ProbePosition.w;
					    if(u_xlatb33){
					        u_xlat33 = dot(u_xlat4.xyz, u_xlat4.xyz);
					        u_xlat33 = inversesqrt(u_xlat33);
					        u_xlat5.xyz = vec3(u_xlat33) * u_xlat4.xyz;
					        u_xlat6.xyz = (-vs_TEXCOORD3.xyz) + unity_SpecCube0_BoxMax.xyz;
					        u_xlat6.xyz = u_xlat6.xyz / u_xlat5.xyz;
					        u_xlat7.xyz = (-vs_TEXCOORD3.xyz) + unity_SpecCube0_BoxMin.xyz;
					        u_xlat7.xyz = u_xlat7.xyz / u_xlat5.xyz;
					        u_xlatb8.xyz = lessThan(vec4(0.0, 0.0, 0.0, 0.0), u_xlat5.xyzx).xyz;
					        {
					            vec3 hlslcc_movcTemp = u_xlat6;
					            hlslcc_movcTemp.x = (u_xlatb8.x) ? u_xlat6.x : u_xlat7.x;
					            hlslcc_movcTemp.y = (u_xlatb8.y) ? u_xlat6.y : u_xlat7.y;
					            hlslcc_movcTemp.z = (u_xlatb8.z) ? u_xlat6.z : u_xlat7.z;
					            u_xlat6 = hlslcc_movcTemp;
					        }
					        u_xlat33 = min(u_xlat6.y, u_xlat6.x);
					        u_xlat33 = min(u_xlat6.z, u_xlat33);
					        u_xlat6.xyz = vs_TEXCOORD3.xyz + (-unity_SpecCube0_ProbePosition.xyz);
					        u_xlat5.xyz = u_xlat5.xyz * vec3(u_xlat33) + u_xlat6.xyz;
					    } else {
					        u_xlat5.xyz = u_xlat4.xyz;
					    }
					    u_xlat5 = textureLod(unity_SpecCube0, u_xlat5.xyz, 6.0);
					    u_xlat33 = u_xlat5.w + -1.0;
					    u_xlat33 = unity_SpecCube0_HDR.w * u_xlat33 + 1.0;
					    u_xlat33 = u_xlat33 * unity_SpecCube0_HDR.x;
					    u_xlat6.xyz = u_xlat5.xyz * vec3(u_xlat33);
					    u_xlatb34 = unity_SpecCube0_BoxMin.w<0.999989986;
					    if(u_xlatb34){
					        u_xlatb34 = 0.0<unity_SpecCube1_ProbePosition.w;
					        if(u_xlatb34){
					            u_xlat34 = dot(u_xlat4.xyz, u_xlat4.xyz);
					            u_xlat34 = inversesqrt(u_xlat34);
					            u_xlat7.xyz = vec3(u_xlat34) * u_xlat4.xyz;
					            u_xlat8.xyz = (-vs_TEXCOORD3.xyz) + unity_SpecCube1_BoxMax.xyz;
					            u_xlat8.xyz = u_xlat8.xyz / u_xlat7.xyz;
					            u_xlat9.xyz = (-vs_TEXCOORD3.xyz) + unity_SpecCube1_BoxMin.xyz;
					            u_xlat9.xyz = u_xlat9.xyz / u_xlat7.xyz;
					            u_xlatb10.xyz = lessThan(vec4(0.0, 0.0, 0.0, 0.0), u_xlat7.xyzx).xyz;
					            {
					                vec3 hlslcc_movcTemp = u_xlat8;
					                hlslcc_movcTemp.x = (u_xlatb10.x) ? u_xlat8.x : u_xlat9.x;
					                hlslcc_movcTemp.y = (u_xlatb10.y) ? u_xlat8.y : u_xlat9.y;
					                hlslcc_movcTemp.z = (u_xlatb10.z) ? u_xlat8.z : u_xlat9.z;
					                u_xlat8 = hlslcc_movcTemp;
					            }
					            u_xlat34 = min(u_xlat8.y, u_xlat8.x);
					            u_xlat34 = min(u_xlat8.z, u_xlat34);
					            u_xlat8.xyz = vs_TEXCOORD3.xyz + (-unity_SpecCube1_ProbePosition.xyz);
					            u_xlat4.xyz = u_xlat7.xyz * vec3(u_xlat34) + u_xlat8.xyz;
					        }
					        u_xlat4 = textureLod(unity_SpecCube1, u_xlat4.xyz, 6.0);
					        u_xlat34 = u_xlat4.w + -1.0;
					        u_xlat34 = unity_SpecCube1_HDR.w * u_xlat34 + 1.0;
					        u_xlat34 = u_xlat34 * unity_SpecCube1_HDR.x;
					        u_xlat4.xyz = u_xlat4.xyz * vec3(u_xlat34);
					        u_xlat5.xyz = vec3(u_xlat33) * u_xlat5.xyz + (-u_xlat4.xyz);
					        u_xlat6.xyz = unity_SpecCube0_BoxMin.www * u_xlat5.xyz + u_xlat4.xyz;
					    }
					    u_xlat0.w = dot(u_xlat0.xyz, u_xlat3.xyz);
					    u_xlat4.xy = vs_TEXCOORD0.xy * _AmbientOcculsion_ST.xy + _AmbientOcculsion_ST.zw;
					    u_xlat4 = texture(_AmbientOcculsion, u_xlat4.xy);
					    u_xlat15.xy = vs_TEXCOORD0.xy * _Specular_ST.xy + _Specular_ST.zw;
					    u_xlat5 = texture(_Specular, u_xlat15.xy);
					    u_xlat34 = dot(u_xlat3.xyz, u_xlat1.xyz);
					    u_xlat34 = max(u_xlat34, 0.0);
					    u_xlat3.xy = vs_TEXCOORD0.xy * _MainTexture_ST.xy + _MainTexture_ST.zw;
					    u_xlat3 = texture(_MainTexture, u_xlat3.xy);
					    u_xlat3.xyz = _Color.xyz * u_xlat3.xyz + vec3(_Shadows);
					    u_xlat3.xyz = u_xlat3.xyz + vec3(-1.0, -1.0, -1.0);
					    u_xlat3.xyz = clamp(u_xlat3.xyz, 0.0, 1.0);
					    u_xlat35 = u_xlat5.x * 0.449999988;
					    u_xlat15.xyz = u_xlat3.xyz + vec3(-0.220916301, -0.220916301, -0.220916301);
					    u_xlat15.xyz = vec3(u_xlat35) * u_xlat15.xyz + vec3(0.220916301, 0.220916301, 0.220916301);
					    u_xlat35 = (-u_xlat5.x) * 0.350587666 + 0.779083729;
					    u_xlat3.xyz = vec3(u_xlat35) * u_xlat3.xyz;
					    u_xlat35 = (-u_xlat35) + 1.0;
					    u_xlat35 = clamp(u_xlat35, 0.0, 1.0);
					    u_xlat2.x = dot(u_xlat0.xyz, u_xlat2.xyz);
					    u_xlat2.x = max(u_xlat2.x, 0.0);
					    u_xlat0.x = dot(u_xlat0.xyz, u_xlat1.xyz);
					    u_xlat0.xw = max(u_xlat0.xw, vec2(0.0, 0.0));
					    u_xlat11.x = u_xlat0.w * 0.202115417 + 0.797884583;
					    u_xlat22 = u_xlat2.x * 0.202115417 + 0.797884583;
					    u_xlat11.x = u_xlat11.x * u_xlat22 + 9.99999975e-06;
					    u_xlat11.x = float(1.0) / u_xlat11.x;
					    u_xlat11.y = log2(u_xlat0.x);
					    u_xlat0.yz = u_xlat11.xy * vec2(0.25, 9.99999975e-05);
					    u_xlat22 = exp2(u_xlat0.z);
					    u_xlat22 = u_xlat22 * 0.318325758;
					    u_xlat0.xy = u_xlat0.xy * u_xlat0.xw;
					    u_xlat11.x = u_xlat22 * u_xlat0.y;
					    u_xlat11.x = u_xlat11.x * 0.616850257;
					    u_xlat0.x = u_xlat11.x * u_xlat0.x;
					    u_xlat0.xyz = u_xlat0.xxx * _LightColor0.xyz;
					    u_xlat1.x = (-u_xlat34) + 1.0;
					    u_xlat12 = u_xlat1.x * u_xlat1.x;
					    u_xlat12 = u_xlat12 * u_xlat12;
					    u_xlat1.x = u_xlat1.x * u_xlat12;
					    u_xlat7.xyz = (-u_xlat15.xyz) + vec3(1.0, 1.0, 1.0);
					    u_xlat1.xyz = u_xlat7.xyz * u_xlat1.xxx + u_xlat15.xyz;
					    u_xlat5.xyz = u_xlat5.xyz * vec3(0.0199999996, 0.0199999996, 0.0199999996) + u_xlat6.xyz;
					    u_xlat5.xyz = u_xlat4.xxx * u_xlat5.xyz;
					    u_xlat2.xy = (-u_xlat2.xx) + vec2(1.0, 1.00001001);
					    u_xlat6.xy = u_xlat2.xy * u_xlat2.xy;
					    u_xlat6.xy = u_xlat6.xy * u_xlat6.xy;
					    u_xlat2.xy = u_xlat2.xy * u_xlat6.xy;
					    u_xlat6.xyz = (-u_xlat15.xyz) + vec3(u_xlat35);
					    u_xlat2.xzw = u_xlat2.xxx * u_xlat6.xyz + u_xlat15.xyz;
					    u_xlat2.xzw = u_xlat2.xzw * u_xlat5.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz + u_xlat2.xzw;
					    u_xlat1.x = u_xlat34 + u_xlat34;
					    u_xlat1.x = u_xlat1.x * u_xlat34 + -0.5;
					    u_xlat12 = (-u_xlat0.w) + 1.00001001;
					    u_xlat23 = u_xlat12 * u_xlat12;
					    u_xlat23 = u_xlat23 * u_xlat23;
					    u_xlat12 = u_xlat23 * u_xlat12;
					    u_xlat12 = u_xlat1.x * u_xlat12 + 1.0;
					    u_xlat1.x = u_xlat1.x * u_xlat2.y + 1.0;
					    u_xlat1.x = u_xlat1.x * u_xlat12;
					    u_xlat33 = u_xlat0.w * u_xlat1.x;
					    u_xlat1.xyz = vec3(u_xlat33) * _LightColor0.xyz;
					    SV_Target0.xyz = u_xlat1.xyz * u_xlat3.xyz + u_xlat0.xyz;
					    SV_Target0.w = 1.0;
					    return;
					}"
				}
				SubProgram "d3d11 " {
					Keywords { "DIRECTIONAL" "DIRLIGHTMAP_COMBINED" "LIGHTPROBE_SH" "LIGHTMAP_OFF" "DYNAMICLIGHTMAP_OFF" }
					"ps_4_0
					
					#version 330
					#extension GL_ARB_explicit_attrib_location : require
					#extension GL_ARB_explicit_uniform_location : require
					
					#define HLSLCC_ENABLE_UNIFORM_BUFFERS 1
					#if HLSLCC_ENABLE_UNIFORM_BUFFERS
					#define UNITY_UNIFORM
					#else
					#define UNITY_UNIFORM uniform
					#endif
					#define UNITY_SUPPORTS_UNIFORM_LOCATION 1
					#if UNITY_SUPPORTS_UNIFORM_LOCATION
					#define UNITY_LOCATION(x) layout(location = x)
					#define UNITY_BINDING(x) layout(binding = x, std140)
					#else
					#define UNITY_LOCATION(x)
					#define UNITY_BINDING(x) layout(std140)
					#endif
					layout(std140) uniform PGlobals {
						vec4 unused_0_0[2];
						vec4 _LightColor0;
						vec4 unused_0_2;
						vec4 _MainTexture_ST;
						vec4 _Specular_ST;
						vec4 _NormalMap_ST;
						vec4 _Color;
						vec4 unused_0_7;
						float _NormalSharpness;
						vec4 _AmbientOcculsion_ST;
						float _Shadows;
					};
					layout(std140) uniform UnityPerCamera {
						vec4 unused_1_0[4];
						vec3 _WorldSpaceCameraPos;
						vec4 unused_1_2[4];
					};
					layout(std140) uniform UnityLighting {
						vec4 _WorldSpaceLightPos0;
						vec4 unused_2_1[38];
						vec4 unity_SHAr;
						vec4 unity_SHAg;
						vec4 unity_SHAb;
						vec4 unused_2_5[6];
					};
					layout(std140) uniform UnityReflectionProbes {
						vec4 unity_SpecCube0_BoxMax;
						vec4 unity_SpecCube0_BoxMin;
						vec4 unity_SpecCube0_ProbePosition;
						vec4 unity_SpecCube0_HDR;
						vec4 unity_SpecCube1_BoxMax;
						vec4 unity_SpecCube1_BoxMin;
						vec4 unity_SpecCube1_ProbePosition;
						vec4 unity_SpecCube1_HDR;
					};
					layout(std140) uniform UnityProbeVolume {
						vec4 unity_ProbeVolumeParams;
						mat4x4 unity_ProbeVolumeWorldToObject;
						vec3 unity_ProbeVolumeSizeInv;
						vec3 unity_ProbeVolumeMin;
					};
					uniform  sampler2D _NormalMap;
					uniform  sampler2D _AmbientOcculsion;
					uniform  sampler2D _Specular;
					uniform  sampler2D _MainTexture;
					uniform  samplerCube unity_SpecCube0;
					uniform  samplerCube unity_SpecCube1;
					uniform  sampler3D unity_ProbeVolumeSH;
					in  vec2 vs_TEXCOORD0;
					in  vec4 vs_TEXCOORD3;
					in  vec3 vs_TEXCOORD4;
					in  vec3 vs_TEXCOORD5;
					in  vec3 vs_TEXCOORD6;
					in  vec4 vs_TEXCOORD10;
					layout(location = 0) out vec4 SV_Target0;
					vec4 u_xlat0;
					int u_xlati0;
					vec3 u_xlat1;
					vec3 u_xlat2;
					vec4 u_xlat3;
					vec4 u_xlat4;
					vec4 u_xlat5;
					vec4 u_xlat6;
					vec4 u_xlat7;
					vec4 u_xlat8;
					vec3 u_xlat9;
					bvec3 u_xlatb9;
					vec3 u_xlat10;
					bvec3 u_xlatb11;
					vec3 u_xlat12;
					int u_xlati12;
					vec2 u_xlat13;
					vec3 u_xlat16;
					float u_xlat24;
					float u_xlat25;
					vec2 u_xlat30;
					float u_xlat36;
					bool u_xlatb36;
					float u_xlat37;
					bool u_xlatb37;
					float u_xlat38;
					void main()
					{
					    u_xlat0.x = dot(vs_TEXCOORD4.xyz, vs_TEXCOORD4.xyz);
					    u_xlat0.x = inversesqrt(u_xlat0.x);
					    u_xlat0.xyz = u_xlat0.xxx * vs_TEXCOORD4.xyz;
					    u_xlat1.xyz = (-vs_TEXCOORD3.xyz) + _WorldSpaceCameraPos.xyz;
					    u_xlat36 = dot(u_xlat1.xyz, u_xlat1.xyz);
					    u_xlat36 = inversesqrt(u_xlat36);
					    u_xlat2.xyz = vec3(u_xlat36) * u_xlat1.xyz;
					    u_xlat3.xy = vs_TEXCOORD0.xy * _NormalMap_ST.xy + _NormalMap_ST.zw;
					    u_xlat3 = texture(_NormalMap, u_xlat3.xy);
					    u_xlat3.x = u_xlat3.w * u_xlat3.x;
					    u_xlat3.xy = u_xlat3.xy * vec2(2.0, 2.0) + vec2(-1.0, -1.0);
					    u_xlat37 = dot(u_xlat3.xy, u_xlat3.xy);
					    u_xlat37 = min(u_xlat37, 1.0);
					    u_xlat37 = (-u_xlat37) + 1.0;
					    u_xlat3.z = sqrt(u_xlat37);
					    u_xlat37 = (-_NormalSharpness) + 1.0;
					    u_xlat3.xyz = u_xlat3.xyz / vec3(u_xlat37);
					    u_xlat3.xyz = clamp(u_xlat3.xyz, 0.0, 1.0);
					    u_xlat4.xyz = u_xlat3.yyy * vs_TEXCOORD6.xyz;
					    u_xlat3.xyw = u_xlat3.xxx * vs_TEXCOORD5.xyz + u_xlat4.xyz;
					    u_xlat3.xyz = u_xlat3.zzz * u_xlat0.xyz + u_xlat3.xyw;
					    u_xlat37 = dot(u_xlat3.xyz, u_xlat3.xyz);
					    u_xlat37 = inversesqrt(u_xlat37);
					    u_xlat3.xyz = vec3(u_xlat37) * u_xlat3.xyz;
					    u_xlat0.x = dot(u_xlat2.xyz, u_xlat0.xyz);
					    u_xlati12 = int((0.0<u_xlat0.x) ? 0xFFFFFFFFu : uint(0));
					    u_xlati0 = int((u_xlat0.x<0.0) ? 0xFFFFFFFFu : uint(0));
					    u_xlati0 = (-u_xlati12) + u_xlati0;
					    u_xlat0.x = float(u_xlati0);
					    u_xlat3.xyz = u_xlat0.xxx * u_xlat3.xyz;
					    u_xlat0.x = dot(_WorldSpaceLightPos0.xyz, _WorldSpaceLightPos0.xyz);
					    u_xlat0.x = inversesqrt(u_xlat0.x);
					    u_xlat0.xyz = u_xlat0.xxx * _WorldSpaceLightPos0.xyz;
					    u_xlat1.xyz = u_xlat1.xyz * vec3(u_xlat36) + u_xlat0.xyz;
					    u_xlat36 = dot(u_xlat1.xyz, u_xlat1.xyz);
					    u_xlat36 = inversesqrt(u_xlat36);
					    u_xlat1.xyz = vec3(u_xlat36) * u_xlat1.xyz;
					    u_xlat36 = dot((-u_xlat2.xyz), u_xlat3.xyz);
					    u_xlat36 = u_xlat36 + u_xlat36;
					    u_xlat4.xyz = u_xlat3.xyz * (-vec3(u_xlat36)) + (-u_xlat2.xyz);
					    u_xlatb36 = unity_ProbeVolumeParams.x==1.0;
					    if(u_xlatb36){
					        u_xlatb36 = unity_ProbeVolumeParams.y==1.0;
					        u_xlat5.xyz = vs_TEXCOORD3.yyy * unity_ProbeVolumeWorldToObject[1].xyz;
					        u_xlat5.xyz = unity_ProbeVolumeWorldToObject[0].xyz * vs_TEXCOORD3.xxx + u_xlat5.xyz;
					        u_xlat5.xyz = unity_ProbeVolumeWorldToObject[2].xyz * vs_TEXCOORD3.zzz + u_xlat5.xyz;
					        u_xlat5.xyz = u_xlat5.xyz + unity_ProbeVolumeWorldToObject[3].xyz;
					        u_xlat5.xyz = (bool(u_xlatb36)) ? u_xlat5.xyz : vs_TEXCOORD3.xyz;
					        u_xlat5.xyz = u_xlat5.xyz + (-unity_ProbeVolumeMin.xyz);
					        u_xlat5.yzw = u_xlat5.xyz * unity_ProbeVolumeSizeInv.xyz;
					        u_xlat36 = u_xlat5.y * 0.25;
					        u_xlat37 = unity_ProbeVolumeParams.z * 0.5;
					        u_xlat38 = (-unity_ProbeVolumeParams.z) * 0.5 + 0.25;
					        u_xlat36 = max(u_xlat36, u_xlat37);
					        u_xlat5.x = min(u_xlat38, u_xlat36);
					        u_xlat6 = texture(unity_ProbeVolumeSH, u_xlat5.xzw);
					        u_xlat7.xyz = u_xlat5.xzw + vec3(0.25, 0.0, 0.0);
					        u_xlat7 = texture(unity_ProbeVolumeSH, u_xlat7.xyz);
					        u_xlat5.xyz = u_xlat5.xzw + vec3(0.5, 0.0, 0.0);
					        u_xlat5 = texture(unity_ProbeVolumeSH, u_xlat5.xyz);
					        u_xlat3.w = 1.0;
					        u_xlat6.x = dot(u_xlat6, u_xlat3);
					        u_xlat6.y = dot(u_xlat7, u_xlat3);
					        u_xlat6.z = dot(u_xlat5, u_xlat3);
					    } else {
					        u_xlat3.w = 1.0;
					        u_xlat6.x = dot(unity_SHAr, u_xlat3);
					        u_xlat6.y = dot(unity_SHAg, u_xlat3);
					        u_xlat6.z = dot(unity_SHAb, u_xlat3);
					    }
					    u_xlat5.xyz = u_xlat6.xyz + vs_TEXCOORD10.xyz;
					    u_xlat5.xyz = max(u_xlat5.xyz, vec3(0.0, 0.0, 0.0));
					    u_xlat5.xyz = log2(u_xlat5.xyz);
					    u_xlat5.xyz = u_xlat5.xyz * vec3(0.416666657, 0.416666657, 0.416666657);
					    u_xlat5.xyz = exp2(u_xlat5.xyz);
					    u_xlat5.xyz = u_xlat5.xyz * vec3(1.05499995, 1.05499995, 1.05499995) + vec3(-0.0549999997, -0.0549999997, -0.0549999997);
					    u_xlat5.xyz = max(u_xlat5.xyz, vec3(0.0, 0.0, 0.0));
					    u_xlatb36 = 0.0<unity_SpecCube0_ProbePosition.w;
					    if(u_xlatb36){
					        u_xlat36 = dot(u_xlat4.xyz, u_xlat4.xyz);
					        u_xlat36 = inversesqrt(u_xlat36);
					        u_xlat6.xyz = vec3(u_xlat36) * u_xlat4.xyz;
					        u_xlat7.xyz = (-vs_TEXCOORD3.xyz) + unity_SpecCube0_BoxMax.xyz;
					        u_xlat7.xyz = u_xlat7.xyz / u_xlat6.xyz;
					        u_xlat8.xyz = (-vs_TEXCOORD3.xyz) + unity_SpecCube0_BoxMin.xyz;
					        u_xlat8.xyz = u_xlat8.xyz / u_xlat6.xyz;
					        u_xlatb9.xyz = lessThan(vec4(0.0, 0.0, 0.0, 0.0), u_xlat6.xyzx).xyz;
					        {
					            vec4 hlslcc_movcTemp = u_xlat7;
					            hlslcc_movcTemp.x = (u_xlatb9.x) ? u_xlat7.x : u_xlat8.x;
					            hlslcc_movcTemp.y = (u_xlatb9.y) ? u_xlat7.y : u_xlat8.y;
					            hlslcc_movcTemp.z = (u_xlatb9.z) ? u_xlat7.z : u_xlat8.z;
					            u_xlat7 = hlslcc_movcTemp;
					        }
					        u_xlat36 = min(u_xlat7.y, u_xlat7.x);
					        u_xlat36 = min(u_xlat7.z, u_xlat36);
					        u_xlat7.xyz = vs_TEXCOORD3.xyz + (-unity_SpecCube0_ProbePosition.xyz);
					        u_xlat6.xyz = u_xlat6.xyz * vec3(u_xlat36) + u_xlat7.xyz;
					    } else {
					        u_xlat6.xyz = u_xlat4.xyz;
					    }
					    u_xlat6 = textureLod(unity_SpecCube0, u_xlat6.xyz, 6.0);
					    u_xlat36 = u_xlat6.w + -1.0;
					    u_xlat36 = unity_SpecCube0_HDR.w * u_xlat36 + 1.0;
					    u_xlat36 = u_xlat36 * unity_SpecCube0_HDR.x;
					    u_xlat7.xyz = u_xlat6.xyz * vec3(u_xlat36);
					    u_xlatb37 = unity_SpecCube0_BoxMin.w<0.999989986;
					    if(u_xlatb37){
					        u_xlatb37 = 0.0<unity_SpecCube1_ProbePosition.w;
					        if(u_xlatb37){
					            u_xlat37 = dot(u_xlat4.xyz, u_xlat4.xyz);
					            u_xlat37 = inversesqrt(u_xlat37);
					            u_xlat8.xyz = vec3(u_xlat37) * u_xlat4.xyz;
					            u_xlat9.xyz = (-vs_TEXCOORD3.xyz) + unity_SpecCube1_BoxMax.xyz;
					            u_xlat9.xyz = u_xlat9.xyz / u_xlat8.xyz;
					            u_xlat10.xyz = (-vs_TEXCOORD3.xyz) + unity_SpecCube1_BoxMin.xyz;
					            u_xlat10.xyz = u_xlat10.xyz / u_xlat8.xyz;
					            u_xlatb11.xyz = lessThan(vec4(0.0, 0.0, 0.0, 0.0), u_xlat8.xyzx).xyz;
					            {
					                vec3 hlslcc_movcTemp = u_xlat9;
					                hlslcc_movcTemp.x = (u_xlatb11.x) ? u_xlat9.x : u_xlat10.x;
					                hlslcc_movcTemp.y = (u_xlatb11.y) ? u_xlat9.y : u_xlat10.y;
					                hlslcc_movcTemp.z = (u_xlatb11.z) ? u_xlat9.z : u_xlat10.z;
					                u_xlat9 = hlslcc_movcTemp;
					            }
					            u_xlat37 = min(u_xlat9.y, u_xlat9.x);
					            u_xlat37 = min(u_xlat9.z, u_xlat37);
					            u_xlat9.xyz = vs_TEXCOORD3.xyz + (-unity_SpecCube1_ProbePosition.xyz);
					            u_xlat4.xyz = u_xlat8.xyz * vec3(u_xlat37) + u_xlat9.xyz;
					        }
					        u_xlat4 = textureLod(unity_SpecCube1, u_xlat4.xyz, 6.0);
					        u_xlat37 = u_xlat4.w + -1.0;
					        u_xlat37 = unity_SpecCube1_HDR.w * u_xlat37 + 1.0;
					        u_xlat37 = u_xlat37 * unity_SpecCube1_HDR.x;
					        u_xlat4.xyz = u_xlat4.xyz * vec3(u_xlat37);
					        u_xlat6.xyz = vec3(u_xlat36) * u_xlat6.xyz + (-u_xlat4.xyz);
					        u_xlat7.xyz = unity_SpecCube0_BoxMin.www * u_xlat6.xyz + u_xlat4.xyz;
					    }
					    u_xlat0.w = dot(u_xlat3.xyz, u_xlat0.xyz);
					    u_xlat4.xy = vs_TEXCOORD0.xy * _AmbientOcculsion_ST.xy + _AmbientOcculsion_ST.zw;
					    u_xlat4 = texture(_AmbientOcculsion, u_xlat4.xy);
					    u_xlat16.xy = vs_TEXCOORD0.xy * _Specular_ST.xy + _Specular_ST.zw;
					    u_xlat6 = texture(_Specular, u_xlat16.xy);
					    u_xlat0.x = dot(u_xlat0.xyz, u_xlat1.xyz);
					    u_xlat12.xy = vs_TEXCOORD0.xy * _MainTexture_ST.xy + _MainTexture_ST.zw;
					    u_xlat8 = texture(_MainTexture, u_xlat12.xy);
					    u_xlat16.xyz = _Color.xyz * u_xlat8.xyz + vec3(_Shadows);
					    u_xlat16.xyz = u_xlat16.xyz + vec3(-1.0, -1.0, -1.0);
					    u_xlat16.xyz = clamp(u_xlat16.xyz, 0.0, 1.0);
					    u_xlat12.x = u_xlat6.x * 0.449999988;
					    u_xlat8.xyz = u_xlat16.xyz + vec3(-0.220916301, -0.220916301, -0.220916301);
					    u_xlat8.xyz = u_xlat12.xxx * u_xlat8.xyz + vec3(0.220916301, 0.220916301, 0.220916301);
					    u_xlat12.x = (-u_xlat6.x) * 0.350587666 + 0.779083729;
					    u_xlat16.xyz = u_xlat12.xxx * u_xlat16.xyz;
					    u_xlat12.x = (-u_xlat12.x) + 1.0;
					    u_xlat12.x = clamp(u_xlat12.x, 0.0, 1.0);
					    u_xlat0.z = dot(u_xlat3.xyz, u_xlat2.xyz);
					    u_xlat0.xzw = max(u_xlat0.xzw, vec3(0.0, 0.0, 0.0));
					    u_xlat1.x = dot(u_xlat3.xyz, u_xlat1.xyz);
					    u_xlat1.x = max(u_xlat1.x, 0.0);
					    u_xlat13.x = u_xlat0.w * 0.202115417 + 0.797884583;
					    u_xlat25 = u_xlat0.z * 0.202115417 + 0.797884583;
					    u_xlat13.x = u_xlat13.x * u_xlat25 + 9.99999975e-06;
					    u_xlat13.x = float(1.0) / u_xlat13.x;
					    u_xlat13.y = log2(u_xlat1.x);
					    u_xlat13.xy = u_xlat13.xy * vec2(0.25, 9.99999975e-05);
					    u_xlat25 = exp2(u_xlat13.y);
					    u_xlat1.z = u_xlat25 * 0.318325758;
					    u_xlat1.y = u_xlat0.w * u_xlat13.x;
					    u_xlat1.xy = u_xlat1.xz * u_xlat1.xy;
					    u_xlat13.x = u_xlat1.y * 0.616850257;
					    u_xlat1.x = u_xlat13.x * u_xlat1.x;
					    u_xlat1.xyz = u_xlat1.xxx * _LightColor0.xyz;
					    u_xlat37 = (-u_xlat0.x) + 1.0;
					    u_xlat2.x = u_xlat37 * u_xlat37;
					    u_xlat2.x = u_xlat2.x * u_xlat2.x;
					    u_xlat37 = u_xlat37 * u_xlat2.x;
					    u_xlat2.xyz = (-u_xlat8.xyz) + vec3(1.0, 1.0, 1.0);
					    u_xlat2.xyz = u_xlat2.xyz * vec3(u_xlat37) + u_xlat8.xyz;
					    u_xlat3.xyz = u_xlat6.xyz * vec3(0.0199999996, 0.0199999996, 0.0199999996) + u_xlat7.xyz;
					    u_xlat3.xyz = u_xlat4.xxx * u_xlat3.xyz;
					    u_xlat6.xy = (-u_xlat0.zz) + vec2(1.0, 1.00001001);
					    u_xlat30.xy = u_xlat6.xy * u_xlat6.xy;
					    u_xlat30.xy = u_xlat30.xy * u_xlat30.xy;
					    u_xlat6.xy = u_xlat6.xy * u_xlat30.xy;
					    u_xlat7.xyz = (-u_xlat8.xyz) + u_xlat12.xxx;
					    u_xlat6.xzw = u_xlat6.xxx * u_xlat7.xyz + u_xlat8.xyz;
					    u_xlat3.xyz = u_xlat3.xyz * u_xlat6.xzw;
					    u_xlat1.xyz = u_xlat1.xyz * u_xlat2.xyz + u_xlat3.xyz;
					    u_xlat12.x = u_xlat0.x + u_xlat0.x;
					    u_xlat0.x = u_xlat12.x * u_xlat0.x + -0.5;
					    u_xlat12.x = (-u_xlat0.w) + 1.00001001;
					    u_xlat24 = u_xlat12.x * u_xlat12.x;
					    u_xlat24 = u_xlat24 * u_xlat24;
					    u_xlat12.x = u_xlat24 * u_xlat12.x;
					    u_xlat12.x = u_xlat0.x * u_xlat12.x + 1.0;
					    u_xlat0.x = u_xlat0.x * u_xlat6.y + 1.0;
					    u_xlat0.x = u_xlat0.x * u_xlat12.x;
					    u_xlat0.x = u_xlat0.w * u_xlat0.x;
					    u_xlat12.xyz = u_xlat4.xxx * u_xlat5.xyz;
					    u_xlat0.xyz = u_xlat0.xxx * _LightColor0.xyz + u_xlat12.xyz;
					    SV_Target0.xyz = u_xlat0.xyz * u_xlat16.xyz + u_xlat1.xyz;
					    SV_Target0.w = 1.0;
					    return;
					}"
				}
				SubProgram "d3d11 " {
					Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "DIRLIGHTMAP_COMBINED" "LIGHTMAP_OFF" "DYNAMICLIGHTMAP_OFF" }
					"ps_4_0
					
					#version 330
					#extension GL_ARB_explicit_attrib_location : require
					#extension GL_ARB_explicit_uniform_location : require
					
					#define HLSLCC_ENABLE_UNIFORM_BUFFERS 1
					#if HLSLCC_ENABLE_UNIFORM_BUFFERS
					#define UNITY_UNIFORM
					#else
					#define UNITY_UNIFORM uniform
					#endif
					#define UNITY_SUPPORTS_UNIFORM_LOCATION 1
					#if UNITY_SUPPORTS_UNIFORM_LOCATION
					#define UNITY_LOCATION(x) layout(location = x)
					#define UNITY_BINDING(x) layout(binding = x, std140)
					#else
					#define UNITY_LOCATION(x)
					#define UNITY_BINDING(x) layout(std140)
					#endif
					layout(std140) uniform PGlobals {
						vec4 unused_0_0[2];
						vec4 _LightColor0;
						vec4 unused_0_2;
						vec4 _MainTexture_ST;
						vec4 _Specular_ST;
						vec4 _NormalMap_ST;
						vec4 _Color;
						vec4 unused_0_7;
						float _NormalSharpness;
						vec4 _AmbientOcculsion_ST;
						float _Shadows;
					};
					layout(std140) uniform UnityPerCamera {
						vec4 unused_1_0[4];
						vec3 _WorldSpaceCameraPos;
						vec4 unused_1_2[4];
					};
					layout(std140) uniform UnityLighting {
						vec4 _WorldSpaceLightPos0;
						vec4 unused_2_1[47];
					};
					layout(std140) uniform UnityReflectionProbes {
						vec4 unity_SpecCube0_BoxMax;
						vec4 unity_SpecCube0_BoxMin;
						vec4 unity_SpecCube0_ProbePosition;
						vec4 unity_SpecCube0_HDR;
						vec4 unity_SpecCube1_BoxMax;
						vec4 unity_SpecCube1_BoxMin;
						vec4 unity_SpecCube1_ProbePosition;
						vec4 unity_SpecCube1_HDR;
					};
					uniform  sampler2D _NormalMap;
					uniform  sampler2D _ShadowMapTexture;
					uniform  sampler2D _AmbientOcculsion;
					uniform  sampler2D _Specular;
					uniform  sampler2D _MainTexture;
					uniform  samplerCube unity_SpecCube0;
					uniform  samplerCube unity_SpecCube1;
					in  vec2 vs_TEXCOORD0;
					in  vec4 vs_TEXCOORD3;
					in  vec3 vs_TEXCOORD4;
					in  vec3 vs_TEXCOORD5;
					in  vec3 vs_TEXCOORD6;
					in  vec4 vs_TEXCOORD8;
					layout(location = 0) out vec4 SV_Target0;
					vec4 u_xlat0;
					int u_xlati0;
					vec3 u_xlat1;
					vec4 u_xlat2;
					vec4 u_xlat3;
					vec4 u_xlat4;
					vec4 u_xlat5;
					vec4 u_xlat6;
					vec3 u_xlat7;
					vec3 u_xlat8;
					vec3 u_xlat9;
					bvec3 u_xlatb9;
					vec3 u_xlat10;
					bvec3 u_xlatb11;
					vec2 u_xlat12;
					int u_xlati12;
					float u_xlat13;
					vec3 u_xlat17;
					float u_xlat24;
					float u_xlat25;
					float u_xlat36;
					bool u_xlatb36;
					float u_xlat37;
					bool u_xlatb37;
					float u_xlat38;
					void main()
					{
					    u_xlat0.x = dot(vs_TEXCOORD4.xyz, vs_TEXCOORD4.xyz);
					    u_xlat0.x = inversesqrt(u_xlat0.x);
					    u_xlat0.xyz = u_xlat0.xxx * vs_TEXCOORD4.xyz;
					    u_xlat1.xyz = (-vs_TEXCOORD3.xyz) + _WorldSpaceCameraPos.xyz;
					    u_xlat36 = dot(u_xlat1.xyz, u_xlat1.xyz);
					    u_xlat36 = inversesqrt(u_xlat36);
					    u_xlat2.xyz = vec3(u_xlat36) * u_xlat1.xyz;
					    u_xlat3.xy = vs_TEXCOORD0.xy * _NormalMap_ST.xy + _NormalMap_ST.zw;
					    u_xlat3 = texture(_NormalMap, u_xlat3.xy);
					    u_xlat3.x = u_xlat3.w * u_xlat3.x;
					    u_xlat3.xy = u_xlat3.xy * vec2(2.0, 2.0) + vec2(-1.0, -1.0);
					    u_xlat37 = dot(u_xlat3.xy, u_xlat3.xy);
					    u_xlat37 = min(u_xlat37, 1.0);
					    u_xlat37 = (-u_xlat37) + 1.0;
					    u_xlat3.z = sqrt(u_xlat37);
					    u_xlat37 = (-_NormalSharpness) + 1.0;
					    u_xlat3.xyz = u_xlat3.xyz / vec3(u_xlat37);
					    u_xlat3.xyz = clamp(u_xlat3.xyz, 0.0, 1.0);
					    u_xlat4.xyz = u_xlat3.yyy * vs_TEXCOORD6.xyz;
					    u_xlat3.xyw = u_xlat3.xxx * vs_TEXCOORD5.xyz + u_xlat4.xyz;
					    u_xlat3.xyz = u_xlat3.zzz * u_xlat0.xyz + u_xlat3.xyw;
					    u_xlat37 = dot(u_xlat3.xyz, u_xlat3.xyz);
					    u_xlat37 = inversesqrt(u_xlat37);
					    u_xlat3.xyz = vec3(u_xlat37) * u_xlat3.xyz;
					    u_xlat0.x = dot(u_xlat2.xyz, u_xlat0.xyz);
					    u_xlati12 = int((0.0<u_xlat0.x) ? 0xFFFFFFFFu : uint(0));
					    u_xlati0 = int((u_xlat0.x<0.0) ? 0xFFFFFFFFu : uint(0));
					    u_xlati0 = (-u_xlati12) + u_xlati0;
					    u_xlat0.x = float(u_xlati0);
					    u_xlat0.xyz = u_xlat0.xxx * u_xlat3.xyz;
					    u_xlat37 = dot(_WorldSpaceLightPos0.xyz, _WorldSpaceLightPos0.xyz);
					    u_xlat37 = inversesqrt(u_xlat37);
					    u_xlat3.xyz = vec3(u_xlat37) * _WorldSpaceLightPos0.xyz;
					    u_xlat1.xyz = u_xlat1.xyz * vec3(u_xlat36) + u_xlat3.xyz;
					    u_xlat36 = dot(u_xlat1.xyz, u_xlat1.xyz);
					    u_xlat36 = inversesqrt(u_xlat36);
					    u_xlat1.xyz = vec3(u_xlat36) * u_xlat1.xyz;
					    u_xlat4.xy = vs_TEXCOORD8.xy / vs_TEXCOORD8.ww;
					    u_xlat4 = texture(_ShadowMapTexture, u_xlat4.xy);
					    u_xlat4.xyz = u_xlat4.xxx * _LightColor0.xyz;
					    u_xlat36 = dot((-u_xlat2.xyz), u_xlat0.xyz);
					    u_xlat36 = u_xlat36 + u_xlat36;
					    u_xlat5.xyz = u_xlat0.xyz * (-vec3(u_xlat36)) + (-u_xlat2.xyz);
					    u_xlatb36 = 0.0<unity_SpecCube0_ProbePosition.w;
					    if(u_xlatb36){
					        u_xlat36 = dot(u_xlat5.xyz, u_xlat5.xyz);
					        u_xlat36 = inversesqrt(u_xlat36);
					        u_xlat6.xyz = vec3(u_xlat36) * u_xlat5.xyz;
					        u_xlat7.xyz = (-vs_TEXCOORD3.xyz) + unity_SpecCube0_BoxMax.xyz;
					        u_xlat7.xyz = u_xlat7.xyz / u_xlat6.xyz;
					        u_xlat8.xyz = (-vs_TEXCOORD3.xyz) + unity_SpecCube0_BoxMin.xyz;
					        u_xlat8.xyz = u_xlat8.xyz / u_xlat6.xyz;
					        u_xlatb9.xyz = lessThan(vec4(0.0, 0.0, 0.0, 0.0), u_xlat6.xyzx).xyz;
					        {
					            vec3 hlslcc_movcTemp = u_xlat7;
					            hlslcc_movcTemp.x = (u_xlatb9.x) ? u_xlat7.x : u_xlat8.x;
					            hlslcc_movcTemp.y = (u_xlatb9.y) ? u_xlat7.y : u_xlat8.y;
					            hlslcc_movcTemp.z = (u_xlatb9.z) ? u_xlat7.z : u_xlat8.z;
					            u_xlat7 = hlslcc_movcTemp;
					        }
					        u_xlat36 = min(u_xlat7.y, u_xlat7.x);
					        u_xlat36 = min(u_xlat7.z, u_xlat36);
					        u_xlat7.xyz = vs_TEXCOORD3.xyz + (-unity_SpecCube0_ProbePosition.xyz);
					        u_xlat6.xyz = u_xlat6.xyz * vec3(u_xlat36) + u_xlat7.xyz;
					    } else {
					        u_xlat6.xyz = u_xlat5.xyz;
					    }
					    u_xlat6 = textureLod(unity_SpecCube0, u_xlat6.xyz, 6.0);
					    u_xlat36 = u_xlat6.w + -1.0;
					    u_xlat36 = unity_SpecCube0_HDR.w * u_xlat36 + 1.0;
					    u_xlat36 = u_xlat36 * unity_SpecCube0_HDR.x;
					    u_xlat7.xyz = u_xlat6.xyz * vec3(u_xlat36);
					    u_xlatb37 = unity_SpecCube0_BoxMin.w<0.999989986;
					    if(u_xlatb37){
					        u_xlatb37 = 0.0<unity_SpecCube1_ProbePosition.w;
					        if(u_xlatb37){
					            u_xlat37 = dot(u_xlat5.xyz, u_xlat5.xyz);
					            u_xlat37 = inversesqrt(u_xlat37);
					            u_xlat8.xyz = vec3(u_xlat37) * u_xlat5.xyz;
					            u_xlat9.xyz = (-vs_TEXCOORD3.xyz) + unity_SpecCube1_BoxMax.xyz;
					            u_xlat9.xyz = u_xlat9.xyz / u_xlat8.xyz;
					            u_xlat10.xyz = (-vs_TEXCOORD3.xyz) + unity_SpecCube1_BoxMin.xyz;
					            u_xlat10.xyz = u_xlat10.xyz / u_xlat8.xyz;
					            u_xlatb11.xyz = lessThan(vec4(0.0, 0.0, 0.0, 0.0), u_xlat8.xyzx).xyz;
					            {
					                vec3 hlslcc_movcTemp = u_xlat9;
					                hlslcc_movcTemp.x = (u_xlatb11.x) ? u_xlat9.x : u_xlat10.x;
					                hlslcc_movcTemp.y = (u_xlatb11.y) ? u_xlat9.y : u_xlat10.y;
					                hlslcc_movcTemp.z = (u_xlatb11.z) ? u_xlat9.z : u_xlat10.z;
					                u_xlat9 = hlslcc_movcTemp;
					            }
					            u_xlat37 = min(u_xlat9.y, u_xlat9.x);
					            u_xlat37 = min(u_xlat9.z, u_xlat37);
					            u_xlat9.xyz = vs_TEXCOORD3.xyz + (-unity_SpecCube1_ProbePosition.xyz);
					            u_xlat5.xyz = u_xlat8.xyz * vec3(u_xlat37) + u_xlat9.xyz;
					        }
					        u_xlat5 = textureLod(unity_SpecCube1, u_xlat5.xyz, 6.0);
					        u_xlat37 = u_xlat5.w + -1.0;
					        u_xlat37 = unity_SpecCube1_HDR.w * u_xlat37 + 1.0;
					        u_xlat37 = u_xlat37 * unity_SpecCube1_HDR.x;
					        u_xlat5.xyz = u_xlat5.xyz * vec3(u_xlat37);
					        u_xlat6.xyz = vec3(u_xlat36) * u_xlat6.xyz + (-u_xlat5.xyz);
					        u_xlat7.xyz = unity_SpecCube0_BoxMin.www * u_xlat6.xyz + u_xlat5.xyz;
					    }
					    u_xlat0.w = dot(u_xlat0.xyz, u_xlat3.xyz);
					    u_xlat5.xy = vs_TEXCOORD0.xy * _AmbientOcculsion_ST.xy + _AmbientOcculsion_ST.zw;
					    u_xlat5 = texture(_AmbientOcculsion, u_xlat5.xy);
					    u_xlat17.xy = vs_TEXCOORD0.xy * _Specular_ST.xy + _Specular_ST.zw;
					    u_xlat6 = texture(_Specular, u_xlat17.xy);
					    u_xlat37 = dot(u_xlat3.xyz, u_xlat1.xyz);
					    u_xlat37 = max(u_xlat37, 0.0);
					    u_xlat3.xy = vs_TEXCOORD0.xy * _MainTexture_ST.xy + _MainTexture_ST.zw;
					    u_xlat3 = texture(_MainTexture, u_xlat3.xy);
					    u_xlat3.xyz = _Color.xyz * u_xlat3.xyz + vec3(_Shadows);
					    u_xlat3.xyz = u_xlat3.xyz + vec3(-1.0, -1.0, -1.0);
					    u_xlat3.xyz = clamp(u_xlat3.xyz, 0.0, 1.0);
					    u_xlat38 = u_xlat6.x * 0.449999988;
					    u_xlat17.xyz = u_xlat3.xyz + vec3(-0.220916301, -0.220916301, -0.220916301);
					    u_xlat17.xyz = vec3(u_xlat38) * u_xlat17.xyz + vec3(0.220916301, 0.220916301, 0.220916301);
					    u_xlat38 = (-u_xlat6.x) * 0.350587666 + 0.779083729;
					    u_xlat3.xyz = vec3(u_xlat38) * u_xlat3.xyz;
					    u_xlat38 = (-u_xlat38) + 1.0;
					    u_xlat38 = clamp(u_xlat38, 0.0, 1.0);
					    u_xlat2.x = dot(u_xlat0.xyz, u_xlat2.xyz);
					    u_xlat2.x = max(u_xlat2.x, 0.0);
					    u_xlat0.x = dot(u_xlat0.xyz, u_xlat1.xyz);
					    u_xlat0.xw = max(u_xlat0.xw, vec2(0.0, 0.0));
					    u_xlat12.x = u_xlat0.w * 0.202115417 + 0.797884583;
					    u_xlat24 = u_xlat2.x * 0.202115417 + 0.797884583;
					    u_xlat12.x = u_xlat12.x * u_xlat24 + 9.99999975e-06;
					    u_xlat12.x = float(1.0) / u_xlat12.x;
					    u_xlat12.y = log2(u_xlat0.x);
					    u_xlat0.yz = u_xlat12.xy * vec2(0.25, 9.99999975e-05);
					    u_xlat24 = exp2(u_xlat0.z);
					    u_xlat24 = u_xlat24 * 0.318325758;
					    u_xlat0.xy = u_xlat0.xy * u_xlat0.xw;
					    u_xlat12.x = u_xlat24 * u_xlat0.y;
					    u_xlat12.x = u_xlat12.x * 0.616850257;
					    u_xlat0.x = u_xlat12.x * u_xlat0.x;
					    u_xlat0.xyz = u_xlat4.xyz * u_xlat0.xxx;
					    u_xlat1.x = (-u_xlat37) + 1.0;
					    u_xlat13 = u_xlat1.x * u_xlat1.x;
					    u_xlat13 = u_xlat13 * u_xlat13;
					    u_xlat1.x = u_xlat1.x * u_xlat13;
					    u_xlat8.xyz = (-u_xlat17.xyz) + vec3(1.0, 1.0, 1.0);
					    u_xlat1.xyz = u_xlat8.xyz * u_xlat1.xxx + u_xlat17.xyz;
					    u_xlat6.xyz = u_xlat6.xyz * vec3(0.0199999996, 0.0199999996, 0.0199999996) + u_xlat7.xyz;
					    u_xlat6.xyz = u_xlat5.xxx * u_xlat6.xyz;
					    u_xlat2.xy = (-u_xlat2.xx) + vec2(1.0, 1.00001001);
					    u_xlat7.xy = u_xlat2.xy * u_xlat2.xy;
					    u_xlat7.xy = u_xlat7.xy * u_xlat7.xy;
					    u_xlat2.xy = u_xlat2.xy * u_xlat7.xy;
					    u_xlat7.xyz = (-u_xlat17.xyz) + vec3(u_xlat38);
					    u_xlat2.xzw = u_xlat2.xxx * u_xlat7.xyz + u_xlat17.xyz;
					    u_xlat2.xzw = u_xlat2.xzw * u_xlat6.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz + u_xlat2.xzw;
					    u_xlat1.x = u_xlat37 + u_xlat37;
					    u_xlat1.x = u_xlat1.x * u_xlat37 + -0.5;
					    u_xlat13 = (-u_xlat0.w) + 1.00001001;
					    u_xlat25 = u_xlat13 * u_xlat13;
					    u_xlat25 = u_xlat25 * u_xlat25;
					    u_xlat13 = u_xlat25 * u_xlat13;
					    u_xlat13 = u_xlat1.x * u_xlat13 + 1.0;
					    u_xlat1.x = u_xlat1.x * u_xlat2.y + 1.0;
					    u_xlat1.x = u_xlat1.x * u_xlat13;
					    u_xlat36 = u_xlat0.w * u_xlat1.x;
					    u_xlat1.xyz = u_xlat4.xyz * vec3(u_xlat36);
					    SV_Target0.xyz = u_xlat1.xyz * u_xlat3.xyz + u_xlat0.xyz;
					    SV_Target0.w = 1.0;
					    return;
					}"
				}
				SubProgram "d3d11 " {
					Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "DIRLIGHTMAP_COMBINED" "LIGHTPROBE_SH" "LIGHTMAP_OFF" "DYNAMICLIGHTMAP_OFF" }
					"ps_4_0
					
					#version 330
					#extension GL_ARB_explicit_attrib_location : require
					#extension GL_ARB_explicit_uniform_location : require
					
					#define HLSLCC_ENABLE_UNIFORM_BUFFERS 1
					#if HLSLCC_ENABLE_UNIFORM_BUFFERS
					#define UNITY_UNIFORM
					#else
					#define UNITY_UNIFORM uniform
					#endif
					#define UNITY_SUPPORTS_UNIFORM_LOCATION 1
					#if UNITY_SUPPORTS_UNIFORM_LOCATION
					#define UNITY_LOCATION(x) layout(location = x)
					#define UNITY_BINDING(x) layout(binding = x, std140)
					#else
					#define UNITY_LOCATION(x)
					#define UNITY_BINDING(x) layout(std140)
					#endif
					layout(std140) uniform PGlobals {
						vec4 unused_0_0[2];
						vec4 _LightColor0;
						vec4 unused_0_2;
						vec4 _MainTexture_ST;
						vec4 _Specular_ST;
						vec4 _NormalMap_ST;
						vec4 _Color;
						vec4 unused_0_7;
						float _NormalSharpness;
						vec4 _AmbientOcculsion_ST;
						float _Shadows;
					};
					layout(std140) uniform UnityPerCamera {
						vec4 unused_1_0[4];
						vec3 _WorldSpaceCameraPos;
						vec4 unused_1_2[4];
					};
					layout(std140) uniform UnityLighting {
						vec4 _WorldSpaceLightPos0;
						vec4 unused_2_1[38];
						vec4 unity_SHAr;
						vec4 unity_SHAg;
						vec4 unity_SHAb;
						vec4 unused_2_5[6];
					};
					layout(std140) uniform UnityReflectionProbes {
						vec4 unity_SpecCube0_BoxMax;
						vec4 unity_SpecCube0_BoxMin;
						vec4 unity_SpecCube0_ProbePosition;
						vec4 unity_SpecCube0_HDR;
						vec4 unity_SpecCube1_BoxMax;
						vec4 unity_SpecCube1_BoxMin;
						vec4 unity_SpecCube1_ProbePosition;
						vec4 unity_SpecCube1_HDR;
					};
					layout(std140) uniform UnityProbeVolume {
						vec4 unity_ProbeVolumeParams;
						mat4x4 unity_ProbeVolumeWorldToObject;
						vec3 unity_ProbeVolumeSizeInv;
						vec3 unity_ProbeVolumeMin;
					};
					uniform  sampler2D _NormalMap;
					uniform  sampler2D _ShadowMapTexture;
					uniform  sampler2D _AmbientOcculsion;
					uniform  sampler2D _Specular;
					uniform  sampler2D _MainTexture;
					uniform  samplerCube unity_SpecCube0;
					uniform  samplerCube unity_SpecCube1;
					uniform  sampler3D unity_ProbeVolumeSH;
					in  vec2 vs_TEXCOORD0;
					in  vec4 vs_TEXCOORD3;
					in  vec3 vs_TEXCOORD4;
					in  vec3 vs_TEXCOORD5;
					in  vec3 vs_TEXCOORD6;
					in  vec4 vs_TEXCOORD8;
					in  vec4 vs_TEXCOORD10;
					layout(location = 0) out vec4 SV_Target0;
					vec4 u_xlat0;
					int u_xlati0;
					vec3 u_xlat1;
					vec3 u_xlat2;
					vec4 u_xlat3;
					vec4 u_xlat4;
					vec4 u_xlat5;
					vec4 u_xlat6;
					vec4 u_xlat7;
					vec4 u_xlat8;
					vec4 u_xlat9;
					vec3 u_xlat10;
					bvec3 u_xlatb10;
					vec3 u_xlat11;
					bvec3 u_xlatb12;
					vec3 u_xlat13;
					int u_xlati13;
					vec2 u_xlat14;
					vec3 u_xlat18;
					float u_xlat26;
					float u_xlat27;
					vec2 u_xlat33;
					float u_xlat39;
					bool u_xlatb39;
					float u_xlat40;
					bool u_xlatb40;
					float u_xlat41;
					void main()
					{
					    u_xlat0.x = dot(vs_TEXCOORD4.xyz, vs_TEXCOORD4.xyz);
					    u_xlat0.x = inversesqrt(u_xlat0.x);
					    u_xlat0.xyz = u_xlat0.xxx * vs_TEXCOORD4.xyz;
					    u_xlat1.xyz = (-vs_TEXCOORD3.xyz) + _WorldSpaceCameraPos.xyz;
					    u_xlat39 = dot(u_xlat1.xyz, u_xlat1.xyz);
					    u_xlat39 = inversesqrt(u_xlat39);
					    u_xlat2.xyz = vec3(u_xlat39) * u_xlat1.xyz;
					    u_xlat3.xy = vs_TEXCOORD0.xy * _NormalMap_ST.xy + _NormalMap_ST.zw;
					    u_xlat3 = texture(_NormalMap, u_xlat3.xy);
					    u_xlat3.x = u_xlat3.w * u_xlat3.x;
					    u_xlat3.xy = u_xlat3.xy * vec2(2.0, 2.0) + vec2(-1.0, -1.0);
					    u_xlat40 = dot(u_xlat3.xy, u_xlat3.xy);
					    u_xlat40 = min(u_xlat40, 1.0);
					    u_xlat40 = (-u_xlat40) + 1.0;
					    u_xlat3.z = sqrt(u_xlat40);
					    u_xlat40 = (-_NormalSharpness) + 1.0;
					    u_xlat3.xyz = u_xlat3.xyz / vec3(u_xlat40);
					    u_xlat3.xyz = clamp(u_xlat3.xyz, 0.0, 1.0);
					    u_xlat4.xyz = u_xlat3.yyy * vs_TEXCOORD6.xyz;
					    u_xlat3.xyw = u_xlat3.xxx * vs_TEXCOORD5.xyz + u_xlat4.xyz;
					    u_xlat3.xyz = u_xlat3.zzz * u_xlat0.xyz + u_xlat3.xyw;
					    u_xlat40 = dot(u_xlat3.xyz, u_xlat3.xyz);
					    u_xlat40 = inversesqrt(u_xlat40);
					    u_xlat3.xyz = vec3(u_xlat40) * u_xlat3.xyz;
					    u_xlat0.x = dot(u_xlat2.xyz, u_xlat0.xyz);
					    u_xlati13 = int((0.0<u_xlat0.x) ? 0xFFFFFFFFu : uint(0));
					    u_xlati0 = int((u_xlat0.x<0.0) ? 0xFFFFFFFFu : uint(0));
					    u_xlati0 = (-u_xlati13) + u_xlati0;
					    u_xlat0.x = float(u_xlati0);
					    u_xlat3.xyz = u_xlat0.xxx * u_xlat3.xyz;
					    u_xlat0.x = dot(_WorldSpaceLightPos0.xyz, _WorldSpaceLightPos0.xyz);
					    u_xlat0.x = inversesqrt(u_xlat0.x);
					    u_xlat0.xyz = u_xlat0.xxx * _WorldSpaceLightPos0.xyz;
					    u_xlat1.xyz = u_xlat1.xyz * vec3(u_xlat39) + u_xlat0.xyz;
					    u_xlat39 = dot(u_xlat1.xyz, u_xlat1.xyz);
					    u_xlat39 = inversesqrt(u_xlat39);
					    u_xlat1.xyz = vec3(u_xlat39) * u_xlat1.xyz;
					    u_xlat4.xy = vs_TEXCOORD8.xy / vs_TEXCOORD8.ww;
					    u_xlat4 = texture(_ShadowMapTexture, u_xlat4.xy);
					    u_xlat4.xyz = u_xlat4.xxx * _LightColor0.xyz;
					    u_xlat39 = dot((-u_xlat2.xyz), u_xlat3.xyz);
					    u_xlat39 = u_xlat39 + u_xlat39;
					    u_xlat5.xyz = u_xlat3.xyz * (-vec3(u_xlat39)) + (-u_xlat2.xyz);
					    u_xlatb39 = unity_ProbeVolumeParams.x==1.0;
					    if(u_xlatb39){
					        u_xlatb39 = unity_ProbeVolumeParams.y==1.0;
					        u_xlat6.xyz = vs_TEXCOORD3.yyy * unity_ProbeVolumeWorldToObject[1].xyz;
					        u_xlat6.xyz = unity_ProbeVolumeWorldToObject[0].xyz * vs_TEXCOORD3.xxx + u_xlat6.xyz;
					        u_xlat6.xyz = unity_ProbeVolumeWorldToObject[2].xyz * vs_TEXCOORD3.zzz + u_xlat6.xyz;
					        u_xlat6.xyz = u_xlat6.xyz + unity_ProbeVolumeWorldToObject[3].xyz;
					        u_xlat6.xyz = (bool(u_xlatb39)) ? u_xlat6.xyz : vs_TEXCOORD3.xyz;
					        u_xlat6.xyz = u_xlat6.xyz + (-unity_ProbeVolumeMin.xyz);
					        u_xlat6.yzw = u_xlat6.xyz * unity_ProbeVolumeSizeInv.xyz;
					        u_xlat39 = u_xlat6.y * 0.25;
					        u_xlat40 = unity_ProbeVolumeParams.z * 0.5;
					        u_xlat41 = (-unity_ProbeVolumeParams.z) * 0.5 + 0.25;
					        u_xlat39 = max(u_xlat39, u_xlat40);
					        u_xlat6.x = min(u_xlat41, u_xlat39);
					        u_xlat7 = texture(unity_ProbeVolumeSH, u_xlat6.xzw);
					        u_xlat8.xyz = u_xlat6.xzw + vec3(0.25, 0.0, 0.0);
					        u_xlat8 = texture(unity_ProbeVolumeSH, u_xlat8.xyz);
					        u_xlat6.xyz = u_xlat6.xzw + vec3(0.5, 0.0, 0.0);
					        u_xlat6 = texture(unity_ProbeVolumeSH, u_xlat6.xyz);
					        u_xlat3.w = 1.0;
					        u_xlat7.x = dot(u_xlat7, u_xlat3);
					        u_xlat7.y = dot(u_xlat8, u_xlat3);
					        u_xlat7.z = dot(u_xlat6, u_xlat3);
					    } else {
					        u_xlat3.w = 1.0;
					        u_xlat7.x = dot(unity_SHAr, u_xlat3);
					        u_xlat7.y = dot(unity_SHAg, u_xlat3);
					        u_xlat7.z = dot(unity_SHAb, u_xlat3);
					    }
					    u_xlat6.xyz = u_xlat7.xyz + vs_TEXCOORD10.xyz;
					    u_xlat6.xyz = max(u_xlat6.xyz, vec3(0.0, 0.0, 0.0));
					    u_xlat6.xyz = log2(u_xlat6.xyz);
					    u_xlat6.xyz = u_xlat6.xyz * vec3(0.416666657, 0.416666657, 0.416666657);
					    u_xlat6.xyz = exp2(u_xlat6.xyz);
					    u_xlat6.xyz = u_xlat6.xyz * vec3(1.05499995, 1.05499995, 1.05499995) + vec3(-0.0549999997, -0.0549999997, -0.0549999997);
					    u_xlat6.xyz = max(u_xlat6.xyz, vec3(0.0, 0.0, 0.0));
					    u_xlatb39 = 0.0<unity_SpecCube0_ProbePosition.w;
					    if(u_xlatb39){
					        u_xlat39 = dot(u_xlat5.xyz, u_xlat5.xyz);
					        u_xlat39 = inversesqrt(u_xlat39);
					        u_xlat7.xyz = vec3(u_xlat39) * u_xlat5.xyz;
					        u_xlat8.xyz = (-vs_TEXCOORD3.xyz) + unity_SpecCube0_BoxMax.xyz;
					        u_xlat8.xyz = u_xlat8.xyz / u_xlat7.xyz;
					        u_xlat9.xyz = (-vs_TEXCOORD3.xyz) + unity_SpecCube0_BoxMin.xyz;
					        u_xlat9.xyz = u_xlat9.xyz / u_xlat7.xyz;
					        u_xlatb10.xyz = lessThan(vec4(0.0, 0.0, 0.0, 0.0), u_xlat7.xyzx).xyz;
					        {
					            vec4 hlslcc_movcTemp = u_xlat8;
					            hlslcc_movcTemp.x = (u_xlatb10.x) ? u_xlat8.x : u_xlat9.x;
					            hlslcc_movcTemp.y = (u_xlatb10.y) ? u_xlat8.y : u_xlat9.y;
					            hlslcc_movcTemp.z = (u_xlatb10.z) ? u_xlat8.z : u_xlat9.z;
					            u_xlat8 = hlslcc_movcTemp;
					        }
					        u_xlat39 = min(u_xlat8.y, u_xlat8.x);
					        u_xlat39 = min(u_xlat8.z, u_xlat39);
					        u_xlat8.xyz = vs_TEXCOORD3.xyz + (-unity_SpecCube0_ProbePosition.xyz);
					        u_xlat7.xyz = u_xlat7.xyz * vec3(u_xlat39) + u_xlat8.xyz;
					    } else {
					        u_xlat7.xyz = u_xlat5.xyz;
					    }
					    u_xlat7 = textureLod(unity_SpecCube0, u_xlat7.xyz, 6.0);
					    u_xlat39 = u_xlat7.w + -1.0;
					    u_xlat39 = unity_SpecCube0_HDR.w * u_xlat39 + 1.0;
					    u_xlat39 = u_xlat39 * unity_SpecCube0_HDR.x;
					    u_xlat8.xyz = u_xlat7.xyz * vec3(u_xlat39);
					    u_xlatb40 = unity_SpecCube0_BoxMin.w<0.999989986;
					    if(u_xlatb40){
					        u_xlatb40 = 0.0<unity_SpecCube1_ProbePosition.w;
					        if(u_xlatb40){
					            u_xlat40 = dot(u_xlat5.xyz, u_xlat5.xyz);
					            u_xlat40 = inversesqrt(u_xlat40);
					            u_xlat9.xyz = vec3(u_xlat40) * u_xlat5.xyz;
					            u_xlat10.xyz = (-vs_TEXCOORD3.xyz) + unity_SpecCube1_BoxMax.xyz;
					            u_xlat10.xyz = u_xlat10.xyz / u_xlat9.xyz;
					            u_xlat11.xyz = (-vs_TEXCOORD3.xyz) + unity_SpecCube1_BoxMin.xyz;
					            u_xlat11.xyz = u_xlat11.xyz / u_xlat9.xyz;
					            u_xlatb12.xyz = lessThan(vec4(0.0, 0.0, 0.0, 0.0), u_xlat9.xyzx).xyz;
					            {
					                vec3 hlslcc_movcTemp = u_xlat10;
					                hlslcc_movcTemp.x = (u_xlatb12.x) ? u_xlat10.x : u_xlat11.x;
					                hlslcc_movcTemp.y = (u_xlatb12.y) ? u_xlat10.y : u_xlat11.y;
					                hlslcc_movcTemp.z = (u_xlatb12.z) ? u_xlat10.z : u_xlat11.z;
					                u_xlat10 = hlslcc_movcTemp;
					            }
					            u_xlat40 = min(u_xlat10.y, u_xlat10.x);
					            u_xlat40 = min(u_xlat10.z, u_xlat40);
					            u_xlat10.xyz = vs_TEXCOORD3.xyz + (-unity_SpecCube1_ProbePosition.xyz);
					            u_xlat5.xyz = u_xlat9.xyz * vec3(u_xlat40) + u_xlat10.xyz;
					        }
					        u_xlat5 = textureLod(unity_SpecCube1, u_xlat5.xyz, 6.0);
					        u_xlat40 = u_xlat5.w + -1.0;
					        u_xlat40 = unity_SpecCube1_HDR.w * u_xlat40 + 1.0;
					        u_xlat40 = u_xlat40 * unity_SpecCube1_HDR.x;
					        u_xlat5.xyz = u_xlat5.xyz * vec3(u_xlat40);
					        u_xlat7.xyz = vec3(u_xlat39) * u_xlat7.xyz + (-u_xlat5.xyz);
					        u_xlat8.xyz = unity_SpecCube0_BoxMin.www * u_xlat7.xyz + u_xlat5.xyz;
					    }
					    u_xlat0.w = dot(u_xlat3.xyz, u_xlat0.xyz);
					    u_xlat5.xy = vs_TEXCOORD0.xy * _AmbientOcculsion_ST.xy + _AmbientOcculsion_ST.zw;
					    u_xlat5 = texture(_AmbientOcculsion, u_xlat5.xy);
					    u_xlat18.xy = vs_TEXCOORD0.xy * _Specular_ST.xy + _Specular_ST.zw;
					    u_xlat7 = texture(_Specular, u_xlat18.xy);
					    u_xlat0.x = dot(u_xlat0.xyz, u_xlat1.xyz);
					    u_xlat13.xy = vs_TEXCOORD0.xy * _MainTexture_ST.xy + _MainTexture_ST.zw;
					    u_xlat9 = texture(_MainTexture, u_xlat13.xy);
					    u_xlat18.xyz = _Color.xyz * u_xlat9.xyz + vec3(_Shadows);
					    u_xlat18.xyz = u_xlat18.xyz + vec3(-1.0, -1.0, -1.0);
					    u_xlat18.xyz = clamp(u_xlat18.xyz, 0.0, 1.0);
					    u_xlat13.x = u_xlat7.x * 0.449999988;
					    u_xlat9.xyz = u_xlat18.xyz + vec3(-0.220916301, -0.220916301, -0.220916301);
					    u_xlat9.xyz = u_xlat13.xxx * u_xlat9.xyz + vec3(0.220916301, 0.220916301, 0.220916301);
					    u_xlat13.x = (-u_xlat7.x) * 0.350587666 + 0.779083729;
					    u_xlat18.xyz = u_xlat13.xxx * u_xlat18.xyz;
					    u_xlat13.x = (-u_xlat13.x) + 1.0;
					    u_xlat13.x = clamp(u_xlat13.x, 0.0, 1.0);
					    u_xlat0.z = dot(u_xlat3.xyz, u_xlat2.xyz);
					    u_xlat0.xzw = max(u_xlat0.xzw, vec3(0.0, 0.0, 0.0));
					    u_xlat1.x = dot(u_xlat3.xyz, u_xlat1.xyz);
					    u_xlat1.x = max(u_xlat1.x, 0.0);
					    u_xlat14.x = u_xlat0.w * 0.202115417 + 0.797884583;
					    u_xlat27 = u_xlat0.z * 0.202115417 + 0.797884583;
					    u_xlat14.x = u_xlat14.x * u_xlat27 + 9.99999975e-06;
					    u_xlat14.x = float(1.0) / u_xlat14.x;
					    u_xlat14.y = log2(u_xlat1.x);
					    u_xlat14.xy = u_xlat14.xy * vec2(0.25, 9.99999975e-05);
					    u_xlat27 = exp2(u_xlat14.y);
					    u_xlat1.z = u_xlat27 * 0.318325758;
					    u_xlat1.y = u_xlat0.w * u_xlat14.x;
					    u_xlat1.xy = u_xlat1.xz * u_xlat1.xy;
					    u_xlat14.x = u_xlat1.y * 0.616850257;
					    u_xlat1.x = u_xlat14.x * u_xlat1.x;
					    u_xlat1.xyz = u_xlat4.xyz * u_xlat1.xxx;
					    u_xlat40 = (-u_xlat0.x) + 1.0;
					    u_xlat2.x = u_xlat40 * u_xlat40;
					    u_xlat2.x = u_xlat2.x * u_xlat2.x;
					    u_xlat40 = u_xlat40 * u_xlat2.x;
					    u_xlat2.xyz = (-u_xlat9.xyz) + vec3(1.0, 1.0, 1.0);
					    u_xlat2.xyz = u_xlat2.xyz * vec3(u_xlat40) + u_xlat9.xyz;
					    u_xlat3.xyz = u_xlat7.xyz * vec3(0.0199999996, 0.0199999996, 0.0199999996) + u_xlat8.xyz;
					    u_xlat3.xyz = u_xlat5.xxx * u_xlat3.xyz;
					    u_xlat7.xy = (-u_xlat0.zz) + vec2(1.0, 1.00001001);
					    u_xlat33.xy = u_xlat7.xy * u_xlat7.xy;
					    u_xlat33.xy = u_xlat33.xy * u_xlat33.xy;
					    u_xlat7.xy = u_xlat7.xy * u_xlat33.xy;
					    u_xlat8.xyz = (-u_xlat9.xyz) + u_xlat13.xxx;
					    u_xlat7.xzw = u_xlat7.xxx * u_xlat8.xyz + u_xlat9.xyz;
					    u_xlat3.xyz = u_xlat3.xyz * u_xlat7.xzw;
					    u_xlat1.xyz = u_xlat1.xyz * u_xlat2.xyz + u_xlat3.xyz;
					    u_xlat13.x = u_xlat0.x + u_xlat0.x;
					    u_xlat0.x = u_xlat13.x * u_xlat0.x + -0.5;
					    u_xlat13.x = (-u_xlat0.w) + 1.00001001;
					    u_xlat26 = u_xlat13.x * u_xlat13.x;
					    u_xlat26 = u_xlat26 * u_xlat26;
					    u_xlat13.x = u_xlat26 * u_xlat13.x;
					    u_xlat13.x = u_xlat0.x * u_xlat13.x + 1.0;
					    u_xlat0.x = u_xlat0.x * u_xlat7.y + 1.0;
					    u_xlat0.x = u_xlat0.x * u_xlat13.x;
					    u_xlat0.x = u_xlat0.w * u_xlat0.x;
					    u_xlat13.xyz = u_xlat5.xxx * u_xlat6.xyz;
					    u_xlat0.xyz = u_xlat0.xxx * u_xlat4.xyz + u_xlat13.xyz;
					    SV_Target0.xyz = u_xlat0.xyz * u_xlat18.xyz + u_xlat1.xyz;
					    SV_Target0.w = 1.0;
					    return;
					}"
				}
				SubProgram "d3d11 " {
					Keywords { "DIRECTIONAL" "DIRLIGHTMAP_SEPARATE" "LIGHTMAP_OFF" "DYNAMICLIGHTMAP_OFF" }
					"ps_4_0
					
					#version 330
					#extension GL_ARB_explicit_attrib_location : require
					#extension GL_ARB_explicit_uniform_location : require
					
					#define HLSLCC_ENABLE_UNIFORM_BUFFERS 1
					#if HLSLCC_ENABLE_UNIFORM_BUFFERS
					#define UNITY_UNIFORM
					#else
					#define UNITY_UNIFORM uniform
					#endif
					#define UNITY_SUPPORTS_UNIFORM_LOCATION 1
					#if UNITY_SUPPORTS_UNIFORM_LOCATION
					#define UNITY_LOCATION(x) layout(location = x)
					#define UNITY_BINDING(x) layout(binding = x, std140)
					#else
					#define UNITY_LOCATION(x)
					#define UNITY_BINDING(x) layout(std140)
					#endif
					layout(std140) uniform PGlobals {
						vec4 unused_0_0[2];
						vec4 _LightColor0;
						vec4 unused_0_2;
						vec4 _MainTexture_ST;
						vec4 _Specular_ST;
						vec4 _NormalMap_ST;
						vec4 _Color;
						vec4 unused_0_7;
						float _NormalSharpness;
						vec4 _AmbientOcculsion_ST;
						float _Shadows;
					};
					layout(std140) uniform UnityPerCamera {
						vec4 unused_1_0[4];
						vec3 _WorldSpaceCameraPos;
						vec4 unused_1_2[4];
					};
					layout(std140) uniform UnityLighting {
						vec4 _WorldSpaceLightPos0;
						vec4 unused_2_1[47];
					};
					layout(std140) uniform UnityReflectionProbes {
						vec4 unity_SpecCube0_BoxMax;
						vec4 unity_SpecCube0_BoxMin;
						vec4 unity_SpecCube0_ProbePosition;
						vec4 unity_SpecCube0_HDR;
						vec4 unity_SpecCube1_BoxMax;
						vec4 unity_SpecCube1_BoxMin;
						vec4 unity_SpecCube1_ProbePosition;
						vec4 unity_SpecCube1_HDR;
					};
					uniform  sampler2D _NormalMap;
					uniform  sampler2D _AmbientOcculsion;
					uniform  sampler2D _Specular;
					uniform  sampler2D _MainTexture;
					uniform  samplerCube unity_SpecCube0;
					uniform  samplerCube unity_SpecCube1;
					in  vec2 vs_TEXCOORD0;
					in  vec4 vs_TEXCOORD3;
					in  vec3 vs_TEXCOORD4;
					in  vec3 vs_TEXCOORD5;
					in  vec3 vs_TEXCOORD6;
					layout(location = 0) out vec4 SV_Target0;
					vec4 u_xlat0;
					int u_xlati0;
					vec3 u_xlat1;
					vec4 u_xlat2;
					vec4 u_xlat3;
					vec4 u_xlat4;
					vec4 u_xlat5;
					vec3 u_xlat6;
					vec3 u_xlat7;
					vec3 u_xlat8;
					bvec3 u_xlatb8;
					vec3 u_xlat9;
					bvec3 u_xlatb10;
					vec2 u_xlat11;
					int u_xlati11;
					float u_xlat12;
					vec3 u_xlat15;
					float u_xlat22;
					float u_xlat23;
					float u_xlat33;
					bool u_xlatb33;
					float u_xlat34;
					bool u_xlatb34;
					float u_xlat35;
					void main()
					{
					    u_xlat0.x = dot(vs_TEXCOORD4.xyz, vs_TEXCOORD4.xyz);
					    u_xlat0.x = inversesqrt(u_xlat0.x);
					    u_xlat0.xyz = u_xlat0.xxx * vs_TEXCOORD4.xyz;
					    u_xlat1.xyz = (-vs_TEXCOORD3.xyz) + _WorldSpaceCameraPos.xyz;
					    u_xlat33 = dot(u_xlat1.xyz, u_xlat1.xyz);
					    u_xlat33 = inversesqrt(u_xlat33);
					    u_xlat2.xyz = vec3(u_xlat33) * u_xlat1.xyz;
					    u_xlat3.xy = vs_TEXCOORD0.xy * _NormalMap_ST.xy + _NormalMap_ST.zw;
					    u_xlat3 = texture(_NormalMap, u_xlat3.xy);
					    u_xlat3.x = u_xlat3.w * u_xlat3.x;
					    u_xlat3.xy = u_xlat3.xy * vec2(2.0, 2.0) + vec2(-1.0, -1.0);
					    u_xlat34 = dot(u_xlat3.xy, u_xlat3.xy);
					    u_xlat34 = min(u_xlat34, 1.0);
					    u_xlat34 = (-u_xlat34) + 1.0;
					    u_xlat3.z = sqrt(u_xlat34);
					    u_xlat34 = (-_NormalSharpness) + 1.0;
					    u_xlat3.xyz = u_xlat3.xyz / vec3(u_xlat34);
					    u_xlat3.xyz = clamp(u_xlat3.xyz, 0.0, 1.0);
					    u_xlat4.xyz = u_xlat3.yyy * vs_TEXCOORD6.xyz;
					    u_xlat3.xyw = u_xlat3.xxx * vs_TEXCOORD5.xyz + u_xlat4.xyz;
					    u_xlat3.xyz = u_xlat3.zzz * u_xlat0.xyz + u_xlat3.xyw;
					    u_xlat34 = dot(u_xlat3.xyz, u_xlat3.xyz);
					    u_xlat34 = inversesqrt(u_xlat34);
					    u_xlat3.xyz = vec3(u_xlat34) * u_xlat3.xyz;
					    u_xlat0.x = dot(u_xlat2.xyz, u_xlat0.xyz);
					    u_xlati11 = int((0.0<u_xlat0.x) ? 0xFFFFFFFFu : uint(0));
					    u_xlati0 = int((u_xlat0.x<0.0) ? 0xFFFFFFFFu : uint(0));
					    u_xlati0 = (-u_xlati11) + u_xlati0;
					    u_xlat0.x = float(u_xlati0);
					    u_xlat0.xyz = u_xlat0.xxx * u_xlat3.xyz;
					    u_xlat34 = dot(_WorldSpaceLightPos0.xyz, _WorldSpaceLightPos0.xyz);
					    u_xlat34 = inversesqrt(u_xlat34);
					    u_xlat3.xyz = vec3(u_xlat34) * _WorldSpaceLightPos0.xyz;
					    u_xlat1.xyz = u_xlat1.xyz * vec3(u_xlat33) + u_xlat3.xyz;
					    u_xlat33 = dot(u_xlat1.xyz, u_xlat1.xyz);
					    u_xlat33 = inversesqrt(u_xlat33);
					    u_xlat1.xyz = vec3(u_xlat33) * u_xlat1.xyz;
					    u_xlat33 = dot((-u_xlat2.xyz), u_xlat0.xyz);
					    u_xlat33 = u_xlat33 + u_xlat33;
					    u_xlat4.xyz = u_xlat0.xyz * (-vec3(u_xlat33)) + (-u_xlat2.xyz);
					    u_xlatb33 = 0.0<unity_SpecCube0_ProbePosition.w;
					    if(u_xlatb33){
					        u_xlat33 = dot(u_xlat4.xyz, u_xlat4.xyz);
					        u_xlat33 = inversesqrt(u_xlat33);
					        u_xlat5.xyz = vec3(u_xlat33) * u_xlat4.xyz;
					        u_xlat6.xyz = (-vs_TEXCOORD3.xyz) + unity_SpecCube0_BoxMax.xyz;
					        u_xlat6.xyz = u_xlat6.xyz / u_xlat5.xyz;
					        u_xlat7.xyz = (-vs_TEXCOORD3.xyz) + unity_SpecCube0_BoxMin.xyz;
					        u_xlat7.xyz = u_xlat7.xyz / u_xlat5.xyz;
					        u_xlatb8.xyz = lessThan(vec4(0.0, 0.0, 0.0, 0.0), u_xlat5.xyzx).xyz;
					        {
					            vec3 hlslcc_movcTemp = u_xlat6;
					            hlslcc_movcTemp.x = (u_xlatb8.x) ? u_xlat6.x : u_xlat7.x;
					            hlslcc_movcTemp.y = (u_xlatb8.y) ? u_xlat6.y : u_xlat7.y;
					            hlslcc_movcTemp.z = (u_xlatb8.z) ? u_xlat6.z : u_xlat7.z;
					            u_xlat6 = hlslcc_movcTemp;
					        }
					        u_xlat33 = min(u_xlat6.y, u_xlat6.x);
					        u_xlat33 = min(u_xlat6.z, u_xlat33);
					        u_xlat6.xyz = vs_TEXCOORD3.xyz + (-unity_SpecCube0_ProbePosition.xyz);
					        u_xlat5.xyz = u_xlat5.xyz * vec3(u_xlat33) + u_xlat6.xyz;
					    } else {
					        u_xlat5.xyz = u_xlat4.xyz;
					    }
					    u_xlat5 = textureLod(unity_SpecCube0, u_xlat5.xyz, 6.0);
					    u_xlat33 = u_xlat5.w + -1.0;
					    u_xlat33 = unity_SpecCube0_HDR.w * u_xlat33 + 1.0;
					    u_xlat33 = u_xlat33 * unity_SpecCube0_HDR.x;
					    u_xlat6.xyz = u_xlat5.xyz * vec3(u_xlat33);
					    u_xlatb34 = unity_SpecCube0_BoxMin.w<0.999989986;
					    if(u_xlatb34){
					        u_xlatb34 = 0.0<unity_SpecCube1_ProbePosition.w;
					        if(u_xlatb34){
					            u_xlat34 = dot(u_xlat4.xyz, u_xlat4.xyz);
					            u_xlat34 = inversesqrt(u_xlat34);
					            u_xlat7.xyz = vec3(u_xlat34) * u_xlat4.xyz;
					            u_xlat8.xyz = (-vs_TEXCOORD3.xyz) + unity_SpecCube1_BoxMax.xyz;
					            u_xlat8.xyz = u_xlat8.xyz / u_xlat7.xyz;
					            u_xlat9.xyz = (-vs_TEXCOORD3.xyz) + unity_SpecCube1_BoxMin.xyz;
					            u_xlat9.xyz = u_xlat9.xyz / u_xlat7.xyz;
					            u_xlatb10.xyz = lessThan(vec4(0.0, 0.0, 0.0, 0.0), u_xlat7.xyzx).xyz;
					            {
					                vec3 hlslcc_movcTemp = u_xlat8;
					                hlslcc_movcTemp.x = (u_xlatb10.x) ? u_xlat8.x : u_xlat9.x;
					                hlslcc_movcTemp.y = (u_xlatb10.y) ? u_xlat8.y : u_xlat9.y;
					                hlslcc_movcTemp.z = (u_xlatb10.z) ? u_xlat8.z : u_xlat9.z;
					                u_xlat8 = hlslcc_movcTemp;
					            }
					            u_xlat34 = min(u_xlat8.y, u_xlat8.x);
					            u_xlat34 = min(u_xlat8.z, u_xlat34);
					            u_xlat8.xyz = vs_TEXCOORD3.xyz + (-unity_SpecCube1_ProbePosition.xyz);
					            u_xlat4.xyz = u_xlat7.xyz * vec3(u_xlat34) + u_xlat8.xyz;
					        }
					        u_xlat4 = textureLod(unity_SpecCube1, u_xlat4.xyz, 6.0);
					        u_xlat34 = u_xlat4.w + -1.0;
					        u_xlat34 = unity_SpecCube1_HDR.w * u_xlat34 + 1.0;
					        u_xlat34 = u_xlat34 * unity_SpecCube1_HDR.x;
					        u_xlat4.xyz = u_xlat4.xyz * vec3(u_xlat34);
					        u_xlat5.xyz = vec3(u_xlat33) * u_xlat5.xyz + (-u_xlat4.xyz);
					        u_xlat6.xyz = unity_SpecCube0_BoxMin.www * u_xlat5.xyz + u_xlat4.xyz;
					    }
					    u_xlat0.w = dot(u_xlat0.xyz, u_xlat3.xyz);
					    u_xlat4.xy = vs_TEXCOORD0.xy * _AmbientOcculsion_ST.xy + _AmbientOcculsion_ST.zw;
					    u_xlat4 = texture(_AmbientOcculsion, u_xlat4.xy);
					    u_xlat15.xy = vs_TEXCOORD0.xy * _Specular_ST.xy + _Specular_ST.zw;
					    u_xlat5 = texture(_Specular, u_xlat15.xy);
					    u_xlat34 = dot(u_xlat3.xyz, u_xlat1.xyz);
					    u_xlat34 = max(u_xlat34, 0.0);
					    u_xlat3.xy = vs_TEXCOORD0.xy * _MainTexture_ST.xy + _MainTexture_ST.zw;
					    u_xlat3 = texture(_MainTexture, u_xlat3.xy);
					    u_xlat3.xyz = _Color.xyz * u_xlat3.xyz + vec3(_Shadows);
					    u_xlat3.xyz = u_xlat3.xyz + vec3(-1.0, -1.0, -1.0);
					    u_xlat3.xyz = clamp(u_xlat3.xyz, 0.0, 1.0);
					    u_xlat35 = u_xlat5.x * 0.449999988;
					    u_xlat15.xyz = u_xlat3.xyz + vec3(-0.220916301, -0.220916301, -0.220916301);
					    u_xlat15.xyz = vec3(u_xlat35) * u_xlat15.xyz + vec3(0.220916301, 0.220916301, 0.220916301);
					    u_xlat35 = (-u_xlat5.x) * 0.350587666 + 0.779083729;
					    u_xlat3.xyz = vec3(u_xlat35) * u_xlat3.xyz;
					    u_xlat35 = (-u_xlat35) + 1.0;
					    u_xlat35 = clamp(u_xlat35, 0.0, 1.0);
					    u_xlat2.x = dot(u_xlat0.xyz, u_xlat2.xyz);
					    u_xlat2.x = max(u_xlat2.x, 0.0);
					    u_xlat0.x = dot(u_xlat0.xyz, u_xlat1.xyz);
					    u_xlat0.xw = max(u_xlat0.xw, vec2(0.0, 0.0));
					    u_xlat11.x = u_xlat0.w * 0.202115417 + 0.797884583;
					    u_xlat22 = u_xlat2.x * 0.202115417 + 0.797884583;
					    u_xlat11.x = u_xlat11.x * u_xlat22 + 9.99999975e-06;
					    u_xlat11.x = float(1.0) / u_xlat11.x;
					    u_xlat11.y = log2(u_xlat0.x);
					    u_xlat0.yz = u_xlat11.xy * vec2(0.25, 9.99999975e-05);
					    u_xlat22 = exp2(u_xlat0.z);
					    u_xlat22 = u_xlat22 * 0.318325758;
					    u_xlat0.xy = u_xlat0.xy * u_xlat0.xw;
					    u_xlat11.x = u_xlat22 * u_xlat0.y;
					    u_xlat11.x = u_xlat11.x * 0.616850257;
					    u_xlat0.x = u_xlat11.x * u_xlat0.x;
					    u_xlat0.xyz = u_xlat0.xxx * _LightColor0.xyz;
					    u_xlat1.x = (-u_xlat34) + 1.0;
					    u_xlat12 = u_xlat1.x * u_xlat1.x;
					    u_xlat12 = u_xlat12 * u_xlat12;
					    u_xlat1.x = u_xlat1.x * u_xlat12;
					    u_xlat7.xyz = (-u_xlat15.xyz) + vec3(1.0, 1.0, 1.0);
					    u_xlat1.xyz = u_xlat7.xyz * u_xlat1.xxx + u_xlat15.xyz;
					    u_xlat5.xyz = u_xlat5.xyz * vec3(0.0199999996, 0.0199999996, 0.0199999996) + u_xlat6.xyz;
					    u_xlat5.xyz = u_xlat4.xxx * u_xlat5.xyz;
					    u_xlat2.xy = (-u_xlat2.xx) + vec2(1.0, 1.00001001);
					    u_xlat6.xy = u_xlat2.xy * u_xlat2.xy;
					    u_xlat6.xy = u_xlat6.xy * u_xlat6.xy;
					    u_xlat2.xy = u_xlat2.xy * u_xlat6.xy;
					    u_xlat6.xyz = (-u_xlat15.xyz) + vec3(u_xlat35);
					    u_xlat2.xzw = u_xlat2.xxx * u_xlat6.xyz + u_xlat15.xyz;
					    u_xlat2.xzw = u_xlat2.xzw * u_xlat5.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz + u_xlat2.xzw;
					    u_xlat1.x = u_xlat34 + u_xlat34;
					    u_xlat1.x = u_xlat1.x * u_xlat34 + -0.5;
					    u_xlat12 = (-u_xlat0.w) + 1.00001001;
					    u_xlat23 = u_xlat12 * u_xlat12;
					    u_xlat23 = u_xlat23 * u_xlat23;
					    u_xlat12 = u_xlat23 * u_xlat12;
					    u_xlat12 = u_xlat1.x * u_xlat12 + 1.0;
					    u_xlat1.x = u_xlat1.x * u_xlat2.y + 1.0;
					    u_xlat1.x = u_xlat1.x * u_xlat12;
					    u_xlat33 = u_xlat0.w * u_xlat1.x;
					    u_xlat1.xyz = vec3(u_xlat33) * _LightColor0.xyz;
					    SV_Target0.xyz = u_xlat1.xyz * u_xlat3.xyz + u_xlat0.xyz;
					    SV_Target0.w = 1.0;
					    return;
					}"
				}
				SubProgram "d3d11 " {
					Keywords { "DIRECTIONAL" "LIGHTPROBE_SH" "DIRLIGHTMAP_SEPARATE" "LIGHTMAP_OFF" "DYNAMICLIGHTMAP_OFF" }
					"ps_4_0
					
					#version 330
					#extension GL_ARB_explicit_attrib_location : require
					#extension GL_ARB_explicit_uniform_location : require
					
					#define HLSLCC_ENABLE_UNIFORM_BUFFERS 1
					#if HLSLCC_ENABLE_UNIFORM_BUFFERS
					#define UNITY_UNIFORM
					#else
					#define UNITY_UNIFORM uniform
					#endif
					#define UNITY_SUPPORTS_UNIFORM_LOCATION 1
					#if UNITY_SUPPORTS_UNIFORM_LOCATION
					#define UNITY_LOCATION(x) layout(location = x)
					#define UNITY_BINDING(x) layout(binding = x, std140)
					#else
					#define UNITY_LOCATION(x)
					#define UNITY_BINDING(x) layout(std140)
					#endif
					layout(std140) uniform PGlobals {
						vec4 unused_0_0[2];
						vec4 _LightColor0;
						vec4 unused_0_2;
						vec4 _MainTexture_ST;
						vec4 _Specular_ST;
						vec4 _NormalMap_ST;
						vec4 _Color;
						vec4 unused_0_7;
						float _NormalSharpness;
						vec4 _AmbientOcculsion_ST;
						float _Shadows;
					};
					layout(std140) uniform UnityPerCamera {
						vec4 unused_1_0[4];
						vec3 _WorldSpaceCameraPos;
						vec4 unused_1_2[4];
					};
					layout(std140) uniform UnityLighting {
						vec4 _WorldSpaceLightPos0;
						vec4 unused_2_1[38];
						vec4 unity_SHAr;
						vec4 unity_SHAg;
						vec4 unity_SHAb;
						vec4 unused_2_5[6];
					};
					layout(std140) uniform UnityReflectionProbes {
						vec4 unity_SpecCube0_BoxMax;
						vec4 unity_SpecCube0_BoxMin;
						vec4 unity_SpecCube0_ProbePosition;
						vec4 unity_SpecCube0_HDR;
						vec4 unity_SpecCube1_BoxMax;
						vec4 unity_SpecCube1_BoxMin;
						vec4 unity_SpecCube1_ProbePosition;
						vec4 unity_SpecCube1_HDR;
					};
					layout(std140) uniform UnityProbeVolume {
						vec4 unity_ProbeVolumeParams;
						mat4x4 unity_ProbeVolumeWorldToObject;
						vec3 unity_ProbeVolumeSizeInv;
						vec3 unity_ProbeVolumeMin;
					};
					uniform  sampler2D _NormalMap;
					uniform  sampler2D _AmbientOcculsion;
					uniform  sampler2D _Specular;
					uniform  sampler2D _MainTexture;
					uniform  samplerCube unity_SpecCube0;
					uniform  samplerCube unity_SpecCube1;
					uniform  sampler3D unity_ProbeVolumeSH;
					in  vec2 vs_TEXCOORD0;
					in  vec4 vs_TEXCOORD3;
					in  vec3 vs_TEXCOORD4;
					in  vec3 vs_TEXCOORD5;
					in  vec3 vs_TEXCOORD6;
					in  vec4 vs_TEXCOORD10;
					layout(location = 0) out vec4 SV_Target0;
					vec4 u_xlat0;
					int u_xlati0;
					vec3 u_xlat1;
					vec3 u_xlat2;
					vec4 u_xlat3;
					vec4 u_xlat4;
					vec4 u_xlat5;
					vec4 u_xlat6;
					vec4 u_xlat7;
					vec4 u_xlat8;
					vec3 u_xlat9;
					bvec3 u_xlatb9;
					vec3 u_xlat10;
					bvec3 u_xlatb11;
					vec3 u_xlat12;
					int u_xlati12;
					vec2 u_xlat13;
					vec3 u_xlat16;
					float u_xlat24;
					float u_xlat25;
					vec2 u_xlat30;
					float u_xlat36;
					bool u_xlatb36;
					float u_xlat37;
					bool u_xlatb37;
					float u_xlat38;
					void main()
					{
					    u_xlat0.x = dot(vs_TEXCOORD4.xyz, vs_TEXCOORD4.xyz);
					    u_xlat0.x = inversesqrt(u_xlat0.x);
					    u_xlat0.xyz = u_xlat0.xxx * vs_TEXCOORD4.xyz;
					    u_xlat1.xyz = (-vs_TEXCOORD3.xyz) + _WorldSpaceCameraPos.xyz;
					    u_xlat36 = dot(u_xlat1.xyz, u_xlat1.xyz);
					    u_xlat36 = inversesqrt(u_xlat36);
					    u_xlat2.xyz = vec3(u_xlat36) * u_xlat1.xyz;
					    u_xlat3.xy = vs_TEXCOORD0.xy * _NormalMap_ST.xy + _NormalMap_ST.zw;
					    u_xlat3 = texture(_NormalMap, u_xlat3.xy);
					    u_xlat3.x = u_xlat3.w * u_xlat3.x;
					    u_xlat3.xy = u_xlat3.xy * vec2(2.0, 2.0) + vec2(-1.0, -1.0);
					    u_xlat37 = dot(u_xlat3.xy, u_xlat3.xy);
					    u_xlat37 = min(u_xlat37, 1.0);
					    u_xlat37 = (-u_xlat37) + 1.0;
					    u_xlat3.z = sqrt(u_xlat37);
					    u_xlat37 = (-_NormalSharpness) + 1.0;
					    u_xlat3.xyz = u_xlat3.xyz / vec3(u_xlat37);
					    u_xlat3.xyz = clamp(u_xlat3.xyz, 0.0, 1.0);
					    u_xlat4.xyz = u_xlat3.yyy * vs_TEXCOORD6.xyz;
					    u_xlat3.xyw = u_xlat3.xxx * vs_TEXCOORD5.xyz + u_xlat4.xyz;
					    u_xlat3.xyz = u_xlat3.zzz * u_xlat0.xyz + u_xlat3.xyw;
					    u_xlat37 = dot(u_xlat3.xyz, u_xlat3.xyz);
					    u_xlat37 = inversesqrt(u_xlat37);
					    u_xlat3.xyz = vec3(u_xlat37) * u_xlat3.xyz;
					    u_xlat0.x = dot(u_xlat2.xyz, u_xlat0.xyz);
					    u_xlati12 = int((0.0<u_xlat0.x) ? 0xFFFFFFFFu : uint(0));
					    u_xlati0 = int((u_xlat0.x<0.0) ? 0xFFFFFFFFu : uint(0));
					    u_xlati0 = (-u_xlati12) + u_xlati0;
					    u_xlat0.x = float(u_xlati0);
					    u_xlat3.xyz = u_xlat0.xxx * u_xlat3.xyz;
					    u_xlat0.x = dot(_WorldSpaceLightPos0.xyz, _WorldSpaceLightPos0.xyz);
					    u_xlat0.x = inversesqrt(u_xlat0.x);
					    u_xlat0.xyz = u_xlat0.xxx * _WorldSpaceLightPos0.xyz;
					    u_xlat1.xyz = u_xlat1.xyz * vec3(u_xlat36) + u_xlat0.xyz;
					    u_xlat36 = dot(u_xlat1.xyz, u_xlat1.xyz);
					    u_xlat36 = inversesqrt(u_xlat36);
					    u_xlat1.xyz = vec3(u_xlat36) * u_xlat1.xyz;
					    u_xlat36 = dot((-u_xlat2.xyz), u_xlat3.xyz);
					    u_xlat36 = u_xlat36 + u_xlat36;
					    u_xlat4.xyz = u_xlat3.xyz * (-vec3(u_xlat36)) + (-u_xlat2.xyz);
					    u_xlatb36 = unity_ProbeVolumeParams.x==1.0;
					    if(u_xlatb36){
					        u_xlatb36 = unity_ProbeVolumeParams.y==1.0;
					        u_xlat5.xyz = vs_TEXCOORD3.yyy * unity_ProbeVolumeWorldToObject[1].xyz;
					        u_xlat5.xyz = unity_ProbeVolumeWorldToObject[0].xyz * vs_TEXCOORD3.xxx + u_xlat5.xyz;
					        u_xlat5.xyz = unity_ProbeVolumeWorldToObject[2].xyz * vs_TEXCOORD3.zzz + u_xlat5.xyz;
					        u_xlat5.xyz = u_xlat5.xyz + unity_ProbeVolumeWorldToObject[3].xyz;
					        u_xlat5.xyz = (bool(u_xlatb36)) ? u_xlat5.xyz : vs_TEXCOORD3.xyz;
					        u_xlat5.xyz = u_xlat5.xyz + (-unity_ProbeVolumeMin.xyz);
					        u_xlat5.yzw = u_xlat5.xyz * unity_ProbeVolumeSizeInv.xyz;
					        u_xlat36 = u_xlat5.y * 0.25;
					        u_xlat37 = unity_ProbeVolumeParams.z * 0.5;
					        u_xlat38 = (-unity_ProbeVolumeParams.z) * 0.5 + 0.25;
					        u_xlat36 = max(u_xlat36, u_xlat37);
					        u_xlat5.x = min(u_xlat38, u_xlat36);
					        u_xlat6 = texture(unity_ProbeVolumeSH, u_xlat5.xzw);
					        u_xlat7.xyz = u_xlat5.xzw + vec3(0.25, 0.0, 0.0);
					        u_xlat7 = texture(unity_ProbeVolumeSH, u_xlat7.xyz);
					        u_xlat5.xyz = u_xlat5.xzw + vec3(0.5, 0.0, 0.0);
					        u_xlat5 = texture(unity_ProbeVolumeSH, u_xlat5.xyz);
					        u_xlat3.w = 1.0;
					        u_xlat6.x = dot(u_xlat6, u_xlat3);
					        u_xlat6.y = dot(u_xlat7, u_xlat3);
					        u_xlat6.z = dot(u_xlat5, u_xlat3);
					    } else {
					        u_xlat3.w = 1.0;
					        u_xlat6.x = dot(unity_SHAr, u_xlat3);
					        u_xlat6.y = dot(unity_SHAg, u_xlat3);
					        u_xlat6.z = dot(unity_SHAb, u_xlat3);
					    }
					    u_xlat5.xyz = u_xlat6.xyz + vs_TEXCOORD10.xyz;
					    u_xlat5.xyz = max(u_xlat5.xyz, vec3(0.0, 0.0, 0.0));
					    u_xlat5.xyz = log2(u_xlat5.xyz);
					    u_xlat5.xyz = u_xlat5.xyz * vec3(0.416666657, 0.416666657, 0.416666657);
					    u_xlat5.xyz = exp2(u_xlat5.xyz);
					    u_xlat5.xyz = u_xlat5.xyz * vec3(1.05499995, 1.05499995, 1.05499995) + vec3(-0.0549999997, -0.0549999997, -0.0549999997);
					    u_xlat5.xyz = max(u_xlat5.xyz, vec3(0.0, 0.0, 0.0));
					    u_xlatb36 = 0.0<unity_SpecCube0_ProbePosition.w;
					    if(u_xlatb36){
					        u_xlat36 = dot(u_xlat4.xyz, u_xlat4.xyz);
					        u_xlat36 = inversesqrt(u_xlat36);
					        u_xlat6.xyz = vec3(u_xlat36) * u_xlat4.xyz;
					        u_xlat7.xyz = (-vs_TEXCOORD3.xyz) + unity_SpecCube0_BoxMax.xyz;
					        u_xlat7.xyz = u_xlat7.xyz / u_xlat6.xyz;
					        u_xlat8.xyz = (-vs_TEXCOORD3.xyz) + unity_SpecCube0_BoxMin.xyz;
					        u_xlat8.xyz = u_xlat8.xyz / u_xlat6.xyz;
					        u_xlatb9.xyz = lessThan(vec4(0.0, 0.0, 0.0, 0.0), u_xlat6.xyzx).xyz;
					        {
					            vec4 hlslcc_movcTemp = u_xlat7;
					            hlslcc_movcTemp.x = (u_xlatb9.x) ? u_xlat7.x : u_xlat8.x;
					            hlslcc_movcTemp.y = (u_xlatb9.y) ? u_xlat7.y : u_xlat8.y;
					            hlslcc_movcTemp.z = (u_xlatb9.z) ? u_xlat7.z : u_xlat8.z;
					            u_xlat7 = hlslcc_movcTemp;
					        }
					        u_xlat36 = min(u_xlat7.y, u_xlat7.x);
					        u_xlat36 = min(u_xlat7.z, u_xlat36);
					        u_xlat7.xyz = vs_TEXCOORD3.xyz + (-unity_SpecCube0_ProbePosition.xyz);
					        u_xlat6.xyz = u_xlat6.xyz * vec3(u_xlat36) + u_xlat7.xyz;
					    } else {
					        u_xlat6.xyz = u_xlat4.xyz;
					    }
					    u_xlat6 = textureLod(unity_SpecCube0, u_xlat6.xyz, 6.0);
					    u_xlat36 = u_xlat6.w + -1.0;
					    u_xlat36 = unity_SpecCube0_HDR.w * u_xlat36 + 1.0;
					    u_xlat36 = u_xlat36 * unity_SpecCube0_HDR.x;
					    u_xlat7.xyz = u_xlat6.xyz * vec3(u_xlat36);
					    u_xlatb37 = unity_SpecCube0_BoxMin.w<0.999989986;
					    if(u_xlatb37){
					        u_xlatb37 = 0.0<unity_SpecCube1_ProbePosition.w;
					        if(u_xlatb37){
					            u_xlat37 = dot(u_xlat4.xyz, u_xlat4.xyz);
					            u_xlat37 = inversesqrt(u_xlat37);
					            u_xlat8.xyz = vec3(u_xlat37) * u_xlat4.xyz;
					            u_xlat9.xyz = (-vs_TEXCOORD3.xyz) + unity_SpecCube1_BoxMax.xyz;
					            u_xlat9.xyz = u_xlat9.xyz / u_xlat8.xyz;
					            u_xlat10.xyz = (-vs_TEXCOORD3.xyz) + unity_SpecCube1_BoxMin.xyz;
					            u_xlat10.xyz = u_xlat10.xyz / u_xlat8.xyz;
					            u_xlatb11.xyz = lessThan(vec4(0.0, 0.0, 0.0, 0.0), u_xlat8.xyzx).xyz;
					            {
					                vec3 hlslcc_movcTemp = u_xlat9;
					                hlslcc_movcTemp.x = (u_xlatb11.x) ? u_xlat9.x : u_xlat10.x;
					                hlslcc_movcTemp.y = (u_xlatb11.y) ? u_xlat9.y : u_xlat10.y;
					                hlslcc_movcTemp.z = (u_xlatb11.z) ? u_xlat9.z : u_xlat10.z;
					                u_xlat9 = hlslcc_movcTemp;
					            }
					            u_xlat37 = min(u_xlat9.y, u_xlat9.x);
					            u_xlat37 = min(u_xlat9.z, u_xlat37);
					            u_xlat9.xyz = vs_TEXCOORD3.xyz + (-unity_SpecCube1_ProbePosition.xyz);
					            u_xlat4.xyz = u_xlat8.xyz * vec3(u_xlat37) + u_xlat9.xyz;
					        }
					        u_xlat4 = textureLod(unity_SpecCube1, u_xlat4.xyz, 6.0);
					        u_xlat37 = u_xlat4.w + -1.0;
					        u_xlat37 = unity_SpecCube1_HDR.w * u_xlat37 + 1.0;
					        u_xlat37 = u_xlat37 * unity_SpecCube1_HDR.x;
					        u_xlat4.xyz = u_xlat4.xyz * vec3(u_xlat37);
					        u_xlat6.xyz = vec3(u_xlat36) * u_xlat6.xyz + (-u_xlat4.xyz);
					        u_xlat7.xyz = unity_SpecCube0_BoxMin.www * u_xlat6.xyz + u_xlat4.xyz;
					    }
					    u_xlat0.w = dot(u_xlat3.xyz, u_xlat0.xyz);
					    u_xlat4.xy = vs_TEXCOORD0.xy * _AmbientOcculsion_ST.xy + _AmbientOcculsion_ST.zw;
					    u_xlat4 = texture(_AmbientOcculsion, u_xlat4.xy);
					    u_xlat16.xy = vs_TEXCOORD0.xy * _Specular_ST.xy + _Specular_ST.zw;
					    u_xlat6 = texture(_Specular, u_xlat16.xy);
					    u_xlat0.x = dot(u_xlat0.xyz, u_xlat1.xyz);
					    u_xlat12.xy = vs_TEXCOORD0.xy * _MainTexture_ST.xy + _MainTexture_ST.zw;
					    u_xlat8 = texture(_MainTexture, u_xlat12.xy);
					    u_xlat16.xyz = _Color.xyz * u_xlat8.xyz + vec3(_Shadows);
					    u_xlat16.xyz = u_xlat16.xyz + vec3(-1.0, -1.0, -1.0);
					    u_xlat16.xyz = clamp(u_xlat16.xyz, 0.0, 1.0);
					    u_xlat12.x = u_xlat6.x * 0.449999988;
					    u_xlat8.xyz = u_xlat16.xyz + vec3(-0.220916301, -0.220916301, -0.220916301);
					    u_xlat8.xyz = u_xlat12.xxx * u_xlat8.xyz + vec3(0.220916301, 0.220916301, 0.220916301);
					    u_xlat12.x = (-u_xlat6.x) * 0.350587666 + 0.779083729;
					    u_xlat16.xyz = u_xlat12.xxx * u_xlat16.xyz;
					    u_xlat12.x = (-u_xlat12.x) + 1.0;
					    u_xlat12.x = clamp(u_xlat12.x, 0.0, 1.0);
					    u_xlat0.z = dot(u_xlat3.xyz, u_xlat2.xyz);
					    u_xlat0.xzw = max(u_xlat0.xzw, vec3(0.0, 0.0, 0.0));
					    u_xlat1.x = dot(u_xlat3.xyz, u_xlat1.xyz);
					    u_xlat1.x = max(u_xlat1.x, 0.0);
					    u_xlat13.x = u_xlat0.w * 0.202115417 + 0.797884583;
					    u_xlat25 = u_xlat0.z * 0.202115417 + 0.797884583;
					    u_xlat13.x = u_xlat13.x * u_xlat25 + 9.99999975e-06;
					    u_xlat13.x = float(1.0) / u_xlat13.x;
					    u_xlat13.y = log2(u_xlat1.x);
					    u_xlat13.xy = u_xlat13.xy * vec2(0.25, 9.99999975e-05);
					    u_xlat25 = exp2(u_xlat13.y);
					    u_xlat1.z = u_xlat25 * 0.318325758;
					    u_xlat1.y = u_xlat0.w * u_xlat13.x;
					    u_xlat1.xy = u_xlat1.xz * u_xlat1.xy;
					    u_xlat13.x = u_xlat1.y * 0.616850257;
					    u_xlat1.x = u_xlat13.x * u_xlat1.x;
					    u_xlat1.xyz = u_xlat1.xxx * _LightColor0.xyz;
					    u_xlat37 = (-u_xlat0.x) + 1.0;
					    u_xlat2.x = u_xlat37 * u_xlat37;
					    u_xlat2.x = u_xlat2.x * u_xlat2.x;
					    u_xlat37 = u_xlat37 * u_xlat2.x;
					    u_xlat2.xyz = (-u_xlat8.xyz) + vec3(1.0, 1.0, 1.0);
					    u_xlat2.xyz = u_xlat2.xyz * vec3(u_xlat37) + u_xlat8.xyz;
					    u_xlat3.xyz = u_xlat6.xyz * vec3(0.0199999996, 0.0199999996, 0.0199999996) + u_xlat7.xyz;
					    u_xlat3.xyz = u_xlat4.xxx * u_xlat3.xyz;
					    u_xlat6.xy = (-u_xlat0.zz) + vec2(1.0, 1.00001001);
					    u_xlat30.xy = u_xlat6.xy * u_xlat6.xy;
					    u_xlat30.xy = u_xlat30.xy * u_xlat30.xy;
					    u_xlat6.xy = u_xlat6.xy * u_xlat30.xy;
					    u_xlat7.xyz = (-u_xlat8.xyz) + u_xlat12.xxx;
					    u_xlat6.xzw = u_xlat6.xxx * u_xlat7.xyz + u_xlat8.xyz;
					    u_xlat3.xyz = u_xlat3.xyz * u_xlat6.xzw;
					    u_xlat1.xyz = u_xlat1.xyz * u_xlat2.xyz + u_xlat3.xyz;
					    u_xlat12.x = u_xlat0.x + u_xlat0.x;
					    u_xlat0.x = u_xlat12.x * u_xlat0.x + -0.5;
					    u_xlat12.x = (-u_xlat0.w) + 1.00001001;
					    u_xlat24 = u_xlat12.x * u_xlat12.x;
					    u_xlat24 = u_xlat24 * u_xlat24;
					    u_xlat12.x = u_xlat24 * u_xlat12.x;
					    u_xlat12.x = u_xlat0.x * u_xlat12.x + 1.0;
					    u_xlat0.x = u_xlat0.x * u_xlat6.y + 1.0;
					    u_xlat0.x = u_xlat0.x * u_xlat12.x;
					    u_xlat0.x = u_xlat0.w * u_xlat0.x;
					    u_xlat12.xyz = u_xlat4.xxx * u_xlat5.xyz;
					    u_xlat0.xyz = u_xlat0.xxx * _LightColor0.xyz + u_xlat12.xyz;
					    SV_Target0.xyz = u_xlat0.xyz * u_xlat16.xyz + u_xlat1.xyz;
					    SV_Target0.w = 1.0;
					    return;
					}"
				}
				SubProgram "d3d11 " {
					Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "DIRLIGHTMAP_SEPARATE" "LIGHTMAP_OFF" "DYNAMICLIGHTMAP_OFF" }
					"ps_4_0
					
					#version 330
					#extension GL_ARB_explicit_attrib_location : require
					#extension GL_ARB_explicit_uniform_location : require
					
					#define HLSLCC_ENABLE_UNIFORM_BUFFERS 1
					#if HLSLCC_ENABLE_UNIFORM_BUFFERS
					#define UNITY_UNIFORM
					#else
					#define UNITY_UNIFORM uniform
					#endif
					#define UNITY_SUPPORTS_UNIFORM_LOCATION 1
					#if UNITY_SUPPORTS_UNIFORM_LOCATION
					#define UNITY_LOCATION(x) layout(location = x)
					#define UNITY_BINDING(x) layout(binding = x, std140)
					#else
					#define UNITY_LOCATION(x)
					#define UNITY_BINDING(x) layout(std140)
					#endif
					layout(std140) uniform PGlobals {
						vec4 unused_0_0[2];
						vec4 _LightColor0;
						vec4 unused_0_2;
						vec4 _MainTexture_ST;
						vec4 _Specular_ST;
						vec4 _NormalMap_ST;
						vec4 _Color;
						vec4 unused_0_7;
						float _NormalSharpness;
						vec4 _AmbientOcculsion_ST;
						float _Shadows;
					};
					layout(std140) uniform UnityPerCamera {
						vec4 unused_1_0[4];
						vec3 _WorldSpaceCameraPos;
						vec4 unused_1_2[4];
					};
					layout(std140) uniform UnityLighting {
						vec4 _WorldSpaceLightPos0;
						vec4 unused_2_1[47];
					};
					layout(std140) uniform UnityReflectionProbes {
						vec4 unity_SpecCube0_BoxMax;
						vec4 unity_SpecCube0_BoxMin;
						vec4 unity_SpecCube0_ProbePosition;
						vec4 unity_SpecCube0_HDR;
						vec4 unity_SpecCube1_BoxMax;
						vec4 unity_SpecCube1_BoxMin;
						vec4 unity_SpecCube1_ProbePosition;
						vec4 unity_SpecCube1_HDR;
					};
					uniform  sampler2D _NormalMap;
					uniform  sampler2D _ShadowMapTexture;
					uniform  sampler2D _AmbientOcculsion;
					uniform  sampler2D _Specular;
					uniform  sampler2D _MainTexture;
					uniform  samplerCube unity_SpecCube0;
					uniform  samplerCube unity_SpecCube1;
					in  vec2 vs_TEXCOORD0;
					in  vec4 vs_TEXCOORD3;
					in  vec3 vs_TEXCOORD4;
					in  vec3 vs_TEXCOORD5;
					in  vec3 vs_TEXCOORD6;
					in  vec4 vs_TEXCOORD8;
					layout(location = 0) out vec4 SV_Target0;
					vec4 u_xlat0;
					int u_xlati0;
					vec3 u_xlat1;
					vec4 u_xlat2;
					vec4 u_xlat3;
					vec4 u_xlat4;
					vec4 u_xlat5;
					vec4 u_xlat6;
					vec3 u_xlat7;
					vec3 u_xlat8;
					vec3 u_xlat9;
					bvec3 u_xlatb9;
					vec3 u_xlat10;
					bvec3 u_xlatb11;
					vec2 u_xlat12;
					int u_xlati12;
					float u_xlat13;
					vec3 u_xlat17;
					float u_xlat24;
					float u_xlat25;
					float u_xlat36;
					bool u_xlatb36;
					float u_xlat37;
					bool u_xlatb37;
					float u_xlat38;
					void main()
					{
					    u_xlat0.x = dot(vs_TEXCOORD4.xyz, vs_TEXCOORD4.xyz);
					    u_xlat0.x = inversesqrt(u_xlat0.x);
					    u_xlat0.xyz = u_xlat0.xxx * vs_TEXCOORD4.xyz;
					    u_xlat1.xyz = (-vs_TEXCOORD3.xyz) + _WorldSpaceCameraPos.xyz;
					    u_xlat36 = dot(u_xlat1.xyz, u_xlat1.xyz);
					    u_xlat36 = inversesqrt(u_xlat36);
					    u_xlat2.xyz = vec3(u_xlat36) * u_xlat1.xyz;
					    u_xlat3.xy = vs_TEXCOORD0.xy * _NormalMap_ST.xy + _NormalMap_ST.zw;
					    u_xlat3 = texture(_NormalMap, u_xlat3.xy);
					    u_xlat3.x = u_xlat3.w * u_xlat3.x;
					    u_xlat3.xy = u_xlat3.xy * vec2(2.0, 2.0) + vec2(-1.0, -1.0);
					    u_xlat37 = dot(u_xlat3.xy, u_xlat3.xy);
					    u_xlat37 = min(u_xlat37, 1.0);
					    u_xlat37 = (-u_xlat37) + 1.0;
					    u_xlat3.z = sqrt(u_xlat37);
					    u_xlat37 = (-_NormalSharpness) + 1.0;
					    u_xlat3.xyz = u_xlat3.xyz / vec3(u_xlat37);
					    u_xlat3.xyz = clamp(u_xlat3.xyz, 0.0, 1.0);
					    u_xlat4.xyz = u_xlat3.yyy * vs_TEXCOORD6.xyz;
					    u_xlat3.xyw = u_xlat3.xxx * vs_TEXCOORD5.xyz + u_xlat4.xyz;
					    u_xlat3.xyz = u_xlat3.zzz * u_xlat0.xyz + u_xlat3.xyw;
					    u_xlat37 = dot(u_xlat3.xyz, u_xlat3.xyz);
					    u_xlat37 = inversesqrt(u_xlat37);
					    u_xlat3.xyz = vec3(u_xlat37) * u_xlat3.xyz;
					    u_xlat0.x = dot(u_xlat2.xyz, u_xlat0.xyz);
					    u_xlati12 = int((0.0<u_xlat0.x) ? 0xFFFFFFFFu : uint(0));
					    u_xlati0 = int((u_xlat0.x<0.0) ? 0xFFFFFFFFu : uint(0));
					    u_xlati0 = (-u_xlati12) + u_xlati0;
					    u_xlat0.x = float(u_xlati0);
					    u_xlat0.xyz = u_xlat0.xxx * u_xlat3.xyz;
					    u_xlat37 = dot(_WorldSpaceLightPos0.xyz, _WorldSpaceLightPos0.xyz);
					    u_xlat37 = inversesqrt(u_xlat37);
					    u_xlat3.xyz = vec3(u_xlat37) * _WorldSpaceLightPos0.xyz;
					    u_xlat1.xyz = u_xlat1.xyz * vec3(u_xlat36) + u_xlat3.xyz;
					    u_xlat36 = dot(u_xlat1.xyz, u_xlat1.xyz);
					    u_xlat36 = inversesqrt(u_xlat36);
					    u_xlat1.xyz = vec3(u_xlat36) * u_xlat1.xyz;
					    u_xlat4.xy = vs_TEXCOORD8.xy / vs_TEXCOORD8.ww;
					    u_xlat4 = texture(_ShadowMapTexture, u_xlat4.xy);
					    u_xlat4.xyz = u_xlat4.xxx * _LightColor0.xyz;
					    u_xlat36 = dot((-u_xlat2.xyz), u_xlat0.xyz);
					    u_xlat36 = u_xlat36 + u_xlat36;
					    u_xlat5.xyz = u_xlat0.xyz * (-vec3(u_xlat36)) + (-u_xlat2.xyz);
					    u_xlatb36 = 0.0<unity_SpecCube0_ProbePosition.w;
					    if(u_xlatb36){
					        u_xlat36 = dot(u_xlat5.xyz, u_xlat5.xyz);
					        u_xlat36 = inversesqrt(u_xlat36);
					        u_xlat6.xyz = vec3(u_xlat36) * u_xlat5.xyz;
					        u_xlat7.xyz = (-vs_TEXCOORD3.xyz) + unity_SpecCube0_BoxMax.xyz;
					        u_xlat7.xyz = u_xlat7.xyz / u_xlat6.xyz;
					        u_xlat8.xyz = (-vs_TEXCOORD3.xyz) + unity_SpecCube0_BoxMin.xyz;
					        u_xlat8.xyz = u_xlat8.xyz / u_xlat6.xyz;
					        u_xlatb9.xyz = lessThan(vec4(0.0, 0.0, 0.0, 0.0), u_xlat6.xyzx).xyz;
					        {
					            vec3 hlslcc_movcTemp = u_xlat7;
					            hlslcc_movcTemp.x = (u_xlatb9.x) ? u_xlat7.x : u_xlat8.x;
					            hlslcc_movcTemp.y = (u_xlatb9.y) ? u_xlat7.y : u_xlat8.y;
					            hlslcc_movcTemp.z = (u_xlatb9.z) ? u_xlat7.z : u_xlat8.z;
					            u_xlat7 = hlslcc_movcTemp;
					        }
					        u_xlat36 = min(u_xlat7.y, u_xlat7.x);
					        u_xlat36 = min(u_xlat7.z, u_xlat36);
					        u_xlat7.xyz = vs_TEXCOORD3.xyz + (-unity_SpecCube0_ProbePosition.xyz);
					        u_xlat6.xyz = u_xlat6.xyz * vec3(u_xlat36) + u_xlat7.xyz;
					    } else {
					        u_xlat6.xyz = u_xlat5.xyz;
					    }
					    u_xlat6 = textureLod(unity_SpecCube0, u_xlat6.xyz, 6.0);
					    u_xlat36 = u_xlat6.w + -1.0;
					    u_xlat36 = unity_SpecCube0_HDR.w * u_xlat36 + 1.0;
					    u_xlat36 = u_xlat36 * unity_SpecCube0_HDR.x;
					    u_xlat7.xyz = u_xlat6.xyz * vec3(u_xlat36);
					    u_xlatb37 = unity_SpecCube0_BoxMin.w<0.999989986;
					    if(u_xlatb37){
					        u_xlatb37 = 0.0<unity_SpecCube1_ProbePosition.w;
					        if(u_xlatb37){
					            u_xlat37 = dot(u_xlat5.xyz, u_xlat5.xyz);
					            u_xlat37 = inversesqrt(u_xlat37);
					            u_xlat8.xyz = vec3(u_xlat37) * u_xlat5.xyz;
					            u_xlat9.xyz = (-vs_TEXCOORD3.xyz) + unity_SpecCube1_BoxMax.xyz;
					            u_xlat9.xyz = u_xlat9.xyz / u_xlat8.xyz;
					            u_xlat10.xyz = (-vs_TEXCOORD3.xyz) + unity_SpecCube1_BoxMin.xyz;
					            u_xlat10.xyz = u_xlat10.xyz / u_xlat8.xyz;
					            u_xlatb11.xyz = lessThan(vec4(0.0, 0.0, 0.0, 0.0), u_xlat8.xyzx).xyz;
					            {
					                vec3 hlslcc_movcTemp = u_xlat9;
					                hlslcc_movcTemp.x = (u_xlatb11.x) ? u_xlat9.x : u_xlat10.x;
					                hlslcc_movcTemp.y = (u_xlatb11.y) ? u_xlat9.y : u_xlat10.y;
					                hlslcc_movcTemp.z = (u_xlatb11.z) ? u_xlat9.z : u_xlat10.z;
					                u_xlat9 = hlslcc_movcTemp;
					            }
					            u_xlat37 = min(u_xlat9.y, u_xlat9.x);
					            u_xlat37 = min(u_xlat9.z, u_xlat37);
					            u_xlat9.xyz = vs_TEXCOORD3.xyz + (-unity_SpecCube1_ProbePosition.xyz);
					            u_xlat5.xyz = u_xlat8.xyz * vec3(u_xlat37) + u_xlat9.xyz;
					        }
					        u_xlat5 = textureLod(unity_SpecCube1, u_xlat5.xyz, 6.0);
					        u_xlat37 = u_xlat5.w + -1.0;
					        u_xlat37 = unity_SpecCube1_HDR.w * u_xlat37 + 1.0;
					        u_xlat37 = u_xlat37 * unity_SpecCube1_HDR.x;
					        u_xlat5.xyz = u_xlat5.xyz * vec3(u_xlat37);
					        u_xlat6.xyz = vec3(u_xlat36) * u_xlat6.xyz + (-u_xlat5.xyz);
					        u_xlat7.xyz = unity_SpecCube0_BoxMin.www * u_xlat6.xyz + u_xlat5.xyz;
					    }
					    u_xlat0.w = dot(u_xlat0.xyz, u_xlat3.xyz);
					    u_xlat5.xy = vs_TEXCOORD0.xy * _AmbientOcculsion_ST.xy + _AmbientOcculsion_ST.zw;
					    u_xlat5 = texture(_AmbientOcculsion, u_xlat5.xy);
					    u_xlat17.xy = vs_TEXCOORD0.xy * _Specular_ST.xy + _Specular_ST.zw;
					    u_xlat6 = texture(_Specular, u_xlat17.xy);
					    u_xlat37 = dot(u_xlat3.xyz, u_xlat1.xyz);
					    u_xlat37 = max(u_xlat37, 0.0);
					    u_xlat3.xy = vs_TEXCOORD0.xy * _MainTexture_ST.xy + _MainTexture_ST.zw;
					    u_xlat3 = texture(_MainTexture, u_xlat3.xy);
					    u_xlat3.xyz = _Color.xyz * u_xlat3.xyz + vec3(_Shadows);
					    u_xlat3.xyz = u_xlat3.xyz + vec3(-1.0, -1.0, -1.0);
					    u_xlat3.xyz = clamp(u_xlat3.xyz, 0.0, 1.0);
					    u_xlat38 = u_xlat6.x * 0.449999988;
					    u_xlat17.xyz = u_xlat3.xyz + vec3(-0.220916301, -0.220916301, -0.220916301);
					    u_xlat17.xyz = vec3(u_xlat38) * u_xlat17.xyz + vec3(0.220916301, 0.220916301, 0.220916301);
					    u_xlat38 = (-u_xlat6.x) * 0.350587666 + 0.779083729;
					    u_xlat3.xyz = vec3(u_xlat38) * u_xlat3.xyz;
					    u_xlat38 = (-u_xlat38) + 1.0;
					    u_xlat38 = clamp(u_xlat38, 0.0, 1.0);
					    u_xlat2.x = dot(u_xlat0.xyz, u_xlat2.xyz);
					    u_xlat2.x = max(u_xlat2.x, 0.0);
					    u_xlat0.x = dot(u_xlat0.xyz, u_xlat1.xyz);
					    u_xlat0.xw = max(u_xlat0.xw, vec2(0.0, 0.0));
					    u_xlat12.x = u_xlat0.w * 0.202115417 + 0.797884583;
					    u_xlat24 = u_xlat2.x * 0.202115417 + 0.797884583;
					    u_xlat12.x = u_xlat12.x * u_xlat24 + 9.99999975e-06;
					    u_xlat12.x = float(1.0) / u_xlat12.x;
					    u_xlat12.y = log2(u_xlat0.x);
					    u_xlat0.yz = u_xlat12.xy * vec2(0.25, 9.99999975e-05);
					    u_xlat24 = exp2(u_xlat0.z);
					    u_xlat24 = u_xlat24 * 0.318325758;
					    u_xlat0.xy = u_xlat0.xy * u_xlat0.xw;
					    u_xlat12.x = u_xlat24 * u_xlat0.y;
					    u_xlat12.x = u_xlat12.x * 0.616850257;
					    u_xlat0.x = u_xlat12.x * u_xlat0.x;
					    u_xlat0.xyz = u_xlat4.xyz * u_xlat0.xxx;
					    u_xlat1.x = (-u_xlat37) + 1.0;
					    u_xlat13 = u_xlat1.x * u_xlat1.x;
					    u_xlat13 = u_xlat13 * u_xlat13;
					    u_xlat1.x = u_xlat1.x * u_xlat13;
					    u_xlat8.xyz = (-u_xlat17.xyz) + vec3(1.0, 1.0, 1.0);
					    u_xlat1.xyz = u_xlat8.xyz * u_xlat1.xxx + u_xlat17.xyz;
					    u_xlat6.xyz = u_xlat6.xyz * vec3(0.0199999996, 0.0199999996, 0.0199999996) + u_xlat7.xyz;
					    u_xlat6.xyz = u_xlat5.xxx * u_xlat6.xyz;
					    u_xlat2.xy = (-u_xlat2.xx) + vec2(1.0, 1.00001001);
					    u_xlat7.xy = u_xlat2.xy * u_xlat2.xy;
					    u_xlat7.xy = u_xlat7.xy * u_xlat7.xy;
					    u_xlat2.xy = u_xlat2.xy * u_xlat7.xy;
					    u_xlat7.xyz = (-u_xlat17.xyz) + vec3(u_xlat38);
					    u_xlat2.xzw = u_xlat2.xxx * u_xlat7.xyz + u_xlat17.xyz;
					    u_xlat2.xzw = u_xlat2.xzw * u_xlat6.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz + u_xlat2.xzw;
					    u_xlat1.x = u_xlat37 + u_xlat37;
					    u_xlat1.x = u_xlat1.x * u_xlat37 + -0.5;
					    u_xlat13 = (-u_xlat0.w) + 1.00001001;
					    u_xlat25 = u_xlat13 * u_xlat13;
					    u_xlat25 = u_xlat25 * u_xlat25;
					    u_xlat13 = u_xlat25 * u_xlat13;
					    u_xlat13 = u_xlat1.x * u_xlat13 + 1.0;
					    u_xlat1.x = u_xlat1.x * u_xlat2.y + 1.0;
					    u_xlat1.x = u_xlat1.x * u_xlat13;
					    u_xlat36 = u_xlat0.w * u_xlat1.x;
					    u_xlat1.xyz = u_xlat4.xyz * vec3(u_xlat36);
					    SV_Target0.xyz = u_xlat1.xyz * u_xlat3.xyz + u_xlat0.xyz;
					    SV_Target0.w = 1.0;
					    return;
					}"
				}
				SubProgram "d3d11 " {
					Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "LIGHTPROBE_SH" "DIRLIGHTMAP_SEPARATE" "LIGHTMAP_OFF" "DYNAMICLIGHTMAP_OFF" }
					"ps_4_0
					
					#version 330
					#extension GL_ARB_explicit_attrib_location : require
					#extension GL_ARB_explicit_uniform_location : require
					
					#define HLSLCC_ENABLE_UNIFORM_BUFFERS 1
					#if HLSLCC_ENABLE_UNIFORM_BUFFERS
					#define UNITY_UNIFORM
					#else
					#define UNITY_UNIFORM uniform
					#endif
					#define UNITY_SUPPORTS_UNIFORM_LOCATION 1
					#if UNITY_SUPPORTS_UNIFORM_LOCATION
					#define UNITY_LOCATION(x) layout(location = x)
					#define UNITY_BINDING(x) layout(binding = x, std140)
					#else
					#define UNITY_LOCATION(x)
					#define UNITY_BINDING(x) layout(std140)
					#endif
					layout(std140) uniform PGlobals {
						vec4 unused_0_0[2];
						vec4 _LightColor0;
						vec4 unused_0_2;
						vec4 _MainTexture_ST;
						vec4 _Specular_ST;
						vec4 _NormalMap_ST;
						vec4 _Color;
						vec4 unused_0_7;
						float _NormalSharpness;
						vec4 _AmbientOcculsion_ST;
						float _Shadows;
					};
					layout(std140) uniform UnityPerCamera {
						vec4 unused_1_0[4];
						vec3 _WorldSpaceCameraPos;
						vec4 unused_1_2[4];
					};
					layout(std140) uniform UnityLighting {
						vec4 _WorldSpaceLightPos0;
						vec4 unused_2_1[38];
						vec4 unity_SHAr;
						vec4 unity_SHAg;
						vec4 unity_SHAb;
						vec4 unused_2_5[6];
					};
					layout(std140) uniform UnityReflectionProbes {
						vec4 unity_SpecCube0_BoxMax;
						vec4 unity_SpecCube0_BoxMin;
						vec4 unity_SpecCube0_ProbePosition;
						vec4 unity_SpecCube0_HDR;
						vec4 unity_SpecCube1_BoxMax;
						vec4 unity_SpecCube1_BoxMin;
						vec4 unity_SpecCube1_ProbePosition;
						vec4 unity_SpecCube1_HDR;
					};
					layout(std140) uniform UnityProbeVolume {
						vec4 unity_ProbeVolumeParams;
						mat4x4 unity_ProbeVolumeWorldToObject;
						vec3 unity_ProbeVolumeSizeInv;
						vec3 unity_ProbeVolumeMin;
					};
					uniform  sampler2D _NormalMap;
					uniform  sampler2D _ShadowMapTexture;
					uniform  sampler2D _AmbientOcculsion;
					uniform  sampler2D _Specular;
					uniform  sampler2D _MainTexture;
					uniform  samplerCube unity_SpecCube0;
					uniform  samplerCube unity_SpecCube1;
					uniform  sampler3D unity_ProbeVolumeSH;
					in  vec2 vs_TEXCOORD0;
					in  vec4 vs_TEXCOORD3;
					in  vec3 vs_TEXCOORD4;
					in  vec3 vs_TEXCOORD5;
					in  vec3 vs_TEXCOORD6;
					in  vec4 vs_TEXCOORD8;
					in  vec4 vs_TEXCOORD10;
					layout(location = 0) out vec4 SV_Target0;
					vec4 u_xlat0;
					int u_xlati0;
					vec3 u_xlat1;
					vec3 u_xlat2;
					vec4 u_xlat3;
					vec4 u_xlat4;
					vec4 u_xlat5;
					vec4 u_xlat6;
					vec4 u_xlat7;
					vec4 u_xlat8;
					vec4 u_xlat9;
					vec3 u_xlat10;
					bvec3 u_xlatb10;
					vec3 u_xlat11;
					bvec3 u_xlatb12;
					vec3 u_xlat13;
					int u_xlati13;
					vec2 u_xlat14;
					vec3 u_xlat18;
					float u_xlat26;
					float u_xlat27;
					vec2 u_xlat33;
					float u_xlat39;
					bool u_xlatb39;
					float u_xlat40;
					bool u_xlatb40;
					float u_xlat41;
					void main()
					{
					    u_xlat0.x = dot(vs_TEXCOORD4.xyz, vs_TEXCOORD4.xyz);
					    u_xlat0.x = inversesqrt(u_xlat0.x);
					    u_xlat0.xyz = u_xlat0.xxx * vs_TEXCOORD4.xyz;
					    u_xlat1.xyz = (-vs_TEXCOORD3.xyz) + _WorldSpaceCameraPos.xyz;
					    u_xlat39 = dot(u_xlat1.xyz, u_xlat1.xyz);
					    u_xlat39 = inversesqrt(u_xlat39);
					    u_xlat2.xyz = vec3(u_xlat39) * u_xlat1.xyz;
					    u_xlat3.xy = vs_TEXCOORD0.xy * _NormalMap_ST.xy + _NormalMap_ST.zw;
					    u_xlat3 = texture(_NormalMap, u_xlat3.xy);
					    u_xlat3.x = u_xlat3.w * u_xlat3.x;
					    u_xlat3.xy = u_xlat3.xy * vec2(2.0, 2.0) + vec2(-1.0, -1.0);
					    u_xlat40 = dot(u_xlat3.xy, u_xlat3.xy);
					    u_xlat40 = min(u_xlat40, 1.0);
					    u_xlat40 = (-u_xlat40) + 1.0;
					    u_xlat3.z = sqrt(u_xlat40);
					    u_xlat40 = (-_NormalSharpness) + 1.0;
					    u_xlat3.xyz = u_xlat3.xyz / vec3(u_xlat40);
					    u_xlat3.xyz = clamp(u_xlat3.xyz, 0.0, 1.0);
					    u_xlat4.xyz = u_xlat3.yyy * vs_TEXCOORD6.xyz;
					    u_xlat3.xyw = u_xlat3.xxx * vs_TEXCOORD5.xyz + u_xlat4.xyz;
					    u_xlat3.xyz = u_xlat3.zzz * u_xlat0.xyz + u_xlat3.xyw;
					    u_xlat40 = dot(u_xlat3.xyz, u_xlat3.xyz);
					    u_xlat40 = inversesqrt(u_xlat40);
					    u_xlat3.xyz = vec3(u_xlat40) * u_xlat3.xyz;
					    u_xlat0.x = dot(u_xlat2.xyz, u_xlat0.xyz);
					    u_xlati13 = int((0.0<u_xlat0.x) ? 0xFFFFFFFFu : uint(0));
					    u_xlati0 = int((u_xlat0.x<0.0) ? 0xFFFFFFFFu : uint(0));
					    u_xlati0 = (-u_xlati13) + u_xlati0;
					    u_xlat0.x = float(u_xlati0);
					    u_xlat3.xyz = u_xlat0.xxx * u_xlat3.xyz;
					    u_xlat0.x = dot(_WorldSpaceLightPos0.xyz, _WorldSpaceLightPos0.xyz);
					    u_xlat0.x = inversesqrt(u_xlat0.x);
					    u_xlat0.xyz = u_xlat0.xxx * _WorldSpaceLightPos0.xyz;
					    u_xlat1.xyz = u_xlat1.xyz * vec3(u_xlat39) + u_xlat0.xyz;
					    u_xlat39 = dot(u_xlat1.xyz, u_xlat1.xyz);
					    u_xlat39 = inversesqrt(u_xlat39);
					    u_xlat1.xyz = vec3(u_xlat39) * u_xlat1.xyz;
					    u_xlat4.xy = vs_TEXCOORD8.xy / vs_TEXCOORD8.ww;
					    u_xlat4 = texture(_ShadowMapTexture, u_xlat4.xy);
					    u_xlat4.xyz = u_xlat4.xxx * _LightColor0.xyz;
					    u_xlat39 = dot((-u_xlat2.xyz), u_xlat3.xyz);
					    u_xlat39 = u_xlat39 + u_xlat39;
					    u_xlat5.xyz = u_xlat3.xyz * (-vec3(u_xlat39)) + (-u_xlat2.xyz);
					    u_xlatb39 = unity_ProbeVolumeParams.x==1.0;
					    if(u_xlatb39){
					        u_xlatb39 = unity_ProbeVolumeParams.y==1.0;
					        u_xlat6.xyz = vs_TEXCOORD3.yyy * unity_ProbeVolumeWorldToObject[1].xyz;
					        u_xlat6.xyz = unity_ProbeVolumeWorldToObject[0].xyz * vs_TEXCOORD3.xxx + u_xlat6.xyz;
					        u_xlat6.xyz = unity_ProbeVolumeWorldToObject[2].xyz * vs_TEXCOORD3.zzz + u_xlat6.xyz;
					        u_xlat6.xyz = u_xlat6.xyz + unity_ProbeVolumeWorldToObject[3].xyz;
					        u_xlat6.xyz = (bool(u_xlatb39)) ? u_xlat6.xyz : vs_TEXCOORD3.xyz;
					        u_xlat6.xyz = u_xlat6.xyz + (-unity_ProbeVolumeMin.xyz);
					        u_xlat6.yzw = u_xlat6.xyz * unity_ProbeVolumeSizeInv.xyz;
					        u_xlat39 = u_xlat6.y * 0.25;
					        u_xlat40 = unity_ProbeVolumeParams.z * 0.5;
					        u_xlat41 = (-unity_ProbeVolumeParams.z) * 0.5 + 0.25;
					        u_xlat39 = max(u_xlat39, u_xlat40);
					        u_xlat6.x = min(u_xlat41, u_xlat39);
					        u_xlat7 = texture(unity_ProbeVolumeSH, u_xlat6.xzw);
					        u_xlat8.xyz = u_xlat6.xzw + vec3(0.25, 0.0, 0.0);
					        u_xlat8 = texture(unity_ProbeVolumeSH, u_xlat8.xyz);
					        u_xlat6.xyz = u_xlat6.xzw + vec3(0.5, 0.0, 0.0);
					        u_xlat6 = texture(unity_ProbeVolumeSH, u_xlat6.xyz);
					        u_xlat3.w = 1.0;
					        u_xlat7.x = dot(u_xlat7, u_xlat3);
					        u_xlat7.y = dot(u_xlat8, u_xlat3);
					        u_xlat7.z = dot(u_xlat6, u_xlat3);
					    } else {
					        u_xlat3.w = 1.0;
					        u_xlat7.x = dot(unity_SHAr, u_xlat3);
					        u_xlat7.y = dot(unity_SHAg, u_xlat3);
					        u_xlat7.z = dot(unity_SHAb, u_xlat3);
					    }
					    u_xlat6.xyz = u_xlat7.xyz + vs_TEXCOORD10.xyz;
					    u_xlat6.xyz = max(u_xlat6.xyz, vec3(0.0, 0.0, 0.0));
					    u_xlat6.xyz = log2(u_xlat6.xyz);
					    u_xlat6.xyz = u_xlat6.xyz * vec3(0.416666657, 0.416666657, 0.416666657);
					    u_xlat6.xyz = exp2(u_xlat6.xyz);
					    u_xlat6.xyz = u_xlat6.xyz * vec3(1.05499995, 1.05499995, 1.05499995) + vec3(-0.0549999997, -0.0549999997, -0.0549999997);
					    u_xlat6.xyz = max(u_xlat6.xyz, vec3(0.0, 0.0, 0.0));
					    u_xlatb39 = 0.0<unity_SpecCube0_ProbePosition.w;
					    if(u_xlatb39){
					        u_xlat39 = dot(u_xlat5.xyz, u_xlat5.xyz);
					        u_xlat39 = inversesqrt(u_xlat39);
					        u_xlat7.xyz = vec3(u_xlat39) * u_xlat5.xyz;
					        u_xlat8.xyz = (-vs_TEXCOORD3.xyz) + unity_SpecCube0_BoxMax.xyz;
					        u_xlat8.xyz = u_xlat8.xyz / u_xlat7.xyz;
					        u_xlat9.xyz = (-vs_TEXCOORD3.xyz) + unity_SpecCube0_BoxMin.xyz;
					        u_xlat9.xyz = u_xlat9.xyz / u_xlat7.xyz;
					        u_xlatb10.xyz = lessThan(vec4(0.0, 0.0, 0.0, 0.0), u_xlat7.xyzx).xyz;
					        {
					            vec4 hlslcc_movcTemp = u_xlat8;
					            hlslcc_movcTemp.x = (u_xlatb10.x) ? u_xlat8.x : u_xlat9.x;
					            hlslcc_movcTemp.y = (u_xlatb10.y) ? u_xlat8.y : u_xlat9.y;
					            hlslcc_movcTemp.z = (u_xlatb10.z) ? u_xlat8.z : u_xlat9.z;
					            u_xlat8 = hlslcc_movcTemp;
					        }
					        u_xlat39 = min(u_xlat8.y, u_xlat8.x);
					        u_xlat39 = min(u_xlat8.z, u_xlat39);
					        u_xlat8.xyz = vs_TEXCOORD3.xyz + (-unity_SpecCube0_ProbePosition.xyz);
					        u_xlat7.xyz = u_xlat7.xyz * vec3(u_xlat39) + u_xlat8.xyz;
					    } else {
					        u_xlat7.xyz = u_xlat5.xyz;
					    }
					    u_xlat7 = textureLod(unity_SpecCube0, u_xlat7.xyz, 6.0);
					    u_xlat39 = u_xlat7.w + -1.0;
					    u_xlat39 = unity_SpecCube0_HDR.w * u_xlat39 + 1.0;
					    u_xlat39 = u_xlat39 * unity_SpecCube0_HDR.x;
					    u_xlat8.xyz = u_xlat7.xyz * vec3(u_xlat39);
					    u_xlatb40 = unity_SpecCube0_BoxMin.w<0.999989986;
					    if(u_xlatb40){
					        u_xlatb40 = 0.0<unity_SpecCube1_ProbePosition.w;
					        if(u_xlatb40){
					            u_xlat40 = dot(u_xlat5.xyz, u_xlat5.xyz);
					            u_xlat40 = inversesqrt(u_xlat40);
					            u_xlat9.xyz = vec3(u_xlat40) * u_xlat5.xyz;
					            u_xlat10.xyz = (-vs_TEXCOORD3.xyz) + unity_SpecCube1_BoxMax.xyz;
					            u_xlat10.xyz = u_xlat10.xyz / u_xlat9.xyz;
					            u_xlat11.xyz = (-vs_TEXCOORD3.xyz) + unity_SpecCube1_BoxMin.xyz;
					            u_xlat11.xyz = u_xlat11.xyz / u_xlat9.xyz;
					            u_xlatb12.xyz = lessThan(vec4(0.0, 0.0, 0.0, 0.0), u_xlat9.xyzx).xyz;
					            {
					                vec3 hlslcc_movcTemp = u_xlat10;
					                hlslcc_movcTemp.x = (u_xlatb12.x) ? u_xlat10.x : u_xlat11.x;
					                hlslcc_movcTemp.y = (u_xlatb12.y) ? u_xlat10.y : u_xlat11.y;
					                hlslcc_movcTemp.z = (u_xlatb12.z) ? u_xlat10.z : u_xlat11.z;
					                u_xlat10 = hlslcc_movcTemp;
					            }
					            u_xlat40 = min(u_xlat10.y, u_xlat10.x);
					            u_xlat40 = min(u_xlat10.z, u_xlat40);
					            u_xlat10.xyz = vs_TEXCOORD3.xyz + (-unity_SpecCube1_ProbePosition.xyz);
					            u_xlat5.xyz = u_xlat9.xyz * vec3(u_xlat40) + u_xlat10.xyz;
					        }
					        u_xlat5 = textureLod(unity_SpecCube1, u_xlat5.xyz, 6.0);
					        u_xlat40 = u_xlat5.w + -1.0;
					        u_xlat40 = unity_SpecCube1_HDR.w * u_xlat40 + 1.0;
					        u_xlat40 = u_xlat40 * unity_SpecCube1_HDR.x;
					        u_xlat5.xyz = u_xlat5.xyz * vec3(u_xlat40);
					        u_xlat7.xyz = vec3(u_xlat39) * u_xlat7.xyz + (-u_xlat5.xyz);
					        u_xlat8.xyz = unity_SpecCube0_BoxMin.www * u_xlat7.xyz + u_xlat5.xyz;
					    }
					    u_xlat0.w = dot(u_xlat3.xyz, u_xlat0.xyz);
					    u_xlat5.xy = vs_TEXCOORD0.xy * _AmbientOcculsion_ST.xy + _AmbientOcculsion_ST.zw;
					    u_xlat5 = texture(_AmbientOcculsion, u_xlat5.xy);
					    u_xlat18.xy = vs_TEXCOORD0.xy * _Specular_ST.xy + _Specular_ST.zw;
					    u_xlat7 = texture(_Specular, u_xlat18.xy);
					    u_xlat0.x = dot(u_xlat0.xyz, u_xlat1.xyz);
					    u_xlat13.xy = vs_TEXCOORD0.xy * _MainTexture_ST.xy + _MainTexture_ST.zw;
					    u_xlat9 = texture(_MainTexture, u_xlat13.xy);
					    u_xlat18.xyz = _Color.xyz * u_xlat9.xyz + vec3(_Shadows);
					    u_xlat18.xyz = u_xlat18.xyz + vec3(-1.0, -1.0, -1.0);
					    u_xlat18.xyz = clamp(u_xlat18.xyz, 0.0, 1.0);
					    u_xlat13.x = u_xlat7.x * 0.449999988;
					    u_xlat9.xyz = u_xlat18.xyz + vec3(-0.220916301, -0.220916301, -0.220916301);
					    u_xlat9.xyz = u_xlat13.xxx * u_xlat9.xyz + vec3(0.220916301, 0.220916301, 0.220916301);
					    u_xlat13.x = (-u_xlat7.x) * 0.350587666 + 0.779083729;
					    u_xlat18.xyz = u_xlat13.xxx * u_xlat18.xyz;
					    u_xlat13.x = (-u_xlat13.x) + 1.0;
					    u_xlat13.x = clamp(u_xlat13.x, 0.0, 1.0);
					    u_xlat0.z = dot(u_xlat3.xyz, u_xlat2.xyz);
					    u_xlat0.xzw = max(u_xlat0.xzw, vec3(0.0, 0.0, 0.0));
					    u_xlat1.x = dot(u_xlat3.xyz, u_xlat1.xyz);
					    u_xlat1.x = max(u_xlat1.x, 0.0);
					    u_xlat14.x = u_xlat0.w * 0.202115417 + 0.797884583;
					    u_xlat27 = u_xlat0.z * 0.202115417 + 0.797884583;
					    u_xlat14.x = u_xlat14.x * u_xlat27 + 9.99999975e-06;
					    u_xlat14.x = float(1.0) / u_xlat14.x;
					    u_xlat14.y = log2(u_xlat1.x);
					    u_xlat14.xy = u_xlat14.xy * vec2(0.25, 9.99999975e-05);
					    u_xlat27 = exp2(u_xlat14.y);
					    u_xlat1.z = u_xlat27 * 0.318325758;
					    u_xlat1.y = u_xlat0.w * u_xlat14.x;
					    u_xlat1.xy = u_xlat1.xz * u_xlat1.xy;
					    u_xlat14.x = u_xlat1.y * 0.616850257;
					    u_xlat1.x = u_xlat14.x * u_xlat1.x;
					    u_xlat1.xyz = u_xlat4.xyz * u_xlat1.xxx;
					    u_xlat40 = (-u_xlat0.x) + 1.0;
					    u_xlat2.x = u_xlat40 * u_xlat40;
					    u_xlat2.x = u_xlat2.x * u_xlat2.x;
					    u_xlat40 = u_xlat40 * u_xlat2.x;
					    u_xlat2.xyz = (-u_xlat9.xyz) + vec3(1.0, 1.0, 1.0);
					    u_xlat2.xyz = u_xlat2.xyz * vec3(u_xlat40) + u_xlat9.xyz;
					    u_xlat3.xyz = u_xlat7.xyz * vec3(0.0199999996, 0.0199999996, 0.0199999996) + u_xlat8.xyz;
					    u_xlat3.xyz = u_xlat5.xxx * u_xlat3.xyz;
					    u_xlat7.xy = (-u_xlat0.zz) + vec2(1.0, 1.00001001);
					    u_xlat33.xy = u_xlat7.xy * u_xlat7.xy;
					    u_xlat33.xy = u_xlat33.xy * u_xlat33.xy;
					    u_xlat7.xy = u_xlat7.xy * u_xlat33.xy;
					    u_xlat8.xyz = (-u_xlat9.xyz) + u_xlat13.xxx;
					    u_xlat7.xzw = u_xlat7.xxx * u_xlat8.xyz + u_xlat9.xyz;
					    u_xlat3.xyz = u_xlat3.xyz * u_xlat7.xzw;
					    u_xlat1.xyz = u_xlat1.xyz * u_xlat2.xyz + u_xlat3.xyz;
					    u_xlat13.x = u_xlat0.x + u_xlat0.x;
					    u_xlat0.x = u_xlat13.x * u_xlat0.x + -0.5;
					    u_xlat13.x = (-u_xlat0.w) + 1.00001001;
					    u_xlat26 = u_xlat13.x * u_xlat13.x;
					    u_xlat26 = u_xlat26 * u_xlat26;
					    u_xlat13.x = u_xlat26 * u_xlat13.x;
					    u_xlat13.x = u_xlat0.x * u_xlat13.x + 1.0;
					    u_xlat0.x = u_xlat0.x * u_xlat7.y + 1.0;
					    u_xlat0.x = u_xlat0.x * u_xlat13.x;
					    u_xlat0.x = u_xlat0.w * u_xlat0.x;
					    u_xlat13.xyz = u_xlat5.xxx * u_xlat6.xyz;
					    u_xlat0.xyz = u_xlat0.xxx * u_xlat4.xyz + u_xlat13.xyz;
					    SV_Target0.xyz = u_xlat0.xyz * u_xlat18.xyz + u_xlat1.xyz;
					    SV_Target0.w = 1.0;
					    return;
					}"
				}
			}
		}
		Pass {
			Name "FORWARD_DELTA"
			LOD 2
			Tags { "LIGHTMODE" = "FORWARDADD" "RenderType" = "Opaque" "SHADOWSUPPORT" = "true" }
			Blend One One, One One
			Cull Off
			GpuProgramID 81099
			Program "vp" {
				SubProgram "d3d11 " {
					Keywords { "POINT" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "DYNAMICLIGHTMAP_OFF" }
					"vs_4_0
					
					#version 330
					#extension GL_ARB_explicit_attrib_location : require
					#extension GL_ARB_explicit_uniform_location : require
					
					#define HLSLCC_ENABLE_UNIFORM_BUFFERS 1
					#if HLSLCC_ENABLE_UNIFORM_BUFFERS
					#define UNITY_UNIFORM
					#else
					#define UNITY_UNIFORM uniform
					#endif
					#define UNITY_SUPPORTS_UNIFORM_LOCATION 1
					#if UNITY_SUPPORTS_UNIFORM_LOCATION
					#define UNITY_LOCATION(x) layout(location = x)
					#define UNITY_BINDING(x) layout(binding = x, std140)
					#else
					#define UNITY_LOCATION(x)
					#define UNITY_BINDING(x) layout(std140)
					#endif
					layout(std140) uniform VGlobals {
						vec4 unused_0_0[2];
						mat4x4 unity_WorldToLight;
						vec4 unused_0_2[2];
						vec4 _MainTexture_ST;
						vec4 unused_0_4[2];
						vec4 _Color;
						vec4 _Heightmap_ST;
						float _Bumpiness;
						float _BumpAttune;
					};
					layout(std140) uniform UnityPerDraw {
						mat4x4 unity_ObjectToWorld;
						mat4x4 unity_WorldToObject;
						vec4 unused_1_2[2];
					};
					layout(std140) uniform UnityPerFrame {
						vec4 unused_2_0[17];
						mat4x4 unity_MatrixVP;
						vec4 unused_2_2[2];
					};
					uniform  sampler2D _Heightmap;
					uniform  sampler2D _MainTexture;
					in  vec4 in_POSITION0;
					in  vec3 in_NORMAL0;
					in  vec4 in_TANGENT0;
					in  vec2 in_TEXCOORD0;
					in  vec2 in_TEXCOORD1;
					in  vec2 in_TEXCOORD2;
					out vec2 vs_TEXCOORD0;
					out vec2 vs_TEXCOORD1;
					out vec2 vs_TEXCOORD2;
					out vec4 vs_TEXCOORD3;
					out vec3 vs_TEXCOORD4;
					out vec3 vs_TEXCOORD5;
					out vec3 vs_TEXCOORD6;
					out vec3 vs_TEXCOORD7;
					vec4 u_xlat0;
					vec4 u_xlat1;
					vec4 u_xlat2;
					vec3 u_xlat3;
					float u_xlat12;
					float u_xlat13;
					void main()
					{
					    u_xlat0.xy = in_TEXCOORD0.xy * _MainTexture_ST.xy + _MainTexture_ST.zw;
					    u_xlat0 = textureLod(_MainTexture, u_xlat0.xy, 0.0);
					    u_xlat0.xyz = u_xlat0.xyz * _Color.xyz;
					    u_xlat1.xyz = u_xlat0.xyz * vec3(-1.0, -1.0, 1.0);
					    u_xlat2.xy = in_TEXCOORD0.xy * _Heightmap_ST.xy + _Heightmap_ST.zw;
					    u_xlat2 = textureLod(_Heightmap, u_xlat2.xy, 0.0);
					    u_xlat2.xyz = u_xlat2.xyz * vec3(_Bumpiness);
					    u_xlat2.xyz = clamp(u_xlat2.xyz, 0.0, 1.0);
					    u_xlat3.xyz = u_xlat2.xyz + vec3(0.0, 0.0, 1.0);
					    u_xlat2.xyz = u_xlat2.xyz * in_NORMAL0.xyz;
					    u_xlat12 = dot(u_xlat3.xyz, u_xlat1.xyz);
					    u_xlat1.xyz = vec3(u_xlat12) * u_xlat3.xyz;
					    u_xlat1.xyz = u_xlat1.xyz / u_xlat3.zzz;
					    u_xlat0.xyz = (-u_xlat0.xyz) * vec3(-1.0, -1.0, 1.0) + u_xlat1.xyz;
					    u_xlat0.x = dot(u_xlat0.xyz, vec3(0.300000012, 0.589999974, 0.109999999));
					    u_xlat0.xyz = u_xlat2.xyz * u_xlat0.xxx + (-u_xlat2.xyz);
					    u_xlat0.xyz = vec3(vec3(_BumpAttune, _BumpAttune, _BumpAttune)) * u_xlat0.xyz + u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz + in_POSITION0.xyz;
					    u_xlat1 = u_xlat0.yyyy * unity_ObjectToWorld[1];
					    u_xlat1 = unity_ObjectToWorld[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat0 = unity_ObjectToWorld[2] * u_xlat0.zzzz + u_xlat1;
					    u_xlat1 = u_xlat0 + unity_ObjectToWorld[3];
					    u_xlat0 = unity_ObjectToWorld[3] * in_POSITION0.wwww + u_xlat0;
					    u_xlat2 = u_xlat1.yyyy * unity_MatrixVP[1];
					    u_xlat2 = unity_MatrixVP[0] * u_xlat1.xxxx + u_xlat2;
					    u_xlat2 = unity_MatrixVP[2] * u_xlat1.zzzz + u_xlat2;
					    gl_Position = unity_MatrixVP[3] * u_xlat1.wwww + u_xlat2;
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
					    vs_TEXCOORD1.xy = in_TEXCOORD1.xy;
					    vs_TEXCOORD2.xy = in_TEXCOORD2.xy;
					    vs_TEXCOORD3 = u_xlat0;
					    u_xlat1.x = dot(in_NORMAL0.xyz, unity_WorldToObject[0].xyz);
					    u_xlat1.y = dot(in_NORMAL0.xyz, unity_WorldToObject[1].xyz);
					    u_xlat1.z = dot(in_NORMAL0.xyz, unity_WorldToObject[2].xyz);
					    u_xlat13 = dot(u_xlat1.xyz, u_xlat1.xyz);
					    u_xlat13 = inversesqrt(u_xlat13);
					    u_xlat1.xyz = vec3(u_xlat13) * u_xlat1.xyz;
					    vs_TEXCOORD4.xyz = u_xlat1.xyz;
					    u_xlat2.xyz = in_TANGENT0.yyy * unity_ObjectToWorld[1].xyz;
					    u_xlat2.xyz = unity_ObjectToWorld[0].xyz * in_TANGENT0.xxx + u_xlat2.xyz;
					    u_xlat2.xyz = unity_ObjectToWorld[2].xyz * in_TANGENT0.zzz + u_xlat2.xyz;
					    u_xlat13 = dot(u_xlat2.xyz, u_xlat2.xyz);
					    u_xlat13 = inversesqrt(u_xlat13);
					    u_xlat2.xyz = vec3(u_xlat13) * u_xlat2.xyz;
					    vs_TEXCOORD5.xyz = u_xlat2.xyz;
					    u_xlat3.xyz = u_xlat1.zxy * u_xlat2.yzx;
					    u_xlat1.xyz = u_xlat1.yzx * u_xlat2.zxy + (-u_xlat3.xyz);
					    u_xlat1.xyz = u_xlat1.xyz * in_TANGENT0.www;
					    u_xlat13 = dot(u_xlat1.xyz, u_xlat1.xyz);
					    u_xlat13 = inversesqrt(u_xlat13);
					    vs_TEXCOORD6.xyz = vec3(u_xlat13) * u_xlat1.xyz;
					    u_xlat1.xyz = u_xlat0.yyy * unity_WorldToLight[1].xyz;
					    u_xlat1.xyz = unity_WorldToLight[0].xyz * u_xlat0.xxx + u_xlat1.xyz;
					    u_xlat0.xyz = unity_WorldToLight[2].xyz * u_xlat0.zzz + u_xlat1.xyz;
					    vs_TEXCOORD7.xyz = unity_WorldToLight[3].xyz * u_xlat0.www + u_xlat0.xyz;
					    return;
					}"
				}
				SubProgram "d3d11 " {
					Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "DYNAMICLIGHTMAP_OFF" }
					"vs_4_0
					
					#version 330
					#extension GL_ARB_explicit_attrib_location : require
					#extension GL_ARB_explicit_uniform_location : require
					
					#define HLSLCC_ENABLE_UNIFORM_BUFFERS 1
					#if HLSLCC_ENABLE_UNIFORM_BUFFERS
					#define UNITY_UNIFORM
					#else
					#define UNITY_UNIFORM uniform
					#endif
					#define UNITY_SUPPORTS_UNIFORM_LOCATION 1
					#if UNITY_SUPPORTS_UNIFORM_LOCATION
					#define UNITY_LOCATION(x) layout(location = x)
					#define UNITY_BINDING(x) layout(binding = x, std140)
					#else
					#define UNITY_LOCATION(x)
					#define UNITY_BINDING(x) layout(std140)
					#endif
					layout(std140) uniform VGlobals {
						vec4 unused_0_0[4];
						vec4 _MainTexture_ST;
						vec4 unused_0_2[2];
						vec4 _Color;
						vec4 _Heightmap_ST;
						float _Bumpiness;
						float _BumpAttune;
					};
					layout(std140) uniform UnityPerDraw {
						mat4x4 unity_ObjectToWorld;
						mat4x4 unity_WorldToObject;
						vec4 unused_1_2[2];
					};
					layout(std140) uniform UnityPerFrame {
						vec4 unused_2_0[17];
						mat4x4 unity_MatrixVP;
						vec4 unused_2_2[2];
					};
					uniform  sampler2D _Heightmap;
					uniform  sampler2D _MainTexture;
					in  vec4 in_POSITION0;
					in  vec3 in_NORMAL0;
					in  vec4 in_TANGENT0;
					in  vec2 in_TEXCOORD0;
					in  vec2 in_TEXCOORD1;
					in  vec2 in_TEXCOORD2;
					out vec2 vs_TEXCOORD0;
					out vec2 vs_TEXCOORD1;
					out vec2 vs_TEXCOORD2;
					out vec4 vs_TEXCOORD3;
					out vec3 vs_TEXCOORD4;
					out vec3 vs_TEXCOORD5;
					out vec3 vs_TEXCOORD6;
					vec4 u_xlat0;
					vec4 u_xlat1;
					vec4 u_xlat2;
					vec3 u_xlat3;
					float u_xlat12;
					void main()
					{
					    u_xlat0.xy = in_TEXCOORD0.xy * _MainTexture_ST.xy + _MainTexture_ST.zw;
					    u_xlat0 = textureLod(_MainTexture, u_xlat0.xy, 0.0);
					    u_xlat0.xyz = u_xlat0.xyz * _Color.xyz;
					    u_xlat1.xyz = u_xlat0.xyz * vec3(-1.0, -1.0, 1.0);
					    u_xlat2.xy = in_TEXCOORD0.xy * _Heightmap_ST.xy + _Heightmap_ST.zw;
					    u_xlat2 = textureLod(_Heightmap, u_xlat2.xy, 0.0);
					    u_xlat2.xyz = u_xlat2.xyz * vec3(_Bumpiness);
					    u_xlat2.xyz = clamp(u_xlat2.xyz, 0.0, 1.0);
					    u_xlat3.xyz = u_xlat2.xyz + vec3(0.0, 0.0, 1.0);
					    u_xlat2.xyz = u_xlat2.xyz * in_NORMAL0.xyz;
					    u_xlat12 = dot(u_xlat3.xyz, u_xlat1.xyz);
					    u_xlat1.xyz = vec3(u_xlat12) * u_xlat3.xyz;
					    u_xlat1.xyz = u_xlat1.xyz / u_xlat3.zzz;
					    u_xlat0.xyz = (-u_xlat0.xyz) * vec3(-1.0, -1.0, 1.0) + u_xlat1.xyz;
					    u_xlat0.x = dot(u_xlat0.xyz, vec3(0.300000012, 0.589999974, 0.109999999));
					    u_xlat0.xyz = u_xlat2.xyz * u_xlat0.xxx + (-u_xlat2.xyz);
					    u_xlat0.xyz = vec3(vec3(_BumpAttune, _BumpAttune, _BumpAttune)) * u_xlat0.xyz + u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz + in_POSITION0.xyz;
					    u_xlat1 = u_xlat0.yyyy * unity_ObjectToWorld[1];
					    u_xlat1 = unity_ObjectToWorld[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat0 = unity_ObjectToWorld[2] * u_xlat0.zzzz + u_xlat1;
					    u_xlat1 = u_xlat0 + unity_ObjectToWorld[3];
					    vs_TEXCOORD3 = unity_ObjectToWorld[3] * in_POSITION0.wwww + u_xlat0;
					    u_xlat0 = u_xlat1.yyyy * unity_MatrixVP[1];
					    u_xlat0 = unity_MatrixVP[0] * u_xlat1.xxxx + u_xlat0;
					    u_xlat0 = unity_MatrixVP[2] * u_xlat1.zzzz + u_xlat0;
					    gl_Position = unity_MatrixVP[3] * u_xlat1.wwww + u_xlat0;
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
					    vs_TEXCOORD1.xy = in_TEXCOORD1.xy;
					    vs_TEXCOORD2.xy = in_TEXCOORD2.xy;
					    u_xlat0.x = dot(in_NORMAL0.xyz, unity_WorldToObject[0].xyz);
					    u_xlat0.y = dot(in_NORMAL0.xyz, unity_WorldToObject[1].xyz);
					    u_xlat0.z = dot(in_NORMAL0.xyz, unity_WorldToObject[2].xyz);
					    u_xlat12 = dot(u_xlat0.xyz, u_xlat0.xyz);
					    u_xlat12 = inversesqrt(u_xlat12);
					    u_xlat0.xyz = vec3(u_xlat12) * u_xlat0.xyz;
					    vs_TEXCOORD4.xyz = u_xlat0.xyz;
					    u_xlat1.xyz = in_TANGENT0.yyy * unity_ObjectToWorld[1].xyz;
					    u_xlat1.xyz = unity_ObjectToWorld[0].xyz * in_TANGENT0.xxx + u_xlat1.xyz;
					    u_xlat1.xyz = unity_ObjectToWorld[2].xyz * in_TANGENT0.zzz + u_xlat1.xyz;
					    u_xlat12 = dot(u_xlat1.xyz, u_xlat1.xyz);
					    u_xlat12 = inversesqrt(u_xlat12);
					    u_xlat1.xyz = vec3(u_xlat12) * u_xlat1.xyz;
					    vs_TEXCOORD5.xyz = u_xlat1.xyz;
					    u_xlat2.xyz = u_xlat0.zxy * u_xlat1.yzx;
					    u_xlat0.xyz = u_xlat0.yzx * u_xlat1.zxy + (-u_xlat2.xyz);
					    u_xlat0.xyz = u_xlat0.xyz * in_TANGENT0.www;
					    u_xlat12 = dot(u_xlat0.xyz, u_xlat0.xyz);
					    u_xlat12 = inversesqrt(u_xlat12);
					    vs_TEXCOORD6.xyz = vec3(u_xlat12) * u_xlat0.xyz;
					    return;
					}"
				}
				SubProgram "d3d11 " {
					Keywords { "SPOT" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "DYNAMICLIGHTMAP_OFF" }
					"vs_4_0
					
					#version 330
					#extension GL_ARB_explicit_attrib_location : require
					#extension GL_ARB_explicit_uniform_location : require
					
					#define HLSLCC_ENABLE_UNIFORM_BUFFERS 1
					#if HLSLCC_ENABLE_UNIFORM_BUFFERS
					#define UNITY_UNIFORM
					#else
					#define UNITY_UNIFORM uniform
					#endif
					#define UNITY_SUPPORTS_UNIFORM_LOCATION 1
					#if UNITY_SUPPORTS_UNIFORM_LOCATION
					#define UNITY_LOCATION(x) layout(location = x)
					#define UNITY_BINDING(x) layout(binding = x, std140)
					#else
					#define UNITY_LOCATION(x)
					#define UNITY_BINDING(x) layout(std140)
					#endif
					layout(std140) uniform VGlobals {
						vec4 unused_0_0[2];
						mat4x4 unity_WorldToLight;
						vec4 unused_0_2[2];
						vec4 _MainTexture_ST;
						vec4 unused_0_4[2];
						vec4 _Color;
						vec4 _Heightmap_ST;
						float _Bumpiness;
						float _BumpAttune;
					};
					layout(std140) uniform UnityPerDraw {
						mat4x4 unity_ObjectToWorld;
						mat4x4 unity_WorldToObject;
						vec4 unused_1_2[2];
					};
					layout(std140) uniform UnityPerFrame {
						vec4 unused_2_0[17];
						mat4x4 unity_MatrixVP;
						vec4 unused_2_2[2];
					};
					uniform  sampler2D _Heightmap;
					uniform  sampler2D _MainTexture;
					in  vec4 in_POSITION0;
					in  vec3 in_NORMAL0;
					in  vec4 in_TANGENT0;
					in  vec2 in_TEXCOORD0;
					in  vec2 in_TEXCOORD1;
					in  vec2 in_TEXCOORD2;
					out vec2 vs_TEXCOORD0;
					out vec2 vs_TEXCOORD1;
					out vec2 vs_TEXCOORD2;
					out vec4 vs_TEXCOORD3;
					out vec3 vs_TEXCOORD4;
					out vec3 vs_TEXCOORD5;
					out vec3 vs_TEXCOORD6;
					out vec4 vs_TEXCOORD7;
					vec4 u_xlat0;
					vec4 u_xlat1;
					vec4 u_xlat2;
					vec3 u_xlat3;
					float u_xlat12;
					float u_xlat13;
					void main()
					{
					    u_xlat0.xy = in_TEXCOORD0.xy * _MainTexture_ST.xy + _MainTexture_ST.zw;
					    u_xlat0 = textureLod(_MainTexture, u_xlat0.xy, 0.0);
					    u_xlat0.xyz = u_xlat0.xyz * _Color.xyz;
					    u_xlat1.xyz = u_xlat0.xyz * vec3(-1.0, -1.0, 1.0);
					    u_xlat2.xy = in_TEXCOORD0.xy * _Heightmap_ST.xy + _Heightmap_ST.zw;
					    u_xlat2 = textureLod(_Heightmap, u_xlat2.xy, 0.0);
					    u_xlat2.xyz = u_xlat2.xyz * vec3(_Bumpiness);
					    u_xlat2.xyz = clamp(u_xlat2.xyz, 0.0, 1.0);
					    u_xlat3.xyz = u_xlat2.xyz + vec3(0.0, 0.0, 1.0);
					    u_xlat2.xyz = u_xlat2.xyz * in_NORMAL0.xyz;
					    u_xlat12 = dot(u_xlat3.xyz, u_xlat1.xyz);
					    u_xlat1.xyz = vec3(u_xlat12) * u_xlat3.xyz;
					    u_xlat1.xyz = u_xlat1.xyz / u_xlat3.zzz;
					    u_xlat0.xyz = (-u_xlat0.xyz) * vec3(-1.0, -1.0, 1.0) + u_xlat1.xyz;
					    u_xlat0.x = dot(u_xlat0.xyz, vec3(0.300000012, 0.589999974, 0.109999999));
					    u_xlat0.xyz = u_xlat2.xyz * u_xlat0.xxx + (-u_xlat2.xyz);
					    u_xlat0.xyz = vec3(vec3(_BumpAttune, _BumpAttune, _BumpAttune)) * u_xlat0.xyz + u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz + in_POSITION0.xyz;
					    u_xlat1 = u_xlat0.yyyy * unity_ObjectToWorld[1];
					    u_xlat1 = unity_ObjectToWorld[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat0 = unity_ObjectToWorld[2] * u_xlat0.zzzz + u_xlat1;
					    u_xlat1 = u_xlat0 + unity_ObjectToWorld[3];
					    u_xlat0 = unity_ObjectToWorld[3] * in_POSITION0.wwww + u_xlat0;
					    u_xlat2 = u_xlat1.yyyy * unity_MatrixVP[1];
					    u_xlat2 = unity_MatrixVP[0] * u_xlat1.xxxx + u_xlat2;
					    u_xlat2 = unity_MatrixVP[2] * u_xlat1.zzzz + u_xlat2;
					    gl_Position = unity_MatrixVP[3] * u_xlat1.wwww + u_xlat2;
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
					    vs_TEXCOORD1.xy = in_TEXCOORD1.xy;
					    vs_TEXCOORD2.xy = in_TEXCOORD2.xy;
					    vs_TEXCOORD3 = u_xlat0;
					    u_xlat1.x = dot(in_NORMAL0.xyz, unity_WorldToObject[0].xyz);
					    u_xlat1.y = dot(in_NORMAL0.xyz, unity_WorldToObject[1].xyz);
					    u_xlat1.z = dot(in_NORMAL0.xyz, unity_WorldToObject[2].xyz);
					    u_xlat13 = dot(u_xlat1.xyz, u_xlat1.xyz);
					    u_xlat13 = inversesqrt(u_xlat13);
					    u_xlat1.xyz = vec3(u_xlat13) * u_xlat1.xyz;
					    vs_TEXCOORD4.xyz = u_xlat1.xyz;
					    u_xlat2.xyz = in_TANGENT0.yyy * unity_ObjectToWorld[1].xyz;
					    u_xlat2.xyz = unity_ObjectToWorld[0].xyz * in_TANGENT0.xxx + u_xlat2.xyz;
					    u_xlat2.xyz = unity_ObjectToWorld[2].xyz * in_TANGENT0.zzz + u_xlat2.xyz;
					    u_xlat13 = dot(u_xlat2.xyz, u_xlat2.xyz);
					    u_xlat13 = inversesqrt(u_xlat13);
					    u_xlat2.xyz = vec3(u_xlat13) * u_xlat2.xyz;
					    vs_TEXCOORD5.xyz = u_xlat2.xyz;
					    u_xlat3.xyz = u_xlat1.zxy * u_xlat2.yzx;
					    u_xlat1.xyz = u_xlat1.yzx * u_xlat2.zxy + (-u_xlat3.xyz);
					    u_xlat1.xyz = u_xlat1.xyz * in_TANGENT0.www;
					    u_xlat13 = dot(u_xlat1.xyz, u_xlat1.xyz);
					    u_xlat13 = inversesqrt(u_xlat13);
					    vs_TEXCOORD6.xyz = vec3(u_xlat13) * u_xlat1.xyz;
					    u_xlat1 = u_xlat0.yyyy * unity_WorldToLight[1];
					    u_xlat1 = unity_WorldToLight[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat1 = unity_WorldToLight[2] * u_xlat0.zzzz + u_xlat1;
					    vs_TEXCOORD7 = unity_WorldToLight[3] * u_xlat0.wwww + u_xlat1;
					    return;
					}"
				}
				SubProgram "d3d11 " {
					Keywords { "POINT_COOKIE" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "DYNAMICLIGHTMAP_OFF" }
					"vs_4_0
					
					#version 330
					#extension GL_ARB_explicit_attrib_location : require
					#extension GL_ARB_explicit_uniform_location : require
					
					#define HLSLCC_ENABLE_UNIFORM_BUFFERS 1
					#if HLSLCC_ENABLE_UNIFORM_BUFFERS
					#define UNITY_UNIFORM
					#else
					#define UNITY_UNIFORM uniform
					#endif
					#define UNITY_SUPPORTS_UNIFORM_LOCATION 1
					#if UNITY_SUPPORTS_UNIFORM_LOCATION
					#define UNITY_LOCATION(x) layout(location = x)
					#define UNITY_BINDING(x) layout(binding = x, std140)
					#else
					#define UNITY_LOCATION(x)
					#define UNITY_BINDING(x) layout(std140)
					#endif
					layout(std140) uniform VGlobals {
						vec4 unused_0_0[2];
						mat4x4 unity_WorldToLight;
						vec4 unused_0_2[2];
						vec4 _MainTexture_ST;
						vec4 unused_0_4[2];
						vec4 _Color;
						vec4 _Heightmap_ST;
						float _Bumpiness;
						float _BumpAttune;
					};
					layout(std140) uniform UnityPerDraw {
						mat4x4 unity_ObjectToWorld;
						mat4x4 unity_WorldToObject;
						vec4 unused_1_2[2];
					};
					layout(std140) uniform UnityPerFrame {
						vec4 unused_2_0[17];
						mat4x4 unity_MatrixVP;
						vec4 unused_2_2[2];
					};
					uniform  sampler2D _Heightmap;
					uniform  sampler2D _MainTexture;
					in  vec4 in_POSITION0;
					in  vec3 in_NORMAL0;
					in  vec4 in_TANGENT0;
					in  vec2 in_TEXCOORD0;
					in  vec2 in_TEXCOORD1;
					in  vec2 in_TEXCOORD2;
					out vec2 vs_TEXCOORD0;
					out vec2 vs_TEXCOORD1;
					out vec2 vs_TEXCOORD2;
					out vec4 vs_TEXCOORD3;
					out vec3 vs_TEXCOORD4;
					out vec3 vs_TEXCOORD5;
					out vec3 vs_TEXCOORD6;
					out vec3 vs_TEXCOORD7;
					vec4 u_xlat0;
					vec4 u_xlat1;
					vec4 u_xlat2;
					vec3 u_xlat3;
					float u_xlat12;
					float u_xlat13;
					void main()
					{
					    u_xlat0.xy = in_TEXCOORD0.xy * _MainTexture_ST.xy + _MainTexture_ST.zw;
					    u_xlat0 = textureLod(_MainTexture, u_xlat0.xy, 0.0);
					    u_xlat0.xyz = u_xlat0.xyz * _Color.xyz;
					    u_xlat1.xyz = u_xlat0.xyz * vec3(-1.0, -1.0, 1.0);
					    u_xlat2.xy = in_TEXCOORD0.xy * _Heightmap_ST.xy + _Heightmap_ST.zw;
					    u_xlat2 = textureLod(_Heightmap, u_xlat2.xy, 0.0);
					    u_xlat2.xyz = u_xlat2.xyz * vec3(_Bumpiness);
					    u_xlat2.xyz = clamp(u_xlat2.xyz, 0.0, 1.0);
					    u_xlat3.xyz = u_xlat2.xyz + vec3(0.0, 0.0, 1.0);
					    u_xlat2.xyz = u_xlat2.xyz * in_NORMAL0.xyz;
					    u_xlat12 = dot(u_xlat3.xyz, u_xlat1.xyz);
					    u_xlat1.xyz = vec3(u_xlat12) * u_xlat3.xyz;
					    u_xlat1.xyz = u_xlat1.xyz / u_xlat3.zzz;
					    u_xlat0.xyz = (-u_xlat0.xyz) * vec3(-1.0, -1.0, 1.0) + u_xlat1.xyz;
					    u_xlat0.x = dot(u_xlat0.xyz, vec3(0.300000012, 0.589999974, 0.109999999));
					    u_xlat0.xyz = u_xlat2.xyz * u_xlat0.xxx + (-u_xlat2.xyz);
					    u_xlat0.xyz = vec3(vec3(_BumpAttune, _BumpAttune, _BumpAttune)) * u_xlat0.xyz + u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz + in_POSITION0.xyz;
					    u_xlat1 = u_xlat0.yyyy * unity_ObjectToWorld[1];
					    u_xlat1 = unity_ObjectToWorld[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat0 = unity_ObjectToWorld[2] * u_xlat0.zzzz + u_xlat1;
					    u_xlat1 = u_xlat0 + unity_ObjectToWorld[3];
					    u_xlat0 = unity_ObjectToWorld[3] * in_POSITION0.wwww + u_xlat0;
					    u_xlat2 = u_xlat1.yyyy * unity_MatrixVP[1];
					    u_xlat2 = unity_MatrixVP[0] * u_xlat1.xxxx + u_xlat2;
					    u_xlat2 = unity_MatrixVP[2] * u_xlat1.zzzz + u_xlat2;
					    gl_Position = unity_MatrixVP[3] * u_xlat1.wwww + u_xlat2;
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
					    vs_TEXCOORD1.xy = in_TEXCOORD1.xy;
					    vs_TEXCOORD2.xy = in_TEXCOORD2.xy;
					    vs_TEXCOORD3 = u_xlat0;
					    u_xlat1.x = dot(in_NORMAL0.xyz, unity_WorldToObject[0].xyz);
					    u_xlat1.y = dot(in_NORMAL0.xyz, unity_WorldToObject[1].xyz);
					    u_xlat1.z = dot(in_NORMAL0.xyz, unity_WorldToObject[2].xyz);
					    u_xlat13 = dot(u_xlat1.xyz, u_xlat1.xyz);
					    u_xlat13 = inversesqrt(u_xlat13);
					    u_xlat1.xyz = vec3(u_xlat13) * u_xlat1.xyz;
					    vs_TEXCOORD4.xyz = u_xlat1.xyz;
					    u_xlat2.xyz = in_TANGENT0.yyy * unity_ObjectToWorld[1].xyz;
					    u_xlat2.xyz = unity_ObjectToWorld[0].xyz * in_TANGENT0.xxx + u_xlat2.xyz;
					    u_xlat2.xyz = unity_ObjectToWorld[2].xyz * in_TANGENT0.zzz + u_xlat2.xyz;
					    u_xlat13 = dot(u_xlat2.xyz, u_xlat2.xyz);
					    u_xlat13 = inversesqrt(u_xlat13);
					    u_xlat2.xyz = vec3(u_xlat13) * u_xlat2.xyz;
					    vs_TEXCOORD5.xyz = u_xlat2.xyz;
					    u_xlat3.xyz = u_xlat1.zxy * u_xlat2.yzx;
					    u_xlat1.xyz = u_xlat1.yzx * u_xlat2.zxy + (-u_xlat3.xyz);
					    u_xlat1.xyz = u_xlat1.xyz * in_TANGENT0.www;
					    u_xlat13 = dot(u_xlat1.xyz, u_xlat1.xyz);
					    u_xlat13 = inversesqrt(u_xlat13);
					    vs_TEXCOORD6.xyz = vec3(u_xlat13) * u_xlat1.xyz;
					    u_xlat1.xyz = u_xlat0.yyy * unity_WorldToLight[1].xyz;
					    u_xlat1.xyz = unity_WorldToLight[0].xyz * u_xlat0.xxx + u_xlat1.xyz;
					    u_xlat0.xyz = unity_WorldToLight[2].xyz * u_xlat0.zzz + u_xlat1.xyz;
					    vs_TEXCOORD7.xyz = unity_WorldToLight[3].xyz * u_xlat0.www + u_xlat0.xyz;
					    return;
					}"
				}
				SubProgram "d3d11 " {
					Keywords { "DIRECTIONAL_COOKIE" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "DYNAMICLIGHTMAP_OFF" }
					"vs_4_0
					
					#version 330
					#extension GL_ARB_explicit_attrib_location : require
					#extension GL_ARB_explicit_uniform_location : require
					
					#define HLSLCC_ENABLE_UNIFORM_BUFFERS 1
					#if HLSLCC_ENABLE_UNIFORM_BUFFERS
					#define UNITY_UNIFORM
					#else
					#define UNITY_UNIFORM uniform
					#endif
					#define UNITY_SUPPORTS_UNIFORM_LOCATION 1
					#if UNITY_SUPPORTS_UNIFORM_LOCATION
					#define UNITY_LOCATION(x) layout(location = x)
					#define UNITY_BINDING(x) layout(binding = x, std140)
					#else
					#define UNITY_LOCATION(x)
					#define UNITY_BINDING(x) layout(std140)
					#endif
					layout(std140) uniform VGlobals {
						vec4 unused_0_0[2];
						mat4x4 unity_WorldToLight;
						vec4 unused_0_2[2];
						vec4 _MainTexture_ST;
						vec4 unused_0_4[2];
						vec4 _Color;
						vec4 _Heightmap_ST;
						float _Bumpiness;
						float _BumpAttune;
					};
					layout(std140) uniform UnityPerDraw {
						mat4x4 unity_ObjectToWorld;
						mat4x4 unity_WorldToObject;
						vec4 unused_1_2[2];
					};
					layout(std140) uniform UnityPerFrame {
						vec4 unused_2_0[17];
						mat4x4 unity_MatrixVP;
						vec4 unused_2_2[2];
					};
					uniform  sampler2D _Heightmap;
					uniform  sampler2D _MainTexture;
					in  vec4 in_POSITION0;
					in  vec3 in_NORMAL0;
					in  vec4 in_TANGENT0;
					in  vec2 in_TEXCOORD0;
					in  vec2 in_TEXCOORD1;
					in  vec2 in_TEXCOORD2;
					out vec2 vs_TEXCOORD0;
					out vec2 vs_TEXCOORD1;
					out vec2 vs_TEXCOORD2;
					out vec2 vs_TEXCOORD7;
					out vec4 vs_TEXCOORD3;
					out vec3 vs_TEXCOORD4;
					out vec3 vs_TEXCOORD5;
					out vec3 vs_TEXCOORD6;
					vec4 u_xlat0;
					vec4 u_xlat1;
					vec4 u_xlat2;
					vec3 u_xlat3;
					float u_xlat12;
					void main()
					{
					    u_xlat0.xy = in_TEXCOORD0.xy * _MainTexture_ST.xy + _MainTexture_ST.zw;
					    u_xlat0 = textureLod(_MainTexture, u_xlat0.xy, 0.0);
					    u_xlat0.xyz = u_xlat0.xyz * _Color.xyz;
					    u_xlat1.xyz = u_xlat0.xyz * vec3(-1.0, -1.0, 1.0);
					    u_xlat2.xy = in_TEXCOORD0.xy * _Heightmap_ST.xy + _Heightmap_ST.zw;
					    u_xlat2 = textureLod(_Heightmap, u_xlat2.xy, 0.0);
					    u_xlat2.xyz = u_xlat2.xyz * vec3(_Bumpiness);
					    u_xlat2.xyz = clamp(u_xlat2.xyz, 0.0, 1.0);
					    u_xlat3.xyz = u_xlat2.xyz + vec3(0.0, 0.0, 1.0);
					    u_xlat2.xyz = u_xlat2.xyz * in_NORMAL0.xyz;
					    u_xlat12 = dot(u_xlat3.xyz, u_xlat1.xyz);
					    u_xlat1.xyz = vec3(u_xlat12) * u_xlat3.xyz;
					    u_xlat1.xyz = u_xlat1.xyz / u_xlat3.zzz;
					    u_xlat0.xyz = (-u_xlat0.xyz) * vec3(-1.0, -1.0, 1.0) + u_xlat1.xyz;
					    u_xlat0.x = dot(u_xlat0.xyz, vec3(0.300000012, 0.589999974, 0.109999999));
					    u_xlat0.xyz = u_xlat2.xyz * u_xlat0.xxx + (-u_xlat2.xyz);
					    u_xlat0.xyz = vec3(vec3(_BumpAttune, _BumpAttune, _BumpAttune)) * u_xlat0.xyz + u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz + in_POSITION0.xyz;
					    u_xlat1 = u_xlat0.yyyy * unity_ObjectToWorld[1];
					    u_xlat1 = unity_ObjectToWorld[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat0 = unity_ObjectToWorld[2] * u_xlat0.zzzz + u_xlat1;
					    u_xlat1 = u_xlat0 + unity_ObjectToWorld[3];
					    u_xlat0 = unity_ObjectToWorld[3] * in_POSITION0.wwww + u_xlat0;
					    u_xlat2 = u_xlat1.yyyy * unity_MatrixVP[1];
					    u_xlat2 = unity_MatrixVP[0] * u_xlat1.xxxx + u_xlat2;
					    u_xlat2 = unity_MatrixVP[2] * u_xlat1.zzzz + u_xlat2;
					    gl_Position = unity_MatrixVP[3] * u_xlat1.wwww + u_xlat2;
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
					    vs_TEXCOORD1.xy = in_TEXCOORD1.xy;
					    u_xlat1.xy = u_xlat0.yy * unity_WorldToLight[1].xy;
					    u_xlat1.xy = unity_WorldToLight[0].xy * u_xlat0.xx + u_xlat1.xy;
					    u_xlat1.xy = unity_WorldToLight[2].xy * u_xlat0.zz + u_xlat1.xy;
					    vs_TEXCOORD7.xy = unity_WorldToLight[3].xy * u_xlat0.ww + u_xlat1.xy;
					    vs_TEXCOORD3 = u_xlat0;
					    vs_TEXCOORD2.xy = in_TEXCOORD2.xy;
					    u_xlat0.x = dot(in_NORMAL0.xyz, unity_WorldToObject[0].xyz);
					    u_xlat0.y = dot(in_NORMAL0.xyz, unity_WorldToObject[1].xyz);
					    u_xlat0.z = dot(in_NORMAL0.xyz, unity_WorldToObject[2].xyz);
					    u_xlat12 = dot(u_xlat0.xyz, u_xlat0.xyz);
					    u_xlat12 = inversesqrt(u_xlat12);
					    u_xlat0.xyz = vec3(u_xlat12) * u_xlat0.xyz;
					    vs_TEXCOORD4.xyz = u_xlat0.xyz;
					    u_xlat1.xyz = in_TANGENT0.yyy * unity_ObjectToWorld[1].xyz;
					    u_xlat1.xyz = unity_ObjectToWorld[0].xyz * in_TANGENT0.xxx + u_xlat1.xyz;
					    u_xlat1.xyz = unity_ObjectToWorld[2].xyz * in_TANGENT0.zzz + u_xlat1.xyz;
					    u_xlat12 = dot(u_xlat1.xyz, u_xlat1.xyz);
					    u_xlat12 = inversesqrt(u_xlat12);
					    u_xlat1.xyz = vec3(u_xlat12) * u_xlat1.xyz;
					    vs_TEXCOORD5.xyz = u_xlat1.xyz;
					    u_xlat2.xyz = u_xlat0.zxy * u_xlat1.yzx;
					    u_xlat0.xyz = u_xlat0.yzx * u_xlat1.zxy + (-u_xlat2.xyz);
					    u_xlat0.xyz = u_xlat0.xyz * in_TANGENT0.www;
					    u_xlat12 = dot(u_xlat0.xyz, u_xlat0.xyz);
					    u_xlat12 = inversesqrt(u_xlat12);
					    vs_TEXCOORD6.xyz = vec3(u_xlat12) * u_xlat0.xyz;
					    return;
					}"
				}
				SubProgram "d3d11 " {
					Keywords { "SPOT" "SHADOWS_DEPTH" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "DYNAMICLIGHTMAP_OFF" }
					"vs_4_0
					
					#version 330
					#extension GL_ARB_explicit_attrib_location : require
					#extension GL_ARB_explicit_uniform_location : require
					
					#define HLSLCC_ENABLE_UNIFORM_BUFFERS 1
					#if HLSLCC_ENABLE_UNIFORM_BUFFERS
					#define UNITY_UNIFORM
					#else
					#define UNITY_UNIFORM uniform
					#endif
					#define UNITY_SUPPORTS_UNIFORM_LOCATION 1
					#if UNITY_SUPPORTS_UNIFORM_LOCATION
					#define UNITY_LOCATION(x) layout(location = x)
					#define UNITY_BINDING(x) layout(binding = x, std140)
					#else
					#define UNITY_LOCATION(x)
					#define UNITY_BINDING(x) layout(std140)
					#endif
					layout(std140) uniform VGlobals {
						vec4 unused_0_0[2];
						mat4x4 unity_WorldToLight;
						vec4 unused_0_2[2];
						vec4 _MainTexture_ST;
						vec4 unused_0_4[2];
						vec4 _Color;
						vec4 _Heightmap_ST;
						float _Bumpiness;
						float _BumpAttune;
					};
					layout(std140) uniform UnityShadows {
						vec4 unused_1_0[8];
						mat4x4 unity_WorldToShadow[4];
						vec4 unused_1_2[14];
					};
					layout(std140) uniform UnityPerDraw {
						mat4x4 unity_ObjectToWorld;
						mat4x4 unity_WorldToObject;
						vec4 unused_2_2[2];
					};
					layout(std140) uniform UnityPerFrame {
						vec4 unused_3_0[17];
						mat4x4 unity_MatrixVP;
						vec4 unused_3_2[2];
					};
					uniform  sampler2D _Heightmap;
					uniform  sampler2D _MainTexture;
					in  vec4 in_POSITION0;
					in  vec3 in_NORMAL0;
					in  vec4 in_TANGENT0;
					in  vec2 in_TEXCOORD0;
					in  vec2 in_TEXCOORD1;
					in  vec2 in_TEXCOORD2;
					out vec2 vs_TEXCOORD0;
					out vec2 vs_TEXCOORD1;
					out vec2 vs_TEXCOORD2;
					out vec4 vs_TEXCOORD3;
					out vec3 vs_TEXCOORD4;
					out vec3 vs_TEXCOORD5;
					out vec3 vs_TEXCOORD6;
					out vec4 vs_TEXCOORD7;
					out vec4 vs_TEXCOORD8;
					vec4 u_xlat0;
					vec4 u_xlat1;
					vec4 u_xlat2;
					vec3 u_xlat3;
					float u_xlat12;
					float u_xlat13;
					void main()
					{
					    u_xlat0.xy = in_TEXCOORD0.xy * _MainTexture_ST.xy + _MainTexture_ST.zw;
					    u_xlat0 = textureLod(_MainTexture, u_xlat0.xy, 0.0);
					    u_xlat0.xyz = u_xlat0.xyz * _Color.xyz;
					    u_xlat1.xyz = u_xlat0.xyz * vec3(-1.0, -1.0, 1.0);
					    u_xlat2.xy = in_TEXCOORD0.xy * _Heightmap_ST.xy + _Heightmap_ST.zw;
					    u_xlat2 = textureLod(_Heightmap, u_xlat2.xy, 0.0);
					    u_xlat2.xyz = u_xlat2.xyz * vec3(_Bumpiness);
					    u_xlat2.xyz = clamp(u_xlat2.xyz, 0.0, 1.0);
					    u_xlat3.xyz = u_xlat2.xyz + vec3(0.0, 0.0, 1.0);
					    u_xlat2.xyz = u_xlat2.xyz * in_NORMAL0.xyz;
					    u_xlat12 = dot(u_xlat3.xyz, u_xlat1.xyz);
					    u_xlat1.xyz = vec3(u_xlat12) * u_xlat3.xyz;
					    u_xlat1.xyz = u_xlat1.xyz / u_xlat3.zzz;
					    u_xlat0.xyz = (-u_xlat0.xyz) * vec3(-1.0, -1.0, 1.0) + u_xlat1.xyz;
					    u_xlat0.x = dot(u_xlat0.xyz, vec3(0.300000012, 0.589999974, 0.109999999));
					    u_xlat0.xyz = u_xlat2.xyz * u_xlat0.xxx + (-u_xlat2.xyz);
					    u_xlat0.xyz = vec3(vec3(_BumpAttune, _BumpAttune, _BumpAttune)) * u_xlat0.xyz + u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz + in_POSITION0.xyz;
					    u_xlat1 = u_xlat0.yyyy * unity_ObjectToWorld[1];
					    u_xlat1 = unity_ObjectToWorld[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat0 = unity_ObjectToWorld[2] * u_xlat0.zzzz + u_xlat1;
					    u_xlat1 = u_xlat0 + unity_ObjectToWorld[3];
					    u_xlat0 = unity_ObjectToWorld[3] * in_POSITION0.wwww + u_xlat0;
					    u_xlat2 = u_xlat1.yyyy * unity_MatrixVP[1];
					    u_xlat2 = unity_MatrixVP[0] * u_xlat1.xxxx + u_xlat2;
					    u_xlat2 = unity_MatrixVP[2] * u_xlat1.zzzz + u_xlat2;
					    gl_Position = unity_MatrixVP[3] * u_xlat1.wwww + u_xlat2;
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
					    vs_TEXCOORD1.xy = in_TEXCOORD1.xy;
					    vs_TEXCOORD2.xy = in_TEXCOORD2.xy;
					    vs_TEXCOORD3 = u_xlat0;
					    u_xlat1.x = dot(in_NORMAL0.xyz, unity_WorldToObject[0].xyz);
					    u_xlat1.y = dot(in_NORMAL0.xyz, unity_WorldToObject[1].xyz);
					    u_xlat1.z = dot(in_NORMAL0.xyz, unity_WorldToObject[2].xyz);
					    u_xlat13 = dot(u_xlat1.xyz, u_xlat1.xyz);
					    u_xlat13 = inversesqrt(u_xlat13);
					    u_xlat1.xyz = vec3(u_xlat13) * u_xlat1.xyz;
					    vs_TEXCOORD4.xyz = u_xlat1.xyz;
					    u_xlat2.xyz = in_TANGENT0.yyy * unity_ObjectToWorld[1].xyz;
					    u_xlat2.xyz = unity_ObjectToWorld[0].xyz * in_TANGENT0.xxx + u_xlat2.xyz;
					    u_xlat2.xyz = unity_ObjectToWorld[2].xyz * in_TANGENT0.zzz + u_xlat2.xyz;
					    u_xlat13 = dot(u_xlat2.xyz, u_xlat2.xyz);
					    u_xlat13 = inversesqrt(u_xlat13);
					    u_xlat2.xyz = vec3(u_xlat13) * u_xlat2.xyz;
					    vs_TEXCOORD5.xyz = u_xlat2.xyz;
					    u_xlat3.xyz = u_xlat1.zxy * u_xlat2.yzx;
					    u_xlat1.xyz = u_xlat1.yzx * u_xlat2.zxy + (-u_xlat3.xyz);
					    u_xlat1.xyz = u_xlat1.xyz * in_TANGENT0.www;
					    u_xlat13 = dot(u_xlat1.xyz, u_xlat1.xyz);
					    u_xlat13 = inversesqrt(u_xlat13);
					    vs_TEXCOORD6.xyz = vec3(u_xlat13) * u_xlat1.xyz;
					    u_xlat1 = u_xlat0.yyyy * unity_WorldToLight[1];
					    u_xlat1 = unity_WorldToLight[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat1 = unity_WorldToLight[2] * u_xlat0.zzzz + u_xlat1;
					    vs_TEXCOORD7 = unity_WorldToLight[3] * u_xlat0.wwww + u_xlat1;
					    u_xlat1 = u_xlat0.yyyy * unity_WorldToShadow[1 / 4][1 % 4];
					    u_xlat1 = unity_WorldToShadow[0 / 4][0 % 4] * u_xlat0.xxxx + u_xlat1;
					    u_xlat1 = unity_WorldToShadow[2 / 4][2 % 4] * u_xlat0.zzzz + u_xlat1;
					    vs_TEXCOORD8 = unity_WorldToShadow[3 / 4][3 % 4] * u_xlat0.wwww + u_xlat1;
					    return;
					}"
				}
				SubProgram "d3d11 " {
					Keywords { "SPOT" "SHADOWS_DEPTH" "SHADOWS_SOFT" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "DYNAMICLIGHTMAP_OFF" }
					"vs_4_0
					
					#version 330
					#extension GL_ARB_explicit_attrib_location : require
					#extension GL_ARB_explicit_uniform_location : require
					
					#define HLSLCC_ENABLE_UNIFORM_BUFFERS 1
					#if HLSLCC_ENABLE_UNIFORM_BUFFERS
					#define UNITY_UNIFORM
					#else
					#define UNITY_UNIFORM uniform
					#endif
					#define UNITY_SUPPORTS_UNIFORM_LOCATION 1
					#if UNITY_SUPPORTS_UNIFORM_LOCATION
					#define UNITY_LOCATION(x) layout(location = x)
					#define UNITY_BINDING(x) layout(binding = x, std140)
					#else
					#define UNITY_LOCATION(x)
					#define UNITY_BINDING(x) layout(std140)
					#endif
					layout(std140) uniform VGlobals {
						vec4 unused_0_0[7];
						mat4x4 unity_WorldToLight;
						vec4 unused_0_2[2];
						vec4 _MainTexture_ST;
						vec4 unused_0_4[2];
						vec4 _Color;
						vec4 _Heightmap_ST;
						float _Bumpiness;
						float _BumpAttune;
					};
					layout(std140) uniform UnityShadows {
						vec4 unused_1_0[8];
						mat4x4 unity_WorldToShadow[4];
						vec4 unused_1_2[14];
					};
					layout(std140) uniform UnityPerDraw {
						mat4x4 unity_ObjectToWorld;
						mat4x4 unity_WorldToObject;
						vec4 unused_2_2[2];
					};
					layout(std140) uniform UnityPerFrame {
						vec4 unused_3_0[17];
						mat4x4 unity_MatrixVP;
						vec4 unused_3_2[2];
					};
					uniform  sampler2D _Heightmap;
					uniform  sampler2D _MainTexture;
					in  vec4 in_POSITION0;
					in  vec3 in_NORMAL0;
					in  vec4 in_TANGENT0;
					in  vec2 in_TEXCOORD0;
					in  vec2 in_TEXCOORD1;
					in  vec2 in_TEXCOORD2;
					out vec2 vs_TEXCOORD0;
					out vec2 vs_TEXCOORD1;
					out vec2 vs_TEXCOORD2;
					out vec4 vs_TEXCOORD3;
					out vec3 vs_TEXCOORD4;
					out vec3 vs_TEXCOORD5;
					out vec3 vs_TEXCOORD6;
					out vec4 vs_TEXCOORD7;
					out vec4 vs_TEXCOORD8;
					vec4 u_xlat0;
					vec4 u_xlat1;
					vec4 u_xlat2;
					vec3 u_xlat3;
					float u_xlat12;
					float u_xlat13;
					void main()
					{
					    u_xlat0.xy = in_TEXCOORD0.xy * _MainTexture_ST.xy + _MainTexture_ST.zw;
					    u_xlat0 = textureLod(_MainTexture, u_xlat0.xy, 0.0);
					    u_xlat0.xyz = u_xlat0.xyz * _Color.xyz;
					    u_xlat1.xyz = u_xlat0.xyz * vec3(-1.0, -1.0, 1.0);
					    u_xlat2.xy = in_TEXCOORD0.xy * _Heightmap_ST.xy + _Heightmap_ST.zw;
					    u_xlat2 = textureLod(_Heightmap, u_xlat2.xy, 0.0);
					    u_xlat2.xyz = u_xlat2.xyz * vec3(_Bumpiness);
					    u_xlat2.xyz = clamp(u_xlat2.xyz, 0.0, 1.0);
					    u_xlat3.xyz = u_xlat2.xyz + vec3(0.0, 0.0, 1.0);
					    u_xlat2.xyz = u_xlat2.xyz * in_NORMAL0.xyz;
					    u_xlat12 = dot(u_xlat3.xyz, u_xlat1.xyz);
					    u_xlat1.xyz = vec3(u_xlat12) * u_xlat3.xyz;
					    u_xlat1.xyz = u_xlat1.xyz / u_xlat3.zzz;
					    u_xlat0.xyz = (-u_xlat0.xyz) * vec3(-1.0, -1.0, 1.0) + u_xlat1.xyz;
					    u_xlat0.x = dot(u_xlat0.xyz, vec3(0.300000012, 0.589999974, 0.109999999));
					    u_xlat0.xyz = u_xlat2.xyz * u_xlat0.xxx + (-u_xlat2.xyz);
					    u_xlat0.xyz = vec3(vec3(_BumpAttune, _BumpAttune, _BumpAttune)) * u_xlat0.xyz + u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz + in_POSITION0.xyz;
					    u_xlat1 = u_xlat0.yyyy * unity_ObjectToWorld[1];
					    u_xlat1 = unity_ObjectToWorld[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat0 = unity_ObjectToWorld[2] * u_xlat0.zzzz + u_xlat1;
					    u_xlat1 = u_xlat0 + unity_ObjectToWorld[3];
					    u_xlat0 = unity_ObjectToWorld[3] * in_POSITION0.wwww + u_xlat0;
					    u_xlat2 = u_xlat1.yyyy * unity_MatrixVP[1];
					    u_xlat2 = unity_MatrixVP[0] * u_xlat1.xxxx + u_xlat2;
					    u_xlat2 = unity_MatrixVP[2] * u_xlat1.zzzz + u_xlat2;
					    gl_Position = unity_MatrixVP[3] * u_xlat1.wwww + u_xlat2;
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
					    vs_TEXCOORD1.xy = in_TEXCOORD1.xy;
					    vs_TEXCOORD2.xy = in_TEXCOORD2.xy;
					    vs_TEXCOORD3 = u_xlat0;
					    u_xlat1.x = dot(in_NORMAL0.xyz, unity_WorldToObject[0].xyz);
					    u_xlat1.y = dot(in_NORMAL0.xyz, unity_WorldToObject[1].xyz);
					    u_xlat1.z = dot(in_NORMAL0.xyz, unity_WorldToObject[2].xyz);
					    u_xlat13 = dot(u_xlat1.xyz, u_xlat1.xyz);
					    u_xlat13 = inversesqrt(u_xlat13);
					    u_xlat1.xyz = vec3(u_xlat13) * u_xlat1.xyz;
					    vs_TEXCOORD4.xyz = u_xlat1.xyz;
					    u_xlat2.xyz = in_TANGENT0.yyy * unity_ObjectToWorld[1].xyz;
					    u_xlat2.xyz = unity_ObjectToWorld[0].xyz * in_TANGENT0.xxx + u_xlat2.xyz;
					    u_xlat2.xyz = unity_ObjectToWorld[2].xyz * in_TANGENT0.zzz + u_xlat2.xyz;
					    u_xlat13 = dot(u_xlat2.xyz, u_xlat2.xyz);
					    u_xlat13 = inversesqrt(u_xlat13);
					    u_xlat2.xyz = vec3(u_xlat13) * u_xlat2.xyz;
					    vs_TEXCOORD5.xyz = u_xlat2.xyz;
					    u_xlat3.xyz = u_xlat1.zxy * u_xlat2.yzx;
					    u_xlat1.xyz = u_xlat1.yzx * u_xlat2.zxy + (-u_xlat3.xyz);
					    u_xlat1.xyz = u_xlat1.xyz * in_TANGENT0.www;
					    u_xlat13 = dot(u_xlat1.xyz, u_xlat1.xyz);
					    u_xlat13 = inversesqrt(u_xlat13);
					    vs_TEXCOORD6.xyz = vec3(u_xlat13) * u_xlat1.xyz;
					    u_xlat1 = u_xlat0.yyyy * unity_WorldToLight[1];
					    u_xlat1 = unity_WorldToLight[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat1 = unity_WorldToLight[2] * u_xlat0.zzzz + u_xlat1;
					    vs_TEXCOORD7 = unity_WorldToLight[3] * u_xlat0.wwww + u_xlat1;
					    u_xlat1 = u_xlat0.yyyy * unity_WorldToShadow[1 / 4][1 % 4];
					    u_xlat1 = unity_WorldToShadow[0 / 4][0 % 4] * u_xlat0.xxxx + u_xlat1;
					    u_xlat1 = unity_WorldToShadow[2 / 4][2 % 4] * u_xlat0.zzzz + u_xlat1;
					    vs_TEXCOORD8 = unity_WorldToShadow[3 / 4][3 % 4] * u_xlat0.wwww + u_xlat1;
					    return;
					}"
				}
				SubProgram "d3d11 " {
					Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "DYNAMICLIGHTMAP_OFF" }
					"vs_4_0
					
					#version 330
					#extension GL_ARB_explicit_attrib_location : require
					#extension GL_ARB_explicit_uniform_location : require
					
					#define HLSLCC_ENABLE_UNIFORM_BUFFERS 1
					#if HLSLCC_ENABLE_UNIFORM_BUFFERS
					#define UNITY_UNIFORM
					#else
					#define UNITY_UNIFORM uniform
					#endif
					#define UNITY_SUPPORTS_UNIFORM_LOCATION 1
					#if UNITY_SUPPORTS_UNIFORM_LOCATION
					#define UNITY_LOCATION(x) layout(location = x)
					#define UNITY_BINDING(x) layout(binding = x, std140)
					#else
					#define UNITY_LOCATION(x)
					#define UNITY_BINDING(x) layout(std140)
					#endif
					layout(std140) uniform VGlobals {
						vec4 unused_0_0[4];
						vec4 _MainTexture_ST;
						vec4 unused_0_2[2];
						vec4 _Color;
						vec4 _Heightmap_ST;
						float _Bumpiness;
						float _BumpAttune;
					};
					layout(std140) uniform UnityPerCamera {
						vec4 unused_1_0[5];
						vec4 _ProjectionParams;
						vec4 unused_1_2[3];
					};
					layout(std140) uniform UnityPerDraw {
						mat4x4 unity_ObjectToWorld;
						mat4x4 unity_WorldToObject;
						vec4 unused_2_2[2];
					};
					layout(std140) uniform UnityPerFrame {
						vec4 unused_3_0[17];
						mat4x4 unity_MatrixVP;
						vec4 unused_3_2[2];
					};
					uniform  sampler2D _Heightmap;
					uniform  sampler2D _MainTexture;
					in  vec4 in_POSITION0;
					in  vec3 in_NORMAL0;
					in  vec4 in_TANGENT0;
					in  vec2 in_TEXCOORD0;
					in  vec2 in_TEXCOORD1;
					in  vec2 in_TEXCOORD2;
					out vec2 vs_TEXCOORD0;
					out vec2 vs_TEXCOORD1;
					out vec2 vs_TEXCOORD2;
					out vec4 vs_TEXCOORD3;
					out vec3 vs_TEXCOORD4;
					out vec3 vs_TEXCOORD5;
					out vec3 vs_TEXCOORD6;
					out vec4 vs_TEXCOORD8;
					vec4 u_xlat0;
					vec4 u_xlat1;
					vec4 u_xlat2;
					vec3 u_xlat3;
					float u_xlat12;
					float u_xlat13;
					void main()
					{
					    u_xlat0.xy = in_TEXCOORD0.xy * _MainTexture_ST.xy + _MainTexture_ST.zw;
					    u_xlat0 = textureLod(_MainTexture, u_xlat0.xy, 0.0);
					    u_xlat0.xyz = u_xlat0.xyz * _Color.xyz;
					    u_xlat1.xyz = u_xlat0.xyz * vec3(-1.0, -1.0, 1.0);
					    u_xlat2.xy = in_TEXCOORD0.xy * _Heightmap_ST.xy + _Heightmap_ST.zw;
					    u_xlat2 = textureLod(_Heightmap, u_xlat2.xy, 0.0);
					    u_xlat2.xyz = u_xlat2.xyz * vec3(_Bumpiness);
					    u_xlat2.xyz = clamp(u_xlat2.xyz, 0.0, 1.0);
					    u_xlat3.xyz = u_xlat2.xyz + vec3(0.0, 0.0, 1.0);
					    u_xlat2.xyz = u_xlat2.xyz * in_NORMAL0.xyz;
					    u_xlat12 = dot(u_xlat3.xyz, u_xlat1.xyz);
					    u_xlat1.xyz = vec3(u_xlat12) * u_xlat3.xyz;
					    u_xlat1.xyz = u_xlat1.xyz / u_xlat3.zzz;
					    u_xlat0.xyz = (-u_xlat0.xyz) * vec3(-1.0, -1.0, 1.0) + u_xlat1.xyz;
					    u_xlat0.x = dot(u_xlat0.xyz, vec3(0.300000012, 0.589999974, 0.109999999));
					    u_xlat0.xyz = u_xlat2.xyz * u_xlat0.xxx + (-u_xlat2.xyz);
					    u_xlat0.xyz = vec3(vec3(_BumpAttune, _BumpAttune, _BumpAttune)) * u_xlat0.xyz + u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz + in_POSITION0.xyz;
					    u_xlat1 = u_xlat0.yyyy * unity_ObjectToWorld[1];
					    u_xlat1 = unity_ObjectToWorld[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat0 = unity_ObjectToWorld[2] * u_xlat0.zzzz + u_xlat1;
					    u_xlat1 = u_xlat0 + unity_ObjectToWorld[3];
					    vs_TEXCOORD3 = unity_ObjectToWorld[3] * in_POSITION0.wwww + u_xlat0;
					    u_xlat0 = u_xlat1.yyyy * unity_MatrixVP[1];
					    u_xlat0 = unity_MatrixVP[0] * u_xlat1.xxxx + u_xlat0;
					    u_xlat0 = unity_MatrixVP[2] * u_xlat1.zzzz + u_xlat0;
					    u_xlat0 = unity_MatrixVP[3] * u_xlat1.wwww + u_xlat0;
					    gl_Position = u_xlat0;
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
					    vs_TEXCOORD1.xy = in_TEXCOORD1.xy;
					    vs_TEXCOORD2.xy = in_TEXCOORD2.xy;
					    u_xlat1.x = dot(in_NORMAL0.xyz, unity_WorldToObject[0].xyz);
					    u_xlat1.y = dot(in_NORMAL0.xyz, unity_WorldToObject[1].xyz);
					    u_xlat1.z = dot(in_NORMAL0.xyz, unity_WorldToObject[2].xyz);
					    u_xlat13 = dot(u_xlat1.xyz, u_xlat1.xyz);
					    u_xlat13 = inversesqrt(u_xlat13);
					    u_xlat1.xyz = vec3(u_xlat13) * u_xlat1.xyz;
					    vs_TEXCOORD4.xyz = u_xlat1.xyz;
					    u_xlat2.xyz = in_TANGENT0.yyy * unity_ObjectToWorld[1].xyz;
					    u_xlat2.xyz = unity_ObjectToWorld[0].xyz * in_TANGENT0.xxx + u_xlat2.xyz;
					    u_xlat2.xyz = unity_ObjectToWorld[2].xyz * in_TANGENT0.zzz + u_xlat2.xyz;
					    u_xlat13 = dot(u_xlat2.xyz, u_xlat2.xyz);
					    u_xlat13 = inversesqrt(u_xlat13);
					    u_xlat2.xyz = vec3(u_xlat13) * u_xlat2.xyz;
					    vs_TEXCOORD5.xyz = u_xlat2.xyz;
					    u_xlat3.xyz = u_xlat1.zxy * u_xlat2.yzx;
					    u_xlat1.xyz = u_xlat1.yzx * u_xlat2.zxy + (-u_xlat3.xyz);
					    u_xlat1.xyz = u_xlat1.xyz * in_TANGENT0.www;
					    u_xlat13 = dot(u_xlat1.xyz, u_xlat1.xyz);
					    u_xlat13 = inversesqrt(u_xlat13);
					    vs_TEXCOORD6.xyz = vec3(u_xlat13) * u_xlat1.xyz;
					    u_xlat0.y = u_xlat0.y * _ProjectionParams.x;
					    u_xlat1.xzw = u_xlat0.xwy * vec3(0.5, 0.5, 0.5);
					    vs_TEXCOORD8.zw = u_xlat0.zw;
					    vs_TEXCOORD8.xy = u_xlat1.zz + u_xlat1.xw;
					    return;
					}"
				}
				SubProgram "d3d11 " {
					Keywords { "DIRECTIONAL_COOKIE" "SHADOWS_SCREEN" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "DYNAMICLIGHTMAP_OFF" }
					"vs_4_0
					
					#version 330
					#extension GL_ARB_explicit_attrib_location : require
					#extension GL_ARB_explicit_uniform_location : require
					
					#define HLSLCC_ENABLE_UNIFORM_BUFFERS 1
					#if HLSLCC_ENABLE_UNIFORM_BUFFERS
					#define UNITY_UNIFORM
					#else
					#define UNITY_UNIFORM uniform
					#endif
					#define UNITY_SUPPORTS_UNIFORM_LOCATION 1
					#if UNITY_SUPPORTS_UNIFORM_LOCATION
					#define UNITY_LOCATION(x) layout(location = x)
					#define UNITY_BINDING(x) layout(binding = x, std140)
					#else
					#define UNITY_LOCATION(x)
					#define UNITY_BINDING(x) layout(std140)
					#endif
					layout(std140) uniform VGlobals {
						vec4 unused_0_0[2];
						mat4x4 unity_WorldToLight;
						vec4 unused_0_2[2];
						vec4 _MainTexture_ST;
						vec4 unused_0_4[2];
						vec4 _Color;
						vec4 _Heightmap_ST;
						float _Bumpiness;
						float _BumpAttune;
					};
					layout(std140) uniform UnityPerCamera {
						vec4 unused_1_0[5];
						vec4 _ProjectionParams;
						vec4 unused_1_2[3];
					};
					layout(std140) uniform UnityPerDraw {
						mat4x4 unity_ObjectToWorld;
						mat4x4 unity_WorldToObject;
						vec4 unused_2_2[2];
					};
					layout(std140) uniform UnityPerFrame {
						vec4 unused_3_0[17];
						mat4x4 unity_MatrixVP;
						vec4 unused_3_2[2];
					};
					uniform  sampler2D _Heightmap;
					uniform  sampler2D _MainTexture;
					in  vec4 in_POSITION0;
					in  vec3 in_NORMAL0;
					in  vec4 in_TANGENT0;
					in  vec2 in_TEXCOORD0;
					in  vec2 in_TEXCOORD1;
					in  vec2 in_TEXCOORD2;
					out vec2 vs_TEXCOORD0;
					out vec2 vs_TEXCOORD1;
					out vec2 vs_TEXCOORD2;
					out vec2 vs_TEXCOORD7;
					out vec4 vs_TEXCOORD3;
					out vec3 vs_TEXCOORD4;
					out vec3 vs_TEXCOORD5;
					out vec3 vs_TEXCOORD6;
					out vec4 vs_TEXCOORD8;
					vec4 u_xlat0;
					vec4 u_xlat1;
					vec4 u_xlat2;
					vec3 u_xlat3;
					float u_xlat12;
					void main()
					{
					    u_xlat0.xy = in_TEXCOORD0.xy * _MainTexture_ST.xy + _MainTexture_ST.zw;
					    u_xlat0 = textureLod(_MainTexture, u_xlat0.xy, 0.0);
					    u_xlat0.xyz = u_xlat0.xyz * _Color.xyz;
					    u_xlat1.xyz = u_xlat0.xyz * vec3(-1.0, -1.0, 1.0);
					    u_xlat2.xy = in_TEXCOORD0.xy * _Heightmap_ST.xy + _Heightmap_ST.zw;
					    u_xlat2 = textureLod(_Heightmap, u_xlat2.xy, 0.0);
					    u_xlat2.xyz = u_xlat2.xyz * vec3(_Bumpiness);
					    u_xlat2.xyz = clamp(u_xlat2.xyz, 0.0, 1.0);
					    u_xlat3.xyz = u_xlat2.xyz + vec3(0.0, 0.0, 1.0);
					    u_xlat2.xyz = u_xlat2.xyz * in_NORMAL0.xyz;
					    u_xlat12 = dot(u_xlat3.xyz, u_xlat1.xyz);
					    u_xlat1.xyz = vec3(u_xlat12) * u_xlat3.xyz;
					    u_xlat1.xyz = u_xlat1.xyz / u_xlat3.zzz;
					    u_xlat0.xyz = (-u_xlat0.xyz) * vec3(-1.0, -1.0, 1.0) + u_xlat1.xyz;
					    u_xlat0.x = dot(u_xlat0.xyz, vec3(0.300000012, 0.589999974, 0.109999999));
					    u_xlat0.xyz = u_xlat2.xyz * u_xlat0.xxx + (-u_xlat2.xyz);
					    u_xlat0.xyz = vec3(vec3(_BumpAttune, _BumpAttune, _BumpAttune)) * u_xlat0.xyz + u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz + in_POSITION0.xyz;
					    u_xlat1 = u_xlat0.yyyy * unity_ObjectToWorld[1];
					    u_xlat1 = unity_ObjectToWorld[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat0 = unity_ObjectToWorld[2] * u_xlat0.zzzz + u_xlat1;
					    u_xlat1 = u_xlat0 + unity_ObjectToWorld[3];
					    u_xlat0 = unity_ObjectToWorld[3] * in_POSITION0.wwww + u_xlat0;
					    u_xlat2 = u_xlat1.yyyy * unity_MatrixVP[1];
					    u_xlat2 = unity_MatrixVP[0] * u_xlat1.xxxx + u_xlat2;
					    u_xlat2 = unity_MatrixVP[2] * u_xlat1.zzzz + u_xlat2;
					    u_xlat1 = unity_MatrixVP[3] * u_xlat1.wwww + u_xlat2;
					    gl_Position = u_xlat1;
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
					    vs_TEXCOORD1.xy = in_TEXCOORD1.xy;
					    u_xlat2.xy = u_xlat0.yy * unity_WorldToLight[1].xy;
					    u_xlat2.xy = unity_WorldToLight[0].xy * u_xlat0.xx + u_xlat2.xy;
					    u_xlat2.xy = unity_WorldToLight[2].xy * u_xlat0.zz + u_xlat2.xy;
					    vs_TEXCOORD7.xy = unity_WorldToLight[3].xy * u_xlat0.ww + u_xlat2.xy;
					    vs_TEXCOORD3 = u_xlat0;
					    vs_TEXCOORD2.xy = in_TEXCOORD2.xy;
					    u_xlat0.x = dot(in_NORMAL0.xyz, unity_WorldToObject[0].xyz);
					    u_xlat0.y = dot(in_NORMAL0.xyz, unity_WorldToObject[1].xyz);
					    u_xlat0.z = dot(in_NORMAL0.xyz, unity_WorldToObject[2].xyz);
					    u_xlat12 = dot(u_xlat0.xyz, u_xlat0.xyz);
					    u_xlat12 = inversesqrt(u_xlat12);
					    u_xlat0.xyz = vec3(u_xlat12) * u_xlat0.xyz;
					    vs_TEXCOORD4.xyz = u_xlat0.xyz;
					    u_xlat2.xyz = in_TANGENT0.yyy * unity_ObjectToWorld[1].xyz;
					    u_xlat2.xyz = unity_ObjectToWorld[0].xyz * in_TANGENT0.xxx + u_xlat2.xyz;
					    u_xlat2.xyz = unity_ObjectToWorld[2].xyz * in_TANGENT0.zzz + u_xlat2.xyz;
					    u_xlat12 = dot(u_xlat2.xyz, u_xlat2.xyz);
					    u_xlat12 = inversesqrt(u_xlat12);
					    u_xlat2.xyz = vec3(u_xlat12) * u_xlat2.xyz;
					    vs_TEXCOORD5.xyz = u_xlat2.xyz;
					    u_xlat3.xyz = u_xlat0.zxy * u_xlat2.yzx;
					    u_xlat0.xyz = u_xlat0.yzx * u_xlat2.zxy + (-u_xlat3.xyz);
					    u_xlat0.xyz = u_xlat0.xyz * in_TANGENT0.www;
					    u_xlat12 = dot(u_xlat0.xyz, u_xlat0.xyz);
					    u_xlat12 = inversesqrt(u_xlat12);
					    vs_TEXCOORD6.xyz = vec3(u_xlat12) * u_xlat0.xyz;
					    u_xlat0.x = u_xlat1.y * _ProjectionParams.x;
					    u_xlat0.w = u_xlat0.x * 0.5;
					    u_xlat0.xz = u_xlat1.xw * vec2(0.5, 0.5);
					    vs_TEXCOORD8.zw = u_xlat1.zw;
					    vs_TEXCOORD8.xy = u_xlat0.zz + u_xlat0.xw;
					    return;
					}"
				}
				SubProgram "d3d11 " {
					Keywords { "POINT" "SHADOWS_CUBE" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "DYNAMICLIGHTMAP_OFF" }
					"vs_4_0
					
					#version 330
					#extension GL_ARB_explicit_attrib_location : require
					#extension GL_ARB_explicit_uniform_location : require
					
					#define HLSLCC_ENABLE_UNIFORM_BUFFERS 1
					#if HLSLCC_ENABLE_UNIFORM_BUFFERS
					#define UNITY_UNIFORM
					#else
					#define UNITY_UNIFORM uniform
					#endif
					#define UNITY_SUPPORTS_UNIFORM_LOCATION 1
					#if UNITY_SUPPORTS_UNIFORM_LOCATION
					#define UNITY_LOCATION(x) layout(location = x)
					#define UNITY_BINDING(x) layout(binding = x, std140)
					#else
					#define UNITY_LOCATION(x)
					#define UNITY_BINDING(x) layout(std140)
					#endif
					layout(std140) uniform VGlobals {
						vec4 unused_0_0[2];
						mat4x4 unity_WorldToLight;
						vec4 unused_0_2[2];
						vec4 _MainTexture_ST;
						vec4 unused_0_4[2];
						vec4 _Color;
						vec4 _Heightmap_ST;
						float _Bumpiness;
						float _BumpAttune;
					};
					layout(std140) uniform UnityLighting {
						vec4 unused_1_0;
						vec4 _LightPositionRange;
						vec4 unused_1_2[46];
					};
					layout(std140) uniform UnityPerDraw {
						mat4x4 unity_ObjectToWorld;
						mat4x4 unity_WorldToObject;
						vec4 unused_2_2[2];
					};
					layout(std140) uniform UnityPerFrame {
						vec4 unused_3_0[17];
						mat4x4 unity_MatrixVP;
						vec4 unused_3_2[2];
					};
					uniform  sampler2D _Heightmap;
					uniform  sampler2D _MainTexture;
					in  vec4 in_POSITION0;
					in  vec3 in_NORMAL0;
					in  vec4 in_TANGENT0;
					in  vec2 in_TEXCOORD0;
					in  vec2 in_TEXCOORD1;
					in  vec2 in_TEXCOORD2;
					out vec2 vs_TEXCOORD0;
					out vec2 vs_TEXCOORD1;
					out vec2 vs_TEXCOORD2;
					out vec4 vs_TEXCOORD3;
					out vec3 vs_TEXCOORD4;
					out vec3 vs_TEXCOORD5;
					out vec3 vs_TEXCOORD6;
					out vec3 vs_TEXCOORD7;
					out vec3 vs_TEXCOORD8;
					vec4 u_xlat0;
					vec4 u_xlat1;
					vec4 u_xlat2;
					vec3 u_xlat3;
					float u_xlat12;
					float u_xlat13;
					void main()
					{
					    u_xlat0.xy = in_TEXCOORD0.xy * _MainTexture_ST.xy + _MainTexture_ST.zw;
					    u_xlat0 = textureLod(_MainTexture, u_xlat0.xy, 0.0);
					    u_xlat0.xyz = u_xlat0.xyz * _Color.xyz;
					    u_xlat1.xyz = u_xlat0.xyz * vec3(-1.0, -1.0, 1.0);
					    u_xlat2.xy = in_TEXCOORD0.xy * _Heightmap_ST.xy + _Heightmap_ST.zw;
					    u_xlat2 = textureLod(_Heightmap, u_xlat2.xy, 0.0);
					    u_xlat2.xyz = u_xlat2.xyz * vec3(_Bumpiness);
					    u_xlat2.xyz = clamp(u_xlat2.xyz, 0.0, 1.0);
					    u_xlat3.xyz = u_xlat2.xyz + vec3(0.0, 0.0, 1.0);
					    u_xlat2.xyz = u_xlat2.xyz * in_NORMAL0.xyz;
					    u_xlat12 = dot(u_xlat3.xyz, u_xlat1.xyz);
					    u_xlat1.xyz = vec3(u_xlat12) * u_xlat3.xyz;
					    u_xlat1.xyz = u_xlat1.xyz / u_xlat3.zzz;
					    u_xlat0.xyz = (-u_xlat0.xyz) * vec3(-1.0, -1.0, 1.0) + u_xlat1.xyz;
					    u_xlat0.x = dot(u_xlat0.xyz, vec3(0.300000012, 0.589999974, 0.109999999));
					    u_xlat0.xyz = u_xlat2.xyz * u_xlat0.xxx + (-u_xlat2.xyz);
					    u_xlat0.xyz = vec3(vec3(_BumpAttune, _BumpAttune, _BumpAttune)) * u_xlat0.xyz + u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz + in_POSITION0.xyz;
					    u_xlat1 = u_xlat0.yyyy * unity_ObjectToWorld[1];
					    u_xlat1 = unity_ObjectToWorld[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat0 = unity_ObjectToWorld[2] * u_xlat0.zzzz + u_xlat1;
					    u_xlat1 = u_xlat0 + unity_ObjectToWorld[3];
					    u_xlat0 = unity_ObjectToWorld[3] * in_POSITION0.wwww + u_xlat0;
					    u_xlat2 = u_xlat1.yyyy * unity_MatrixVP[1];
					    u_xlat2 = unity_MatrixVP[0] * u_xlat1.xxxx + u_xlat2;
					    u_xlat2 = unity_MatrixVP[2] * u_xlat1.zzzz + u_xlat2;
					    gl_Position = unity_MatrixVP[3] * u_xlat1.wwww + u_xlat2;
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
					    vs_TEXCOORD1.xy = in_TEXCOORD1.xy;
					    vs_TEXCOORD2.xy = in_TEXCOORD2.xy;
					    vs_TEXCOORD3 = u_xlat0;
					    u_xlat1.x = dot(in_NORMAL0.xyz, unity_WorldToObject[0].xyz);
					    u_xlat1.y = dot(in_NORMAL0.xyz, unity_WorldToObject[1].xyz);
					    u_xlat1.z = dot(in_NORMAL0.xyz, unity_WorldToObject[2].xyz);
					    u_xlat13 = dot(u_xlat1.xyz, u_xlat1.xyz);
					    u_xlat13 = inversesqrt(u_xlat13);
					    u_xlat1.xyz = vec3(u_xlat13) * u_xlat1.xyz;
					    vs_TEXCOORD4.xyz = u_xlat1.xyz;
					    u_xlat2.xyz = in_TANGENT0.yyy * unity_ObjectToWorld[1].xyz;
					    u_xlat2.xyz = unity_ObjectToWorld[0].xyz * in_TANGENT0.xxx + u_xlat2.xyz;
					    u_xlat2.xyz = unity_ObjectToWorld[2].xyz * in_TANGENT0.zzz + u_xlat2.xyz;
					    u_xlat13 = dot(u_xlat2.xyz, u_xlat2.xyz);
					    u_xlat13 = inversesqrt(u_xlat13);
					    u_xlat2.xyz = vec3(u_xlat13) * u_xlat2.xyz;
					    vs_TEXCOORD5.xyz = u_xlat2.xyz;
					    u_xlat3.xyz = u_xlat1.zxy * u_xlat2.yzx;
					    u_xlat1.xyz = u_xlat1.yzx * u_xlat2.zxy + (-u_xlat3.xyz);
					    u_xlat1.xyz = u_xlat1.xyz * in_TANGENT0.www;
					    u_xlat13 = dot(u_xlat1.xyz, u_xlat1.xyz);
					    u_xlat13 = inversesqrt(u_xlat13);
					    vs_TEXCOORD6.xyz = vec3(u_xlat13) * u_xlat1.xyz;
					    u_xlat1.xyz = u_xlat0.yyy * unity_WorldToLight[1].xyz;
					    u_xlat1.xyz = unity_WorldToLight[0].xyz * u_xlat0.xxx + u_xlat1.xyz;
					    u_xlat1.xyz = unity_WorldToLight[2].xyz * u_xlat0.zzz + u_xlat1.xyz;
					    vs_TEXCOORD7.xyz = unity_WorldToLight[3].xyz * u_xlat0.www + u_xlat1.xyz;
					    vs_TEXCOORD8.xyz = u_xlat0.xyz + (-_LightPositionRange.xyz);
					    return;
					}"
				}
				SubProgram "d3d11 " {
					Keywords { "POINT" "SHADOWS_CUBE" "SHADOWS_SOFT" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "DYNAMICLIGHTMAP_OFF" }
					"vs_4_0
					
					#version 330
					#extension GL_ARB_explicit_attrib_location : require
					#extension GL_ARB_explicit_uniform_location : require
					
					#define HLSLCC_ENABLE_UNIFORM_BUFFERS 1
					#if HLSLCC_ENABLE_UNIFORM_BUFFERS
					#define UNITY_UNIFORM
					#else
					#define UNITY_UNIFORM uniform
					#endif
					#define UNITY_SUPPORTS_UNIFORM_LOCATION 1
					#if UNITY_SUPPORTS_UNIFORM_LOCATION
					#define UNITY_LOCATION(x) layout(location = x)
					#define UNITY_BINDING(x) layout(binding = x, std140)
					#else
					#define UNITY_LOCATION(x)
					#define UNITY_BINDING(x) layout(std140)
					#endif
					layout(std140) uniform VGlobals {
						vec4 unused_0_0[2];
						mat4x4 unity_WorldToLight;
						vec4 unused_0_2[2];
						vec4 _MainTexture_ST;
						vec4 unused_0_4[2];
						vec4 _Color;
						vec4 _Heightmap_ST;
						float _Bumpiness;
						float _BumpAttune;
					};
					layout(std140) uniform UnityLighting {
						vec4 unused_1_0;
						vec4 _LightPositionRange;
						vec4 unused_1_2[46];
					};
					layout(std140) uniform UnityPerDraw {
						mat4x4 unity_ObjectToWorld;
						mat4x4 unity_WorldToObject;
						vec4 unused_2_2[2];
					};
					layout(std140) uniform UnityPerFrame {
						vec4 unused_3_0[17];
						mat4x4 unity_MatrixVP;
						vec4 unused_3_2[2];
					};
					uniform  sampler2D _Heightmap;
					uniform  sampler2D _MainTexture;
					in  vec4 in_POSITION0;
					in  vec3 in_NORMAL0;
					in  vec4 in_TANGENT0;
					in  vec2 in_TEXCOORD0;
					in  vec2 in_TEXCOORD1;
					in  vec2 in_TEXCOORD2;
					out vec2 vs_TEXCOORD0;
					out vec2 vs_TEXCOORD1;
					out vec2 vs_TEXCOORD2;
					out vec4 vs_TEXCOORD3;
					out vec3 vs_TEXCOORD4;
					out vec3 vs_TEXCOORD5;
					out vec3 vs_TEXCOORD6;
					out vec3 vs_TEXCOORD7;
					out vec3 vs_TEXCOORD8;
					vec4 u_xlat0;
					vec4 u_xlat1;
					vec4 u_xlat2;
					vec3 u_xlat3;
					float u_xlat12;
					float u_xlat13;
					void main()
					{
					    u_xlat0.xy = in_TEXCOORD0.xy * _MainTexture_ST.xy + _MainTexture_ST.zw;
					    u_xlat0 = textureLod(_MainTexture, u_xlat0.xy, 0.0);
					    u_xlat0.xyz = u_xlat0.xyz * _Color.xyz;
					    u_xlat1.xyz = u_xlat0.xyz * vec3(-1.0, -1.0, 1.0);
					    u_xlat2.xy = in_TEXCOORD0.xy * _Heightmap_ST.xy + _Heightmap_ST.zw;
					    u_xlat2 = textureLod(_Heightmap, u_xlat2.xy, 0.0);
					    u_xlat2.xyz = u_xlat2.xyz * vec3(_Bumpiness);
					    u_xlat2.xyz = clamp(u_xlat2.xyz, 0.0, 1.0);
					    u_xlat3.xyz = u_xlat2.xyz + vec3(0.0, 0.0, 1.0);
					    u_xlat2.xyz = u_xlat2.xyz * in_NORMAL0.xyz;
					    u_xlat12 = dot(u_xlat3.xyz, u_xlat1.xyz);
					    u_xlat1.xyz = vec3(u_xlat12) * u_xlat3.xyz;
					    u_xlat1.xyz = u_xlat1.xyz / u_xlat3.zzz;
					    u_xlat0.xyz = (-u_xlat0.xyz) * vec3(-1.0, -1.0, 1.0) + u_xlat1.xyz;
					    u_xlat0.x = dot(u_xlat0.xyz, vec3(0.300000012, 0.589999974, 0.109999999));
					    u_xlat0.xyz = u_xlat2.xyz * u_xlat0.xxx + (-u_xlat2.xyz);
					    u_xlat0.xyz = vec3(vec3(_BumpAttune, _BumpAttune, _BumpAttune)) * u_xlat0.xyz + u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz + in_POSITION0.xyz;
					    u_xlat1 = u_xlat0.yyyy * unity_ObjectToWorld[1];
					    u_xlat1 = unity_ObjectToWorld[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat0 = unity_ObjectToWorld[2] * u_xlat0.zzzz + u_xlat1;
					    u_xlat1 = u_xlat0 + unity_ObjectToWorld[3];
					    u_xlat0 = unity_ObjectToWorld[3] * in_POSITION0.wwww + u_xlat0;
					    u_xlat2 = u_xlat1.yyyy * unity_MatrixVP[1];
					    u_xlat2 = unity_MatrixVP[0] * u_xlat1.xxxx + u_xlat2;
					    u_xlat2 = unity_MatrixVP[2] * u_xlat1.zzzz + u_xlat2;
					    gl_Position = unity_MatrixVP[3] * u_xlat1.wwww + u_xlat2;
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
					    vs_TEXCOORD1.xy = in_TEXCOORD1.xy;
					    vs_TEXCOORD2.xy = in_TEXCOORD2.xy;
					    vs_TEXCOORD3 = u_xlat0;
					    u_xlat1.x = dot(in_NORMAL0.xyz, unity_WorldToObject[0].xyz);
					    u_xlat1.y = dot(in_NORMAL0.xyz, unity_WorldToObject[1].xyz);
					    u_xlat1.z = dot(in_NORMAL0.xyz, unity_WorldToObject[2].xyz);
					    u_xlat13 = dot(u_xlat1.xyz, u_xlat1.xyz);
					    u_xlat13 = inversesqrt(u_xlat13);
					    u_xlat1.xyz = vec3(u_xlat13) * u_xlat1.xyz;
					    vs_TEXCOORD4.xyz = u_xlat1.xyz;
					    u_xlat2.xyz = in_TANGENT0.yyy * unity_ObjectToWorld[1].xyz;
					    u_xlat2.xyz = unity_ObjectToWorld[0].xyz * in_TANGENT0.xxx + u_xlat2.xyz;
					    u_xlat2.xyz = unity_ObjectToWorld[2].xyz * in_TANGENT0.zzz + u_xlat2.xyz;
					    u_xlat13 = dot(u_xlat2.xyz, u_xlat2.xyz);
					    u_xlat13 = inversesqrt(u_xlat13);
					    u_xlat2.xyz = vec3(u_xlat13) * u_xlat2.xyz;
					    vs_TEXCOORD5.xyz = u_xlat2.xyz;
					    u_xlat3.xyz = u_xlat1.zxy * u_xlat2.yzx;
					    u_xlat1.xyz = u_xlat1.yzx * u_xlat2.zxy + (-u_xlat3.xyz);
					    u_xlat1.xyz = u_xlat1.xyz * in_TANGENT0.www;
					    u_xlat13 = dot(u_xlat1.xyz, u_xlat1.xyz);
					    u_xlat13 = inversesqrt(u_xlat13);
					    vs_TEXCOORD6.xyz = vec3(u_xlat13) * u_xlat1.xyz;
					    u_xlat1.xyz = u_xlat0.yyy * unity_WorldToLight[1].xyz;
					    u_xlat1.xyz = unity_WorldToLight[0].xyz * u_xlat0.xxx + u_xlat1.xyz;
					    u_xlat1.xyz = unity_WorldToLight[2].xyz * u_xlat0.zzz + u_xlat1.xyz;
					    vs_TEXCOORD7.xyz = unity_WorldToLight[3].xyz * u_xlat0.www + u_xlat1.xyz;
					    vs_TEXCOORD8.xyz = u_xlat0.xyz + (-_LightPositionRange.xyz);
					    return;
					}"
				}
				SubProgram "d3d11 " {
					Keywords { "POINT_COOKIE" "SHADOWS_CUBE" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "DYNAMICLIGHTMAP_OFF" }
					"vs_4_0
					
					#version 330
					#extension GL_ARB_explicit_attrib_location : require
					#extension GL_ARB_explicit_uniform_location : require
					
					#define HLSLCC_ENABLE_UNIFORM_BUFFERS 1
					#if HLSLCC_ENABLE_UNIFORM_BUFFERS
					#define UNITY_UNIFORM
					#else
					#define UNITY_UNIFORM uniform
					#endif
					#define UNITY_SUPPORTS_UNIFORM_LOCATION 1
					#if UNITY_SUPPORTS_UNIFORM_LOCATION
					#define UNITY_LOCATION(x) layout(location = x)
					#define UNITY_BINDING(x) layout(binding = x, std140)
					#else
					#define UNITY_LOCATION(x)
					#define UNITY_BINDING(x) layout(std140)
					#endif
					layout(std140) uniform VGlobals {
						vec4 unused_0_0[2];
						mat4x4 unity_WorldToLight;
						vec4 unused_0_2[2];
						vec4 _MainTexture_ST;
						vec4 unused_0_4[2];
						vec4 _Color;
						vec4 _Heightmap_ST;
						float _Bumpiness;
						float _BumpAttune;
					};
					layout(std140) uniform UnityLighting {
						vec4 unused_1_0;
						vec4 _LightPositionRange;
						vec4 unused_1_2[46];
					};
					layout(std140) uniform UnityPerDraw {
						mat4x4 unity_ObjectToWorld;
						mat4x4 unity_WorldToObject;
						vec4 unused_2_2[2];
					};
					layout(std140) uniform UnityPerFrame {
						vec4 unused_3_0[17];
						mat4x4 unity_MatrixVP;
						vec4 unused_3_2[2];
					};
					uniform  sampler2D _Heightmap;
					uniform  sampler2D _MainTexture;
					in  vec4 in_POSITION0;
					in  vec3 in_NORMAL0;
					in  vec4 in_TANGENT0;
					in  vec2 in_TEXCOORD0;
					in  vec2 in_TEXCOORD1;
					in  vec2 in_TEXCOORD2;
					out vec2 vs_TEXCOORD0;
					out vec2 vs_TEXCOORD1;
					out vec2 vs_TEXCOORD2;
					out vec4 vs_TEXCOORD3;
					out vec3 vs_TEXCOORD4;
					out vec3 vs_TEXCOORD5;
					out vec3 vs_TEXCOORD6;
					out vec3 vs_TEXCOORD7;
					out vec3 vs_TEXCOORD8;
					vec4 u_xlat0;
					vec4 u_xlat1;
					vec4 u_xlat2;
					vec3 u_xlat3;
					float u_xlat12;
					float u_xlat13;
					void main()
					{
					    u_xlat0.xy = in_TEXCOORD0.xy * _MainTexture_ST.xy + _MainTexture_ST.zw;
					    u_xlat0 = textureLod(_MainTexture, u_xlat0.xy, 0.0);
					    u_xlat0.xyz = u_xlat0.xyz * _Color.xyz;
					    u_xlat1.xyz = u_xlat0.xyz * vec3(-1.0, -1.0, 1.0);
					    u_xlat2.xy = in_TEXCOORD0.xy * _Heightmap_ST.xy + _Heightmap_ST.zw;
					    u_xlat2 = textureLod(_Heightmap, u_xlat2.xy, 0.0);
					    u_xlat2.xyz = u_xlat2.xyz * vec3(_Bumpiness);
					    u_xlat2.xyz = clamp(u_xlat2.xyz, 0.0, 1.0);
					    u_xlat3.xyz = u_xlat2.xyz + vec3(0.0, 0.0, 1.0);
					    u_xlat2.xyz = u_xlat2.xyz * in_NORMAL0.xyz;
					    u_xlat12 = dot(u_xlat3.xyz, u_xlat1.xyz);
					    u_xlat1.xyz = vec3(u_xlat12) * u_xlat3.xyz;
					    u_xlat1.xyz = u_xlat1.xyz / u_xlat3.zzz;
					    u_xlat0.xyz = (-u_xlat0.xyz) * vec3(-1.0, -1.0, 1.0) + u_xlat1.xyz;
					    u_xlat0.x = dot(u_xlat0.xyz, vec3(0.300000012, 0.589999974, 0.109999999));
					    u_xlat0.xyz = u_xlat2.xyz * u_xlat0.xxx + (-u_xlat2.xyz);
					    u_xlat0.xyz = vec3(vec3(_BumpAttune, _BumpAttune, _BumpAttune)) * u_xlat0.xyz + u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz + in_POSITION0.xyz;
					    u_xlat1 = u_xlat0.yyyy * unity_ObjectToWorld[1];
					    u_xlat1 = unity_ObjectToWorld[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat0 = unity_ObjectToWorld[2] * u_xlat0.zzzz + u_xlat1;
					    u_xlat1 = u_xlat0 + unity_ObjectToWorld[3];
					    u_xlat0 = unity_ObjectToWorld[3] * in_POSITION0.wwww + u_xlat0;
					    u_xlat2 = u_xlat1.yyyy * unity_MatrixVP[1];
					    u_xlat2 = unity_MatrixVP[0] * u_xlat1.xxxx + u_xlat2;
					    u_xlat2 = unity_MatrixVP[2] * u_xlat1.zzzz + u_xlat2;
					    gl_Position = unity_MatrixVP[3] * u_xlat1.wwww + u_xlat2;
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
					    vs_TEXCOORD1.xy = in_TEXCOORD1.xy;
					    vs_TEXCOORD2.xy = in_TEXCOORD2.xy;
					    vs_TEXCOORD3 = u_xlat0;
					    u_xlat1.x = dot(in_NORMAL0.xyz, unity_WorldToObject[0].xyz);
					    u_xlat1.y = dot(in_NORMAL0.xyz, unity_WorldToObject[1].xyz);
					    u_xlat1.z = dot(in_NORMAL0.xyz, unity_WorldToObject[2].xyz);
					    u_xlat13 = dot(u_xlat1.xyz, u_xlat1.xyz);
					    u_xlat13 = inversesqrt(u_xlat13);
					    u_xlat1.xyz = vec3(u_xlat13) * u_xlat1.xyz;
					    vs_TEXCOORD4.xyz = u_xlat1.xyz;
					    u_xlat2.xyz = in_TANGENT0.yyy * unity_ObjectToWorld[1].xyz;
					    u_xlat2.xyz = unity_ObjectToWorld[0].xyz * in_TANGENT0.xxx + u_xlat2.xyz;
					    u_xlat2.xyz = unity_ObjectToWorld[2].xyz * in_TANGENT0.zzz + u_xlat2.xyz;
					    u_xlat13 = dot(u_xlat2.xyz, u_xlat2.xyz);
					    u_xlat13 = inversesqrt(u_xlat13);
					    u_xlat2.xyz = vec3(u_xlat13) * u_xlat2.xyz;
					    vs_TEXCOORD5.xyz = u_xlat2.xyz;
					    u_xlat3.xyz = u_xlat1.zxy * u_xlat2.yzx;
					    u_xlat1.xyz = u_xlat1.yzx * u_xlat2.zxy + (-u_xlat3.xyz);
					    u_xlat1.xyz = u_xlat1.xyz * in_TANGENT0.www;
					    u_xlat13 = dot(u_xlat1.xyz, u_xlat1.xyz);
					    u_xlat13 = inversesqrt(u_xlat13);
					    vs_TEXCOORD6.xyz = vec3(u_xlat13) * u_xlat1.xyz;
					    u_xlat1.xyz = u_xlat0.yyy * unity_WorldToLight[1].xyz;
					    u_xlat1.xyz = unity_WorldToLight[0].xyz * u_xlat0.xxx + u_xlat1.xyz;
					    u_xlat1.xyz = unity_WorldToLight[2].xyz * u_xlat0.zzz + u_xlat1.xyz;
					    vs_TEXCOORD7.xyz = unity_WorldToLight[3].xyz * u_xlat0.www + u_xlat1.xyz;
					    vs_TEXCOORD8.xyz = u_xlat0.xyz + (-_LightPositionRange.xyz);
					    return;
					}"
				}
				SubProgram "d3d11 " {
					Keywords { "POINT_COOKIE" "SHADOWS_CUBE" "SHADOWS_SOFT" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "DYNAMICLIGHTMAP_OFF" }
					"vs_4_0
					
					#version 330
					#extension GL_ARB_explicit_attrib_location : require
					#extension GL_ARB_explicit_uniform_location : require
					
					#define HLSLCC_ENABLE_UNIFORM_BUFFERS 1
					#if HLSLCC_ENABLE_UNIFORM_BUFFERS
					#define UNITY_UNIFORM
					#else
					#define UNITY_UNIFORM uniform
					#endif
					#define UNITY_SUPPORTS_UNIFORM_LOCATION 1
					#if UNITY_SUPPORTS_UNIFORM_LOCATION
					#define UNITY_LOCATION(x) layout(location = x)
					#define UNITY_BINDING(x) layout(binding = x, std140)
					#else
					#define UNITY_LOCATION(x)
					#define UNITY_BINDING(x) layout(std140)
					#endif
					layout(std140) uniform VGlobals {
						vec4 unused_0_0[2];
						mat4x4 unity_WorldToLight;
						vec4 unused_0_2[2];
						vec4 _MainTexture_ST;
						vec4 unused_0_4[2];
						vec4 _Color;
						vec4 _Heightmap_ST;
						float _Bumpiness;
						float _BumpAttune;
					};
					layout(std140) uniform UnityLighting {
						vec4 unused_1_0;
						vec4 _LightPositionRange;
						vec4 unused_1_2[46];
					};
					layout(std140) uniform UnityPerDraw {
						mat4x4 unity_ObjectToWorld;
						mat4x4 unity_WorldToObject;
						vec4 unused_2_2[2];
					};
					layout(std140) uniform UnityPerFrame {
						vec4 unused_3_0[17];
						mat4x4 unity_MatrixVP;
						vec4 unused_3_2[2];
					};
					uniform  sampler2D _Heightmap;
					uniform  sampler2D _MainTexture;
					in  vec4 in_POSITION0;
					in  vec3 in_NORMAL0;
					in  vec4 in_TANGENT0;
					in  vec2 in_TEXCOORD0;
					in  vec2 in_TEXCOORD1;
					in  vec2 in_TEXCOORD2;
					out vec2 vs_TEXCOORD0;
					out vec2 vs_TEXCOORD1;
					out vec2 vs_TEXCOORD2;
					out vec4 vs_TEXCOORD3;
					out vec3 vs_TEXCOORD4;
					out vec3 vs_TEXCOORD5;
					out vec3 vs_TEXCOORD6;
					out vec3 vs_TEXCOORD7;
					out vec3 vs_TEXCOORD8;
					vec4 u_xlat0;
					vec4 u_xlat1;
					vec4 u_xlat2;
					vec3 u_xlat3;
					float u_xlat12;
					float u_xlat13;
					void main()
					{
					    u_xlat0.xy = in_TEXCOORD0.xy * _MainTexture_ST.xy + _MainTexture_ST.zw;
					    u_xlat0 = textureLod(_MainTexture, u_xlat0.xy, 0.0);
					    u_xlat0.xyz = u_xlat0.xyz * _Color.xyz;
					    u_xlat1.xyz = u_xlat0.xyz * vec3(-1.0, -1.0, 1.0);
					    u_xlat2.xy = in_TEXCOORD0.xy * _Heightmap_ST.xy + _Heightmap_ST.zw;
					    u_xlat2 = textureLod(_Heightmap, u_xlat2.xy, 0.0);
					    u_xlat2.xyz = u_xlat2.xyz * vec3(_Bumpiness);
					    u_xlat2.xyz = clamp(u_xlat2.xyz, 0.0, 1.0);
					    u_xlat3.xyz = u_xlat2.xyz + vec3(0.0, 0.0, 1.0);
					    u_xlat2.xyz = u_xlat2.xyz * in_NORMAL0.xyz;
					    u_xlat12 = dot(u_xlat3.xyz, u_xlat1.xyz);
					    u_xlat1.xyz = vec3(u_xlat12) * u_xlat3.xyz;
					    u_xlat1.xyz = u_xlat1.xyz / u_xlat3.zzz;
					    u_xlat0.xyz = (-u_xlat0.xyz) * vec3(-1.0, -1.0, 1.0) + u_xlat1.xyz;
					    u_xlat0.x = dot(u_xlat0.xyz, vec3(0.300000012, 0.589999974, 0.109999999));
					    u_xlat0.xyz = u_xlat2.xyz * u_xlat0.xxx + (-u_xlat2.xyz);
					    u_xlat0.xyz = vec3(vec3(_BumpAttune, _BumpAttune, _BumpAttune)) * u_xlat0.xyz + u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz + in_POSITION0.xyz;
					    u_xlat1 = u_xlat0.yyyy * unity_ObjectToWorld[1];
					    u_xlat1 = unity_ObjectToWorld[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat0 = unity_ObjectToWorld[2] * u_xlat0.zzzz + u_xlat1;
					    u_xlat1 = u_xlat0 + unity_ObjectToWorld[3];
					    u_xlat0 = unity_ObjectToWorld[3] * in_POSITION0.wwww + u_xlat0;
					    u_xlat2 = u_xlat1.yyyy * unity_MatrixVP[1];
					    u_xlat2 = unity_MatrixVP[0] * u_xlat1.xxxx + u_xlat2;
					    u_xlat2 = unity_MatrixVP[2] * u_xlat1.zzzz + u_xlat2;
					    gl_Position = unity_MatrixVP[3] * u_xlat1.wwww + u_xlat2;
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
					    vs_TEXCOORD1.xy = in_TEXCOORD1.xy;
					    vs_TEXCOORD2.xy = in_TEXCOORD2.xy;
					    vs_TEXCOORD3 = u_xlat0;
					    u_xlat1.x = dot(in_NORMAL0.xyz, unity_WorldToObject[0].xyz);
					    u_xlat1.y = dot(in_NORMAL0.xyz, unity_WorldToObject[1].xyz);
					    u_xlat1.z = dot(in_NORMAL0.xyz, unity_WorldToObject[2].xyz);
					    u_xlat13 = dot(u_xlat1.xyz, u_xlat1.xyz);
					    u_xlat13 = inversesqrt(u_xlat13);
					    u_xlat1.xyz = vec3(u_xlat13) * u_xlat1.xyz;
					    vs_TEXCOORD4.xyz = u_xlat1.xyz;
					    u_xlat2.xyz = in_TANGENT0.yyy * unity_ObjectToWorld[1].xyz;
					    u_xlat2.xyz = unity_ObjectToWorld[0].xyz * in_TANGENT0.xxx + u_xlat2.xyz;
					    u_xlat2.xyz = unity_ObjectToWorld[2].xyz * in_TANGENT0.zzz + u_xlat2.xyz;
					    u_xlat13 = dot(u_xlat2.xyz, u_xlat2.xyz);
					    u_xlat13 = inversesqrt(u_xlat13);
					    u_xlat2.xyz = vec3(u_xlat13) * u_xlat2.xyz;
					    vs_TEXCOORD5.xyz = u_xlat2.xyz;
					    u_xlat3.xyz = u_xlat1.zxy * u_xlat2.yzx;
					    u_xlat1.xyz = u_xlat1.yzx * u_xlat2.zxy + (-u_xlat3.xyz);
					    u_xlat1.xyz = u_xlat1.xyz * in_TANGENT0.www;
					    u_xlat13 = dot(u_xlat1.xyz, u_xlat1.xyz);
					    u_xlat13 = inversesqrt(u_xlat13);
					    vs_TEXCOORD6.xyz = vec3(u_xlat13) * u_xlat1.xyz;
					    u_xlat1.xyz = u_xlat0.yyy * unity_WorldToLight[1].xyz;
					    u_xlat1.xyz = unity_WorldToLight[0].xyz * u_xlat0.xxx + u_xlat1.xyz;
					    u_xlat1.xyz = unity_WorldToLight[2].xyz * u_xlat0.zzz + u_xlat1.xyz;
					    vs_TEXCOORD7.xyz = unity_WorldToLight[3].xyz * u_xlat0.www + u_xlat1.xyz;
					    vs_TEXCOORD8.xyz = u_xlat0.xyz + (-_LightPositionRange.xyz);
					    return;
					}"
				}
				SubProgram "d3d11 " {
					Keywords { "POINT" "DIRLIGHTMAP_COMBINED" "LIGHTMAP_OFF" "DYNAMICLIGHTMAP_OFF" }
					"vs_4_0
					
					#version 330
					#extension GL_ARB_explicit_attrib_location : require
					#extension GL_ARB_explicit_uniform_location : require
					
					#define HLSLCC_ENABLE_UNIFORM_BUFFERS 1
					#if HLSLCC_ENABLE_UNIFORM_BUFFERS
					#define UNITY_UNIFORM
					#else
					#define UNITY_UNIFORM uniform
					#endif
					#define UNITY_SUPPORTS_UNIFORM_LOCATION 1
					#if UNITY_SUPPORTS_UNIFORM_LOCATION
					#define UNITY_LOCATION(x) layout(location = x)
					#define UNITY_BINDING(x) layout(binding = x, std140)
					#else
					#define UNITY_LOCATION(x)
					#define UNITY_BINDING(x) layout(std140)
					#endif
					layout(std140) uniform VGlobals {
						vec4 unused_0_0[2];
						mat4x4 unity_WorldToLight;
						vec4 unused_0_2[2];
						vec4 _MainTexture_ST;
						vec4 unused_0_4[2];
						vec4 _Color;
						vec4 _Heightmap_ST;
						float _Bumpiness;
						float _BumpAttune;
					};
					layout(std140) uniform UnityPerDraw {
						mat4x4 unity_ObjectToWorld;
						mat4x4 unity_WorldToObject;
						vec4 unused_1_2[2];
					};
					layout(std140) uniform UnityPerFrame {
						vec4 unused_2_0[17];
						mat4x4 unity_MatrixVP;
						vec4 unused_2_2[2];
					};
					uniform  sampler2D _Heightmap;
					uniform  sampler2D _MainTexture;
					in  vec4 in_POSITION0;
					in  vec3 in_NORMAL0;
					in  vec4 in_TANGENT0;
					in  vec2 in_TEXCOORD0;
					in  vec2 in_TEXCOORD1;
					in  vec2 in_TEXCOORD2;
					out vec2 vs_TEXCOORD0;
					out vec2 vs_TEXCOORD1;
					out vec2 vs_TEXCOORD2;
					out vec4 vs_TEXCOORD3;
					out vec3 vs_TEXCOORD4;
					out vec3 vs_TEXCOORD5;
					out vec3 vs_TEXCOORD6;
					out vec3 vs_TEXCOORD7;
					vec4 u_xlat0;
					vec4 u_xlat1;
					vec4 u_xlat2;
					vec3 u_xlat3;
					float u_xlat12;
					float u_xlat13;
					void main()
					{
					    u_xlat0.xy = in_TEXCOORD0.xy * _MainTexture_ST.xy + _MainTexture_ST.zw;
					    u_xlat0 = textureLod(_MainTexture, u_xlat0.xy, 0.0);
					    u_xlat0.xyz = u_xlat0.xyz * _Color.xyz;
					    u_xlat1.xyz = u_xlat0.xyz * vec3(-1.0, -1.0, 1.0);
					    u_xlat2.xy = in_TEXCOORD0.xy * _Heightmap_ST.xy + _Heightmap_ST.zw;
					    u_xlat2 = textureLod(_Heightmap, u_xlat2.xy, 0.0);
					    u_xlat2.xyz = u_xlat2.xyz * vec3(_Bumpiness);
					    u_xlat2.xyz = clamp(u_xlat2.xyz, 0.0, 1.0);
					    u_xlat3.xyz = u_xlat2.xyz + vec3(0.0, 0.0, 1.0);
					    u_xlat2.xyz = u_xlat2.xyz * in_NORMAL0.xyz;
					    u_xlat12 = dot(u_xlat3.xyz, u_xlat1.xyz);
					    u_xlat1.xyz = vec3(u_xlat12) * u_xlat3.xyz;
					    u_xlat1.xyz = u_xlat1.xyz / u_xlat3.zzz;
					    u_xlat0.xyz = (-u_xlat0.xyz) * vec3(-1.0, -1.0, 1.0) + u_xlat1.xyz;
					    u_xlat0.x = dot(u_xlat0.xyz, vec3(0.300000012, 0.589999974, 0.109999999));
					    u_xlat0.xyz = u_xlat2.xyz * u_xlat0.xxx + (-u_xlat2.xyz);
					    u_xlat0.xyz = vec3(vec3(_BumpAttune, _BumpAttune, _BumpAttune)) * u_xlat0.xyz + u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz + in_POSITION0.xyz;
					    u_xlat1 = u_xlat0.yyyy * unity_ObjectToWorld[1];
					    u_xlat1 = unity_ObjectToWorld[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat0 = unity_ObjectToWorld[2] * u_xlat0.zzzz + u_xlat1;
					    u_xlat1 = u_xlat0 + unity_ObjectToWorld[3];
					    u_xlat0 = unity_ObjectToWorld[3] * in_POSITION0.wwww + u_xlat0;
					    u_xlat2 = u_xlat1.yyyy * unity_MatrixVP[1];
					    u_xlat2 = unity_MatrixVP[0] * u_xlat1.xxxx + u_xlat2;
					    u_xlat2 = unity_MatrixVP[2] * u_xlat1.zzzz + u_xlat2;
					    gl_Position = unity_MatrixVP[3] * u_xlat1.wwww + u_xlat2;
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
					    vs_TEXCOORD1.xy = in_TEXCOORD1.xy;
					    vs_TEXCOORD2.xy = in_TEXCOORD2.xy;
					    vs_TEXCOORD3 = u_xlat0;
					    u_xlat1.x = dot(in_NORMAL0.xyz, unity_WorldToObject[0].xyz);
					    u_xlat1.y = dot(in_NORMAL0.xyz, unity_WorldToObject[1].xyz);
					    u_xlat1.z = dot(in_NORMAL0.xyz, unity_WorldToObject[2].xyz);
					    u_xlat13 = dot(u_xlat1.xyz, u_xlat1.xyz);
					    u_xlat13 = inversesqrt(u_xlat13);
					    u_xlat1.xyz = vec3(u_xlat13) * u_xlat1.xyz;
					    vs_TEXCOORD4.xyz = u_xlat1.xyz;
					    u_xlat2.xyz = in_TANGENT0.yyy * unity_ObjectToWorld[1].xyz;
					    u_xlat2.xyz = unity_ObjectToWorld[0].xyz * in_TANGENT0.xxx + u_xlat2.xyz;
					    u_xlat2.xyz = unity_ObjectToWorld[2].xyz * in_TANGENT0.zzz + u_xlat2.xyz;
					    u_xlat13 = dot(u_xlat2.xyz, u_xlat2.xyz);
					    u_xlat13 = inversesqrt(u_xlat13);
					    u_xlat2.xyz = vec3(u_xlat13) * u_xlat2.xyz;
					    vs_TEXCOORD5.xyz = u_xlat2.xyz;
					    u_xlat3.xyz = u_xlat1.zxy * u_xlat2.yzx;
					    u_xlat1.xyz = u_xlat1.yzx * u_xlat2.zxy + (-u_xlat3.xyz);
					    u_xlat1.xyz = u_xlat1.xyz * in_TANGENT0.www;
					    u_xlat13 = dot(u_xlat1.xyz, u_xlat1.xyz);
					    u_xlat13 = inversesqrt(u_xlat13);
					    vs_TEXCOORD6.xyz = vec3(u_xlat13) * u_xlat1.xyz;
					    u_xlat1.xyz = u_xlat0.yyy * unity_WorldToLight[1].xyz;
					    u_xlat1.xyz = unity_WorldToLight[0].xyz * u_xlat0.xxx + u_xlat1.xyz;
					    u_xlat0.xyz = unity_WorldToLight[2].xyz * u_xlat0.zzz + u_xlat1.xyz;
					    vs_TEXCOORD7.xyz = unity_WorldToLight[3].xyz * u_xlat0.www + u_xlat0.xyz;
					    return;
					}"
				}
				SubProgram "d3d11 " {
					Keywords { "DIRECTIONAL" "DIRLIGHTMAP_COMBINED" "LIGHTMAP_OFF" "DYNAMICLIGHTMAP_OFF" }
					"vs_4_0
					
					#version 330
					#extension GL_ARB_explicit_attrib_location : require
					#extension GL_ARB_explicit_uniform_location : require
					
					#define HLSLCC_ENABLE_UNIFORM_BUFFERS 1
					#if HLSLCC_ENABLE_UNIFORM_BUFFERS
					#define UNITY_UNIFORM
					#else
					#define UNITY_UNIFORM uniform
					#endif
					#define UNITY_SUPPORTS_UNIFORM_LOCATION 1
					#if UNITY_SUPPORTS_UNIFORM_LOCATION
					#define UNITY_LOCATION(x) layout(location = x)
					#define UNITY_BINDING(x) layout(binding = x, std140)
					#else
					#define UNITY_LOCATION(x)
					#define UNITY_BINDING(x) layout(std140)
					#endif
					layout(std140) uniform VGlobals {
						vec4 unused_0_0[4];
						vec4 _MainTexture_ST;
						vec4 unused_0_2[2];
						vec4 _Color;
						vec4 _Heightmap_ST;
						float _Bumpiness;
						float _BumpAttune;
					};
					layout(std140) uniform UnityPerDraw {
						mat4x4 unity_ObjectToWorld;
						mat4x4 unity_WorldToObject;
						vec4 unused_1_2[2];
					};
					layout(std140) uniform UnityPerFrame {
						vec4 unused_2_0[17];
						mat4x4 unity_MatrixVP;
						vec4 unused_2_2[2];
					};
					uniform  sampler2D _Heightmap;
					uniform  sampler2D _MainTexture;
					in  vec4 in_POSITION0;
					in  vec3 in_NORMAL0;
					in  vec4 in_TANGENT0;
					in  vec2 in_TEXCOORD0;
					in  vec2 in_TEXCOORD1;
					in  vec2 in_TEXCOORD2;
					out vec2 vs_TEXCOORD0;
					out vec2 vs_TEXCOORD1;
					out vec2 vs_TEXCOORD2;
					out vec4 vs_TEXCOORD3;
					out vec3 vs_TEXCOORD4;
					out vec3 vs_TEXCOORD5;
					out vec3 vs_TEXCOORD6;
					vec4 u_xlat0;
					vec4 u_xlat1;
					vec4 u_xlat2;
					vec3 u_xlat3;
					float u_xlat12;
					void main()
					{
					    u_xlat0.xy = in_TEXCOORD0.xy * _MainTexture_ST.xy + _MainTexture_ST.zw;
					    u_xlat0 = textureLod(_MainTexture, u_xlat0.xy, 0.0);
					    u_xlat0.xyz = u_xlat0.xyz * _Color.xyz;
					    u_xlat1.xyz = u_xlat0.xyz * vec3(-1.0, -1.0, 1.0);
					    u_xlat2.xy = in_TEXCOORD0.xy * _Heightmap_ST.xy + _Heightmap_ST.zw;
					    u_xlat2 = textureLod(_Heightmap, u_xlat2.xy, 0.0);
					    u_xlat2.xyz = u_xlat2.xyz * vec3(_Bumpiness);
					    u_xlat2.xyz = clamp(u_xlat2.xyz, 0.0, 1.0);
					    u_xlat3.xyz = u_xlat2.xyz + vec3(0.0, 0.0, 1.0);
					    u_xlat2.xyz = u_xlat2.xyz * in_NORMAL0.xyz;
					    u_xlat12 = dot(u_xlat3.xyz, u_xlat1.xyz);
					    u_xlat1.xyz = vec3(u_xlat12) * u_xlat3.xyz;
					    u_xlat1.xyz = u_xlat1.xyz / u_xlat3.zzz;
					    u_xlat0.xyz = (-u_xlat0.xyz) * vec3(-1.0, -1.0, 1.0) + u_xlat1.xyz;
					    u_xlat0.x = dot(u_xlat0.xyz, vec3(0.300000012, 0.589999974, 0.109999999));
					    u_xlat0.xyz = u_xlat2.xyz * u_xlat0.xxx + (-u_xlat2.xyz);
					    u_xlat0.xyz = vec3(vec3(_BumpAttune, _BumpAttune, _BumpAttune)) * u_xlat0.xyz + u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz + in_POSITION0.xyz;
					    u_xlat1 = u_xlat0.yyyy * unity_ObjectToWorld[1];
					    u_xlat1 = unity_ObjectToWorld[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat0 = unity_ObjectToWorld[2] * u_xlat0.zzzz + u_xlat1;
					    u_xlat1 = u_xlat0 + unity_ObjectToWorld[3];
					    vs_TEXCOORD3 = unity_ObjectToWorld[3] * in_POSITION0.wwww + u_xlat0;
					    u_xlat0 = u_xlat1.yyyy * unity_MatrixVP[1];
					    u_xlat0 = unity_MatrixVP[0] * u_xlat1.xxxx + u_xlat0;
					    u_xlat0 = unity_MatrixVP[2] * u_xlat1.zzzz + u_xlat0;
					    gl_Position = unity_MatrixVP[3] * u_xlat1.wwww + u_xlat0;
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
					    vs_TEXCOORD1.xy = in_TEXCOORD1.xy;
					    vs_TEXCOORD2.xy = in_TEXCOORD2.xy;
					    u_xlat0.x = dot(in_NORMAL0.xyz, unity_WorldToObject[0].xyz);
					    u_xlat0.y = dot(in_NORMAL0.xyz, unity_WorldToObject[1].xyz);
					    u_xlat0.z = dot(in_NORMAL0.xyz, unity_WorldToObject[2].xyz);
					    u_xlat12 = dot(u_xlat0.xyz, u_xlat0.xyz);
					    u_xlat12 = inversesqrt(u_xlat12);
					    u_xlat0.xyz = vec3(u_xlat12) * u_xlat0.xyz;
					    vs_TEXCOORD4.xyz = u_xlat0.xyz;
					    u_xlat1.xyz = in_TANGENT0.yyy * unity_ObjectToWorld[1].xyz;
					    u_xlat1.xyz = unity_ObjectToWorld[0].xyz * in_TANGENT0.xxx + u_xlat1.xyz;
					    u_xlat1.xyz = unity_ObjectToWorld[2].xyz * in_TANGENT0.zzz + u_xlat1.xyz;
					    u_xlat12 = dot(u_xlat1.xyz, u_xlat1.xyz);
					    u_xlat12 = inversesqrt(u_xlat12);
					    u_xlat1.xyz = vec3(u_xlat12) * u_xlat1.xyz;
					    vs_TEXCOORD5.xyz = u_xlat1.xyz;
					    u_xlat2.xyz = u_xlat0.zxy * u_xlat1.yzx;
					    u_xlat0.xyz = u_xlat0.yzx * u_xlat1.zxy + (-u_xlat2.xyz);
					    u_xlat0.xyz = u_xlat0.xyz * in_TANGENT0.www;
					    u_xlat12 = dot(u_xlat0.xyz, u_xlat0.xyz);
					    u_xlat12 = inversesqrt(u_xlat12);
					    vs_TEXCOORD6.xyz = vec3(u_xlat12) * u_xlat0.xyz;
					    return;
					}"
				}
				SubProgram "d3d11 " {
					Keywords { "SPOT" "DIRLIGHTMAP_COMBINED" "LIGHTMAP_OFF" "DYNAMICLIGHTMAP_OFF" }
					"vs_4_0
					
					#version 330
					#extension GL_ARB_explicit_attrib_location : require
					#extension GL_ARB_explicit_uniform_location : require
					
					#define HLSLCC_ENABLE_UNIFORM_BUFFERS 1
					#if HLSLCC_ENABLE_UNIFORM_BUFFERS
					#define UNITY_UNIFORM
					#else
					#define UNITY_UNIFORM uniform
					#endif
					#define UNITY_SUPPORTS_UNIFORM_LOCATION 1
					#if UNITY_SUPPORTS_UNIFORM_LOCATION
					#define UNITY_LOCATION(x) layout(location = x)
					#define UNITY_BINDING(x) layout(binding = x, std140)
					#else
					#define UNITY_LOCATION(x)
					#define UNITY_BINDING(x) layout(std140)
					#endif
					layout(std140) uniform VGlobals {
						vec4 unused_0_0[2];
						mat4x4 unity_WorldToLight;
						vec4 unused_0_2[2];
						vec4 _MainTexture_ST;
						vec4 unused_0_4[2];
						vec4 _Color;
						vec4 _Heightmap_ST;
						float _Bumpiness;
						float _BumpAttune;
					};
					layout(std140) uniform UnityPerDraw {
						mat4x4 unity_ObjectToWorld;
						mat4x4 unity_WorldToObject;
						vec4 unused_1_2[2];
					};
					layout(std140) uniform UnityPerFrame {
						vec4 unused_2_0[17];
						mat4x4 unity_MatrixVP;
						vec4 unused_2_2[2];
					};
					uniform  sampler2D _Heightmap;
					uniform  sampler2D _MainTexture;
					in  vec4 in_POSITION0;
					in  vec3 in_NORMAL0;
					in  vec4 in_TANGENT0;
					in  vec2 in_TEXCOORD0;
					in  vec2 in_TEXCOORD1;
					in  vec2 in_TEXCOORD2;
					out vec2 vs_TEXCOORD0;
					out vec2 vs_TEXCOORD1;
					out vec2 vs_TEXCOORD2;
					out vec4 vs_TEXCOORD3;
					out vec3 vs_TEXCOORD4;
					out vec3 vs_TEXCOORD5;
					out vec3 vs_TEXCOORD6;
					out vec4 vs_TEXCOORD7;
					vec4 u_xlat0;
					vec4 u_xlat1;
					vec4 u_xlat2;
					vec3 u_xlat3;
					float u_xlat12;
					float u_xlat13;
					void main()
					{
					    u_xlat0.xy = in_TEXCOORD0.xy * _MainTexture_ST.xy + _MainTexture_ST.zw;
					    u_xlat0 = textureLod(_MainTexture, u_xlat0.xy, 0.0);
					    u_xlat0.xyz = u_xlat0.xyz * _Color.xyz;
					    u_xlat1.xyz = u_xlat0.xyz * vec3(-1.0, -1.0, 1.0);
					    u_xlat2.xy = in_TEXCOORD0.xy * _Heightmap_ST.xy + _Heightmap_ST.zw;
					    u_xlat2 = textureLod(_Heightmap, u_xlat2.xy, 0.0);
					    u_xlat2.xyz = u_xlat2.xyz * vec3(_Bumpiness);
					    u_xlat2.xyz = clamp(u_xlat2.xyz, 0.0, 1.0);
					    u_xlat3.xyz = u_xlat2.xyz + vec3(0.0, 0.0, 1.0);
					    u_xlat2.xyz = u_xlat2.xyz * in_NORMAL0.xyz;
					    u_xlat12 = dot(u_xlat3.xyz, u_xlat1.xyz);
					    u_xlat1.xyz = vec3(u_xlat12) * u_xlat3.xyz;
					    u_xlat1.xyz = u_xlat1.xyz / u_xlat3.zzz;
					    u_xlat0.xyz = (-u_xlat0.xyz) * vec3(-1.0, -1.0, 1.0) + u_xlat1.xyz;
					    u_xlat0.x = dot(u_xlat0.xyz, vec3(0.300000012, 0.589999974, 0.109999999));
					    u_xlat0.xyz = u_xlat2.xyz * u_xlat0.xxx + (-u_xlat2.xyz);
					    u_xlat0.xyz = vec3(vec3(_BumpAttune, _BumpAttune, _BumpAttune)) * u_xlat0.xyz + u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz + in_POSITION0.xyz;
					    u_xlat1 = u_xlat0.yyyy * unity_ObjectToWorld[1];
					    u_xlat1 = unity_ObjectToWorld[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat0 = unity_ObjectToWorld[2] * u_xlat0.zzzz + u_xlat1;
					    u_xlat1 = u_xlat0 + unity_ObjectToWorld[3];
					    u_xlat0 = unity_ObjectToWorld[3] * in_POSITION0.wwww + u_xlat0;
					    u_xlat2 = u_xlat1.yyyy * unity_MatrixVP[1];
					    u_xlat2 = unity_MatrixVP[0] * u_xlat1.xxxx + u_xlat2;
					    u_xlat2 = unity_MatrixVP[2] * u_xlat1.zzzz + u_xlat2;
					    gl_Position = unity_MatrixVP[3] * u_xlat1.wwww + u_xlat2;
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
					    vs_TEXCOORD1.xy = in_TEXCOORD1.xy;
					    vs_TEXCOORD2.xy = in_TEXCOORD2.xy;
					    vs_TEXCOORD3 = u_xlat0;
					    u_xlat1.x = dot(in_NORMAL0.xyz, unity_WorldToObject[0].xyz);
					    u_xlat1.y = dot(in_NORMAL0.xyz, unity_WorldToObject[1].xyz);
					    u_xlat1.z = dot(in_NORMAL0.xyz, unity_WorldToObject[2].xyz);
					    u_xlat13 = dot(u_xlat1.xyz, u_xlat1.xyz);
					    u_xlat13 = inversesqrt(u_xlat13);
					    u_xlat1.xyz = vec3(u_xlat13) * u_xlat1.xyz;
					    vs_TEXCOORD4.xyz = u_xlat1.xyz;
					    u_xlat2.xyz = in_TANGENT0.yyy * unity_ObjectToWorld[1].xyz;
					    u_xlat2.xyz = unity_ObjectToWorld[0].xyz * in_TANGENT0.xxx + u_xlat2.xyz;
					    u_xlat2.xyz = unity_ObjectToWorld[2].xyz * in_TANGENT0.zzz + u_xlat2.xyz;
					    u_xlat13 = dot(u_xlat2.xyz, u_xlat2.xyz);
					    u_xlat13 = inversesqrt(u_xlat13);
					    u_xlat2.xyz = vec3(u_xlat13) * u_xlat2.xyz;
					    vs_TEXCOORD5.xyz = u_xlat2.xyz;
					    u_xlat3.xyz = u_xlat1.zxy * u_xlat2.yzx;
					    u_xlat1.xyz = u_xlat1.yzx * u_xlat2.zxy + (-u_xlat3.xyz);
					    u_xlat1.xyz = u_xlat1.xyz * in_TANGENT0.www;
					    u_xlat13 = dot(u_xlat1.xyz, u_xlat1.xyz);
					    u_xlat13 = inversesqrt(u_xlat13);
					    vs_TEXCOORD6.xyz = vec3(u_xlat13) * u_xlat1.xyz;
					    u_xlat1 = u_xlat0.yyyy * unity_WorldToLight[1];
					    u_xlat1 = unity_WorldToLight[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat1 = unity_WorldToLight[2] * u_xlat0.zzzz + u_xlat1;
					    vs_TEXCOORD7 = unity_WorldToLight[3] * u_xlat0.wwww + u_xlat1;
					    return;
					}"
				}
				SubProgram "d3d11 " {
					Keywords { "POINT_COOKIE" "DIRLIGHTMAP_COMBINED" "LIGHTMAP_OFF" "DYNAMICLIGHTMAP_OFF" }
					"vs_4_0
					
					#version 330
					#extension GL_ARB_explicit_attrib_location : require
					#extension GL_ARB_explicit_uniform_location : require
					
					#define HLSLCC_ENABLE_UNIFORM_BUFFERS 1
					#if HLSLCC_ENABLE_UNIFORM_BUFFERS
					#define UNITY_UNIFORM
					#else
					#define UNITY_UNIFORM uniform
					#endif
					#define UNITY_SUPPORTS_UNIFORM_LOCATION 1
					#if UNITY_SUPPORTS_UNIFORM_LOCATION
					#define UNITY_LOCATION(x) layout(location = x)
					#define UNITY_BINDING(x) layout(binding = x, std140)
					#else
					#define UNITY_LOCATION(x)
					#define UNITY_BINDING(x) layout(std140)
					#endif
					layout(std140) uniform VGlobals {
						vec4 unused_0_0[2];
						mat4x4 unity_WorldToLight;
						vec4 unused_0_2[2];
						vec4 _MainTexture_ST;
						vec4 unused_0_4[2];
						vec4 _Color;
						vec4 _Heightmap_ST;
						float _Bumpiness;
						float _BumpAttune;
					};
					layout(std140) uniform UnityPerDraw {
						mat4x4 unity_ObjectToWorld;
						mat4x4 unity_WorldToObject;
						vec4 unused_1_2[2];
					};
					layout(std140) uniform UnityPerFrame {
						vec4 unused_2_0[17];
						mat4x4 unity_MatrixVP;
						vec4 unused_2_2[2];
					};
					uniform  sampler2D _Heightmap;
					uniform  sampler2D _MainTexture;
					in  vec4 in_POSITION0;
					in  vec3 in_NORMAL0;
					in  vec4 in_TANGENT0;
					in  vec2 in_TEXCOORD0;
					in  vec2 in_TEXCOORD1;
					in  vec2 in_TEXCOORD2;
					out vec2 vs_TEXCOORD0;
					out vec2 vs_TEXCOORD1;
					out vec2 vs_TEXCOORD2;
					out vec4 vs_TEXCOORD3;
					out vec3 vs_TEXCOORD4;
					out vec3 vs_TEXCOORD5;
					out vec3 vs_TEXCOORD6;
					out vec3 vs_TEXCOORD7;
					vec4 u_xlat0;
					vec4 u_xlat1;
					vec4 u_xlat2;
					vec3 u_xlat3;
					float u_xlat12;
					float u_xlat13;
					void main()
					{
					    u_xlat0.xy = in_TEXCOORD0.xy * _MainTexture_ST.xy + _MainTexture_ST.zw;
					    u_xlat0 = textureLod(_MainTexture, u_xlat0.xy, 0.0);
					    u_xlat0.xyz = u_xlat0.xyz * _Color.xyz;
					    u_xlat1.xyz = u_xlat0.xyz * vec3(-1.0, -1.0, 1.0);
					    u_xlat2.xy = in_TEXCOORD0.xy * _Heightmap_ST.xy + _Heightmap_ST.zw;
					    u_xlat2 = textureLod(_Heightmap, u_xlat2.xy, 0.0);
					    u_xlat2.xyz = u_xlat2.xyz * vec3(_Bumpiness);
					    u_xlat2.xyz = clamp(u_xlat2.xyz, 0.0, 1.0);
					    u_xlat3.xyz = u_xlat2.xyz + vec3(0.0, 0.0, 1.0);
					    u_xlat2.xyz = u_xlat2.xyz * in_NORMAL0.xyz;
					    u_xlat12 = dot(u_xlat3.xyz, u_xlat1.xyz);
					    u_xlat1.xyz = vec3(u_xlat12) * u_xlat3.xyz;
					    u_xlat1.xyz = u_xlat1.xyz / u_xlat3.zzz;
					    u_xlat0.xyz = (-u_xlat0.xyz) * vec3(-1.0, -1.0, 1.0) + u_xlat1.xyz;
					    u_xlat0.x = dot(u_xlat0.xyz, vec3(0.300000012, 0.589999974, 0.109999999));
					    u_xlat0.xyz = u_xlat2.xyz * u_xlat0.xxx + (-u_xlat2.xyz);
					    u_xlat0.xyz = vec3(vec3(_BumpAttune, _BumpAttune, _BumpAttune)) * u_xlat0.xyz + u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz + in_POSITION0.xyz;
					    u_xlat1 = u_xlat0.yyyy * unity_ObjectToWorld[1];
					    u_xlat1 = unity_ObjectToWorld[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat0 = unity_ObjectToWorld[2] * u_xlat0.zzzz + u_xlat1;
					    u_xlat1 = u_xlat0 + unity_ObjectToWorld[3];
					    u_xlat0 = unity_ObjectToWorld[3] * in_POSITION0.wwww + u_xlat0;
					    u_xlat2 = u_xlat1.yyyy * unity_MatrixVP[1];
					    u_xlat2 = unity_MatrixVP[0] * u_xlat1.xxxx + u_xlat2;
					    u_xlat2 = unity_MatrixVP[2] * u_xlat1.zzzz + u_xlat2;
					    gl_Position = unity_MatrixVP[3] * u_xlat1.wwww + u_xlat2;
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
					    vs_TEXCOORD1.xy = in_TEXCOORD1.xy;
					    vs_TEXCOORD2.xy = in_TEXCOORD2.xy;
					    vs_TEXCOORD3 = u_xlat0;
					    u_xlat1.x = dot(in_NORMAL0.xyz, unity_WorldToObject[0].xyz);
					    u_xlat1.y = dot(in_NORMAL0.xyz, unity_WorldToObject[1].xyz);
					    u_xlat1.z = dot(in_NORMAL0.xyz, unity_WorldToObject[2].xyz);
					    u_xlat13 = dot(u_xlat1.xyz, u_xlat1.xyz);
					    u_xlat13 = inversesqrt(u_xlat13);
					    u_xlat1.xyz = vec3(u_xlat13) * u_xlat1.xyz;
					    vs_TEXCOORD4.xyz = u_xlat1.xyz;
					    u_xlat2.xyz = in_TANGENT0.yyy * unity_ObjectToWorld[1].xyz;
					    u_xlat2.xyz = unity_ObjectToWorld[0].xyz * in_TANGENT0.xxx + u_xlat2.xyz;
					    u_xlat2.xyz = unity_ObjectToWorld[2].xyz * in_TANGENT0.zzz + u_xlat2.xyz;
					    u_xlat13 = dot(u_xlat2.xyz, u_xlat2.xyz);
					    u_xlat13 = inversesqrt(u_xlat13);
					    u_xlat2.xyz = vec3(u_xlat13) * u_xlat2.xyz;
					    vs_TEXCOORD5.xyz = u_xlat2.xyz;
					    u_xlat3.xyz = u_xlat1.zxy * u_xlat2.yzx;
					    u_xlat1.xyz = u_xlat1.yzx * u_xlat2.zxy + (-u_xlat3.xyz);
					    u_xlat1.xyz = u_xlat1.xyz * in_TANGENT0.www;
					    u_xlat13 = dot(u_xlat1.xyz, u_xlat1.xyz);
					    u_xlat13 = inversesqrt(u_xlat13);
					    vs_TEXCOORD6.xyz = vec3(u_xlat13) * u_xlat1.xyz;
					    u_xlat1.xyz = u_xlat0.yyy * unity_WorldToLight[1].xyz;
					    u_xlat1.xyz = unity_WorldToLight[0].xyz * u_xlat0.xxx + u_xlat1.xyz;
					    u_xlat0.xyz = unity_WorldToLight[2].xyz * u_xlat0.zzz + u_xlat1.xyz;
					    vs_TEXCOORD7.xyz = unity_WorldToLight[3].xyz * u_xlat0.www + u_xlat0.xyz;
					    return;
					}"
				}
				SubProgram "d3d11 " {
					Keywords { "DIRECTIONAL_COOKIE" "DIRLIGHTMAP_COMBINED" "LIGHTMAP_OFF" "DYNAMICLIGHTMAP_OFF" }
					"vs_4_0
					
					#version 330
					#extension GL_ARB_explicit_attrib_location : require
					#extension GL_ARB_explicit_uniform_location : require
					
					#define HLSLCC_ENABLE_UNIFORM_BUFFERS 1
					#if HLSLCC_ENABLE_UNIFORM_BUFFERS
					#define UNITY_UNIFORM
					#else
					#define UNITY_UNIFORM uniform
					#endif
					#define UNITY_SUPPORTS_UNIFORM_LOCATION 1
					#if UNITY_SUPPORTS_UNIFORM_LOCATION
					#define UNITY_LOCATION(x) layout(location = x)
					#define UNITY_BINDING(x) layout(binding = x, std140)
					#else
					#define UNITY_LOCATION(x)
					#define UNITY_BINDING(x) layout(std140)
					#endif
					layout(std140) uniform VGlobals {
						vec4 unused_0_0[2];
						mat4x4 unity_WorldToLight;
						vec4 unused_0_2[2];
						vec4 _MainTexture_ST;
						vec4 unused_0_4[2];
						vec4 _Color;
						vec4 _Heightmap_ST;
						float _Bumpiness;
						float _BumpAttune;
					};
					layout(std140) uniform UnityPerDraw {
						mat4x4 unity_ObjectToWorld;
						mat4x4 unity_WorldToObject;
						vec4 unused_1_2[2];
					};
					layout(std140) uniform UnityPerFrame {
						vec4 unused_2_0[17];
						mat4x4 unity_MatrixVP;
						vec4 unused_2_2[2];
					};
					uniform  sampler2D _Heightmap;
					uniform  sampler2D _MainTexture;
					in  vec4 in_POSITION0;
					in  vec3 in_NORMAL0;
					in  vec4 in_TANGENT0;
					in  vec2 in_TEXCOORD0;
					in  vec2 in_TEXCOORD1;
					in  vec2 in_TEXCOORD2;
					out vec2 vs_TEXCOORD0;
					out vec2 vs_TEXCOORD1;
					out vec2 vs_TEXCOORD2;
					out vec2 vs_TEXCOORD7;
					out vec4 vs_TEXCOORD3;
					out vec3 vs_TEXCOORD4;
					out vec3 vs_TEXCOORD5;
					out vec3 vs_TEXCOORD6;
					vec4 u_xlat0;
					vec4 u_xlat1;
					vec4 u_xlat2;
					vec3 u_xlat3;
					float u_xlat12;
					void main()
					{
					    u_xlat0.xy = in_TEXCOORD0.xy * _MainTexture_ST.xy + _MainTexture_ST.zw;
					    u_xlat0 = textureLod(_MainTexture, u_xlat0.xy, 0.0);
					    u_xlat0.xyz = u_xlat0.xyz * _Color.xyz;
					    u_xlat1.xyz = u_xlat0.xyz * vec3(-1.0, -1.0, 1.0);
					    u_xlat2.xy = in_TEXCOORD0.xy * _Heightmap_ST.xy + _Heightmap_ST.zw;
					    u_xlat2 = textureLod(_Heightmap, u_xlat2.xy, 0.0);
					    u_xlat2.xyz = u_xlat2.xyz * vec3(_Bumpiness);
					    u_xlat2.xyz = clamp(u_xlat2.xyz, 0.0, 1.0);
					    u_xlat3.xyz = u_xlat2.xyz + vec3(0.0, 0.0, 1.0);
					    u_xlat2.xyz = u_xlat2.xyz * in_NORMAL0.xyz;
					    u_xlat12 = dot(u_xlat3.xyz, u_xlat1.xyz);
					    u_xlat1.xyz = vec3(u_xlat12) * u_xlat3.xyz;
					    u_xlat1.xyz = u_xlat1.xyz / u_xlat3.zzz;
					    u_xlat0.xyz = (-u_xlat0.xyz) * vec3(-1.0, -1.0, 1.0) + u_xlat1.xyz;
					    u_xlat0.x = dot(u_xlat0.xyz, vec3(0.300000012, 0.589999974, 0.109999999));
					    u_xlat0.xyz = u_xlat2.xyz * u_xlat0.xxx + (-u_xlat2.xyz);
					    u_xlat0.xyz = vec3(vec3(_BumpAttune, _BumpAttune, _BumpAttune)) * u_xlat0.xyz + u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz + in_POSITION0.xyz;
					    u_xlat1 = u_xlat0.yyyy * unity_ObjectToWorld[1];
					    u_xlat1 = unity_ObjectToWorld[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat0 = unity_ObjectToWorld[2] * u_xlat0.zzzz + u_xlat1;
					    u_xlat1 = u_xlat0 + unity_ObjectToWorld[3];
					    u_xlat0 = unity_ObjectToWorld[3] * in_POSITION0.wwww + u_xlat0;
					    u_xlat2 = u_xlat1.yyyy * unity_MatrixVP[1];
					    u_xlat2 = unity_MatrixVP[0] * u_xlat1.xxxx + u_xlat2;
					    u_xlat2 = unity_MatrixVP[2] * u_xlat1.zzzz + u_xlat2;
					    gl_Position = unity_MatrixVP[3] * u_xlat1.wwww + u_xlat2;
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
					    vs_TEXCOORD1.xy = in_TEXCOORD1.xy;
					    u_xlat1.xy = u_xlat0.yy * unity_WorldToLight[1].xy;
					    u_xlat1.xy = unity_WorldToLight[0].xy * u_xlat0.xx + u_xlat1.xy;
					    u_xlat1.xy = unity_WorldToLight[2].xy * u_xlat0.zz + u_xlat1.xy;
					    vs_TEXCOORD7.xy = unity_WorldToLight[3].xy * u_xlat0.ww + u_xlat1.xy;
					    vs_TEXCOORD3 = u_xlat0;
					    vs_TEXCOORD2.xy = in_TEXCOORD2.xy;
					    u_xlat0.x = dot(in_NORMAL0.xyz, unity_WorldToObject[0].xyz);
					    u_xlat0.y = dot(in_NORMAL0.xyz, unity_WorldToObject[1].xyz);
					    u_xlat0.z = dot(in_NORMAL0.xyz, unity_WorldToObject[2].xyz);
					    u_xlat12 = dot(u_xlat0.xyz, u_xlat0.xyz);
					    u_xlat12 = inversesqrt(u_xlat12);
					    u_xlat0.xyz = vec3(u_xlat12) * u_xlat0.xyz;
					    vs_TEXCOORD4.xyz = u_xlat0.xyz;
					    u_xlat1.xyz = in_TANGENT0.yyy * unity_ObjectToWorld[1].xyz;
					    u_xlat1.xyz = unity_ObjectToWorld[0].xyz * in_TANGENT0.xxx + u_xlat1.xyz;
					    u_xlat1.xyz = unity_ObjectToWorld[2].xyz * in_TANGENT0.zzz + u_xlat1.xyz;
					    u_xlat12 = dot(u_xlat1.xyz, u_xlat1.xyz);
					    u_xlat12 = inversesqrt(u_xlat12);
					    u_xlat1.xyz = vec3(u_xlat12) * u_xlat1.xyz;
					    vs_TEXCOORD5.xyz = u_xlat1.xyz;
					    u_xlat2.xyz = u_xlat0.zxy * u_xlat1.yzx;
					    u_xlat0.xyz = u_xlat0.yzx * u_xlat1.zxy + (-u_xlat2.xyz);
					    u_xlat0.xyz = u_xlat0.xyz * in_TANGENT0.www;
					    u_xlat12 = dot(u_xlat0.xyz, u_xlat0.xyz);
					    u_xlat12 = inversesqrt(u_xlat12);
					    vs_TEXCOORD6.xyz = vec3(u_xlat12) * u_xlat0.xyz;
					    return;
					}"
				}
				SubProgram "d3d11 " {
					Keywords { "SPOT" "SHADOWS_DEPTH" "DIRLIGHTMAP_COMBINED" "LIGHTMAP_OFF" "DYNAMICLIGHTMAP_OFF" }
					"vs_4_0
					
					#version 330
					#extension GL_ARB_explicit_attrib_location : require
					#extension GL_ARB_explicit_uniform_location : require
					
					#define HLSLCC_ENABLE_UNIFORM_BUFFERS 1
					#if HLSLCC_ENABLE_UNIFORM_BUFFERS
					#define UNITY_UNIFORM
					#else
					#define UNITY_UNIFORM uniform
					#endif
					#define UNITY_SUPPORTS_UNIFORM_LOCATION 1
					#if UNITY_SUPPORTS_UNIFORM_LOCATION
					#define UNITY_LOCATION(x) layout(location = x)
					#define UNITY_BINDING(x) layout(binding = x, std140)
					#else
					#define UNITY_LOCATION(x)
					#define UNITY_BINDING(x) layout(std140)
					#endif
					layout(std140) uniform VGlobals {
						vec4 unused_0_0[2];
						mat4x4 unity_WorldToLight;
						vec4 unused_0_2[2];
						vec4 _MainTexture_ST;
						vec4 unused_0_4[2];
						vec4 _Color;
						vec4 _Heightmap_ST;
						float _Bumpiness;
						float _BumpAttune;
					};
					layout(std140) uniform UnityShadows {
						vec4 unused_1_0[8];
						mat4x4 unity_WorldToShadow[4];
						vec4 unused_1_2[14];
					};
					layout(std140) uniform UnityPerDraw {
						mat4x4 unity_ObjectToWorld;
						mat4x4 unity_WorldToObject;
						vec4 unused_2_2[2];
					};
					layout(std140) uniform UnityPerFrame {
						vec4 unused_3_0[17];
						mat4x4 unity_MatrixVP;
						vec4 unused_3_2[2];
					};
					uniform  sampler2D _Heightmap;
					uniform  sampler2D _MainTexture;
					in  vec4 in_POSITION0;
					in  vec3 in_NORMAL0;
					in  vec4 in_TANGENT0;
					in  vec2 in_TEXCOORD0;
					in  vec2 in_TEXCOORD1;
					in  vec2 in_TEXCOORD2;
					out vec2 vs_TEXCOORD0;
					out vec2 vs_TEXCOORD1;
					out vec2 vs_TEXCOORD2;
					out vec4 vs_TEXCOORD3;
					out vec3 vs_TEXCOORD4;
					out vec3 vs_TEXCOORD5;
					out vec3 vs_TEXCOORD6;
					out vec4 vs_TEXCOORD7;
					out vec4 vs_TEXCOORD8;
					vec4 u_xlat0;
					vec4 u_xlat1;
					vec4 u_xlat2;
					vec3 u_xlat3;
					float u_xlat12;
					float u_xlat13;
					void main()
					{
					    u_xlat0.xy = in_TEXCOORD0.xy * _MainTexture_ST.xy + _MainTexture_ST.zw;
					    u_xlat0 = textureLod(_MainTexture, u_xlat0.xy, 0.0);
					    u_xlat0.xyz = u_xlat0.xyz * _Color.xyz;
					    u_xlat1.xyz = u_xlat0.xyz * vec3(-1.0, -1.0, 1.0);
					    u_xlat2.xy = in_TEXCOORD0.xy * _Heightmap_ST.xy + _Heightmap_ST.zw;
					    u_xlat2 = textureLod(_Heightmap, u_xlat2.xy, 0.0);
					    u_xlat2.xyz = u_xlat2.xyz * vec3(_Bumpiness);
					    u_xlat2.xyz = clamp(u_xlat2.xyz, 0.0, 1.0);
					    u_xlat3.xyz = u_xlat2.xyz + vec3(0.0, 0.0, 1.0);
					    u_xlat2.xyz = u_xlat2.xyz * in_NORMAL0.xyz;
					    u_xlat12 = dot(u_xlat3.xyz, u_xlat1.xyz);
					    u_xlat1.xyz = vec3(u_xlat12) * u_xlat3.xyz;
					    u_xlat1.xyz = u_xlat1.xyz / u_xlat3.zzz;
					    u_xlat0.xyz = (-u_xlat0.xyz) * vec3(-1.0, -1.0, 1.0) + u_xlat1.xyz;
					    u_xlat0.x = dot(u_xlat0.xyz, vec3(0.300000012, 0.589999974, 0.109999999));
					    u_xlat0.xyz = u_xlat2.xyz * u_xlat0.xxx + (-u_xlat2.xyz);
					    u_xlat0.xyz = vec3(vec3(_BumpAttune, _BumpAttune, _BumpAttune)) * u_xlat0.xyz + u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz + in_POSITION0.xyz;
					    u_xlat1 = u_xlat0.yyyy * unity_ObjectToWorld[1];
					    u_xlat1 = unity_ObjectToWorld[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat0 = unity_ObjectToWorld[2] * u_xlat0.zzzz + u_xlat1;
					    u_xlat1 = u_xlat0 + unity_ObjectToWorld[3];
					    u_xlat0 = unity_ObjectToWorld[3] * in_POSITION0.wwww + u_xlat0;
					    u_xlat2 = u_xlat1.yyyy * unity_MatrixVP[1];
					    u_xlat2 = unity_MatrixVP[0] * u_xlat1.xxxx + u_xlat2;
					    u_xlat2 = unity_MatrixVP[2] * u_xlat1.zzzz + u_xlat2;
					    gl_Position = unity_MatrixVP[3] * u_xlat1.wwww + u_xlat2;
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
					    vs_TEXCOORD1.xy = in_TEXCOORD1.xy;
					    vs_TEXCOORD2.xy = in_TEXCOORD2.xy;
					    vs_TEXCOORD3 = u_xlat0;
					    u_xlat1.x = dot(in_NORMAL0.xyz, unity_WorldToObject[0].xyz);
					    u_xlat1.y = dot(in_NORMAL0.xyz, unity_WorldToObject[1].xyz);
					    u_xlat1.z = dot(in_NORMAL0.xyz, unity_WorldToObject[2].xyz);
					    u_xlat13 = dot(u_xlat1.xyz, u_xlat1.xyz);
					    u_xlat13 = inversesqrt(u_xlat13);
					    u_xlat1.xyz = vec3(u_xlat13) * u_xlat1.xyz;
					    vs_TEXCOORD4.xyz = u_xlat1.xyz;
					    u_xlat2.xyz = in_TANGENT0.yyy * unity_ObjectToWorld[1].xyz;
					    u_xlat2.xyz = unity_ObjectToWorld[0].xyz * in_TANGENT0.xxx + u_xlat2.xyz;
					    u_xlat2.xyz = unity_ObjectToWorld[2].xyz * in_TANGENT0.zzz + u_xlat2.xyz;
					    u_xlat13 = dot(u_xlat2.xyz, u_xlat2.xyz);
					    u_xlat13 = inversesqrt(u_xlat13);
					    u_xlat2.xyz = vec3(u_xlat13) * u_xlat2.xyz;
					    vs_TEXCOORD5.xyz = u_xlat2.xyz;
					    u_xlat3.xyz = u_xlat1.zxy * u_xlat2.yzx;
					    u_xlat1.xyz = u_xlat1.yzx * u_xlat2.zxy + (-u_xlat3.xyz);
					    u_xlat1.xyz = u_xlat1.xyz * in_TANGENT0.www;
					    u_xlat13 = dot(u_xlat1.xyz, u_xlat1.xyz);
					    u_xlat13 = inversesqrt(u_xlat13);
					    vs_TEXCOORD6.xyz = vec3(u_xlat13) * u_xlat1.xyz;
					    u_xlat1 = u_xlat0.yyyy * unity_WorldToLight[1];
					    u_xlat1 = unity_WorldToLight[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat1 = unity_WorldToLight[2] * u_xlat0.zzzz + u_xlat1;
					    vs_TEXCOORD7 = unity_WorldToLight[3] * u_xlat0.wwww + u_xlat1;
					    u_xlat1 = u_xlat0.yyyy * unity_WorldToShadow[1 / 4][1 % 4];
					    u_xlat1 = unity_WorldToShadow[0 / 4][0 % 4] * u_xlat0.xxxx + u_xlat1;
					    u_xlat1 = unity_WorldToShadow[2 / 4][2 % 4] * u_xlat0.zzzz + u_xlat1;
					    vs_TEXCOORD8 = unity_WorldToShadow[3 / 4][3 % 4] * u_xlat0.wwww + u_xlat1;
					    return;
					}"
				}
				SubProgram "d3d11 " {
					Keywords { "SPOT" "SHADOWS_DEPTH" "SHADOWS_SOFT" "DIRLIGHTMAP_COMBINED" "LIGHTMAP_OFF" "DYNAMICLIGHTMAP_OFF" }
					"vs_4_0
					
					#version 330
					#extension GL_ARB_explicit_attrib_location : require
					#extension GL_ARB_explicit_uniform_location : require
					
					#define HLSLCC_ENABLE_UNIFORM_BUFFERS 1
					#if HLSLCC_ENABLE_UNIFORM_BUFFERS
					#define UNITY_UNIFORM
					#else
					#define UNITY_UNIFORM uniform
					#endif
					#define UNITY_SUPPORTS_UNIFORM_LOCATION 1
					#if UNITY_SUPPORTS_UNIFORM_LOCATION
					#define UNITY_LOCATION(x) layout(location = x)
					#define UNITY_BINDING(x) layout(binding = x, std140)
					#else
					#define UNITY_LOCATION(x)
					#define UNITY_BINDING(x) layout(std140)
					#endif
					layout(std140) uniform VGlobals {
						vec4 unused_0_0[7];
						mat4x4 unity_WorldToLight;
						vec4 unused_0_2[2];
						vec4 _MainTexture_ST;
						vec4 unused_0_4[2];
						vec4 _Color;
						vec4 _Heightmap_ST;
						float _Bumpiness;
						float _BumpAttune;
					};
					layout(std140) uniform UnityShadows {
						vec4 unused_1_0[8];
						mat4x4 unity_WorldToShadow[4];
						vec4 unused_1_2[14];
					};
					layout(std140) uniform UnityPerDraw {
						mat4x4 unity_ObjectToWorld;
						mat4x4 unity_WorldToObject;
						vec4 unused_2_2[2];
					};
					layout(std140) uniform UnityPerFrame {
						vec4 unused_3_0[17];
						mat4x4 unity_MatrixVP;
						vec4 unused_3_2[2];
					};
					uniform  sampler2D _Heightmap;
					uniform  sampler2D _MainTexture;
					in  vec4 in_POSITION0;
					in  vec3 in_NORMAL0;
					in  vec4 in_TANGENT0;
					in  vec2 in_TEXCOORD0;
					in  vec2 in_TEXCOORD1;
					in  vec2 in_TEXCOORD2;
					out vec2 vs_TEXCOORD0;
					out vec2 vs_TEXCOORD1;
					out vec2 vs_TEXCOORD2;
					out vec4 vs_TEXCOORD3;
					out vec3 vs_TEXCOORD4;
					out vec3 vs_TEXCOORD5;
					out vec3 vs_TEXCOORD6;
					out vec4 vs_TEXCOORD7;
					out vec4 vs_TEXCOORD8;
					vec4 u_xlat0;
					vec4 u_xlat1;
					vec4 u_xlat2;
					vec3 u_xlat3;
					float u_xlat12;
					float u_xlat13;
					void main()
					{
					    u_xlat0.xy = in_TEXCOORD0.xy * _MainTexture_ST.xy + _MainTexture_ST.zw;
					    u_xlat0 = textureLod(_MainTexture, u_xlat0.xy, 0.0);
					    u_xlat0.xyz = u_xlat0.xyz * _Color.xyz;
					    u_xlat1.xyz = u_xlat0.xyz * vec3(-1.0, -1.0, 1.0);
					    u_xlat2.xy = in_TEXCOORD0.xy * _Heightmap_ST.xy + _Heightmap_ST.zw;
					    u_xlat2 = textureLod(_Heightmap, u_xlat2.xy, 0.0);
					    u_xlat2.xyz = u_xlat2.xyz * vec3(_Bumpiness);
					    u_xlat2.xyz = clamp(u_xlat2.xyz, 0.0, 1.0);
					    u_xlat3.xyz = u_xlat2.xyz + vec3(0.0, 0.0, 1.0);
					    u_xlat2.xyz = u_xlat2.xyz * in_NORMAL0.xyz;
					    u_xlat12 = dot(u_xlat3.xyz, u_xlat1.xyz);
					    u_xlat1.xyz = vec3(u_xlat12) * u_xlat3.xyz;
					    u_xlat1.xyz = u_xlat1.xyz / u_xlat3.zzz;
					    u_xlat0.xyz = (-u_xlat0.xyz) * vec3(-1.0, -1.0, 1.0) + u_xlat1.xyz;
					    u_xlat0.x = dot(u_xlat0.xyz, vec3(0.300000012, 0.589999974, 0.109999999));
					    u_xlat0.xyz = u_xlat2.xyz * u_xlat0.xxx + (-u_xlat2.xyz);
					    u_xlat0.xyz = vec3(vec3(_BumpAttune, _BumpAttune, _BumpAttune)) * u_xlat0.xyz + u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz + in_POSITION0.xyz;
					    u_xlat1 = u_xlat0.yyyy * unity_ObjectToWorld[1];
					    u_xlat1 = unity_ObjectToWorld[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat0 = unity_ObjectToWorld[2] * u_xlat0.zzzz + u_xlat1;
					    u_xlat1 = u_xlat0 + unity_ObjectToWorld[3];
					    u_xlat0 = unity_ObjectToWorld[3] * in_POSITION0.wwww + u_xlat0;
					    u_xlat2 = u_xlat1.yyyy * unity_MatrixVP[1];
					    u_xlat2 = unity_MatrixVP[0] * u_xlat1.xxxx + u_xlat2;
					    u_xlat2 = unity_MatrixVP[2] * u_xlat1.zzzz + u_xlat2;
					    gl_Position = unity_MatrixVP[3] * u_xlat1.wwww + u_xlat2;
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
					    vs_TEXCOORD1.xy = in_TEXCOORD1.xy;
					    vs_TEXCOORD2.xy = in_TEXCOORD2.xy;
					    vs_TEXCOORD3 = u_xlat0;
					    u_xlat1.x = dot(in_NORMAL0.xyz, unity_WorldToObject[0].xyz);
					    u_xlat1.y = dot(in_NORMAL0.xyz, unity_WorldToObject[1].xyz);
					    u_xlat1.z = dot(in_NORMAL0.xyz, unity_WorldToObject[2].xyz);
					    u_xlat13 = dot(u_xlat1.xyz, u_xlat1.xyz);
					    u_xlat13 = inversesqrt(u_xlat13);
					    u_xlat1.xyz = vec3(u_xlat13) * u_xlat1.xyz;
					    vs_TEXCOORD4.xyz = u_xlat1.xyz;
					    u_xlat2.xyz = in_TANGENT0.yyy * unity_ObjectToWorld[1].xyz;
					    u_xlat2.xyz = unity_ObjectToWorld[0].xyz * in_TANGENT0.xxx + u_xlat2.xyz;
					    u_xlat2.xyz = unity_ObjectToWorld[2].xyz * in_TANGENT0.zzz + u_xlat2.xyz;
					    u_xlat13 = dot(u_xlat2.xyz, u_xlat2.xyz);
					    u_xlat13 = inversesqrt(u_xlat13);
					    u_xlat2.xyz = vec3(u_xlat13) * u_xlat2.xyz;
					    vs_TEXCOORD5.xyz = u_xlat2.xyz;
					    u_xlat3.xyz = u_xlat1.zxy * u_xlat2.yzx;
					    u_xlat1.xyz = u_xlat1.yzx * u_xlat2.zxy + (-u_xlat3.xyz);
					    u_xlat1.xyz = u_xlat1.xyz * in_TANGENT0.www;
					    u_xlat13 = dot(u_xlat1.xyz, u_xlat1.xyz);
					    u_xlat13 = inversesqrt(u_xlat13);
					    vs_TEXCOORD6.xyz = vec3(u_xlat13) * u_xlat1.xyz;
					    u_xlat1 = u_xlat0.yyyy * unity_WorldToLight[1];
					    u_xlat1 = unity_WorldToLight[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat1 = unity_WorldToLight[2] * u_xlat0.zzzz + u_xlat1;
					    vs_TEXCOORD7 = unity_WorldToLight[3] * u_xlat0.wwww + u_xlat1;
					    u_xlat1 = u_xlat0.yyyy * unity_WorldToShadow[1 / 4][1 % 4];
					    u_xlat1 = unity_WorldToShadow[0 / 4][0 % 4] * u_xlat0.xxxx + u_xlat1;
					    u_xlat1 = unity_WorldToShadow[2 / 4][2 % 4] * u_xlat0.zzzz + u_xlat1;
					    vs_TEXCOORD8 = unity_WorldToShadow[3 / 4][3 % 4] * u_xlat0.wwww + u_xlat1;
					    return;
					}"
				}
				SubProgram "d3d11 " {
					Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "DIRLIGHTMAP_COMBINED" "LIGHTMAP_OFF" "DYNAMICLIGHTMAP_OFF" }
					"vs_4_0
					
					#version 330
					#extension GL_ARB_explicit_attrib_location : require
					#extension GL_ARB_explicit_uniform_location : require
					
					#define HLSLCC_ENABLE_UNIFORM_BUFFERS 1
					#if HLSLCC_ENABLE_UNIFORM_BUFFERS
					#define UNITY_UNIFORM
					#else
					#define UNITY_UNIFORM uniform
					#endif
					#define UNITY_SUPPORTS_UNIFORM_LOCATION 1
					#if UNITY_SUPPORTS_UNIFORM_LOCATION
					#define UNITY_LOCATION(x) layout(location = x)
					#define UNITY_BINDING(x) layout(binding = x, std140)
					#else
					#define UNITY_LOCATION(x)
					#define UNITY_BINDING(x) layout(std140)
					#endif
					layout(std140) uniform VGlobals {
						vec4 unused_0_0[4];
						vec4 _MainTexture_ST;
						vec4 unused_0_2[2];
						vec4 _Color;
						vec4 _Heightmap_ST;
						float _Bumpiness;
						float _BumpAttune;
					};
					layout(std140) uniform UnityPerCamera {
						vec4 unused_1_0[5];
						vec4 _ProjectionParams;
						vec4 unused_1_2[3];
					};
					layout(std140) uniform UnityPerDraw {
						mat4x4 unity_ObjectToWorld;
						mat4x4 unity_WorldToObject;
						vec4 unused_2_2[2];
					};
					layout(std140) uniform UnityPerFrame {
						vec4 unused_3_0[17];
						mat4x4 unity_MatrixVP;
						vec4 unused_3_2[2];
					};
					uniform  sampler2D _Heightmap;
					uniform  sampler2D _MainTexture;
					in  vec4 in_POSITION0;
					in  vec3 in_NORMAL0;
					in  vec4 in_TANGENT0;
					in  vec2 in_TEXCOORD0;
					in  vec2 in_TEXCOORD1;
					in  vec2 in_TEXCOORD2;
					out vec2 vs_TEXCOORD0;
					out vec2 vs_TEXCOORD1;
					out vec2 vs_TEXCOORD2;
					out vec4 vs_TEXCOORD3;
					out vec3 vs_TEXCOORD4;
					out vec3 vs_TEXCOORD5;
					out vec3 vs_TEXCOORD6;
					out vec4 vs_TEXCOORD8;
					vec4 u_xlat0;
					vec4 u_xlat1;
					vec4 u_xlat2;
					vec3 u_xlat3;
					float u_xlat12;
					float u_xlat13;
					void main()
					{
					    u_xlat0.xy = in_TEXCOORD0.xy * _MainTexture_ST.xy + _MainTexture_ST.zw;
					    u_xlat0 = textureLod(_MainTexture, u_xlat0.xy, 0.0);
					    u_xlat0.xyz = u_xlat0.xyz * _Color.xyz;
					    u_xlat1.xyz = u_xlat0.xyz * vec3(-1.0, -1.0, 1.0);
					    u_xlat2.xy = in_TEXCOORD0.xy * _Heightmap_ST.xy + _Heightmap_ST.zw;
					    u_xlat2 = textureLod(_Heightmap, u_xlat2.xy, 0.0);
					    u_xlat2.xyz = u_xlat2.xyz * vec3(_Bumpiness);
					    u_xlat2.xyz = clamp(u_xlat2.xyz, 0.0, 1.0);
					    u_xlat3.xyz = u_xlat2.xyz + vec3(0.0, 0.0, 1.0);
					    u_xlat2.xyz = u_xlat2.xyz * in_NORMAL0.xyz;
					    u_xlat12 = dot(u_xlat3.xyz, u_xlat1.xyz);
					    u_xlat1.xyz = vec3(u_xlat12) * u_xlat3.xyz;
					    u_xlat1.xyz = u_xlat1.xyz / u_xlat3.zzz;
					    u_xlat0.xyz = (-u_xlat0.xyz) * vec3(-1.0, -1.0, 1.0) + u_xlat1.xyz;
					    u_xlat0.x = dot(u_xlat0.xyz, vec3(0.300000012, 0.589999974, 0.109999999));
					    u_xlat0.xyz = u_xlat2.xyz * u_xlat0.xxx + (-u_xlat2.xyz);
					    u_xlat0.xyz = vec3(vec3(_BumpAttune, _BumpAttune, _BumpAttune)) * u_xlat0.xyz + u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz + in_POSITION0.xyz;
					    u_xlat1 = u_xlat0.yyyy * unity_ObjectToWorld[1];
					    u_xlat1 = unity_ObjectToWorld[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat0 = unity_ObjectToWorld[2] * u_xlat0.zzzz + u_xlat1;
					    u_xlat1 = u_xlat0 + unity_ObjectToWorld[3];
					    vs_TEXCOORD3 = unity_ObjectToWorld[3] * in_POSITION0.wwww + u_xlat0;
					    u_xlat0 = u_xlat1.yyyy * unity_MatrixVP[1];
					    u_xlat0 = unity_MatrixVP[0] * u_xlat1.xxxx + u_xlat0;
					    u_xlat0 = unity_MatrixVP[2] * u_xlat1.zzzz + u_xlat0;
					    u_xlat0 = unity_MatrixVP[3] * u_xlat1.wwww + u_xlat0;
					    gl_Position = u_xlat0;
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
					    vs_TEXCOORD1.xy = in_TEXCOORD1.xy;
					    vs_TEXCOORD2.xy = in_TEXCOORD2.xy;
					    u_xlat1.x = dot(in_NORMAL0.xyz, unity_WorldToObject[0].xyz);
					    u_xlat1.y = dot(in_NORMAL0.xyz, unity_WorldToObject[1].xyz);
					    u_xlat1.z = dot(in_NORMAL0.xyz, unity_WorldToObject[2].xyz);
					    u_xlat13 = dot(u_xlat1.xyz, u_xlat1.xyz);
					    u_xlat13 = inversesqrt(u_xlat13);
					    u_xlat1.xyz = vec3(u_xlat13) * u_xlat1.xyz;
					    vs_TEXCOORD4.xyz = u_xlat1.xyz;
					    u_xlat2.xyz = in_TANGENT0.yyy * unity_ObjectToWorld[1].xyz;
					    u_xlat2.xyz = unity_ObjectToWorld[0].xyz * in_TANGENT0.xxx + u_xlat2.xyz;
					    u_xlat2.xyz = unity_ObjectToWorld[2].xyz * in_TANGENT0.zzz + u_xlat2.xyz;
					    u_xlat13 = dot(u_xlat2.xyz, u_xlat2.xyz);
					    u_xlat13 = inversesqrt(u_xlat13);
					    u_xlat2.xyz = vec3(u_xlat13) * u_xlat2.xyz;
					    vs_TEXCOORD5.xyz = u_xlat2.xyz;
					    u_xlat3.xyz = u_xlat1.zxy * u_xlat2.yzx;
					    u_xlat1.xyz = u_xlat1.yzx * u_xlat2.zxy + (-u_xlat3.xyz);
					    u_xlat1.xyz = u_xlat1.xyz * in_TANGENT0.www;
					    u_xlat13 = dot(u_xlat1.xyz, u_xlat1.xyz);
					    u_xlat13 = inversesqrt(u_xlat13);
					    vs_TEXCOORD6.xyz = vec3(u_xlat13) * u_xlat1.xyz;
					    u_xlat0.y = u_xlat0.y * _ProjectionParams.x;
					    u_xlat1.xzw = u_xlat0.xwy * vec3(0.5, 0.5, 0.5);
					    vs_TEXCOORD8.zw = u_xlat0.zw;
					    vs_TEXCOORD8.xy = u_xlat1.zz + u_xlat1.xw;
					    return;
					}"
				}
				SubProgram "d3d11 " {
					Keywords { "DIRECTIONAL_COOKIE" "SHADOWS_SCREEN" "DIRLIGHTMAP_COMBINED" "LIGHTMAP_OFF" "DYNAMICLIGHTMAP_OFF" }
					"vs_4_0
					
					#version 330
					#extension GL_ARB_explicit_attrib_location : require
					#extension GL_ARB_explicit_uniform_location : require
					
					#define HLSLCC_ENABLE_UNIFORM_BUFFERS 1
					#if HLSLCC_ENABLE_UNIFORM_BUFFERS
					#define UNITY_UNIFORM
					#else
					#define UNITY_UNIFORM uniform
					#endif
					#define UNITY_SUPPORTS_UNIFORM_LOCATION 1
					#if UNITY_SUPPORTS_UNIFORM_LOCATION
					#define UNITY_LOCATION(x) layout(location = x)
					#define UNITY_BINDING(x) layout(binding = x, std140)
					#else
					#define UNITY_LOCATION(x)
					#define UNITY_BINDING(x) layout(std140)
					#endif
					layout(std140) uniform VGlobals {
						vec4 unused_0_0[2];
						mat4x4 unity_WorldToLight;
						vec4 unused_0_2[2];
						vec4 _MainTexture_ST;
						vec4 unused_0_4[2];
						vec4 _Color;
						vec4 _Heightmap_ST;
						float _Bumpiness;
						float _BumpAttune;
					};
					layout(std140) uniform UnityPerCamera {
						vec4 unused_1_0[5];
						vec4 _ProjectionParams;
						vec4 unused_1_2[3];
					};
					layout(std140) uniform UnityPerDraw {
						mat4x4 unity_ObjectToWorld;
						mat4x4 unity_WorldToObject;
						vec4 unused_2_2[2];
					};
					layout(std140) uniform UnityPerFrame {
						vec4 unused_3_0[17];
						mat4x4 unity_MatrixVP;
						vec4 unused_3_2[2];
					};
					uniform  sampler2D _Heightmap;
					uniform  sampler2D _MainTexture;
					in  vec4 in_POSITION0;
					in  vec3 in_NORMAL0;
					in  vec4 in_TANGENT0;
					in  vec2 in_TEXCOORD0;
					in  vec2 in_TEXCOORD1;
					in  vec2 in_TEXCOORD2;
					out vec2 vs_TEXCOORD0;
					out vec2 vs_TEXCOORD1;
					out vec2 vs_TEXCOORD2;
					out vec2 vs_TEXCOORD7;
					out vec4 vs_TEXCOORD3;
					out vec3 vs_TEXCOORD4;
					out vec3 vs_TEXCOORD5;
					out vec3 vs_TEXCOORD6;
					out vec4 vs_TEXCOORD8;
					vec4 u_xlat0;
					vec4 u_xlat1;
					vec4 u_xlat2;
					vec3 u_xlat3;
					float u_xlat12;
					void main()
					{
					    u_xlat0.xy = in_TEXCOORD0.xy * _MainTexture_ST.xy + _MainTexture_ST.zw;
					    u_xlat0 = textureLod(_MainTexture, u_xlat0.xy, 0.0);
					    u_xlat0.xyz = u_xlat0.xyz * _Color.xyz;
					    u_xlat1.xyz = u_xlat0.xyz * vec3(-1.0, -1.0, 1.0);
					    u_xlat2.xy = in_TEXCOORD0.xy * _Heightmap_ST.xy + _Heightmap_ST.zw;
					    u_xlat2 = textureLod(_Heightmap, u_xlat2.xy, 0.0);
					    u_xlat2.xyz = u_xlat2.xyz * vec3(_Bumpiness);
					    u_xlat2.xyz = clamp(u_xlat2.xyz, 0.0, 1.0);
					    u_xlat3.xyz = u_xlat2.xyz + vec3(0.0, 0.0, 1.0);
					    u_xlat2.xyz = u_xlat2.xyz * in_NORMAL0.xyz;
					    u_xlat12 = dot(u_xlat3.xyz, u_xlat1.xyz);
					    u_xlat1.xyz = vec3(u_xlat12) * u_xlat3.xyz;
					    u_xlat1.xyz = u_xlat1.xyz / u_xlat3.zzz;
					    u_xlat0.xyz = (-u_xlat0.xyz) * vec3(-1.0, -1.0, 1.0) + u_xlat1.xyz;
					    u_xlat0.x = dot(u_xlat0.xyz, vec3(0.300000012, 0.589999974, 0.109999999));
					    u_xlat0.xyz = u_xlat2.xyz * u_xlat0.xxx + (-u_xlat2.xyz);
					    u_xlat0.xyz = vec3(vec3(_BumpAttune, _BumpAttune, _BumpAttune)) * u_xlat0.xyz + u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz + in_POSITION0.xyz;
					    u_xlat1 = u_xlat0.yyyy * unity_ObjectToWorld[1];
					    u_xlat1 = unity_ObjectToWorld[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat0 = unity_ObjectToWorld[2] * u_xlat0.zzzz + u_xlat1;
					    u_xlat1 = u_xlat0 + unity_ObjectToWorld[3];
					    u_xlat0 = unity_ObjectToWorld[3] * in_POSITION0.wwww + u_xlat0;
					    u_xlat2 = u_xlat1.yyyy * unity_MatrixVP[1];
					    u_xlat2 = unity_MatrixVP[0] * u_xlat1.xxxx + u_xlat2;
					    u_xlat2 = unity_MatrixVP[2] * u_xlat1.zzzz + u_xlat2;
					    u_xlat1 = unity_MatrixVP[3] * u_xlat1.wwww + u_xlat2;
					    gl_Position = u_xlat1;
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
					    vs_TEXCOORD1.xy = in_TEXCOORD1.xy;
					    u_xlat2.xy = u_xlat0.yy * unity_WorldToLight[1].xy;
					    u_xlat2.xy = unity_WorldToLight[0].xy * u_xlat0.xx + u_xlat2.xy;
					    u_xlat2.xy = unity_WorldToLight[2].xy * u_xlat0.zz + u_xlat2.xy;
					    vs_TEXCOORD7.xy = unity_WorldToLight[3].xy * u_xlat0.ww + u_xlat2.xy;
					    vs_TEXCOORD3 = u_xlat0;
					    vs_TEXCOORD2.xy = in_TEXCOORD2.xy;
					    u_xlat0.x = dot(in_NORMAL0.xyz, unity_WorldToObject[0].xyz);
					    u_xlat0.y = dot(in_NORMAL0.xyz, unity_WorldToObject[1].xyz);
					    u_xlat0.z = dot(in_NORMAL0.xyz, unity_WorldToObject[2].xyz);
					    u_xlat12 = dot(u_xlat0.xyz, u_xlat0.xyz);
					    u_xlat12 = inversesqrt(u_xlat12);
					    u_xlat0.xyz = vec3(u_xlat12) * u_xlat0.xyz;
					    vs_TEXCOORD4.xyz = u_xlat0.xyz;
					    u_xlat2.xyz = in_TANGENT0.yyy * unity_ObjectToWorld[1].xyz;
					    u_xlat2.xyz = unity_ObjectToWorld[0].xyz * in_TANGENT0.xxx + u_xlat2.xyz;
					    u_xlat2.xyz = unity_ObjectToWorld[2].xyz * in_TANGENT0.zzz + u_xlat2.xyz;
					    u_xlat12 = dot(u_xlat2.xyz, u_xlat2.xyz);
					    u_xlat12 = inversesqrt(u_xlat12);
					    u_xlat2.xyz = vec3(u_xlat12) * u_xlat2.xyz;
					    vs_TEXCOORD5.xyz = u_xlat2.xyz;
					    u_xlat3.xyz = u_xlat0.zxy * u_xlat2.yzx;
					    u_xlat0.xyz = u_xlat0.yzx * u_xlat2.zxy + (-u_xlat3.xyz);
					    u_xlat0.xyz = u_xlat0.xyz * in_TANGENT0.www;
					    u_xlat12 = dot(u_xlat0.xyz, u_xlat0.xyz);
					    u_xlat12 = inversesqrt(u_xlat12);
					    vs_TEXCOORD6.xyz = vec3(u_xlat12) * u_xlat0.xyz;
					    u_xlat0.x = u_xlat1.y * _ProjectionParams.x;
					    u_xlat0.w = u_xlat0.x * 0.5;
					    u_xlat0.xz = u_xlat1.xw * vec2(0.5, 0.5);
					    vs_TEXCOORD8.zw = u_xlat1.zw;
					    vs_TEXCOORD8.xy = u_xlat0.zz + u_xlat0.xw;
					    return;
					}"
				}
				SubProgram "d3d11 " {
					Keywords { "POINT" "SHADOWS_CUBE" "DIRLIGHTMAP_COMBINED" "LIGHTMAP_OFF" "DYNAMICLIGHTMAP_OFF" }
					"vs_4_0
					
					#version 330
					#extension GL_ARB_explicit_attrib_location : require
					#extension GL_ARB_explicit_uniform_location : require
					
					#define HLSLCC_ENABLE_UNIFORM_BUFFERS 1
					#if HLSLCC_ENABLE_UNIFORM_BUFFERS
					#define UNITY_UNIFORM
					#else
					#define UNITY_UNIFORM uniform
					#endif
					#define UNITY_SUPPORTS_UNIFORM_LOCATION 1
					#if UNITY_SUPPORTS_UNIFORM_LOCATION
					#define UNITY_LOCATION(x) layout(location = x)
					#define UNITY_BINDING(x) layout(binding = x, std140)
					#else
					#define UNITY_LOCATION(x)
					#define UNITY_BINDING(x) layout(std140)
					#endif
					layout(std140) uniform VGlobals {
						vec4 unused_0_0[2];
						mat4x4 unity_WorldToLight;
						vec4 unused_0_2[2];
						vec4 _MainTexture_ST;
						vec4 unused_0_4[2];
						vec4 _Color;
						vec4 _Heightmap_ST;
						float _Bumpiness;
						float _BumpAttune;
					};
					layout(std140) uniform UnityLighting {
						vec4 unused_1_0;
						vec4 _LightPositionRange;
						vec4 unused_1_2[46];
					};
					layout(std140) uniform UnityPerDraw {
						mat4x4 unity_ObjectToWorld;
						mat4x4 unity_WorldToObject;
						vec4 unused_2_2[2];
					};
					layout(std140) uniform UnityPerFrame {
						vec4 unused_3_0[17];
						mat4x4 unity_MatrixVP;
						vec4 unused_3_2[2];
					};
					uniform  sampler2D _Heightmap;
					uniform  sampler2D _MainTexture;
					in  vec4 in_POSITION0;
					in  vec3 in_NORMAL0;
					in  vec4 in_TANGENT0;
					in  vec2 in_TEXCOORD0;
					in  vec2 in_TEXCOORD1;
					in  vec2 in_TEXCOORD2;
					out vec2 vs_TEXCOORD0;
					out vec2 vs_TEXCOORD1;
					out vec2 vs_TEXCOORD2;
					out vec4 vs_TEXCOORD3;
					out vec3 vs_TEXCOORD4;
					out vec3 vs_TEXCOORD5;
					out vec3 vs_TEXCOORD6;
					out vec3 vs_TEXCOORD7;
					out vec3 vs_TEXCOORD8;
					vec4 u_xlat0;
					vec4 u_xlat1;
					vec4 u_xlat2;
					vec3 u_xlat3;
					float u_xlat12;
					float u_xlat13;
					void main()
					{
					    u_xlat0.xy = in_TEXCOORD0.xy * _MainTexture_ST.xy + _MainTexture_ST.zw;
					    u_xlat0 = textureLod(_MainTexture, u_xlat0.xy, 0.0);
					    u_xlat0.xyz = u_xlat0.xyz * _Color.xyz;
					    u_xlat1.xyz = u_xlat0.xyz * vec3(-1.0, -1.0, 1.0);
					    u_xlat2.xy = in_TEXCOORD0.xy * _Heightmap_ST.xy + _Heightmap_ST.zw;
					    u_xlat2 = textureLod(_Heightmap, u_xlat2.xy, 0.0);
					    u_xlat2.xyz = u_xlat2.xyz * vec3(_Bumpiness);
					    u_xlat2.xyz = clamp(u_xlat2.xyz, 0.0, 1.0);
					    u_xlat3.xyz = u_xlat2.xyz + vec3(0.0, 0.0, 1.0);
					    u_xlat2.xyz = u_xlat2.xyz * in_NORMAL0.xyz;
					    u_xlat12 = dot(u_xlat3.xyz, u_xlat1.xyz);
					    u_xlat1.xyz = vec3(u_xlat12) * u_xlat3.xyz;
					    u_xlat1.xyz = u_xlat1.xyz / u_xlat3.zzz;
					    u_xlat0.xyz = (-u_xlat0.xyz) * vec3(-1.0, -1.0, 1.0) + u_xlat1.xyz;
					    u_xlat0.x = dot(u_xlat0.xyz, vec3(0.300000012, 0.589999974, 0.109999999));
					    u_xlat0.xyz = u_xlat2.xyz * u_xlat0.xxx + (-u_xlat2.xyz);
					    u_xlat0.xyz = vec3(vec3(_BumpAttune, _BumpAttune, _BumpAttune)) * u_xlat0.xyz + u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz + in_POSITION0.xyz;
					    u_xlat1 = u_xlat0.yyyy * unity_ObjectToWorld[1];
					    u_xlat1 = unity_ObjectToWorld[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat0 = unity_ObjectToWorld[2] * u_xlat0.zzzz + u_xlat1;
					    u_xlat1 = u_xlat0 + unity_ObjectToWorld[3];
					    u_xlat0 = unity_ObjectToWorld[3] * in_POSITION0.wwww + u_xlat0;
					    u_xlat2 = u_xlat1.yyyy * unity_MatrixVP[1];
					    u_xlat2 = unity_MatrixVP[0] * u_xlat1.xxxx + u_xlat2;
					    u_xlat2 = unity_MatrixVP[2] * u_xlat1.zzzz + u_xlat2;
					    gl_Position = unity_MatrixVP[3] * u_xlat1.wwww + u_xlat2;
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
					    vs_TEXCOORD1.xy = in_TEXCOORD1.xy;
					    vs_TEXCOORD2.xy = in_TEXCOORD2.xy;
					    vs_TEXCOORD3 = u_xlat0;
					    u_xlat1.x = dot(in_NORMAL0.xyz, unity_WorldToObject[0].xyz);
					    u_xlat1.y = dot(in_NORMAL0.xyz, unity_WorldToObject[1].xyz);
					    u_xlat1.z = dot(in_NORMAL0.xyz, unity_WorldToObject[2].xyz);
					    u_xlat13 = dot(u_xlat1.xyz, u_xlat1.xyz);
					    u_xlat13 = inversesqrt(u_xlat13);
					    u_xlat1.xyz = vec3(u_xlat13) * u_xlat1.xyz;
					    vs_TEXCOORD4.xyz = u_xlat1.xyz;
					    u_xlat2.xyz = in_TANGENT0.yyy * unity_ObjectToWorld[1].xyz;
					    u_xlat2.xyz = unity_ObjectToWorld[0].xyz * in_TANGENT0.xxx + u_xlat2.xyz;
					    u_xlat2.xyz = unity_ObjectToWorld[2].xyz * in_TANGENT0.zzz + u_xlat2.xyz;
					    u_xlat13 = dot(u_xlat2.xyz, u_xlat2.xyz);
					    u_xlat13 = inversesqrt(u_xlat13);
					    u_xlat2.xyz = vec3(u_xlat13) * u_xlat2.xyz;
					    vs_TEXCOORD5.xyz = u_xlat2.xyz;
					    u_xlat3.xyz = u_xlat1.zxy * u_xlat2.yzx;
					    u_xlat1.xyz = u_xlat1.yzx * u_xlat2.zxy + (-u_xlat3.xyz);
					    u_xlat1.xyz = u_xlat1.xyz * in_TANGENT0.www;
					    u_xlat13 = dot(u_xlat1.xyz, u_xlat1.xyz);
					    u_xlat13 = inversesqrt(u_xlat13);
					    vs_TEXCOORD6.xyz = vec3(u_xlat13) * u_xlat1.xyz;
					    u_xlat1.xyz = u_xlat0.yyy * unity_WorldToLight[1].xyz;
					    u_xlat1.xyz = unity_WorldToLight[0].xyz * u_xlat0.xxx + u_xlat1.xyz;
					    u_xlat1.xyz = unity_WorldToLight[2].xyz * u_xlat0.zzz + u_xlat1.xyz;
					    vs_TEXCOORD7.xyz = unity_WorldToLight[3].xyz * u_xlat0.www + u_xlat1.xyz;
					    vs_TEXCOORD8.xyz = u_xlat0.xyz + (-_LightPositionRange.xyz);
					    return;
					}"
				}
				SubProgram "d3d11 " {
					Keywords { "POINT" "SHADOWS_CUBE" "SHADOWS_SOFT" "DIRLIGHTMAP_COMBINED" "LIGHTMAP_OFF" "DYNAMICLIGHTMAP_OFF" }
					"vs_4_0
					
					#version 330
					#extension GL_ARB_explicit_attrib_location : require
					#extension GL_ARB_explicit_uniform_location : require
					
					#define HLSLCC_ENABLE_UNIFORM_BUFFERS 1
					#if HLSLCC_ENABLE_UNIFORM_BUFFERS
					#define UNITY_UNIFORM
					#else
					#define UNITY_UNIFORM uniform
					#endif
					#define UNITY_SUPPORTS_UNIFORM_LOCATION 1
					#if UNITY_SUPPORTS_UNIFORM_LOCATION
					#define UNITY_LOCATION(x) layout(location = x)
					#define UNITY_BINDING(x) layout(binding = x, std140)
					#else
					#define UNITY_LOCATION(x)
					#define UNITY_BINDING(x) layout(std140)
					#endif
					layout(std140) uniform VGlobals {
						vec4 unused_0_0[2];
						mat4x4 unity_WorldToLight;
						vec4 unused_0_2[2];
						vec4 _MainTexture_ST;
						vec4 unused_0_4[2];
						vec4 _Color;
						vec4 _Heightmap_ST;
						float _Bumpiness;
						float _BumpAttune;
					};
					layout(std140) uniform UnityLighting {
						vec4 unused_1_0;
						vec4 _LightPositionRange;
						vec4 unused_1_2[46];
					};
					layout(std140) uniform UnityPerDraw {
						mat4x4 unity_ObjectToWorld;
						mat4x4 unity_WorldToObject;
						vec4 unused_2_2[2];
					};
					layout(std140) uniform UnityPerFrame {
						vec4 unused_3_0[17];
						mat4x4 unity_MatrixVP;
						vec4 unused_3_2[2];
					};
					uniform  sampler2D _Heightmap;
					uniform  sampler2D _MainTexture;
					in  vec4 in_POSITION0;
					in  vec3 in_NORMAL0;
					in  vec4 in_TANGENT0;
					in  vec2 in_TEXCOORD0;
					in  vec2 in_TEXCOORD1;
					in  vec2 in_TEXCOORD2;
					out vec2 vs_TEXCOORD0;
					out vec2 vs_TEXCOORD1;
					out vec2 vs_TEXCOORD2;
					out vec4 vs_TEXCOORD3;
					out vec3 vs_TEXCOORD4;
					out vec3 vs_TEXCOORD5;
					out vec3 vs_TEXCOORD6;
					out vec3 vs_TEXCOORD7;
					out vec3 vs_TEXCOORD8;
					vec4 u_xlat0;
					vec4 u_xlat1;
					vec4 u_xlat2;
					vec3 u_xlat3;
					float u_xlat12;
					float u_xlat13;
					void main()
					{
					    u_xlat0.xy = in_TEXCOORD0.xy * _MainTexture_ST.xy + _MainTexture_ST.zw;
					    u_xlat0 = textureLod(_MainTexture, u_xlat0.xy, 0.0);
					    u_xlat0.xyz = u_xlat0.xyz * _Color.xyz;
					    u_xlat1.xyz = u_xlat0.xyz * vec3(-1.0, -1.0, 1.0);
					    u_xlat2.xy = in_TEXCOORD0.xy * _Heightmap_ST.xy + _Heightmap_ST.zw;
					    u_xlat2 = textureLod(_Heightmap, u_xlat2.xy, 0.0);
					    u_xlat2.xyz = u_xlat2.xyz * vec3(_Bumpiness);
					    u_xlat2.xyz = clamp(u_xlat2.xyz, 0.0, 1.0);
					    u_xlat3.xyz = u_xlat2.xyz + vec3(0.0, 0.0, 1.0);
					    u_xlat2.xyz = u_xlat2.xyz * in_NORMAL0.xyz;
					    u_xlat12 = dot(u_xlat3.xyz, u_xlat1.xyz);
					    u_xlat1.xyz = vec3(u_xlat12) * u_xlat3.xyz;
					    u_xlat1.xyz = u_xlat1.xyz / u_xlat3.zzz;
					    u_xlat0.xyz = (-u_xlat0.xyz) * vec3(-1.0, -1.0, 1.0) + u_xlat1.xyz;
					    u_xlat0.x = dot(u_xlat0.xyz, vec3(0.300000012, 0.589999974, 0.109999999));
					    u_xlat0.xyz = u_xlat2.xyz * u_xlat0.xxx + (-u_xlat2.xyz);
					    u_xlat0.xyz = vec3(vec3(_BumpAttune, _BumpAttune, _BumpAttune)) * u_xlat0.xyz + u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz + in_POSITION0.xyz;
					    u_xlat1 = u_xlat0.yyyy * unity_ObjectToWorld[1];
					    u_xlat1 = unity_ObjectToWorld[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat0 = unity_ObjectToWorld[2] * u_xlat0.zzzz + u_xlat1;
					    u_xlat1 = u_xlat0 + unity_ObjectToWorld[3];
					    u_xlat0 = unity_ObjectToWorld[3] * in_POSITION0.wwww + u_xlat0;
					    u_xlat2 = u_xlat1.yyyy * unity_MatrixVP[1];
					    u_xlat2 = unity_MatrixVP[0] * u_xlat1.xxxx + u_xlat2;
					    u_xlat2 = unity_MatrixVP[2] * u_xlat1.zzzz + u_xlat2;
					    gl_Position = unity_MatrixVP[3] * u_xlat1.wwww + u_xlat2;
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
					    vs_TEXCOORD1.xy = in_TEXCOORD1.xy;
					    vs_TEXCOORD2.xy = in_TEXCOORD2.xy;
					    vs_TEXCOORD3 = u_xlat0;
					    u_xlat1.x = dot(in_NORMAL0.xyz, unity_WorldToObject[0].xyz);
					    u_xlat1.y = dot(in_NORMAL0.xyz, unity_WorldToObject[1].xyz);
					    u_xlat1.z = dot(in_NORMAL0.xyz, unity_WorldToObject[2].xyz);
					    u_xlat13 = dot(u_xlat1.xyz, u_xlat1.xyz);
					    u_xlat13 = inversesqrt(u_xlat13);
					    u_xlat1.xyz = vec3(u_xlat13) * u_xlat1.xyz;
					    vs_TEXCOORD4.xyz = u_xlat1.xyz;
					    u_xlat2.xyz = in_TANGENT0.yyy * unity_ObjectToWorld[1].xyz;
					    u_xlat2.xyz = unity_ObjectToWorld[0].xyz * in_TANGENT0.xxx + u_xlat2.xyz;
					    u_xlat2.xyz = unity_ObjectToWorld[2].xyz * in_TANGENT0.zzz + u_xlat2.xyz;
					    u_xlat13 = dot(u_xlat2.xyz, u_xlat2.xyz);
					    u_xlat13 = inversesqrt(u_xlat13);
					    u_xlat2.xyz = vec3(u_xlat13) * u_xlat2.xyz;
					    vs_TEXCOORD5.xyz = u_xlat2.xyz;
					    u_xlat3.xyz = u_xlat1.zxy * u_xlat2.yzx;
					    u_xlat1.xyz = u_xlat1.yzx * u_xlat2.zxy + (-u_xlat3.xyz);
					    u_xlat1.xyz = u_xlat1.xyz * in_TANGENT0.www;
					    u_xlat13 = dot(u_xlat1.xyz, u_xlat1.xyz);
					    u_xlat13 = inversesqrt(u_xlat13);
					    vs_TEXCOORD6.xyz = vec3(u_xlat13) * u_xlat1.xyz;
					    u_xlat1.xyz = u_xlat0.yyy * unity_WorldToLight[1].xyz;
					    u_xlat1.xyz = unity_WorldToLight[0].xyz * u_xlat0.xxx + u_xlat1.xyz;
					    u_xlat1.xyz = unity_WorldToLight[2].xyz * u_xlat0.zzz + u_xlat1.xyz;
					    vs_TEXCOORD7.xyz = unity_WorldToLight[3].xyz * u_xlat0.www + u_xlat1.xyz;
					    vs_TEXCOORD8.xyz = u_xlat0.xyz + (-_LightPositionRange.xyz);
					    return;
					}"
				}
				SubProgram "d3d11 " {
					Keywords { "POINT_COOKIE" "SHADOWS_CUBE" "DIRLIGHTMAP_COMBINED" "LIGHTMAP_OFF" "DYNAMICLIGHTMAP_OFF" }
					"vs_4_0
					
					#version 330
					#extension GL_ARB_explicit_attrib_location : require
					#extension GL_ARB_explicit_uniform_location : require
					
					#define HLSLCC_ENABLE_UNIFORM_BUFFERS 1
					#if HLSLCC_ENABLE_UNIFORM_BUFFERS
					#define UNITY_UNIFORM
					#else
					#define UNITY_UNIFORM uniform
					#endif
					#define UNITY_SUPPORTS_UNIFORM_LOCATION 1
					#if UNITY_SUPPORTS_UNIFORM_LOCATION
					#define UNITY_LOCATION(x) layout(location = x)
					#define UNITY_BINDING(x) layout(binding = x, std140)
					#else
					#define UNITY_LOCATION(x)
					#define UNITY_BINDING(x) layout(std140)
					#endif
					layout(std140) uniform VGlobals {
						vec4 unused_0_0[2];
						mat4x4 unity_WorldToLight;
						vec4 unused_0_2[2];
						vec4 _MainTexture_ST;
						vec4 unused_0_4[2];
						vec4 _Color;
						vec4 _Heightmap_ST;
						float _Bumpiness;
						float _BumpAttune;
					};
					layout(std140) uniform UnityLighting {
						vec4 unused_1_0;
						vec4 _LightPositionRange;
						vec4 unused_1_2[46];
					};
					layout(std140) uniform UnityPerDraw {
						mat4x4 unity_ObjectToWorld;
						mat4x4 unity_WorldToObject;
						vec4 unused_2_2[2];
					};
					layout(std140) uniform UnityPerFrame {
						vec4 unused_3_0[17];
						mat4x4 unity_MatrixVP;
						vec4 unused_3_2[2];
					};
					uniform  sampler2D _Heightmap;
					uniform  sampler2D _MainTexture;
					in  vec4 in_POSITION0;
					in  vec3 in_NORMAL0;
					in  vec4 in_TANGENT0;
					in  vec2 in_TEXCOORD0;
					in  vec2 in_TEXCOORD1;
					in  vec2 in_TEXCOORD2;
					out vec2 vs_TEXCOORD0;
					out vec2 vs_TEXCOORD1;
					out vec2 vs_TEXCOORD2;
					out vec4 vs_TEXCOORD3;
					out vec3 vs_TEXCOORD4;
					out vec3 vs_TEXCOORD5;
					out vec3 vs_TEXCOORD6;
					out vec3 vs_TEXCOORD7;
					out vec3 vs_TEXCOORD8;
					vec4 u_xlat0;
					vec4 u_xlat1;
					vec4 u_xlat2;
					vec3 u_xlat3;
					float u_xlat12;
					float u_xlat13;
					void main()
					{
					    u_xlat0.xy = in_TEXCOORD0.xy * _MainTexture_ST.xy + _MainTexture_ST.zw;
					    u_xlat0 = textureLod(_MainTexture, u_xlat0.xy, 0.0);
					    u_xlat0.xyz = u_xlat0.xyz * _Color.xyz;
					    u_xlat1.xyz = u_xlat0.xyz * vec3(-1.0, -1.0, 1.0);
					    u_xlat2.xy = in_TEXCOORD0.xy * _Heightmap_ST.xy + _Heightmap_ST.zw;
					    u_xlat2 = textureLod(_Heightmap, u_xlat2.xy, 0.0);
					    u_xlat2.xyz = u_xlat2.xyz * vec3(_Bumpiness);
					    u_xlat2.xyz = clamp(u_xlat2.xyz, 0.0, 1.0);
					    u_xlat3.xyz = u_xlat2.xyz + vec3(0.0, 0.0, 1.0);
					    u_xlat2.xyz = u_xlat2.xyz * in_NORMAL0.xyz;
					    u_xlat12 = dot(u_xlat3.xyz, u_xlat1.xyz);
					    u_xlat1.xyz = vec3(u_xlat12) * u_xlat3.xyz;
					    u_xlat1.xyz = u_xlat1.xyz / u_xlat3.zzz;
					    u_xlat0.xyz = (-u_xlat0.xyz) * vec3(-1.0, -1.0, 1.0) + u_xlat1.xyz;
					    u_xlat0.x = dot(u_xlat0.xyz, vec3(0.300000012, 0.589999974, 0.109999999));
					    u_xlat0.xyz = u_xlat2.xyz * u_xlat0.xxx + (-u_xlat2.xyz);
					    u_xlat0.xyz = vec3(vec3(_BumpAttune, _BumpAttune, _BumpAttune)) * u_xlat0.xyz + u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz + in_POSITION0.xyz;
					    u_xlat1 = u_xlat0.yyyy * unity_ObjectToWorld[1];
					    u_xlat1 = unity_ObjectToWorld[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat0 = unity_ObjectToWorld[2] * u_xlat0.zzzz + u_xlat1;
					    u_xlat1 = u_xlat0 + unity_ObjectToWorld[3];
					    u_xlat0 = unity_ObjectToWorld[3] * in_POSITION0.wwww + u_xlat0;
					    u_xlat2 = u_xlat1.yyyy * unity_MatrixVP[1];
					    u_xlat2 = unity_MatrixVP[0] * u_xlat1.xxxx + u_xlat2;
					    u_xlat2 = unity_MatrixVP[2] * u_xlat1.zzzz + u_xlat2;
					    gl_Position = unity_MatrixVP[3] * u_xlat1.wwww + u_xlat2;
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
					    vs_TEXCOORD1.xy = in_TEXCOORD1.xy;
					    vs_TEXCOORD2.xy = in_TEXCOORD2.xy;
					    vs_TEXCOORD3 = u_xlat0;
					    u_xlat1.x = dot(in_NORMAL0.xyz, unity_WorldToObject[0].xyz);
					    u_xlat1.y = dot(in_NORMAL0.xyz, unity_WorldToObject[1].xyz);
					    u_xlat1.z = dot(in_NORMAL0.xyz, unity_WorldToObject[2].xyz);
					    u_xlat13 = dot(u_xlat1.xyz, u_xlat1.xyz);
					    u_xlat13 = inversesqrt(u_xlat13);
					    u_xlat1.xyz = vec3(u_xlat13) * u_xlat1.xyz;
					    vs_TEXCOORD4.xyz = u_xlat1.xyz;
					    u_xlat2.xyz = in_TANGENT0.yyy * unity_ObjectToWorld[1].xyz;
					    u_xlat2.xyz = unity_ObjectToWorld[0].xyz * in_TANGENT0.xxx + u_xlat2.xyz;
					    u_xlat2.xyz = unity_ObjectToWorld[2].xyz * in_TANGENT0.zzz + u_xlat2.xyz;
					    u_xlat13 = dot(u_xlat2.xyz, u_xlat2.xyz);
					    u_xlat13 = inversesqrt(u_xlat13);
					    u_xlat2.xyz = vec3(u_xlat13) * u_xlat2.xyz;
					    vs_TEXCOORD5.xyz = u_xlat2.xyz;
					    u_xlat3.xyz = u_xlat1.zxy * u_xlat2.yzx;
					    u_xlat1.xyz = u_xlat1.yzx * u_xlat2.zxy + (-u_xlat3.xyz);
					    u_xlat1.xyz = u_xlat1.xyz * in_TANGENT0.www;
					    u_xlat13 = dot(u_xlat1.xyz, u_xlat1.xyz);
					    u_xlat13 = inversesqrt(u_xlat13);
					    vs_TEXCOORD6.xyz = vec3(u_xlat13) * u_xlat1.xyz;
					    u_xlat1.xyz = u_xlat0.yyy * unity_WorldToLight[1].xyz;
					    u_xlat1.xyz = unity_WorldToLight[0].xyz * u_xlat0.xxx + u_xlat1.xyz;
					    u_xlat1.xyz = unity_WorldToLight[2].xyz * u_xlat0.zzz + u_xlat1.xyz;
					    vs_TEXCOORD7.xyz = unity_WorldToLight[3].xyz * u_xlat0.www + u_xlat1.xyz;
					    vs_TEXCOORD8.xyz = u_xlat0.xyz + (-_LightPositionRange.xyz);
					    return;
					}"
				}
				SubProgram "d3d11 " {
					Keywords { "POINT_COOKIE" "SHADOWS_CUBE" "SHADOWS_SOFT" "DIRLIGHTMAP_COMBINED" "LIGHTMAP_OFF" "DYNAMICLIGHTMAP_OFF" }
					"vs_4_0
					
					#version 330
					#extension GL_ARB_explicit_attrib_location : require
					#extension GL_ARB_explicit_uniform_location : require
					
					#define HLSLCC_ENABLE_UNIFORM_BUFFERS 1
					#if HLSLCC_ENABLE_UNIFORM_BUFFERS
					#define UNITY_UNIFORM
					#else
					#define UNITY_UNIFORM uniform
					#endif
					#define UNITY_SUPPORTS_UNIFORM_LOCATION 1
					#if UNITY_SUPPORTS_UNIFORM_LOCATION
					#define UNITY_LOCATION(x) layout(location = x)
					#define UNITY_BINDING(x) layout(binding = x, std140)
					#else
					#define UNITY_LOCATION(x)
					#define UNITY_BINDING(x) layout(std140)
					#endif
					layout(std140) uniform VGlobals {
						vec4 unused_0_0[2];
						mat4x4 unity_WorldToLight;
						vec4 unused_0_2[2];
						vec4 _MainTexture_ST;
						vec4 unused_0_4[2];
						vec4 _Color;
						vec4 _Heightmap_ST;
						float _Bumpiness;
						float _BumpAttune;
					};
					layout(std140) uniform UnityLighting {
						vec4 unused_1_0;
						vec4 _LightPositionRange;
						vec4 unused_1_2[46];
					};
					layout(std140) uniform UnityPerDraw {
						mat4x4 unity_ObjectToWorld;
						mat4x4 unity_WorldToObject;
						vec4 unused_2_2[2];
					};
					layout(std140) uniform UnityPerFrame {
						vec4 unused_3_0[17];
						mat4x4 unity_MatrixVP;
						vec4 unused_3_2[2];
					};
					uniform  sampler2D _Heightmap;
					uniform  sampler2D _MainTexture;
					in  vec4 in_POSITION0;
					in  vec3 in_NORMAL0;
					in  vec4 in_TANGENT0;
					in  vec2 in_TEXCOORD0;
					in  vec2 in_TEXCOORD1;
					in  vec2 in_TEXCOORD2;
					out vec2 vs_TEXCOORD0;
					out vec2 vs_TEXCOORD1;
					out vec2 vs_TEXCOORD2;
					out vec4 vs_TEXCOORD3;
					out vec3 vs_TEXCOORD4;
					out vec3 vs_TEXCOORD5;
					out vec3 vs_TEXCOORD6;
					out vec3 vs_TEXCOORD7;
					out vec3 vs_TEXCOORD8;
					vec4 u_xlat0;
					vec4 u_xlat1;
					vec4 u_xlat2;
					vec3 u_xlat3;
					float u_xlat12;
					float u_xlat13;
					void main()
					{
					    u_xlat0.xy = in_TEXCOORD0.xy * _MainTexture_ST.xy + _MainTexture_ST.zw;
					    u_xlat0 = textureLod(_MainTexture, u_xlat0.xy, 0.0);
					    u_xlat0.xyz = u_xlat0.xyz * _Color.xyz;
					    u_xlat1.xyz = u_xlat0.xyz * vec3(-1.0, -1.0, 1.0);
					    u_xlat2.xy = in_TEXCOORD0.xy * _Heightmap_ST.xy + _Heightmap_ST.zw;
					    u_xlat2 = textureLod(_Heightmap, u_xlat2.xy, 0.0);
					    u_xlat2.xyz = u_xlat2.xyz * vec3(_Bumpiness);
					    u_xlat2.xyz = clamp(u_xlat2.xyz, 0.0, 1.0);
					    u_xlat3.xyz = u_xlat2.xyz + vec3(0.0, 0.0, 1.0);
					    u_xlat2.xyz = u_xlat2.xyz * in_NORMAL0.xyz;
					    u_xlat12 = dot(u_xlat3.xyz, u_xlat1.xyz);
					    u_xlat1.xyz = vec3(u_xlat12) * u_xlat3.xyz;
					    u_xlat1.xyz = u_xlat1.xyz / u_xlat3.zzz;
					    u_xlat0.xyz = (-u_xlat0.xyz) * vec3(-1.0, -1.0, 1.0) + u_xlat1.xyz;
					    u_xlat0.x = dot(u_xlat0.xyz, vec3(0.300000012, 0.589999974, 0.109999999));
					    u_xlat0.xyz = u_xlat2.xyz * u_xlat0.xxx + (-u_xlat2.xyz);
					    u_xlat0.xyz = vec3(vec3(_BumpAttune, _BumpAttune, _BumpAttune)) * u_xlat0.xyz + u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz + in_POSITION0.xyz;
					    u_xlat1 = u_xlat0.yyyy * unity_ObjectToWorld[1];
					    u_xlat1 = unity_ObjectToWorld[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat0 = unity_ObjectToWorld[2] * u_xlat0.zzzz + u_xlat1;
					    u_xlat1 = u_xlat0 + unity_ObjectToWorld[3];
					    u_xlat0 = unity_ObjectToWorld[3] * in_POSITION0.wwww + u_xlat0;
					    u_xlat2 = u_xlat1.yyyy * unity_MatrixVP[1];
					    u_xlat2 = unity_MatrixVP[0] * u_xlat1.xxxx + u_xlat2;
					    u_xlat2 = unity_MatrixVP[2] * u_xlat1.zzzz + u_xlat2;
					    gl_Position = unity_MatrixVP[3] * u_xlat1.wwww + u_xlat2;
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
					    vs_TEXCOORD1.xy = in_TEXCOORD1.xy;
					    vs_TEXCOORD2.xy = in_TEXCOORD2.xy;
					    vs_TEXCOORD3 = u_xlat0;
					    u_xlat1.x = dot(in_NORMAL0.xyz, unity_WorldToObject[0].xyz);
					    u_xlat1.y = dot(in_NORMAL0.xyz, unity_WorldToObject[1].xyz);
					    u_xlat1.z = dot(in_NORMAL0.xyz, unity_WorldToObject[2].xyz);
					    u_xlat13 = dot(u_xlat1.xyz, u_xlat1.xyz);
					    u_xlat13 = inversesqrt(u_xlat13);
					    u_xlat1.xyz = vec3(u_xlat13) * u_xlat1.xyz;
					    vs_TEXCOORD4.xyz = u_xlat1.xyz;
					    u_xlat2.xyz = in_TANGENT0.yyy * unity_ObjectToWorld[1].xyz;
					    u_xlat2.xyz = unity_ObjectToWorld[0].xyz * in_TANGENT0.xxx + u_xlat2.xyz;
					    u_xlat2.xyz = unity_ObjectToWorld[2].xyz * in_TANGENT0.zzz + u_xlat2.xyz;
					    u_xlat13 = dot(u_xlat2.xyz, u_xlat2.xyz);
					    u_xlat13 = inversesqrt(u_xlat13);
					    u_xlat2.xyz = vec3(u_xlat13) * u_xlat2.xyz;
					    vs_TEXCOORD5.xyz = u_xlat2.xyz;
					    u_xlat3.xyz = u_xlat1.zxy * u_xlat2.yzx;
					    u_xlat1.xyz = u_xlat1.yzx * u_xlat2.zxy + (-u_xlat3.xyz);
					    u_xlat1.xyz = u_xlat1.xyz * in_TANGENT0.www;
					    u_xlat13 = dot(u_xlat1.xyz, u_xlat1.xyz);
					    u_xlat13 = inversesqrt(u_xlat13);
					    vs_TEXCOORD6.xyz = vec3(u_xlat13) * u_xlat1.xyz;
					    u_xlat1.xyz = u_xlat0.yyy * unity_WorldToLight[1].xyz;
					    u_xlat1.xyz = unity_WorldToLight[0].xyz * u_xlat0.xxx + u_xlat1.xyz;
					    u_xlat1.xyz = unity_WorldToLight[2].xyz * u_xlat0.zzz + u_xlat1.xyz;
					    vs_TEXCOORD7.xyz = unity_WorldToLight[3].xyz * u_xlat0.www + u_xlat1.xyz;
					    vs_TEXCOORD8.xyz = u_xlat0.xyz + (-_LightPositionRange.xyz);
					    return;
					}"
				}
				SubProgram "d3d11 " {
					Keywords { "POINT" "DIRLIGHTMAP_SEPARATE" "LIGHTMAP_OFF" "DYNAMICLIGHTMAP_OFF" }
					"vs_4_0
					
					#version 330
					#extension GL_ARB_explicit_attrib_location : require
					#extension GL_ARB_explicit_uniform_location : require
					
					#define HLSLCC_ENABLE_UNIFORM_BUFFERS 1
					#if HLSLCC_ENABLE_UNIFORM_BUFFERS
					#define UNITY_UNIFORM
					#else
					#define UNITY_UNIFORM uniform
					#endif
					#define UNITY_SUPPORTS_UNIFORM_LOCATION 1
					#if UNITY_SUPPORTS_UNIFORM_LOCATION
					#define UNITY_LOCATION(x) layout(location = x)
					#define UNITY_BINDING(x) layout(binding = x, std140)
					#else
					#define UNITY_LOCATION(x)
					#define UNITY_BINDING(x) layout(std140)
					#endif
					layout(std140) uniform VGlobals {
						vec4 unused_0_0[2];
						mat4x4 unity_WorldToLight;
						vec4 unused_0_2[2];
						vec4 _MainTexture_ST;
						vec4 unused_0_4[2];
						vec4 _Color;
						vec4 _Heightmap_ST;
						float _Bumpiness;
						float _BumpAttune;
					};
					layout(std140) uniform UnityPerDraw {
						mat4x4 unity_ObjectToWorld;
						mat4x4 unity_WorldToObject;
						vec4 unused_1_2[2];
					};
					layout(std140) uniform UnityPerFrame {
						vec4 unused_2_0[17];
						mat4x4 unity_MatrixVP;
						vec4 unused_2_2[2];
					};
					uniform  sampler2D _Heightmap;
					uniform  sampler2D _MainTexture;
					in  vec4 in_POSITION0;
					in  vec3 in_NORMAL0;
					in  vec4 in_TANGENT0;
					in  vec2 in_TEXCOORD0;
					in  vec2 in_TEXCOORD1;
					in  vec2 in_TEXCOORD2;
					out vec2 vs_TEXCOORD0;
					out vec2 vs_TEXCOORD1;
					out vec2 vs_TEXCOORD2;
					out vec4 vs_TEXCOORD3;
					out vec3 vs_TEXCOORD4;
					out vec3 vs_TEXCOORD5;
					out vec3 vs_TEXCOORD6;
					out vec3 vs_TEXCOORD7;
					vec4 u_xlat0;
					vec4 u_xlat1;
					vec4 u_xlat2;
					vec3 u_xlat3;
					float u_xlat12;
					float u_xlat13;
					void main()
					{
					    u_xlat0.xy = in_TEXCOORD0.xy * _MainTexture_ST.xy + _MainTexture_ST.zw;
					    u_xlat0 = textureLod(_MainTexture, u_xlat0.xy, 0.0);
					    u_xlat0.xyz = u_xlat0.xyz * _Color.xyz;
					    u_xlat1.xyz = u_xlat0.xyz * vec3(-1.0, -1.0, 1.0);
					    u_xlat2.xy = in_TEXCOORD0.xy * _Heightmap_ST.xy + _Heightmap_ST.zw;
					    u_xlat2 = textureLod(_Heightmap, u_xlat2.xy, 0.0);
					    u_xlat2.xyz = u_xlat2.xyz * vec3(_Bumpiness);
					    u_xlat2.xyz = clamp(u_xlat2.xyz, 0.0, 1.0);
					    u_xlat3.xyz = u_xlat2.xyz + vec3(0.0, 0.0, 1.0);
					    u_xlat2.xyz = u_xlat2.xyz * in_NORMAL0.xyz;
					    u_xlat12 = dot(u_xlat3.xyz, u_xlat1.xyz);
					    u_xlat1.xyz = vec3(u_xlat12) * u_xlat3.xyz;
					    u_xlat1.xyz = u_xlat1.xyz / u_xlat3.zzz;
					    u_xlat0.xyz = (-u_xlat0.xyz) * vec3(-1.0, -1.0, 1.0) + u_xlat1.xyz;
					    u_xlat0.x = dot(u_xlat0.xyz, vec3(0.300000012, 0.589999974, 0.109999999));
					    u_xlat0.xyz = u_xlat2.xyz * u_xlat0.xxx + (-u_xlat2.xyz);
					    u_xlat0.xyz = vec3(vec3(_BumpAttune, _BumpAttune, _BumpAttune)) * u_xlat0.xyz + u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz + in_POSITION0.xyz;
					    u_xlat1 = u_xlat0.yyyy * unity_ObjectToWorld[1];
					    u_xlat1 = unity_ObjectToWorld[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat0 = unity_ObjectToWorld[2] * u_xlat0.zzzz + u_xlat1;
					    u_xlat1 = u_xlat0 + unity_ObjectToWorld[3];
					    u_xlat0 = unity_ObjectToWorld[3] * in_POSITION0.wwww + u_xlat0;
					    u_xlat2 = u_xlat1.yyyy * unity_MatrixVP[1];
					    u_xlat2 = unity_MatrixVP[0] * u_xlat1.xxxx + u_xlat2;
					    u_xlat2 = unity_MatrixVP[2] * u_xlat1.zzzz + u_xlat2;
					    gl_Position = unity_MatrixVP[3] * u_xlat1.wwww + u_xlat2;
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
					    vs_TEXCOORD1.xy = in_TEXCOORD1.xy;
					    vs_TEXCOORD2.xy = in_TEXCOORD2.xy;
					    vs_TEXCOORD3 = u_xlat0;
					    u_xlat1.x = dot(in_NORMAL0.xyz, unity_WorldToObject[0].xyz);
					    u_xlat1.y = dot(in_NORMAL0.xyz, unity_WorldToObject[1].xyz);
					    u_xlat1.z = dot(in_NORMAL0.xyz, unity_WorldToObject[2].xyz);
					    u_xlat13 = dot(u_xlat1.xyz, u_xlat1.xyz);
					    u_xlat13 = inversesqrt(u_xlat13);
					    u_xlat1.xyz = vec3(u_xlat13) * u_xlat1.xyz;
					    vs_TEXCOORD4.xyz = u_xlat1.xyz;
					    u_xlat2.xyz = in_TANGENT0.yyy * unity_ObjectToWorld[1].xyz;
					    u_xlat2.xyz = unity_ObjectToWorld[0].xyz * in_TANGENT0.xxx + u_xlat2.xyz;
					    u_xlat2.xyz = unity_ObjectToWorld[2].xyz * in_TANGENT0.zzz + u_xlat2.xyz;
					    u_xlat13 = dot(u_xlat2.xyz, u_xlat2.xyz);
					    u_xlat13 = inversesqrt(u_xlat13);
					    u_xlat2.xyz = vec3(u_xlat13) * u_xlat2.xyz;
					    vs_TEXCOORD5.xyz = u_xlat2.xyz;
					    u_xlat3.xyz = u_xlat1.zxy * u_xlat2.yzx;
					    u_xlat1.xyz = u_xlat1.yzx * u_xlat2.zxy + (-u_xlat3.xyz);
					    u_xlat1.xyz = u_xlat1.xyz * in_TANGENT0.www;
					    u_xlat13 = dot(u_xlat1.xyz, u_xlat1.xyz);
					    u_xlat13 = inversesqrt(u_xlat13);
					    vs_TEXCOORD6.xyz = vec3(u_xlat13) * u_xlat1.xyz;
					    u_xlat1.xyz = u_xlat0.yyy * unity_WorldToLight[1].xyz;
					    u_xlat1.xyz = unity_WorldToLight[0].xyz * u_xlat0.xxx + u_xlat1.xyz;
					    u_xlat0.xyz = unity_WorldToLight[2].xyz * u_xlat0.zzz + u_xlat1.xyz;
					    vs_TEXCOORD7.xyz = unity_WorldToLight[3].xyz * u_xlat0.www + u_xlat0.xyz;
					    return;
					}"
				}
				SubProgram "d3d11 " {
					Keywords { "DIRECTIONAL" "DIRLIGHTMAP_SEPARATE" "LIGHTMAP_OFF" "DYNAMICLIGHTMAP_OFF" }
					"vs_4_0
					
					#version 330
					#extension GL_ARB_explicit_attrib_location : require
					#extension GL_ARB_explicit_uniform_location : require
					
					#define HLSLCC_ENABLE_UNIFORM_BUFFERS 1
					#if HLSLCC_ENABLE_UNIFORM_BUFFERS
					#define UNITY_UNIFORM
					#else
					#define UNITY_UNIFORM uniform
					#endif
					#define UNITY_SUPPORTS_UNIFORM_LOCATION 1
					#if UNITY_SUPPORTS_UNIFORM_LOCATION
					#define UNITY_LOCATION(x) layout(location = x)
					#define UNITY_BINDING(x) layout(binding = x, std140)
					#else
					#define UNITY_LOCATION(x)
					#define UNITY_BINDING(x) layout(std140)
					#endif
					layout(std140) uniform VGlobals {
						vec4 unused_0_0[4];
						vec4 _MainTexture_ST;
						vec4 unused_0_2[2];
						vec4 _Color;
						vec4 _Heightmap_ST;
						float _Bumpiness;
						float _BumpAttune;
					};
					layout(std140) uniform UnityPerDraw {
						mat4x4 unity_ObjectToWorld;
						mat4x4 unity_WorldToObject;
						vec4 unused_1_2[2];
					};
					layout(std140) uniform UnityPerFrame {
						vec4 unused_2_0[17];
						mat4x4 unity_MatrixVP;
						vec4 unused_2_2[2];
					};
					uniform  sampler2D _Heightmap;
					uniform  sampler2D _MainTexture;
					in  vec4 in_POSITION0;
					in  vec3 in_NORMAL0;
					in  vec4 in_TANGENT0;
					in  vec2 in_TEXCOORD0;
					in  vec2 in_TEXCOORD1;
					in  vec2 in_TEXCOORD2;
					out vec2 vs_TEXCOORD0;
					out vec2 vs_TEXCOORD1;
					out vec2 vs_TEXCOORD2;
					out vec4 vs_TEXCOORD3;
					out vec3 vs_TEXCOORD4;
					out vec3 vs_TEXCOORD5;
					out vec3 vs_TEXCOORD6;
					vec4 u_xlat0;
					vec4 u_xlat1;
					vec4 u_xlat2;
					vec3 u_xlat3;
					float u_xlat12;
					void main()
					{
					    u_xlat0.xy = in_TEXCOORD0.xy * _MainTexture_ST.xy + _MainTexture_ST.zw;
					    u_xlat0 = textureLod(_MainTexture, u_xlat0.xy, 0.0);
					    u_xlat0.xyz = u_xlat0.xyz * _Color.xyz;
					    u_xlat1.xyz = u_xlat0.xyz * vec3(-1.0, -1.0, 1.0);
					    u_xlat2.xy = in_TEXCOORD0.xy * _Heightmap_ST.xy + _Heightmap_ST.zw;
					    u_xlat2 = textureLod(_Heightmap, u_xlat2.xy, 0.0);
					    u_xlat2.xyz = u_xlat2.xyz * vec3(_Bumpiness);
					    u_xlat2.xyz = clamp(u_xlat2.xyz, 0.0, 1.0);
					    u_xlat3.xyz = u_xlat2.xyz + vec3(0.0, 0.0, 1.0);
					    u_xlat2.xyz = u_xlat2.xyz * in_NORMAL0.xyz;
					    u_xlat12 = dot(u_xlat3.xyz, u_xlat1.xyz);
					    u_xlat1.xyz = vec3(u_xlat12) * u_xlat3.xyz;
					    u_xlat1.xyz = u_xlat1.xyz / u_xlat3.zzz;
					    u_xlat0.xyz = (-u_xlat0.xyz) * vec3(-1.0, -1.0, 1.0) + u_xlat1.xyz;
					    u_xlat0.x = dot(u_xlat0.xyz, vec3(0.300000012, 0.589999974, 0.109999999));
					    u_xlat0.xyz = u_xlat2.xyz * u_xlat0.xxx + (-u_xlat2.xyz);
					    u_xlat0.xyz = vec3(vec3(_BumpAttune, _BumpAttune, _BumpAttune)) * u_xlat0.xyz + u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz + in_POSITION0.xyz;
					    u_xlat1 = u_xlat0.yyyy * unity_ObjectToWorld[1];
					    u_xlat1 = unity_ObjectToWorld[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat0 = unity_ObjectToWorld[2] * u_xlat0.zzzz + u_xlat1;
					    u_xlat1 = u_xlat0 + unity_ObjectToWorld[3];
					    vs_TEXCOORD3 = unity_ObjectToWorld[3] * in_POSITION0.wwww + u_xlat0;
					    u_xlat0 = u_xlat1.yyyy * unity_MatrixVP[1];
					    u_xlat0 = unity_MatrixVP[0] * u_xlat1.xxxx + u_xlat0;
					    u_xlat0 = unity_MatrixVP[2] * u_xlat1.zzzz + u_xlat0;
					    gl_Position = unity_MatrixVP[3] * u_xlat1.wwww + u_xlat0;
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
					    vs_TEXCOORD1.xy = in_TEXCOORD1.xy;
					    vs_TEXCOORD2.xy = in_TEXCOORD2.xy;
					    u_xlat0.x = dot(in_NORMAL0.xyz, unity_WorldToObject[0].xyz);
					    u_xlat0.y = dot(in_NORMAL0.xyz, unity_WorldToObject[1].xyz);
					    u_xlat0.z = dot(in_NORMAL0.xyz, unity_WorldToObject[2].xyz);
					    u_xlat12 = dot(u_xlat0.xyz, u_xlat0.xyz);
					    u_xlat12 = inversesqrt(u_xlat12);
					    u_xlat0.xyz = vec3(u_xlat12) * u_xlat0.xyz;
					    vs_TEXCOORD4.xyz = u_xlat0.xyz;
					    u_xlat1.xyz = in_TANGENT0.yyy * unity_ObjectToWorld[1].xyz;
					    u_xlat1.xyz = unity_ObjectToWorld[0].xyz * in_TANGENT0.xxx + u_xlat1.xyz;
					    u_xlat1.xyz = unity_ObjectToWorld[2].xyz * in_TANGENT0.zzz + u_xlat1.xyz;
					    u_xlat12 = dot(u_xlat1.xyz, u_xlat1.xyz);
					    u_xlat12 = inversesqrt(u_xlat12);
					    u_xlat1.xyz = vec3(u_xlat12) * u_xlat1.xyz;
					    vs_TEXCOORD5.xyz = u_xlat1.xyz;
					    u_xlat2.xyz = u_xlat0.zxy * u_xlat1.yzx;
					    u_xlat0.xyz = u_xlat0.yzx * u_xlat1.zxy + (-u_xlat2.xyz);
					    u_xlat0.xyz = u_xlat0.xyz * in_TANGENT0.www;
					    u_xlat12 = dot(u_xlat0.xyz, u_xlat0.xyz);
					    u_xlat12 = inversesqrt(u_xlat12);
					    vs_TEXCOORD6.xyz = vec3(u_xlat12) * u_xlat0.xyz;
					    return;
					}"
				}
				SubProgram "d3d11 " {
					Keywords { "SPOT" "DIRLIGHTMAP_SEPARATE" "LIGHTMAP_OFF" "DYNAMICLIGHTMAP_OFF" }
					"vs_4_0
					
					#version 330
					#extension GL_ARB_explicit_attrib_location : require
					#extension GL_ARB_explicit_uniform_location : require
					
					#define HLSLCC_ENABLE_UNIFORM_BUFFERS 1
					#if HLSLCC_ENABLE_UNIFORM_BUFFERS
					#define UNITY_UNIFORM
					#else
					#define UNITY_UNIFORM uniform
					#endif
					#define UNITY_SUPPORTS_UNIFORM_LOCATION 1
					#if UNITY_SUPPORTS_UNIFORM_LOCATION
					#define UNITY_LOCATION(x) layout(location = x)
					#define UNITY_BINDING(x) layout(binding = x, std140)
					#else
					#define UNITY_LOCATION(x)
					#define UNITY_BINDING(x) layout(std140)
					#endif
					layout(std140) uniform VGlobals {
						vec4 unused_0_0[2];
						mat4x4 unity_WorldToLight;
						vec4 unused_0_2[2];
						vec4 _MainTexture_ST;
						vec4 unused_0_4[2];
						vec4 _Color;
						vec4 _Heightmap_ST;
						float _Bumpiness;
						float _BumpAttune;
					};
					layout(std140) uniform UnityPerDraw {
						mat4x4 unity_ObjectToWorld;
						mat4x4 unity_WorldToObject;
						vec4 unused_1_2[2];
					};
					layout(std140) uniform UnityPerFrame {
						vec4 unused_2_0[17];
						mat4x4 unity_MatrixVP;
						vec4 unused_2_2[2];
					};
					uniform  sampler2D _Heightmap;
					uniform  sampler2D _MainTexture;
					in  vec4 in_POSITION0;
					in  vec3 in_NORMAL0;
					in  vec4 in_TANGENT0;
					in  vec2 in_TEXCOORD0;
					in  vec2 in_TEXCOORD1;
					in  vec2 in_TEXCOORD2;
					out vec2 vs_TEXCOORD0;
					out vec2 vs_TEXCOORD1;
					out vec2 vs_TEXCOORD2;
					out vec4 vs_TEXCOORD3;
					out vec3 vs_TEXCOORD4;
					out vec3 vs_TEXCOORD5;
					out vec3 vs_TEXCOORD6;
					out vec4 vs_TEXCOORD7;
					vec4 u_xlat0;
					vec4 u_xlat1;
					vec4 u_xlat2;
					vec3 u_xlat3;
					float u_xlat12;
					float u_xlat13;
					void main()
					{
					    u_xlat0.xy = in_TEXCOORD0.xy * _MainTexture_ST.xy + _MainTexture_ST.zw;
					    u_xlat0 = textureLod(_MainTexture, u_xlat0.xy, 0.0);
					    u_xlat0.xyz = u_xlat0.xyz * _Color.xyz;
					    u_xlat1.xyz = u_xlat0.xyz * vec3(-1.0, -1.0, 1.0);
					    u_xlat2.xy = in_TEXCOORD0.xy * _Heightmap_ST.xy + _Heightmap_ST.zw;
					    u_xlat2 = textureLod(_Heightmap, u_xlat2.xy, 0.0);
					    u_xlat2.xyz = u_xlat2.xyz * vec3(_Bumpiness);
					    u_xlat2.xyz = clamp(u_xlat2.xyz, 0.0, 1.0);
					    u_xlat3.xyz = u_xlat2.xyz + vec3(0.0, 0.0, 1.0);
					    u_xlat2.xyz = u_xlat2.xyz * in_NORMAL0.xyz;
					    u_xlat12 = dot(u_xlat3.xyz, u_xlat1.xyz);
					    u_xlat1.xyz = vec3(u_xlat12) * u_xlat3.xyz;
					    u_xlat1.xyz = u_xlat1.xyz / u_xlat3.zzz;
					    u_xlat0.xyz = (-u_xlat0.xyz) * vec3(-1.0, -1.0, 1.0) + u_xlat1.xyz;
					    u_xlat0.x = dot(u_xlat0.xyz, vec3(0.300000012, 0.589999974, 0.109999999));
					    u_xlat0.xyz = u_xlat2.xyz * u_xlat0.xxx + (-u_xlat2.xyz);
					    u_xlat0.xyz = vec3(vec3(_BumpAttune, _BumpAttune, _BumpAttune)) * u_xlat0.xyz + u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz + in_POSITION0.xyz;
					    u_xlat1 = u_xlat0.yyyy * unity_ObjectToWorld[1];
					    u_xlat1 = unity_ObjectToWorld[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat0 = unity_ObjectToWorld[2] * u_xlat0.zzzz + u_xlat1;
					    u_xlat1 = u_xlat0 + unity_ObjectToWorld[3];
					    u_xlat0 = unity_ObjectToWorld[3] * in_POSITION0.wwww + u_xlat0;
					    u_xlat2 = u_xlat1.yyyy * unity_MatrixVP[1];
					    u_xlat2 = unity_MatrixVP[0] * u_xlat1.xxxx + u_xlat2;
					    u_xlat2 = unity_MatrixVP[2] * u_xlat1.zzzz + u_xlat2;
					    gl_Position = unity_MatrixVP[3] * u_xlat1.wwww + u_xlat2;
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
					    vs_TEXCOORD1.xy = in_TEXCOORD1.xy;
					    vs_TEXCOORD2.xy = in_TEXCOORD2.xy;
					    vs_TEXCOORD3 = u_xlat0;
					    u_xlat1.x = dot(in_NORMAL0.xyz, unity_WorldToObject[0].xyz);
					    u_xlat1.y = dot(in_NORMAL0.xyz, unity_WorldToObject[1].xyz);
					    u_xlat1.z = dot(in_NORMAL0.xyz, unity_WorldToObject[2].xyz);
					    u_xlat13 = dot(u_xlat1.xyz, u_xlat1.xyz);
					    u_xlat13 = inversesqrt(u_xlat13);
					    u_xlat1.xyz = vec3(u_xlat13) * u_xlat1.xyz;
					    vs_TEXCOORD4.xyz = u_xlat1.xyz;
					    u_xlat2.xyz = in_TANGENT0.yyy * unity_ObjectToWorld[1].xyz;
					    u_xlat2.xyz = unity_ObjectToWorld[0].xyz * in_TANGENT0.xxx + u_xlat2.xyz;
					    u_xlat2.xyz = unity_ObjectToWorld[2].xyz * in_TANGENT0.zzz + u_xlat2.xyz;
					    u_xlat13 = dot(u_xlat2.xyz, u_xlat2.xyz);
					    u_xlat13 = inversesqrt(u_xlat13);
					    u_xlat2.xyz = vec3(u_xlat13) * u_xlat2.xyz;
					    vs_TEXCOORD5.xyz = u_xlat2.xyz;
					    u_xlat3.xyz = u_xlat1.zxy * u_xlat2.yzx;
					    u_xlat1.xyz = u_xlat1.yzx * u_xlat2.zxy + (-u_xlat3.xyz);
					    u_xlat1.xyz = u_xlat1.xyz * in_TANGENT0.www;
					    u_xlat13 = dot(u_xlat1.xyz, u_xlat1.xyz);
					    u_xlat13 = inversesqrt(u_xlat13);
					    vs_TEXCOORD6.xyz = vec3(u_xlat13) * u_xlat1.xyz;
					    u_xlat1 = u_xlat0.yyyy * unity_WorldToLight[1];
					    u_xlat1 = unity_WorldToLight[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat1 = unity_WorldToLight[2] * u_xlat0.zzzz + u_xlat1;
					    vs_TEXCOORD7 = unity_WorldToLight[3] * u_xlat0.wwww + u_xlat1;
					    return;
					}"
				}
				SubProgram "d3d11 " {
					Keywords { "POINT_COOKIE" "DIRLIGHTMAP_SEPARATE" "LIGHTMAP_OFF" "DYNAMICLIGHTMAP_OFF" }
					"vs_4_0
					
					#version 330
					#extension GL_ARB_explicit_attrib_location : require
					#extension GL_ARB_explicit_uniform_location : require
					
					#define HLSLCC_ENABLE_UNIFORM_BUFFERS 1
					#if HLSLCC_ENABLE_UNIFORM_BUFFERS
					#define UNITY_UNIFORM
					#else
					#define UNITY_UNIFORM uniform
					#endif
					#define UNITY_SUPPORTS_UNIFORM_LOCATION 1
					#if UNITY_SUPPORTS_UNIFORM_LOCATION
					#define UNITY_LOCATION(x) layout(location = x)
					#define UNITY_BINDING(x) layout(binding = x, std140)
					#else
					#define UNITY_LOCATION(x)
					#define UNITY_BINDING(x) layout(std140)
					#endif
					layout(std140) uniform VGlobals {
						vec4 unused_0_0[2];
						mat4x4 unity_WorldToLight;
						vec4 unused_0_2[2];
						vec4 _MainTexture_ST;
						vec4 unused_0_4[2];
						vec4 _Color;
						vec4 _Heightmap_ST;
						float _Bumpiness;
						float _BumpAttune;
					};
					layout(std140) uniform UnityPerDraw {
						mat4x4 unity_ObjectToWorld;
						mat4x4 unity_WorldToObject;
						vec4 unused_1_2[2];
					};
					layout(std140) uniform UnityPerFrame {
						vec4 unused_2_0[17];
						mat4x4 unity_MatrixVP;
						vec4 unused_2_2[2];
					};
					uniform  sampler2D _Heightmap;
					uniform  sampler2D _MainTexture;
					in  vec4 in_POSITION0;
					in  vec3 in_NORMAL0;
					in  vec4 in_TANGENT0;
					in  vec2 in_TEXCOORD0;
					in  vec2 in_TEXCOORD1;
					in  vec2 in_TEXCOORD2;
					out vec2 vs_TEXCOORD0;
					out vec2 vs_TEXCOORD1;
					out vec2 vs_TEXCOORD2;
					out vec4 vs_TEXCOORD3;
					out vec3 vs_TEXCOORD4;
					out vec3 vs_TEXCOORD5;
					out vec3 vs_TEXCOORD6;
					out vec3 vs_TEXCOORD7;
					vec4 u_xlat0;
					vec4 u_xlat1;
					vec4 u_xlat2;
					vec3 u_xlat3;
					float u_xlat12;
					float u_xlat13;
					void main()
					{
					    u_xlat0.xy = in_TEXCOORD0.xy * _MainTexture_ST.xy + _MainTexture_ST.zw;
					    u_xlat0 = textureLod(_MainTexture, u_xlat0.xy, 0.0);
					    u_xlat0.xyz = u_xlat0.xyz * _Color.xyz;
					    u_xlat1.xyz = u_xlat0.xyz * vec3(-1.0, -1.0, 1.0);
					    u_xlat2.xy = in_TEXCOORD0.xy * _Heightmap_ST.xy + _Heightmap_ST.zw;
					    u_xlat2 = textureLod(_Heightmap, u_xlat2.xy, 0.0);
					    u_xlat2.xyz = u_xlat2.xyz * vec3(_Bumpiness);
					    u_xlat2.xyz = clamp(u_xlat2.xyz, 0.0, 1.0);
					    u_xlat3.xyz = u_xlat2.xyz + vec3(0.0, 0.0, 1.0);
					    u_xlat2.xyz = u_xlat2.xyz * in_NORMAL0.xyz;
					    u_xlat12 = dot(u_xlat3.xyz, u_xlat1.xyz);
					    u_xlat1.xyz = vec3(u_xlat12) * u_xlat3.xyz;
					    u_xlat1.xyz = u_xlat1.xyz / u_xlat3.zzz;
					    u_xlat0.xyz = (-u_xlat0.xyz) * vec3(-1.0, -1.0, 1.0) + u_xlat1.xyz;
					    u_xlat0.x = dot(u_xlat0.xyz, vec3(0.300000012, 0.589999974, 0.109999999));
					    u_xlat0.xyz = u_xlat2.xyz * u_xlat0.xxx + (-u_xlat2.xyz);
					    u_xlat0.xyz = vec3(vec3(_BumpAttune, _BumpAttune, _BumpAttune)) * u_xlat0.xyz + u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz + in_POSITION0.xyz;
					    u_xlat1 = u_xlat0.yyyy * unity_ObjectToWorld[1];
					    u_xlat1 = unity_ObjectToWorld[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat0 = unity_ObjectToWorld[2] * u_xlat0.zzzz + u_xlat1;
					    u_xlat1 = u_xlat0 + unity_ObjectToWorld[3];
					    u_xlat0 = unity_ObjectToWorld[3] * in_POSITION0.wwww + u_xlat0;
					    u_xlat2 = u_xlat1.yyyy * unity_MatrixVP[1];
					    u_xlat2 = unity_MatrixVP[0] * u_xlat1.xxxx + u_xlat2;
					    u_xlat2 = unity_MatrixVP[2] * u_xlat1.zzzz + u_xlat2;
					    gl_Position = unity_MatrixVP[3] * u_xlat1.wwww + u_xlat2;
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
					    vs_TEXCOORD1.xy = in_TEXCOORD1.xy;
					    vs_TEXCOORD2.xy = in_TEXCOORD2.xy;
					    vs_TEXCOORD3 = u_xlat0;
					    u_xlat1.x = dot(in_NORMAL0.xyz, unity_WorldToObject[0].xyz);
					    u_xlat1.y = dot(in_NORMAL0.xyz, unity_WorldToObject[1].xyz);
					    u_xlat1.z = dot(in_NORMAL0.xyz, unity_WorldToObject[2].xyz);
					    u_xlat13 = dot(u_xlat1.xyz, u_xlat1.xyz);
					    u_xlat13 = inversesqrt(u_xlat13);
					    u_xlat1.xyz = vec3(u_xlat13) * u_xlat1.xyz;
					    vs_TEXCOORD4.xyz = u_xlat1.xyz;
					    u_xlat2.xyz = in_TANGENT0.yyy * unity_ObjectToWorld[1].xyz;
					    u_xlat2.xyz = unity_ObjectToWorld[0].xyz * in_TANGENT0.xxx + u_xlat2.xyz;
					    u_xlat2.xyz = unity_ObjectToWorld[2].xyz * in_TANGENT0.zzz + u_xlat2.xyz;
					    u_xlat13 = dot(u_xlat2.xyz, u_xlat2.xyz);
					    u_xlat13 = inversesqrt(u_xlat13);
					    u_xlat2.xyz = vec3(u_xlat13) * u_xlat2.xyz;
					    vs_TEXCOORD5.xyz = u_xlat2.xyz;
					    u_xlat3.xyz = u_xlat1.zxy * u_xlat2.yzx;
					    u_xlat1.xyz = u_xlat1.yzx * u_xlat2.zxy + (-u_xlat3.xyz);
					    u_xlat1.xyz = u_xlat1.xyz * in_TANGENT0.www;
					    u_xlat13 = dot(u_xlat1.xyz, u_xlat1.xyz);
					    u_xlat13 = inversesqrt(u_xlat13);
					    vs_TEXCOORD6.xyz = vec3(u_xlat13) * u_xlat1.xyz;
					    u_xlat1.xyz = u_xlat0.yyy * unity_WorldToLight[1].xyz;
					    u_xlat1.xyz = unity_WorldToLight[0].xyz * u_xlat0.xxx + u_xlat1.xyz;
					    u_xlat0.xyz = unity_WorldToLight[2].xyz * u_xlat0.zzz + u_xlat1.xyz;
					    vs_TEXCOORD7.xyz = unity_WorldToLight[3].xyz * u_xlat0.www + u_xlat0.xyz;
					    return;
					}"
				}
				SubProgram "d3d11 " {
					Keywords { "DIRECTIONAL_COOKIE" "DIRLIGHTMAP_SEPARATE" "LIGHTMAP_OFF" "DYNAMICLIGHTMAP_OFF" }
					"vs_4_0
					
					#version 330
					#extension GL_ARB_explicit_attrib_location : require
					#extension GL_ARB_explicit_uniform_location : require
					
					#define HLSLCC_ENABLE_UNIFORM_BUFFERS 1
					#if HLSLCC_ENABLE_UNIFORM_BUFFERS
					#define UNITY_UNIFORM
					#else
					#define UNITY_UNIFORM uniform
					#endif
					#define UNITY_SUPPORTS_UNIFORM_LOCATION 1
					#if UNITY_SUPPORTS_UNIFORM_LOCATION
					#define UNITY_LOCATION(x) layout(location = x)
					#define UNITY_BINDING(x) layout(binding = x, std140)
					#else
					#define UNITY_LOCATION(x)
					#define UNITY_BINDING(x) layout(std140)
					#endif
					layout(std140) uniform VGlobals {
						vec4 unused_0_0[2];
						mat4x4 unity_WorldToLight;
						vec4 unused_0_2[2];
						vec4 _MainTexture_ST;
						vec4 unused_0_4[2];
						vec4 _Color;
						vec4 _Heightmap_ST;
						float _Bumpiness;
						float _BumpAttune;
					};
					layout(std140) uniform UnityPerDraw {
						mat4x4 unity_ObjectToWorld;
						mat4x4 unity_WorldToObject;
						vec4 unused_1_2[2];
					};
					layout(std140) uniform UnityPerFrame {
						vec4 unused_2_0[17];
						mat4x4 unity_MatrixVP;
						vec4 unused_2_2[2];
					};
					uniform  sampler2D _Heightmap;
					uniform  sampler2D _MainTexture;
					in  vec4 in_POSITION0;
					in  vec3 in_NORMAL0;
					in  vec4 in_TANGENT0;
					in  vec2 in_TEXCOORD0;
					in  vec2 in_TEXCOORD1;
					in  vec2 in_TEXCOORD2;
					out vec2 vs_TEXCOORD0;
					out vec2 vs_TEXCOORD1;
					out vec2 vs_TEXCOORD2;
					out vec2 vs_TEXCOORD7;
					out vec4 vs_TEXCOORD3;
					out vec3 vs_TEXCOORD4;
					out vec3 vs_TEXCOORD5;
					out vec3 vs_TEXCOORD6;
					vec4 u_xlat0;
					vec4 u_xlat1;
					vec4 u_xlat2;
					vec3 u_xlat3;
					float u_xlat12;
					void main()
					{
					    u_xlat0.xy = in_TEXCOORD0.xy * _MainTexture_ST.xy + _MainTexture_ST.zw;
					    u_xlat0 = textureLod(_MainTexture, u_xlat0.xy, 0.0);
					    u_xlat0.xyz = u_xlat0.xyz * _Color.xyz;
					    u_xlat1.xyz = u_xlat0.xyz * vec3(-1.0, -1.0, 1.0);
					    u_xlat2.xy = in_TEXCOORD0.xy * _Heightmap_ST.xy + _Heightmap_ST.zw;
					    u_xlat2 = textureLod(_Heightmap, u_xlat2.xy, 0.0);
					    u_xlat2.xyz = u_xlat2.xyz * vec3(_Bumpiness);
					    u_xlat2.xyz = clamp(u_xlat2.xyz, 0.0, 1.0);
					    u_xlat3.xyz = u_xlat2.xyz + vec3(0.0, 0.0, 1.0);
					    u_xlat2.xyz = u_xlat2.xyz * in_NORMAL0.xyz;
					    u_xlat12 = dot(u_xlat3.xyz, u_xlat1.xyz);
					    u_xlat1.xyz = vec3(u_xlat12) * u_xlat3.xyz;
					    u_xlat1.xyz = u_xlat1.xyz / u_xlat3.zzz;
					    u_xlat0.xyz = (-u_xlat0.xyz) * vec3(-1.0, -1.0, 1.0) + u_xlat1.xyz;
					    u_xlat0.x = dot(u_xlat0.xyz, vec3(0.300000012, 0.589999974, 0.109999999));
					    u_xlat0.xyz = u_xlat2.xyz * u_xlat0.xxx + (-u_xlat2.xyz);
					    u_xlat0.xyz = vec3(vec3(_BumpAttune, _BumpAttune, _BumpAttune)) * u_xlat0.xyz + u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz + in_POSITION0.xyz;
					    u_xlat1 = u_xlat0.yyyy * unity_ObjectToWorld[1];
					    u_xlat1 = unity_ObjectToWorld[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat0 = unity_ObjectToWorld[2] * u_xlat0.zzzz + u_xlat1;
					    u_xlat1 = u_xlat0 + unity_ObjectToWorld[3];
					    u_xlat0 = unity_ObjectToWorld[3] * in_POSITION0.wwww + u_xlat0;
					    u_xlat2 = u_xlat1.yyyy * unity_MatrixVP[1];
					    u_xlat2 = unity_MatrixVP[0] * u_xlat1.xxxx + u_xlat2;
					    u_xlat2 = unity_MatrixVP[2] * u_xlat1.zzzz + u_xlat2;
					    gl_Position = unity_MatrixVP[3] * u_xlat1.wwww + u_xlat2;
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
					    vs_TEXCOORD1.xy = in_TEXCOORD1.xy;
					    u_xlat1.xy = u_xlat0.yy * unity_WorldToLight[1].xy;
					    u_xlat1.xy = unity_WorldToLight[0].xy * u_xlat0.xx + u_xlat1.xy;
					    u_xlat1.xy = unity_WorldToLight[2].xy * u_xlat0.zz + u_xlat1.xy;
					    vs_TEXCOORD7.xy = unity_WorldToLight[3].xy * u_xlat0.ww + u_xlat1.xy;
					    vs_TEXCOORD3 = u_xlat0;
					    vs_TEXCOORD2.xy = in_TEXCOORD2.xy;
					    u_xlat0.x = dot(in_NORMAL0.xyz, unity_WorldToObject[0].xyz);
					    u_xlat0.y = dot(in_NORMAL0.xyz, unity_WorldToObject[1].xyz);
					    u_xlat0.z = dot(in_NORMAL0.xyz, unity_WorldToObject[2].xyz);
					    u_xlat12 = dot(u_xlat0.xyz, u_xlat0.xyz);
					    u_xlat12 = inversesqrt(u_xlat12);
					    u_xlat0.xyz = vec3(u_xlat12) * u_xlat0.xyz;
					    vs_TEXCOORD4.xyz = u_xlat0.xyz;
					    u_xlat1.xyz = in_TANGENT0.yyy * unity_ObjectToWorld[1].xyz;
					    u_xlat1.xyz = unity_ObjectToWorld[0].xyz * in_TANGENT0.xxx + u_xlat1.xyz;
					    u_xlat1.xyz = unity_ObjectToWorld[2].xyz * in_TANGENT0.zzz + u_xlat1.xyz;
					    u_xlat12 = dot(u_xlat1.xyz, u_xlat1.xyz);
					    u_xlat12 = inversesqrt(u_xlat12);
					    u_xlat1.xyz = vec3(u_xlat12) * u_xlat1.xyz;
					    vs_TEXCOORD5.xyz = u_xlat1.xyz;
					    u_xlat2.xyz = u_xlat0.zxy * u_xlat1.yzx;
					    u_xlat0.xyz = u_xlat0.yzx * u_xlat1.zxy + (-u_xlat2.xyz);
					    u_xlat0.xyz = u_xlat0.xyz * in_TANGENT0.www;
					    u_xlat12 = dot(u_xlat0.xyz, u_xlat0.xyz);
					    u_xlat12 = inversesqrt(u_xlat12);
					    vs_TEXCOORD6.xyz = vec3(u_xlat12) * u_xlat0.xyz;
					    return;
					}"
				}
				SubProgram "d3d11 " {
					Keywords { "SPOT" "SHADOWS_DEPTH" "DIRLIGHTMAP_SEPARATE" "LIGHTMAP_OFF" "DYNAMICLIGHTMAP_OFF" }
					"vs_4_0
					
					#version 330
					#extension GL_ARB_explicit_attrib_location : require
					#extension GL_ARB_explicit_uniform_location : require
					
					#define HLSLCC_ENABLE_UNIFORM_BUFFERS 1
					#if HLSLCC_ENABLE_UNIFORM_BUFFERS
					#define UNITY_UNIFORM
					#else
					#define UNITY_UNIFORM uniform
					#endif
					#define UNITY_SUPPORTS_UNIFORM_LOCATION 1
					#if UNITY_SUPPORTS_UNIFORM_LOCATION
					#define UNITY_LOCATION(x) layout(location = x)
					#define UNITY_BINDING(x) layout(binding = x, std140)
					#else
					#define UNITY_LOCATION(x)
					#define UNITY_BINDING(x) layout(std140)
					#endif
					layout(std140) uniform VGlobals {
						vec4 unused_0_0[2];
						mat4x4 unity_WorldToLight;
						vec4 unused_0_2[2];
						vec4 _MainTexture_ST;
						vec4 unused_0_4[2];
						vec4 _Color;
						vec4 _Heightmap_ST;
						float _Bumpiness;
						float _BumpAttune;
					};
					layout(std140) uniform UnityShadows {
						vec4 unused_1_0[8];
						mat4x4 unity_WorldToShadow[4];
						vec4 unused_1_2[14];
					};
					layout(std140) uniform UnityPerDraw {
						mat4x4 unity_ObjectToWorld;
						mat4x4 unity_WorldToObject;
						vec4 unused_2_2[2];
					};
					layout(std140) uniform UnityPerFrame {
						vec4 unused_3_0[17];
						mat4x4 unity_MatrixVP;
						vec4 unused_3_2[2];
					};
					uniform  sampler2D _Heightmap;
					uniform  sampler2D _MainTexture;
					in  vec4 in_POSITION0;
					in  vec3 in_NORMAL0;
					in  vec4 in_TANGENT0;
					in  vec2 in_TEXCOORD0;
					in  vec2 in_TEXCOORD1;
					in  vec2 in_TEXCOORD2;
					out vec2 vs_TEXCOORD0;
					out vec2 vs_TEXCOORD1;
					out vec2 vs_TEXCOORD2;
					out vec4 vs_TEXCOORD3;
					out vec3 vs_TEXCOORD4;
					out vec3 vs_TEXCOORD5;
					out vec3 vs_TEXCOORD6;
					out vec4 vs_TEXCOORD7;
					out vec4 vs_TEXCOORD8;
					vec4 u_xlat0;
					vec4 u_xlat1;
					vec4 u_xlat2;
					vec3 u_xlat3;
					float u_xlat12;
					float u_xlat13;
					void main()
					{
					    u_xlat0.xy = in_TEXCOORD0.xy * _MainTexture_ST.xy + _MainTexture_ST.zw;
					    u_xlat0 = textureLod(_MainTexture, u_xlat0.xy, 0.0);
					    u_xlat0.xyz = u_xlat0.xyz * _Color.xyz;
					    u_xlat1.xyz = u_xlat0.xyz * vec3(-1.0, -1.0, 1.0);
					    u_xlat2.xy = in_TEXCOORD0.xy * _Heightmap_ST.xy + _Heightmap_ST.zw;
					    u_xlat2 = textureLod(_Heightmap, u_xlat2.xy, 0.0);
					    u_xlat2.xyz = u_xlat2.xyz * vec3(_Bumpiness);
					    u_xlat2.xyz = clamp(u_xlat2.xyz, 0.0, 1.0);
					    u_xlat3.xyz = u_xlat2.xyz + vec3(0.0, 0.0, 1.0);
					    u_xlat2.xyz = u_xlat2.xyz * in_NORMAL0.xyz;
					    u_xlat12 = dot(u_xlat3.xyz, u_xlat1.xyz);
					    u_xlat1.xyz = vec3(u_xlat12) * u_xlat3.xyz;
					    u_xlat1.xyz = u_xlat1.xyz / u_xlat3.zzz;
					    u_xlat0.xyz = (-u_xlat0.xyz) * vec3(-1.0, -1.0, 1.0) + u_xlat1.xyz;
					    u_xlat0.x = dot(u_xlat0.xyz, vec3(0.300000012, 0.589999974, 0.109999999));
					    u_xlat0.xyz = u_xlat2.xyz * u_xlat0.xxx + (-u_xlat2.xyz);
					    u_xlat0.xyz = vec3(vec3(_BumpAttune, _BumpAttune, _BumpAttune)) * u_xlat0.xyz + u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz + in_POSITION0.xyz;
					    u_xlat1 = u_xlat0.yyyy * unity_ObjectToWorld[1];
					    u_xlat1 = unity_ObjectToWorld[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat0 = unity_ObjectToWorld[2] * u_xlat0.zzzz + u_xlat1;
					    u_xlat1 = u_xlat0 + unity_ObjectToWorld[3];
					    u_xlat0 = unity_ObjectToWorld[3] * in_POSITION0.wwww + u_xlat0;
					    u_xlat2 = u_xlat1.yyyy * unity_MatrixVP[1];
					    u_xlat2 = unity_MatrixVP[0] * u_xlat1.xxxx + u_xlat2;
					    u_xlat2 = unity_MatrixVP[2] * u_xlat1.zzzz + u_xlat2;
					    gl_Position = unity_MatrixVP[3] * u_xlat1.wwww + u_xlat2;
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
					    vs_TEXCOORD1.xy = in_TEXCOORD1.xy;
					    vs_TEXCOORD2.xy = in_TEXCOORD2.xy;
					    vs_TEXCOORD3 = u_xlat0;
					    u_xlat1.x = dot(in_NORMAL0.xyz, unity_WorldToObject[0].xyz);
					    u_xlat1.y = dot(in_NORMAL0.xyz, unity_WorldToObject[1].xyz);
					    u_xlat1.z = dot(in_NORMAL0.xyz, unity_WorldToObject[2].xyz);
					    u_xlat13 = dot(u_xlat1.xyz, u_xlat1.xyz);
					    u_xlat13 = inversesqrt(u_xlat13);
					    u_xlat1.xyz = vec3(u_xlat13) * u_xlat1.xyz;
					    vs_TEXCOORD4.xyz = u_xlat1.xyz;
					    u_xlat2.xyz = in_TANGENT0.yyy * unity_ObjectToWorld[1].xyz;
					    u_xlat2.xyz = unity_ObjectToWorld[0].xyz * in_TANGENT0.xxx + u_xlat2.xyz;
					    u_xlat2.xyz = unity_ObjectToWorld[2].xyz * in_TANGENT0.zzz + u_xlat2.xyz;
					    u_xlat13 = dot(u_xlat2.xyz, u_xlat2.xyz);
					    u_xlat13 = inversesqrt(u_xlat13);
					    u_xlat2.xyz = vec3(u_xlat13) * u_xlat2.xyz;
					    vs_TEXCOORD5.xyz = u_xlat2.xyz;
					    u_xlat3.xyz = u_xlat1.zxy * u_xlat2.yzx;
					    u_xlat1.xyz = u_xlat1.yzx * u_xlat2.zxy + (-u_xlat3.xyz);
					    u_xlat1.xyz = u_xlat1.xyz * in_TANGENT0.www;
					    u_xlat13 = dot(u_xlat1.xyz, u_xlat1.xyz);
					    u_xlat13 = inversesqrt(u_xlat13);
					    vs_TEXCOORD6.xyz = vec3(u_xlat13) * u_xlat1.xyz;
					    u_xlat1 = u_xlat0.yyyy * unity_WorldToLight[1];
					    u_xlat1 = unity_WorldToLight[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat1 = unity_WorldToLight[2] * u_xlat0.zzzz + u_xlat1;
					    vs_TEXCOORD7 = unity_WorldToLight[3] * u_xlat0.wwww + u_xlat1;
					    u_xlat1 = u_xlat0.yyyy * unity_WorldToShadow[1 / 4][1 % 4];
					    u_xlat1 = unity_WorldToShadow[0 / 4][0 % 4] * u_xlat0.xxxx + u_xlat1;
					    u_xlat1 = unity_WorldToShadow[2 / 4][2 % 4] * u_xlat0.zzzz + u_xlat1;
					    vs_TEXCOORD8 = unity_WorldToShadow[3 / 4][3 % 4] * u_xlat0.wwww + u_xlat1;
					    return;
					}"
				}
				SubProgram "d3d11 " {
					Keywords { "SPOT" "SHADOWS_DEPTH" "SHADOWS_SOFT" "DIRLIGHTMAP_SEPARATE" "LIGHTMAP_OFF" "DYNAMICLIGHTMAP_OFF" }
					"vs_4_0
					
					#version 330
					#extension GL_ARB_explicit_attrib_location : require
					#extension GL_ARB_explicit_uniform_location : require
					
					#define HLSLCC_ENABLE_UNIFORM_BUFFERS 1
					#if HLSLCC_ENABLE_UNIFORM_BUFFERS
					#define UNITY_UNIFORM
					#else
					#define UNITY_UNIFORM uniform
					#endif
					#define UNITY_SUPPORTS_UNIFORM_LOCATION 1
					#if UNITY_SUPPORTS_UNIFORM_LOCATION
					#define UNITY_LOCATION(x) layout(location = x)
					#define UNITY_BINDING(x) layout(binding = x, std140)
					#else
					#define UNITY_LOCATION(x)
					#define UNITY_BINDING(x) layout(std140)
					#endif
					layout(std140) uniform VGlobals {
						vec4 unused_0_0[7];
						mat4x4 unity_WorldToLight;
						vec4 unused_0_2[2];
						vec4 _MainTexture_ST;
						vec4 unused_0_4[2];
						vec4 _Color;
						vec4 _Heightmap_ST;
						float _Bumpiness;
						float _BumpAttune;
					};
					layout(std140) uniform UnityShadows {
						vec4 unused_1_0[8];
						mat4x4 unity_WorldToShadow[4];
						vec4 unused_1_2[14];
					};
					layout(std140) uniform UnityPerDraw {
						mat4x4 unity_ObjectToWorld;
						mat4x4 unity_WorldToObject;
						vec4 unused_2_2[2];
					};
					layout(std140) uniform UnityPerFrame {
						vec4 unused_3_0[17];
						mat4x4 unity_MatrixVP;
						vec4 unused_3_2[2];
					};
					uniform  sampler2D _Heightmap;
					uniform  sampler2D _MainTexture;
					in  vec4 in_POSITION0;
					in  vec3 in_NORMAL0;
					in  vec4 in_TANGENT0;
					in  vec2 in_TEXCOORD0;
					in  vec2 in_TEXCOORD1;
					in  vec2 in_TEXCOORD2;
					out vec2 vs_TEXCOORD0;
					out vec2 vs_TEXCOORD1;
					out vec2 vs_TEXCOORD2;
					out vec4 vs_TEXCOORD3;
					out vec3 vs_TEXCOORD4;
					out vec3 vs_TEXCOORD5;
					out vec3 vs_TEXCOORD6;
					out vec4 vs_TEXCOORD7;
					out vec4 vs_TEXCOORD8;
					vec4 u_xlat0;
					vec4 u_xlat1;
					vec4 u_xlat2;
					vec3 u_xlat3;
					float u_xlat12;
					float u_xlat13;
					void main()
					{
					    u_xlat0.xy = in_TEXCOORD0.xy * _MainTexture_ST.xy + _MainTexture_ST.zw;
					    u_xlat0 = textureLod(_MainTexture, u_xlat0.xy, 0.0);
					    u_xlat0.xyz = u_xlat0.xyz * _Color.xyz;
					    u_xlat1.xyz = u_xlat0.xyz * vec3(-1.0, -1.0, 1.0);
					    u_xlat2.xy = in_TEXCOORD0.xy * _Heightmap_ST.xy + _Heightmap_ST.zw;
					    u_xlat2 = textureLod(_Heightmap, u_xlat2.xy, 0.0);
					    u_xlat2.xyz = u_xlat2.xyz * vec3(_Bumpiness);
					    u_xlat2.xyz = clamp(u_xlat2.xyz, 0.0, 1.0);
					    u_xlat3.xyz = u_xlat2.xyz + vec3(0.0, 0.0, 1.0);
					    u_xlat2.xyz = u_xlat2.xyz * in_NORMAL0.xyz;
					    u_xlat12 = dot(u_xlat3.xyz, u_xlat1.xyz);
					    u_xlat1.xyz = vec3(u_xlat12) * u_xlat3.xyz;
					    u_xlat1.xyz = u_xlat1.xyz / u_xlat3.zzz;
					    u_xlat0.xyz = (-u_xlat0.xyz) * vec3(-1.0, -1.0, 1.0) + u_xlat1.xyz;
					    u_xlat0.x = dot(u_xlat0.xyz, vec3(0.300000012, 0.589999974, 0.109999999));
					    u_xlat0.xyz = u_xlat2.xyz * u_xlat0.xxx + (-u_xlat2.xyz);
					    u_xlat0.xyz = vec3(vec3(_BumpAttune, _BumpAttune, _BumpAttune)) * u_xlat0.xyz + u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz + in_POSITION0.xyz;
					    u_xlat1 = u_xlat0.yyyy * unity_ObjectToWorld[1];
					    u_xlat1 = unity_ObjectToWorld[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat0 = unity_ObjectToWorld[2] * u_xlat0.zzzz + u_xlat1;
					    u_xlat1 = u_xlat0 + unity_ObjectToWorld[3];
					    u_xlat0 = unity_ObjectToWorld[3] * in_POSITION0.wwww + u_xlat0;
					    u_xlat2 = u_xlat1.yyyy * unity_MatrixVP[1];
					    u_xlat2 = unity_MatrixVP[0] * u_xlat1.xxxx + u_xlat2;
					    u_xlat2 = unity_MatrixVP[2] * u_xlat1.zzzz + u_xlat2;
					    gl_Position = unity_MatrixVP[3] * u_xlat1.wwww + u_xlat2;
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
					    vs_TEXCOORD1.xy = in_TEXCOORD1.xy;
					    vs_TEXCOORD2.xy = in_TEXCOORD2.xy;
					    vs_TEXCOORD3 = u_xlat0;
					    u_xlat1.x = dot(in_NORMAL0.xyz, unity_WorldToObject[0].xyz);
					    u_xlat1.y = dot(in_NORMAL0.xyz, unity_WorldToObject[1].xyz);
					    u_xlat1.z = dot(in_NORMAL0.xyz, unity_WorldToObject[2].xyz);
					    u_xlat13 = dot(u_xlat1.xyz, u_xlat1.xyz);
					    u_xlat13 = inversesqrt(u_xlat13);
					    u_xlat1.xyz = vec3(u_xlat13) * u_xlat1.xyz;
					    vs_TEXCOORD4.xyz = u_xlat1.xyz;
					    u_xlat2.xyz = in_TANGENT0.yyy * unity_ObjectToWorld[1].xyz;
					    u_xlat2.xyz = unity_ObjectToWorld[0].xyz * in_TANGENT0.xxx + u_xlat2.xyz;
					    u_xlat2.xyz = unity_ObjectToWorld[2].xyz * in_TANGENT0.zzz + u_xlat2.xyz;
					    u_xlat13 = dot(u_xlat2.xyz, u_xlat2.xyz);
					    u_xlat13 = inversesqrt(u_xlat13);
					    u_xlat2.xyz = vec3(u_xlat13) * u_xlat2.xyz;
					    vs_TEXCOORD5.xyz = u_xlat2.xyz;
					    u_xlat3.xyz = u_xlat1.zxy * u_xlat2.yzx;
					    u_xlat1.xyz = u_xlat1.yzx * u_xlat2.zxy + (-u_xlat3.xyz);
					    u_xlat1.xyz = u_xlat1.xyz * in_TANGENT0.www;
					    u_xlat13 = dot(u_xlat1.xyz, u_xlat1.xyz);
					    u_xlat13 = inversesqrt(u_xlat13);
					    vs_TEXCOORD6.xyz = vec3(u_xlat13) * u_xlat1.xyz;
					    u_xlat1 = u_xlat0.yyyy * unity_WorldToLight[1];
					    u_xlat1 = unity_WorldToLight[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat1 = unity_WorldToLight[2] * u_xlat0.zzzz + u_xlat1;
					    vs_TEXCOORD7 = unity_WorldToLight[3] * u_xlat0.wwww + u_xlat1;
					    u_xlat1 = u_xlat0.yyyy * unity_WorldToShadow[1 / 4][1 % 4];
					    u_xlat1 = unity_WorldToShadow[0 / 4][0 % 4] * u_xlat0.xxxx + u_xlat1;
					    u_xlat1 = unity_WorldToShadow[2 / 4][2 % 4] * u_xlat0.zzzz + u_xlat1;
					    vs_TEXCOORD8 = unity_WorldToShadow[3 / 4][3 % 4] * u_xlat0.wwww + u_xlat1;
					    return;
					}"
				}
				SubProgram "d3d11 " {
					Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "DIRLIGHTMAP_SEPARATE" "LIGHTMAP_OFF" "DYNAMICLIGHTMAP_OFF" }
					"vs_4_0
					
					#version 330
					#extension GL_ARB_explicit_attrib_location : require
					#extension GL_ARB_explicit_uniform_location : require
					
					#define HLSLCC_ENABLE_UNIFORM_BUFFERS 1
					#if HLSLCC_ENABLE_UNIFORM_BUFFERS
					#define UNITY_UNIFORM
					#else
					#define UNITY_UNIFORM uniform
					#endif
					#define UNITY_SUPPORTS_UNIFORM_LOCATION 1
					#if UNITY_SUPPORTS_UNIFORM_LOCATION
					#define UNITY_LOCATION(x) layout(location = x)
					#define UNITY_BINDING(x) layout(binding = x, std140)
					#else
					#define UNITY_LOCATION(x)
					#define UNITY_BINDING(x) layout(std140)
					#endif
					layout(std140) uniform VGlobals {
						vec4 unused_0_0[4];
						vec4 _MainTexture_ST;
						vec4 unused_0_2[2];
						vec4 _Color;
						vec4 _Heightmap_ST;
						float _Bumpiness;
						float _BumpAttune;
					};
					layout(std140) uniform UnityPerCamera {
						vec4 unused_1_0[5];
						vec4 _ProjectionParams;
						vec4 unused_1_2[3];
					};
					layout(std140) uniform UnityPerDraw {
						mat4x4 unity_ObjectToWorld;
						mat4x4 unity_WorldToObject;
						vec4 unused_2_2[2];
					};
					layout(std140) uniform UnityPerFrame {
						vec4 unused_3_0[17];
						mat4x4 unity_MatrixVP;
						vec4 unused_3_2[2];
					};
					uniform  sampler2D _Heightmap;
					uniform  sampler2D _MainTexture;
					in  vec4 in_POSITION0;
					in  vec3 in_NORMAL0;
					in  vec4 in_TANGENT0;
					in  vec2 in_TEXCOORD0;
					in  vec2 in_TEXCOORD1;
					in  vec2 in_TEXCOORD2;
					out vec2 vs_TEXCOORD0;
					out vec2 vs_TEXCOORD1;
					out vec2 vs_TEXCOORD2;
					out vec4 vs_TEXCOORD3;
					out vec3 vs_TEXCOORD4;
					out vec3 vs_TEXCOORD5;
					out vec3 vs_TEXCOORD6;
					out vec4 vs_TEXCOORD8;
					vec4 u_xlat0;
					vec4 u_xlat1;
					vec4 u_xlat2;
					vec3 u_xlat3;
					float u_xlat12;
					float u_xlat13;
					void main()
					{
					    u_xlat0.xy = in_TEXCOORD0.xy * _MainTexture_ST.xy + _MainTexture_ST.zw;
					    u_xlat0 = textureLod(_MainTexture, u_xlat0.xy, 0.0);
					    u_xlat0.xyz = u_xlat0.xyz * _Color.xyz;
					    u_xlat1.xyz = u_xlat0.xyz * vec3(-1.0, -1.0, 1.0);
					    u_xlat2.xy = in_TEXCOORD0.xy * _Heightmap_ST.xy + _Heightmap_ST.zw;
					    u_xlat2 = textureLod(_Heightmap, u_xlat2.xy, 0.0);
					    u_xlat2.xyz = u_xlat2.xyz * vec3(_Bumpiness);
					    u_xlat2.xyz = clamp(u_xlat2.xyz, 0.0, 1.0);
					    u_xlat3.xyz = u_xlat2.xyz + vec3(0.0, 0.0, 1.0);
					    u_xlat2.xyz = u_xlat2.xyz * in_NORMAL0.xyz;
					    u_xlat12 = dot(u_xlat3.xyz, u_xlat1.xyz);
					    u_xlat1.xyz = vec3(u_xlat12) * u_xlat3.xyz;
					    u_xlat1.xyz = u_xlat1.xyz / u_xlat3.zzz;
					    u_xlat0.xyz = (-u_xlat0.xyz) * vec3(-1.0, -1.0, 1.0) + u_xlat1.xyz;
					    u_xlat0.x = dot(u_xlat0.xyz, vec3(0.300000012, 0.589999974, 0.109999999));
					    u_xlat0.xyz = u_xlat2.xyz * u_xlat0.xxx + (-u_xlat2.xyz);
					    u_xlat0.xyz = vec3(vec3(_BumpAttune, _BumpAttune, _BumpAttune)) * u_xlat0.xyz + u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz + in_POSITION0.xyz;
					    u_xlat1 = u_xlat0.yyyy * unity_ObjectToWorld[1];
					    u_xlat1 = unity_ObjectToWorld[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat0 = unity_ObjectToWorld[2] * u_xlat0.zzzz + u_xlat1;
					    u_xlat1 = u_xlat0 + unity_ObjectToWorld[3];
					    vs_TEXCOORD3 = unity_ObjectToWorld[3] * in_POSITION0.wwww + u_xlat0;
					    u_xlat0 = u_xlat1.yyyy * unity_MatrixVP[1];
					    u_xlat0 = unity_MatrixVP[0] * u_xlat1.xxxx + u_xlat0;
					    u_xlat0 = unity_MatrixVP[2] * u_xlat1.zzzz + u_xlat0;
					    u_xlat0 = unity_MatrixVP[3] * u_xlat1.wwww + u_xlat0;
					    gl_Position = u_xlat0;
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
					    vs_TEXCOORD1.xy = in_TEXCOORD1.xy;
					    vs_TEXCOORD2.xy = in_TEXCOORD2.xy;
					    u_xlat1.x = dot(in_NORMAL0.xyz, unity_WorldToObject[0].xyz);
					    u_xlat1.y = dot(in_NORMAL0.xyz, unity_WorldToObject[1].xyz);
					    u_xlat1.z = dot(in_NORMAL0.xyz, unity_WorldToObject[2].xyz);
					    u_xlat13 = dot(u_xlat1.xyz, u_xlat1.xyz);
					    u_xlat13 = inversesqrt(u_xlat13);
					    u_xlat1.xyz = vec3(u_xlat13) * u_xlat1.xyz;
					    vs_TEXCOORD4.xyz = u_xlat1.xyz;
					    u_xlat2.xyz = in_TANGENT0.yyy * unity_ObjectToWorld[1].xyz;
					    u_xlat2.xyz = unity_ObjectToWorld[0].xyz * in_TANGENT0.xxx + u_xlat2.xyz;
					    u_xlat2.xyz = unity_ObjectToWorld[2].xyz * in_TANGENT0.zzz + u_xlat2.xyz;
					    u_xlat13 = dot(u_xlat2.xyz, u_xlat2.xyz);
					    u_xlat13 = inversesqrt(u_xlat13);
					    u_xlat2.xyz = vec3(u_xlat13) * u_xlat2.xyz;
					    vs_TEXCOORD5.xyz = u_xlat2.xyz;
					    u_xlat3.xyz = u_xlat1.zxy * u_xlat2.yzx;
					    u_xlat1.xyz = u_xlat1.yzx * u_xlat2.zxy + (-u_xlat3.xyz);
					    u_xlat1.xyz = u_xlat1.xyz * in_TANGENT0.www;
					    u_xlat13 = dot(u_xlat1.xyz, u_xlat1.xyz);
					    u_xlat13 = inversesqrt(u_xlat13);
					    vs_TEXCOORD6.xyz = vec3(u_xlat13) * u_xlat1.xyz;
					    u_xlat0.y = u_xlat0.y * _ProjectionParams.x;
					    u_xlat1.xzw = u_xlat0.xwy * vec3(0.5, 0.5, 0.5);
					    vs_TEXCOORD8.zw = u_xlat0.zw;
					    vs_TEXCOORD8.xy = u_xlat1.zz + u_xlat1.xw;
					    return;
					}"
				}
				SubProgram "d3d11 " {
					Keywords { "DIRECTIONAL_COOKIE" "SHADOWS_SCREEN" "DIRLIGHTMAP_SEPARATE" "LIGHTMAP_OFF" "DYNAMICLIGHTMAP_OFF" }
					"vs_4_0
					
					#version 330
					#extension GL_ARB_explicit_attrib_location : require
					#extension GL_ARB_explicit_uniform_location : require
					
					#define HLSLCC_ENABLE_UNIFORM_BUFFERS 1
					#if HLSLCC_ENABLE_UNIFORM_BUFFERS
					#define UNITY_UNIFORM
					#else
					#define UNITY_UNIFORM uniform
					#endif
					#define UNITY_SUPPORTS_UNIFORM_LOCATION 1
					#if UNITY_SUPPORTS_UNIFORM_LOCATION
					#define UNITY_LOCATION(x) layout(location = x)
					#define UNITY_BINDING(x) layout(binding = x, std140)
					#else
					#define UNITY_LOCATION(x)
					#define UNITY_BINDING(x) layout(std140)
					#endif
					layout(std140) uniform VGlobals {
						vec4 unused_0_0[2];
						mat4x4 unity_WorldToLight;
						vec4 unused_0_2[2];
						vec4 _MainTexture_ST;
						vec4 unused_0_4[2];
						vec4 _Color;
						vec4 _Heightmap_ST;
						float _Bumpiness;
						float _BumpAttune;
					};
					layout(std140) uniform UnityPerCamera {
						vec4 unused_1_0[5];
						vec4 _ProjectionParams;
						vec4 unused_1_2[3];
					};
					layout(std140) uniform UnityPerDraw {
						mat4x4 unity_ObjectToWorld;
						mat4x4 unity_WorldToObject;
						vec4 unused_2_2[2];
					};
					layout(std140) uniform UnityPerFrame {
						vec4 unused_3_0[17];
						mat4x4 unity_MatrixVP;
						vec4 unused_3_2[2];
					};
					uniform  sampler2D _Heightmap;
					uniform  sampler2D _MainTexture;
					in  vec4 in_POSITION0;
					in  vec3 in_NORMAL0;
					in  vec4 in_TANGENT0;
					in  vec2 in_TEXCOORD0;
					in  vec2 in_TEXCOORD1;
					in  vec2 in_TEXCOORD2;
					out vec2 vs_TEXCOORD0;
					out vec2 vs_TEXCOORD1;
					out vec2 vs_TEXCOORD2;
					out vec2 vs_TEXCOORD7;
					out vec4 vs_TEXCOORD3;
					out vec3 vs_TEXCOORD4;
					out vec3 vs_TEXCOORD5;
					out vec3 vs_TEXCOORD6;
					out vec4 vs_TEXCOORD8;
					vec4 u_xlat0;
					vec4 u_xlat1;
					vec4 u_xlat2;
					vec3 u_xlat3;
					float u_xlat12;
					void main()
					{
					    u_xlat0.xy = in_TEXCOORD0.xy * _MainTexture_ST.xy + _MainTexture_ST.zw;
					    u_xlat0 = textureLod(_MainTexture, u_xlat0.xy, 0.0);
					    u_xlat0.xyz = u_xlat0.xyz * _Color.xyz;
					    u_xlat1.xyz = u_xlat0.xyz * vec3(-1.0, -1.0, 1.0);
					    u_xlat2.xy = in_TEXCOORD0.xy * _Heightmap_ST.xy + _Heightmap_ST.zw;
					    u_xlat2 = textureLod(_Heightmap, u_xlat2.xy, 0.0);
					    u_xlat2.xyz = u_xlat2.xyz * vec3(_Bumpiness);
					    u_xlat2.xyz = clamp(u_xlat2.xyz, 0.0, 1.0);
					    u_xlat3.xyz = u_xlat2.xyz + vec3(0.0, 0.0, 1.0);
					    u_xlat2.xyz = u_xlat2.xyz * in_NORMAL0.xyz;
					    u_xlat12 = dot(u_xlat3.xyz, u_xlat1.xyz);
					    u_xlat1.xyz = vec3(u_xlat12) * u_xlat3.xyz;
					    u_xlat1.xyz = u_xlat1.xyz / u_xlat3.zzz;
					    u_xlat0.xyz = (-u_xlat0.xyz) * vec3(-1.0, -1.0, 1.0) + u_xlat1.xyz;
					    u_xlat0.x = dot(u_xlat0.xyz, vec3(0.300000012, 0.589999974, 0.109999999));
					    u_xlat0.xyz = u_xlat2.xyz * u_xlat0.xxx + (-u_xlat2.xyz);
					    u_xlat0.xyz = vec3(vec3(_BumpAttune, _BumpAttune, _BumpAttune)) * u_xlat0.xyz + u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz + in_POSITION0.xyz;
					    u_xlat1 = u_xlat0.yyyy * unity_ObjectToWorld[1];
					    u_xlat1 = unity_ObjectToWorld[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat0 = unity_ObjectToWorld[2] * u_xlat0.zzzz + u_xlat1;
					    u_xlat1 = u_xlat0 + unity_ObjectToWorld[3];
					    u_xlat0 = unity_ObjectToWorld[3] * in_POSITION0.wwww + u_xlat0;
					    u_xlat2 = u_xlat1.yyyy * unity_MatrixVP[1];
					    u_xlat2 = unity_MatrixVP[0] * u_xlat1.xxxx + u_xlat2;
					    u_xlat2 = unity_MatrixVP[2] * u_xlat1.zzzz + u_xlat2;
					    u_xlat1 = unity_MatrixVP[3] * u_xlat1.wwww + u_xlat2;
					    gl_Position = u_xlat1;
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
					    vs_TEXCOORD1.xy = in_TEXCOORD1.xy;
					    u_xlat2.xy = u_xlat0.yy * unity_WorldToLight[1].xy;
					    u_xlat2.xy = unity_WorldToLight[0].xy * u_xlat0.xx + u_xlat2.xy;
					    u_xlat2.xy = unity_WorldToLight[2].xy * u_xlat0.zz + u_xlat2.xy;
					    vs_TEXCOORD7.xy = unity_WorldToLight[3].xy * u_xlat0.ww + u_xlat2.xy;
					    vs_TEXCOORD3 = u_xlat0;
					    vs_TEXCOORD2.xy = in_TEXCOORD2.xy;
					    u_xlat0.x = dot(in_NORMAL0.xyz, unity_WorldToObject[0].xyz);
					    u_xlat0.y = dot(in_NORMAL0.xyz, unity_WorldToObject[1].xyz);
					    u_xlat0.z = dot(in_NORMAL0.xyz, unity_WorldToObject[2].xyz);
					    u_xlat12 = dot(u_xlat0.xyz, u_xlat0.xyz);
					    u_xlat12 = inversesqrt(u_xlat12);
					    u_xlat0.xyz = vec3(u_xlat12) * u_xlat0.xyz;
					    vs_TEXCOORD4.xyz = u_xlat0.xyz;
					    u_xlat2.xyz = in_TANGENT0.yyy * unity_ObjectToWorld[1].xyz;
					    u_xlat2.xyz = unity_ObjectToWorld[0].xyz * in_TANGENT0.xxx + u_xlat2.xyz;
					    u_xlat2.xyz = unity_ObjectToWorld[2].xyz * in_TANGENT0.zzz + u_xlat2.xyz;
					    u_xlat12 = dot(u_xlat2.xyz, u_xlat2.xyz);
					    u_xlat12 = inversesqrt(u_xlat12);
					    u_xlat2.xyz = vec3(u_xlat12) * u_xlat2.xyz;
					    vs_TEXCOORD5.xyz = u_xlat2.xyz;
					    u_xlat3.xyz = u_xlat0.zxy * u_xlat2.yzx;
					    u_xlat0.xyz = u_xlat0.yzx * u_xlat2.zxy + (-u_xlat3.xyz);
					    u_xlat0.xyz = u_xlat0.xyz * in_TANGENT0.www;
					    u_xlat12 = dot(u_xlat0.xyz, u_xlat0.xyz);
					    u_xlat12 = inversesqrt(u_xlat12);
					    vs_TEXCOORD6.xyz = vec3(u_xlat12) * u_xlat0.xyz;
					    u_xlat0.x = u_xlat1.y * _ProjectionParams.x;
					    u_xlat0.w = u_xlat0.x * 0.5;
					    u_xlat0.xz = u_xlat1.xw * vec2(0.5, 0.5);
					    vs_TEXCOORD8.zw = u_xlat1.zw;
					    vs_TEXCOORD8.xy = u_xlat0.zz + u_xlat0.xw;
					    return;
					}"
				}
				SubProgram "d3d11 " {
					Keywords { "POINT" "SHADOWS_CUBE" "DIRLIGHTMAP_SEPARATE" "LIGHTMAP_OFF" "DYNAMICLIGHTMAP_OFF" }
					"vs_4_0
					
					#version 330
					#extension GL_ARB_explicit_attrib_location : require
					#extension GL_ARB_explicit_uniform_location : require
					
					#define HLSLCC_ENABLE_UNIFORM_BUFFERS 1
					#if HLSLCC_ENABLE_UNIFORM_BUFFERS
					#define UNITY_UNIFORM
					#else
					#define UNITY_UNIFORM uniform
					#endif
					#define UNITY_SUPPORTS_UNIFORM_LOCATION 1
					#if UNITY_SUPPORTS_UNIFORM_LOCATION
					#define UNITY_LOCATION(x) layout(location = x)
					#define UNITY_BINDING(x) layout(binding = x, std140)
					#else
					#define UNITY_LOCATION(x)
					#define UNITY_BINDING(x) layout(std140)
					#endif
					layout(std140) uniform VGlobals {
						vec4 unused_0_0[2];
						mat4x4 unity_WorldToLight;
						vec4 unused_0_2[2];
						vec4 _MainTexture_ST;
						vec4 unused_0_4[2];
						vec4 _Color;
						vec4 _Heightmap_ST;
						float _Bumpiness;
						float _BumpAttune;
					};
					layout(std140) uniform UnityLighting {
						vec4 unused_1_0;
						vec4 _LightPositionRange;
						vec4 unused_1_2[46];
					};
					layout(std140) uniform UnityPerDraw {
						mat4x4 unity_ObjectToWorld;
						mat4x4 unity_WorldToObject;
						vec4 unused_2_2[2];
					};
					layout(std140) uniform UnityPerFrame {
						vec4 unused_3_0[17];
						mat4x4 unity_MatrixVP;
						vec4 unused_3_2[2];
					};
					uniform  sampler2D _Heightmap;
					uniform  sampler2D _MainTexture;
					in  vec4 in_POSITION0;
					in  vec3 in_NORMAL0;
					in  vec4 in_TANGENT0;
					in  vec2 in_TEXCOORD0;
					in  vec2 in_TEXCOORD1;
					in  vec2 in_TEXCOORD2;
					out vec2 vs_TEXCOORD0;
					out vec2 vs_TEXCOORD1;
					out vec2 vs_TEXCOORD2;
					out vec4 vs_TEXCOORD3;
					out vec3 vs_TEXCOORD4;
					out vec3 vs_TEXCOORD5;
					out vec3 vs_TEXCOORD6;
					out vec3 vs_TEXCOORD7;
					out vec3 vs_TEXCOORD8;
					vec4 u_xlat0;
					vec4 u_xlat1;
					vec4 u_xlat2;
					vec3 u_xlat3;
					float u_xlat12;
					float u_xlat13;
					void main()
					{
					    u_xlat0.xy = in_TEXCOORD0.xy * _MainTexture_ST.xy + _MainTexture_ST.zw;
					    u_xlat0 = textureLod(_MainTexture, u_xlat0.xy, 0.0);
					    u_xlat0.xyz = u_xlat0.xyz * _Color.xyz;
					    u_xlat1.xyz = u_xlat0.xyz * vec3(-1.0, -1.0, 1.0);
					    u_xlat2.xy = in_TEXCOORD0.xy * _Heightmap_ST.xy + _Heightmap_ST.zw;
					    u_xlat2 = textureLod(_Heightmap, u_xlat2.xy, 0.0);
					    u_xlat2.xyz = u_xlat2.xyz * vec3(_Bumpiness);
					    u_xlat2.xyz = clamp(u_xlat2.xyz, 0.0, 1.0);
					    u_xlat3.xyz = u_xlat2.xyz + vec3(0.0, 0.0, 1.0);
					    u_xlat2.xyz = u_xlat2.xyz * in_NORMAL0.xyz;
					    u_xlat12 = dot(u_xlat3.xyz, u_xlat1.xyz);
					    u_xlat1.xyz = vec3(u_xlat12) * u_xlat3.xyz;
					    u_xlat1.xyz = u_xlat1.xyz / u_xlat3.zzz;
					    u_xlat0.xyz = (-u_xlat0.xyz) * vec3(-1.0, -1.0, 1.0) + u_xlat1.xyz;
					    u_xlat0.x = dot(u_xlat0.xyz, vec3(0.300000012, 0.589999974, 0.109999999));
					    u_xlat0.xyz = u_xlat2.xyz * u_xlat0.xxx + (-u_xlat2.xyz);
					    u_xlat0.xyz = vec3(vec3(_BumpAttune, _BumpAttune, _BumpAttune)) * u_xlat0.xyz + u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz + in_POSITION0.xyz;
					    u_xlat1 = u_xlat0.yyyy * unity_ObjectToWorld[1];
					    u_xlat1 = unity_ObjectToWorld[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat0 = unity_ObjectToWorld[2] * u_xlat0.zzzz + u_xlat1;
					    u_xlat1 = u_xlat0 + unity_ObjectToWorld[3];
					    u_xlat0 = unity_ObjectToWorld[3] * in_POSITION0.wwww + u_xlat0;
					    u_xlat2 = u_xlat1.yyyy * unity_MatrixVP[1];
					    u_xlat2 = unity_MatrixVP[0] * u_xlat1.xxxx + u_xlat2;
					    u_xlat2 = unity_MatrixVP[2] * u_xlat1.zzzz + u_xlat2;
					    gl_Position = unity_MatrixVP[3] * u_xlat1.wwww + u_xlat2;
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
					    vs_TEXCOORD1.xy = in_TEXCOORD1.xy;
					    vs_TEXCOORD2.xy = in_TEXCOORD2.xy;
					    vs_TEXCOORD3 = u_xlat0;
					    u_xlat1.x = dot(in_NORMAL0.xyz, unity_WorldToObject[0].xyz);
					    u_xlat1.y = dot(in_NORMAL0.xyz, unity_WorldToObject[1].xyz);
					    u_xlat1.z = dot(in_NORMAL0.xyz, unity_WorldToObject[2].xyz);
					    u_xlat13 = dot(u_xlat1.xyz, u_xlat1.xyz);
					    u_xlat13 = inversesqrt(u_xlat13);
					    u_xlat1.xyz = vec3(u_xlat13) * u_xlat1.xyz;
					    vs_TEXCOORD4.xyz = u_xlat1.xyz;
					    u_xlat2.xyz = in_TANGENT0.yyy * unity_ObjectToWorld[1].xyz;
					    u_xlat2.xyz = unity_ObjectToWorld[0].xyz * in_TANGENT0.xxx + u_xlat2.xyz;
					    u_xlat2.xyz = unity_ObjectToWorld[2].xyz * in_TANGENT0.zzz + u_xlat2.xyz;
					    u_xlat13 = dot(u_xlat2.xyz, u_xlat2.xyz);
					    u_xlat13 = inversesqrt(u_xlat13);
					    u_xlat2.xyz = vec3(u_xlat13) * u_xlat2.xyz;
					    vs_TEXCOORD5.xyz = u_xlat2.xyz;
					    u_xlat3.xyz = u_xlat1.zxy * u_xlat2.yzx;
					    u_xlat1.xyz = u_xlat1.yzx * u_xlat2.zxy + (-u_xlat3.xyz);
					    u_xlat1.xyz = u_xlat1.xyz * in_TANGENT0.www;
					    u_xlat13 = dot(u_xlat1.xyz, u_xlat1.xyz);
					    u_xlat13 = inversesqrt(u_xlat13);
					    vs_TEXCOORD6.xyz = vec3(u_xlat13) * u_xlat1.xyz;
					    u_xlat1.xyz = u_xlat0.yyy * unity_WorldToLight[1].xyz;
					    u_xlat1.xyz = unity_WorldToLight[0].xyz * u_xlat0.xxx + u_xlat1.xyz;
					    u_xlat1.xyz = unity_WorldToLight[2].xyz * u_xlat0.zzz + u_xlat1.xyz;
					    vs_TEXCOORD7.xyz = unity_WorldToLight[3].xyz * u_xlat0.www + u_xlat1.xyz;
					    vs_TEXCOORD8.xyz = u_xlat0.xyz + (-_LightPositionRange.xyz);
					    return;
					}"
				}
				SubProgram "d3d11 " {
					Keywords { "POINT" "SHADOWS_CUBE" "SHADOWS_SOFT" "DIRLIGHTMAP_SEPARATE" "LIGHTMAP_OFF" "DYNAMICLIGHTMAP_OFF" }
					"vs_4_0
					
					#version 330
					#extension GL_ARB_explicit_attrib_location : require
					#extension GL_ARB_explicit_uniform_location : require
					
					#define HLSLCC_ENABLE_UNIFORM_BUFFERS 1
					#if HLSLCC_ENABLE_UNIFORM_BUFFERS
					#define UNITY_UNIFORM
					#else
					#define UNITY_UNIFORM uniform
					#endif
					#define UNITY_SUPPORTS_UNIFORM_LOCATION 1
					#if UNITY_SUPPORTS_UNIFORM_LOCATION
					#define UNITY_LOCATION(x) layout(location = x)
					#define UNITY_BINDING(x) layout(binding = x, std140)
					#else
					#define UNITY_LOCATION(x)
					#define UNITY_BINDING(x) layout(std140)
					#endif
					layout(std140) uniform VGlobals {
						vec4 unused_0_0[2];
						mat4x4 unity_WorldToLight;
						vec4 unused_0_2[2];
						vec4 _MainTexture_ST;
						vec4 unused_0_4[2];
						vec4 _Color;
						vec4 _Heightmap_ST;
						float _Bumpiness;
						float _BumpAttune;
					};
					layout(std140) uniform UnityLighting {
						vec4 unused_1_0;
						vec4 _LightPositionRange;
						vec4 unused_1_2[46];
					};
					layout(std140) uniform UnityPerDraw {
						mat4x4 unity_ObjectToWorld;
						mat4x4 unity_WorldToObject;
						vec4 unused_2_2[2];
					};
					layout(std140) uniform UnityPerFrame {
						vec4 unused_3_0[17];
						mat4x4 unity_MatrixVP;
						vec4 unused_3_2[2];
					};
					uniform  sampler2D _Heightmap;
					uniform  sampler2D _MainTexture;
					in  vec4 in_POSITION0;
					in  vec3 in_NORMAL0;
					in  vec4 in_TANGENT0;
					in  vec2 in_TEXCOORD0;
					in  vec2 in_TEXCOORD1;
					in  vec2 in_TEXCOORD2;
					out vec2 vs_TEXCOORD0;
					out vec2 vs_TEXCOORD1;
					out vec2 vs_TEXCOORD2;
					out vec4 vs_TEXCOORD3;
					out vec3 vs_TEXCOORD4;
					out vec3 vs_TEXCOORD5;
					out vec3 vs_TEXCOORD6;
					out vec3 vs_TEXCOORD7;
					out vec3 vs_TEXCOORD8;
					vec4 u_xlat0;
					vec4 u_xlat1;
					vec4 u_xlat2;
					vec3 u_xlat3;
					float u_xlat12;
					float u_xlat13;
					void main()
					{
					    u_xlat0.xy = in_TEXCOORD0.xy * _MainTexture_ST.xy + _MainTexture_ST.zw;
					    u_xlat0 = textureLod(_MainTexture, u_xlat0.xy, 0.0);
					    u_xlat0.xyz = u_xlat0.xyz * _Color.xyz;
					    u_xlat1.xyz = u_xlat0.xyz * vec3(-1.0, -1.0, 1.0);
					    u_xlat2.xy = in_TEXCOORD0.xy * _Heightmap_ST.xy + _Heightmap_ST.zw;
					    u_xlat2 = textureLod(_Heightmap, u_xlat2.xy, 0.0);
					    u_xlat2.xyz = u_xlat2.xyz * vec3(_Bumpiness);
					    u_xlat2.xyz = clamp(u_xlat2.xyz, 0.0, 1.0);
					    u_xlat3.xyz = u_xlat2.xyz + vec3(0.0, 0.0, 1.0);
					    u_xlat2.xyz = u_xlat2.xyz * in_NORMAL0.xyz;
					    u_xlat12 = dot(u_xlat3.xyz, u_xlat1.xyz);
					    u_xlat1.xyz = vec3(u_xlat12) * u_xlat3.xyz;
					    u_xlat1.xyz = u_xlat1.xyz / u_xlat3.zzz;
					    u_xlat0.xyz = (-u_xlat0.xyz) * vec3(-1.0, -1.0, 1.0) + u_xlat1.xyz;
					    u_xlat0.x = dot(u_xlat0.xyz, vec3(0.300000012, 0.589999974, 0.109999999));
					    u_xlat0.xyz = u_xlat2.xyz * u_xlat0.xxx + (-u_xlat2.xyz);
					    u_xlat0.xyz = vec3(vec3(_BumpAttune, _BumpAttune, _BumpAttune)) * u_xlat0.xyz + u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz + in_POSITION0.xyz;
					    u_xlat1 = u_xlat0.yyyy * unity_ObjectToWorld[1];
					    u_xlat1 = unity_ObjectToWorld[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat0 = unity_ObjectToWorld[2] * u_xlat0.zzzz + u_xlat1;
					    u_xlat1 = u_xlat0 + unity_ObjectToWorld[3];
					    u_xlat0 = unity_ObjectToWorld[3] * in_POSITION0.wwww + u_xlat0;
					    u_xlat2 = u_xlat1.yyyy * unity_MatrixVP[1];
					    u_xlat2 = unity_MatrixVP[0] * u_xlat1.xxxx + u_xlat2;
					    u_xlat2 = unity_MatrixVP[2] * u_xlat1.zzzz + u_xlat2;
					    gl_Position = unity_MatrixVP[3] * u_xlat1.wwww + u_xlat2;
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
					    vs_TEXCOORD1.xy = in_TEXCOORD1.xy;
					    vs_TEXCOORD2.xy = in_TEXCOORD2.xy;
					    vs_TEXCOORD3 = u_xlat0;
					    u_xlat1.x = dot(in_NORMAL0.xyz, unity_WorldToObject[0].xyz);
					    u_xlat1.y = dot(in_NORMAL0.xyz, unity_WorldToObject[1].xyz);
					    u_xlat1.z = dot(in_NORMAL0.xyz, unity_WorldToObject[2].xyz);
					    u_xlat13 = dot(u_xlat1.xyz, u_xlat1.xyz);
					    u_xlat13 = inversesqrt(u_xlat13);
					    u_xlat1.xyz = vec3(u_xlat13) * u_xlat1.xyz;
					    vs_TEXCOORD4.xyz = u_xlat1.xyz;
					    u_xlat2.xyz = in_TANGENT0.yyy * unity_ObjectToWorld[1].xyz;
					    u_xlat2.xyz = unity_ObjectToWorld[0].xyz * in_TANGENT0.xxx + u_xlat2.xyz;
					    u_xlat2.xyz = unity_ObjectToWorld[2].xyz * in_TANGENT0.zzz + u_xlat2.xyz;
					    u_xlat13 = dot(u_xlat2.xyz, u_xlat2.xyz);
					    u_xlat13 = inversesqrt(u_xlat13);
					    u_xlat2.xyz = vec3(u_xlat13) * u_xlat2.xyz;
					    vs_TEXCOORD5.xyz = u_xlat2.xyz;
					    u_xlat3.xyz = u_xlat1.zxy * u_xlat2.yzx;
					    u_xlat1.xyz = u_xlat1.yzx * u_xlat2.zxy + (-u_xlat3.xyz);
					    u_xlat1.xyz = u_xlat1.xyz * in_TANGENT0.www;
					    u_xlat13 = dot(u_xlat1.xyz, u_xlat1.xyz);
					    u_xlat13 = inversesqrt(u_xlat13);
					    vs_TEXCOORD6.xyz = vec3(u_xlat13) * u_xlat1.xyz;
					    u_xlat1.xyz = u_xlat0.yyy * unity_WorldToLight[1].xyz;
					    u_xlat1.xyz = unity_WorldToLight[0].xyz * u_xlat0.xxx + u_xlat1.xyz;
					    u_xlat1.xyz = unity_WorldToLight[2].xyz * u_xlat0.zzz + u_xlat1.xyz;
					    vs_TEXCOORD7.xyz = unity_WorldToLight[3].xyz * u_xlat0.www + u_xlat1.xyz;
					    vs_TEXCOORD8.xyz = u_xlat0.xyz + (-_LightPositionRange.xyz);
					    return;
					}"
				}
				SubProgram "d3d11 " {
					Keywords { "POINT_COOKIE" "SHADOWS_CUBE" "DIRLIGHTMAP_SEPARATE" "LIGHTMAP_OFF" "DYNAMICLIGHTMAP_OFF" }
					"vs_4_0
					
					#version 330
					#extension GL_ARB_explicit_attrib_location : require
					#extension GL_ARB_explicit_uniform_location : require
					
					#define HLSLCC_ENABLE_UNIFORM_BUFFERS 1
					#if HLSLCC_ENABLE_UNIFORM_BUFFERS
					#define UNITY_UNIFORM
					#else
					#define UNITY_UNIFORM uniform
					#endif
					#define UNITY_SUPPORTS_UNIFORM_LOCATION 1
					#if UNITY_SUPPORTS_UNIFORM_LOCATION
					#define UNITY_LOCATION(x) layout(location = x)
					#define UNITY_BINDING(x) layout(binding = x, std140)
					#else
					#define UNITY_LOCATION(x)
					#define UNITY_BINDING(x) layout(std140)
					#endif
					layout(std140) uniform VGlobals {
						vec4 unused_0_0[2];
						mat4x4 unity_WorldToLight;
						vec4 unused_0_2[2];
						vec4 _MainTexture_ST;
						vec4 unused_0_4[2];
						vec4 _Color;
						vec4 _Heightmap_ST;
						float _Bumpiness;
						float _BumpAttune;
					};
					layout(std140) uniform UnityLighting {
						vec4 unused_1_0;
						vec4 _LightPositionRange;
						vec4 unused_1_2[46];
					};
					layout(std140) uniform UnityPerDraw {
						mat4x4 unity_ObjectToWorld;
						mat4x4 unity_WorldToObject;
						vec4 unused_2_2[2];
					};
					layout(std140) uniform UnityPerFrame {
						vec4 unused_3_0[17];
						mat4x4 unity_MatrixVP;
						vec4 unused_3_2[2];
					};
					uniform  sampler2D _Heightmap;
					uniform  sampler2D _MainTexture;
					in  vec4 in_POSITION0;
					in  vec3 in_NORMAL0;
					in  vec4 in_TANGENT0;
					in  vec2 in_TEXCOORD0;
					in  vec2 in_TEXCOORD1;
					in  vec2 in_TEXCOORD2;
					out vec2 vs_TEXCOORD0;
					out vec2 vs_TEXCOORD1;
					out vec2 vs_TEXCOORD2;
					out vec4 vs_TEXCOORD3;
					out vec3 vs_TEXCOORD4;
					out vec3 vs_TEXCOORD5;
					out vec3 vs_TEXCOORD6;
					out vec3 vs_TEXCOORD7;
					out vec3 vs_TEXCOORD8;
					vec4 u_xlat0;
					vec4 u_xlat1;
					vec4 u_xlat2;
					vec3 u_xlat3;
					float u_xlat12;
					float u_xlat13;
					void main()
					{
					    u_xlat0.xy = in_TEXCOORD0.xy * _MainTexture_ST.xy + _MainTexture_ST.zw;
					    u_xlat0 = textureLod(_MainTexture, u_xlat0.xy, 0.0);
					    u_xlat0.xyz = u_xlat0.xyz * _Color.xyz;
					    u_xlat1.xyz = u_xlat0.xyz * vec3(-1.0, -1.0, 1.0);
					    u_xlat2.xy = in_TEXCOORD0.xy * _Heightmap_ST.xy + _Heightmap_ST.zw;
					    u_xlat2 = textureLod(_Heightmap, u_xlat2.xy, 0.0);
					    u_xlat2.xyz = u_xlat2.xyz * vec3(_Bumpiness);
					    u_xlat2.xyz = clamp(u_xlat2.xyz, 0.0, 1.0);
					    u_xlat3.xyz = u_xlat2.xyz + vec3(0.0, 0.0, 1.0);
					    u_xlat2.xyz = u_xlat2.xyz * in_NORMAL0.xyz;
					    u_xlat12 = dot(u_xlat3.xyz, u_xlat1.xyz);
					    u_xlat1.xyz = vec3(u_xlat12) * u_xlat3.xyz;
					    u_xlat1.xyz = u_xlat1.xyz / u_xlat3.zzz;
					    u_xlat0.xyz = (-u_xlat0.xyz) * vec3(-1.0, -1.0, 1.0) + u_xlat1.xyz;
					    u_xlat0.x = dot(u_xlat0.xyz, vec3(0.300000012, 0.589999974, 0.109999999));
					    u_xlat0.xyz = u_xlat2.xyz * u_xlat0.xxx + (-u_xlat2.xyz);
					    u_xlat0.xyz = vec3(vec3(_BumpAttune, _BumpAttune, _BumpAttune)) * u_xlat0.xyz + u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz + in_POSITION0.xyz;
					    u_xlat1 = u_xlat0.yyyy * unity_ObjectToWorld[1];
					    u_xlat1 = unity_ObjectToWorld[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat0 = unity_ObjectToWorld[2] * u_xlat0.zzzz + u_xlat1;
					    u_xlat1 = u_xlat0 + unity_ObjectToWorld[3];
					    u_xlat0 = unity_ObjectToWorld[3] * in_POSITION0.wwww + u_xlat0;
					    u_xlat2 = u_xlat1.yyyy * unity_MatrixVP[1];
					    u_xlat2 = unity_MatrixVP[0] * u_xlat1.xxxx + u_xlat2;
					    u_xlat2 = unity_MatrixVP[2] * u_xlat1.zzzz + u_xlat2;
					    gl_Position = unity_MatrixVP[3] * u_xlat1.wwww + u_xlat2;
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
					    vs_TEXCOORD1.xy = in_TEXCOORD1.xy;
					    vs_TEXCOORD2.xy = in_TEXCOORD2.xy;
					    vs_TEXCOORD3 = u_xlat0;
					    u_xlat1.x = dot(in_NORMAL0.xyz, unity_WorldToObject[0].xyz);
					    u_xlat1.y = dot(in_NORMAL0.xyz, unity_WorldToObject[1].xyz);
					    u_xlat1.z = dot(in_NORMAL0.xyz, unity_WorldToObject[2].xyz);
					    u_xlat13 = dot(u_xlat1.xyz, u_xlat1.xyz);
					    u_xlat13 = inversesqrt(u_xlat13);
					    u_xlat1.xyz = vec3(u_xlat13) * u_xlat1.xyz;
					    vs_TEXCOORD4.xyz = u_xlat1.xyz;
					    u_xlat2.xyz = in_TANGENT0.yyy * unity_ObjectToWorld[1].xyz;
					    u_xlat2.xyz = unity_ObjectToWorld[0].xyz * in_TANGENT0.xxx + u_xlat2.xyz;
					    u_xlat2.xyz = unity_ObjectToWorld[2].xyz * in_TANGENT0.zzz + u_xlat2.xyz;
					    u_xlat13 = dot(u_xlat2.xyz, u_xlat2.xyz);
					    u_xlat13 = inversesqrt(u_xlat13);
					    u_xlat2.xyz = vec3(u_xlat13) * u_xlat2.xyz;
					    vs_TEXCOORD5.xyz = u_xlat2.xyz;
					    u_xlat3.xyz = u_xlat1.zxy * u_xlat2.yzx;
					    u_xlat1.xyz = u_xlat1.yzx * u_xlat2.zxy + (-u_xlat3.xyz);
					    u_xlat1.xyz = u_xlat1.xyz * in_TANGENT0.www;
					    u_xlat13 = dot(u_xlat1.xyz, u_xlat1.xyz);
					    u_xlat13 = inversesqrt(u_xlat13);
					    vs_TEXCOORD6.xyz = vec3(u_xlat13) * u_xlat1.xyz;
					    u_xlat1.xyz = u_xlat0.yyy * unity_WorldToLight[1].xyz;
					    u_xlat1.xyz = unity_WorldToLight[0].xyz * u_xlat0.xxx + u_xlat1.xyz;
					    u_xlat1.xyz = unity_WorldToLight[2].xyz * u_xlat0.zzz + u_xlat1.xyz;
					    vs_TEXCOORD7.xyz = unity_WorldToLight[3].xyz * u_xlat0.www + u_xlat1.xyz;
					    vs_TEXCOORD8.xyz = u_xlat0.xyz + (-_LightPositionRange.xyz);
					    return;
					}"
				}
				SubProgram "d3d11 " {
					Keywords { "POINT_COOKIE" "SHADOWS_CUBE" "SHADOWS_SOFT" "DIRLIGHTMAP_SEPARATE" "LIGHTMAP_OFF" "DYNAMICLIGHTMAP_OFF" }
					"vs_4_0
					
					#version 330
					#extension GL_ARB_explicit_attrib_location : require
					#extension GL_ARB_explicit_uniform_location : require
					
					#define HLSLCC_ENABLE_UNIFORM_BUFFERS 1
					#if HLSLCC_ENABLE_UNIFORM_BUFFERS
					#define UNITY_UNIFORM
					#else
					#define UNITY_UNIFORM uniform
					#endif
					#define UNITY_SUPPORTS_UNIFORM_LOCATION 1
					#if UNITY_SUPPORTS_UNIFORM_LOCATION
					#define UNITY_LOCATION(x) layout(location = x)
					#define UNITY_BINDING(x) layout(binding = x, std140)
					#else
					#define UNITY_LOCATION(x)
					#define UNITY_BINDING(x) layout(std140)
					#endif
					layout(std140) uniform VGlobals {
						vec4 unused_0_0[2];
						mat4x4 unity_WorldToLight;
						vec4 unused_0_2[2];
						vec4 _MainTexture_ST;
						vec4 unused_0_4[2];
						vec4 _Color;
						vec4 _Heightmap_ST;
						float _Bumpiness;
						float _BumpAttune;
					};
					layout(std140) uniform UnityLighting {
						vec4 unused_1_0;
						vec4 _LightPositionRange;
						vec4 unused_1_2[46];
					};
					layout(std140) uniform UnityPerDraw {
						mat4x4 unity_ObjectToWorld;
						mat4x4 unity_WorldToObject;
						vec4 unused_2_2[2];
					};
					layout(std140) uniform UnityPerFrame {
						vec4 unused_3_0[17];
						mat4x4 unity_MatrixVP;
						vec4 unused_3_2[2];
					};
					uniform  sampler2D _Heightmap;
					uniform  sampler2D _MainTexture;
					in  vec4 in_POSITION0;
					in  vec3 in_NORMAL0;
					in  vec4 in_TANGENT0;
					in  vec2 in_TEXCOORD0;
					in  vec2 in_TEXCOORD1;
					in  vec2 in_TEXCOORD2;
					out vec2 vs_TEXCOORD0;
					out vec2 vs_TEXCOORD1;
					out vec2 vs_TEXCOORD2;
					out vec4 vs_TEXCOORD3;
					out vec3 vs_TEXCOORD4;
					out vec3 vs_TEXCOORD5;
					out vec3 vs_TEXCOORD6;
					out vec3 vs_TEXCOORD7;
					out vec3 vs_TEXCOORD8;
					vec4 u_xlat0;
					vec4 u_xlat1;
					vec4 u_xlat2;
					vec3 u_xlat3;
					float u_xlat12;
					float u_xlat13;
					void main()
					{
					    u_xlat0.xy = in_TEXCOORD0.xy * _MainTexture_ST.xy + _MainTexture_ST.zw;
					    u_xlat0 = textureLod(_MainTexture, u_xlat0.xy, 0.0);
					    u_xlat0.xyz = u_xlat0.xyz * _Color.xyz;
					    u_xlat1.xyz = u_xlat0.xyz * vec3(-1.0, -1.0, 1.0);
					    u_xlat2.xy = in_TEXCOORD0.xy * _Heightmap_ST.xy + _Heightmap_ST.zw;
					    u_xlat2 = textureLod(_Heightmap, u_xlat2.xy, 0.0);
					    u_xlat2.xyz = u_xlat2.xyz * vec3(_Bumpiness);
					    u_xlat2.xyz = clamp(u_xlat2.xyz, 0.0, 1.0);
					    u_xlat3.xyz = u_xlat2.xyz + vec3(0.0, 0.0, 1.0);
					    u_xlat2.xyz = u_xlat2.xyz * in_NORMAL0.xyz;
					    u_xlat12 = dot(u_xlat3.xyz, u_xlat1.xyz);
					    u_xlat1.xyz = vec3(u_xlat12) * u_xlat3.xyz;
					    u_xlat1.xyz = u_xlat1.xyz / u_xlat3.zzz;
					    u_xlat0.xyz = (-u_xlat0.xyz) * vec3(-1.0, -1.0, 1.0) + u_xlat1.xyz;
					    u_xlat0.x = dot(u_xlat0.xyz, vec3(0.300000012, 0.589999974, 0.109999999));
					    u_xlat0.xyz = u_xlat2.xyz * u_xlat0.xxx + (-u_xlat2.xyz);
					    u_xlat0.xyz = vec3(vec3(_BumpAttune, _BumpAttune, _BumpAttune)) * u_xlat0.xyz + u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz + in_POSITION0.xyz;
					    u_xlat1 = u_xlat0.yyyy * unity_ObjectToWorld[1];
					    u_xlat1 = unity_ObjectToWorld[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat0 = unity_ObjectToWorld[2] * u_xlat0.zzzz + u_xlat1;
					    u_xlat1 = u_xlat0 + unity_ObjectToWorld[3];
					    u_xlat0 = unity_ObjectToWorld[3] * in_POSITION0.wwww + u_xlat0;
					    u_xlat2 = u_xlat1.yyyy * unity_MatrixVP[1];
					    u_xlat2 = unity_MatrixVP[0] * u_xlat1.xxxx + u_xlat2;
					    u_xlat2 = unity_MatrixVP[2] * u_xlat1.zzzz + u_xlat2;
					    gl_Position = unity_MatrixVP[3] * u_xlat1.wwww + u_xlat2;
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
					    vs_TEXCOORD1.xy = in_TEXCOORD1.xy;
					    vs_TEXCOORD2.xy = in_TEXCOORD2.xy;
					    vs_TEXCOORD3 = u_xlat0;
					    u_xlat1.x = dot(in_NORMAL0.xyz, unity_WorldToObject[0].xyz);
					    u_xlat1.y = dot(in_NORMAL0.xyz, unity_WorldToObject[1].xyz);
					    u_xlat1.z = dot(in_NORMAL0.xyz, unity_WorldToObject[2].xyz);
					    u_xlat13 = dot(u_xlat1.xyz, u_xlat1.xyz);
					    u_xlat13 = inversesqrt(u_xlat13);
					    u_xlat1.xyz = vec3(u_xlat13) * u_xlat1.xyz;
					    vs_TEXCOORD4.xyz = u_xlat1.xyz;
					    u_xlat2.xyz = in_TANGENT0.yyy * unity_ObjectToWorld[1].xyz;
					    u_xlat2.xyz = unity_ObjectToWorld[0].xyz * in_TANGENT0.xxx + u_xlat2.xyz;
					    u_xlat2.xyz = unity_ObjectToWorld[2].xyz * in_TANGENT0.zzz + u_xlat2.xyz;
					    u_xlat13 = dot(u_xlat2.xyz, u_xlat2.xyz);
					    u_xlat13 = inversesqrt(u_xlat13);
					    u_xlat2.xyz = vec3(u_xlat13) * u_xlat2.xyz;
					    vs_TEXCOORD5.xyz = u_xlat2.xyz;
					    u_xlat3.xyz = u_xlat1.zxy * u_xlat2.yzx;
					    u_xlat1.xyz = u_xlat1.yzx * u_xlat2.zxy + (-u_xlat3.xyz);
					    u_xlat1.xyz = u_xlat1.xyz * in_TANGENT0.www;
					    u_xlat13 = dot(u_xlat1.xyz, u_xlat1.xyz);
					    u_xlat13 = inversesqrt(u_xlat13);
					    vs_TEXCOORD6.xyz = vec3(u_xlat13) * u_xlat1.xyz;
					    u_xlat1.xyz = u_xlat0.yyy * unity_WorldToLight[1].xyz;
					    u_xlat1.xyz = unity_WorldToLight[0].xyz * u_xlat0.xxx + u_xlat1.xyz;
					    u_xlat1.xyz = unity_WorldToLight[2].xyz * u_xlat0.zzz + u_xlat1.xyz;
					    vs_TEXCOORD7.xyz = unity_WorldToLight[3].xyz * u_xlat0.www + u_xlat1.xyz;
					    vs_TEXCOORD8.xyz = u_xlat0.xyz + (-_LightPositionRange.xyz);
					    return;
					}"
				}
			}
			Program "fp" {
				SubProgram "d3d11 " {
					Keywords { "POINT" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "DYNAMICLIGHTMAP_OFF" }
					"ps_4_0
					
					#version 330
					#extension GL_ARB_explicit_attrib_location : require
					#extension GL_ARB_explicit_uniform_location : require
					
					#define HLSLCC_ENABLE_UNIFORM_BUFFERS 1
					#if HLSLCC_ENABLE_UNIFORM_BUFFERS
					#define UNITY_UNIFORM
					#else
					#define UNITY_UNIFORM uniform
					#endif
					#define UNITY_SUPPORTS_UNIFORM_LOCATION 1
					#if UNITY_SUPPORTS_UNIFORM_LOCATION
					#define UNITY_LOCATION(x) layout(location = x)
					#define UNITY_BINDING(x) layout(binding = x, std140)
					#else
					#define UNITY_LOCATION(x)
					#define UNITY_BINDING(x) layout(std140)
					#endif
					layout(std140) uniform PGlobals {
						vec4 unused_0_0[6];
						vec4 _LightColor0;
						vec4 unused_0_2;
						vec4 _MainTexture_ST;
						vec4 _Specular_ST;
						vec4 _NormalMap_ST;
						vec4 _Color;
						vec4 unused_0_7;
						float _NormalSharpness;
						float _Shadows;
					};
					layout(std140) uniform UnityPerCamera {
						vec4 unused_1_0[4];
						vec3 _WorldSpaceCameraPos;
						vec4 unused_1_2[4];
					};
					layout(std140) uniform UnityLighting {
						vec4 _WorldSpaceLightPos0;
						vec4 unused_2_1[47];
					};
					uniform  sampler2D _NormalMap;
					uniform  sampler2D _LightTexture0;
					uniform  sampler2D _MainTexture;
					uniform  sampler2D _Specular;
					in  vec2 vs_TEXCOORD0;
					in  vec4 vs_TEXCOORD3;
					in  vec3 vs_TEXCOORD4;
					in  vec3 vs_TEXCOORD5;
					in  vec3 vs_TEXCOORD6;
					in  vec3 vs_TEXCOORD7;
					layout(location = 0) out vec4 SV_Target0;
					vec4 u_xlat0;
					vec4 u_xlat1;
					int u_xlati1;
					vec4 u_xlat2;
					vec4 u_xlat3;
					vec3 u_xlat4;
					vec4 u_xlat5;
					vec3 u_xlat7;
					int u_xlati7;
					float u_xlat12;
					float u_xlat13;
					float u_xlat18;
					float u_xlat19;
					float u_xlat20;
					void main()
					{
					    u_xlat0.xy = vs_TEXCOORD0.xy * _NormalMap_ST.xy + _NormalMap_ST.zw;
					    u_xlat0 = texture(_NormalMap, u_xlat0.xy);
					    u_xlat0.x = u_xlat0.w * u_xlat0.x;
					    u_xlat0.xy = u_xlat0.xy * vec2(2.0, 2.0) + vec2(-1.0, -1.0);
					    u_xlat18 = dot(u_xlat0.xy, u_xlat0.xy);
					    u_xlat18 = min(u_xlat18, 1.0);
					    u_xlat18 = (-u_xlat18) + 1.0;
					    u_xlat0.z = sqrt(u_xlat18);
					    u_xlat18 = (-_NormalSharpness) + 1.0;
					    u_xlat0.xyz = u_xlat0.xyz / vec3(u_xlat18);
					    u_xlat0.xyz = clamp(u_xlat0.xyz, 0.0, 1.0);
					    u_xlat1.xyz = u_xlat0.yyy * vs_TEXCOORD6.xyz;
					    u_xlat0.xyw = u_xlat0.xxx * vs_TEXCOORD5.xyz + u_xlat1.xyz;
					    u_xlat1.x = dot(vs_TEXCOORD4.xyz, vs_TEXCOORD4.xyz);
					    u_xlat1.x = inversesqrt(u_xlat1.x);
					    u_xlat1.xyz = u_xlat1.xxx * vs_TEXCOORD4.xyz;
					    u_xlat0.xyz = u_xlat0.zzz * u_xlat1.xyz + u_xlat0.xyw;
					    u_xlat18 = dot(u_xlat0.xyz, u_xlat0.xyz);
					    u_xlat18 = inversesqrt(u_xlat18);
					    u_xlat0.xyz = vec3(u_xlat18) * u_xlat0.xyz;
					    u_xlat2.xyz = (-vs_TEXCOORD3.xyz) + _WorldSpaceCameraPos.xyz;
					    u_xlat18 = dot(u_xlat2.xyz, u_xlat2.xyz);
					    u_xlat18 = inversesqrt(u_xlat18);
					    u_xlat3.xyz = vec3(u_xlat18) * u_xlat2.xyz;
					    u_xlat1.x = dot(u_xlat3.xyz, u_xlat1.xyz);
					    u_xlati7 = int((0.0<u_xlat1.x) ? 0xFFFFFFFFu : uint(0));
					    u_xlati1 = int((u_xlat1.x<0.0) ? 0xFFFFFFFFu : uint(0));
					    u_xlati1 = (-u_xlati7) + u_xlati1;
					    u_xlat1.x = float(u_xlati1);
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xxx;
					    u_xlat1.xyz = _WorldSpaceLightPos0.www * (-vs_TEXCOORD3.xyz) + _WorldSpaceLightPos0.xyz;
					    u_xlat19 = dot(u_xlat1.xyz, u_xlat1.xyz);
					    u_xlat19 = inversesqrt(u_xlat19);
					    u_xlat1.xyz = vec3(u_xlat19) * u_xlat1.xyz;
					    u_xlat2.xyz = u_xlat2.xyz * vec3(u_xlat18) + u_xlat1.xyz;
					    u_xlat18 = dot(u_xlat2.xyz, u_xlat2.xyz);
					    u_xlat18 = inversesqrt(u_xlat18);
					    u_xlat2.xyz = vec3(u_xlat18) * u_xlat2.xyz;
					    u_xlat0.w = dot(u_xlat0.xyz, u_xlat2.xyz);
					    u_xlat1.w = dot(u_xlat1.xyz, u_xlat2.xyz);
					    u_xlat1.x = dot(u_xlat0.xyz, u_xlat1.xyz);
					    u_xlat0.x = dot(u_xlat0.xyz, u_xlat3.xyz);
					    u_xlat0.yz = max(u_xlat1.xw, vec2(0.0, 0.0));
					    u_xlat0.xw = max(u_xlat0.xw, vec2(0.0, 0.0));
					    u_xlat1.x = log2(u_xlat0.w);
					    u_xlat18 = u_xlat0.w * u_xlat0.w;
					    u_xlat1.x = u_xlat1.x * 9.99999975e-05;
					    u_xlat1.x = exp2(u_xlat1.x);
					    u_xlat7.x = u_xlat0.x * 0.202115417 + 0.797884583;
					    u_xlat13 = u_xlat0.y * 0.202115417 + 0.797884583;
					    u_xlat7.x = u_xlat13 * u_xlat7.x + 9.99999975e-06;
					    u_xlat1.y = float(1.0) / u_xlat7.x;
					    u_xlat1.xy = u_xlat1.xy * vec2(0.318325758, 0.25);
					    u_xlat7.x = u_xlat0.y * u_xlat1.y;
					    u_xlat1.x = u_xlat1.x * u_xlat7.x;
					    u_xlat1.x = u_xlat1.x * 0.616850257;
					    u_xlat7.x = dot(vs_TEXCOORD7.xyz, vs_TEXCOORD7.xyz);
					    u_xlat2 = texture(_LightTexture0, u_xlat7.xx);
					    u_xlat7.xyz = u_xlat2.xxx * _LightColor0.xyz;
					    u_xlat2.xyz = vec3(u_xlat18) * u_xlat7.xyz;
					    u_xlat2.xyz = u_xlat1.xxx * u_xlat2.xyz;
					    u_xlat2.xyz = u_xlat2.xyz * _LightColor0.xyz;
					    u_xlat0.xw = (-u_xlat0.xz) + vec2(1.00001001, 1.0);
					    u_xlat1.x = u_xlat0.w * u_xlat0.w;
					    u_xlat1.x = u_xlat1.x * u_xlat1.x;
					    u_xlat18 = u_xlat0.w * u_xlat1.x;
					    u_xlat3.xy = vs_TEXCOORD0.xy * _MainTexture_ST.xy + _MainTexture_ST.zw;
					    u_xlat3 = texture(_MainTexture, u_xlat3.xy);
					    u_xlat3.xyz = _Color.xyz * u_xlat3.xyz + vec3(vec3(_Shadows, _Shadows, _Shadows));
					    u_xlat3.xyz = u_xlat3.xyz + vec3(-1.0, -1.0, -1.0);
					    u_xlat3.xyz = clamp(u_xlat3.xyz, 0.0, 1.0);
					    u_xlat4.xyz = u_xlat3.xyz + vec3(-0.220916301, -0.220916301, -0.220916301);
					    u_xlat5.xy = vs_TEXCOORD0.xy * _Specular_ST.xy + _Specular_ST.zw;
					    u_xlat5 = texture(_Specular, u_xlat5.xy);
					    u_xlat1.x = u_xlat5.x * 0.449999988;
					    u_xlat20 = (-u_xlat5.x) * 0.350587666 + 0.779083729;
					    u_xlat3.xyz = vec3(u_xlat20) * u_xlat3.xyz;
					    u_xlat4.xyz = u_xlat1.xxx * u_xlat4.xyz + vec3(0.220916301, 0.220916301, 0.220916301);
					    u_xlat5.xyz = (-u_xlat4.xyz) + vec3(1.0, 1.0, 1.0);
					    u_xlat4.xyz = u_xlat5.xyz * vec3(u_xlat18) + u_xlat4.xyz;
					    u_xlat2.xyz = u_xlat2.xyz * u_xlat4.xyz;
					    u_xlat18 = u_xlat0.x * u_xlat0.x;
					    u_xlat18 = u_xlat18 * u_xlat18;
					    u_xlat0.x = u_xlat18 * u_xlat0.x;
					    u_xlat18 = u_xlat0.z + u_xlat0.z;
					    u_xlat12 = u_xlat18 * u_xlat0.z + -0.5;
					    u_xlat0.x = u_xlat12 * u_xlat0.x + 1.0;
					    u_xlat18 = (-u_xlat0.y) + 1.00001001;
					    u_xlat1.x = u_xlat18 * u_xlat18;
					    u_xlat1.x = u_xlat1.x * u_xlat1.x;
					    u_xlat18 = u_xlat18 * u_xlat1.x;
					    u_xlat12 = u_xlat12 * u_xlat18 + 1.0;
					    u_xlat0.x = u_xlat0.x * u_xlat12;
					    u_xlat0.x = u_xlat0.y * u_xlat0.x;
					    u_xlat0.xyz = u_xlat7.xyz * u_xlat0.xxx;
					    SV_Target0.xyz = u_xlat0.xyz * u_xlat3.xyz + u_xlat2.xyz;
					    SV_Target0.w = 0.0;
					    return;
					}"
				}
				SubProgram "d3d11 " {
					Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "DYNAMICLIGHTMAP_OFF" }
					"ps_4_0
					
					#version 330
					#extension GL_ARB_explicit_attrib_location : require
					#extension GL_ARB_explicit_uniform_location : require
					
					#define HLSLCC_ENABLE_UNIFORM_BUFFERS 1
					#if HLSLCC_ENABLE_UNIFORM_BUFFERS
					#define UNITY_UNIFORM
					#else
					#define UNITY_UNIFORM uniform
					#endif
					#define UNITY_SUPPORTS_UNIFORM_LOCATION 1
					#if UNITY_SUPPORTS_UNIFORM_LOCATION
					#define UNITY_LOCATION(x) layout(location = x)
					#define UNITY_BINDING(x) layout(binding = x, std140)
					#else
					#define UNITY_LOCATION(x)
					#define UNITY_BINDING(x) layout(std140)
					#endif
					layout(std140) uniform PGlobals {
						vec4 unused_0_0[2];
						vec4 _LightColor0;
						vec4 unused_0_2;
						vec4 _MainTexture_ST;
						vec4 _Specular_ST;
						vec4 _NormalMap_ST;
						vec4 _Color;
						vec4 unused_0_7;
						float _NormalSharpness;
						float _Shadows;
					};
					layout(std140) uniform UnityPerCamera {
						vec4 unused_1_0[4];
						vec3 _WorldSpaceCameraPos;
						vec4 unused_1_2[4];
					};
					layout(std140) uniform UnityLighting {
						vec4 _WorldSpaceLightPos0;
						vec4 unused_2_1[47];
					};
					uniform  sampler2D _NormalMap;
					uniform  sampler2D _MainTexture;
					uniform  sampler2D _Specular;
					in  vec2 vs_TEXCOORD0;
					in  vec4 vs_TEXCOORD3;
					in  vec3 vs_TEXCOORD4;
					in  vec3 vs_TEXCOORD5;
					in  vec3 vs_TEXCOORD6;
					layout(location = 0) out vec4 SV_Target0;
					vec4 u_xlat0;
					vec4 u_xlat1;
					int u_xlati1;
					vec4 u_xlat2;
					vec3 u_xlat3;
					vec4 u_xlat4;
					vec3 u_xlat6;
					int u_xlati6;
					float u_xlat10;
					float u_xlat15;
					float u_xlat16;
					float u_xlat17;
					void main()
					{
					    u_xlat0.xy = vs_TEXCOORD0.xy * _NormalMap_ST.xy + _NormalMap_ST.zw;
					    u_xlat0 = texture(_NormalMap, u_xlat0.xy);
					    u_xlat0.x = u_xlat0.w * u_xlat0.x;
					    u_xlat0.xy = u_xlat0.xy * vec2(2.0, 2.0) + vec2(-1.0, -1.0);
					    u_xlat15 = dot(u_xlat0.xy, u_xlat0.xy);
					    u_xlat15 = min(u_xlat15, 1.0);
					    u_xlat15 = (-u_xlat15) + 1.0;
					    u_xlat0.z = sqrt(u_xlat15);
					    u_xlat15 = (-_NormalSharpness) + 1.0;
					    u_xlat0.xyz = u_xlat0.xyz / vec3(u_xlat15);
					    u_xlat0.xyz = clamp(u_xlat0.xyz, 0.0, 1.0);
					    u_xlat1.xyz = u_xlat0.yyy * vs_TEXCOORD6.xyz;
					    u_xlat0.xyw = u_xlat0.xxx * vs_TEXCOORD5.xyz + u_xlat1.xyz;
					    u_xlat1.x = dot(vs_TEXCOORD4.xyz, vs_TEXCOORD4.xyz);
					    u_xlat1.x = inversesqrt(u_xlat1.x);
					    u_xlat1.xyz = u_xlat1.xxx * vs_TEXCOORD4.xyz;
					    u_xlat0.xyz = u_xlat0.zzz * u_xlat1.xyz + u_xlat0.xyw;
					    u_xlat15 = dot(u_xlat0.xyz, u_xlat0.xyz);
					    u_xlat15 = inversesqrt(u_xlat15);
					    u_xlat0.xyz = vec3(u_xlat15) * u_xlat0.xyz;
					    u_xlat2.xyz = (-vs_TEXCOORD3.xyz) + _WorldSpaceCameraPos.xyz;
					    u_xlat15 = dot(u_xlat2.xyz, u_xlat2.xyz);
					    u_xlat15 = inversesqrt(u_xlat15);
					    u_xlat3.xyz = vec3(u_xlat15) * u_xlat2.xyz;
					    u_xlat1.x = dot(u_xlat3.xyz, u_xlat1.xyz);
					    u_xlati6 = int((0.0<u_xlat1.x) ? 0xFFFFFFFFu : uint(0));
					    u_xlati1 = int((u_xlat1.x<0.0) ? 0xFFFFFFFFu : uint(0));
					    u_xlati1 = (-u_xlati6) + u_xlati1;
					    u_xlat1.x = float(u_xlati1);
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xxx;
					    u_xlat1.xyz = _WorldSpaceLightPos0.www * (-vs_TEXCOORD3.xyz) + _WorldSpaceLightPos0.xyz;
					    u_xlat16 = dot(u_xlat1.xyz, u_xlat1.xyz);
					    u_xlat16 = inversesqrt(u_xlat16);
					    u_xlat1.xyz = vec3(u_xlat16) * u_xlat1.xyz;
					    u_xlat2.xyz = u_xlat2.xyz * vec3(u_xlat15) + u_xlat1.xyz;
					    u_xlat15 = dot(u_xlat2.xyz, u_xlat2.xyz);
					    u_xlat15 = inversesqrt(u_xlat15);
					    u_xlat2.xyz = vec3(u_xlat15) * u_xlat2.xyz;
					    u_xlat0.w = dot(u_xlat0.xyz, u_xlat2.xyz);
					    u_xlat1.w = dot(u_xlat1.xyz, u_xlat2.xyz);
					    u_xlat1.x = dot(u_xlat0.xyz, u_xlat1.xyz);
					    u_xlat0.x = dot(u_xlat0.xyz, u_xlat3.xyz);
					    u_xlat0.yz = max(u_xlat1.xw, vec2(0.0, 0.0));
					    u_xlat0.xw = max(u_xlat0.xw, vec2(0.0, 0.0));
					    u_xlat1.x = log2(u_xlat0.w);
					    u_xlat15 = u_xlat0.w * u_xlat0.w;
					    u_xlat6.xyz = vec3(u_xlat15) * _LightColor0.xyz;
					    u_xlat15 = u_xlat1.x * 9.99999975e-05;
					    u_xlat15 = exp2(u_xlat15);
					    u_xlat15 = u_xlat15 * 0.318325758;
					    u_xlat1.x = u_xlat0.x * 0.202115417 + 0.797884583;
					    u_xlat2.x = u_xlat0.y * 0.202115417 + 0.797884583;
					    u_xlat1.x = u_xlat2.x * u_xlat1.x + 9.99999975e-06;
					    u_xlat1.x = float(1.0) / u_xlat1.x;
					    u_xlat1.x = u_xlat1.x * 0.25;
					    u_xlat1.x = u_xlat0.y * u_xlat1.x;
					    u_xlat15 = u_xlat15 * u_xlat1.x;
					    u_xlat15 = u_xlat15 * 0.616850257;
					    u_xlat1.xyz = vec3(u_xlat15) * u_xlat6.xyz;
					    u_xlat1.xyz = u_xlat1.xyz * _LightColor0.xyz;
					    u_xlat0.xw = (-u_xlat0.xz) + vec2(1.00001001, 1.0);
					    u_xlat16 = u_xlat0.w * u_xlat0.w;
					    u_xlat16 = u_xlat16 * u_xlat16;
					    u_xlat15 = u_xlat0.w * u_xlat16;
					    u_xlat2.xy = vs_TEXCOORD0.xy * _MainTexture_ST.xy + _MainTexture_ST.zw;
					    u_xlat2 = texture(_MainTexture, u_xlat2.xy);
					    u_xlat2.xyz = _Color.xyz * u_xlat2.xyz + vec3(vec3(_Shadows, _Shadows, _Shadows));
					    u_xlat2.xyz = u_xlat2.xyz + vec3(-1.0, -1.0, -1.0);
					    u_xlat2.xyz = clamp(u_xlat2.xyz, 0.0, 1.0);
					    u_xlat3.xyz = u_xlat2.xyz + vec3(-0.220916301, -0.220916301, -0.220916301);
					    u_xlat4.xy = vs_TEXCOORD0.xy * _Specular_ST.xy + _Specular_ST.zw;
					    u_xlat4 = texture(_Specular, u_xlat4.xy);
					    u_xlat16 = u_xlat4.x * 0.449999988;
					    u_xlat17 = (-u_xlat4.x) * 0.350587666 + 0.779083729;
					    u_xlat2.xyz = vec3(u_xlat17) * u_xlat2.xyz;
					    u_xlat3.xyz = vec3(u_xlat16) * u_xlat3.xyz + vec3(0.220916301, 0.220916301, 0.220916301);
					    u_xlat4.xyz = (-u_xlat3.xyz) + vec3(1.0, 1.0, 1.0);
					    u_xlat3.xyz = u_xlat4.xyz * vec3(u_xlat15) + u_xlat3.xyz;
					    u_xlat1.xyz = u_xlat1.xyz * u_xlat3.xyz;
					    u_xlat15 = u_xlat0.x * u_xlat0.x;
					    u_xlat15 = u_xlat15 * u_xlat15;
					    u_xlat0.x = u_xlat15 * u_xlat0.x;
					    u_xlat15 = u_xlat0.z + u_xlat0.z;
					    u_xlat10 = u_xlat15 * u_xlat0.z + -0.5;
					    u_xlat0.x = u_xlat10 * u_xlat0.x + 1.0;
					    u_xlat15 = (-u_xlat0.y) + 1.00001001;
					    u_xlat16 = u_xlat15 * u_xlat15;
					    u_xlat16 = u_xlat16 * u_xlat16;
					    u_xlat15 = u_xlat15 * u_xlat16;
					    u_xlat10 = u_xlat10 * u_xlat15 + 1.0;
					    u_xlat0.x = u_xlat0.x * u_xlat10;
					    u_xlat0.x = u_xlat0.y * u_xlat0.x;
					    u_xlat0.xyz = u_xlat0.xxx * _LightColor0.xyz;
					    SV_Target0.xyz = u_xlat0.xyz * u_xlat2.xyz + u_xlat1.xyz;
					    SV_Target0.w = 0.0;
					    return;
					}"
				}
				SubProgram "d3d11 " {
					Keywords { "SPOT" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "DYNAMICLIGHTMAP_OFF" }
					"ps_4_0
					
					#version 330
					#extension GL_ARB_explicit_attrib_location : require
					#extension GL_ARB_explicit_uniform_location : require
					
					#define HLSLCC_ENABLE_UNIFORM_BUFFERS 1
					#if HLSLCC_ENABLE_UNIFORM_BUFFERS
					#define UNITY_UNIFORM
					#else
					#define UNITY_UNIFORM uniform
					#endif
					#define UNITY_SUPPORTS_UNIFORM_LOCATION 1
					#if UNITY_SUPPORTS_UNIFORM_LOCATION
					#define UNITY_LOCATION(x) layout(location = x)
					#define UNITY_BINDING(x) layout(binding = x, std140)
					#else
					#define UNITY_LOCATION(x)
					#define UNITY_BINDING(x) layout(std140)
					#endif
					layout(std140) uniform PGlobals {
						vec4 unused_0_0[6];
						vec4 _LightColor0;
						vec4 unused_0_2;
						vec4 _MainTexture_ST;
						vec4 _Specular_ST;
						vec4 _NormalMap_ST;
						vec4 _Color;
						vec4 unused_0_7;
						float _NormalSharpness;
						float _Shadows;
					};
					layout(std140) uniform UnityPerCamera {
						vec4 unused_1_0[4];
						vec3 _WorldSpaceCameraPos;
						vec4 unused_1_2[4];
					};
					layout(std140) uniform UnityLighting {
						vec4 _WorldSpaceLightPos0;
						vec4 unused_2_1[47];
					};
					uniform  sampler2D _NormalMap;
					uniform  sampler2D _LightTexture0;
					uniform  sampler2D _LightTextureB0;
					uniform  sampler2D _MainTexture;
					uniform  sampler2D _Specular;
					in  vec2 vs_TEXCOORD0;
					in  vec4 vs_TEXCOORD3;
					in  vec3 vs_TEXCOORD4;
					in  vec3 vs_TEXCOORD5;
					in  vec3 vs_TEXCOORD6;
					in  vec4 vs_TEXCOORD7;
					layout(location = 0) out vec4 SV_Target0;
					vec4 u_xlat0;
					vec4 u_xlat1;
					int u_xlati1;
					vec4 u_xlat2;
					vec4 u_xlat3;
					vec3 u_xlat4;
					vec4 u_xlat5;
					vec3 u_xlat7;
					int u_xlati7;
					bool u_xlatb7;
					float u_xlat12;
					float u_xlat13;
					float u_xlat18;
					float u_xlat19;
					float u_xlat20;
					void main()
					{
					    u_xlat0.xy = vs_TEXCOORD0.xy * _NormalMap_ST.xy + _NormalMap_ST.zw;
					    u_xlat0 = texture(_NormalMap, u_xlat0.xy);
					    u_xlat0.x = u_xlat0.w * u_xlat0.x;
					    u_xlat0.xy = u_xlat0.xy * vec2(2.0, 2.0) + vec2(-1.0, -1.0);
					    u_xlat18 = dot(u_xlat0.xy, u_xlat0.xy);
					    u_xlat18 = min(u_xlat18, 1.0);
					    u_xlat18 = (-u_xlat18) + 1.0;
					    u_xlat0.z = sqrt(u_xlat18);
					    u_xlat18 = (-_NormalSharpness) + 1.0;
					    u_xlat0.xyz = u_xlat0.xyz / vec3(u_xlat18);
					    u_xlat0.xyz = clamp(u_xlat0.xyz, 0.0, 1.0);
					    u_xlat1.xyz = u_xlat0.yyy * vs_TEXCOORD6.xyz;
					    u_xlat0.xyw = u_xlat0.xxx * vs_TEXCOORD5.xyz + u_xlat1.xyz;
					    u_xlat1.x = dot(vs_TEXCOORD4.xyz, vs_TEXCOORD4.xyz);
					    u_xlat1.x = inversesqrt(u_xlat1.x);
					    u_xlat1.xyz = u_xlat1.xxx * vs_TEXCOORD4.xyz;
					    u_xlat0.xyz = u_xlat0.zzz * u_xlat1.xyz + u_xlat0.xyw;
					    u_xlat18 = dot(u_xlat0.xyz, u_xlat0.xyz);
					    u_xlat18 = inversesqrt(u_xlat18);
					    u_xlat0.xyz = vec3(u_xlat18) * u_xlat0.xyz;
					    u_xlat2.xyz = (-vs_TEXCOORD3.xyz) + _WorldSpaceCameraPos.xyz;
					    u_xlat18 = dot(u_xlat2.xyz, u_xlat2.xyz);
					    u_xlat18 = inversesqrt(u_xlat18);
					    u_xlat3.xyz = vec3(u_xlat18) * u_xlat2.xyz;
					    u_xlat1.x = dot(u_xlat3.xyz, u_xlat1.xyz);
					    u_xlati7 = int((0.0<u_xlat1.x) ? 0xFFFFFFFFu : uint(0));
					    u_xlati1 = int((u_xlat1.x<0.0) ? 0xFFFFFFFFu : uint(0));
					    u_xlati1 = (-u_xlati7) + u_xlati1;
					    u_xlat1.x = float(u_xlati1);
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xxx;
					    u_xlat1.xyz = _WorldSpaceLightPos0.www * (-vs_TEXCOORD3.xyz) + _WorldSpaceLightPos0.xyz;
					    u_xlat19 = dot(u_xlat1.xyz, u_xlat1.xyz);
					    u_xlat19 = inversesqrt(u_xlat19);
					    u_xlat1.xyz = vec3(u_xlat19) * u_xlat1.xyz;
					    u_xlat2.xyz = u_xlat2.xyz * vec3(u_xlat18) + u_xlat1.xyz;
					    u_xlat18 = dot(u_xlat2.xyz, u_xlat2.xyz);
					    u_xlat18 = inversesqrt(u_xlat18);
					    u_xlat2.xyz = vec3(u_xlat18) * u_xlat2.xyz;
					    u_xlat0.w = dot(u_xlat0.xyz, u_xlat2.xyz);
					    u_xlat1.w = dot(u_xlat1.xyz, u_xlat2.xyz);
					    u_xlat1.x = dot(u_xlat0.xyz, u_xlat1.xyz);
					    u_xlat0.x = dot(u_xlat0.xyz, u_xlat3.xyz);
					    u_xlat0.yz = max(u_xlat1.xw, vec2(0.0, 0.0));
					    u_xlat0.xw = max(u_xlat0.xw, vec2(0.0, 0.0));
					    u_xlat1.x = log2(u_xlat0.w);
					    u_xlat18 = u_xlat0.w * u_xlat0.w;
					    u_xlat1.x = u_xlat1.x * 9.99999975e-05;
					    u_xlat1.x = exp2(u_xlat1.x);
					    u_xlat7.x = u_xlat0.x * 0.202115417 + 0.797884583;
					    u_xlat13 = u_xlat0.y * 0.202115417 + 0.797884583;
					    u_xlat7.x = u_xlat13 * u_xlat7.x + 9.99999975e-06;
					    u_xlat1.y = float(1.0) / u_xlat7.x;
					    u_xlat1.xy = u_xlat1.xy * vec2(0.318325758, 0.25);
					    u_xlat7.x = u_xlat0.y * u_xlat1.y;
					    u_xlat1.x = u_xlat1.x * u_xlat7.x;
					    u_xlat1.x = u_xlat1.x * 0.616850257;
					    u_xlat7.xy = vs_TEXCOORD7.xy / vs_TEXCOORD7.ww;
					    u_xlat7.xy = u_xlat7.xy + vec2(0.5, 0.5);
					    u_xlat2 = texture(_LightTexture0, u_xlat7.xy);
					    u_xlatb7 = 0.0<vs_TEXCOORD7.z;
					    u_xlat7.x = u_xlatb7 ? 1.0 : float(0.0);
					    u_xlat7.x = u_xlat2.w * u_xlat7.x;
					    u_xlat13 = dot(vs_TEXCOORD7.xyz, vs_TEXCOORD7.xyz);
					    u_xlat2 = texture(_LightTextureB0, vec2(u_xlat13));
					    u_xlat7.x = u_xlat7.x * u_xlat2.x;
					    u_xlat7.xyz = u_xlat7.xxx * _LightColor0.xyz;
					    u_xlat2.xyz = vec3(u_xlat18) * u_xlat7.xyz;
					    u_xlat2.xyz = u_xlat1.xxx * u_xlat2.xyz;
					    u_xlat2.xyz = u_xlat2.xyz * _LightColor0.xyz;
					    u_xlat0.xw = (-u_xlat0.xz) + vec2(1.00001001, 1.0);
					    u_xlat1.x = u_xlat0.w * u_xlat0.w;
					    u_xlat1.x = u_xlat1.x * u_xlat1.x;
					    u_xlat18 = u_xlat0.w * u_xlat1.x;
					    u_xlat3.xy = vs_TEXCOORD0.xy * _MainTexture_ST.xy + _MainTexture_ST.zw;
					    u_xlat3 = texture(_MainTexture, u_xlat3.xy);
					    u_xlat3.xyz = _Color.xyz * u_xlat3.xyz + vec3(vec3(_Shadows, _Shadows, _Shadows));
					    u_xlat3.xyz = u_xlat3.xyz + vec3(-1.0, -1.0, -1.0);
					    u_xlat3.xyz = clamp(u_xlat3.xyz, 0.0, 1.0);
					    u_xlat4.xyz = u_xlat3.xyz + vec3(-0.220916301, -0.220916301, -0.220916301);
					    u_xlat5.xy = vs_TEXCOORD0.xy * _Specular_ST.xy + _Specular_ST.zw;
					    u_xlat5 = texture(_Specular, u_xlat5.xy);
					    u_xlat1.x = u_xlat5.x * 0.449999988;
					    u_xlat20 = (-u_xlat5.x) * 0.350587666 + 0.779083729;
					    u_xlat3.xyz = vec3(u_xlat20) * u_xlat3.xyz;
					    u_xlat4.xyz = u_xlat1.xxx * u_xlat4.xyz + vec3(0.220916301, 0.220916301, 0.220916301);
					    u_xlat5.xyz = (-u_xlat4.xyz) + vec3(1.0, 1.0, 1.0);
					    u_xlat4.xyz = u_xlat5.xyz * vec3(u_xlat18) + u_xlat4.xyz;
					    u_xlat2.xyz = u_xlat2.xyz * u_xlat4.xyz;
					    u_xlat18 = u_xlat0.x * u_xlat0.x;
					    u_xlat18 = u_xlat18 * u_xlat18;
					    u_xlat0.x = u_xlat18 * u_xlat0.x;
					    u_xlat18 = u_xlat0.z + u_xlat0.z;
					    u_xlat12 = u_xlat18 * u_xlat0.z + -0.5;
					    u_xlat0.x = u_xlat12 * u_xlat0.x + 1.0;
					    u_xlat18 = (-u_xlat0.y) + 1.00001001;
					    u_xlat1.x = u_xlat18 * u_xlat18;
					    u_xlat1.x = u_xlat1.x * u_xlat1.x;
					    u_xlat18 = u_xlat18 * u_xlat1.x;
					    u_xlat12 = u_xlat12 * u_xlat18 + 1.0;
					    u_xlat0.x = u_xlat0.x * u_xlat12;
					    u_xlat0.x = u_xlat0.y * u_xlat0.x;
					    u_xlat0.xyz = u_xlat7.xyz * u_xlat0.xxx;
					    SV_Target0.xyz = u_xlat0.xyz * u_xlat3.xyz + u_xlat2.xyz;
					    SV_Target0.w = 0.0;
					    return;
					}"
				}
				SubProgram "d3d11 " {
					Keywords { "POINT_COOKIE" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "DYNAMICLIGHTMAP_OFF" }
					"ps_4_0
					
					#version 330
					#extension GL_ARB_explicit_attrib_location : require
					#extension GL_ARB_explicit_uniform_location : require
					
					#define HLSLCC_ENABLE_UNIFORM_BUFFERS 1
					#if HLSLCC_ENABLE_UNIFORM_BUFFERS
					#define UNITY_UNIFORM
					#else
					#define UNITY_UNIFORM uniform
					#endif
					#define UNITY_SUPPORTS_UNIFORM_LOCATION 1
					#if UNITY_SUPPORTS_UNIFORM_LOCATION
					#define UNITY_LOCATION(x) layout(location = x)
					#define UNITY_BINDING(x) layout(binding = x, std140)
					#else
					#define UNITY_LOCATION(x)
					#define UNITY_BINDING(x) layout(std140)
					#endif
					layout(std140) uniform PGlobals {
						vec4 unused_0_0[6];
						vec4 _LightColor0;
						vec4 unused_0_2;
						vec4 _MainTexture_ST;
						vec4 _Specular_ST;
						vec4 _NormalMap_ST;
						vec4 _Color;
						vec4 unused_0_7;
						float _NormalSharpness;
						float _Shadows;
					};
					layout(std140) uniform UnityPerCamera {
						vec4 unused_1_0[4];
						vec3 _WorldSpaceCameraPos;
						vec4 unused_1_2[4];
					};
					layout(std140) uniform UnityLighting {
						vec4 _WorldSpaceLightPos0;
						vec4 unused_2_1[47];
					};
					uniform  sampler2D _NormalMap;
					uniform  sampler2D _LightTextureB0;
					uniform  samplerCube _LightTexture0;
					uniform  sampler2D _MainTexture;
					uniform  sampler2D _Specular;
					in  vec2 vs_TEXCOORD0;
					in  vec4 vs_TEXCOORD3;
					in  vec3 vs_TEXCOORD4;
					in  vec3 vs_TEXCOORD5;
					in  vec3 vs_TEXCOORD6;
					in  vec3 vs_TEXCOORD7;
					layout(location = 0) out vec4 SV_Target0;
					vec4 u_xlat0;
					vec4 u_xlat1;
					int u_xlati1;
					vec4 u_xlat2;
					vec4 u_xlat3;
					vec3 u_xlat4;
					vec4 u_xlat5;
					vec3 u_xlat7;
					int u_xlati7;
					float u_xlat12;
					float u_xlat13;
					float u_xlat18;
					float u_xlat19;
					float u_xlat20;
					void main()
					{
					    u_xlat0.xy = vs_TEXCOORD0.xy * _NormalMap_ST.xy + _NormalMap_ST.zw;
					    u_xlat0 = texture(_NormalMap, u_xlat0.xy);
					    u_xlat0.x = u_xlat0.w * u_xlat0.x;
					    u_xlat0.xy = u_xlat0.xy * vec2(2.0, 2.0) + vec2(-1.0, -1.0);
					    u_xlat18 = dot(u_xlat0.xy, u_xlat0.xy);
					    u_xlat18 = min(u_xlat18, 1.0);
					    u_xlat18 = (-u_xlat18) + 1.0;
					    u_xlat0.z = sqrt(u_xlat18);
					    u_xlat18 = (-_NormalSharpness) + 1.0;
					    u_xlat0.xyz = u_xlat0.xyz / vec3(u_xlat18);
					    u_xlat0.xyz = clamp(u_xlat0.xyz, 0.0, 1.0);
					    u_xlat1.xyz = u_xlat0.yyy * vs_TEXCOORD6.xyz;
					    u_xlat0.xyw = u_xlat0.xxx * vs_TEXCOORD5.xyz + u_xlat1.xyz;
					    u_xlat1.x = dot(vs_TEXCOORD4.xyz, vs_TEXCOORD4.xyz);
					    u_xlat1.x = inversesqrt(u_xlat1.x);
					    u_xlat1.xyz = u_xlat1.xxx * vs_TEXCOORD4.xyz;
					    u_xlat0.xyz = u_xlat0.zzz * u_xlat1.xyz + u_xlat0.xyw;
					    u_xlat18 = dot(u_xlat0.xyz, u_xlat0.xyz);
					    u_xlat18 = inversesqrt(u_xlat18);
					    u_xlat0.xyz = vec3(u_xlat18) * u_xlat0.xyz;
					    u_xlat2.xyz = (-vs_TEXCOORD3.xyz) + _WorldSpaceCameraPos.xyz;
					    u_xlat18 = dot(u_xlat2.xyz, u_xlat2.xyz);
					    u_xlat18 = inversesqrt(u_xlat18);
					    u_xlat3.xyz = vec3(u_xlat18) * u_xlat2.xyz;
					    u_xlat1.x = dot(u_xlat3.xyz, u_xlat1.xyz);
					    u_xlati7 = int((0.0<u_xlat1.x) ? 0xFFFFFFFFu : uint(0));
					    u_xlati1 = int((u_xlat1.x<0.0) ? 0xFFFFFFFFu : uint(0));
					    u_xlati1 = (-u_xlati7) + u_xlati1;
					    u_xlat1.x = float(u_xlati1);
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xxx;
					    u_xlat1.xyz = _WorldSpaceLightPos0.www * (-vs_TEXCOORD3.xyz) + _WorldSpaceLightPos0.xyz;
					    u_xlat19 = dot(u_xlat1.xyz, u_xlat1.xyz);
					    u_xlat19 = inversesqrt(u_xlat19);
					    u_xlat1.xyz = vec3(u_xlat19) * u_xlat1.xyz;
					    u_xlat2.xyz = u_xlat2.xyz * vec3(u_xlat18) + u_xlat1.xyz;
					    u_xlat18 = dot(u_xlat2.xyz, u_xlat2.xyz);
					    u_xlat18 = inversesqrt(u_xlat18);
					    u_xlat2.xyz = vec3(u_xlat18) * u_xlat2.xyz;
					    u_xlat0.w = dot(u_xlat0.xyz, u_xlat2.xyz);
					    u_xlat1.w = dot(u_xlat1.xyz, u_xlat2.xyz);
					    u_xlat1.x = dot(u_xlat0.xyz, u_xlat1.xyz);
					    u_xlat0.x = dot(u_xlat0.xyz, u_xlat3.xyz);
					    u_xlat0.yz = max(u_xlat1.xw, vec2(0.0, 0.0));
					    u_xlat0.xw = max(u_xlat0.xw, vec2(0.0, 0.0));
					    u_xlat1.x = log2(u_xlat0.w);
					    u_xlat18 = u_xlat0.w * u_xlat0.w;
					    u_xlat1.x = u_xlat1.x * 9.99999975e-05;
					    u_xlat1.x = exp2(u_xlat1.x);
					    u_xlat7.x = u_xlat0.x * 0.202115417 + 0.797884583;
					    u_xlat13 = u_xlat0.y * 0.202115417 + 0.797884583;
					    u_xlat7.x = u_xlat13 * u_xlat7.x + 9.99999975e-06;
					    u_xlat1.y = float(1.0) / u_xlat7.x;
					    u_xlat1.xy = u_xlat1.xy * vec2(0.318325758, 0.25);
					    u_xlat7.x = u_xlat0.y * u_xlat1.y;
					    u_xlat1.x = u_xlat1.x * u_xlat7.x;
					    u_xlat1.x = u_xlat1.x * 0.616850257;
					    u_xlat7.x = dot(vs_TEXCOORD7.xyz, vs_TEXCOORD7.xyz);
					    u_xlat2 = texture(_LightTextureB0, u_xlat7.xx);
					    u_xlat3 = texture(_LightTexture0, vs_TEXCOORD7.xyz);
					    u_xlat7.x = u_xlat2.x * u_xlat3.w;
					    u_xlat7.xyz = u_xlat7.xxx * _LightColor0.xyz;
					    u_xlat2.xyz = vec3(u_xlat18) * u_xlat7.xyz;
					    u_xlat2.xyz = u_xlat1.xxx * u_xlat2.xyz;
					    u_xlat2.xyz = u_xlat2.xyz * _LightColor0.xyz;
					    u_xlat0.xw = (-u_xlat0.xz) + vec2(1.00001001, 1.0);
					    u_xlat1.x = u_xlat0.w * u_xlat0.w;
					    u_xlat1.x = u_xlat1.x * u_xlat1.x;
					    u_xlat18 = u_xlat0.w * u_xlat1.x;
					    u_xlat3.xy = vs_TEXCOORD0.xy * _MainTexture_ST.xy + _MainTexture_ST.zw;
					    u_xlat3 = texture(_MainTexture, u_xlat3.xy);
					    u_xlat3.xyz = _Color.xyz * u_xlat3.xyz + vec3(vec3(_Shadows, _Shadows, _Shadows));
					    u_xlat3.xyz = u_xlat3.xyz + vec3(-1.0, -1.0, -1.0);
					    u_xlat3.xyz = clamp(u_xlat3.xyz, 0.0, 1.0);
					    u_xlat4.xyz = u_xlat3.xyz + vec3(-0.220916301, -0.220916301, -0.220916301);
					    u_xlat5.xy = vs_TEXCOORD0.xy * _Specular_ST.xy + _Specular_ST.zw;
					    u_xlat5 = texture(_Specular, u_xlat5.xy);
					    u_xlat1.x = u_xlat5.x * 0.449999988;
					    u_xlat20 = (-u_xlat5.x) * 0.350587666 + 0.779083729;
					    u_xlat3.xyz = vec3(u_xlat20) * u_xlat3.xyz;
					    u_xlat4.xyz = u_xlat1.xxx * u_xlat4.xyz + vec3(0.220916301, 0.220916301, 0.220916301);
					    u_xlat5.xyz = (-u_xlat4.xyz) + vec3(1.0, 1.0, 1.0);
					    u_xlat4.xyz = u_xlat5.xyz * vec3(u_xlat18) + u_xlat4.xyz;
					    u_xlat2.xyz = u_xlat2.xyz * u_xlat4.xyz;
					    u_xlat18 = u_xlat0.x * u_xlat0.x;
					    u_xlat18 = u_xlat18 * u_xlat18;
					    u_xlat0.x = u_xlat18 * u_xlat0.x;
					    u_xlat18 = u_xlat0.z + u_xlat0.z;
					    u_xlat12 = u_xlat18 * u_xlat0.z + -0.5;
					    u_xlat0.x = u_xlat12 * u_xlat0.x + 1.0;
					    u_xlat18 = (-u_xlat0.y) + 1.00001001;
					    u_xlat1.x = u_xlat18 * u_xlat18;
					    u_xlat1.x = u_xlat1.x * u_xlat1.x;
					    u_xlat18 = u_xlat18 * u_xlat1.x;
					    u_xlat12 = u_xlat12 * u_xlat18 + 1.0;
					    u_xlat0.x = u_xlat0.x * u_xlat12;
					    u_xlat0.x = u_xlat0.y * u_xlat0.x;
					    u_xlat0.xyz = u_xlat7.xyz * u_xlat0.xxx;
					    SV_Target0.xyz = u_xlat0.xyz * u_xlat3.xyz + u_xlat2.xyz;
					    SV_Target0.w = 0.0;
					    return;
					}"
				}
				SubProgram "d3d11 " {
					Keywords { "DIRECTIONAL_COOKIE" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "DYNAMICLIGHTMAP_OFF" }
					"ps_4_0
					
					#version 330
					#extension GL_ARB_explicit_attrib_location : require
					#extension GL_ARB_explicit_uniform_location : require
					
					#define HLSLCC_ENABLE_UNIFORM_BUFFERS 1
					#if HLSLCC_ENABLE_UNIFORM_BUFFERS
					#define UNITY_UNIFORM
					#else
					#define UNITY_UNIFORM uniform
					#endif
					#define UNITY_SUPPORTS_UNIFORM_LOCATION 1
					#if UNITY_SUPPORTS_UNIFORM_LOCATION
					#define UNITY_LOCATION(x) layout(location = x)
					#define UNITY_BINDING(x) layout(binding = x, std140)
					#else
					#define UNITY_LOCATION(x)
					#define UNITY_BINDING(x) layout(std140)
					#endif
					layout(std140) uniform PGlobals {
						vec4 unused_0_0[6];
						vec4 _LightColor0;
						vec4 unused_0_2;
						vec4 _MainTexture_ST;
						vec4 _Specular_ST;
						vec4 _NormalMap_ST;
						vec4 _Color;
						vec4 unused_0_7;
						float _NormalSharpness;
						float _Shadows;
					};
					layout(std140) uniform UnityPerCamera {
						vec4 unused_1_0[4];
						vec3 _WorldSpaceCameraPos;
						vec4 unused_1_2[4];
					};
					layout(std140) uniform UnityLighting {
						vec4 _WorldSpaceLightPos0;
						vec4 unused_2_1[47];
					};
					uniform  sampler2D _NormalMap;
					uniform  sampler2D _LightTexture0;
					uniform  sampler2D _MainTexture;
					uniform  sampler2D _Specular;
					in  vec2 vs_TEXCOORD0;
					in  vec2 vs_TEXCOORD7;
					in  vec4 vs_TEXCOORD3;
					in  vec3 vs_TEXCOORD4;
					in  vec3 vs_TEXCOORD5;
					in  vec3 vs_TEXCOORD6;
					layout(location = 0) out vec4 SV_Target0;
					vec4 u_xlat0;
					vec4 u_xlat1;
					int u_xlati1;
					vec4 u_xlat2;
					vec4 u_xlat3;
					vec3 u_xlat4;
					vec4 u_xlat5;
					vec3 u_xlat7;
					int u_xlati7;
					float u_xlat12;
					float u_xlat13;
					float u_xlat18;
					float u_xlat19;
					float u_xlat20;
					void main()
					{
					    u_xlat0.xy = vs_TEXCOORD0.xy * _NormalMap_ST.xy + _NormalMap_ST.zw;
					    u_xlat0 = texture(_NormalMap, u_xlat0.xy);
					    u_xlat0.x = u_xlat0.w * u_xlat0.x;
					    u_xlat0.xy = u_xlat0.xy * vec2(2.0, 2.0) + vec2(-1.0, -1.0);
					    u_xlat18 = dot(u_xlat0.xy, u_xlat0.xy);
					    u_xlat18 = min(u_xlat18, 1.0);
					    u_xlat18 = (-u_xlat18) + 1.0;
					    u_xlat0.z = sqrt(u_xlat18);
					    u_xlat18 = (-_NormalSharpness) + 1.0;
					    u_xlat0.xyz = u_xlat0.xyz / vec3(u_xlat18);
					    u_xlat0.xyz = clamp(u_xlat0.xyz, 0.0, 1.0);
					    u_xlat1.xyz = u_xlat0.yyy * vs_TEXCOORD6.xyz;
					    u_xlat0.xyw = u_xlat0.xxx * vs_TEXCOORD5.xyz + u_xlat1.xyz;
					    u_xlat1.x = dot(vs_TEXCOORD4.xyz, vs_TEXCOORD4.xyz);
					    u_xlat1.x = inversesqrt(u_xlat1.x);
					    u_xlat1.xyz = u_xlat1.xxx * vs_TEXCOORD4.xyz;
					    u_xlat0.xyz = u_xlat0.zzz * u_xlat1.xyz + u_xlat0.xyw;
					    u_xlat18 = dot(u_xlat0.xyz, u_xlat0.xyz);
					    u_xlat18 = inversesqrt(u_xlat18);
					    u_xlat0.xyz = vec3(u_xlat18) * u_xlat0.xyz;
					    u_xlat2.xyz = (-vs_TEXCOORD3.xyz) + _WorldSpaceCameraPos.xyz;
					    u_xlat18 = dot(u_xlat2.xyz, u_xlat2.xyz);
					    u_xlat18 = inversesqrt(u_xlat18);
					    u_xlat3.xyz = vec3(u_xlat18) * u_xlat2.xyz;
					    u_xlat1.x = dot(u_xlat3.xyz, u_xlat1.xyz);
					    u_xlati7 = int((0.0<u_xlat1.x) ? 0xFFFFFFFFu : uint(0));
					    u_xlati1 = int((u_xlat1.x<0.0) ? 0xFFFFFFFFu : uint(0));
					    u_xlati1 = (-u_xlati7) + u_xlati1;
					    u_xlat1.x = float(u_xlati1);
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xxx;
					    u_xlat1.xyz = _WorldSpaceLightPos0.www * (-vs_TEXCOORD3.xyz) + _WorldSpaceLightPos0.xyz;
					    u_xlat19 = dot(u_xlat1.xyz, u_xlat1.xyz);
					    u_xlat19 = inversesqrt(u_xlat19);
					    u_xlat1.xyz = vec3(u_xlat19) * u_xlat1.xyz;
					    u_xlat2.xyz = u_xlat2.xyz * vec3(u_xlat18) + u_xlat1.xyz;
					    u_xlat18 = dot(u_xlat2.xyz, u_xlat2.xyz);
					    u_xlat18 = inversesqrt(u_xlat18);
					    u_xlat2.xyz = vec3(u_xlat18) * u_xlat2.xyz;
					    u_xlat0.w = dot(u_xlat0.xyz, u_xlat2.xyz);
					    u_xlat1.w = dot(u_xlat1.xyz, u_xlat2.xyz);
					    u_xlat1.x = dot(u_xlat0.xyz, u_xlat1.xyz);
					    u_xlat0.x = dot(u_xlat0.xyz, u_xlat3.xyz);
					    u_xlat0.yz = max(u_xlat1.xw, vec2(0.0, 0.0));
					    u_xlat0.xw = max(u_xlat0.xw, vec2(0.0, 0.0));
					    u_xlat1.x = log2(u_xlat0.w);
					    u_xlat18 = u_xlat0.w * u_xlat0.w;
					    u_xlat1.x = u_xlat1.x * 9.99999975e-05;
					    u_xlat1.x = exp2(u_xlat1.x);
					    u_xlat7.x = u_xlat0.x * 0.202115417 + 0.797884583;
					    u_xlat13 = u_xlat0.y * 0.202115417 + 0.797884583;
					    u_xlat7.x = u_xlat13 * u_xlat7.x + 9.99999975e-06;
					    u_xlat1.y = float(1.0) / u_xlat7.x;
					    u_xlat1.xy = u_xlat1.xy * vec2(0.318325758, 0.25);
					    u_xlat7.x = u_xlat0.y * u_xlat1.y;
					    u_xlat1.x = u_xlat1.x * u_xlat7.x;
					    u_xlat1.x = u_xlat1.x * 0.616850257;
					    u_xlat2 = texture(_LightTexture0, vs_TEXCOORD7.xy);
					    u_xlat7.xyz = u_xlat2.www * _LightColor0.xyz;
					    u_xlat2.xyz = vec3(u_xlat18) * u_xlat7.xyz;
					    u_xlat2.xyz = u_xlat1.xxx * u_xlat2.xyz;
					    u_xlat2.xyz = u_xlat2.xyz * _LightColor0.xyz;
					    u_xlat0.xw = (-u_xlat0.xz) + vec2(1.00001001, 1.0);
					    u_xlat1.x = u_xlat0.w * u_xlat0.w;
					    u_xlat1.x = u_xlat1.x * u_xlat1.x;
					    u_xlat18 = u_xlat0.w * u_xlat1.x;
					    u_xlat3.xy = vs_TEXCOORD0.xy * _MainTexture_ST.xy + _MainTexture_ST.zw;
					    u_xlat3 = texture(_MainTexture, u_xlat3.xy);
					    u_xlat3.xyz = _Color.xyz * u_xlat3.xyz + vec3(vec3(_Shadows, _Shadows, _Shadows));
					    u_xlat3.xyz = u_xlat3.xyz + vec3(-1.0, -1.0, -1.0);
					    u_xlat3.xyz = clamp(u_xlat3.xyz, 0.0, 1.0);
					    u_xlat4.xyz = u_xlat3.xyz + vec3(-0.220916301, -0.220916301, -0.220916301);
					    u_xlat5.xy = vs_TEXCOORD0.xy * _Specular_ST.xy + _Specular_ST.zw;
					    u_xlat5 = texture(_Specular, u_xlat5.xy);
					    u_xlat1.x = u_xlat5.x * 0.449999988;
					    u_xlat20 = (-u_xlat5.x) * 0.350587666 + 0.779083729;
					    u_xlat3.xyz = vec3(u_xlat20) * u_xlat3.xyz;
					    u_xlat4.xyz = u_xlat1.xxx * u_xlat4.xyz + vec3(0.220916301, 0.220916301, 0.220916301);
					    u_xlat5.xyz = (-u_xlat4.xyz) + vec3(1.0, 1.0, 1.0);
					    u_xlat4.xyz = u_xlat5.xyz * vec3(u_xlat18) + u_xlat4.xyz;
					    u_xlat2.xyz = u_xlat2.xyz * u_xlat4.xyz;
					    u_xlat18 = u_xlat0.x * u_xlat0.x;
					    u_xlat18 = u_xlat18 * u_xlat18;
					    u_xlat0.x = u_xlat18 * u_xlat0.x;
					    u_xlat18 = u_xlat0.z + u_xlat0.z;
					    u_xlat12 = u_xlat18 * u_xlat0.z + -0.5;
					    u_xlat0.x = u_xlat12 * u_xlat0.x + 1.0;
					    u_xlat18 = (-u_xlat0.y) + 1.00001001;
					    u_xlat1.x = u_xlat18 * u_xlat18;
					    u_xlat1.x = u_xlat1.x * u_xlat1.x;
					    u_xlat18 = u_xlat18 * u_xlat1.x;
					    u_xlat12 = u_xlat12 * u_xlat18 + 1.0;
					    u_xlat0.x = u_xlat0.x * u_xlat12;
					    u_xlat0.x = u_xlat0.y * u_xlat0.x;
					    u_xlat0.xyz = u_xlat7.xyz * u_xlat0.xxx;
					    SV_Target0.xyz = u_xlat0.xyz * u_xlat3.xyz + u_xlat2.xyz;
					    SV_Target0.w = 0.0;
					    return;
					}"
				}
				SubProgram "d3d11 " {
					Keywords { "SPOT" "SHADOWS_DEPTH" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "DYNAMICLIGHTMAP_OFF" }
					"ps_4_0
					
					#version 330
					#extension GL_ARB_explicit_attrib_location : require
					#extension GL_ARB_explicit_uniform_location : require
					
					#define HLSLCC_ENABLE_UNIFORM_BUFFERS 1
					#if HLSLCC_ENABLE_UNIFORM_BUFFERS
					#define UNITY_UNIFORM
					#else
					#define UNITY_UNIFORM uniform
					#endif
					#define UNITY_SUPPORTS_UNIFORM_LOCATION 1
					#if UNITY_SUPPORTS_UNIFORM_LOCATION
					#define UNITY_LOCATION(x) layout(location = x)
					#define UNITY_BINDING(x) layout(binding = x, std140)
					#else
					#define UNITY_LOCATION(x)
					#define UNITY_BINDING(x) layout(std140)
					#endif
					layout(std140) uniform PGlobals {
						vec4 unused_0_0[6];
						vec4 _LightColor0;
						vec4 unused_0_2;
						vec4 _MainTexture_ST;
						vec4 _Specular_ST;
						vec4 _NormalMap_ST;
						vec4 _Color;
						vec4 unused_0_7;
						float _NormalSharpness;
						float _Shadows;
					};
					layout(std140) uniform UnityPerCamera {
						vec4 unused_1_0[4];
						vec3 _WorldSpaceCameraPos;
						vec4 unused_1_2[4];
					};
					layout(std140) uniform UnityLighting {
						vec4 _WorldSpaceLightPos0;
						vec4 unused_2_1[47];
					};
					layout(std140) uniform UnityShadows {
						vec4 unused_3_0[24];
						vec4 _LightShadowData;
						vec4 unused_3_2;
					};
					uniform  sampler2D _NormalMap;
					uniform  sampler2D _LightTexture0;
					uniform  sampler2D _LightTextureB0;
					uniform  sampler2D _MainTexture;
					uniform  sampler2D _Specular;
					uniform  sampler2D _ShadowMapTexture;
					uniform  sampler2DShadow hlslcc_zcmp_ShadowMapTexture;
					in  vec2 vs_TEXCOORD0;
					in  vec4 vs_TEXCOORD3;
					in  vec3 vs_TEXCOORD4;
					in  vec3 vs_TEXCOORD5;
					in  vec3 vs_TEXCOORD6;
					in  vec4 vs_TEXCOORD7;
					in  vec4 vs_TEXCOORD8;
					layout(location = 0) out vec4 SV_Target0;
					vec4 u_xlat0;
					vec4 u_xlat1;
					int u_xlati1;
					vec4 u_xlat2;
					vec4 u_xlat3;
					vec3 u_xlat4;
					vec4 u_xlat5;
					vec3 u_xlat7;
					int u_xlati7;
					bool u_xlatb7;
					float u_xlat12;
					float u_xlat13;
					float u_xlat18;
					float u_xlat19;
					float u_xlat20;
					void main()
					{
					    u_xlat0.xy = vs_TEXCOORD0.xy * _NormalMap_ST.xy + _NormalMap_ST.zw;
					    u_xlat0 = texture(_NormalMap, u_xlat0.xy);
					    u_xlat0.x = u_xlat0.w * u_xlat0.x;
					    u_xlat0.xy = u_xlat0.xy * vec2(2.0, 2.0) + vec2(-1.0, -1.0);
					    u_xlat18 = dot(u_xlat0.xy, u_xlat0.xy);
					    u_xlat18 = min(u_xlat18, 1.0);
					    u_xlat18 = (-u_xlat18) + 1.0;
					    u_xlat0.z = sqrt(u_xlat18);
					    u_xlat18 = (-_NormalSharpness) + 1.0;
					    u_xlat0.xyz = u_xlat0.xyz / vec3(u_xlat18);
					    u_xlat0.xyz = clamp(u_xlat0.xyz, 0.0, 1.0);
					    u_xlat1.xyz = u_xlat0.yyy * vs_TEXCOORD6.xyz;
					    u_xlat0.xyw = u_xlat0.xxx * vs_TEXCOORD5.xyz + u_xlat1.xyz;
					    u_xlat1.x = dot(vs_TEXCOORD4.xyz, vs_TEXCOORD4.xyz);
					    u_xlat1.x = inversesqrt(u_xlat1.x);
					    u_xlat1.xyz = u_xlat1.xxx * vs_TEXCOORD4.xyz;
					    u_xlat0.xyz = u_xlat0.zzz * u_xlat1.xyz + u_xlat0.xyw;
					    u_xlat18 = dot(u_xlat0.xyz, u_xlat0.xyz);
					    u_xlat18 = inversesqrt(u_xlat18);
					    u_xlat0.xyz = vec3(u_xlat18) * u_xlat0.xyz;
					    u_xlat2.xyz = (-vs_TEXCOORD3.xyz) + _WorldSpaceCameraPos.xyz;
					    u_xlat18 = dot(u_xlat2.xyz, u_xlat2.xyz);
					    u_xlat18 = inversesqrt(u_xlat18);
					    u_xlat3.xyz = vec3(u_xlat18) * u_xlat2.xyz;
					    u_xlat1.x = dot(u_xlat3.xyz, u_xlat1.xyz);
					    u_xlati7 = int((0.0<u_xlat1.x) ? 0xFFFFFFFFu : uint(0));
					    u_xlati1 = int((u_xlat1.x<0.0) ? 0xFFFFFFFFu : uint(0));
					    u_xlati1 = (-u_xlati7) + u_xlati1;
					    u_xlat1.x = float(u_xlati1);
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xxx;
					    u_xlat1.xyz = _WorldSpaceLightPos0.www * (-vs_TEXCOORD3.xyz) + _WorldSpaceLightPos0.xyz;
					    u_xlat19 = dot(u_xlat1.xyz, u_xlat1.xyz);
					    u_xlat19 = inversesqrt(u_xlat19);
					    u_xlat1.xyz = vec3(u_xlat19) * u_xlat1.xyz;
					    u_xlat2.xyz = u_xlat2.xyz * vec3(u_xlat18) + u_xlat1.xyz;
					    u_xlat18 = dot(u_xlat2.xyz, u_xlat2.xyz);
					    u_xlat18 = inversesqrt(u_xlat18);
					    u_xlat2.xyz = vec3(u_xlat18) * u_xlat2.xyz;
					    u_xlat0.w = dot(u_xlat0.xyz, u_xlat2.xyz);
					    u_xlat1.w = dot(u_xlat1.xyz, u_xlat2.xyz);
					    u_xlat1.x = dot(u_xlat0.xyz, u_xlat1.xyz);
					    u_xlat0.x = dot(u_xlat0.xyz, u_xlat3.xyz);
					    u_xlat0.yz = max(u_xlat1.xw, vec2(0.0, 0.0));
					    u_xlat0.xw = max(u_xlat0.xw, vec2(0.0, 0.0));
					    u_xlat1.x = log2(u_xlat0.w);
					    u_xlat18 = u_xlat0.w * u_xlat0.w;
					    u_xlat1.x = u_xlat1.x * 9.99999975e-05;
					    u_xlat1.x = exp2(u_xlat1.x);
					    u_xlat7.x = u_xlat0.x * 0.202115417 + 0.797884583;
					    u_xlat13 = u_xlat0.y * 0.202115417 + 0.797884583;
					    u_xlat7.x = u_xlat13 * u_xlat7.x + 9.99999975e-06;
					    u_xlat1.y = float(1.0) / u_xlat7.x;
					    u_xlat1.xy = u_xlat1.xy * vec2(0.318325758, 0.25);
					    u_xlat7.x = u_xlat0.y * u_xlat1.y;
					    u_xlat1.x = u_xlat1.x * u_xlat7.x;
					    u_xlat1.x = u_xlat1.x * 0.616850257;
					    u_xlat7.xy = vs_TEXCOORD7.xy / vs_TEXCOORD7.ww;
					    u_xlat7.xy = u_xlat7.xy + vec2(0.5, 0.5);
					    u_xlat2 = texture(_LightTexture0, u_xlat7.xy);
					    u_xlatb7 = 0.0<vs_TEXCOORD7.z;
					    u_xlat7.x = u_xlatb7 ? 1.0 : float(0.0);
					    u_xlat7.x = u_xlat2.w * u_xlat7.x;
					    u_xlat13 = dot(vs_TEXCOORD7.xyz, vs_TEXCOORD7.xyz);
					    u_xlat2 = texture(_LightTextureB0, vec2(u_xlat13));
					    u_xlat7.x = u_xlat7.x * u_xlat2.x;
					    u_xlat2.xyz = vs_TEXCOORD8.xyz / vs_TEXCOORD8.www;
					    vec3 txVec0 = vec3(u_xlat2.xy,u_xlat2.z);
					    u_xlat13 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec0, 0.0);
					    u_xlat19 = (-_LightShadowData.x) + 1.0;
					    u_xlat13 = u_xlat13 * u_xlat19 + _LightShadowData.x;
					    u_xlat7.x = u_xlat13 * u_xlat7.x;
					    u_xlat7.xyz = u_xlat7.xxx * _LightColor0.xyz;
					    u_xlat2.xyz = vec3(u_xlat18) * u_xlat7.xyz;
					    u_xlat2.xyz = u_xlat1.xxx * u_xlat2.xyz;
					    u_xlat2.xyz = u_xlat2.xyz * _LightColor0.xyz;
					    u_xlat0.xw = (-u_xlat0.xz) + vec2(1.00001001, 1.0);
					    u_xlat1.x = u_xlat0.w * u_xlat0.w;
					    u_xlat1.x = u_xlat1.x * u_xlat1.x;
					    u_xlat18 = u_xlat0.w * u_xlat1.x;
					    u_xlat3.xy = vs_TEXCOORD0.xy * _MainTexture_ST.xy + _MainTexture_ST.zw;
					    u_xlat3 = texture(_MainTexture, u_xlat3.xy);
					    u_xlat3.xyz = _Color.xyz * u_xlat3.xyz + vec3(vec3(_Shadows, _Shadows, _Shadows));
					    u_xlat3.xyz = u_xlat3.xyz + vec3(-1.0, -1.0, -1.0);
					    u_xlat3.xyz = clamp(u_xlat3.xyz, 0.0, 1.0);
					    u_xlat4.xyz = u_xlat3.xyz + vec3(-0.220916301, -0.220916301, -0.220916301);
					    u_xlat5.xy = vs_TEXCOORD0.xy * _Specular_ST.xy + _Specular_ST.zw;
					    u_xlat5 = texture(_Specular, u_xlat5.xy);
					    u_xlat1.x = u_xlat5.x * 0.449999988;
					    u_xlat20 = (-u_xlat5.x) * 0.350587666 + 0.779083729;
					    u_xlat3.xyz = vec3(u_xlat20) * u_xlat3.xyz;
					    u_xlat4.xyz = u_xlat1.xxx * u_xlat4.xyz + vec3(0.220916301, 0.220916301, 0.220916301);
					    u_xlat5.xyz = (-u_xlat4.xyz) + vec3(1.0, 1.0, 1.0);
					    u_xlat4.xyz = u_xlat5.xyz * vec3(u_xlat18) + u_xlat4.xyz;
					    u_xlat2.xyz = u_xlat2.xyz * u_xlat4.xyz;
					    u_xlat18 = u_xlat0.x * u_xlat0.x;
					    u_xlat18 = u_xlat18 * u_xlat18;
					    u_xlat0.x = u_xlat18 * u_xlat0.x;
					    u_xlat18 = u_xlat0.z + u_xlat0.z;
					    u_xlat12 = u_xlat18 * u_xlat0.z + -0.5;
					    u_xlat0.x = u_xlat12 * u_xlat0.x + 1.0;
					    u_xlat18 = (-u_xlat0.y) + 1.00001001;
					    u_xlat1.x = u_xlat18 * u_xlat18;
					    u_xlat1.x = u_xlat1.x * u_xlat1.x;
					    u_xlat18 = u_xlat18 * u_xlat1.x;
					    u_xlat12 = u_xlat12 * u_xlat18 + 1.0;
					    u_xlat0.x = u_xlat0.x * u_xlat12;
					    u_xlat0.x = u_xlat0.y * u_xlat0.x;
					    u_xlat0.xyz = u_xlat7.xyz * u_xlat0.xxx;
					    SV_Target0.xyz = u_xlat0.xyz * u_xlat3.xyz + u_xlat2.xyz;
					    SV_Target0.w = 0.0;
					    return;
					}"
				}
				SubProgram "d3d11 " {
					Keywords { "SPOT" "SHADOWS_DEPTH" "SHADOWS_SOFT" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "DYNAMICLIGHTMAP_OFF" }
					"ps_4_0
					
					#version 330
					#extension GL_ARB_explicit_attrib_location : require
					#extension GL_ARB_explicit_uniform_location : require
					
					#define HLSLCC_ENABLE_UNIFORM_BUFFERS 1
					#if HLSLCC_ENABLE_UNIFORM_BUFFERS
					#define UNITY_UNIFORM
					#else
					#define UNITY_UNIFORM uniform
					#endif
					#define UNITY_SUPPORTS_UNIFORM_LOCATION 1
					#if UNITY_SUPPORTS_UNIFORM_LOCATION
					#define UNITY_LOCATION(x) layout(location = x)
					#define UNITY_BINDING(x) layout(binding = x, std140)
					#else
					#define UNITY_LOCATION(x)
					#define UNITY_BINDING(x) layout(std140)
					#endif
					layout(std140) uniform PGlobals {
						vec4 unused_0_0[6];
						vec4 _ShadowMapTexture_TexelSize;
						vec4 unused_0_2[4];
						vec4 _LightColor0;
						vec4 unused_0_4;
						vec4 _MainTexture_ST;
						vec4 _Specular_ST;
						vec4 _NormalMap_ST;
						vec4 _Color;
						vec4 unused_0_9;
						float _NormalSharpness;
						float _Shadows;
					};
					layout(std140) uniform UnityPerCamera {
						vec4 unused_1_0[4];
						vec3 _WorldSpaceCameraPos;
						vec4 unused_1_2[4];
					};
					layout(std140) uniform UnityLighting {
						vec4 _WorldSpaceLightPos0;
						vec4 unused_2_1[47];
					};
					layout(std140) uniform UnityShadows {
						vec4 unused_3_0[24];
						vec4 _LightShadowData;
						vec4 unused_3_2;
					};
					uniform  sampler2D _NormalMap;
					uniform  sampler2D _LightTexture0;
					uniform  sampler2D _LightTextureB0;
					uniform  sampler2D _MainTexture;
					uniform  sampler2D _Specular;
					uniform  sampler2D _ShadowMapTexture;
					uniform  sampler2DShadow hlslcc_zcmp_ShadowMapTexture;
					in  vec2 vs_TEXCOORD0;
					in  vec4 vs_TEXCOORD3;
					in  vec3 vs_TEXCOORD4;
					in  vec3 vs_TEXCOORD5;
					in  vec3 vs_TEXCOORD6;
					in  vec4 vs_TEXCOORD7;
					in  vec4 vs_TEXCOORD8;
					layout(location = 0) out vec4 SV_Target0;
					vec3 u_xlat0;
					vec4 u_xlat1;
					vec4 u_xlat2;
					int u_xlati2;
					vec4 u_xlat3;
					vec4 u_xlat4;
					vec4 u_xlat5;
					vec2 u_xlat6;
					bool u_xlatb6;
					float u_xlat7;
					float u_xlat12;
					vec2 u_xlat13;
					float u_xlat18;
					float u_xlat19;
					int u_xlati19;
					float u_xlat20;
					void main()
					{
					    u_xlat0.xyz = vs_TEXCOORD8.xyz / vs_TEXCOORD8.www;
					    u_xlat1.xy = u_xlat0.xy * _ShadowMapTexture_TexelSize.zw + vec2(0.5, 0.5);
					    u_xlat1.xy = floor(u_xlat1.xy);
					    u_xlat0.xy = u_xlat0.xy * _ShadowMapTexture_TexelSize.zw + (-u_xlat1.xy);
					    u_xlat13.xy = (-u_xlat0.xy) + vec2(1.0, 1.0);
					    u_xlat2.xy = min(u_xlat0.xy, vec2(0.0, 0.0));
					    u_xlat2.xy = (-u_xlat2.xy) * u_xlat2.xy + u_xlat13.xy;
					    u_xlat3.y = u_xlat2.x;
					    u_xlat13.xy = max(u_xlat0.xy, vec2(0.0, 0.0));
					    u_xlat4 = u_xlat0.xxyy + vec4(0.5, 1.0, 0.5, 1.0);
					    u_xlat2.xz = (-u_xlat13.xy) * u_xlat13.xy + u_xlat4.yw;
					    u_xlat13.xy = u_xlat4.xz * u_xlat4.xz;
					    u_xlat3.z = u_xlat2.x;
					    u_xlat0.xy = u_xlat13.xy * vec2(0.5, 0.5) + (-u_xlat0.xy);
					    u_xlat3.x = u_xlat0.x;
					    u_xlat2.x = u_xlat0.y;
					    u_xlat3.w = u_xlat13.x;
					    u_xlat2.w = u_xlat13.y;
					    u_xlat2 = u_xlat2 * vec4(0.444440007, 0.444440007, 0.444440007, 0.222220004);
					    u_xlat3 = u_xlat3 * vec4(0.444440007, 0.444440007, 0.444440007, 0.222220004);
					    u_xlat4 = u_xlat3.ywyw + u_xlat3.xzxz;
					    u_xlat0.xy = u_xlat3.yw / u_xlat4.zw;
					    u_xlat0.xy = u_xlat0.xy + vec2(-1.5, 0.5);
					    u_xlat3.xy = u_xlat0.xy * _ShadowMapTexture_TexelSize.xx;
					    u_xlat5 = u_xlat2.yyww + u_xlat2.xxzz;
					    u_xlat0.xy = u_xlat2.yw / u_xlat5.yw;
					    u_xlat2 = u_xlat4 * u_xlat5;
					    u_xlat0.xy = u_xlat0.xy + vec2(-1.5, 0.5);
					    u_xlat3.zw = u_xlat0.xy * _ShadowMapTexture_TexelSize.yy;
					    u_xlat4 = u_xlat1.xyxy * _ShadowMapTexture_TexelSize.xyxy + u_xlat3.xzyz;
					    u_xlat1 = u_xlat1.xyxy * _ShadowMapTexture_TexelSize.xyxy + u_xlat3.xwyw;
					    vec3 txVec0 = vec3(u_xlat4.xy,u_xlat0.z);
					    u_xlat0.x = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec0, 0.0);
					    vec3 txVec1 = vec3(u_xlat4.zw,u_xlat0.z);
					    u_xlat6.x = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec1, 0.0);
					    u_xlat6.x = u_xlat6.x * u_xlat2.y;
					    u_xlat0.x = u_xlat2.x * u_xlat0.x + u_xlat6.x;
					    vec3 txVec2 = vec3(u_xlat1.xy,u_xlat0.z);
					    u_xlat6.x = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec2, 0.0);
					    vec3 txVec3 = vec3(u_xlat1.zw,u_xlat0.z);
					    u_xlat12 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec3, 0.0);
					    u_xlat0.x = u_xlat2.z * u_xlat6.x + u_xlat0.x;
					    u_xlat0.x = u_xlat2.w * u_xlat12 + u_xlat0.x;
					    u_xlat6.x = (-_LightShadowData.x) + 1.0;
					    u_xlat0.x = u_xlat0.x * u_xlat6.x + _LightShadowData.x;
					    u_xlat6.xy = vs_TEXCOORD7.xy / vs_TEXCOORD7.ww;
					    u_xlat6.xy = u_xlat6.xy + vec2(0.5, 0.5);
					    u_xlat1 = texture(_LightTexture0, u_xlat6.xy);
					    u_xlatb6 = 0.0<vs_TEXCOORD7.z;
					    u_xlat6.x = u_xlatb6 ? 1.0 : float(0.0);
					    u_xlat6.x = u_xlat1.w * u_xlat6.x;
					    u_xlat12 = dot(vs_TEXCOORD7.xyz, vs_TEXCOORD7.xyz);
					    u_xlat1 = texture(_LightTextureB0, vec2(u_xlat12));
					    u_xlat6.x = u_xlat6.x * u_xlat1.x;
					    u_xlat0.x = u_xlat0.x * u_xlat6.x;
					    u_xlat0.xyz = u_xlat0.xxx * _LightColor0.xyz;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _NormalMap_ST.xy + _NormalMap_ST.zw;
					    u_xlat1 = texture(_NormalMap, u_xlat1.xy);
					    u_xlat1.x = u_xlat1.w * u_xlat1.x;
					    u_xlat1.xy = u_xlat1.xy * vec2(2.0, 2.0) + vec2(-1.0, -1.0);
					    u_xlat18 = dot(u_xlat1.xy, u_xlat1.xy);
					    u_xlat18 = min(u_xlat18, 1.0);
					    u_xlat18 = (-u_xlat18) + 1.0;
					    u_xlat1.z = sqrt(u_xlat18);
					    u_xlat18 = (-_NormalSharpness) + 1.0;
					    u_xlat1.xyz = u_xlat1.xyz / vec3(u_xlat18);
					    u_xlat1.xyz = clamp(u_xlat1.xyz, 0.0, 1.0);
					    u_xlat2.xyz = u_xlat1.yyy * vs_TEXCOORD6.xyz;
					    u_xlat1.xyw = u_xlat1.xxx * vs_TEXCOORD5.xyz + u_xlat2.xyz;
					    u_xlat18 = dot(vs_TEXCOORD4.xyz, vs_TEXCOORD4.xyz);
					    u_xlat18 = inversesqrt(u_xlat18);
					    u_xlat2.xyz = vec3(u_xlat18) * vs_TEXCOORD4.xyz;
					    u_xlat1.xyz = u_xlat1.zzz * u_xlat2.xyz + u_xlat1.xyw;
					    u_xlat18 = dot(u_xlat1.xyz, u_xlat1.xyz);
					    u_xlat18 = inversesqrt(u_xlat18);
					    u_xlat1.xyz = vec3(u_xlat18) * u_xlat1.xyz;
					    u_xlat3.xyz = (-vs_TEXCOORD3.xyz) + _WorldSpaceCameraPos.xyz;
					    u_xlat18 = dot(u_xlat3.xyz, u_xlat3.xyz);
					    u_xlat18 = inversesqrt(u_xlat18);
					    u_xlat4.xyz = vec3(u_xlat18) * u_xlat3.xyz;
					    u_xlat19 = dot(u_xlat4.xyz, u_xlat2.xyz);
					    u_xlati2 = int((0.0<u_xlat19) ? 0xFFFFFFFFu : uint(0));
					    u_xlati19 = int((u_xlat19<0.0) ? 0xFFFFFFFFu : uint(0));
					    u_xlati19 = (-u_xlati2) + u_xlati19;
					    u_xlat19 = float(u_xlati19);
					    u_xlat1.xyz = vec3(u_xlat19) * u_xlat1.xyz;
					    u_xlat2.xyz = _WorldSpaceLightPos0.www * (-vs_TEXCOORD3.xyz) + _WorldSpaceLightPos0.xyz;
					    u_xlat19 = dot(u_xlat2.xyz, u_xlat2.xyz);
					    u_xlat19 = inversesqrt(u_xlat19);
					    u_xlat2.xyz = vec3(u_xlat19) * u_xlat2.xyz;
					    u_xlat3.xyz = u_xlat3.xyz * vec3(u_xlat18) + u_xlat2.xyz;
					    u_xlat18 = dot(u_xlat3.xyz, u_xlat3.xyz);
					    u_xlat18 = inversesqrt(u_xlat18);
					    u_xlat3.xyz = vec3(u_xlat18) * u_xlat3.xyz;
					    u_xlat18 = dot(u_xlat1.xyz, u_xlat3.xyz);
					    u_xlat1.w = dot(u_xlat2.xyz, u_xlat3.xyz);
					    u_xlat2.x = dot(u_xlat1.xyz, u_xlat2.xyz);
					    u_xlat1.x = dot(u_xlat1.xyz, u_xlat4.xyz);
					    u_xlat7 = max(u_xlat2.x, 0.0);
					    u_xlat1.xz = max(u_xlat1.xw, vec2(0.0, 0.0));
					    u_xlat18 = max(u_xlat18, 0.0);
					    u_xlat19 = u_xlat18 * u_xlat18;
					    u_xlat18 = log2(u_xlat18);
					    u_xlat18 = u_xlat18 * 9.99999975e-05;
					    u_xlat18 = exp2(u_xlat18);
					    u_xlat18 = u_xlat18 * 0.318325758;
					    u_xlat2.xyz = u_xlat0.xyz * vec3(u_xlat19);
					    u_xlat19 = u_xlat1.x * 0.202115417 + 0.797884583;
					    u_xlat1.x = (-u_xlat1.x) + 1.00001001;
					    u_xlat20 = u_xlat7 * 0.202115417 + 0.797884583;
					    u_xlat19 = u_xlat20 * u_xlat19 + 9.99999975e-06;
					    u_xlat19 = float(1.0) / u_xlat19;
					    u_xlat19 = u_xlat19 * 0.25;
					    u_xlat19 = u_xlat19 * u_xlat7;
					    u_xlat18 = u_xlat18 * u_xlat19;
					    u_xlat18 = u_xlat18 * 0.616850257;
					    u_xlat2.xyz = vec3(u_xlat18) * u_xlat2.xyz;
					    u_xlat2.xyz = u_xlat2.xyz * _LightColor0.xyz;
					    u_xlat18 = (-u_xlat1.z) + 1.0;
					    u_xlat19 = u_xlat18 * u_xlat18;
					    u_xlat19 = u_xlat19 * u_xlat19;
					    u_xlat18 = u_xlat18 * u_xlat19;
					    u_xlat3.xy = vs_TEXCOORD0.xy * _MainTexture_ST.xy + _MainTexture_ST.zw;
					    u_xlat3 = texture(_MainTexture, u_xlat3.xy);
					    u_xlat3.xyz = _Color.xyz * u_xlat3.xyz + vec3(vec3(_Shadows, _Shadows, _Shadows));
					    u_xlat3.xyz = u_xlat3.xyz + vec3(-1.0, -1.0, -1.0);
					    u_xlat3.xyz = clamp(u_xlat3.xyz, 0.0, 1.0);
					    u_xlat4.xyz = u_xlat3.xyz + vec3(-0.220916301, -0.220916301, -0.220916301);
					    u_xlat5.xy = vs_TEXCOORD0.xy * _Specular_ST.xy + _Specular_ST.zw;
					    u_xlat5 = texture(_Specular, u_xlat5.xy);
					    u_xlat19 = u_xlat5.x * 0.449999988;
					    u_xlat20 = (-u_xlat5.x) * 0.350587666 + 0.779083729;
					    u_xlat3.xyz = vec3(u_xlat20) * u_xlat3.xyz;
					    u_xlat4.xyz = vec3(u_xlat19) * u_xlat4.xyz + vec3(0.220916301, 0.220916301, 0.220916301);
					    u_xlat5.xyz = (-u_xlat4.xyz) + vec3(1.0, 1.0, 1.0);
					    u_xlat4.xyz = u_xlat5.xyz * vec3(u_xlat18) + u_xlat4.xyz;
					    u_xlat2.xyz = u_xlat2.xyz * u_xlat4.xyz;
					    u_xlat18 = u_xlat1.x * u_xlat1.x;
					    u_xlat18 = u_xlat18 * u_xlat18;
					    u_xlat18 = u_xlat18 * u_xlat1.x;
					    u_xlat1.x = u_xlat1.z + u_xlat1.z;
					    u_xlat1.x = u_xlat1.x * u_xlat1.z + -0.5;
					    u_xlat18 = u_xlat1.x * u_xlat18 + 1.0;
					    u_xlat13.x = (-u_xlat7) + 1.00001001;
					    u_xlat19 = u_xlat13.x * u_xlat13.x;
					    u_xlat19 = u_xlat19 * u_xlat19;
					    u_xlat13.x = u_xlat19 * u_xlat13.x;
					    u_xlat1.x = u_xlat1.x * u_xlat13.x + 1.0;
					    u_xlat18 = u_xlat18 * u_xlat1.x;
					    u_xlat18 = u_xlat7 * u_xlat18;
					    u_xlat0.xyz = u_xlat0.xyz * vec3(u_xlat18);
					    SV_Target0.xyz = u_xlat0.xyz * u_xlat3.xyz + u_xlat2.xyz;
					    SV_Target0.w = 0.0;
					    return;
					}"
				}
				SubProgram "d3d11 " {
					Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "DYNAMICLIGHTMAP_OFF" }
					"ps_4_0
					
					#version 330
					#extension GL_ARB_explicit_attrib_location : require
					#extension GL_ARB_explicit_uniform_location : require
					
					#define HLSLCC_ENABLE_UNIFORM_BUFFERS 1
					#if HLSLCC_ENABLE_UNIFORM_BUFFERS
					#define UNITY_UNIFORM
					#else
					#define UNITY_UNIFORM uniform
					#endif
					#define UNITY_SUPPORTS_UNIFORM_LOCATION 1
					#if UNITY_SUPPORTS_UNIFORM_LOCATION
					#define UNITY_LOCATION(x) layout(location = x)
					#define UNITY_BINDING(x) layout(binding = x, std140)
					#else
					#define UNITY_LOCATION(x)
					#define UNITY_BINDING(x) layout(std140)
					#endif
					layout(std140) uniform PGlobals {
						vec4 unused_0_0[2];
						vec4 _LightColor0;
						vec4 unused_0_2;
						vec4 _MainTexture_ST;
						vec4 _Specular_ST;
						vec4 _NormalMap_ST;
						vec4 _Color;
						vec4 unused_0_7;
						float _NormalSharpness;
						float _Shadows;
					};
					layout(std140) uniform UnityPerCamera {
						vec4 unused_1_0[4];
						vec3 _WorldSpaceCameraPos;
						vec4 unused_1_2[4];
					};
					layout(std140) uniform UnityLighting {
						vec4 _WorldSpaceLightPos0;
						vec4 unused_2_1[47];
					};
					uniform  sampler2D _NormalMap;
					uniform  sampler2D _ShadowMapTexture;
					uniform  sampler2D _MainTexture;
					uniform  sampler2D _Specular;
					in  vec2 vs_TEXCOORD0;
					in  vec4 vs_TEXCOORD3;
					in  vec3 vs_TEXCOORD4;
					in  vec3 vs_TEXCOORD5;
					in  vec3 vs_TEXCOORD6;
					in  vec4 vs_TEXCOORD8;
					layout(location = 0) out vec4 SV_Target0;
					vec4 u_xlat0;
					vec4 u_xlat1;
					int u_xlati1;
					vec4 u_xlat2;
					vec4 u_xlat3;
					vec3 u_xlat4;
					vec4 u_xlat5;
					vec3 u_xlat7;
					int u_xlati7;
					float u_xlat12;
					float u_xlat13;
					float u_xlat18;
					float u_xlat19;
					float u_xlat20;
					void main()
					{
					    u_xlat0.xy = vs_TEXCOORD0.xy * _NormalMap_ST.xy + _NormalMap_ST.zw;
					    u_xlat0 = texture(_NormalMap, u_xlat0.xy);
					    u_xlat0.x = u_xlat0.w * u_xlat0.x;
					    u_xlat0.xy = u_xlat0.xy * vec2(2.0, 2.0) + vec2(-1.0, -1.0);
					    u_xlat18 = dot(u_xlat0.xy, u_xlat0.xy);
					    u_xlat18 = min(u_xlat18, 1.0);
					    u_xlat18 = (-u_xlat18) + 1.0;
					    u_xlat0.z = sqrt(u_xlat18);
					    u_xlat18 = (-_NormalSharpness) + 1.0;
					    u_xlat0.xyz = u_xlat0.xyz / vec3(u_xlat18);
					    u_xlat0.xyz = clamp(u_xlat0.xyz, 0.0, 1.0);
					    u_xlat1.xyz = u_xlat0.yyy * vs_TEXCOORD6.xyz;
					    u_xlat0.xyw = u_xlat0.xxx * vs_TEXCOORD5.xyz + u_xlat1.xyz;
					    u_xlat1.x = dot(vs_TEXCOORD4.xyz, vs_TEXCOORD4.xyz);
					    u_xlat1.x = inversesqrt(u_xlat1.x);
					    u_xlat1.xyz = u_xlat1.xxx * vs_TEXCOORD4.xyz;
					    u_xlat0.xyz = u_xlat0.zzz * u_xlat1.xyz + u_xlat0.xyw;
					    u_xlat18 = dot(u_xlat0.xyz, u_xlat0.xyz);
					    u_xlat18 = inversesqrt(u_xlat18);
					    u_xlat0.xyz = vec3(u_xlat18) * u_xlat0.xyz;
					    u_xlat2.xyz = (-vs_TEXCOORD3.xyz) + _WorldSpaceCameraPos.xyz;
					    u_xlat18 = dot(u_xlat2.xyz, u_xlat2.xyz);
					    u_xlat18 = inversesqrt(u_xlat18);
					    u_xlat3.xyz = vec3(u_xlat18) * u_xlat2.xyz;
					    u_xlat1.x = dot(u_xlat3.xyz, u_xlat1.xyz);
					    u_xlati7 = int((0.0<u_xlat1.x) ? 0xFFFFFFFFu : uint(0));
					    u_xlati1 = int((u_xlat1.x<0.0) ? 0xFFFFFFFFu : uint(0));
					    u_xlati1 = (-u_xlati7) + u_xlati1;
					    u_xlat1.x = float(u_xlati1);
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xxx;
					    u_xlat1.xyz = _WorldSpaceLightPos0.www * (-vs_TEXCOORD3.xyz) + _WorldSpaceLightPos0.xyz;
					    u_xlat19 = dot(u_xlat1.xyz, u_xlat1.xyz);
					    u_xlat19 = inversesqrt(u_xlat19);
					    u_xlat1.xyz = vec3(u_xlat19) * u_xlat1.xyz;
					    u_xlat2.xyz = u_xlat2.xyz * vec3(u_xlat18) + u_xlat1.xyz;
					    u_xlat18 = dot(u_xlat2.xyz, u_xlat2.xyz);
					    u_xlat18 = inversesqrt(u_xlat18);
					    u_xlat2.xyz = vec3(u_xlat18) * u_xlat2.xyz;
					    u_xlat0.w = dot(u_xlat0.xyz, u_xlat2.xyz);
					    u_xlat1.w = dot(u_xlat1.xyz, u_xlat2.xyz);
					    u_xlat1.x = dot(u_xlat0.xyz, u_xlat1.xyz);
					    u_xlat0.x = dot(u_xlat0.xyz, u_xlat3.xyz);
					    u_xlat0.yz = max(u_xlat1.xw, vec2(0.0, 0.0));
					    u_xlat0.xw = max(u_xlat0.xw, vec2(0.0, 0.0));
					    u_xlat1.x = log2(u_xlat0.w);
					    u_xlat18 = u_xlat0.w * u_xlat0.w;
					    u_xlat1.x = u_xlat1.x * 9.99999975e-05;
					    u_xlat1.x = exp2(u_xlat1.x);
					    u_xlat7.x = u_xlat0.x * 0.202115417 + 0.797884583;
					    u_xlat13 = u_xlat0.y * 0.202115417 + 0.797884583;
					    u_xlat7.x = u_xlat13 * u_xlat7.x + 9.99999975e-06;
					    u_xlat1.y = float(1.0) / u_xlat7.x;
					    u_xlat1.xy = u_xlat1.xy * vec2(0.318325758, 0.25);
					    u_xlat7.x = u_xlat0.y * u_xlat1.y;
					    u_xlat1.x = u_xlat1.x * u_xlat7.x;
					    u_xlat1.x = u_xlat1.x * 0.616850257;
					    u_xlat7.xy = vs_TEXCOORD8.xy / vs_TEXCOORD8.ww;
					    u_xlat2 = texture(_ShadowMapTexture, u_xlat7.xy);
					    u_xlat7.xyz = u_xlat2.xxx * _LightColor0.xyz;
					    u_xlat2.xyz = vec3(u_xlat18) * u_xlat7.xyz;
					    u_xlat2.xyz = u_xlat1.xxx * u_xlat2.xyz;
					    u_xlat2.xyz = u_xlat2.xyz * _LightColor0.xyz;
					    u_xlat0.xw = (-u_xlat0.xz) + vec2(1.00001001, 1.0);
					    u_xlat1.x = u_xlat0.w * u_xlat0.w;
					    u_xlat1.x = u_xlat1.x * u_xlat1.x;
					    u_xlat18 = u_xlat0.w * u_xlat1.x;
					    u_xlat3.xy = vs_TEXCOORD0.xy * _MainTexture_ST.xy + _MainTexture_ST.zw;
					    u_xlat3 = texture(_MainTexture, u_xlat3.xy);
					    u_xlat3.xyz = _Color.xyz * u_xlat3.xyz + vec3(vec3(_Shadows, _Shadows, _Shadows));
					    u_xlat3.xyz = u_xlat3.xyz + vec3(-1.0, -1.0, -1.0);
					    u_xlat3.xyz = clamp(u_xlat3.xyz, 0.0, 1.0);
					    u_xlat4.xyz = u_xlat3.xyz + vec3(-0.220916301, -0.220916301, -0.220916301);
					    u_xlat5.xy = vs_TEXCOORD0.xy * _Specular_ST.xy + _Specular_ST.zw;
					    u_xlat5 = texture(_Specular, u_xlat5.xy);
					    u_xlat1.x = u_xlat5.x * 0.449999988;
					    u_xlat20 = (-u_xlat5.x) * 0.350587666 + 0.779083729;
					    u_xlat3.xyz = vec3(u_xlat20) * u_xlat3.xyz;
					    u_xlat4.xyz = u_xlat1.xxx * u_xlat4.xyz + vec3(0.220916301, 0.220916301, 0.220916301);
					    u_xlat5.xyz = (-u_xlat4.xyz) + vec3(1.0, 1.0, 1.0);
					    u_xlat4.xyz = u_xlat5.xyz * vec3(u_xlat18) + u_xlat4.xyz;
					    u_xlat2.xyz = u_xlat2.xyz * u_xlat4.xyz;
					    u_xlat18 = u_xlat0.x * u_xlat0.x;
					    u_xlat18 = u_xlat18 * u_xlat18;
					    u_xlat0.x = u_xlat18 * u_xlat0.x;
					    u_xlat18 = u_xlat0.z + u_xlat0.z;
					    u_xlat12 = u_xlat18 * u_xlat0.z + -0.5;
					    u_xlat0.x = u_xlat12 * u_xlat0.x + 1.0;
					    u_xlat18 = (-u_xlat0.y) + 1.00001001;
					    u_xlat1.x = u_xlat18 * u_xlat18;
					    u_xlat1.x = u_xlat1.x * u_xlat1.x;
					    u_xlat18 = u_xlat18 * u_xlat1.x;
					    u_xlat12 = u_xlat12 * u_xlat18 + 1.0;
					    u_xlat0.x = u_xlat0.x * u_xlat12;
					    u_xlat0.x = u_xlat0.y * u_xlat0.x;
					    u_xlat0.xyz = u_xlat7.xyz * u_xlat0.xxx;
					    SV_Target0.xyz = u_xlat0.xyz * u_xlat3.xyz + u_xlat2.xyz;
					    SV_Target0.w = 0.0;
					    return;
					}"
				}
				SubProgram "d3d11 " {
					Keywords { "DIRECTIONAL_COOKIE" "SHADOWS_SCREEN" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "DYNAMICLIGHTMAP_OFF" }
					"ps_4_0
					
					#version 330
					#extension GL_ARB_explicit_attrib_location : require
					#extension GL_ARB_explicit_uniform_location : require
					
					#define HLSLCC_ENABLE_UNIFORM_BUFFERS 1
					#if HLSLCC_ENABLE_UNIFORM_BUFFERS
					#define UNITY_UNIFORM
					#else
					#define UNITY_UNIFORM uniform
					#endif
					#define UNITY_SUPPORTS_UNIFORM_LOCATION 1
					#if UNITY_SUPPORTS_UNIFORM_LOCATION
					#define UNITY_LOCATION(x) layout(location = x)
					#define UNITY_BINDING(x) layout(binding = x, std140)
					#else
					#define UNITY_LOCATION(x)
					#define UNITY_BINDING(x) layout(std140)
					#endif
					layout(std140) uniform PGlobals {
						vec4 unused_0_0[6];
						vec4 _LightColor0;
						vec4 unused_0_2;
						vec4 _MainTexture_ST;
						vec4 _Specular_ST;
						vec4 _NormalMap_ST;
						vec4 _Color;
						vec4 unused_0_7;
						float _NormalSharpness;
						float _Shadows;
					};
					layout(std140) uniform UnityPerCamera {
						vec4 unused_1_0[4];
						vec3 _WorldSpaceCameraPos;
						vec4 unused_1_2[4];
					};
					layout(std140) uniform UnityLighting {
						vec4 _WorldSpaceLightPos0;
						vec4 unused_2_1[47];
					};
					uniform  sampler2D _NormalMap;
					uniform  sampler2D _LightTexture0;
					uniform  sampler2D _ShadowMapTexture;
					uniform  sampler2D _MainTexture;
					uniform  sampler2D _Specular;
					in  vec2 vs_TEXCOORD0;
					in  vec2 vs_TEXCOORD7;
					in  vec4 vs_TEXCOORD3;
					in  vec3 vs_TEXCOORD4;
					in  vec3 vs_TEXCOORD5;
					in  vec3 vs_TEXCOORD6;
					in  vec4 vs_TEXCOORD8;
					layout(location = 0) out vec4 SV_Target0;
					vec4 u_xlat0;
					vec4 u_xlat1;
					int u_xlati1;
					vec4 u_xlat2;
					vec4 u_xlat3;
					vec3 u_xlat4;
					vec4 u_xlat5;
					vec3 u_xlat7;
					int u_xlati7;
					float u_xlat12;
					float u_xlat13;
					float u_xlat18;
					float u_xlat19;
					float u_xlat20;
					void main()
					{
					    u_xlat0.xy = vs_TEXCOORD0.xy * _NormalMap_ST.xy + _NormalMap_ST.zw;
					    u_xlat0 = texture(_NormalMap, u_xlat0.xy);
					    u_xlat0.x = u_xlat0.w * u_xlat0.x;
					    u_xlat0.xy = u_xlat0.xy * vec2(2.0, 2.0) + vec2(-1.0, -1.0);
					    u_xlat18 = dot(u_xlat0.xy, u_xlat0.xy);
					    u_xlat18 = min(u_xlat18, 1.0);
					    u_xlat18 = (-u_xlat18) + 1.0;
					    u_xlat0.z = sqrt(u_xlat18);
					    u_xlat18 = (-_NormalSharpness) + 1.0;
					    u_xlat0.xyz = u_xlat0.xyz / vec3(u_xlat18);
					    u_xlat0.xyz = clamp(u_xlat0.xyz, 0.0, 1.0);
					    u_xlat1.xyz = u_xlat0.yyy * vs_TEXCOORD6.xyz;
					    u_xlat0.xyw = u_xlat0.xxx * vs_TEXCOORD5.xyz + u_xlat1.xyz;
					    u_xlat1.x = dot(vs_TEXCOORD4.xyz, vs_TEXCOORD4.xyz);
					    u_xlat1.x = inversesqrt(u_xlat1.x);
					    u_xlat1.xyz = u_xlat1.xxx * vs_TEXCOORD4.xyz;
					    u_xlat0.xyz = u_xlat0.zzz * u_xlat1.xyz + u_xlat0.xyw;
					    u_xlat18 = dot(u_xlat0.xyz, u_xlat0.xyz);
					    u_xlat18 = inversesqrt(u_xlat18);
					    u_xlat0.xyz = vec3(u_xlat18) * u_xlat0.xyz;
					    u_xlat2.xyz = (-vs_TEXCOORD3.xyz) + _WorldSpaceCameraPos.xyz;
					    u_xlat18 = dot(u_xlat2.xyz, u_xlat2.xyz);
					    u_xlat18 = inversesqrt(u_xlat18);
					    u_xlat3.xyz = vec3(u_xlat18) * u_xlat2.xyz;
					    u_xlat1.x = dot(u_xlat3.xyz, u_xlat1.xyz);
					    u_xlati7 = int((0.0<u_xlat1.x) ? 0xFFFFFFFFu : uint(0));
					    u_xlati1 = int((u_xlat1.x<0.0) ? 0xFFFFFFFFu : uint(0));
					    u_xlati1 = (-u_xlati7) + u_xlati1;
					    u_xlat1.x = float(u_xlati1);
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xxx;
					    u_xlat1.xyz = _WorldSpaceLightPos0.www * (-vs_TEXCOORD3.xyz) + _WorldSpaceLightPos0.xyz;
					    u_xlat19 = dot(u_xlat1.xyz, u_xlat1.xyz);
					    u_xlat19 = inversesqrt(u_xlat19);
					    u_xlat1.xyz = vec3(u_xlat19) * u_xlat1.xyz;
					    u_xlat2.xyz = u_xlat2.xyz * vec3(u_xlat18) + u_xlat1.xyz;
					    u_xlat18 = dot(u_xlat2.xyz, u_xlat2.xyz);
					    u_xlat18 = inversesqrt(u_xlat18);
					    u_xlat2.xyz = vec3(u_xlat18) * u_xlat2.xyz;
					    u_xlat0.w = dot(u_xlat0.xyz, u_xlat2.xyz);
					    u_xlat1.w = dot(u_xlat1.xyz, u_xlat2.xyz);
					    u_xlat1.x = dot(u_xlat0.xyz, u_xlat1.xyz);
					    u_xlat0.x = dot(u_xlat0.xyz, u_xlat3.xyz);
					    u_xlat0.yz = max(u_xlat1.xw, vec2(0.0, 0.0));
					    u_xlat0.xw = max(u_xlat0.xw, vec2(0.0, 0.0));
					    u_xlat1.x = log2(u_xlat0.w);
					    u_xlat18 = u_xlat0.w * u_xlat0.w;
					    u_xlat1.x = u_xlat1.x * 9.99999975e-05;
					    u_xlat1.x = exp2(u_xlat1.x);
					    u_xlat7.x = u_xlat0.x * 0.202115417 + 0.797884583;
					    u_xlat13 = u_xlat0.y * 0.202115417 + 0.797884583;
					    u_xlat7.x = u_xlat13 * u_xlat7.x + 9.99999975e-06;
					    u_xlat1.y = float(1.0) / u_xlat7.x;
					    u_xlat1.xy = u_xlat1.xy * vec2(0.318325758, 0.25);
					    u_xlat7.x = u_xlat0.y * u_xlat1.y;
					    u_xlat1.x = u_xlat1.x * u_xlat7.x;
					    u_xlat1.x = u_xlat1.x * 0.616850257;
					    u_xlat7.xy = vs_TEXCOORD8.xy / vs_TEXCOORD8.ww;
					    u_xlat2 = texture(_ShadowMapTexture, u_xlat7.xy);
					    u_xlat3 = texture(_LightTexture0, vs_TEXCOORD7.xy);
					    u_xlat7.x = u_xlat2.x * u_xlat3.w;
					    u_xlat7.xyz = u_xlat7.xxx * _LightColor0.xyz;
					    u_xlat2.xyz = vec3(u_xlat18) * u_xlat7.xyz;
					    u_xlat2.xyz = u_xlat1.xxx * u_xlat2.xyz;
					    u_xlat2.xyz = u_xlat2.xyz * _LightColor0.xyz;
					    u_xlat0.xw = (-u_xlat0.xz) + vec2(1.00001001, 1.0);
					    u_xlat1.x = u_xlat0.w * u_xlat0.w;
					    u_xlat1.x = u_xlat1.x * u_xlat1.x;
					    u_xlat18 = u_xlat0.w * u_xlat1.x;
					    u_xlat3.xy = vs_TEXCOORD0.xy * _MainTexture_ST.xy + _MainTexture_ST.zw;
					    u_xlat3 = texture(_MainTexture, u_xlat3.xy);
					    u_xlat3.xyz = _Color.xyz * u_xlat3.xyz + vec3(vec3(_Shadows, _Shadows, _Shadows));
					    u_xlat3.xyz = u_xlat3.xyz + vec3(-1.0, -1.0, -1.0);
					    u_xlat3.xyz = clamp(u_xlat3.xyz, 0.0, 1.0);
					    u_xlat4.xyz = u_xlat3.xyz + vec3(-0.220916301, -0.220916301, -0.220916301);
					    u_xlat5.xy = vs_TEXCOORD0.xy * _Specular_ST.xy + _Specular_ST.zw;
					    u_xlat5 = texture(_Specular, u_xlat5.xy);
					    u_xlat1.x = u_xlat5.x * 0.449999988;
					    u_xlat20 = (-u_xlat5.x) * 0.350587666 + 0.779083729;
					    u_xlat3.xyz = vec3(u_xlat20) * u_xlat3.xyz;
					    u_xlat4.xyz = u_xlat1.xxx * u_xlat4.xyz + vec3(0.220916301, 0.220916301, 0.220916301);
					    u_xlat5.xyz = (-u_xlat4.xyz) + vec3(1.0, 1.0, 1.0);
					    u_xlat4.xyz = u_xlat5.xyz * vec3(u_xlat18) + u_xlat4.xyz;
					    u_xlat2.xyz = u_xlat2.xyz * u_xlat4.xyz;
					    u_xlat18 = u_xlat0.x * u_xlat0.x;
					    u_xlat18 = u_xlat18 * u_xlat18;
					    u_xlat0.x = u_xlat18 * u_xlat0.x;
					    u_xlat18 = u_xlat0.z + u_xlat0.z;
					    u_xlat12 = u_xlat18 * u_xlat0.z + -0.5;
					    u_xlat0.x = u_xlat12 * u_xlat0.x + 1.0;
					    u_xlat18 = (-u_xlat0.y) + 1.00001001;
					    u_xlat1.x = u_xlat18 * u_xlat18;
					    u_xlat1.x = u_xlat1.x * u_xlat1.x;
					    u_xlat18 = u_xlat18 * u_xlat1.x;
					    u_xlat12 = u_xlat12 * u_xlat18 + 1.0;
					    u_xlat0.x = u_xlat0.x * u_xlat12;
					    u_xlat0.x = u_xlat0.y * u_xlat0.x;
					    u_xlat0.xyz = u_xlat7.xyz * u_xlat0.xxx;
					    SV_Target0.xyz = u_xlat0.xyz * u_xlat3.xyz + u_xlat2.xyz;
					    SV_Target0.w = 0.0;
					    return;
					}"
				}
				SubProgram "d3d11 " {
					Keywords { "POINT" "SHADOWS_CUBE" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "DYNAMICLIGHTMAP_OFF" }
					"ps_4_0
					
					#version 330
					#extension GL_ARB_explicit_attrib_location : require
					#extension GL_ARB_explicit_uniform_location : require
					
					#define HLSLCC_ENABLE_UNIFORM_BUFFERS 1
					#if HLSLCC_ENABLE_UNIFORM_BUFFERS
					#define UNITY_UNIFORM
					#else
					#define UNITY_UNIFORM uniform
					#endif
					#define UNITY_SUPPORTS_UNIFORM_LOCATION 1
					#if UNITY_SUPPORTS_UNIFORM_LOCATION
					#define UNITY_LOCATION(x) layout(location = x)
					#define UNITY_BINDING(x) layout(binding = x, std140)
					#else
					#define UNITY_LOCATION(x)
					#define UNITY_BINDING(x) layout(std140)
					#endif
					layout(std140) uniform PGlobals {
						vec4 unused_0_0[6];
						vec4 _LightColor0;
						vec4 unused_0_2;
						vec4 _MainTexture_ST;
						vec4 _Specular_ST;
						vec4 _NormalMap_ST;
						vec4 _Color;
						vec4 unused_0_7;
						float _NormalSharpness;
						float _Shadows;
					};
					layout(std140) uniform UnityPerCamera {
						vec4 unused_1_0[4];
						vec3 _WorldSpaceCameraPos;
						vec4 unused_1_2[4];
					};
					layout(std140) uniform UnityLighting {
						vec4 _WorldSpaceLightPos0;
						vec4 unused_2_1;
						vec4 _LightProjectionParams;
						vec4 unused_2_3[45];
					};
					layout(std140) uniform UnityShadows {
						vec4 unused_3_0[24];
						vec4 _LightShadowData;
						vec4 unused_3_2;
					};
					uniform  sampler2D _NormalMap;
					uniform  sampler2D _LightTexture0;
					uniform  sampler2D _MainTexture;
					uniform  sampler2D _Specular;
					uniform  samplerCube _ShadowMapTexture;
					uniform  samplerCubeShadow hlslcc_zcmp_ShadowMapTexture;
					in  vec2 vs_TEXCOORD0;
					in  vec4 vs_TEXCOORD3;
					in  vec3 vs_TEXCOORD4;
					in  vec3 vs_TEXCOORD5;
					in  vec3 vs_TEXCOORD6;
					in  vec3 vs_TEXCOORD7;
					in  vec3 vs_TEXCOORD8;
					layout(location = 0) out vec4 SV_Target0;
					vec4 u_xlat0;
					vec4 u_xlat1;
					int u_xlati1;
					vec4 u_xlat2;
					vec4 u_xlat3;
					vec3 u_xlat4;
					vec4 u_xlat5;
					vec3 u_xlat7;
					int u_xlati7;
					float u_xlat12;
					float u_xlat13;
					float u_xlat18;
					float u_xlat19;
					float u_xlat20;
					void main()
					{
					    u_xlat0.xy = vs_TEXCOORD0.xy * _NormalMap_ST.xy + _NormalMap_ST.zw;
					    u_xlat0 = texture(_NormalMap, u_xlat0.xy);
					    u_xlat0.x = u_xlat0.w * u_xlat0.x;
					    u_xlat0.xy = u_xlat0.xy * vec2(2.0, 2.0) + vec2(-1.0, -1.0);
					    u_xlat18 = dot(u_xlat0.xy, u_xlat0.xy);
					    u_xlat18 = min(u_xlat18, 1.0);
					    u_xlat18 = (-u_xlat18) + 1.0;
					    u_xlat0.z = sqrt(u_xlat18);
					    u_xlat18 = (-_NormalSharpness) + 1.0;
					    u_xlat0.xyz = u_xlat0.xyz / vec3(u_xlat18);
					    u_xlat0.xyz = clamp(u_xlat0.xyz, 0.0, 1.0);
					    u_xlat1.xyz = u_xlat0.yyy * vs_TEXCOORD6.xyz;
					    u_xlat0.xyw = u_xlat0.xxx * vs_TEXCOORD5.xyz + u_xlat1.xyz;
					    u_xlat1.x = dot(vs_TEXCOORD4.xyz, vs_TEXCOORD4.xyz);
					    u_xlat1.x = inversesqrt(u_xlat1.x);
					    u_xlat1.xyz = u_xlat1.xxx * vs_TEXCOORD4.xyz;
					    u_xlat0.xyz = u_xlat0.zzz * u_xlat1.xyz + u_xlat0.xyw;
					    u_xlat18 = dot(u_xlat0.xyz, u_xlat0.xyz);
					    u_xlat18 = inversesqrt(u_xlat18);
					    u_xlat0.xyz = vec3(u_xlat18) * u_xlat0.xyz;
					    u_xlat2.xyz = (-vs_TEXCOORD3.xyz) + _WorldSpaceCameraPos.xyz;
					    u_xlat18 = dot(u_xlat2.xyz, u_xlat2.xyz);
					    u_xlat18 = inversesqrt(u_xlat18);
					    u_xlat3.xyz = vec3(u_xlat18) * u_xlat2.xyz;
					    u_xlat1.x = dot(u_xlat3.xyz, u_xlat1.xyz);
					    u_xlati7 = int((0.0<u_xlat1.x) ? 0xFFFFFFFFu : uint(0));
					    u_xlati1 = int((u_xlat1.x<0.0) ? 0xFFFFFFFFu : uint(0));
					    u_xlati1 = (-u_xlati7) + u_xlati1;
					    u_xlat1.x = float(u_xlati1);
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xxx;
					    u_xlat1.xyz = _WorldSpaceLightPos0.www * (-vs_TEXCOORD3.xyz) + _WorldSpaceLightPos0.xyz;
					    u_xlat19 = dot(u_xlat1.xyz, u_xlat1.xyz);
					    u_xlat19 = inversesqrt(u_xlat19);
					    u_xlat1.xyz = vec3(u_xlat19) * u_xlat1.xyz;
					    u_xlat2.xyz = u_xlat2.xyz * vec3(u_xlat18) + u_xlat1.xyz;
					    u_xlat18 = dot(u_xlat2.xyz, u_xlat2.xyz);
					    u_xlat18 = inversesqrt(u_xlat18);
					    u_xlat2.xyz = vec3(u_xlat18) * u_xlat2.xyz;
					    u_xlat0.w = dot(u_xlat0.xyz, u_xlat2.xyz);
					    u_xlat1.w = dot(u_xlat1.xyz, u_xlat2.xyz);
					    u_xlat1.x = dot(u_xlat0.xyz, u_xlat1.xyz);
					    u_xlat0.x = dot(u_xlat0.xyz, u_xlat3.xyz);
					    u_xlat0.yz = max(u_xlat1.xw, vec2(0.0, 0.0));
					    u_xlat0.xw = max(u_xlat0.xw, vec2(0.0, 0.0));
					    u_xlat1.x = log2(u_xlat0.w);
					    u_xlat18 = u_xlat0.w * u_xlat0.w;
					    u_xlat1.x = u_xlat1.x * 9.99999975e-05;
					    u_xlat1.x = exp2(u_xlat1.x);
					    u_xlat7.x = u_xlat0.x * 0.202115417 + 0.797884583;
					    u_xlat13 = u_xlat0.y * 0.202115417 + 0.797884583;
					    u_xlat7.x = u_xlat13 * u_xlat7.x + 9.99999975e-06;
					    u_xlat1.y = float(1.0) / u_xlat7.x;
					    u_xlat1.xy = u_xlat1.xy * vec2(0.318325758, 0.25);
					    u_xlat7.x = u_xlat0.y * u_xlat1.y;
					    u_xlat1.x = u_xlat1.x * u_xlat7.x;
					    u_xlat1.x = u_xlat1.x * 0.616850257;
					    u_xlat7.x = max(abs(vs_TEXCOORD8.y), abs(vs_TEXCOORD8.x));
					    u_xlat7.x = max(u_xlat7.x, abs(vs_TEXCOORD8.z));
					    u_xlat7.x = u_xlat7.x + (-_LightProjectionParams.z);
					    u_xlat7.x = max(u_xlat7.x, 9.99999975e-06);
					    u_xlat7.x = u_xlat7.x * _LightProjectionParams.w;
					    u_xlat7.x = _LightProjectionParams.y / u_xlat7.x;
					    u_xlat7.x = u_xlat7.x + (-_LightProjectionParams.x);
					    u_xlat7.x = (-u_xlat7.x) + 1.0;
					    vec4 txVec0 = vec4(vs_TEXCOORD8.xyz,u_xlat7.x);
					    u_xlat7.x = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec0, 0.0);
					    u_xlat13 = (-_LightShadowData.x) + 1.0;
					    u_xlat7.x = u_xlat7.x * u_xlat13 + _LightShadowData.x;
					    u_xlat13 = dot(vs_TEXCOORD7.xyz, vs_TEXCOORD7.xyz);
					    u_xlat2 = texture(_LightTexture0, vec2(u_xlat13));
					    u_xlat7.x = u_xlat7.x * u_xlat2.x;
					    u_xlat7.xyz = u_xlat7.xxx * _LightColor0.xyz;
					    u_xlat2.xyz = vec3(u_xlat18) * u_xlat7.xyz;
					    u_xlat2.xyz = u_xlat1.xxx * u_xlat2.xyz;
					    u_xlat2.xyz = u_xlat2.xyz * _LightColor0.xyz;
					    u_xlat0.xw = (-u_xlat0.xz) + vec2(1.00001001, 1.0);
					    u_xlat1.x = u_xlat0.w * u_xlat0.w;
					    u_xlat1.x = u_xlat1.x * u_xlat1.x;
					    u_xlat18 = u_xlat0.w * u_xlat1.x;
					    u_xlat3.xy = vs_TEXCOORD0.xy * _MainTexture_ST.xy + _MainTexture_ST.zw;
					    u_xlat3 = texture(_MainTexture, u_xlat3.xy);
					    u_xlat3.xyz = _Color.xyz * u_xlat3.xyz + vec3(vec3(_Shadows, _Shadows, _Shadows));
					    u_xlat3.xyz = u_xlat3.xyz + vec3(-1.0, -1.0, -1.0);
					    u_xlat3.xyz = clamp(u_xlat3.xyz, 0.0, 1.0);
					    u_xlat4.xyz = u_xlat3.xyz + vec3(-0.220916301, -0.220916301, -0.220916301);
					    u_xlat5.xy = vs_TEXCOORD0.xy * _Specular_ST.xy + _Specular_ST.zw;
					    u_xlat5 = texture(_Specular, u_xlat5.xy);
					    u_xlat1.x = u_xlat5.x * 0.449999988;
					    u_xlat20 = (-u_xlat5.x) * 0.350587666 + 0.779083729;
					    u_xlat3.xyz = vec3(u_xlat20) * u_xlat3.xyz;
					    u_xlat4.xyz = u_xlat1.xxx * u_xlat4.xyz + vec3(0.220916301, 0.220916301, 0.220916301);
					    u_xlat5.xyz = (-u_xlat4.xyz) + vec3(1.0, 1.0, 1.0);
					    u_xlat4.xyz = u_xlat5.xyz * vec3(u_xlat18) + u_xlat4.xyz;
					    u_xlat2.xyz = u_xlat2.xyz * u_xlat4.xyz;
					    u_xlat18 = u_xlat0.x * u_xlat0.x;
					    u_xlat18 = u_xlat18 * u_xlat18;
					    u_xlat0.x = u_xlat18 * u_xlat0.x;
					    u_xlat18 = u_xlat0.z + u_xlat0.z;
					    u_xlat12 = u_xlat18 * u_xlat0.z + -0.5;
					    u_xlat0.x = u_xlat12 * u_xlat0.x + 1.0;
					    u_xlat18 = (-u_xlat0.y) + 1.00001001;
					    u_xlat1.x = u_xlat18 * u_xlat18;
					    u_xlat1.x = u_xlat1.x * u_xlat1.x;
					    u_xlat18 = u_xlat18 * u_xlat1.x;
					    u_xlat12 = u_xlat12 * u_xlat18 + 1.0;
					    u_xlat0.x = u_xlat0.x * u_xlat12;
					    u_xlat0.x = u_xlat0.y * u_xlat0.x;
					    u_xlat0.xyz = u_xlat7.xyz * u_xlat0.xxx;
					    SV_Target0.xyz = u_xlat0.xyz * u_xlat3.xyz + u_xlat2.xyz;
					    SV_Target0.w = 0.0;
					    return;
					}"
				}
				SubProgram "d3d11 " {
					Keywords { "POINT" "SHADOWS_CUBE" "SHADOWS_SOFT" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "DYNAMICLIGHTMAP_OFF" }
					"ps_4_0
					
					#version 330
					#extension GL_ARB_explicit_attrib_location : require
					#extension GL_ARB_explicit_uniform_location : require
					
					#define HLSLCC_ENABLE_UNIFORM_BUFFERS 1
					#if HLSLCC_ENABLE_UNIFORM_BUFFERS
					#define UNITY_UNIFORM
					#else
					#define UNITY_UNIFORM uniform
					#endif
					#define UNITY_SUPPORTS_UNIFORM_LOCATION 1
					#if UNITY_SUPPORTS_UNIFORM_LOCATION
					#define UNITY_LOCATION(x) layout(location = x)
					#define UNITY_BINDING(x) layout(binding = x, std140)
					#else
					#define UNITY_LOCATION(x)
					#define UNITY_BINDING(x) layout(std140)
					#endif
					layout(std140) uniform PGlobals {
						vec4 unused_0_0[6];
						vec4 _LightColor0;
						vec4 unused_0_2;
						vec4 _MainTexture_ST;
						vec4 _Specular_ST;
						vec4 _NormalMap_ST;
						vec4 _Color;
						vec4 unused_0_7;
						float _NormalSharpness;
						float _Shadows;
					};
					layout(std140) uniform UnityPerCamera {
						vec4 unused_1_0[4];
						vec3 _WorldSpaceCameraPos;
						vec4 unused_1_2[4];
					};
					layout(std140) uniform UnityLighting {
						vec4 _WorldSpaceLightPos0;
						vec4 unused_2_1;
						vec4 _LightProjectionParams;
						vec4 unused_2_3[45];
					};
					layout(std140) uniform UnityShadows {
						vec4 unused_3_0[24];
						vec4 _LightShadowData;
						vec4 unused_3_2;
					};
					uniform  sampler2D _NormalMap;
					uniform  sampler2D _LightTexture0;
					uniform  sampler2D _MainTexture;
					uniform  sampler2D _Specular;
					uniform  samplerCube _ShadowMapTexture;
					uniform  samplerCubeShadow hlslcc_zcmp_ShadowMapTexture;
					in  vec2 vs_TEXCOORD0;
					in  vec4 vs_TEXCOORD3;
					in  vec3 vs_TEXCOORD4;
					in  vec3 vs_TEXCOORD5;
					in  vec3 vs_TEXCOORD6;
					in  vec3 vs_TEXCOORD7;
					in  vec3 vs_TEXCOORD8;
					layout(location = 0) out vec4 SV_Target0;
					vec4 u_xlat0;
					vec4 u_xlat1;
					int u_xlati1;
					vec4 u_xlat2;
					vec4 u_xlat3;
					vec3 u_xlat4;
					vec4 u_xlat5;
					vec3 u_xlat7;
					int u_xlati7;
					float u_xlat12;
					float u_xlat13;
					float u_xlat18;
					float u_xlat19;
					float u_xlat20;
					void main()
					{
					    u_xlat0.xy = vs_TEXCOORD0.xy * _NormalMap_ST.xy + _NormalMap_ST.zw;
					    u_xlat0 = texture(_NormalMap, u_xlat0.xy);
					    u_xlat0.x = u_xlat0.w * u_xlat0.x;
					    u_xlat0.xy = u_xlat0.xy * vec2(2.0, 2.0) + vec2(-1.0, -1.0);
					    u_xlat18 = dot(u_xlat0.xy, u_xlat0.xy);
					    u_xlat18 = min(u_xlat18, 1.0);
					    u_xlat18 = (-u_xlat18) + 1.0;
					    u_xlat0.z = sqrt(u_xlat18);
					    u_xlat18 = (-_NormalSharpness) + 1.0;
					    u_xlat0.xyz = u_xlat0.xyz / vec3(u_xlat18);
					    u_xlat0.xyz = clamp(u_xlat0.xyz, 0.0, 1.0);
					    u_xlat1.xyz = u_xlat0.yyy * vs_TEXCOORD6.xyz;
					    u_xlat0.xyw = u_xlat0.xxx * vs_TEXCOORD5.xyz + u_xlat1.xyz;
					    u_xlat1.x = dot(vs_TEXCOORD4.xyz, vs_TEXCOORD4.xyz);
					    u_xlat1.x = inversesqrt(u_xlat1.x);
					    u_xlat1.xyz = u_xlat1.xxx * vs_TEXCOORD4.xyz;
					    u_xlat0.xyz = u_xlat0.zzz * u_xlat1.xyz + u_xlat0.xyw;
					    u_xlat18 = dot(u_xlat0.xyz, u_xlat0.xyz);
					    u_xlat18 = inversesqrt(u_xlat18);
					    u_xlat0.xyz = vec3(u_xlat18) * u_xlat0.xyz;
					    u_xlat2.xyz = (-vs_TEXCOORD3.xyz) + _WorldSpaceCameraPos.xyz;
					    u_xlat18 = dot(u_xlat2.xyz, u_xlat2.xyz);
					    u_xlat18 = inversesqrt(u_xlat18);
					    u_xlat3.xyz = vec3(u_xlat18) * u_xlat2.xyz;
					    u_xlat1.x = dot(u_xlat3.xyz, u_xlat1.xyz);
					    u_xlati7 = int((0.0<u_xlat1.x) ? 0xFFFFFFFFu : uint(0));
					    u_xlati1 = int((u_xlat1.x<0.0) ? 0xFFFFFFFFu : uint(0));
					    u_xlati1 = (-u_xlati7) + u_xlati1;
					    u_xlat1.x = float(u_xlati1);
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xxx;
					    u_xlat1.xyz = _WorldSpaceLightPos0.www * (-vs_TEXCOORD3.xyz) + _WorldSpaceLightPos0.xyz;
					    u_xlat19 = dot(u_xlat1.xyz, u_xlat1.xyz);
					    u_xlat19 = inversesqrt(u_xlat19);
					    u_xlat1.xyz = vec3(u_xlat19) * u_xlat1.xyz;
					    u_xlat2.xyz = u_xlat2.xyz * vec3(u_xlat18) + u_xlat1.xyz;
					    u_xlat18 = dot(u_xlat2.xyz, u_xlat2.xyz);
					    u_xlat18 = inversesqrt(u_xlat18);
					    u_xlat2.xyz = vec3(u_xlat18) * u_xlat2.xyz;
					    u_xlat0.w = dot(u_xlat0.xyz, u_xlat2.xyz);
					    u_xlat1.w = dot(u_xlat1.xyz, u_xlat2.xyz);
					    u_xlat1.x = dot(u_xlat0.xyz, u_xlat1.xyz);
					    u_xlat0.x = dot(u_xlat0.xyz, u_xlat3.xyz);
					    u_xlat0.yz = max(u_xlat1.xw, vec2(0.0, 0.0));
					    u_xlat0.xw = max(u_xlat0.xw, vec2(0.0, 0.0));
					    u_xlat1.x = log2(u_xlat0.w);
					    u_xlat18 = u_xlat0.w * u_xlat0.w;
					    u_xlat1.x = u_xlat1.x * 9.99999975e-05;
					    u_xlat1.x = exp2(u_xlat1.x);
					    u_xlat7.x = u_xlat0.x * 0.202115417 + 0.797884583;
					    u_xlat13 = u_xlat0.y * 0.202115417 + 0.797884583;
					    u_xlat7.x = u_xlat13 * u_xlat7.x + 9.99999975e-06;
					    u_xlat1.y = float(1.0) / u_xlat7.x;
					    u_xlat1.xy = u_xlat1.xy * vec2(0.318325758, 0.25);
					    u_xlat7.x = u_xlat0.y * u_xlat1.y;
					    u_xlat1.x = u_xlat1.x * u_xlat7.x;
					    u_xlat1.x = u_xlat1.x * 0.616850257;
					    u_xlat7.x = max(abs(vs_TEXCOORD8.y), abs(vs_TEXCOORD8.x));
					    u_xlat7.x = max(u_xlat7.x, abs(vs_TEXCOORD8.z));
					    u_xlat7.x = u_xlat7.x + (-_LightProjectionParams.z);
					    u_xlat7.x = max(u_xlat7.x, 9.99999975e-06);
					    u_xlat7.x = u_xlat7.x * _LightProjectionParams.w;
					    u_xlat7.x = _LightProjectionParams.y / u_xlat7.x;
					    u_xlat7.x = u_xlat7.x + (-_LightProjectionParams.x);
					    u_xlat7.x = (-u_xlat7.x) + 1.0;
					    u_xlat2.xyz = vs_TEXCOORD8.xyz + vec3(0.0078125, 0.0078125, 0.0078125);
					    vec4 txVec0 = vec4(u_xlat2.xyz,u_xlat7.x);
					    u_xlat2.x = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec0, 0.0);
					    u_xlat3.xyz = vs_TEXCOORD8.xyz + vec3(-0.0078125, -0.0078125, 0.0078125);
					    vec4 txVec1 = vec4(u_xlat3.xyz,u_xlat7.x);
					    u_xlat2.y = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec1, 0.0);
					    u_xlat3.xyz = vs_TEXCOORD8.xyz + vec3(-0.0078125, 0.0078125, -0.0078125);
					    vec4 txVec2 = vec4(u_xlat3.xyz,u_xlat7.x);
					    u_xlat2.z = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec2, 0.0);
					    u_xlat3.xyz = vs_TEXCOORD8.xyz + vec3(0.0078125, -0.0078125, -0.0078125);
					    vec4 txVec3 = vec4(u_xlat3.xyz,u_xlat7.x);
					    u_xlat2.w = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec3, 0.0);
					    u_xlat7.x = dot(u_xlat2, vec4(0.25, 0.25, 0.25, 0.25));
					    u_xlat13 = (-_LightShadowData.x) + 1.0;
					    u_xlat7.x = u_xlat7.x * u_xlat13 + _LightShadowData.x;
					    u_xlat13 = dot(vs_TEXCOORD7.xyz, vs_TEXCOORD7.xyz);
					    u_xlat2 = texture(_LightTexture0, vec2(u_xlat13));
					    u_xlat7.x = u_xlat7.x * u_xlat2.x;
					    u_xlat7.xyz = u_xlat7.xxx * _LightColor0.xyz;
					    u_xlat2.xyz = vec3(u_xlat18) * u_xlat7.xyz;
					    u_xlat2.xyz = u_xlat1.xxx * u_xlat2.xyz;
					    u_xlat2.xyz = u_xlat2.xyz * _LightColor0.xyz;
					    u_xlat0.xw = (-u_xlat0.xz) + vec2(1.00001001, 1.0);
					    u_xlat1.x = u_xlat0.w * u_xlat0.w;
					    u_xlat1.x = u_xlat1.x * u_xlat1.x;
					    u_xlat18 = u_xlat0.w * u_xlat1.x;
					    u_xlat3.xy = vs_TEXCOORD0.xy * _MainTexture_ST.xy + _MainTexture_ST.zw;
					    u_xlat3 = texture(_MainTexture, u_xlat3.xy);
					    u_xlat3.xyz = _Color.xyz * u_xlat3.xyz + vec3(vec3(_Shadows, _Shadows, _Shadows));
					    u_xlat3.xyz = u_xlat3.xyz + vec3(-1.0, -1.0, -1.0);
					    u_xlat3.xyz = clamp(u_xlat3.xyz, 0.0, 1.0);
					    u_xlat4.xyz = u_xlat3.xyz + vec3(-0.220916301, -0.220916301, -0.220916301);
					    u_xlat5.xy = vs_TEXCOORD0.xy * _Specular_ST.xy + _Specular_ST.zw;
					    u_xlat5 = texture(_Specular, u_xlat5.xy);
					    u_xlat1.x = u_xlat5.x * 0.449999988;
					    u_xlat20 = (-u_xlat5.x) * 0.350587666 + 0.779083729;
					    u_xlat3.xyz = vec3(u_xlat20) * u_xlat3.xyz;
					    u_xlat4.xyz = u_xlat1.xxx * u_xlat4.xyz + vec3(0.220916301, 0.220916301, 0.220916301);
					    u_xlat5.xyz = (-u_xlat4.xyz) + vec3(1.0, 1.0, 1.0);
					    u_xlat4.xyz = u_xlat5.xyz * vec3(u_xlat18) + u_xlat4.xyz;
					    u_xlat2.xyz = u_xlat2.xyz * u_xlat4.xyz;
					    u_xlat18 = u_xlat0.x * u_xlat0.x;
					    u_xlat18 = u_xlat18 * u_xlat18;
					    u_xlat0.x = u_xlat18 * u_xlat0.x;
					    u_xlat18 = u_xlat0.z + u_xlat0.z;
					    u_xlat12 = u_xlat18 * u_xlat0.z + -0.5;
					    u_xlat0.x = u_xlat12 * u_xlat0.x + 1.0;
					    u_xlat18 = (-u_xlat0.y) + 1.00001001;
					    u_xlat1.x = u_xlat18 * u_xlat18;
					    u_xlat1.x = u_xlat1.x * u_xlat1.x;
					    u_xlat18 = u_xlat18 * u_xlat1.x;
					    u_xlat12 = u_xlat12 * u_xlat18 + 1.0;
					    u_xlat0.x = u_xlat0.x * u_xlat12;
					    u_xlat0.x = u_xlat0.y * u_xlat0.x;
					    u_xlat0.xyz = u_xlat7.xyz * u_xlat0.xxx;
					    SV_Target0.xyz = u_xlat0.xyz * u_xlat3.xyz + u_xlat2.xyz;
					    SV_Target0.w = 0.0;
					    return;
					}"
				}
				SubProgram "d3d11 " {
					Keywords { "POINT_COOKIE" "SHADOWS_CUBE" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "DYNAMICLIGHTMAP_OFF" }
					"ps_4_0
					
					#version 330
					#extension GL_ARB_explicit_attrib_location : require
					#extension GL_ARB_explicit_uniform_location : require
					
					#define HLSLCC_ENABLE_UNIFORM_BUFFERS 1
					#if HLSLCC_ENABLE_UNIFORM_BUFFERS
					#define UNITY_UNIFORM
					#else
					#define UNITY_UNIFORM uniform
					#endif
					#define UNITY_SUPPORTS_UNIFORM_LOCATION 1
					#if UNITY_SUPPORTS_UNIFORM_LOCATION
					#define UNITY_LOCATION(x) layout(location = x)
					#define UNITY_BINDING(x) layout(binding = x, std140)
					#else
					#define UNITY_LOCATION(x)
					#define UNITY_BINDING(x) layout(std140)
					#endif
					layout(std140) uniform PGlobals {
						vec4 unused_0_0[6];
						vec4 _LightColor0;
						vec4 unused_0_2;
						vec4 _MainTexture_ST;
						vec4 _Specular_ST;
						vec4 _NormalMap_ST;
						vec4 _Color;
						vec4 unused_0_7;
						float _NormalSharpness;
						float _Shadows;
					};
					layout(std140) uniform UnityPerCamera {
						vec4 unused_1_0[4];
						vec3 _WorldSpaceCameraPos;
						vec4 unused_1_2[4];
					};
					layout(std140) uniform UnityLighting {
						vec4 _WorldSpaceLightPos0;
						vec4 unused_2_1;
						vec4 _LightProjectionParams;
						vec4 unused_2_3[45];
					};
					layout(std140) uniform UnityShadows {
						vec4 unused_3_0[24];
						vec4 _LightShadowData;
						vec4 unused_3_2;
					};
					uniform  sampler2D _NormalMap;
					uniform  sampler2D _LightTextureB0;
					uniform  samplerCube _LightTexture0;
					uniform  sampler2D _MainTexture;
					uniform  sampler2D _Specular;
					uniform  samplerCube _ShadowMapTexture;
					uniform  samplerCubeShadow hlslcc_zcmp_ShadowMapTexture;
					in  vec2 vs_TEXCOORD0;
					in  vec4 vs_TEXCOORD3;
					in  vec3 vs_TEXCOORD4;
					in  vec3 vs_TEXCOORD5;
					in  vec3 vs_TEXCOORD6;
					in  vec3 vs_TEXCOORD7;
					in  vec3 vs_TEXCOORD8;
					layout(location = 0) out vec4 SV_Target0;
					vec4 u_xlat0;
					vec4 u_xlat1;
					int u_xlati1;
					vec4 u_xlat2;
					vec4 u_xlat3;
					vec3 u_xlat4;
					vec4 u_xlat5;
					vec3 u_xlat7;
					int u_xlati7;
					float u_xlat12;
					float u_xlat13;
					float u_xlat18;
					float u_xlat19;
					float u_xlat20;
					void main()
					{
					    u_xlat0.xy = vs_TEXCOORD0.xy * _NormalMap_ST.xy + _NormalMap_ST.zw;
					    u_xlat0 = texture(_NormalMap, u_xlat0.xy);
					    u_xlat0.x = u_xlat0.w * u_xlat0.x;
					    u_xlat0.xy = u_xlat0.xy * vec2(2.0, 2.0) + vec2(-1.0, -1.0);
					    u_xlat18 = dot(u_xlat0.xy, u_xlat0.xy);
					    u_xlat18 = min(u_xlat18, 1.0);
					    u_xlat18 = (-u_xlat18) + 1.0;
					    u_xlat0.z = sqrt(u_xlat18);
					    u_xlat18 = (-_NormalSharpness) + 1.0;
					    u_xlat0.xyz = u_xlat0.xyz / vec3(u_xlat18);
					    u_xlat0.xyz = clamp(u_xlat0.xyz, 0.0, 1.0);
					    u_xlat1.xyz = u_xlat0.yyy * vs_TEXCOORD6.xyz;
					    u_xlat0.xyw = u_xlat0.xxx * vs_TEXCOORD5.xyz + u_xlat1.xyz;
					    u_xlat1.x = dot(vs_TEXCOORD4.xyz, vs_TEXCOORD4.xyz);
					    u_xlat1.x = inversesqrt(u_xlat1.x);
					    u_xlat1.xyz = u_xlat1.xxx * vs_TEXCOORD4.xyz;
					    u_xlat0.xyz = u_xlat0.zzz * u_xlat1.xyz + u_xlat0.xyw;
					    u_xlat18 = dot(u_xlat0.xyz, u_xlat0.xyz);
					    u_xlat18 = inversesqrt(u_xlat18);
					    u_xlat0.xyz = vec3(u_xlat18) * u_xlat0.xyz;
					    u_xlat2.xyz = (-vs_TEXCOORD3.xyz) + _WorldSpaceCameraPos.xyz;
					    u_xlat18 = dot(u_xlat2.xyz, u_xlat2.xyz);
					    u_xlat18 = inversesqrt(u_xlat18);
					    u_xlat3.xyz = vec3(u_xlat18) * u_xlat2.xyz;
					    u_xlat1.x = dot(u_xlat3.xyz, u_xlat1.xyz);
					    u_xlati7 = int((0.0<u_xlat1.x) ? 0xFFFFFFFFu : uint(0));
					    u_xlati1 = int((u_xlat1.x<0.0) ? 0xFFFFFFFFu : uint(0));
					    u_xlati1 = (-u_xlati7) + u_xlati1;
					    u_xlat1.x = float(u_xlati1);
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xxx;
					    u_xlat1.xyz = _WorldSpaceLightPos0.www * (-vs_TEXCOORD3.xyz) + _WorldSpaceLightPos0.xyz;
					    u_xlat19 = dot(u_xlat1.xyz, u_xlat1.xyz);
					    u_xlat19 = inversesqrt(u_xlat19);
					    u_xlat1.xyz = vec3(u_xlat19) * u_xlat1.xyz;
					    u_xlat2.xyz = u_xlat2.xyz * vec3(u_xlat18) + u_xlat1.xyz;
					    u_xlat18 = dot(u_xlat2.xyz, u_xlat2.xyz);
					    u_xlat18 = inversesqrt(u_xlat18);
					    u_xlat2.xyz = vec3(u_xlat18) * u_xlat2.xyz;
					    u_xlat0.w = dot(u_xlat0.xyz, u_xlat2.xyz);
					    u_xlat1.w = dot(u_xlat1.xyz, u_xlat2.xyz);
					    u_xlat1.x = dot(u_xlat0.xyz, u_xlat1.xyz);
					    u_xlat0.x = dot(u_xlat0.xyz, u_xlat3.xyz);
					    u_xlat0.yz = max(u_xlat1.xw, vec2(0.0, 0.0));
					    u_xlat0.xw = max(u_xlat0.xw, vec2(0.0, 0.0));
					    u_xlat1.x = log2(u_xlat0.w);
					    u_xlat18 = u_xlat0.w * u_xlat0.w;
					    u_xlat1.x = u_xlat1.x * 9.99999975e-05;
					    u_xlat1.x = exp2(u_xlat1.x);
					    u_xlat7.x = u_xlat0.x * 0.202115417 + 0.797884583;
					    u_xlat13 = u_xlat0.y * 0.202115417 + 0.797884583;
					    u_xlat7.x = u_xlat13 * u_xlat7.x + 9.99999975e-06;
					    u_xlat1.y = float(1.0) / u_xlat7.x;
					    u_xlat1.xy = u_xlat1.xy * vec2(0.318325758, 0.25);
					    u_xlat7.x = u_xlat0.y * u_xlat1.y;
					    u_xlat1.x = u_xlat1.x * u_xlat7.x;
					    u_xlat1.x = u_xlat1.x * 0.616850257;
					    u_xlat7.x = max(abs(vs_TEXCOORD8.y), abs(vs_TEXCOORD8.x));
					    u_xlat7.x = max(u_xlat7.x, abs(vs_TEXCOORD8.z));
					    u_xlat7.x = u_xlat7.x + (-_LightProjectionParams.z);
					    u_xlat7.x = max(u_xlat7.x, 9.99999975e-06);
					    u_xlat7.x = u_xlat7.x * _LightProjectionParams.w;
					    u_xlat7.x = _LightProjectionParams.y / u_xlat7.x;
					    u_xlat7.x = u_xlat7.x + (-_LightProjectionParams.x);
					    u_xlat7.x = (-u_xlat7.x) + 1.0;
					    vec4 txVec0 = vec4(vs_TEXCOORD8.xyz,u_xlat7.x);
					    u_xlat7.x = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec0, 0.0);
					    u_xlat13 = (-_LightShadowData.x) + 1.0;
					    u_xlat7.x = u_xlat7.x * u_xlat13 + _LightShadowData.x;
					    u_xlat13 = dot(vs_TEXCOORD7.xyz, vs_TEXCOORD7.xyz);
					    u_xlat2 = texture(_LightTextureB0, vec2(u_xlat13));
					    u_xlat3 = texture(_LightTexture0, vs_TEXCOORD7.xyz);
					    u_xlat13 = u_xlat2.x * u_xlat3.w;
					    u_xlat7.x = u_xlat7.x * u_xlat13;
					    u_xlat7.xyz = u_xlat7.xxx * _LightColor0.xyz;
					    u_xlat2.xyz = vec3(u_xlat18) * u_xlat7.xyz;
					    u_xlat2.xyz = u_xlat1.xxx * u_xlat2.xyz;
					    u_xlat2.xyz = u_xlat2.xyz * _LightColor0.xyz;
					    u_xlat0.xw = (-u_xlat0.xz) + vec2(1.00001001, 1.0);
					    u_xlat1.x = u_xlat0.w * u_xlat0.w;
					    u_xlat1.x = u_xlat1.x * u_xlat1.x;
					    u_xlat18 = u_xlat0.w * u_xlat1.x;
					    u_xlat3.xy = vs_TEXCOORD0.xy * _MainTexture_ST.xy + _MainTexture_ST.zw;
					    u_xlat3 = texture(_MainTexture, u_xlat3.xy);
					    u_xlat3.xyz = _Color.xyz * u_xlat3.xyz + vec3(vec3(_Shadows, _Shadows, _Shadows));
					    u_xlat3.xyz = u_xlat3.xyz + vec3(-1.0, -1.0, -1.0);
					    u_xlat3.xyz = clamp(u_xlat3.xyz, 0.0, 1.0);
					    u_xlat4.xyz = u_xlat3.xyz + vec3(-0.220916301, -0.220916301, -0.220916301);
					    u_xlat5.xy = vs_TEXCOORD0.xy * _Specular_ST.xy + _Specular_ST.zw;
					    u_xlat5 = texture(_Specular, u_xlat5.xy);
					    u_xlat1.x = u_xlat5.x * 0.449999988;
					    u_xlat20 = (-u_xlat5.x) * 0.350587666 + 0.779083729;
					    u_xlat3.xyz = vec3(u_xlat20) * u_xlat3.xyz;
					    u_xlat4.xyz = u_xlat1.xxx * u_xlat4.xyz + vec3(0.220916301, 0.220916301, 0.220916301);
					    u_xlat5.xyz = (-u_xlat4.xyz) + vec3(1.0, 1.0, 1.0);
					    u_xlat4.xyz = u_xlat5.xyz * vec3(u_xlat18) + u_xlat4.xyz;
					    u_xlat2.xyz = u_xlat2.xyz * u_xlat4.xyz;
					    u_xlat18 = u_xlat0.x * u_xlat0.x;
					    u_xlat18 = u_xlat18 * u_xlat18;
					    u_xlat0.x = u_xlat18 * u_xlat0.x;
					    u_xlat18 = u_xlat0.z + u_xlat0.z;
					    u_xlat12 = u_xlat18 * u_xlat0.z + -0.5;
					    u_xlat0.x = u_xlat12 * u_xlat0.x + 1.0;
					    u_xlat18 = (-u_xlat0.y) + 1.00001001;
					    u_xlat1.x = u_xlat18 * u_xlat18;
					    u_xlat1.x = u_xlat1.x * u_xlat1.x;
					    u_xlat18 = u_xlat18 * u_xlat1.x;
					    u_xlat12 = u_xlat12 * u_xlat18 + 1.0;
					    u_xlat0.x = u_xlat0.x * u_xlat12;
					    u_xlat0.x = u_xlat0.y * u_xlat0.x;
					    u_xlat0.xyz = u_xlat7.xyz * u_xlat0.xxx;
					    SV_Target0.xyz = u_xlat0.xyz * u_xlat3.xyz + u_xlat2.xyz;
					    SV_Target0.w = 0.0;
					    return;
					}"
				}
				SubProgram "d3d11 " {
					Keywords { "POINT_COOKIE" "SHADOWS_CUBE" "SHADOWS_SOFT" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "DYNAMICLIGHTMAP_OFF" }
					"ps_4_0
					
					#version 330
					#extension GL_ARB_explicit_attrib_location : require
					#extension GL_ARB_explicit_uniform_location : require
					
					#define HLSLCC_ENABLE_UNIFORM_BUFFERS 1
					#if HLSLCC_ENABLE_UNIFORM_BUFFERS
					#define UNITY_UNIFORM
					#else
					#define UNITY_UNIFORM uniform
					#endif
					#define UNITY_SUPPORTS_UNIFORM_LOCATION 1
					#if UNITY_SUPPORTS_UNIFORM_LOCATION
					#define UNITY_LOCATION(x) layout(location = x)
					#define UNITY_BINDING(x) layout(binding = x, std140)
					#else
					#define UNITY_LOCATION(x)
					#define UNITY_BINDING(x) layout(std140)
					#endif
					layout(std140) uniform PGlobals {
						vec4 unused_0_0[6];
						vec4 _LightColor0;
						vec4 unused_0_2;
						vec4 _MainTexture_ST;
						vec4 _Specular_ST;
						vec4 _NormalMap_ST;
						vec4 _Color;
						vec4 unused_0_7;
						float _NormalSharpness;
						float _Shadows;
					};
					layout(std140) uniform UnityPerCamera {
						vec4 unused_1_0[4];
						vec3 _WorldSpaceCameraPos;
						vec4 unused_1_2[4];
					};
					layout(std140) uniform UnityLighting {
						vec4 _WorldSpaceLightPos0;
						vec4 unused_2_1;
						vec4 _LightProjectionParams;
						vec4 unused_2_3[45];
					};
					layout(std140) uniform UnityShadows {
						vec4 unused_3_0[24];
						vec4 _LightShadowData;
						vec4 unused_3_2;
					};
					uniform  sampler2D _NormalMap;
					uniform  sampler2D _LightTextureB0;
					uniform  samplerCube _LightTexture0;
					uniform  sampler2D _MainTexture;
					uniform  sampler2D _Specular;
					uniform  samplerCube _ShadowMapTexture;
					uniform  samplerCubeShadow hlslcc_zcmp_ShadowMapTexture;
					in  vec2 vs_TEXCOORD0;
					in  vec4 vs_TEXCOORD3;
					in  vec3 vs_TEXCOORD4;
					in  vec3 vs_TEXCOORD5;
					in  vec3 vs_TEXCOORD6;
					in  vec3 vs_TEXCOORD7;
					in  vec3 vs_TEXCOORD8;
					layout(location = 0) out vec4 SV_Target0;
					vec4 u_xlat0;
					vec4 u_xlat1;
					int u_xlati1;
					vec4 u_xlat2;
					vec4 u_xlat3;
					vec3 u_xlat4;
					vec4 u_xlat5;
					vec3 u_xlat7;
					int u_xlati7;
					float u_xlat12;
					float u_xlat13;
					float u_xlat18;
					float u_xlat19;
					float u_xlat20;
					void main()
					{
					    u_xlat0.xy = vs_TEXCOORD0.xy * _NormalMap_ST.xy + _NormalMap_ST.zw;
					    u_xlat0 = texture(_NormalMap, u_xlat0.xy);
					    u_xlat0.x = u_xlat0.w * u_xlat0.x;
					    u_xlat0.xy = u_xlat0.xy * vec2(2.0, 2.0) + vec2(-1.0, -1.0);
					    u_xlat18 = dot(u_xlat0.xy, u_xlat0.xy);
					    u_xlat18 = min(u_xlat18, 1.0);
					    u_xlat18 = (-u_xlat18) + 1.0;
					    u_xlat0.z = sqrt(u_xlat18);
					    u_xlat18 = (-_NormalSharpness) + 1.0;
					    u_xlat0.xyz = u_xlat0.xyz / vec3(u_xlat18);
					    u_xlat0.xyz = clamp(u_xlat0.xyz, 0.0, 1.0);
					    u_xlat1.xyz = u_xlat0.yyy * vs_TEXCOORD6.xyz;
					    u_xlat0.xyw = u_xlat0.xxx * vs_TEXCOORD5.xyz + u_xlat1.xyz;
					    u_xlat1.x = dot(vs_TEXCOORD4.xyz, vs_TEXCOORD4.xyz);
					    u_xlat1.x = inversesqrt(u_xlat1.x);
					    u_xlat1.xyz = u_xlat1.xxx * vs_TEXCOORD4.xyz;
					    u_xlat0.xyz = u_xlat0.zzz * u_xlat1.xyz + u_xlat0.xyw;
					    u_xlat18 = dot(u_xlat0.xyz, u_xlat0.xyz);
					    u_xlat18 = inversesqrt(u_xlat18);
					    u_xlat0.xyz = vec3(u_xlat18) * u_xlat0.xyz;
					    u_xlat2.xyz = (-vs_TEXCOORD3.xyz) + _WorldSpaceCameraPos.xyz;
					    u_xlat18 = dot(u_xlat2.xyz, u_xlat2.xyz);
					    u_xlat18 = inversesqrt(u_xlat18);
					    u_xlat3.xyz = vec3(u_xlat18) * u_xlat2.xyz;
					    u_xlat1.x = dot(u_xlat3.xyz, u_xlat1.xyz);
					    u_xlati7 = int((0.0<u_xlat1.x) ? 0xFFFFFFFFu : uint(0));
					    u_xlati1 = int((u_xlat1.x<0.0) ? 0xFFFFFFFFu : uint(0));
					    u_xlati1 = (-u_xlati7) + u_xlati1;
					    u_xlat1.x = float(u_xlati1);
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xxx;
					    u_xlat1.xyz = _WorldSpaceLightPos0.www * (-vs_TEXCOORD3.xyz) + _WorldSpaceLightPos0.xyz;
					    u_xlat19 = dot(u_xlat1.xyz, u_xlat1.xyz);
					    u_xlat19 = inversesqrt(u_xlat19);
					    u_xlat1.xyz = vec3(u_xlat19) * u_xlat1.xyz;
					    u_xlat2.xyz = u_xlat2.xyz * vec3(u_xlat18) + u_xlat1.xyz;
					    u_xlat18 = dot(u_xlat2.xyz, u_xlat2.xyz);
					    u_xlat18 = inversesqrt(u_xlat18);
					    u_xlat2.xyz = vec3(u_xlat18) * u_xlat2.xyz;
					    u_xlat0.w = dot(u_xlat0.xyz, u_xlat2.xyz);
					    u_xlat1.w = dot(u_xlat1.xyz, u_xlat2.xyz);
					    u_xlat1.x = dot(u_xlat0.xyz, u_xlat1.xyz);
					    u_xlat0.x = dot(u_xlat0.xyz, u_xlat3.xyz);
					    u_xlat0.yz = max(u_xlat1.xw, vec2(0.0, 0.0));
					    u_xlat0.xw = max(u_xlat0.xw, vec2(0.0, 0.0));
					    u_xlat1.x = log2(u_xlat0.w);
					    u_xlat18 = u_xlat0.w * u_xlat0.w;
					    u_xlat1.x = u_xlat1.x * 9.99999975e-05;
					    u_xlat1.x = exp2(u_xlat1.x);
					    u_xlat7.x = u_xlat0.x * 0.202115417 + 0.797884583;
					    u_xlat13 = u_xlat0.y * 0.202115417 + 0.797884583;
					    u_xlat7.x = u_xlat13 * u_xlat7.x + 9.99999975e-06;
					    u_xlat1.y = float(1.0) / u_xlat7.x;
					    u_xlat1.xy = u_xlat1.xy * vec2(0.318325758, 0.25);
					    u_xlat7.x = u_xlat0.y * u_xlat1.y;
					    u_xlat1.x = u_xlat1.x * u_xlat7.x;
					    u_xlat1.x = u_xlat1.x * 0.616850257;
					    u_xlat7.x = max(abs(vs_TEXCOORD8.y), abs(vs_TEXCOORD8.x));
					    u_xlat7.x = max(u_xlat7.x, abs(vs_TEXCOORD8.z));
					    u_xlat7.x = u_xlat7.x + (-_LightProjectionParams.z);
					    u_xlat7.x = max(u_xlat7.x, 9.99999975e-06);
					    u_xlat7.x = u_xlat7.x * _LightProjectionParams.w;
					    u_xlat7.x = _LightProjectionParams.y / u_xlat7.x;
					    u_xlat7.x = u_xlat7.x + (-_LightProjectionParams.x);
					    u_xlat7.x = (-u_xlat7.x) + 1.0;
					    u_xlat2.xyz = vs_TEXCOORD8.xyz + vec3(0.0078125, 0.0078125, 0.0078125);
					    vec4 txVec0 = vec4(u_xlat2.xyz,u_xlat7.x);
					    u_xlat2.x = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec0, 0.0);
					    u_xlat3.xyz = vs_TEXCOORD8.xyz + vec3(-0.0078125, -0.0078125, 0.0078125);
					    vec4 txVec1 = vec4(u_xlat3.xyz,u_xlat7.x);
					    u_xlat2.y = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec1, 0.0);
					    u_xlat3.xyz = vs_TEXCOORD8.xyz + vec3(-0.0078125, 0.0078125, -0.0078125);
					    vec4 txVec2 = vec4(u_xlat3.xyz,u_xlat7.x);
					    u_xlat2.z = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec2, 0.0);
					    u_xlat3.xyz = vs_TEXCOORD8.xyz + vec3(0.0078125, -0.0078125, -0.0078125);
					    vec4 txVec3 = vec4(u_xlat3.xyz,u_xlat7.x);
					    u_xlat2.w = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec3, 0.0);
					    u_xlat7.x = dot(u_xlat2, vec4(0.25, 0.25, 0.25, 0.25));
					    u_xlat13 = (-_LightShadowData.x) + 1.0;
					    u_xlat7.x = u_xlat7.x * u_xlat13 + _LightShadowData.x;
					    u_xlat13 = dot(vs_TEXCOORD7.xyz, vs_TEXCOORD7.xyz);
					    u_xlat2 = texture(_LightTextureB0, vec2(u_xlat13));
					    u_xlat3 = texture(_LightTexture0, vs_TEXCOORD7.xyz);
					    u_xlat13 = u_xlat2.x * u_xlat3.w;
					    u_xlat7.x = u_xlat7.x * u_xlat13;
					    u_xlat7.xyz = u_xlat7.xxx * _LightColor0.xyz;
					    u_xlat2.xyz = vec3(u_xlat18) * u_xlat7.xyz;
					    u_xlat2.xyz = u_xlat1.xxx * u_xlat2.xyz;
					    u_xlat2.xyz = u_xlat2.xyz * _LightColor0.xyz;
					    u_xlat0.xw = (-u_xlat0.xz) + vec2(1.00001001, 1.0);
					    u_xlat1.x = u_xlat0.w * u_xlat0.w;
					    u_xlat1.x = u_xlat1.x * u_xlat1.x;
					    u_xlat18 = u_xlat0.w * u_xlat1.x;
					    u_xlat3.xy = vs_TEXCOORD0.xy * _MainTexture_ST.xy + _MainTexture_ST.zw;
					    u_xlat3 = texture(_MainTexture, u_xlat3.xy);
					    u_xlat3.xyz = _Color.xyz * u_xlat3.xyz + vec3(vec3(_Shadows, _Shadows, _Shadows));
					    u_xlat3.xyz = u_xlat3.xyz + vec3(-1.0, -1.0, -1.0);
					    u_xlat3.xyz = clamp(u_xlat3.xyz, 0.0, 1.0);
					    u_xlat4.xyz = u_xlat3.xyz + vec3(-0.220916301, -0.220916301, -0.220916301);
					    u_xlat5.xy = vs_TEXCOORD0.xy * _Specular_ST.xy + _Specular_ST.zw;
					    u_xlat5 = texture(_Specular, u_xlat5.xy);
					    u_xlat1.x = u_xlat5.x * 0.449999988;
					    u_xlat20 = (-u_xlat5.x) * 0.350587666 + 0.779083729;
					    u_xlat3.xyz = vec3(u_xlat20) * u_xlat3.xyz;
					    u_xlat4.xyz = u_xlat1.xxx * u_xlat4.xyz + vec3(0.220916301, 0.220916301, 0.220916301);
					    u_xlat5.xyz = (-u_xlat4.xyz) + vec3(1.0, 1.0, 1.0);
					    u_xlat4.xyz = u_xlat5.xyz * vec3(u_xlat18) + u_xlat4.xyz;
					    u_xlat2.xyz = u_xlat2.xyz * u_xlat4.xyz;
					    u_xlat18 = u_xlat0.x * u_xlat0.x;
					    u_xlat18 = u_xlat18 * u_xlat18;
					    u_xlat0.x = u_xlat18 * u_xlat0.x;
					    u_xlat18 = u_xlat0.z + u_xlat0.z;
					    u_xlat12 = u_xlat18 * u_xlat0.z + -0.5;
					    u_xlat0.x = u_xlat12 * u_xlat0.x + 1.0;
					    u_xlat18 = (-u_xlat0.y) + 1.00001001;
					    u_xlat1.x = u_xlat18 * u_xlat18;
					    u_xlat1.x = u_xlat1.x * u_xlat1.x;
					    u_xlat18 = u_xlat18 * u_xlat1.x;
					    u_xlat12 = u_xlat12 * u_xlat18 + 1.0;
					    u_xlat0.x = u_xlat0.x * u_xlat12;
					    u_xlat0.x = u_xlat0.y * u_xlat0.x;
					    u_xlat0.xyz = u_xlat7.xyz * u_xlat0.xxx;
					    SV_Target0.xyz = u_xlat0.xyz * u_xlat3.xyz + u_xlat2.xyz;
					    SV_Target0.w = 0.0;
					    return;
					}"
				}
				SubProgram "d3d11 " {
					Keywords { "POINT" "DIRLIGHTMAP_COMBINED" "LIGHTMAP_OFF" "DYNAMICLIGHTMAP_OFF" }
					"ps_4_0
					
					#version 330
					#extension GL_ARB_explicit_attrib_location : require
					#extension GL_ARB_explicit_uniform_location : require
					
					#define HLSLCC_ENABLE_UNIFORM_BUFFERS 1
					#if HLSLCC_ENABLE_UNIFORM_BUFFERS
					#define UNITY_UNIFORM
					#else
					#define UNITY_UNIFORM uniform
					#endif
					#define UNITY_SUPPORTS_UNIFORM_LOCATION 1
					#if UNITY_SUPPORTS_UNIFORM_LOCATION
					#define UNITY_LOCATION(x) layout(location = x)
					#define UNITY_BINDING(x) layout(binding = x, std140)
					#else
					#define UNITY_LOCATION(x)
					#define UNITY_BINDING(x) layout(std140)
					#endif
					layout(std140) uniform PGlobals {
						vec4 unused_0_0[6];
						vec4 _LightColor0;
						vec4 unused_0_2;
						vec4 _MainTexture_ST;
						vec4 _Specular_ST;
						vec4 _NormalMap_ST;
						vec4 _Color;
						vec4 unused_0_7;
						float _NormalSharpness;
						float _Shadows;
					};
					layout(std140) uniform UnityPerCamera {
						vec4 unused_1_0[4];
						vec3 _WorldSpaceCameraPos;
						vec4 unused_1_2[4];
					};
					layout(std140) uniform UnityLighting {
						vec4 _WorldSpaceLightPos0;
						vec4 unused_2_1[47];
					};
					uniform  sampler2D _NormalMap;
					uniform  sampler2D _LightTexture0;
					uniform  sampler2D _MainTexture;
					uniform  sampler2D _Specular;
					in  vec2 vs_TEXCOORD0;
					in  vec4 vs_TEXCOORD3;
					in  vec3 vs_TEXCOORD4;
					in  vec3 vs_TEXCOORD5;
					in  vec3 vs_TEXCOORD6;
					in  vec3 vs_TEXCOORD7;
					layout(location = 0) out vec4 SV_Target0;
					vec4 u_xlat0;
					vec4 u_xlat1;
					int u_xlati1;
					vec4 u_xlat2;
					vec4 u_xlat3;
					vec3 u_xlat4;
					vec4 u_xlat5;
					vec3 u_xlat7;
					int u_xlati7;
					float u_xlat12;
					float u_xlat13;
					float u_xlat18;
					float u_xlat19;
					float u_xlat20;
					void main()
					{
					    u_xlat0.xy = vs_TEXCOORD0.xy * _NormalMap_ST.xy + _NormalMap_ST.zw;
					    u_xlat0 = texture(_NormalMap, u_xlat0.xy);
					    u_xlat0.x = u_xlat0.w * u_xlat0.x;
					    u_xlat0.xy = u_xlat0.xy * vec2(2.0, 2.0) + vec2(-1.0, -1.0);
					    u_xlat18 = dot(u_xlat0.xy, u_xlat0.xy);
					    u_xlat18 = min(u_xlat18, 1.0);
					    u_xlat18 = (-u_xlat18) + 1.0;
					    u_xlat0.z = sqrt(u_xlat18);
					    u_xlat18 = (-_NormalSharpness) + 1.0;
					    u_xlat0.xyz = u_xlat0.xyz / vec3(u_xlat18);
					    u_xlat0.xyz = clamp(u_xlat0.xyz, 0.0, 1.0);
					    u_xlat1.xyz = u_xlat0.yyy * vs_TEXCOORD6.xyz;
					    u_xlat0.xyw = u_xlat0.xxx * vs_TEXCOORD5.xyz + u_xlat1.xyz;
					    u_xlat1.x = dot(vs_TEXCOORD4.xyz, vs_TEXCOORD4.xyz);
					    u_xlat1.x = inversesqrt(u_xlat1.x);
					    u_xlat1.xyz = u_xlat1.xxx * vs_TEXCOORD4.xyz;
					    u_xlat0.xyz = u_xlat0.zzz * u_xlat1.xyz + u_xlat0.xyw;
					    u_xlat18 = dot(u_xlat0.xyz, u_xlat0.xyz);
					    u_xlat18 = inversesqrt(u_xlat18);
					    u_xlat0.xyz = vec3(u_xlat18) * u_xlat0.xyz;
					    u_xlat2.xyz = (-vs_TEXCOORD3.xyz) + _WorldSpaceCameraPos.xyz;
					    u_xlat18 = dot(u_xlat2.xyz, u_xlat2.xyz);
					    u_xlat18 = inversesqrt(u_xlat18);
					    u_xlat3.xyz = vec3(u_xlat18) * u_xlat2.xyz;
					    u_xlat1.x = dot(u_xlat3.xyz, u_xlat1.xyz);
					    u_xlati7 = int((0.0<u_xlat1.x) ? 0xFFFFFFFFu : uint(0));
					    u_xlati1 = int((u_xlat1.x<0.0) ? 0xFFFFFFFFu : uint(0));
					    u_xlati1 = (-u_xlati7) + u_xlati1;
					    u_xlat1.x = float(u_xlati1);
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xxx;
					    u_xlat1.xyz = _WorldSpaceLightPos0.www * (-vs_TEXCOORD3.xyz) + _WorldSpaceLightPos0.xyz;
					    u_xlat19 = dot(u_xlat1.xyz, u_xlat1.xyz);
					    u_xlat19 = inversesqrt(u_xlat19);
					    u_xlat1.xyz = vec3(u_xlat19) * u_xlat1.xyz;
					    u_xlat2.xyz = u_xlat2.xyz * vec3(u_xlat18) + u_xlat1.xyz;
					    u_xlat18 = dot(u_xlat2.xyz, u_xlat2.xyz);
					    u_xlat18 = inversesqrt(u_xlat18);
					    u_xlat2.xyz = vec3(u_xlat18) * u_xlat2.xyz;
					    u_xlat0.w = dot(u_xlat0.xyz, u_xlat2.xyz);
					    u_xlat1.w = dot(u_xlat1.xyz, u_xlat2.xyz);
					    u_xlat1.x = dot(u_xlat0.xyz, u_xlat1.xyz);
					    u_xlat0.x = dot(u_xlat0.xyz, u_xlat3.xyz);
					    u_xlat0.yz = max(u_xlat1.xw, vec2(0.0, 0.0));
					    u_xlat0.xw = max(u_xlat0.xw, vec2(0.0, 0.0));
					    u_xlat1.x = log2(u_xlat0.w);
					    u_xlat18 = u_xlat0.w * u_xlat0.w;
					    u_xlat1.x = u_xlat1.x * 9.99999975e-05;
					    u_xlat1.x = exp2(u_xlat1.x);
					    u_xlat7.x = u_xlat0.x * 0.202115417 + 0.797884583;
					    u_xlat13 = u_xlat0.y * 0.202115417 + 0.797884583;
					    u_xlat7.x = u_xlat13 * u_xlat7.x + 9.99999975e-06;
					    u_xlat1.y = float(1.0) / u_xlat7.x;
					    u_xlat1.xy = u_xlat1.xy * vec2(0.318325758, 0.25);
					    u_xlat7.x = u_xlat0.y * u_xlat1.y;
					    u_xlat1.x = u_xlat1.x * u_xlat7.x;
					    u_xlat1.x = u_xlat1.x * 0.616850257;
					    u_xlat7.x = dot(vs_TEXCOORD7.xyz, vs_TEXCOORD7.xyz);
					    u_xlat2 = texture(_LightTexture0, u_xlat7.xx);
					    u_xlat7.xyz = u_xlat2.xxx * _LightColor0.xyz;
					    u_xlat2.xyz = vec3(u_xlat18) * u_xlat7.xyz;
					    u_xlat2.xyz = u_xlat1.xxx * u_xlat2.xyz;
					    u_xlat2.xyz = u_xlat2.xyz * _LightColor0.xyz;
					    u_xlat0.xw = (-u_xlat0.xz) + vec2(1.00001001, 1.0);
					    u_xlat1.x = u_xlat0.w * u_xlat0.w;
					    u_xlat1.x = u_xlat1.x * u_xlat1.x;
					    u_xlat18 = u_xlat0.w * u_xlat1.x;
					    u_xlat3.xy = vs_TEXCOORD0.xy * _MainTexture_ST.xy + _MainTexture_ST.zw;
					    u_xlat3 = texture(_MainTexture, u_xlat3.xy);
					    u_xlat3.xyz = _Color.xyz * u_xlat3.xyz + vec3(vec3(_Shadows, _Shadows, _Shadows));
					    u_xlat3.xyz = u_xlat3.xyz + vec3(-1.0, -1.0, -1.0);
					    u_xlat3.xyz = clamp(u_xlat3.xyz, 0.0, 1.0);
					    u_xlat4.xyz = u_xlat3.xyz + vec3(-0.220916301, -0.220916301, -0.220916301);
					    u_xlat5.xy = vs_TEXCOORD0.xy * _Specular_ST.xy + _Specular_ST.zw;
					    u_xlat5 = texture(_Specular, u_xlat5.xy);
					    u_xlat1.x = u_xlat5.x * 0.449999988;
					    u_xlat20 = (-u_xlat5.x) * 0.350587666 + 0.779083729;
					    u_xlat3.xyz = vec3(u_xlat20) * u_xlat3.xyz;
					    u_xlat4.xyz = u_xlat1.xxx * u_xlat4.xyz + vec3(0.220916301, 0.220916301, 0.220916301);
					    u_xlat5.xyz = (-u_xlat4.xyz) + vec3(1.0, 1.0, 1.0);
					    u_xlat4.xyz = u_xlat5.xyz * vec3(u_xlat18) + u_xlat4.xyz;
					    u_xlat2.xyz = u_xlat2.xyz * u_xlat4.xyz;
					    u_xlat18 = u_xlat0.x * u_xlat0.x;
					    u_xlat18 = u_xlat18 * u_xlat18;
					    u_xlat0.x = u_xlat18 * u_xlat0.x;
					    u_xlat18 = u_xlat0.z + u_xlat0.z;
					    u_xlat12 = u_xlat18 * u_xlat0.z + -0.5;
					    u_xlat0.x = u_xlat12 * u_xlat0.x + 1.0;
					    u_xlat18 = (-u_xlat0.y) + 1.00001001;
					    u_xlat1.x = u_xlat18 * u_xlat18;
					    u_xlat1.x = u_xlat1.x * u_xlat1.x;
					    u_xlat18 = u_xlat18 * u_xlat1.x;
					    u_xlat12 = u_xlat12 * u_xlat18 + 1.0;
					    u_xlat0.x = u_xlat0.x * u_xlat12;
					    u_xlat0.x = u_xlat0.y * u_xlat0.x;
					    u_xlat0.xyz = u_xlat7.xyz * u_xlat0.xxx;
					    SV_Target0.xyz = u_xlat0.xyz * u_xlat3.xyz + u_xlat2.xyz;
					    SV_Target0.w = 0.0;
					    return;
					}"
				}
				SubProgram "d3d11 " {
					Keywords { "DIRECTIONAL" "DIRLIGHTMAP_COMBINED" "LIGHTMAP_OFF" "DYNAMICLIGHTMAP_OFF" }
					"ps_4_0
					
					#version 330
					#extension GL_ARB_explicit_attrib_location : require
					#extension GL_ARB_explicit_uniform_location : require
					
					#define HLSLCC_ENABLE_UNIFORM_BUFFERS 1
					#if HLSLCC_ENABLE_UNIFORM_BUFFERS
					#define UNITY_UNIFORM
					#else
					#define UNITY_UNIFORM uniform
					#endif
					#define UNITY_SUPPORTS_UNIFORM_LOCATION 1
					#if UNITY_SUPPORTS_UNIFORM_LOCATION
					#define UNITY_LOCATION(x) layout(location = x)
					#define UNITY_BINDING(x) layout(binding = x, std140)
					#else
					#define UNITY_LOCATION(x)
					#define UNITY_BINDING(x) layout(std140)
					#endif
					layout(std140) uniform PGlobals {
						vec4 unused_0_0[2];
						vec4 _LightColor0;
						vec4 unused_0_2;
						vec4 _MainTexture_ST;
						vec4 _Specular_ST;
						vec4 _NormalMap_ST;
						vec4 _Color;
						vec4 unused_0_7;
						float _NormalSharpness;
						float _Shadows;
					};
					layout(std140) uniform UnityPerCamera {
						vec4 unused_1_0[4];
						vec3 _WorldSpaceCameraPos;
						vec4 unused_1_2[4];
					};
					layout(std140) uniform UnityLighting {
						vec4 _WorldSpaceLightPos0;
						vec4 unused_2_1[47];
					};
					uniform  sampler2D _NormalMap;
					uniform  sampler2D _MainTexture;
					uniform  sampler2D _Specular;
					in  vec2 vs_TEXCOORD0;
					in  vec4 vs_TEXCOORD3;
					in  vec3 vs_TEXCOORD4;
					in  vec3 vs_TEXCOORD5;
					in  vec3 vs_TEXCOORD6;
					layout(location = 0) out vec4 SV_Target0;
					vec4 u_xlat0;
					vec4 u_xlat1;
					int u_xlati1;
					vec4 u_xlat2;
					vec3 u_xlat3;
					vec4 u_xlat4;
					vec3 u_xlat6;
					int u_xlati6;
					float u_xlat10;
					float u_xlat15;
					float u_xlat16;
					float u_xlat17;
					void main()
					{
					    u_xlat0.xy = vs_TEXCOORD0.xy * _NormalMap_ST.xy + _NormalMap_ST.zw;
					    u_xlat0 = texture(_NormalMap, u_xlat0.xy);
					    u_xlat0.x = u_xlat0.w * u_xlat0.x;
					    u_xlat0.xy = u_xlat0.xy * vec2(2.0, 2.0) + vec2(-1.0, -1.0);
					    u_xlat15 = dot(u_xlat0.xy, u_xlat0.xy);
					    u_xlat15 = min(u_xlat15, 1.0);
					    u_xlat15 = (-u_xlat15) + 1.0;
					    u_xlat0.z = sqrt(u_xlat15);
					    u_xlat15 = (-_NormalSharpness) + 1.0;
					    u_xlat0.xyz = u_xlat0.xyz / vec3(u_xlat15);
					    u_xlat0.xyz = clamp(u_xlat0.xyz, 0.0, 1.0);
					    u_xlat1.xyz = u_xlat0.yyy * vs_TEXCOORD6.xyz;
					    u_xlat0.xyw = u_xlat0.xxx * vs_TEXCOORD5.xyz + u_xlat1.xyz;
					    u_xlat1.x = dot(vs_TEXCOORD4.xyz, vs_TEXCOORD4.xyz);
					    u_xlat1.x = inversesqrt(u_xlat1.x);
					    u_xlat1.xyz = u_xlat1.xxx * vs_TEXCOORD4.xyz;
					    u_xlat0.xyz = u_xlat0.zzz * u_xlat1.xyz + u_xlat0.xyw;
					    u_xlat15 = dot(u_xlat0.xyz, u_xlat0.xyz);
					    u_xlat15 = inversesqrt(u_xlat15);
					    u_xlat0.xyz = vec3(u_xlat15) * u_xlat0.xyz;
					    u_xlat2.xyz = (-vs_TEXCOORD3.xyz) + _WorldSpaceCameraPos.xyz;
					    u_xlat15 = dot(u_xlat2.xyz, u_xlat2.xyz);
					    u_xlat15 = inversesqrt(u_xlat15);
					    u_xlat3.xyz = vec3(u_xlat15) * u_xlat2.xyz;
					    u_xlat1.x = dot(u_xlat3.xyz, u_xlat1.xyz);
					    u_xlati6 = int((0.0<u_xlat1.x) ? 0xFFFFFFFFu : uint(0));
					    u_xlati1 = int((u_xlat1.x<0.0) ? 0xFFFFFFFFu : uint(0));
					    u_xlati1 = (-u_xlati6) + u_xlati1;
					    u_xlat1.x = float(u_xlati1);
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xxx;
					    u_xlat1.xyz = _WorldSpaceLightPos0.www * (-vs_TEXCOORD3.xyz) + _WorldSpaceLightPos0.xyz;
					    u_xlat16 = dot(u_xlat1.xyz, u_xlat1.xyz);
					    u_xlat16 = inversesqrt(u_xlat16);
					    u_xlat1.xyz = vec3(u_xlat16) * u_xlat1.xyz;
					    u_xlat2.xyz = u_xlat2.xyz * vec3(u_xlat15) + u_xlat1.xyz;
					    u_xlat15 = dot(u_xlat2.xyz, u_xlat2.xyz);
					    u_xlat15 = inversesqrt(u_xlat15);
					    u_xlat2.xyz = vec3(u_xlat15) * u_xlat2.xyz;
					    u_xlat0.w = dot(u_xlat0.xyz, u_xlat2.xyz);
					    u_xlat1.w = dot(u_xlat1.xyz, u_xlat2.xyz);
					    u_xlat1.x = dot(u_xlat0.xyz, u_xlat1.xyz);
					    u_xlat0.x = dot(u_xlat0.xyz, u_xlat3.xyz);
					    u_xlat0.yz = max(u_xlat1.xw, vec2(0.0, 0.0));
					    u_xlat0.xw = max(u_xlat0.xw, vec2(0.0, 0.0));
					    u_xlat1.x = log2(u_xlat0.w);
					    u_xlat15 = u_xlat0.w * u_xlat0.w;
					    u_xlat6.xyz = vec3(u_xlat15) * _LightColor0.xyz;
					    u_xlat15 = u_xlat1.x * 9.99999975e-05;
					    u_xlat15 = exp2(u_xlat15);
					    u_xlat15 = u_xlat15 * 0.318325758;
					    u_xlat1.x = u_xlat0.x * 0.202115417 + 0.797884583;
					    u_xlat2.x = u_xlat0.y * 0.202115417 + 0.797884583;
					    u_xlat1.x = u_xlat2.x * u_xlat1.x + 9.99999975e-06;
					    u_xlat1.x = float(1.0) / u_xlat1.x;
					    u_xlat1.x = u_xlat1.x * 0.25;
					    u_xlat1.x = u_xlat0.y * u_xlat1.x;
					    u_xlat15 = u_xlat15 * u_xlat1.x;
					    u_xlat15 = u_xlat15 * 0.616850257;
					    u_xlat1.xyz = vec3(u_xlat15) * u_xlat6.xyz;
					    u_xlat1.xyz = u_xlat1.xyz * _LightColor0.xyz;
					    u_xlat0.xw = (-u_xlat0.xz) + vec2(1.00001001, 1.0);
					    u_xlat16 = u_xlat0.w * u_xlat0.w;
					    u_xlat16 = u_xlat16 * u_xlat16;
					    u_xlat15 = u_xlat0.w * u_xlat16;
					    u_xlat2.xy = vs_TEXCOORD0.xy * _MainTexture_ST.xy + _MainTexture_ST.zw;
					    u_xlat2 = texture(_MainTexture, u_xlat2.xy);
					    u_xlat2.xyz = _Color.xyz * u_xlat2.xyz + vec3(vec3(_Shadows, _Shadows, _Shadows));
					    u_xlat2.xyz = u_xlat2.xyz + vec3(-1.0, -1.0, -1.0);
					    u_xlat2.xyz = clamp(u_xlat2.xyz, 0.0, 1.0);
					    u_xlat3.xyz = u_xlat2.xyz + vec3(-0.220916301, -0.220916301, -0.220916301);
					    u_xlat4.xy = vs_TEXCOORD0.xy * _Specular_ST.xy + _Specular_ST.zw;
					    u_xlat4 = texture(_Specular, u_xlat4.xy);
					    u_xlat16 = u_xlat4.x * 0.449999988;
					    u_xlat17 = (-u_xlat4.x) * 0.350587666 + 0.779083729;
					    u_xlat2.xyz = vec3(u_xlat17) * u_xlat2.xyz;
					    u_xlat3.xyz = vec3(u_xlat16) * u_xlat3.xyz + vec3(0.220916301, 0.220916301, 0.220916301);
					    u_xlat4.xyz = (-u_xlat3.xyz) + vec3(1.0, 1.0, 1.0);
					    u_xlat3.xyz = u_xlat4.xyz * vec3(u_xlat15) + u_xlat3.xyz;
					    u_xlat1.xyz = u_xlat1.xyz * u_xlat3.xyz;
					    u_xlat15 = u_xlat0.x * u_xlat0.x;
					    u_xlat15 = u_xlat15 * u_xlat15;
					    u_xlat0.x = u_xlat15 * u_xlat0.x;
					    u_xlat15 = u_xlat0.z + u_xlat0.z;
					    u_xlat10 = u_xlat15 * u_xlat0.z + -0.5;
					    u_xlat0.x = u_xlat10 * u_xlat0.x + 1.0;
					    u_xlat15 = (-u_xlat0.y) + 1.00001001;
					    u_xlat16 = u_xlat15 * u_xlat15;
					    u_xlat16 = u_xlat16 * u_xlat16;
					    u_xlat15 = u_xlat15 * u_xlat16;
					    u_xlat10 = u_xlat10 * u_xlat15 + 1.0;
					    u_xlat0.x = u_xlat0.x * u_xlat10;
					    u_xlat0.x = u_xlat0.y * u_xlat0.x;
					    u_xlat0.xyz = u_xlat0.xxx * _LightColor0.xyz;
					    SV_Target0.xyz = u_xlat0.xyz * u_xlat2.xyz + u_xlat1.xyz;
					    SV_Target0.w = 0.0;
					    return;
					}"
				}
				SubProgram "d3d11 " {
					Keywords { "SPOT" "DIRLIGHTMAP_COMBINED" "LIGHTMAP_OFF" "DYNAMICLIGHTMAP_OFF" }
					"ps_4_0
					
					#version 330
					#extension GL_ARB_explicit_attrib_location : require
					#extension GL_ARB_explicit_uniform_location : require
					
					#define HLSLCC_ENABLE_UNIFORM_BUFFERS 1
					#if HLSLCC_ENABLE_UNIFORM_BUFFERS
					#define UNITY_UNIFORM
					#else
					#define UNITY_UNIFORM uniform
					#endif
					#define UNITY_SUPPORTS_UNIFORM_LOCATION 1
					#if UNITY_SUPPORTS_UNIFORM_LOCATION
					#define UNITY_LOCATION(x) layout(location = x)
					#define UNITY_BINDING(x) layout(binding = x, std140)
					#else
					#define UNITY_LOCATION(x)
					#define UNITY_BINDING(x) layout(std140)
					#endif
					layout(std140) uniform PGlobals {
						vec4 unused_0_0[6];
						vec4 _LightColor0;
						vec4 unused_0_2;
						vec4 _MainTexture_ST;
						vec4 _Specular_ST;
						vec4 _NormalMap_ST;
						vec4 _Color;
						vec4 unused_0_7;
						float _NormalSharpness;
						float _Shadows;
					};
					layout(std140) uniform UnityPerCamera {
						vec4 unused_1_0[4];
						vec3 _WorldSpaceCameraPos;
						vec4 unused_1_2[4];
					};
					layout(std140) uniform UnityLighting {
						vec4 _WorldSpaceLightPos0;
						vec4 unused_2_1[47];
					};
					uniform  sampler2D _NormalMap;
					uniform  sampler2D _LightTexture0;
					uniform  sampler2D _LightTextureB0;
					uniform  sampler2D _MainTexture;
					uniform  sampler2D _Specular;
					in  vec2 vs_TEXCOORD0;
					in  vec4 vs_TEXCOORD3;
					in  vec3 vs_TEXCOORD4;
					in  vec3 vs_TEXCOORD5;
					in  vec3 vs_TEXCOORD6;
					in  vec4 vs_TEXCOORD7;
					layout(location = 0) out vec4 SV_Target0;
					vec4 u_xlat0;
					vec4 u_xlat1;
					int u_xlati1;
					vec4 u_xlat2;
					vec4 u_xlat3;
					vec3 u_xlat4;
					vec4 u_xlat5;
					vec3 u_xlat7;
					int u_xlati7;
					bool u_xlatb7;
					float u_xlat12;
					float u_xlat13;
					float u_xlat18;
					float u_xlat19;
					float u_xlat20;
					void main()
					{
					    u_xlat0.xy = vs_TEXCOORD0.xy * _NormalMap_ST.xy + _NormalMap_ST.zw;
					    u_xlat0 = texture(_NormalMap, u_xlat0.xy);
					    u_xlat0.x = u_xlat0.w * u_xlat0.x;
					    u_xlat0.xy = u_xlat0.xy * vec2(2.0, 2.0) + vec2(-1.0, -1.0);
					    u_xlat18 = dot(u_xlat0.xy, u_xlat0.xy);
					    u_xlat18 = min(u_xlat18, 1.0);
					    u_xlat18 = (-u_xlat18) + 1.0;
					    u_xlat0.z = sqrt(u_xlat18);
					    u_xlat18 = (-_NormalSharpness) + 1.0;
					    u_xlat0.xyz = u_xlat0.xyz / vec3(u_xlat18);
					    u_xlat0.xyz = clamp(u_xlat0.xyz, 0.0, 1.0);
					    u_xlat1.xyz = u_xlat0.yyy * vs_TEXCOORD6.xyz;
					    u_xlat0.xyw = u_xlat0.xxx * vs_TEXCOORD5.xyz + u_xlat1.xyz;
					    u_xlat1.x = dot(vs_TEXCOORD4.xyz, vs_TEXCOORD4.xyz);
					    u_xlat1.x = inversesqrt(u_xlat1.x);
					    u_xlat1.xyz = u_xlat1.xxx * vs_TEXCOORD4.xyz;
					    u_xlat0.xyz = u_xlat0.zzz * u_xlat1.xyz + u_xlat0.xyw;
					    u_xlat18 = dot(u_xlat0.xyz, u_xlat0.xyz);
					    u_xlat18 = inversesqrt(u_xlat18);
					    u_xlat0.xyz = vec3(u_xlat18) * u_xlat0.xyz;
					    u_xlat2.xyz = (-vs_TEXCOORD3.xyz) + _WorldSpaceCameraPos.xyz;
					    u_xlat18 = dot(u_xlat2.xyz, u_xlat2.xyz);
					    u_xlat18 = inversesqrt(u_xlat18);
					    u_xlat3.xyz = vec3(u_xlat18) * u_xlat2.xyz;
					    u_xlat1.x = dot(u_xlat3.xyz, u_xlat1.xyz);
					    u_xlati7 = int((0.0<u_xlat1.x) ? 0xFFFFFFFFu : uint(0));
					    u_xlati1 = int((u_xlat1.x<0.0) ? 0xFFFFFFFFu : uint(0));
					    u_xlati1 = (-u_xlati7) + u_xlati1;
					    u_xlat1.x = float(u_xlati1);
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xxx;
					    u_xlat1.xyz = _WorldSpaceLightPos0.www * (-vs_TEXCOORD3.xyz) + _WorldSpaceLightPos0.xyz;
					    u_xlat19 = dot(u_xlat1.xyz, u_xlat1.xyz);
					    u_xlat19 = inversesqrt(u_xlat19);
					    u_xlat1.xyz = vec3(u_xlat19) * u_xlat1.xyz;
					    u_xlat2.xyz = u_xlat2.xyz * vec3(u_xlat18) + u_xlat1.xyz;
					    u_xlat18 = dot(u_xlat2.xyz, u_xlat2.xyz);
					    u_xlat18 = inversesqrt(u_xlat18);
					    u_xlat2.xyz = vec3(u_xlat18) * u_xlat2.xyz;
					    u_xlat0.w = dot(u_xlat0.xyz, u_xlat2.xyz);
					    u_xlat1.w = dot(u_xlat1.xyz, u_xlat2.xyz);
					    u_xlat1.x = dot(u_xlat0.xyz, u_xlat1.xyz);
					    u_xlat0.x = dot(u_xlat0.xyz, u_xlat3.xyz);
					    u_xlat0.yz = max(u_xlat1.xw, vec2(0.0, 0.0));
					    u_xlat0.xw = max(u_xlat0.xw, vec2(0.0, 0.0));
					    u_xlat1.x = log2(u_xlat0.w);
					    u_xlat18 = u_xlat0.w * u_xlat0.w;
					    u_xlat1.x = u_xlat1.x * 9.99999975e-05;
					    u_xlat1.x = exp2(u_xlat1.x);
					    u_xlat7.x = u_xlat0.x * 0.202115417 + 0.797884583;
					    u_xlat13 = u_xlat0.y * 0.202115417 + 0.797884583;
					    u_xlat7.x = u_xlat13 * u_xlat7.x + 9.99999975e-06;
					    u_xlat1.y = float(1.0) / u_xlat7.x;
					    u_xlat1.xy = u_xlat1.xy * vec2(0.318325758, 0.25);
					    u_xlat7.x = u_xlat0.y * u_xlat1.y;
					    u_xlat1.x = u_xlat1.x * u_xlat7.x;
					    u_xlat1.x = u_xlat1.x * 0.616850257;
					    u_xlat7.xy = vs_TEXCOORD7.xy / vs_TEXCOORD7.ww;
					    u_xlat7.xy = u_xlat7.xy + vec2(0.5, 0.5);
					    u_xlat2 = texture(_LightTexture0, u_xlat7.xy);
					    u_xlatb7 = 0.0<vs_TEXCOORD7.z;
					    u_xlat7.x = u_xlatb7 ? 1.0 : float(0.0);
					    u_xlat7.x = u_xlat2.w * u_xlat7.x;
					    u_xlat13 = dot(vs_TEXCOORD7.xyz, vs_TEXCOORD7.xyz);
					    u_xlat2 = texture(_LightTextureB0, vec2(u_xlat13));
					    u_xlat7.x = u_xlat7.x * u_xlat2.x;
					    u_xlat7.xyz = u_xlat7.xxx * _LightColor0.xyz;
					    u_xlat2.xyz = vec3(u_xlat18) * u_xlat7.xyz;
					    u_xlat2.xyz = u_xlat1.xxx * u_xlat2.xyz;
					    u_xlat2.xyz = u_xlat2.xyz * _LightColor0.xyz;
					    u_xlat0.xw = (-u_xlat0.xz) + vec2(1.00001001, 1.0);
					    u_xlat1.x = u_xlat0.w * u_xlat0.w;
					    u_xlat1.x = u_xlat1.x * u_xlat1.x;
					    u_xlat18 = u_xlat0.w * u_xlat1.x;
					    u_xlat3.xy = vs_TEXCOORD0.xy * _MainTexture_ST.xy + _MainTexture_ST.zw;
					    u_xlat3 = texture(_MainTexture, u_xlat3.xy);
					    u_xlat3.xyz = _Color.xyz * u_xlat3.xyz + vec3(vec3(_Shadows, _Shadows, _Shadows));
					    u_xlat3.xyz = u_xlat3.xyz + vec3(-1.0, -1.0, -1.0);
					    u_xlat3.xyz = clamp(u_xlat3.xyz, 0.0, 1.0);
					    u_xlat4.xyz = u_xlat3.xyz + vec3(-0.220916301, -0.220916301, -0.220916301);
					    u_xlat5.xy = vs_TEXCOORD0.xy * _Specular_ST.xy + _Specular_ST.zw;
					    u_xlat5 = texture(_Specular, u_xlat5.xy);
					    u_xlat1.x = u_xlat5.x * 0.449999988;
					    u_xlat20 = (-u_xlat5.x) * 0.350587666 + 0.779083729;
					    u_xlat3.xyz = vec3(u_xlat20) * u_xlat3.xyz;
					    u_xlat4.xyz = u_xlat1.xxx * u_xlat4.xyz + vec3(0.220916301, 0.220916301, 0.220916301);
					    u_xlat5.xyz = (-u_xlat4.xyz) + vec3(1.0, 1.0, 1.0);
					    u_xlat4.xyz = u_xlat5.xyz * vec3(u_xlat18) + u_xlat4.xyz;
					    u_xlat2.xyz = u_xlat2.xyz * u_xlat4.xyz;
					    u_xlat18 = u_xlat0.x * u_xlat0.x;
					    u_xlat18 = u_xlat18 * u_xlat18;
					    u_xlat0.x = u_xlat18 * u_xlat0.x;
					    u_xlat18 = u_xlat0.z + u_xlat0.z;
					    u_xlat12 = u_xlat18 * u_xlat0.z + -0.5;
					    u_xlat0.x = u_xlat12 * u_xlat0.x + 1.0;
					    u_xlat18 = (-u_xlat0.y) + 1.00001001;
					    u_xlat1.x = u_xlat18 * u_xlat18;
					    u_xlat1.x = u_xlat1.x * u_xlat1.x;
					    u_xlat18 = u_xlat18 * u_xlat1.x;
					    u_xlat12 = u_xlat12 * u_xlat18 + 1.0;
					    u_xlat0.x = u_xlat0.x * u_xlat12;
					    u_xlat0.x = u_xlat0.y * u_xlat0.x;
					    u_xlat0.xyz = u_xlat7.xyz * u_xlat0.xxx;
					    SV_Target0.xyz = u_xlat0.xyz * u_xlat3.xyz + u_xlat2.xyz;
					    SV_Target0.w = 0.0;
					    return;
					}"
				}
				SubProgram "d3d11 " {
					Keywords { "POINT_COOKIE" "DIRLIGHTMAP_COMBINED" "LIGHTMAP_OFF" "DYNAMICLIGHTMAP_OFF" }
					"ps_4_0
					
					#version 330
					#extension GL_ARB_explicit_attrib_location : require
					#extension GL_ARB_explicit_uniform_location : require
					
					#define HLSLCC_ENABLE_UNIFORM_BUFFERS 1
					#if HLSLCC_ENABLE_UNIFORM_BUFFERS
					#define UNITY_UNIFORM
					#else
					#define UNITY_UNIFORM uniform
					#endif
					#define UNITY_SUPPORTS_UNIFORM_LOCATION 1
					#if UNITY_SUPPORTS_UNIFORM_LOCATION
					#define UNITY_LOCATION(x) layout(location = x)
					#define UNITY_BINDING(x) layout(binding = x, std140)
					#else
					#define UNITY_LOCATION(x)
					#define UNITY_BINDING(x) layout(std140)
					#endif
					layout(std140) uniform PGlobals {
						vec4 unused_0_0[6];
						vec4 _LightColor0;
						vec4 unused_0_2;
						vec4 _MainTexture_ST;
						vec4 _Specular_ST;
						vec4 _NormalMap_ST;
						vec4 _Color;
						vec4 unused_0_7;
						float _NormalSharpness;
						float _Shadows;
					};
					layout(std140) uniform UnityPerCamera {
						vec4 unused_1_0[4];
						vec3 _WorldSpaceCameraPos;
						vec4 unused_1_2[4];
					};
					layout(std140) uniform UnityLighting {
						vec4 _WorldSpaceLightPos0;
						vec4 unused_2_1[47];
					};
					uniform  sampler2D _NormalMap;
					uniform  sampler2D _LightTextureB0;
					uniform  samplerCube _LightTexture0;
					uniform  sampler2D _MainTexture;
					uniform  sampler2D _Specular;
					in  vec2 vs_TEXCOORD0;
					in  vec4 vs_TEXCOORD3;
					in  vec3 vs_TEXCOORD4;
					in  vec3 vs_TEXCOORD5;
					in  vec3 vs_TEXCOORD6;
					in  vec3 vs_TEXCOORD7;
					layout(location = 0) out vec4 SV_Target0;
					vec4 u_xlat0;
					vec4 u_xlat1;
					int u_xlati1;
					vec4 u_xlat2;
					vec4 u_xlat3;
					vec3 u_xlat4;
					vec4 u_xlat5;
					vec3 u_xlat7;
					int u_xlati7;
					float u_xlat12;
					float u_xlat13;
					float u_xlat18;
					float u_xlat19;
					float u_xlat20;
					void main()
					{
					    u_xlat0.xy = vs_TEXCOORD0.xy * _NormalMap_ST.xy + _NormalMap_ST.zw;
					    u_xlat0 = texture(_NormalMap, u_xlat0.xy);
					    u_xlat0.x = u_xlat0.w * u_xlat0.x;
					    u_xlat0.xy = u_xlat0.xy * vec2(2.0, 2.0) + vec2(-1.0, -1.0);
					    u_xlat18 = dot(u_xlat0.xy, u_xlat0.xy);
					    u_xlat18 = min(u_xlat18, 1.0);
					    u_xlat18 = (-u_xlat18) + 1.0;
					    u_xlat0.z = sqrt(u_xlat18);
					    u_xlat18 = (-_NormalSharpness) + 1.0;
					    u_xlat0.xyz = u_xlat0.xyz / vec3(u_xlat18);
					    u_xlat0.xyz = clamp(u_xlat0.xyz, 0.0, 1.0);
					    u_xlat1.xyz = u_xlat0.yyy * vs_TEXCOORD6.xyz;
					    u_xlat0.xyw = u_xlat0.xxx * vs_TEXCOORD5.xyz + u_xlat1.xyz;
					    u_xlat1.x = dot(vs_TEXCOORD4.xyz, vs_TEXCOORD4.xyz);
					    u_xlat1.x = inversesqrt(u_xlat1.x);
					    u_xlat1.xyz = u_xlat1.xxx * vs_TEXCOORD4.xyz;
					    u_xlat0.xyz = u_xlat0.zzz * u_xlat1.xyz + u_xlat0.xyw;
					    u_xlat18 = dot(u_xlat0.xyz, u_xlat0.xyz);
					    u_xlat18 = inversesqrt(u_xlat18);
					    u_xlat0.xyz = vec3(u_xlat18) * u_xlat0.xyz;
					    u_xlat2.xyz = (-vs_TEXCOORD3.xyz) + _WorldSpaceCameraPos.xyz;
					    u_xlat18 = dot(u_xlat2.xyz, u_xlat2.xyz);
					    u_xlat18 = inversesqrt(u_xlat18);
					    u_xlat3.xyz = vec3(u_xlat18) * u_xlat2.xyz;
					    u_xlat1.x = dot(u_xlat3.xyz, u_xlat1.xyz);
					    u_xlati7 = int((0.0<u_xlat1.x) ? 0xFFFFFFFFu : uint(0));
					    u_xlati1 = int((u_xlat1.x<0.0) ? 0xFFFFFFFFu : uint(0));
					    u_xlati1 = (-u_xlati7) + u_xlati1;
					    u_xlat1.x = float(u_xlati1);
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xxx;
					    u_xlat1.xyz = _WorldSpaceLightPos0.www * (-vs_TEXCOORD3.xyz) + _WorldSpaceLightPos0.xyz;
					    u_xlat19 = dot(u_xlat1.xyz, u_xlat1.xyz);
					    u_xlat19 = inversesqrt(u_xlat19);
					    u_xlat1.xyz = vec3(u_xlat19) * u_xlat1.xyz;
					    u_xlat2.xyz = u_xlat2.xyz * vec3(u_xlat18) + u_xlat1.xyz;
					    u_xlat18 = dot(u_xlat2.xyz, u_xlat2.xyz);
					    u_xlat18 = inversesqrt(u_xlat18);
					    u_xlat2.xyz = vec3(u_xlat18) * u_xlat2.xyz;
					    u_xlat0.w = dot(u_xlat0.xyz, u_xlat2.xyz);
					    u_xlat1.w = dot(u_xlat1.xyz, u_xlat2.xyz);
					    u_xlat1.x = dot(u_xlat0.xyz, u_xlat1.xyz);
					    u_xlat0.x = dot(u_xlat0.xyz, u_xlat3.xyz);
					    u_xlat0.yz = max(u_xlat1.xw, vec2(0.0, 0.0));
					    u_xlat0.xw = max(u_xlat0.xw, vec2(0.0, 0.0));
					    u_xlat1.x = log2(u_xlat0.w);
					    u_xlat18 = u_xlat0.w * u_xlat0.w;
					    u_xlat1.x = u_xlat1.x * 9.99999975e-05;
					    u_xlat1.x = exp2(u_xlat1.x);
					    u_xlat7.x = u_xlat0.x * 0.202115417 + 0.797884583;
					    u_xlat13 = u_xlat0.y * 0.202115417 + 0.797884583;
					    u_xlat7.x = u_xlat13 * u_xlat7.x + 9.99999975e-06;
					    u_xlat1.y = float(1.0) / u_xlat7.x;
					    u_xlat1.xy = u_xlat1.xy * vec2(0.318325758, 0.25);
					    u_xlat7.x = u_xlat0.y * u_xlat1.y;
					    u_xlat1.x = u_xlat1.x * u_xlat7.x;
					    u_xlat1.x = u_xlat1.x * 0.616850257;
					    u_xlat7.x = dot(vs_TEXCOORD7.xyz, vs_TEXCOORD7.xyz);
					    u_xlat2 = texture(_LightTextureB0, u_xlat7.xx);
					    u_xlat3 = texture(_LightTexture0, vs_TEXCOORD7.xyz);
					    u_xlat7.x = u_xlat2.x * u_xlat3.w;
					    u_xlat7.xyz = u_xlat7.xxx * _LightColor0.xyz;
					    u_xlat2.xyz = vec3(u_xlat18) * u_xlat7.xyz;
					    u_xlat2.xyz = u_xlat1.xxx * u_xlat2.xyz;
					    u_xlat2.xyz = u_xlat2.xyz * _LightColor0.xyz;
					    u_xlat0.xw = (-u_xlat0.xz) + vec2(1.00001001, 1.0);
					    u_xlat1.x = u_xlat0.w * u_xlat0.w;
					    u_xlat1.x = u_xlat1.x * u_xlat1.x;
					    u_xlat18 = u_xlat0.w * u_xlat1.x;
					    u_xlat3.xy = vs_TEXCOORD0.xy * _MainTexture_ST.xy + _MainTexture_ST.zw;
					    u_xlat3 = texture(_MainTexture, u_xlat3.xy);
					    u_xlat3.xyz = _Color.xyz * u_xlat3.xyz + vec3(vec3(_Shadows, _Shadows, _Shadows));
					    u_xlat3.xyz = u_xlat3.xyz + vec3(-1.0, -1.0, -1.0);
					    u_xlat3.xyz = clamp(u_xlat3.xyz, 0.0, 1.0);
					    u_xlat4.xyz = u_xlat3.xyz + vec3(-0.220916301, -0.220916301, -0.220916301);
					    u_xlat5.xy = vs_TEXCOORD0.xy * _Specular_ST.xy + _Specular_ST.zw;
					    u_xlat5 = texture(_Specular, u_xlat5.xy);
					    u_xlat1.x = u_xlat5.x * 0.449999988;
					    u_xlat20 = (-u_xlat5.x) * 0.350587666 + 0.779083729;
					    u_xlat3.xyz = vec3(u_xlat20) * u_xlat3.xyz;
					    u_xlat4.xyz = u_xlat1.xxx * u_xlat4.xyz + vec3(0.220916301, 0.220916301, 0.220916301);
					    u_xlat5.xyz = (-u_xlat4.xyz) + vec3(1.0, 1.0, 1.0);
					    u_xlat4.xyz = u_xlat5.xyz * vec3(u_xlat18) + u_xlat4.xyz;
					    u_xlat2.xyz = u_xlat2.xyz * u_xlat4.xyz;
					    u_xlat18 = u_xlat0.x * u_xlat0.x;
					    u_xlat18 = u_xlat18 * u_xlat18;
					    u_xlat0.x = u_xlat18 * u_xlat0.x;
					    u_xlat18 = u_xlat0.z + u_xlat0.z;
					    u_xlat12 = u_xlat18 * u_xlat0.z + -0.5;
					    u_xlat0.x = u_xlat12 * u_xlat0.x + 1.0;
					    u_xlat18 = (-u_xlat0.y) + 1.00001001;
					    u_xlat1.x = u_xlat18 * u_xlat18;
					    u_xlat1.x = u_xlat1.x * u_xlat1.x;
					    u_xlat18 = u_xlat18 * u_xlat1.x;
					    u_xlat12 = u_xlat12 * u_xlat18 + 1.0;
					    u_xlat0.x = u_xlat0.x * u_xlat12;
					    u_xlat0.x = u_xlat0.y * u_xlat0.x;
					    u_xlat0.xyz = u_xlat7.xyz * u_xlat0.xxx;
					    SV_Target0.xyz = u_xlat0.xyz * u_xlat3.xyz + u_xlat2.xyz;
					    SV_Target0.w = 0.0;
					    return;
					}"
				}
				SubProgram "d3d11 " {
					Keywords { "DIRECTIONAL_COOKIE" "DIRLIGHTMAP_COMBINED" "LIGHTMAP_OFF" "DYNAMICLIGHTMAP_OFF" }
					"ps_4_0
					
					#version 330
					#extension GL_ARB_explicit_attrib_location : require
					#extension GL_ARB_explicit_uniform_location : require
					
					#define HLSLCC_ENABLE_UNIFORM_BUFFERS 1
					#if HLSLCC_ENABLE_UNIFORM_BUFFERS
					#define UNITY_UNIFORM
					#else
					#define UNITY_UNIFORM uniform
					#endif
					#define UNITY_SUPPORTS_UNIFORM_LOCATION 1
					#if UNITY_SUPPORTS_UNIFORM_LOCATION
					#define UNITY_LOCATION(x) layout(location = x)
					#define UNITY_BINDING(x) layout(binding = x, std140)
					#else
					#define UNITY_LOCATION(x)
					#define UNITY_BINDING(x) layout(std140)
					#endif
					layout(std140) uniform PGlobals {
						vec4 unused_0_0[6];
						vec4 _LightColor0;
						vec4 unused_0_2;
						vec4 _MainTexture_ST;
						vec4 _Specular_ST;
						vec4 _NormalMap_ST;
						vec4 _Color;
						vec4 unused_0_7;
						float _NormalSharpness;
						float _Shadows;
					};
					layout(std140) uniform UnityPerCamera {
						vec4 unused_1_0[4];
						vec3 _WorldSpaceCameraPos;
						vec4 unused_1_2[4];
					};
					layout(std140) uniform UnityLighting {
						vec4 _WorldSpaceLightPos0;
						vec4 unused_2_1[47];
					};
					uniform  sampler2D _NormalMap;
					uniform  sampler2D _LightTexture0;
					uniform  sampler2D _MainTexture;
					uniform  sampler2D _Specular;
					in  vec2 vs_TEXCOORD0;
					in  vec2 vs_TEXCOORD7;
					in  vec4 vs_TEXCOORD3;
					in  vec3 vs_TEXCOORD4;
					in  vec3 vs_TEXCOORD5;
					in  vec3 vs_TEXCOORD6;
					layout(location = 0) out vec4 SV_Target0;
					vec4 u_xlat0;
					vec4 u_xlat1;
					int u_xlati1;
					vec4 u_xlat2;
					vec4 u_xlat3;
					vec3 u_xlat4;
					vec4 u_xlat5;
					vec3 u_xlat7;
					int u_xlati7;
					float u_xlat12;
					float u_xlat13;
					float u_xlat18;
					float u_xlat19;
					float u_xlat20;
					void main()
					{
					    u_xlat0.xy = vs_TEXCOORD0.xy * _NormalMap_ST.xy + _NormalMap_ST.zw;
					    u_xlat0 = texture(_NormalMap, u_xlat0.xy);
					    u_xlat0.x = u_xlat0.w * u_xlat0.x;
					    u_xlat0.xy = u_xlat0.xy * vec2(2.0, 2.0) + vec2(-1.0, -1.0);
					    u_xlat18 = dot(u_xlat0.xy, u_xlat0.xy);
					    u_xlat18 = min(u_xlat18, 1.0);
					    u_xlat18 = (-u_xlat18) + 1.0;
					    u_xlat0.z = sqrt(u_xlat18);
					    u_xlat18 = (-_NormalSharpness) + 1.0;
					    u_xlat0.xyz = u_xlat0.xyz / vec3(u_xlat18);
					    u_xlat0.xyz = clamp(u_xlat0.xyz, 0.0, 1.0);
					    u_xlat1.xyz = u_xlat0.yyy * vs_TEXCOORD6.xyz;
					    u_xlat0.xyw = u_xlat0.xxx * vs_TEXCOORD5.xyz + u_xlat1.xyz;
					    u_xlat1.x = dot(vs_TEXCOORD4.xyz, vs_TEXCOORD4.xyz);
					    u_xlat1.x = inversesqrt(u_xlat1.x);
					    u_xlat1.xyz = u_xlat1.xxx * vs_TEXCOORD4.xyz;
					    u_xlat0.xyz = u_xlat0.zzz * u_xlat1.xyz + u_xlat0.xyw;
					    u_xlat18 = dot(u_xlat0.xyz, u_xlat0.xyz);
					    u_xlat18 = inversesqrt(u_xlat18);
					    u_xlat0.xyz = vec3(u_xlat18) * u_xlat0.xyz;
					    u_xlat2.xyz = (-vs_TEXCOORD3.xyz) + _WorldSpaceCameraPos.xyz;
					    u_xlat18 = dot(u_xlat2.xyz, u_xlat2.xyz);
					    u_xlat18 = inversesqrt(u_xlat18);
					    u_xlat3.xyz = vec3(u_xlat18) * u_xlat2.xyz;
					    u_xlat1.x = dot(u_xlat3.xyz, u_xlat1.xyz);
					    u_xlati7 = int((0.0<u_xlat1.x) ? 0xFFFFFFFFu : uint(0));
					    u_xlati1 = int((u_xlat1.x<0.0) ? 0xFFFFFFFFu : uint(0));
					    u_xlati1 = (-u_xlati7) + u_xlati1;
					    u_xlat1.x = float(u_xlati1);
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xxx;
					    u_xlat1.xyz = _WorldSpaceLightPos0.www * (-vs_TEXCOORD3.xyz) + _WorldSpaceLightPos0.xyz;
					    u_xlat19 = dot(u_xlat1.xyz, u_xlat1.xyz);
					    u_xlat19 = inversesqrt(u_xlat19);
					    u_xlat1.xyz = vec3(u_xlat19) * u_xlat1.xyz;
					    u_xlat2.xyz = u_xlat2.xyz * vec3(u_xlat18) + u_xlat1.xyz;
					    u_xlat18 = dot(u_xlat2.xyz, u_xlat2.xyz);
					    u_xlat18 = inversesqrt(u_xlat18);
					    u_xlat2.xyz = vec3(u_xlat18) * u_xlat2.xyz;
					    u_xlat0.w = dot(u_xlat0.xyz, u_xlat2.xyz);
					    u_xlat1.w = dot(u_xlat1.xyz, u_xlat2.xyz);
					    u_xlat1.x = dot(u_xlat0.xyz, u_xlat1.xyz);
					    u_xlat0.x = dot(u_xlat0.xyz, u_xlat3.xyz);
					    u_xlat0.yz = max(u_xlat1.xw, vec2(0.0, 0.0));
					    u_xlat0.xw = max(u_xlat0.xw, vec2(0.0, 0.0));
					    u_xlat1.x = log2(u_xlat0.w);
					    u_xlat18 = u_xlat0.w * u_xlat0.w;
					    u_xlat1.x = u_xlat1.x * 9.99999975e-05;
					    u_xlat1.x = exp2(u_xlat1.x);
					    u_xlat7.x = u_xlat0.x * 0.202115417 + 0.797884583;
					    u_xlat13 = u_xlat0.y * 0.202115417 + 0.797884583;
					    u_xlat7.x = u_xlat13 * u_xlat7.x + 9.99999975e-06;
					    u_xlat1.y = float(1.0) / u_xlat7.x;
					    u_xlat1.xy = u_xlat1.xy * vec2(0.318325758, 0.25);
					    u_xlat7.x = u_xlat0.y * u_xlat1.y;
					    u_xlat1.x = u_xlat1.x * u_xlat7.x;
					    u_xlat1.x = u_xlat1.x * 0.616850257;
					    u_xlat2 = texture(_LightTexture0, vs_TEXCOORD7.xy);
					    u_xlat7.xyz = u_xlat2.www * _LightColor0.xyz;
					    u_xlat2.xyz = vec3(u_xlat18) * u_xlat7.xyz;
					    u_xlat2.xyz = u_xlat1.xxx * u_xlat2.xyz;
					    u_xlat2.xyz = u_xlat2.xyz * _LightColor0.xyz;
					    u_xlat0.xw = (-u_xlat0.xz) + vec2(1.00001001, 1.0);
					    u_xlat1.x = u_xlat0.w * u_xlat0.w;
					    u_xlat1.x = u_xlat1.x * u_xlat1.x;
					    u_xlat18 = u_xlat0.w * u_xlat1.x;
					    u_xlat3.xy = vs_TEXCOORD0.xy * _MainTexture_ST.xy + _MainTexture_ST.zw;
					    u_xlat3 = texture(_MainTexture, u_xlat3.xy);
					    u_xlat3.xyz = _Color.xyz * u_xlat3.xyz + vec3(vec3(_Shadows, _Shadows, _Shadows));
					    u_xlat3.xyz = u_xlat3.xyz + vec3(-1.0, -1.0, -1.0);
					    u_xlat3.xyz = clamp(u_xlat3.xyz, 0.0, 1.0);
					    u_xlat4.xyz = u_xlat3.xyz + vec3(-0.220916301, -0.220916301, -0.220916301);
					    u_xlat5.xy = vs_TEXCOORD0.xy * _Specular_ST.xy + _Specular_ST.zw;
					    u_xlat5 = texture(_Specular, u_xlat5.xy);
					    u_xlat1.x = u_xlat5.x * 0.449999988;
					    u_xlat20 = (-u_xlat5.x) * 0.350587666 + 0.779083729;
					    u_xlat3.xyz = vec3(u_xlat20) * u_xlat3.xyz;
					    u_xlat4.xyz = u_xlat1.xxx * u_xlat4.xyz + vec3(0.220916301, 0.220916301, 0.220916301);
					    u_xlat5.xyz = (-u_xlat4.xyz) + vec3(1.0, 1.0, 1.0);
					    u_xlat4.xyz = u_xlat5.xyz * vec3(u_xlat18) + u_xlat4.xyz;
					    u_xlat2.xyz = u_xlat2.xyz * u_xlat4.xyz;
					    u_xlat18 = u_xlat0.x * u_xlat0.x;
					    u_xlat18 = u_xlat18 * u_xlat18;
					    u_xlat0.x = u_xlat18 * u_xlat0.x;
					    u_xlat18 = u_xlat0.z + u_xlat0.z;
					    u_xlat12 = u_xlat18 * u_xlat0.z + -0.5;
					    u_xlat0.x = u_xlat12 * u_xlat0.x + 1.0;
					    u_xlat18 = (-u_xlat0.y) + 1.00001001;
					    u_xlat1.x = u_xlat18 * u_xlat18;
					    u_xlat1.x = u_xlat1.x * u_xlat1.x;
					    u_xlat18 = u_xlat18 * u_xlat1.x;
					    u_xlat12 = u_xlat12 * u_xlat18 + 1.0;
					    u_xlat0.x = u_xlat0.x * u_xlat12;
					    u_xlat0.x = u_xlat0.y * u_xlat0.x;
					    u_xlat0.xyz = u_xlat7.xyz * u_xlat0.xxx;
					    SV_Target0.xyz = u_xlat0.xyz * u_xlat3.xyz + u_xlat2.xyz;
					    SV_Target0.w = 0.0;
					    return;
					}"
				}
				SubProgram "d3d11 " {
					Keywords { "SPOT" "SHADOWS_DEPTH" "DIRLIGHTMAP_COMBINED" "LIGHTMAP_OFF" "DYNAMICLIGHTMAP_OFF" }
					"ps_4_0
					
					#version 330
					#extension GL_ARB_explicit_attrib_location : require
					#extension GL_ARB_explicit_uniform_location : require
					
					#define HLSLCC_ENABLE_UNIFORM_BUFFERS 1
					#if HLSLCC_ENABLE_UNIFORM_BUFFERS
					#define UNITY_UNIFORM
					#else
					#define UNITY_UNIFORM uniform
					#endif
					#define UNITY_SUPPORTS_UNIFORM_LOCATION 1
					#if UNITY_SUPPORTS_UNIFORM_LOCATION
					#define UNITY_LOCATION(x) layout(location = x)
					#define UNITY_BINDING(x) layout(binding = x, std140)
					#else
					#define UNITY_LOCATION(x)
					#define UNITY_BINDING(x) layout(std140)
					#endif
					layout(std140) uniform PGlobals {
						vec4 unused_0_0[6];
						vec4 _LightColor0;
						vec4 unused_0_2;
						vec4 _MainTexture_ST;
						vec4 _Specular_ST;
						vec4 _NormalMap_ST;
						vec4 _Color;
						vec4 unused_0_7;
						float _NormalSharpness;
						float _Shadows;
					};
					layout(std140) uniform UnityPerCamera {
						vec4 unused_1_0[4];
						vec3 _WorldSpaceCameraPos;
						vec4 unused_1_2[4];
					};
					layout(std140) uniform UnityLighting {
						vec4 _WorldSpaceLightPos0;
						vec4 unused_2_1[47];
					};
					layout(std140) uniform UnityShadows {
						vec4 unused_3_0[24];
						vec4 _LightShadowData;
						vec4 unused_3_2;
					};
					uniform  sampler2D _NormalMap;
					uniform  sampler2D _LightTexture0;
					uniform  sampler2D _LightTextureB0;
					uniform  sampler2D _MainTexture;
					uniform  sampler2D _Specular;
					uniform  sampler2D _ShadowMapTexture;
					uniform  sampler2DShadow hlslcc_zcmp_ShadowMapTexture;
					in  vec2 vs_TEXCOORD0;
					in  vec4 vs_TEXCOORD3;
					in  vec3 vs_TEXCOORD4;
					in  vec3 vs_TEXCOORD5;
					in  vec3 vs_TEXCOORD6;
					in  vec4 vs_TEXCOORD7;
					in  vec4 vs_TEXCOORD8;
					layout(location = 0) out vec4 SV_Target0;
					vec4 u_xlat0;
					vec4 u_xlat1;
					int u_xlati1;
					vec4 u_xlat2;
					vec4 u_xlat3;
					vec3 u_xlat4;
					vec4 u_xlat5;
					vec3 u_xlat7;
					int u_xlati7;
					bool u_xlatb7;
					float u_xlat12;
					float u_xlat13;
					float u_xlat18;
					float u_xlat19;
					float u_xlat20;
					void main()
					{
					    u_xlat0.xy = vs_TEXCOORD0.xy * _NormalMap_ST.xy + _NormalMap_ST.zw;
					    u_xlat0 = texture(_NormalMap, u_xlat0.xy);
					    u_xlat0.x = u_xlat0.w * u_xlat0.x;
					    u_xlat0.xy = u_xlat0.xy * vec2(2.0, 2.0) + vec2(-1.0, -1.0);
					    u_xlat18 = dot(u_xlat0.xy, u_xlat0.xy);
					    u_xlat18 = min(u_xlat18, 1.0);
					    u_xlat18 = (-u_xlat18) + 1.0;
					    u_xlat0.z = sqrt(u_xlat18);
					    u_xlat18 = (-_NormalSharpness) + 1.0;
					    u_xlat0.xyz = u_xlat0.xyz / vec3(u_xlat18);
					    u_xlat0.xyz = clamp(u_xlat0.xyz, 0.0, 1.0);
					    u_xlat1.xyz = u_xlat0.yyy * vs_TEXCOORD6.xyz;
					    u_xlat0.xyw = u_xlat0.xxx * vs_TEXCOORD5.xyz + u_xlat1.xyz;
					    u_xlat1.x = dot(vs_TEXCOORD4.xyz, vs_TEXCOORD4.xyz);
					    u_xlat1.x = inversesqrt(u_xlat1.x);
					    u_xlat1.xyz = u_xlat1.xxx * vs_TEXCOORD4.xyz;
					    u_xlat0.xyz = u_xlat0.zzz * u_xlat1.xyz + u_xlat0.xyw;
					    u_xlat18 = dot(u_xlat0.xyz, u_xlat0.xyz);
					    u_xlat18 = inversesqrt(u_xlat18);
					    u_xlat0.xyz = vec3(u_xlat18) * u_xlat0.xyz;
					    u_xlat2.xyz = (-vs_TEXCOORD3.xyz) + _WorldSpaceCameraPos.xyz;
					    u_xlat18 = dot(u_xlat2.xyz, u_xlat2.xyz);
					    u_xlat18 = inversesqrt(u_xlat18);
					    u_xlat3.xyz = vec3(u_xlat18) * u_xlat2.xyz;
					    u_xlat1.x = dot(u_xlat3.xyz, u_xlat1.xyz);
					    u_xlati7 = int((0.0<u_xlat1.x) ? 0xFFFFFFFFu : uint(0));
					    u_xlati1 = int((u_xlat1.x<0.0) ? 0xFFFFFFFFu : uint(0));
					    u_xlati1 = (-u_xlati7) + u_xlati1;
					    u_xlat1.x = float(u_xlati1);
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xxx;
					    u_xlat1.xyz = _WorldSpaceLightPos0.www * (-vs_TEXCOORD3.xyz) + _WorldSpaceLightPos0.xyz;
					    u_xlat19 = dot(u_xlat1.xyz, u_xlat1.xyz);
					    u_xlat19 = inversesqrt(u_xlat19);
					    u_xlat1.xyz = vec3(u_xlat19) * u_xlat1.xyz;
					    u_xlat2.xyz = u_xlat2.xyz * vec3(u_xlat18) + u_xlat1.xyz;
					    u_xlat18 = dot(u_xlat2.xyz, u_xlat2.xyz);
					    u_xlat18 = inversesqrt(u_xlat18);
					    u_xlat2.xyz = vec3(u_xlat18) * u_xlat2.xyz;
					    u_xlat0.w = dot(u_xlat0.xyz, u_xlat2.xyz);
					    u_xlat1.w = dot(u_xlat1.xyz, u_xlat2.xyz);
					    u_xlat1.x = dot(u_xlat0.xyz, u_xlat1.xyz);
					    u_xlat0.x = dot(u_xlat0.xyz, u_xlat3.xyz);
					    u_xlat0.yz = max(u_xlat1.xw, vec2(0.0, 0.0));
					    u_xlat0.xw = max(u_xlat0.xw, vec2(0.0, 0.0));
					    u_xlat1.x = log2(u_xlat0.w);
					    u_xlat18 = u_xlat0.w * u_xlat0.w;
					    u_xlat1.x = u_xlat1.x * 9.99999975e-05;
					    u_xlat1.x = exp2(u_xlat1.x);
					    u_xlat7.x = u_xlat0.x * 0.202115417 + 0.797884583;
					    u_xlat13 = u_xlat0.y * 0.202115417 + 0.797884583;
					    u_xlat7.x = u_xlat13 * u_xlat7.x + 9.99999975e-06;
					    u_xlat1.y = float(1.0) / u_xlat7.x;
					    u_xlat1.xy = u_xlat1.xy * vec2(0.318325758, 0.25);
					    u_xlat7.x = u_xlat0.y * u_xlat1.y;
					    u_xlat1.x = u_xlat1.x * u_xlat7.x;
					    u_xlat1.x = u_xlat1.x * 0.616850257;
					    u_xlat7.xy = vs_TEXCOORD7.xy / vs_TEXCOORD7.ww;
					    u_xlat7.xy = u_xlat7.xy + vec2(0.5, 0.5);
					    u_xlat2 = texture(_LightTexture0, u_xlat7.xy);
					    u_xlatb7 = 0.0<vs_TEXCOORD7.z;
					    u_xlat7.x = u_xlatb7 ? 1.0 : float(0.0);
					    u_xlat7.x = u_xlat2.w * u_xlat7.x;
					    u_xlat13 = dot(vs_TEXCOORD7.xyz, vs_TEXCOORD7.xyz);
					    u_xlat2 = texture(_LightTextureB0, vec2(u_xlat13));
					    u_xlat7.x = u_xlat7.x * u_xlat2.x;
					    u_xlat2.xyz = vs_TEXCOORD8.xyz / vs_TEXCOORD8.www;
					    vec3 txVec0 = vec3(u_xlat2.xy,u_xlat2.z);
					    u_xlat13 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec0, 0.0);
					    u_xlat19 = (-_LightShadowData.x) + 1.0;
					    u_xlat13 = u_xlat13 * u_xlat19 + _LightShadowData.x;
					    u_xlat7.x = u_xlat13 * u_xlat7.x;
					    u_xlat7.xyz = u_xlat7.xxx * _LightColor0.xyz;
					    u_xlat2.xyz = vec3(u_xlat18) * u_xlat7.xyz;
					    u_xlat2.xyz = u_xlat1.xxx * u_xlat2.xyz;
					    u_xlat2.xyz = u_xlat2.xyz * _LightColor0.xyz;
					    u_xlat0.xw = (-u_xlat0.xz) + vec2(1.00001001, 1.0);
					    u_xlat1.x = u_xlat0.w * u_xlat0.w;
					    u_xlat1.x = u_xlat1.x * u_xlat1.x;
					    u_xlat18 = u_xlat0.w * u_xlat1.x;
					    u_xlat3.xy = vs_TEXCOORD0.xy * _MainTexture_ST.xy + _MainTexture_ST.zw;
					    u_xlat3 = texture(_MainTexture, u_xlat3.xy);
					    u_xlat3.xyz = _Color.xyz * u_xlat3.xyz + vec3(vec3(_Shadows, _Shadows, _Shadows));
					    u_xlat3.xyz = u_xlat3.xyz + vec3(-1.0, -1.0, -1.0);
					    u_xlat3.xyz = clamp(u_xlat3.xyz, 0.0, 1.0);
					    u_xlat4.xyz = u_xlat3.xyz + vec3(-0.220916301, -0.220916301, -0.220916301);
					    u_xlat5.xy = vs_TEXCOORD0.xy * _Specular_ST.xy + _Specular_ST.zw;
					    u_xlat5 = texture(_Specular, u_xlat5.xy);
					    u_xlat1.x = u_xlat5.x * 0.449999988;
					    u_xlat20 = (-u_xlat5.x) * 0.350587666 + 0.779083729;
					    u_xlat3.xyz = vec3(u_xlat20) * u_xlat3.xyz;
					    u_xlat4.xyz = u_xlat1.xxx * u_xlat4.xyz + vec3(0.220916301, 0.220916301, 0.220916301);
					    u_xlat5.xyz = (-u_xlat4.xyz) + vec3(1.0, 1.0, 1.0);
					    u_xlat4.xyz = u_xlat5.xyz * vec3(u_xlat18) + u_xlat4.xyz;
					    u_xlat2.xyz = u_xlat2.xyz * u_xlat4.xyz;
					    u_xlat18 = u_xlat0.x * u_xlat0.x;
					    u_xlat18 = u_xlat18 * u_xlat18;
					    u_xlat0.x = u_xlat18 * u_xlat0.x;
					    u_xlat18 = u_xlat0.z + u_xlat0.z;
					    u_xlat12 = u_xlat18 * u_xlat0.z + -0.5;
					    u_xlat0.x = u_xlat12 * u_xlat0.x + 1.0;
					    u_xlat18 = (-u_xlat0.y) + 1.00001001;
					    u_xlat1.x = u_xlat18 * u_xlat18;
					    u_xlat1.x = u_xlat1.x * u_xlat1.x;
					    u_xlat18 = u_xlat18 * u_xlat1.x;
					    u_xlat12 = u_xlat12 * u_xlat18 + 1.0;
					    u_xlat0.x = u_xlat0.x * u_xlat12;
					    u_xlat0.x = u_xlat0.y * u_xlat0.x;
					    u_xlat0.xyz = u_xlat7.xyz * u_xlat0.xxx;
					    SV_Target0.xyz = u_xlat0.xyz * u_xlat3.xyz + u_xlat2.xyz;
					    SV_Target0.w = 0.0;
					    return;
					}"
				}
				SubProgram "d3d11 " {
					Keywords { "SPOT" "SHADOWS_DEPTH" "SHADOWS_SOFT" "DIRLIGHTMAP_COMBINED" "LIGHTMAP_OFF" "DYNAMICLIGHTMAP_OFF" }
					"ps_4_0
					
					#version 330
					#extension GL_ARB_explicit_attrib_location : require
					#extension GL_ARB_explicit_uniform_location : require
					
					#define HLSLCC_ENABLE_UNIFORM_BUFFERS 1
					#if HLSLCC_ENABLE_UNIFORM_BUFFERS
					#define UNITY_UNIFORM
					#else
					#define UNITY_UNIFORM uniform
					#endif
					#define UNITY_SUPPORTS_UNIFORM_LOCATION 1
					#if UNITY_SUPPORTS_UNIFORM_LOCATION
					#define UNITY_LOCATION(x) layout(location = x)
					#define UNITY_BINDING(x) layout(binding = x, std140)
					#else
					#define UNITY_LOCATION(x)
					#define UNITY_BINDING(x) layout(std140)
					#endif
					layout(std140) uniform PGlobals {
						vec4 unused_0_0[6];
						vec4 _ShadowMapTexture_TexelSize;
						vec4 unused_0_2[4];
						vec4 _LightColor0;
						vec4 unused_0_4;
						vec4 _MainTexture_ST;
						vec4 _Specular_ST;
						vec4 _NormalMap_ST;
						vec4 _Color;
						vec4 unused_0_9;
						float _NormalSharpness;
						float _Shadows;
					};
					layout(std140) uniform UnityPerCamera {
						vec4 unused_1_0[4];
						vec3 _WorldSpaceCameraPos;
						vec4 unused_1_2[4];
					};
					layout(std140) uniform UnityLighting {
						vec4 _WorldSpaceLightPos0;
						vec4 unused_2_1[47];
					};
					layout(std140) uniform UnityShadows {
						vec4 unused_3_0[24];
						vec4 _LightShadowData;
						vec4 unused_3_2;
					};
					uniform  sampler2D _NormalMap;
					uniform  sampler2D _LightTexture0;
					uniform  sampler2D _LightTextureB0;
					uniform  sampler2D _MainTexture;
					uniform  sampler2D _Specular;
					uniform  sampler2D _ShadowMapTexture;
					uniform  sampler2DShadow hlslcc_zcmp_ShadowMapTexture;
					in  vec2 vs_TEXCOORD0;
					in  vec4 vs_TEXCOORD3;
					in  vec3 vs_TEXCOORD4;
					in  vec3 vs_TEXCOORD5;
					in  vec3 vs_TEXCOORD6;
					in  vec4 vs_TEXCOORD7;
					in  vec4 vs_TEXCOORD8;
					layout(location = 0) out vec4 SV_Target0;
					vec3 u_xlat0;
					vec4 u_xlat1;
					vec4 u_xlat2;
					int u_xlati2;
					vec4 u_xlat3;
					vec4 u_xlat4;
					vec4 u_xlat5;
					vec2 u_xlat6;
					bool u_xlatb6;
					float u_xlat7;
					float u_xlat12;
					vec2 u_xlat13;
					float u_xlat18;
					float u_xlat19;
					int u_xlati19;
					float u_xlat20;
					void main()
					{
					    u_xlat0.xyz = vs_TEXCOORD8.xyz / vs_TEXCOORD8.www;
					    u_xlat1.xy = u_xlat0.xy * _ShadowMapTexture_TexelSize.zw + vec2(0.5, 0.5);
					    u_xlat1.xy = floor(u_xlat1.xy);
					    u_xlat0.xy = u_xlat0.xy * _ShadowMapTexture_TexelSize.zw + (-u_xlat1.xy);
					    u_xlat13.xy = (-u_xlat0.xy) + vec2(1.0, 1.0);
					    u_xlat2.xy = min(u_xlat0.xy, vec2(0.0, 0.0));
					    u_xlat2.xy = (-u_xlat2.xy) * u_xlat2.xy + u_xlat13.xy;
					    u_xlat3.y = u_xlat2.x;
					    u_xlat13.xy = max(u_xlat0.xy, vec2(0.0, 0.0));
					    u_xlat4 = u_xlat0.xxyy + vec4(0.5, 1.0, 0.5, 1.0);
					    u_xlat2.xz = (-u_xlat13.xy) * u_xlat13.xy + u_xlat4.yw;
					    u_xlat13.xy = u_xlat4.xz * u_xlat4.xz;
					    u_xlat3.z = u_xlat2.x;
					    u_xlat0.xy = u_xlat13.xy * vec2(0.5, 0.5) + (-u_xlat0.xy);
					    u_xlat3.x = u_xlat0.x;
					    u_xlat2.x = u_xlat0.y;
					    u_xlat3.w = u_xlat13.x;
					    u_xlat2.w = u_xlat13.y;
					    u_xlat2 = u_xlat2 * vec4(0.444440007, 0.444440007, 0.444440007, 0.222220004);
					    u_xlat3 = u_xlat3 * vec4(0.444440007, 0.444440007, 0.444440007, 0.222220004);
					    u_xlat4 = u_xlat3.ywyw + u_xlat3.xzxz;
					    u_xlat0.xy = u_xlat3.yw / u_xlat4.zw;
					    u_xlat0.xy = u_xlat0.xy + vec2(-1.5, 0.5);
					    u_xlat3.xy = u_xlat0.xy * _ShadowMapTexture_TexelSize.xx;
					    u_xlat5 = u_xlat2.yyww + u_xlat2.xxzz;
					    u_xlat0.xy = u_xlat2.yw / u_xlat5.yw;
					    u_xlat2 = u_xlat4 * u_xlat5;
					    u_xlat0.xy = u_xlat0.xy + vec2(-1.5, 0.5);
					    u_xlat3.zw = u_xlat0.xy * _ShadowMapTexture_TexelSize.yy;
					    u_xlat4 = u_xlat1.xyxy * _ShadowMapTexture_TexelSize.xyxy + u_xlat3.xzyz;
					    u_xlat1 = u_xlat1.xyxy * _ShadowMapTexture_TexelSize.xyxy + u_xlat3.xwyw;
					    vec3 txVec0 = vec3(u_xlat4.xy,u_xlat0.z);
					    u_xlat0.x = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec0, 0.0);
					    vec3 txVec1 = vec3(u_xlat4.zw,u_xlat0.z);
					    u_xlat6.x = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec1, 0.0);
					    u_xlat6.x = u_xlat6.x * u_xlat2.y;
					    u_xlat0.x = u_xlat2.x * u_xlat0.x + u_xlat6.x;
					    vec3 txVec2 = vec3(u_xlat1.xy,u_xlat0.z);
					    u_xlat6.x = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec2, 0.0);
					    vec3 txVec3 = vec3(u_xlat1.zw,u_xlat0.z);
					    u_xlat12 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec3, 0.0);
					    u_xlat0.x = u_xlat2.z * u_xlat6.x + u_xlat0.x;
					    u_xlat0.x = u_xlat2.w * u_xlat12 + u_xlat0.x;
					    u_xlat6.x = (-_LightShadowData.x) + 1.0;
					    u_xlat0.x = u_xlat0.x * u_xlat6.x + _LightShadowData.x;
					    u_xlat6.xy = vs_TEXCOORD7.xy / vs_TEXCOORD7.ww;
					    u_xlat6.xy = u_xlat6.xy + vec2(0.5, 0.5);
					    u_xlat1 = texture(_LightTexture0, u_xlat6.xy);
					    u_xlatb6 = 0.0<vs_TEXCOORD7.z;
					    u_xlat6.x = u_xlatb6 ? 1.0 : float(0.0);
					    u_xlat6.x = u_xlat1.w * u_xlat6.x;
					    u_xlat12 = dot(vs_TEXCOORD7.xyz, vs_TEXCOORD7.xyz);
					    u_xlat1 = texture(_LightTextureB0, vec2(u_xlat12));
					    u_xlat6.x = u_xlat6.x * u_xlat1.x;
					    u_xlat0.x = u_xlat0.x * u_xlat6.x;
					    u_xlat0.xyz = u_xlat0.xxx * _LightColor0.xyz;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _NormalMap_ST.xy + _NormalMap_ST.zw;
					    u_xlat1 = texture(_NormalMap, u_xlat1.xy);
					    u_xlat1.x = u_xlat1.w * u_xlat1.x;
					    u_xlat1.xy = u_xlat1.xy * vec2(2.0, 2.0) + vec2(-1.0, -1.0);
					    u_xlat18 = dot(u_xlat1.xy, u_xlat1.xy);
					    u_xlat18 = min(u_xlat18, 1.0);
					    u_xlat18 = (-u_xlat18) + 1.0;
					    u_xlat1.z = sqrt(u_xlat18);
					    u_xlat18 = (-_NormalSharpness) + 1.0;
					    u_xlat1.xyz = u_xlat1.xyz / vec3(u_xlat18);
					    u_xlat1.xyz = clamp(u_xlat1.xyz, 0.0, 1.0);
					    u_xlat2.xyz = u_xlat1.yyy * vs_TEXCOORD6.xyz;
					    u_xlat1.xyw = u_xlat1.xxx * vs_TEXCOORD5.xyz + u_xlat2.xyz;
					    u_xlat18 = dot(vs_TEXCOORD4.xyz, vs_TEXCOORD4.xyz);
					    u_xlat18 = inversesqrt(u_xlat18);
					    u_xlat2.xyz = vec3(u_xlat18) * vs_TEXCOORD4.xyz;
					    u_xlat1.xyz = u_xlat1.zzz * u_xlat2.xyz + u_xlat1.xyw;
					    u_xlat18 = dot(u_xlat1.xyz, u_xlat1.xyz);
					    u_xlat18 = inversesqrt(u_xlat18);
					    u_xlat1.xyz = vec3(u_xlat18) * u_xlat1.xyz;
					    u_xlat3.xyz = (-vs_TEXCOORD3.xyz) + _WorldSpaceCameraPos.xyz;
					    u_xlat18 = dot(u_xlat3.xyz, u_xlat3.xyz);
					    u_xlat18 = inversesqrt(u_xlat18);
					    u_xlat4.xyz = vec3(u_xlat18) * u_xlat3.xyz;
					    u_xlat19 = dot(u_xlat4.xyz, u_xlat2.xyz);
					    u_xlati2 = int((0.0<u_xlat19) ? 0xFFFFFFFFu : uint(0));
					    u_xlati19 = int((u_xlat19<0.0) ? 0xFFFFFFFFu : uint(0));
					    u_xlati19 = (-u_xlati2) + u_xlati19;
					    u_xlat19 = float(u_xlati19);
					    u_xlat1.xyz = vec3(u_xlat19) * u_xlat1.xyz;
					    u_xlat2.xyz = _WorldSpaceLightPos0.www * (-vs_TEXCOORD3.xyz) + _WorldSpaceLightPos0.xyz;
					    u_xlat19 = dot(u_xlat2.xyz, u_xlat2.xyz);
					    u_xlat19 = inversesqrt(u_xlat19);
					    u_xlat2.xyz = vec3(u_xlat19) * u_xlat2.xyz;
					    u_xlat3.xyz = u_xlat3.xyz * vec3(u_xlat18) + u_xlat2.xyz;
					    u_xlat18 = dot(u_xlat3.xyz, u_xlat3.xyz);
					    u_xlat18 = inversesqrt(u_xlat18);
					    u_xlat3.xyz = vec3(u_xlat18) * u_xlat3.xyz;
					    u_xlat18 = dot(u_xlat1.xyz, u_xlat3.xyz);
					    u_xlat1.w = dot(u_xlat2.xyz, u_xlat3.xyz);
					    u_xlat2.x = dot(u_xlat1.xyz, u_xlat2.xyz);
					    u_xlat1.x = dot(u_xlat1.xyz, u_xlat4.xyz);
					    u_xlat7 = max(u_xlat2.x, 0.0);
					    u_xlat1.xz = max(u_xlat1.xw, vec2(0.0, 0.0));
					    u_xlat18 = max(u_xlat18, 0.0);
					    u_xlat19 = u_xlat18 * u_xlat18;
					    u_xlat18 = log2(u_xlat18);
					    u_xlat18 = u_xlat18 * 9.99999975e-05;
					    u_xlat18 = exp2(u_xlat18);
					    u_xlat18 = u_xlat18 * 0.318325758;
					    u_xlat2.xyz = u_xlat0.xyz * vec3(u_xlat19);
					    u_xlat19 = u_xlat1.x * 0.202115417 + 0.797884583;
					    u_xlat1.x = (-u_xlat1.x) + 1.00001001;
					    u_xlat20 = u_xlat7 * 0.202115417 + 0.797884583;
					    u_xlat19 = u_xlat20 * u_xlat19 + 9.99999975e-06;
					    u_xlat19 = float(1.0) / u_xlat19;
					    u_xlat19 = u_xlat19 * 0.25;
					    u_xlat19 = u_xlat19 * u_xlat7;
					    u_xlat18 = u_xlat18 * u_xlat19;
					    u_xlat18 = u_xlat18 * 0.616850257;
					    u_xlat2.xyz = vec3(u_xlat18) * u_xlat2.xyz;
					    u_xlat2.xyz = u_xlat2.xyz * _LightColor0.xyz;
					    u_xlat18 = (-u_xlat1.z) + 1.0;
					    u_xlat19 = u_xlat18 * u_xlat18;
					    u_xlat19 = u_xlat19 * u_xlat19;
					    u_xlat18 = u_xlat18 * u_xlat19;
					    u_xlat3.xy = vs_TEXCOORD0.xy * _MainTexture_ST.xy + _MainTexture_ST.zw;
					    u_xlat3 = texture(_MainTexture, u_xlat3.xy);
					    u_xlat3.xyz = _Color.xyz * u_xlat3.xyz + vec3(vec3(_Shadows, _Shadows, _Shadows));
					    u_xlat3.xyz = u_xlat3.xyz + vec3(-1.0, -1.0, -1.0);
					    u_xlat3.xyz = clamp(u_xlat3.xyz, 0.0, 1.0);
					    u_xlat4.xyz = u_xlat3.xyz + vec3(-0.220916301, -0.220916301, -0.220916301);
					    u_xlat5.xy = vs_TEXCOORD0.xy * _Specular_ST.xy + _Specular_ST.zw;
					    u_xlat5 = texture(_Specular, u_xlat5.xy);
					    u_xlat19 = u_xlat5.x * 0.449999988;
					    u_xlat20 = (-u_xlat5.x) * 0.350587666 + 0.779083729;
					    u_xlat3.xyz = vec3(u_xlat20) * u_xlat3.xyz;
					    u_xlat4.xyz = vec3(u_xlat19) * u_xlat4.xyz + vec3(0.220916301, 0.220916301, 0.220916301);
					    u_xlat5.xyz = (-u_xlat4.xyz) + vec3(1.0, 1.0, 1.0);
					    u_xlat4.xyz = u_xlat5.xyz * vec3(u_xlat18) + u_xlat4.xyz;
					    u_xlat2.xyz = u_xlat2.xyz * u_xlat4.xyz;
					    u_xlat18 = u_xlat1.x * u_xlat1.x;
					    u_xlat18 = u_xlat18 * u_xlat18;
					    u_xlat18 = u_xlat18 * u_xlat1.x;
					    u_xlat1.x = u_xlat1.z + u_xlat1.z;
					    u_xlat1.x = u_xlat1.x * u_xlat1.z + -0.5;
					    u_xlat18 = u_xlat1.x * u_xlat18 + 1.0;
					    u_xlat13.x = (-u_xlat7) + 1.00001001;
					    u_xlat19 = u_xlat13.x * u_xlat13.x;
					    u_xlat19 = u_xlat19 * u_xlat19;
					    u_xlat13.x = u_xlat19 * u_xlat13.x;
					    u_xlat1.x = u_xlat1.x * u_xlat13.x + 1.0;
					    u_xlat18 = u_xlat18 * u_xlat1.x;
					    u_xlat18 = u_xlat7 * u_xlat18;
					    u_xlat0.xyz = u_xlat0.xyz * vec3(u_xlat18);
					    SV_Target0.xyz = u_xlat0.xyz * u_xlat3.xyz + u_xlat2.xyz;
					    SV_Target0.w = 0.0;
					    return;
					}"
				}
				SubProgram "d3d11 " {
					Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "DIRLIGHTMAP_COMBINED" "LIGHTMAP_OFF" "DYNAMICLIGHTMAP_OFF" }
					"ps_4_0
					
					#version 330
					#extension GL_ARB_explicit_attrib_location : require
					#extension GL_ARB_explicit_uniform_location : require
					
					#define HLSLCC_ENABLE_UNIFORM_BUFFERS 1
					#if HLSLCC_ENABLE_UNIFORM_BUFFERS
					#define UNITY_UNIFORM
					#else
					#define UNITY_UNIFORM uniform
					#endif
					#define UNITY_SUPPORTS_UNIFORM_LOCATION 1
					#if UNITY_SUPPORTS_UNIFORM_LOCATION
					#define UNITY_LOCATION(x) layout(location = x)
					#define UNITY_BINDING(x) layout(binding = x, std140)
					#else
					#define UNITY_LOCATION(x)
					#define UNITY_BINDING(x) layout(std140)
					#endif
					layout(std140) uniform PGlobals {
						vec4 unused_0_0[2];
						vec4 _LightColor0;
						vec4 unused_0_2;
						vec4 _MainTexture_ST;
						vec4 _Specular_ST;
						vec4 _NormalMap_ST;
						vec4 _Color;
						vec4 unused_0_7;
						float _NormalSharpness;
						float _Shadows;
					};
					layout(std140) uniform UnityPerCamera {
						vec4 unused_1_0[4];
						vec3 _WorldSpaceCameraPos;
						vec4 unused_1_2[4];
					};
					layout(std140) uniform UnityLighting {
						vec4 _WorldSpaceLightPos0;
						vec4 unused_2_1[47];
					};
					uniform  sampler2D _NormalMap;
					uniform  sampler2D _ShadowMapTexture;
					uniform  sampler2D _MainTexture;
					uniform  sampler2D _Specular;
					in  vec2 vs_TEXCOORD0;
					in  vec4 vs_TEXCOORD3;
					in  vec3 vs_TEXCOORD4;
					in  vec3 vs_TEXCOORD5;
					in  vec3 vs_TEXCOORD6;
					in  vec4 vs_TEXCOORD8;
					layout(location = 0) out vec4 SV_Target0;
					vec4 u_xlat0;
					vec4 u_xlat1;
					int u_xlati1;
					vec4 u_xlat2;
					vec4 u_xlat3;
					vec3 u_xlat4;
					vec4 u_xlat5;
					vec3 u_xlat7;
					int u_xlati7;
					float u_xlat12;
					float u_xlat13;
					float u_xlat18;
					float u_xlat19;
					float u_xlat20;
					void main()
					{
					    u_xlat0.xy = vs_TEXCOORD0.xy * _NormalMap_ST.xy + _NormalMap_ST.zw;
					    u_xlat0 = texture(_NormalMap, u_xlat0.xy);
					    u_xlat0.x = u_xlat0.w * u_xlat0.x;
					    u_xlat0.xy = u_xlat0.xy * vec2(2.0, 2.0) + vec2(-1.0, -1.0);
					    u_xlat18 = dot(u_xlat0.xy, u_xlat0.xy);
					    u_xlat18 = min(u_xlat18, 1.0);
					    u_xlat18 = (-u_xlat18) + 1.0;
					    u_xlat0.z = sqrt(u_xlat18);
					    u_xlat18 = (-_NormalSharpness) + 1.0;
					    u_xlat0.xyz = u_xlat0.xyz / vec3(u_xlat18);
					    u_xlat0.xyz = clamp(u_xlat0.xyz, 0.0, 1.0);
					    u_xlat1.xyz = u_xlat0.yyy * vs_TEXCOORD6.xyz;
					    u_xlat0.xyw = u_xlat0.xxx * vs_TEXCOORD5.xyz + u_xlat1.xyz;
					    u_xlat1.x = dot(vs_TEXCOORD4.xyz, vs_TEXCOORD4.xyz);
					    u_xlat1.x = inversesqrt(u_xlat1.x);
					    u_xlat1.xyz = u_xlat1.xxx * vs_TEXCOORD4.xyz;
					    u_xlat0.xyz = u_xlat0.zzz * u_xlat1.xyz + u_xlat0.xyw;
					    u_xlat18 = dot(u_xlat0.xyz, u_xlat0.xyz);
					    u_xlat18 = inversesqrt(u_xlat18);
					    u_xlat0.xyz = vec3(u_xlat18) * u_xlat0.xyz;
					    u_xlat2.xyz = (-vs_TEXCOORD3.xyz) + _WorldSpaceCameraPos.xyz;
					    u_xlat18 = dot(u_xlat2.xyz, u_xlat2.xyz);
					    u_xlat18 = inversesqrt(u_xlat18);
					    u_xlat3.xyz = vec3(u_xlat18) * u_xlat2.xyz;
					    u_xlat1.x = dot(u_xlat3.xyz, u_xlat1.xyz);
					    u_xlati7 = int((0.0<u_xlat1.x) ? 0xFFFFFFFFu : uint(0));
					    u_xlati1 = int((u_xlat1.x<0.0) ? 0xFFFFFFFFu : uint(0));
					    u_xlati1 = (-u_xlati7) + u_xlati1;
					    u_xlat1.x = float(u_xlati1);
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xxx;
					    u_xlat1.xyz = _WorldSpaceLightPos0.www * (-vs_TEXCOORD3.xyz) + _WorldSpaceLightPos0.xyz;
					    u_xlat19 = dot(u_xlat1.xyz, u_xlat1.xyz);
					    u_xlat19 = inversesqrt(u_xlat19);
					    u_xlat1.xyz = vec3(u_xlat19) * u_xlat1.xyz;
					    u_xlat2.xyz = u_xlat2.xyz * vec3(u_xlat18) + u_xlat1.xyz;
					    u_xlat18 = dot(u_xlat2.xyz, u_xlat2.xyz);
					    u_xlat18 = inversesqrt(u_xlat18);
					    u_xlat2.xyz = vec3(u_xlat18) * u_xlat2.xyz;
					    u_xlat0.w = dot(u_xlat0.xyz, u_xlat2.xyz);
					    u_xlat1.w = dot(u_xlat1.xyz, u_xlat2.xyz);
					    u_xlat1.x = dot(u_xlat0.xyz, u_xlat1.xyz);
					    u_xlat0.x = dot(u_xlat0.xyz, u_xlat3.xyz);
					    u_xlat0.yz = max(u_xlat1.xw, vec2(0.0, 0.0));
					    u_xlat0.xw = max(u_xlat0.xw, vec2(0.0, 0.0));
					    u_xlat1.x = log2(u_xlat0.w);
					    u_xlat18 = u_xlat0.w * u_xlat0.w;
					    u_xlat1.x = u_xlat1.x * 9.99999975e-05;
					    u_xlat1.x = exp2(u_xlat1.x);
					    u_xlat7.x = u_xlat0.x * 0.202115417 + 0.797884583;
					    u_xlat13 = u_xlat0.y * 0.202115417 + 0.797884583;
					    u_xlat7.x = u_xlat13 * u_xlat7.x + 9.99999975e-06;
					    u_xlat1.y = float(1.0) / u_xlat7.x;
					    u_xlat1.xy = u_xlat1.xy * vec2(0.318325758, 0.25);
					    u_xlat7.x = u_xlat0.y * u_xlat1.y;
					    u_xlat1.x = u_xlat1.x * u_xlat7.x;
					    u_xlat1.x = u_xlat1.x * 0.616850257;
					    u_xlat7.xy = vs_TEXCOORD8.xy / vs_TEXCOORD8.ww;
					    u_xlat2 = texture(_ShadowMapTexture, u_xlat7.xy);
					    u_xlat7.xyz = u_xlat2.xxx * _LightColor0.xyz;
					    u_xlat2.xyz = vec3(u_xlat18) * u_xlat7.xyz;
					    u_xlat2.xyz = u_xlat1.xxx * u_xlat2.xyz;
					    u_xlat2.xyz = u_xlat2.xyz * _LightColor0.xyz;
					    u_xlat0.xw = (-u_xlat0.xz) + vec2(1.00001001, 1.0);
					    u_xlat1.x = u_xlat0.w * u_xlat0.w;
					    u_xlat1.x = u_xlat1.x * u_xlat1.x;
					    u_xlat18 = u_xlat0.w * u_xlat1.x;
					    u_xlat3.xy = vs_TEXCOORD0.xy * _MainTexture_ST.xy + _MainTexture_ST.zw;
					    u_xlat3 = texture(_MainTexture, u_xlat3.xy);
					    u_xlat3.xyz = _Color.xyz * u_xlat3.xyz + vec3(vec3(_Shadows, _Shadows, _Shadows));
					    u_xlat3.xyz = u_xlat3.xyz + vec3(-1.0, -1.0, -1.0);
					    u_xlat3.xyz = clamp(u_xlat3.xyz, 0.0, 1.0);
					    u_xlat4.xyz = u_xlat3.xyz + vec3(-0.220916301, -0.220916301, -0.220916301);
					    u_xlat5.xy = vs_TEXCOORD0.xy * _Specular_ST.xy + _Specular_ST.zw;
					    u_xlat5 = texture(_Specular, u_xlat5.xy);
					    u_xlat1.x = u_xlat5.x * 0.449999988;
					    u_xlat20 = (-u_xlat5.x) * 0.350587666 + 0.779083729;
					    u_xlat3.xyz = vec3(u_xlat20) * u_xlat3.xyz;
					    u_xlat4.xyz = u_xlat1.xxx * u_xlat4.xyz + vec3(0.220916301, 0.220916301, 0.220916301);
					    u_xlat5.xyz = (-u_xlat4.xyz) + vec3(1.0, 1.0, 1.0);
					    u_xlat4.xyz = u_xlat5.xyz * vec3(u_xlat18) + u_xlat4.xyz;
					    u_xlat2.xyz = u_xlat2.xyz * u_xlat4.xyz;
					    u_xlat18 = u_xlat0.x * u_xlat0.x;
					    u_xlat18 = u_xlat18 * u_xlat18;
					    u_xlat0.x = u_xlat18 * u_xlat0.x;
					    u_xlat18 = u_xlat0.z + u_xlat0.z;
					    u_xlat12 = u_xlat18 * u_xlat0.z + -0.5;
					    u_xlat0.x = u_xlat12 * u_xlat0.x + 1.0;
					    u_xlat18 = (-u_xlat0.y) + 1.00001001;
					    u_xlat1.x = u_xlat18 * u_xlat18;
					    u_xlat1.x = u_xlat1.x * u_xlat1.x;
					    u_xlat18 = u_xlat18 * u_xlat1.x;
					    u_xlat12 = u_xlat12 * u_xlat18 + 1.0;
					    u_xlat0.x = u_xlat0.x * u_xlat12;
					    u_xlat0.x = u_xlat0.y * u_xlat0.x;
					    u_xlat0.xyz = u_xlat7.xyz * u_xlat0.xxx;
					    SV_Target0.xyz = u_xlat0.xyz * u_xlat3.xyz + u_xlat2.xyz;
					    SV_Target0.w = 0.0;
					    return;
					}"
				}
				SubProgram "d3d11 " {
					Keywords { "DIRECTIONAL_COOKIE" "SHADOWS_SCREEN" "DIRLIGHTMAP_COMBINED" "LIGHTMAP_OFF" "DYNAMICLIGHTMAP_OFF" }
					"ps_4_0
					
					#version 330
					#extension GL_ARB_explicit_attrib_location : require
					#extension GL_ARB_explicit_uniform_location : require
					
					#define HLSLCC_ENABLE_UNIFORM_BUFFERS 1
					#if HLSLCC_ENABLE_UNIFORM_BUFFERS
					#define UNITY_UNIFORM
					#else
					#define UNITY_UNIFORM uniform
					#endif
					#define UNITY_SUPPORTS_UNIFORM_LOCATION 1
					#if UNITY_SUPPORTS_UNIFORM_LOCATION
					#define UNITY_LOCATION(x) layout(location = x)
					#define UNITY_BINDING(x) layout(binding = x, std140)
					#else
					#define UNITY_LOCATION(x)
					#define UNITY_BINDING(x) layout(std140)
					#endif
					layout(std140) uniform PGlobals {
						vec4 unused_0_0[6];
						vec4 _LightColor0;
						vec4 unused_0_2;
						vec4 _MainTexture_ST;
						vec4 _Specular_ST;
						vec4 _NormalMap_ST;
						vec4 _Color;
						vec4 unused_0_7;
						float _NormalSharpness;
						float _Shadows;
					};
					layout(std140) uniform UnityPerCamera {
						vec4 unused_1_0[4];
						vec3 _WorldSpaceCameraPos;
						vec4 unused_1_2[4];
					};
					layout(std140) uniform UnityLighting {
						vec4 _WorldSpaceLightPos0;
						vec4 unused_2_1[47];
					};
					uniform  sampler2D _NormalMap;
					uniform  sampler2D _LightTexture0;
					uniform  sampler2D _ShadowMapTexture;
					uniform  sampler2D _MainTexture;
					uniform  sampler2D _Specular;
					in  vec2 vs_TEXCOORD0;
					in  vec2 vs_TEXCOORD7;
					in  vec4 vs_TEXCOORD3;
					in  vec3 vs_TEXCOORD4;
					in  vec3 vs_TEXCOORD5;
					in  vec3 vs_TEXCOORD6;
					in  vec4 vs_TEXCOORD8;
					layout(location = 0) out vec4 SV_Target0;
					vec4 u_xlat0;
					vec4 u_xlat1;
					int u_xlati1;
					vec4 u_xlat2;
					vec4 u_xlat3;
					vec3 u_xlat4;
					vec4 u_xlat5;
					vec3 u_xlat7;
					int u_xlati7;
					float u_xlat12;
					float u_xlat13;
					float u_xlat18;
					float u_xlat19;
					float u_xlat20;
					void main()
					{
					    u_xlat0.xy = vs_TEXCOORD0.xy * _NormalMap_ST.xy + _NormalMap_ST.zw;
					    u_xlat0 = texture(_NormalMap, u_xlat0.xy);
					    u_xlat0.x = u_xlat0.w * u_xlat0.x;
					    u_xlat0.xy = u_xlat0.xy * vec2(2.0, 2.0) + vec2(-1.0, -1.0);
					    u_xlat18 = dot(u_xlat0.xy, u_xlat0.xy);
					    u_xlat18 = min(u_xlat18, 1.0);
					    u_xlat18 = (-u_xlat18) + 1.0;
					    u_xlat0.z = sqrt(u_xlat18);
					    u_xlat18 = (-_NormalSharpness) + 1.0;
					    u_xlat0.xyz = u_xlat0.xyz / vec3(u_xlat18);
					    u_xlat0.xyz = clamp(u_xlat0.xyz, 0.0, 1.0);
					    u_xlat1.xyz = u_xlat0.yyy * vs_TEXCOORD6.xyz;
					    u_xlat0.xyw = u_xlat0.xxx * vs_TEXCOORD5.xyz + u_xlat1.xyz;
					    u_xlat1.x = dot(vs_TEXCOORD4.xyz, vs_TEXCOORD4.xyz);
					    u_xlat1.x = inversesqrt(u_xlat1.x);
					    u_xlat1.xyz = u_xlat1.xxx * vs_TEXCOORD4.xyz;
					    u_xlat0.xyz = u_xlat0.zzz * u_xlat1.xyz + u_xlat0.xyw;
					    u_xlat18 = dot(u_xlat0.xyz, u_xlat0.xyz);
					    u_xlat18 = inversesqrt(u_xlat18);
					    u_xlat0.xyz = vec3(u_xlat18) * u_xlat0.xyz;
					    u_xlat2.xyz = (-vs_TEXCOORD3.xyz) + _WorldSpaceCameraPos.xyz;
					    u_xlat18 = dot(u_xlat2.xyz, u_xlat2.xyz);
					    u_xlat18 = inversesqrt(u_xlat18);
					    u_xlat3.xyz = vec3(u_xlat18) * u_xlat2.xyz;
					    u_xlat1.x = dot(u_xlat3.xyz, u_xlat1.xyz);
					    u_xlati7 = int((0.0<u_xlat1.x) ? 0xFFFFFFFFu : uint(0));
					    u_xlati1 = int((u_xlat1.x<0.0) ? 0xFFFFFFFFu : uint(0));
					    u_xlati1 = (-u_xlati7) + u_xlati1;
					    u_xlat1.x = float(u_xlati1);
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xxx;
					    u_xlat1.xyz = _WorldSpaceLightPos0.www * (-vs_TEXCOORD3.xyz) + _WorldSpaceLightPos0.xyz;
					    u_xlat19 = dot(u_xlat1.xyz, u_xlat1.xyz);
					    u_xlat19 = inversesqrt(u_xlat19);
					    u_xlat1.xyz = vec3(u_xlat19) * u_xlat1.xyz;
					    u_xlat2.xyz = u_xlat2.xyz * vec3(u_xlat18) + u_xlat1.xyz;
					    u_xlat18 = dot(u_xlat2.xyz, u_xlat2.xyz);
					    u_xlat18 = inversesqrt(u_xlat18);
					    u_xlat2.xyz = vec3(u_xlat18) * u_xlat2.xyz;
					    u_xlat0.w = dot(u_xlat0.xyz, u_xlat2.xyz);
					    u_xlat1.w = dot(u_xlat1.xyz, u_xlat2.xyz);
					    u_xlat1.x = dot(u_xlat0.xyz, u_xlat1.xyz);
					    u_xlat0.x = dot(u_xlat0.xyz, u_xlat3.xyz);
					    u_xlat0.yz = max(u_xlat1.xw, vec2(0.0, 0.0));
					    u_xlat0.xw = max(u_xlat0.xw, vec2(0.0, 0.0));
					    u_xlat1.x = log2(u_xlat0.w);
					    u_xlat18 = u_xlat0.w * u_xlat0.w;
					    u_xlat1.x = u_xlat1.x * 9.99999975e-05;
					    u_xlat1.x = exp2(u_xlat1.x);
					    u_xlat7.x = u_xlat0.x * 0.202115417 + 0.797884583;
					    u_xlat13 = u_xlat0.y * 0.202115417 + 0.797884583;
					    u_xlat7.x = u_xlat13 * u_xlat7.x + 9.99999975e-06;
					    u_xlat1.y = float(1.0) / u_xlat7.x;
					    u_xlat1.xy = u_xlat1.xy * vec2(0.318325758, 0.25);
					    u_xlat7.x = u_xlat0.y * u_xlat1.y;
					    u_xlat1.x = u_xlat1.x * u_xlat7.x;
					    u_xlat1.x = u_xlat1.x * 0.616850257;
					    u_xlat7.xy = vs_TEXCOORD8.xy / vs_TEXCOORD8.ww;
					    u_xlat2 = texture(_ShadowMapTexture, u_xlat7.xy);
					    u_xlat3 = texture(_LightTexture0, vs_TEXCOORD7.xy);
					    u_xlat7.x = u_xlat2.x * u_xlat3.w;
					    u_xlat7.xyz = u_xlat7.xxx * _LightColor0.xyz;
					    u_xlat2.xyz = vec3(u_xlat18) * u_xlat7.xyz;
					    u_xlat2.xyz = u_xlat1.xxx * u_xlat2.xyz;
					    u_xlat2.xyz = u_xlat2.xyz * _LightColor0.xyz;
					    u_xlat0.xw = (-u_xlat0.xz) + vec2(1.00001001, 1.0);
					    u_xlat1.x = u_xlat0.w * u_xlat0.w;
					    u_xlat1.x = u_xlat1.x * u_xlat1.x;
					    u_xlat18 = u_xlat0.w * u_xlat1.x;
					    u_xlat3.xy = vs_TEXCOORD0.xy * _MainTexture_ST.xy + _MainTexture_ST.zw;
					    u_xlat3 = texture(_MainTexture, u_xlat3.xy);
					    u_xlat3.xyz = _Color.xyz * u_xlat3.xyz + vec3(vec3(_Shadows, _Shadows, _Shadows));
					    u_xlat3.xyz = u_xlat3.xyz + vec3(-1.0, -1.0, -1.0);
					    u_xlat3.xyz = clamp(u_xlat3.xyz, 0.0, 1.0);
					    u_xlat4.xyz = u_xlat3.xyz + vec3(-0.220916301, -0.220916301, -0.220916301);
					    u_xlat5.xy = vs_TEXCOORD0.xy * _Specular_ST.xy + _Specular_ST.zw;
					    u_xlat5 = texture(_Specular, u_xlat5.xy);
					    u_xlat1.x = u_xlat5.x * 0.449999988;
					    u_xlat20 = (-u_xlat5.x) * 0.350587666 + 0.779083729;
					    u_xlat3.xyz = vec3(u_xlat20) * u_xlat3.xyz;
					    u_xlat4.xyz = u_xlat1.xxx * u_xlat4.xyz + vec3(0.220916301, 0.220916301, 0.220916301);
					    u_xlat5.xyz = (-u_xlat4.xyz) + vec3(1.0, 1.0, 1.0);
					    u_xlat4.xyz = u_xlat5.xyz * vec3(u_xlat18) + u_xlat4.xyz;
					    u_xlat2.xyz = u_xlat2.xyz * u_xlat4.xyz;
					    u_xlat18 = u_xlat0.x * u_xlat0.x;
					    u_xlat18 = u_xlat18 * u_xlat18;
					    u_xlat0.x = u_xlat18 * u_xlat0.x;
					    u_xlat18 = u_xlat0.z + u_xlat0.z;
					    u_xlat12 = u_xlat18 * u_xlat0.z + -0.5;
					    u_xlat0.x = u_xlat12 * u_xlat0.x + 1.0;
					    u_xlat18 = (-u_xlat0.y) + 1.00001001;
					    u_xlat1.x = u_xlat18 * u_xlat18;
					    u_xlat1.x = u_xlat1.x * u_xlat1.x;
					    u_xlat18 = u_xlat18 * u_xlat1.x;
					    u_xlat12 = u_xlat12 * u_xlat18 + 1.0;
					    u_xlat0.x = u_xlat0.x * u_xlat12;
					    u_xlat0.x = u_xlat0.y * u_xlat0.x;
					    u_xlat0.xyz = u_xlat7.xyz * u_xlat0.xxx;
					    SV_Target0.xyz = u_xlat0.xyz * u_xlat3.xyz + u_xlat2.xyz;
					    SV_Target0.w = 0.0;
					    return;
					}"
				}
				SubProgram "d3d11 " {
					Keywords { "POINT" "SHADOWS_CUBE" "DIRLIGHTMAP_COMBINED" "LIGHTMAP_OFF" "DYNAMICLIGHTMAP_OFF" }
					"ps_4_0
					
					#version 330
					#extension GL_ARB_explicit_attrib_location : require
					#extension GL_ARB_explicit_uniform_location : require
					
					#define HLSLCC_ENABLE_UNIFORM_BUFFERS 1
					#if HLSLCC_ENABLE_UNIFORM_BUFFERS
					#define UNITY_UNIFORM
					#else
					#define UNITY_UNIFORM uniform
					#endif
					#define UNITY_SUPPORTS_UNIFORM_LOCATION 1
					#if UNITY_SUPPORTS_UNIFORM_LOCATION
					#define UNITY_LOCATION(x) layout(location = x)
					#define UNITY_BINDING(x) layout(binding = x, std140)
					#else
					#define UNITY_LOCATION(x)
					#define UNITY_BINDING(x) layout(std140)
					#endif
					layout(std140) uniform PGlobals {
						vec4 unused_0_0[6];
						vec4 _LightColor0;
						vec4 unused_0_2;
						vec4 _MainTexture_ST;
						vec4 _Specular_ST;
						vec4 _NormalMap_ST;
						vec4 _Color;
						vec4 unused_0_7;
						float _NormalSharpness;
						float _Shadows;
					};
					layout(std140) uniform UnityPerCamera {
						vec4 unused_1_0[4];
						vec3 _WorldSpaceCameraPos;
						vec4 unused_1_2[4];
					};
					layout(std140) uniform UnityLighting {
						vec4 _WorldSpaceLightPos0;
						vec4 unused_2_1;
						vec4 _LightProjectionParams;
						vec4 unused_2_3[45];
					};
					layout(std140) uniform UnityShadows {
						vec4 unused_3_0[24];
						vec4 _LightShadowData;
						vec4 unused_3_2;
					};
					uniform  sampler2D _NormalMap;
					uniform  sampler2D _LightTexture0;
					uniform  sampler2D _MainTexture;
					uniform  sampler2D _Specular;
					uniform  samplerCube _ShadowMapTexture;
					uniform  samplerCubeShadow hlslcc_zcmp_ShadowMapTexture;
					in  vec2 vs_TEXCOORD0;
					in  vec4 vs_TEXCOORD3;
					in  vec3 vs_TEXCOORD4;
					in  vec3 vs_TEXCOORD5;
					in  vec3 vs_TEXCOORD6;
					in  vec3 vs_TEXCOORD7;
					in  vec3 vs_TEXCOORD8;
					layout(location = 0) out vec4 SV_Target0;
					vec4 u_xlat0;
					vec4 u_xlat1;
					int u_xlati1;
					vec4 u_xlat2;
					vec4 u_xlat3;
					vec3 u_xlat4;
					vec4 u_xlat5;
					vec3 u_xlat7;
					int u_xlati7;
					float u_xlat12;
					float u_xlat13;
					float u_xlat18;
					float u_xlat19;
					float u_xlat20;
					void main()
					{
					    u_xlat0.xy = vs_TEXCOORD0.xy * _NormalMap_ST.xy + _NormalMap_ST.zw;
					    u_xlat0 = texture(_NormalMap, u_xlat0.xy);
					    u_xlat0.x = u_xlat0.w * u_xlat0.x;
					    u_xlat0.xy = u_xlat0.xy * vec2(2.0, 2.0) + vec2(-1.0, -1.0);
					    u_xlat18 = dot(u_xlat0.xy, u_xlat0.xy);
					    u_xlat18 = min(u_xlat18, 1.0);
					    u_xlat18 = (-u_xlat18) + 1.0;
					    u_xlat0.z = sqrt(u_xlat18);
					    u_xlat18 = (-_NormalSharpness) + 1.0;
					    u_xlat0.xyz = u_xlat0.xyz / vec3(u_xlat18);
					    u_xlat0.xyz = clamp(u_xlat0.xyz, 0.0, 1.0);
					    u_xlat1.xyz = u_xlat0.yyy * vs_TEXCOORD6.xyz;
					    u_xlat0.xyw = u_xlat0.xxx * vs_TEXCOORD5.xyz + u_xlat1.xyz;
					    u_xlat1.x = dot(vs_TEXCOORD4.xyz, vs_TEXCOORD4.xyz);
					    u_xlat1.x = inversesqrt(u_xlat1.x);
					    u_xlat1.xyz = u_xlat1.xxx * vs_TEXCOORD4.xyz;
					    u_xlat0.xyz = u_xlat0.zzz * u_xlat1.xyz + u_xlat0.xyw;
					    u_xlat18 = dot(u_xlat0.xyz, u_xlat0.xyz);
					    u_xlat18 = inversesqrt(u_xlat18);
					    u_xlat0.xyz = vec3(u_xlat18) * u_xlat0.xyz;
					    u_xlat2.xyz = (-vs_TEXCOORD3.xyz) + _WorldSpaceCameraPos.xyz;
					    u_xlat18 = dot(u_xlat2.xyz, u_xlat2.xyz);
					    u_xlat18 = inversesqrt(u_xlat18);
					    u_xlat3.xyz = vec3(u_xlat18) * u_xlat2.xyz;
					    u_xlat1.x = dot(u_xlat3.xyz, u_xlat1.xyz);
					    u_xlati7 = int((0.0<u_xlat1.x) ? 0xFFFFFFFFu : uint(0));
					    u_xlati1 = int((u_xlat1.x<0.0) ? 0xFFFFFFFFu : uint(0));
					    u_xlati1 = (-u_xlati7) + u_xlati1;
					    u_xlat1.x = float(u_xlati1);
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xxx;
					    u_xlat1.xyz = _WorldSpaceLightPos0.www * (-vs_TEXCOORD3.xyz) + _WorldSpaceLightPos0.xyz;
					    u_xlat19 = dot(u_xlat1.xyz, u_xlat1.xyz);
					    u_xlat19 = inversesqrt(u_xlat19);
					    u_xlat1.xyz = vec3(u_xlat19) * u_xlat1.xyz;
					    u_xlat2.xyz = u_xlat2.xyz * vec3(u_xlat18) + u_xlat1.xyz;
					    u_xlat18 = dot(u_xlat2.xyz, u_xlat2.xyz);
					    u_xlat18 = inversesqrt(u_xlat18);
					    u_xlat2.xyz = vec3(u_xlat18) * u_xlat2.xyz;
					    u_xlat0.w = dot(u_xlat0.xyz, u_xlat2.xyz);
					    u_xlat1.w = dot(u_xlat1.xyz, u_xlat2.xyz);
					    u_xlat1.x = dot(u_xlat0.xyz, u_xlat1.xyz);
					    u_xlat0.x = dot(u_xlat0.xyz, u_xlat3.xyz);
					    u_xlat0.yz = max(u_xlat1.xw, vec2(0.0, 0.0));
					    u_xlat0.xw = max(u_xlat0.xw, vec2(0.0, 0.0));
					    u_xlat1.x = log2(u_xlat0.w);
					    u_xlat18 = u_xlat0.w * u_xlat0.w;
					    u_xlat1.x = u_xlat1.x * 9.99999975e-05;
					    u_xlat1.x = exp2(u_xlat1.x);
					    u_xlat7.x = u_xlat0.x * 0.202115417 + 0.797884583;
					    u_xlat13 = u_xlat0.y * 0.202115417 + 0.797884583;
					    u_xlat7.x = u_xlat13 * u_xlat7.x + 9.99999975e-06;
					    u_xlat1.y = float(1.0) / u_xlat7.x;
					    u_xlat1.xy = u_xlat1.xy * vec2(0.318325758, 0.25);
					    u_xlat7.x = u_xlat0.y * u_xlat1.y;
					    u_xlat1.x = u_xlat1.x * u_xlat7.x;
					    u_xlat1.x = u_xlat1.x * 0.616850257;
					    u_xlat7.x = max(abs(vs_TEXCOORD8.y), abs(vs_TEXCOORD8.x));
					    u_xlat7.x = max(u_xlat7.x, abs(vs_TEXCOORD8.z));
					    u_xlat7.x = u_xlat7.x + (-_LightProjectionParams.z);
					    u_xlat7.x = max(u_xlat7.x, 9.99999975e-06);
					    u_xlat7.x = u_xlat7.x * _LightProjectionParams.w;
					    u_xlat7.x = _LightProjectionParams.y / u_xlat7.x;
					    u_xlat7.x = u_xlat7.x + (-_LightProjectionParams.x);
					    u_xlat7.x = (-u_xlat7.x) + 1.0;
					    vec4 txVec0 = vec4(vs_TEXCOORD8.xyz,u_xlat7.x);
					    u_xlat7.x = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec0, 0.0);
					    u_xlat13 = (-_LightShadowData.x) + 1.0;
					    u_xlat7.x = u_xlat7.x * u_xlat13 + _LightShadowData.x;
					    u_xlat13 = dot(vs_TEXCOORD7.xyz, vs_TEXCOORD7.xyz);
					    u_xlat2 = texture(_LightTexture0, vec2(u_xlat13));
					    u_xlat7.x = u_xlat7.x * u_xlat2.x;
					    u_xlat7.xyz = u_xlat7.xxx * _LightColor0.xyz;
					    u_xlat2.xyz = vec3(u_xlat18) * u_xlat7.xyz;
					    u_xlat2.xyz = u_xlat1.xxx * u_xlat2.xyz;
					    u_xlat2.xyz = u_xlat2.xyz * _LightColor0.xyz;
					    u_xlat0.xw = (-u_xlat0.xz) + vec2(1.00001001, 1.0);
					    u_xlat1.x = u_xlat0.w * u_xlat0.w;
					    u_xlat1.x = u_xlat1.x * u_xlat1.x;
					    u_xlat18 = u_xlat0.w * u_xlat1.x;
					    u_xlat3.xy = vs_TEXCOORD0.xy * _MainTexture_ST.xy + _MainTexture_ST.zw;
					    u_xlat3 = texture(_MainTexture, u_xlat3.xy);
					    u_xlat3.xyz = _Color.xyz * u_xlat3.xyz + vec3(vec3(_Shadows, _Shadows, _Shadows));
					    u_xlat3.xyz = u_xlat3.xyz + vec3(-1.0, -1.0, -1.0);
					    u_xlat3.xyz = clamp(u_xlat3.xyz, 0.0, 1.0);
					    u_xlat4.xyz = u_xlat3.xyz + vec3(-0.220916301, -0.220916301, -0.220916301);
					    u_xlat5.xy = vs_TEXCOORD0.xy * _Specular_ST.xy + _Specular_ST.zw;
					    u_xlat5 = texture(_Specular, u_xlat5.xy);
					    u_xlat1.x = u_xlat5.x * 0.449999988;
					    u_xlat20 = (-u_xlat5.x) * 0.350587666 + 0.779083729;
					    u_xlat3.xyz = vec3(u_xlat20) * u_xlat3.xyz;
					    u_xlat4.xyz = u_xlat1.xxx * u_xlat4.xyz + vec3(0.220916301, 0.220916301, 0.220916301);
					    u_xlat5.xyz = (-u_xlat4.xyz) + vec3(1.0, 1.0, 1.0);
					    u_xlat4.xyz = u_xlat5.xyz * vec3(u_xlat18) + u_xlat4.xyz;
					    u_xlat2.xyz = u_xlat2.xyz * u_xlat4.xyz;
					    u_xlat18 = u_xlat0.x * u_xlat0.x;
					    u_xlat18 = u_xlat18 * u_xlat18;
					    u_xlat0.x = u_xlat18 * u_xlat0.x;
					    u_xlat18 = u_xlat0.z + u_xlat0.z;
					    u_xlat12 = u_xlat18 * u_xlat0.z + -0.5;
					    u_xlat0.x = u_xlat12 * u_xlat0.x + 1.0;
					    u_xlat18 = (-u_xlat0.y) + 1.00001001;
					    u_xlat1.x = u_xlat18 * u_xlat18;
					    u_xlat1.x = u_xlat1.x * u_xlat1.x;
					    u_xlat18 = u_xlat18 * u_xlat1.x;
					    u_xlat12 = u_xlat12 * u_xlat18 + 1.0;
					    u_xlat0.x = u_xlat0.x * u_xlat12;
					    u_xlat0.x = u_xlat0.y * u_xlat0.x;
					    u_xlat0.xyz = u_xlat7.xyz * u_xlat0.xxx;
					    SV_Target0.xyz = u_xlat0.xyz * u_xlat3.xyz + u_xlat2.xyz;
					    SV_Target0.w = 0.0;
					    return;
					}"
				}
				SubProgram "d3d11 " {
					Keywords { "POINT" "SHADOWS_CUBE" "SHADOWS_SOFT" "DIRLIGHTMAP_COMBINED" "LIGHTMAP_OFF" "DYNAMICLIGHTMAP_OFF" }
					"ps_4_0
					
					#version 330
					#extension GL_ARB_explicit_attrib_location : require
					#extension GL_ARB_explicit_uniform_location : require
					
					#define HLSLCC_ENABLE_UNIFORM_BUFFERS 1
					#if HLSLCC_ENABLE_UNIFORM_BUFFERS
					#define UNITY_UNIFORM
					#else
					#define UNITY_UNIFORM uniform
					#endif
					#define UNITY_SUPPORTS_UNIFORM_LOCATION 1
					#if UNITY_SUPPORTS_UNIFORM_LOCATION
					#define UNITY_LOCATION(x) layout(location = x)
					#define UNITY_BINDING(x) layout(binding = x, std140)
					#else
					#define UNITY_LOCATION(x)
					#define UNITY_BINDING(x) layout(std140)
					#endif
					layout(std140) uniform PGlobals {
						vec4 unused_0_0[6];
						vec4 _LightColor0;
						vec4 unused_0_2;
						vec4 _MainTexture_ST;
						vec4 _Specular_ST;
						vec4 _NormalMap_ST;
						vec4 _Color;
						vec4 unused_0_7;
						float _NormalSharpness;
						float _Shadows;
					};
					layout(std140) uniform UnityPerCamera {
						vec4 unused_1_0[4];
						vec3 _WorldSpaceCameraPos;
						vec4 unused_1_2[4];
					};
					layout(std140) uniform UnityLighting {
						vec4 _WorldSpaceLightPos0;
						vec4 unused_2_1;
						vec4 _LightProjectionParams;
						vec4 unused_2_3[45];
					};
					layout(std140) uniform UnityShadows {
						vec4 unused_3_0[24];
						vec4 _LightShadowData;
						vec4 unused_3_2;
					};
					uniform  sampler2D _NormalMap;
					uniform  sampler2D _LightTexture0;
					uniform  sampler2D _MainTexture;
					uniform  sampler2D _Specular;
					uniform  samplerCube _ShadowMapTexture;
					uniform  samplerCubeShadow hlslcc_zcmp_ShadowMapTexture;
					in  vec2 vs_TEXCOORD0;
					in  vec4 vs_TEXCOORD3;
					in  vec3 vs_TEXCOORD4;
					in  vec3 vs_TEXCOORD5;
					in  vec3 vs_TEXCOORD6;
					in  vec3 vs_TEXCOORD7;
					in  vec3 vs_TEXCOORD8;
					layout(location = 0) out vec4 SV_Target0;
					vec4 u_xlat0;
					vec4 u_xlat1;
					int u_xlati1;
					vec4 u_xlat2;
					vec4 u_xlat3;
					vec3 u_xlat4;
					vec4 u_xlat5;
					vec3 u_xlat7;
					int u_xlati7;
					float u_xlat12;
					float u_xlat13;
					float u_xlat18;
					float u_xlat19;
					float u_xlat20;
					void main()
					{
					    u_xlat0.xy = vs_TEXCOORD0.xy * _NormalMap_ST.xy + _NormalMap_ST.zw;
					    u_xlat0 = texture(_NormalMap, u_xlat0.xy);
					    u_xlat0.x = u_xlat0.w * u_xlat0.x;
					    u_xlat0.xy = u_xlat0.xy * vec2(2.0, 2.0) + vec2(-1.0, -1.0);
					    u_xlat18 = dot(u_xlat0.xy, u_xlat0.xy);
					    u_xlat18 = min(u_xlat18, 1.0);
					    u_xlat18 = (-u_xlat18) + 1.0;
					    u_xlat0.z = sqrt(u_xlat18);
					    u_xlat18 = (-_NormalSharpness) + 1.0;
					    u_xlat0.xyz = u_xlat0.xyz / vec3(u_xlat18);
					    u_xlat0.xyz = clamp(u_xlat0.xyz, 0.0, 1.0);
					    u_xlat1.xyz = u_xlat0.yyy * vs_TEXCOORD6.xyz;
					    u_xlat0.xyw = u_xlat0.xxx * vs_TEXCOORD5.xyz + u_xlat1.xyz;
					    u_xlat1.x = dot(vs_TEXCOORD4.xyz, vs_TEXCOORD4.xyz);
					    u_xlat1.x = inversesqrt(u_xlat1.x);
					    u_xlat1.xyz = u_xlat1.xxx * vs_TEXCOORD4.xyz;
					    u_xlat0.xyz = u_xlat0.zzz * u_xlat1.xyz + u_xlat0.xyw;
					    u_xlat18 = dot(u_xlat0.xyz, u_xlat0.xyz);
					    u_xlat18 = inversesqrt(u_xlat18);
					    u_xlat0.xyz = vec3(u_xlat18) * u_xlat0.xyz;
					    u_xlat2.xyz = (-vs_TEXCOORD3.xyz) + _WorldSpaceCameraPos.xyz;
					    u_xlat18 = dot(u_xlat2.xyz, u_xlat2.xyz);
					    u_xlat18 = inversesqrt(u_xlat18);
					    u_xlat3.xyz = vec3(u_xlat18) * u_xlat2.xyz;
					    u_xlat1.x = dot(u_xlat3.xyz, u_xlat1.xyz);
					    u_xlati7 = int((0.0<u_xlat1.x) ? 0xFFFFFFFFu : uint(0));
					    u_xlati1 = int((u_xlat1.x<0.0) ? 0xFFFFFFFFu : uint(0));
					    u_xlati1 = (-u_xlati7) + u_xlati1;
					    u_xlat1.x = float(u_xlati1);
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xxx;
					    u_xlat1.xyz = _WorldSpaceLightPos0.www * (-vs_TEXCOORD3.xyz) + _WorldSpaceLightPos0.xyz;
					    u_xlat19 = dot(u_xlat1.xyz, u_xlat1.xyz);
					    u_xlat19 = inversesqrt(u_xlat19);
					    u_xlat1.xyz = vec3(u_xlat19) * u_xlat1.xyz;
					    u_xlat2.xyz = u_xlat2.xyz * vec3(u_xlat18) + u_xlat1.xyz;
					    u_xlat18 = dot(u_xlat2.xyz, u_xlat2.xyz);
					    u_xlat18 = inversesqrt(u_xlat18);
					    u_xlat2.xyz = vec3(u_xlat18) * u_xlat2.xyz;
					    u_xlat0.w = dot(u_xlat0.xyz, u_xlat2.xyz);
					    u_xlat1.w = dot(u_xlat1.xyz, u_xlat2.xyz);
					    u_xlat1.x = dot(u_xlat0.xyz, u_xlat1.xyz);
					    u_xlat0.x = dot(u_xlat0.xyz, u_xlat3.xyz);
					    u_xlat0.yz = max(u_xlat1.xw, vec2(0.0, 0.0));
					    u_xlat0.xw = max(u_xlat0.xw, vec2(0.0, 0.0));
					    u_xlat1.x = log2(u_xlat0.w);
					    u_xlat18 = u_xlat0.w * u_xlat0.w;
					    u_xlat1.x = u_xlat1.x * 9.99999975e-05;
					    u_xlat1.x = exp2(u_xlat1.x);
					    u_xlat7.x = u_xlat0.x * 0.202115417 + 0.797884583;
					    u_xlat13 = u_xlat0.y * 0.202115417 + 0.797884583;
					    u_xlat7.x = u_xlat13 * u_xlat7.x + 9.99999975e-06;
					    u_xlat1.y = float(1.0) / u_xlat7.x;
					    u_xlat1.xy = u_xlat1.xy * vec2(0.318325758, 0.25);
					    u_xlat7.x = u_xlat0.y * u_xlat1.y;
					    u_xlat1.x = u_xlat1.x * u_xlat7.x;
					    u_xlat1.x = u_xlat1.x * 0.616850257;
					    u_xlat7.x = max(abs(vs_TEXCOORD8.y), abs(vs_TEXCOORD8.x));
					    u_xlat7.x = max(u_xlat7.x, abs(vs_TEXCOORD8.z));
					    u_xlat7.x = u_xlat7.x + (-_LightProjectionParams.z);
					    u_xlat7.x = max(u_xlat7.x, 9.99999975e-06);
					    u_xlat7.x = u_xlat7.x * _LightProjectionParams.w;
					    u_xlat7.x = _LightProjectionParams.y / u_xlat7.x;
					    u_xlat7.x = u_xlat7.x + (-_LightProjectionParams.x);
					    u_xlat7.x = (-u_xlat7.x) + 1.0;
					    u_xlat2.xyz = vs_TEXCOORD8.xyz + vec3(0.0078125, 0.0078125, 0.0078125);
					    vec4 txVec0 = vec4(u_xlat2.xyz,u_xlat7.x);
					    u_xlat2.x = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec0, 0.0);
					    u_xlat3.xyz = vs_TEXCOORD8.xyz + vec3(-0.0078125, -0.0078125, 0.0078125);
					    vec4 txVec1 = vec4(u_xlat3.xyz,u_xlat7.x);
					    u_xlat2.y = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec1, 0.0);
					    u_xlat3.xyz = vs_TEXCOORD8.xyz + vec3(-0.0078125, 0.0078125, -0.0078125);
					    vec4 txVec2 = vec4(u_xlat3.xyz,u_xlat7.x);
					    u_xlat2.z = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec2, 0.0);
					    u_xlat3.xyz = vs_TEXCOORD8.xyz + vec3(0.0078125, -0.0078125, -0.0078125);
					    vec4 txVec3 = vec4(u_xlat3.xyz,u_xlat7.x);
					    u_xlat2.w = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec3, 0.0);
					    u_xlat7.x = dot(u_xlat2, vec4(0.25, 0.25, 0.25, 0.25));
					    u_xlat13 = (-_LightShadowData.x) + 1.0;
					    u_xlat7.x = u_xlat7.x * u_xlat13 + _LightShadowData.x;
					    u_xlat13 = dot(vs_TEXCOORD7.xyz, vs_TEXCOORD7.xyz);
					    u_xlat2 = texture(_LightTexture0, vec2(u_xlat13));
					    u_xlat7.x = u_xlat7.x * u_xlat2.x;
					    u_xlat7.xyz = u_xlat7.xxx * _LightColor0.xyz;
					    u_xlat2.xyz = vec3(u_xlat18) * u_xlat7.xyz;
					    u_xlat2.xyz = u_xlat1.xxx * u_xlat2.xyz;
					    u_xlat2.xyz = u_xlat2.xyz * _LightColor0.xyz;
					    u_xlat0.xw = (-u_xlat0.xz) + vec2(1.00001001, 1.0);
					    u_xlat1.x = u_xlat0.w * u_xlat0.w;
					    u_xlat1.x = u_xlat1.x * u_xlat1.x;
					    u_xlat18 = u_xlat0.w * u_xlat1.x;
					    u_xlat3.xy = vs_TEXCOORD0.xy * _MainTexture_ST.xy + _MainTexture_ST.zw;
					    u_xlat3 = texture(_MainTexture, u_xlat3.xy);
					    u_xlat3.xyz = _Color.xyz * u_xlat3.xyz + vec3(vec3(_Shadows, _Shadows, _Shadows));
					    u_xlat3.xyz = u_xlat3.xyz + vec3(-1.0, -1.0, -1.0);
					    u_xlat3.xyz = clamp(u_xlat3.xyz, 0.0, 1.0);
					    u_xlat4.xyz = u_xlat3.xyz + vec3(-0.220916301, -0.220916301, -0.220916301);
					    u_xlat5.xy = vs_TEXCOORD0.xy * _Specular_ST.xy + _Specular_ST.zw;
					    u_xlat5 = texture(_Specular, u_xlat5.xy);
					    u_xlat1.x = u_xlat5.x * 0.449999988;
					    u_xlat20 = (-u_xlat5.x) * 0.350587666 + 0.779083729;
					    u_xlat3.xyz = vec3(u_xlat20) * u_xlat3.xyz;
					    u_xlat4.xyz = u_xlat1.xxx * u_xlat4.xyz + vec3(0.220916301, 0.220916301, 0.220916301);
					    u_xlat5.xyz = (-u_xlat4.xyz) + vec3(1.0, 1.0, 1.0);
					    u_xlat4.xyz = u_xlat5.xyz * vec3(u_xlat18) + u_xlat4.xyz;
					    u_xlat2.xyz = u_xlat2.xyz * u_xlat4.xyz;
					    u_xlat18 = u_xlat0.x * u_xlat0.x;
					    u_xlat18 = u_xlat18 * u_xlat18;
					    u_xlat0.x = u_xlat18 * u_xlat0.x;
					    u_xlat18 = u_xlat0.z + u_xlat0.z;
					    u_xlat12 = u_xlat18 * u_xlat0.z + -0.5;
					    u_xlat0.x = u_xlat12 * u_xlat0.x + 1.0;
					    u_xlat18 = (-u_xlat0.y) + 1.00001001;
					    u_xlat1.x = u_xlat18 * u_xlat18;
					    u_xlat1.x = u_xlat1.x * u_xlat1.x;
					    u_xlat18 = u_xlat18 * u_xlat1.x;
					    u_xlat12 = u_xlat12 * u_xlat18 + 1.0;
					    u_xlat0.x = u_xlat0.x * u_xlat12;
					    u_xlat0.x = u_xlat0.y * u_xlat0.x;
					    u_xlat0.xyz = u_xlat7.xyz * u_xlat0.xxx;
					    SV_Target0.xyz = u_xlat0.xyz * u_xlat3.xyz + u_xlat2.xyz;
					    SV_Target0.w = 0.0;
					    return;
					}"
				}
				SubProgram "d3d11 " {
					Keywords { "POINT_COOKIE" "SHADOWS_CUBE" "DIRLIGHTMAP_COMBINED" "LIGHTMAP_OFF" "DYNAMICLIGHTMAP_OFF" }
					"ps_4_0
					
					#version 330
					#extension GL_ARB_explicit_attrib_location : require
					#extension GL_ARB_explicit_uniform_location : require
					
					#define HLSLCC_ENABLE_UNIFORM_BUFFERS 1
					#if HLSLCC_ENABLE_UNIFORM_BUFFERS
					#define UNITY_UNIFORM
					#else
					#define UNITY_UNIFORM uniform
					#endif
					#define UNITY_SUPPORTS_UNIFORM_LOCATION 1
					#if UNITY_SUPPORTS_UNIFORM_LOCATION
					#define UNITY_LOCATION(x) layout(location = x)
					#define UNITY_BINDING(x) layout(binding = x, std140)
					#else
					#define UNITY_LOCATION(x)
					#define UNITY_BINDING(x) layout(std140)
					#endif
					layout(std140) uniform PGlobals {
						vec4 unused_0_0[6];
						vec4 _LightColor0;
						vec4 unused_0_2;
						vec4 _MainTexture_ST;
						vec4 _Specular_ST;
						vec4 _NormalMap_ST;
						vec4 _Color;
						vec4 unused_0_7;
						float _NormalSharpness;
						float _Shadows;
					};
					layout(std140) uniform UnityPerCamera {
						vec4 unused_1_0[4];
						vec3 _WorldSpaceCameraPos;
						vec4 unused_1_2[4];
					};
					layout(std140) uniform UnityLighting {
						vec4 _WorldSpaceLightPos0;
						vec4 unused_2_1;
						vec4 _LightProjectionParams;
						vec4 unused_2_3[45];
					};
					layout(std140) uniform UnityShadows {
						vec4 unused_3_0[24];
						vec4 _LightShadowData;
						vec4 unused_3_2;
					};
					uniform  sampler2D _NormalMap;
					uniform  sampler2D _LightTextureB0;
					uniform  samplerCube _LightTexture0;
					uniform  sampler2D _MainTexture;
					uniform  sampler2D _Specular;
					uniform  samplerCube _ShadowMapTexture;
					uniform  samplerCubeShadow hlslcc_zcmp_ShadowMapTexture;
					in  vec2 vs_TEXCOORD0;
					in  vec4 vs_TEXCOORD3;
					in  vec3 vs_TEXCOORD4;
					in  vec3 vs_TEXCOORD5;
					in  vec3 vs_TEXCOORD6;
					in  vec3 vs_TEXCOORD7;
					in  vec3 vs_TEXCOORD8;
					layout(location = 0) out vec4 SV_Target0;
					vec4 u_xlat0;
					vec4 u_xlat1;
					int u_xlati1;
					vec4 u_xlat2;
					vec4 u_xlat3;
					vec3 u_xlat4;
					vec4 u_xlat5;
					vec3 u_xlat7;
					int u_xlati7;
					float u_xlat12;
					float u_xlat13;
					float u_xlat18;
					float u_xlat19;
					float u_xlat20;
					void main()
					{
					    u_xlat0.xy = vs_TEXCOORD0.xy * _NormalMap_ST.xy + _NormalMap_ST.zw;
					    u_xlat0 = texture(_NormalMap, u_xlat0.xy);
					    u_xlat0.x = u_xlat0.w * u_xlat0.x;
					    u_xlat0.xy = u_xlat0.xy * vec2(2.0, 2.0) + vec2(-1.0, -1.0);
					    u_xlat18 = dot(u_xlat0.xy, u_xlat0.xy);
					    u_xlat18 = min(u_xlat18, 1.0);
					    u_xlat18 = (-u_xlat18) + 1.0;
					    u_xlat0.z = sqrt(u_xlat18);
					    u_xlat18 = (-_NormalSharpness) + 1.0;
					    u_xlat0.xyz = u_xlat0.xyz / vec3(u_xlat18);
					    u_xlat0.xyz = clamp(u_xlat0.xyz, 0.0, 1.0);
					    u_xlat1.xyz = u_xlat0.yyy * vs_TEXCOORD6.xyz;
					    u_xlat0.xyw = u_xlat0.xxx * vs_TEXCOORD5.xyz + u_xlat1.xyz;
					    u_xlat1.x = dot(vs_TEXCOORD4.xyz, vs_TEXCOORD4.xyz);
					    u_xlat1.x = inversesqrt(u_xlat1.x);
					    u_xlat1.xyz = u_xlat1.xxx * vs_TEXCOORD4.xyz;
					    u_xlat0.xyz = u_xlat0.zzz * u_xlat1.xyz + u_xlat0.xyw;
					    u_xlat18 = dot(u_xlat0.xyz, u_xlat0.xyz);
					    u_xlat18 = inversesqrt(u_xlat18);
					    u_xlat0.xyz = vec3(u_xlat18) * u_xlat0.xyz;
					    u_xlat2.xyz = (-vs_TEXCOORD3.xyz) + _WorldSpaceCameraPos.xyz;
					    u_xlat18 = dot(u_xlat2.xyz, u_xlat2.xyz);
					    u_xlat18 = inversesqrt(u_xlat18);
					    u_xlat3.xyz = vec3(u_xlat18) * u_xlat2.xyz;
					    u_xlat1.x = dot(u_xlat3.xyz, u_xlat1.xyz);
					    u_xlati7 = int((0.0<u_xlat1.x) ? 0xFFFFFFFFu : uint(0));
					    u_xlati1 = int((u_xlat1.x<0.0) ? 0xFFFFFFFFu : uint(0));
					    u_xlati1 = (-u_xlati7) + u_xlati1;
					    u_xlat1.x = float(u_xlati1);
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xxx;
					    u_xlat1.xyz = _WorldSpaceLightPos0.www * (-vs_TEXCOORD3.xyz) + _WorldSpaceLightPos0.xyz;
					    u_xlat19 = dot(u_xlat1.xyz, u_xlat1.xyz);
					    u_xlat19 = inversesqrt(u_xlat19);
					    u_xlat1.xyz = vec3(u_xlat19) * u_xlat1.xyz;
					    u_xlat2.xyz = u_xlat2.xyz * vec3(u_xlat18) + u_xlat1.xyz;
					    u_xlat18 = dot(u_xlat2.xyz, u_xlat2.xyz);
					    u_xlat18 = inversesqrt(u_xlat18);
					    u_xlat2.xyz = vec3(u_xlat18) * u_xlat2.xyz;
					    u_xlat0.w = dot(u_xlat0.xyz, u_xlat2.xyz);
					    u_xlat1.w = dot(u_xlat1.xyz, u_xlat2.xyz);
					    u_xlat1.x = dot(u_xlat0.xyz, u_xlat1.xyz);
					    u_xlat0.x = dot(u_xlat0.xyz, u_xlat3.xyz);
					    u_xlat0.yz = max(u_xlat1.xw, vec2(0.0, 0.0));
					    u_xlat0.xw = max(u_xlat0.xw, vec2(0.0, 0.0));
					    u_xlat1.x = log2(u_xlat0.w);
					    u_xlat18 = u_xlat0.w * u_xlat0.w;
					    u_xlat1.x = u_xlat1.x * 9.99999975e-05;
					    u_xlat1.x = exp2(u_xlat1.x);
					    u_xlat7.x = u_xlat0.x * 0.202115417 + 0.797884583;
					    u_xlat13 = u_xlat0.y * 0.202115417 + 0.797884583;
					    u_xlat7.x = u_xlat13 * u_xlat7.x + 9.99999975e-06;
					    u_xlat1.y = float(1.0) / u_xlat7.x;
					    u_xlat1.xy = u_xlat1.xy * vec2(0.318325758, 0.25);
					    u_xlat7.x = u_xlat0.y * u_xlat1.y;
					    u_xlat1.x = u_xlat1.x * u_xlat7.x;
					    u_xlat1.x = u_xlat1.x * 0.616850257;
					    u_xlat7.x = max(abs(vs_TEXCOORD8.y), abs(vs_TEXCOORD8.x));
					    u_xlat7.x = max(u_xlat7.x, abs(vs_TEXCOORD8.z));
					    u_xlat7.x = u_xlat7.x + (-_LightProjectionParams.z);
					    u_xlat7.x = max(u_xlat7.x, 9.99999975e-06);
					    u_xlat7.x = u_xlat7.x * _LightProjectionParams.w;
					    u_xlat7.x = _LightProjectionParams.y / u_xlat7.x;
					    u_xlat7.x = u_xlat7.x + (-_LightProjectionParams.x);
					    u_xlat7.x = (-u_xlat7.x) + 1.0;
					    vec4 txVec0 = vec4(vs_TEXCOORD8.xyz,u_xlat7.x);
					    u_xlat7.x = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec0, 0.0);
					    u_xlat13 = (-_LightShadowData.x) + 1.0;
					    u_xlat7.x = u_xlat7.x * u_xlat13 + _LightShadowData.x;
					    u_xlat13 = dot(vs_TEXCOORD7.xyz, vs_TEXCOORD7.xyz);
					    u_xlat2 = texture(_LightTextureB0, vec2(u_xlat13));
					    u_xlat3 = texture(_LightTexture0, vs_TEXCOORD7.xyz);
					    u_xlat13 = u_xlat2.x * u_xlat3.w;
					    u_xlat7.x = u_xlat7.x * u_xlat13;
					    u_xlat7.xyz = u_xlat7.xxx * _LightColor0.xyz;
					    u_xlat2.xyz = vec3(u_xlat18) * u_xlat7.xyz;
					    u_xlat2.xyz = u_xlat1.xxx * u_xlat2.xyz;
					    u_xlat2.xyz = u_xlat2.xyz * _LightColor0.xyz;
					    u_xlat0.xw = (-u_xlat0.xz) + vec2(1.00001001, 1.0);
					    u_xlat1.x = u_xlat0.w * u_xlat0.w;
					    u_xlat1.x = u_xlat1.x * u_xlat1.x;
					    u_xlat18 = u_xlat0.w * u_xlat1.x;
					    u_xlat3.xy = vs_TEXCOORD0.xy * _MainTexture_ST.xy + _MainTexture_ST.zw;
					    u_xlat3 = texture(_MainTexture, u_xlat3.xy);
					    u_xlat3.xyz = _Color.xyz * u_xlat3.xyz + vec3(vec3(_Shadows, _Shadows, _Shadows));
					    u_xlat3.xyz = u_xlat3.xyz + vec3(-1.0, -1.0, -1.0);
					    u_xlat3.xyz = clamp(u_xlat3.xyz, 0.0, 1.0);
					    u_xlat4.xyz = u_xlat3.xyz + vec3(-0.220916301, -0.220916301, -0.220916301);
					    u_xlat5.xy = vs_TEXCOORD0.xy * _Specular_ST.xy + _Specular_ST.zw;
					    u_xlat5 = texture(_Specular, u_xlat5.xy);
					    u_xlat1.x = u_xlat5.x * 0.449999988;
					    u_xlat20 = (-u_xlat5.x) * 0.350587666 + 0.779083729;
					    u_xlat3.xyz = vec3(u_xlat20) * u_xlat3.xyz;
					    u_xlat4.xyz = u_xlat1.xxx * u_xlat4.xyz + vec3(0.220916301, 0.220916301, 0.220916301);
					    u_xlat5.xyz = (-u_xlat4.xyz) + vec3(1.0, 1.0, 1.0);
					    u_xlat4.xyz = u_xlat5.xyz * vec3(u_xlat18) + u_xlat4.xyz;
					    u_xlat2.xyz = u_xlat2.xyz * u_xlat4.xyz;
					    u_xlat18 = u_xlat0.x * u_xlat0.x;
					    u_xlat18 = u_xlat18 * u_xlat18;
					    u_xlat0.x = u_xlat18 * u_xlat0.x;
					    u_xlat18 = u_xlat0.z + u_xlat0.z;
					    u_xlat12 = u_xlat18 * u_xlat0.z + -0.5;
					    u_xlat0.x = u_xlat12 * u_xlat0.x + 1.0;
					    u_xlat18 = (-u_xlat0.y) + 1.00001001;
					    u_xlat1.x = u_xlat18 * u_xlat18;
					    u_xlat1.x = u_xlat1.x * u_xlat1.x;
					    u_xlat18 = u_xlat18 * u_xlat1.x;
					    u_xlat12 = u_xlat12 * u_xlat18 + 1.0;
					    u_xlat0.x = u_xlat0.x * u_xlat12;
					    u_xlat0.x = u_xlat0.y * u_xlat0.x;
					    u_xlat0.xyz = u_xlat7.xyz * u_xlat0.xxx;
					    SV_Target0.xyz = u_xlat0.xyz * u_xlat3.xyz + u_xlat2.xyz;
					    SV_Target0.w = 0.0;
					    return;
					}"
				}
				SubProgram "d3d11 " {
					Keywords { "POINT_COOKIE" "SHADOWS_CUBE" "SHADOWS_SOFT" "DIRLIGHTMAP_COMBINED" "LIGHTMAP_OFF" "DYNAMICLIGHTMAP_OFF" }
					"ps_4_0
					
					#version 330
					#extension GL_ARB_explicit_attrib_location : require
					#extension GL_ARB_explicit_uniform_location : require
					
					#define HLSLCC_ENABLE_UNIFORM_BUFFERS 1
					#if HLSLCC_ENABLE_UNIFORM_BUFFERS
					#define UNITY_UNIFORM
					#else
					#define UNITY_UNIFORM uniform
					#endif
					#define UNITY_SUPPORTS_UNIFORM_LOCATION 1
					#if UNITY_SUPPORTS_UNIFORM_LOCATION
					#define UNITY_LOCATION(x) layout(location = x)
					#define UNITY_BINDING(x) layout(binding = x, std140)
					#else
					#define UNITY_LOCATION(x)
					#define UNITY_BINDING(x) layout(std140)
					#endif
					layout(std140) uniform PGlobals {
						vec4 unused_0_0[6];
						vec4 _LightColor0;
						vec4 unused_0_2;
						vec4 _MainTexture_ST;
						vec4 _Specular_ST;
						vec4 _NormalMap_ST;
						vec4 _Color;
						vec4 unused_0_7;
						float _NormalSharpness;
						float _Shadows;
					};
					layout(std140) uniform UnityPerCamera {
						vec4 unused_1_0[4];
						vec3 _WorldSpaceCameraPos;
						vec4 unused_1_2[4];
					};
					layout(std140) uniform UnityLighting {
						vec4 _WorldSpaceLightPos0;
						vec4 unused_2_1;
						vec4 _LightProjectionParams;
						vec4 unused_2_3[45];
					};
					layout(std140) uniform UnityShadows {
						vec4 unused_3_0[24];
						vec4 _LightShadowData;
						vec4 unused_3_2;
					};
					uniform  sampler2D _NormalMap;
					uniform  sampler2D _LightTextureB0;
					uniform  samplerCube _LightTexture0;
					uniform  sampler2D _MainTexture;
					uniform  sampler2D _Specular;
					uniform  samplerCube _ShadowMapTexture;
					uniform  samplerCubeShadow hlslcc_zcmp_ShadowMapTexture;
					in  vec2 vs_TEXCOORD0;
					in  vec4 vs_TEXCOORD3;
					in  vec3 vs_TEXCOORD4;
					in  vec3 vs_TEXCOORD5;
					in  vec3 vs_TEXCOORD6;
					in  vec3 vs_TEXCOORD7;
					in  vec3 vs_TEXCOORD8;
					layout(location = 0) out vec4 SV_Target0;
					vec4 u_xlat0;
					vec4 u_xlat1;
					int u_xlati1;
					vec4 u_xlat2;
					vec4 u_xlat3;
					vec3 u_xlat4;
					vec4 u_xlat5;
					vec3 u_xlat7;
					int u_xlati7;
					float u_xlat12;
					float u_xlat13;
					float u_xlat18;
					float u_xlat19;
					float u_xlat20;
					void main()
					{
					    u_xlat0.xy = vs_TEXCOORD0.xy * _NormalMap_ST.xy + _NormalMap_ST.zw;
					    u_xlat0 = texture(_NormalMap, u_xlat0.xy);
					    u_xlat0.x = u_xlat0.w * u_xlat0.x;
					    u_xlat0.xy = u_xlat0.xy * vec2(2.0, 2.0) + vec2(-1.0, -1.0);
					    u_xlat18 = dot(u_xlat0.xy, u_xlat0.xy);
					    u_xlat18 = min(u_xlat18, 1.0);
					    u_xlat18 = (-u_xlat18) + 1.0;
					    u_xlat0.z = sqrt(u_xlat18);
					    u_xlat18 = (-_NormalSharpness) + 1.0;
					    u_xlat0.xyz = u_xlat0.xyz / vec3(u_xlat18);
					    u_xlat0.xyz = clamp(u_xlat0.xyz, 0.0, 1.0);
					    u_xlat1.xyz = u_xlat0.yyy * vs_TEXCOORD6.xyz;
					    u_xlat0.xyw = u_xlat0.xxx * vs_TEXCOORD5.xyz + u_xlat1.xyz;
					    u_xlat1.x = dot(vs_TEXCOORD4.xyz, vs_TEXCOORD4.xyz);
					    u_xlat1.x = inversesqrt(u_xlat1.x);
					    u_xlat1.xyz = u_xlat1.xxx * vs_TEXCOORD4.xyz;
					    u_xlat0.xyz = u_xlat0.zzz * u_xlat1.xyz + u_xlat0.xyw;
					    u_xlat18 = dot(u_xlat0.xyz, u_xlat0.xyz);
					    u_xlat18 = inversesqrt(u_xlat18);
					    u_xlat0.xyz = vec3(u_xlat18) * u_xlat0.xyz;
					    u_xlat2.xyz = (-vs_TEXCOORD3.xyz) + _WorldSpaceCameraPos.xyz;
					    u_xlat18 = dot(u_xlat2.xyz, u_xlat2.xyz);
					    u_xlat18 = inversesqrt(u_xlat18);
					    u_xlat3.xyz = vec3(u_xlat18) * u_xlat2.xyz;
					    u_xlat1.x = dot(u_xlat3.xyz, u_xlat1.xyz);
					    u_xlati7 = int((0.0<u_xlat1.x) ? 0xFFFFFFFFu : uint(0));
					    u_xlati1 = int((u_xlat1.x<0.0) ? 0xFFFFFFFFu : uint(0));
					    u_xlati1 = (-u_xlati7) + u_xlati1;
					    u_xlat1.x = float(u_xlati1);
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xxx;
					    u_xlat1.xyz = _WorldSpaceLightPos0.www * (-vs_TEXCOORD3.xyz) + _WorldSpaceLightPos0.xyz;
					    u_xlat19 = dot(u_xlat1.xyz, u_xlat1.xyz);
					    u_xlat19 = inversesqrt(u_xlat19);
					    u_xlat1.xyz = vec3(u_xlat19) * u_xlat1.xyz;
					    u_xlat2.xyz = u_xlat2.xyz * vec3(u_xlat18) + u_xlat1.xyz;
					    u_xlat18 = dot(u_xlat2.xyz, u_xlat2.xyz);
					    u_xlat18 = inversesqrt(u_xlat18);
					    u_xlat2.xyz = vec3(u_xlat18) * u_xlat2.xyz;
					    u_xlat0.w = dot(u_xlat0.xyz, u_xlat2.xyz);
					    u_xlat1.w = dot(u_xlat1.xyz, u_xlat2.xyz);
					    u_xlat1.x = dot(u_xlat0.xyz, u_xlat1.xyz);
					    u_xlat0.x = dot(u_xlat0.xyz, u_xlat3.xyz);
					    u_xlat0.yz = max(u_xlat1.xw, vec2(0.0, 0.0));
					    u_xlat0.xw = max(u_xlat0.xw, vec2(0.0, 0.0));
					    u_xlat1.x = log2(u_xlat0.w);
					    u_xlat18 = u_xlat0.w * u_xlat0.w;
					    u_xlat1.x = u_xlat1.x * 9.99999975e-05;
					    u_xlat1.x = exp2(u_xlat1.x);
					    u_xlat7.x = u_xlat0.x * 0.202115417 + 0.797884583;
					    u_xlat13 = u_xlat0.y * 0.202115417 + 0.797884583;
					    u_xlat7.x = u_xlat13 * u_xlat7.x + 9.99999975e-06;
					    u_xlat1.y = float(1.0) / u_xlat7.x;
					    u_xlat1.xy = u_xlat1.xy * vec2(0.318325758, 0.25);
					    u_xlat7.x = u_xlat0.y * u_xlat1.y;
					    u_xlat1.x = u_xlat1.x * u_xlat7.x;
					    u_xlat1.x = u_xlat1.x * 0.616850257;
					    u_xlat7.x = max(abs(vs_TEXCOORD8.y), abs(vs_TEXCOORD8.x));
					    u_xlat7.x = max(u_xlat7.x, abs(vs_TEXCOORD8.z));
					    u_xlat7.x = u_xlat7.x + (-_LightProjectionParams.z);
					    u_xlat7.x = max(u_xlat7.x, 9.99999975e-06);
					    u_xlat7.x = u_xlat7.x * _LightProjectionParams.w;
					    u_xlat7.x = _LightProjectionParams.y / u_xlat7.x;
					    u_xlat7.x = u_xlat7.x + (-_LightProjectionParams.x);
					    u_xlat7.x = (-u_xlat7.x) + 1.0;
					    u_xlat2.xyz = vs_TEXCOORD8.xyz + vec3(0.0078125, 0.0078125, 0.0078125);
					    vec4 txVec0 = vec4(u_xlat2.xyz,u_xlat7.x);
					    u_xlat2.x = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec0, 0.0);
					    u_xlat3.xyz = vs_TEXCOORD8.xyz + vec3(-0.0078125, -0.0078125, 0.0078125);
					    vec4 txVec1 = vec4(u_xlat3.xyz,u_xlat7.x);
					    u_xlat2.y = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec1, 0.0);
					    u_xlat3.xyz = vs_TEXCOORD8.xyz + vec3(-0.0078125, 0.0078125, -0.0078125);
					    vec4 txVec2 = vec4(u_xlat3.xyz,u_xlat7.x);
					    u_xlat2.z = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec2, 0.0);
					    u_xlat3.xyz = vs_TEXCOORD8.xyz + vec3(0.0078125, -0.0078125, -0.0078125);
					    vec4 txVec3 = vec4(u_xlat3.xyz,u_xlat7.x);
					    u_xlat2.w = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec3, 0.0);
					    u_xlat7.x = dot(u_xlat2, vec4(0.25, 0.25, 0.25, 0.25));
					    u_xlat13 = (-_LightShadowData.x) + 1.0;
					    u_xlat7.x = u_xlat7.x * u_xlat13 + _LightShadowData.x;
					    u_xlat13 = dot(vs_TEXCOORD7.xyz, vs_TEXCOORD7.xyz);
					    u_xlat2 = texture(_LightTextureB0, vec2(u_xlat13));
					    u_xlat3 = texture(_LightTexture0, vs_TEXCOORD7.xyz);
					    u_xlat13 = u_xlat2.x * u_xlat3.w;
					    u_xlat7.x = u_xlat7.x * u_xlat13;
					    u_xlat7.xyz = u_xlat7.xxx * _LightColor0.xyz;
					    u_xlat2.xyz = vec3(u_xlat18) * u_xlat7.xyz;
					    u_xlat2.xyz = u_xlat1.xxx * u_xlat2.xyz;
					    u_xlat2.xyz = u_xlat2.xyz * _LightColor0.xyz;
					    u_xlat0.xw = (-u_xlat0.xz) + vec2(1.00001001, 1.0);
					    u_xlat1.x = u_xlat0.w * u_xlat0.w;
					    u_xlat1.x = u_xlat1.x * u_xlat1.x;
					    u_xlat18 = u_xlat0.w * u_xlat1.x;
					    u_xlat3.xy = vs_TEXCOORD0.xy * _MainTexture_ST.xy + _MainTexture_ST.zw;
					    u_xlat3 = texture(_MainTexture, u_xlat3.xy);
					    u_xlat3.xyz = _Color.xyz * u_xlat3.xyz + vec3(vec3(_Shadows, _Shadows, _Shadows));
					    u_xlat3.xyz = u_xlat3.xyz + vec3(-1.0, -1.0, -1.0);
					    u_xlat3.xyz = clamp(u_xlat3.xyz, 0.0, 1.0);
					    u_xlat4.xyz = u_xlat3.xyz + vec3(-0.220916301, -0.220916301, -0.220916301);
					    u_xlat5.xy = vs_TEXCOORD0.xy * _Specular_ST.xy + _Specular_ST.zw;
					    u_xlat5 = texture(_Specular, u_xlat5.xy);
					    u_xlat1.x = u_xlat5.x * 0.449999988;
					    u_xlat20 = (-u_xlat5.x) * 0.350587666 + 0.779083729;
					    u_xlat3.xyz = vec3(u_xlat20) * u_xlat3.xyz;
					    u_xlat4.xyz = u_xlat1.xxx * u_xlat4.xyz + vec3(0.220916301, 0.220916301, 0.220916301);
					    u_xlat5.xyz = (-u_xlat4.xyz) + vec3(1.0, 1.0, 1.0);
					    u_xlat4.xyz = u_xlat5.xyz * vec3(u_xlat18) + u_xlat4.xyz;
					    u_xlat2.xyz = u_xlat2.xyz * u_xlat4.xyz;
					    u_xlat18 = u_xlat0.x * u_xlat0.x;
					    u_xlat18 = u_xlat18 * u_xlat18;
					    u_xlat0.x = u_xlat18 * u_xlat0.x;
					    u_xlat18 = u_xlat0.z + u_xlat0.z;
					    u_xlat12 = u_xlat18 * u_xlat0.z + -0.5;
					    u_xlat0.x = u_xlat12 * u_xlat0.x + 1.0;
					    u_xlat18 = (-u_xlat0.y) + 1.00001001;
					    u_xlat1.x = u_xlat18 * u_xlat18;
					    u_xlat1.x = u_xlat1.x * u_xlat1.x;
					    u_xlat18 = u_xlat18 * u_xlat1.x;
					    u_xlat12 = u_xlat12 * u_xlat18 + 1.0;
					    u_xlat0.x = u_xlat0.x * u_xlat12;
					    u_xlat0.x = u_xlat0.y * u_xlat0.x;
					    u_xlat0.xyz = u_xlat7.xyz * u_xlat0.xxx;
					    SV_Target0.xyz = u_xlat0.xyz * u_xlat3.xyz + u_xlat2.xyz;
					    SV_Target0.w = 0.0;
					    return;
					}"
				}
				SubProgram "d3d11 " {
					Keywords { "POINT" "DIRLIGHTMAP_SEPARATE" "LIGHTMAP_OFF" "DYNAMICLIGHTMAP_OFF" }
					"ps_4_0
					
					#version 330
					#extension GL_ARB_explicit_attrib_location : require
					#extension GL_ARB_explicit_uniform_location : require
					
					#define HLSLCC_ENABLE_UNIFORM_BUFFERS 1
					#if HLSLCC_ENABLE_UNIFORM_BUFFERS
					#define UNITY_UNIFORM
					#else
					#define UNITY_UNIFORM uniform
					#endif
					#define UNITY_SUPPORTS_UNIFORM_LOCATION 1
					#if UNITY_SUPPORTS_UNIFORM_LOCATION
					#define UNITY_LOCATION(x) layout(location = x)
					#define UNITY_BINDING(x) layout(binding = x, std140)
					#else
					#define UNITY_LOCATION(x)
					#define UNITY_BINDING(x) layout(std140)
					#endif
					layout(std140) uniform PGlobals {
						vec4 unused_0_0[6];
						vec4 _LightColor0;
						vec4 unused_0_2;
						vec4 _MainTexture_ST;
						vec4 _Specular_ST;
						vec4 _NormalMap_ST;
						vec4 _Color;
						vec4 unused_0_7;
						float _NormalSharpness;
						float _Shadows;
					};
					layout(std140) uniform UnityPerCamera {
						vec4 unused_1_0[4];
						vec3 _WorldSpaceCameraPos;
						vec4 unused_1_2[4];
					};
					layout(std140) uniform UnityLighting {
						vec4 _WorldSpaceLightPos0;
						vec4 unused_2_1[47];
					};
					uniform  sampler2D _NormalMap;
					uniform  sampler2D _LightTexture0;
					uniform  sampler2D _MainTexture;
					uniform  sampler2D _Specular;
					in  vec2 vs_TEXCOORD0;
					in  vec4 vs_TEXCOORD3;
					in  vec3 vs_TEXCOORD4;
					in  vec3 vs_TEXCOORD5;
					in  vec3 vs_TEXCOORD6;
					in  vec3 vs_TEXCOORD7;
					layout(location = 0) out vec4 SV_Target0;
					vec4 u_xlat0;
					vec4 u_xlat1;
					int u_xlati1;
					vec4 u_xlat2;
					vec4 u_xlat3;
					vec3 u_xlat4;
					vec4 u_xlat5;
					vec3 u_xlat7;
					int u_xlati7;
					float u_xlat12;
					float u_xlat13;
					float u_xlat18;
					float u_xlat19;
					float u_xlat20;
					void main()
					{
					    u_xlat0.xy = vs_TEXCOORD0.xy * _NormalMap_ST.xy + _NormalMap_ST.zw;
					    u_xlat0 = texture(_NormalMap, u_xlat0.xy);
					    u_xlat0.x = u_xlat0.w * u_xlat0.x;
					    u_xlat0.xy = u_xlat0.xy * vec2(2.0, 2.0) + vec2(-1.0, -1.0);
					    u_xlat18 = dot(u_xlat0.xy, u_xlat0.xy);
					    u_xlat18 = min(u_xlat18, 1.0);
					    u_xlat18 = (-u_xlat18) + 1.0;
					    u_xlat0.z = sqrt(u_xlat18);
					    u_xlat18 = (-_NormalSharpness) + 1.0;
					    u_xlat0.xyz = u_xlat0.xyz / vec3(u_xlat18);
					    u_xlat0.xyz = clamp(u_xlat0.xyz, 0.0, 1.0);
					    u_xlat1.xyz = u_xlat0.yyy * vs_TEXCOORD6.xyz;
					    u_xlat0.xyw = u_xlat0.xxx * vs_TEXCOORD5.xyz + u_xlat1.xyz;
					    u_xlat1.x = dot(vs_TEXCOORD4.xyz, vs_TEXCOORD4.xyz);
					    u_xlat1.x = inversesqrt(u_xlat1.x);
					    u_xlat1.xyz = u_xlat1.xxx * vs_TEXCOORD4.xyz;
					    u_xlat0.xyz = u_xlat0.zzz * u_xlat1.xyz + u_xlat0.xyw;
					    u_xlat18 = dot(u_xlat0.xyz, u_xlat0.xyz);
					    u_xlat18 = inversesqrt(u_xlat18);
					    u_xlat0.xyz = vec3(u_xlat18) * u_xlat0.xyz;
					    u_xlat2.xyz = (-vs_TEXCOORD3.xyz) + _WorldSpaceCameraPos.xyz;
					    u_xlat18 = dot(u_xlat2.xyz, u_xlat2.xyz);
					    u_xlat18 = inversesqrt(u_xlat18);
					    u_xlat3.xyz = vec3(u_xlat18) * u_xlat2.xyz;
					    u_xlat1.x = dot(u_xlat3.xyz, u_xlat1.xyz);
					    u_xlati7 = int((0.0<u_xlat1.x) ? 0xFFFFFFFFu : uint(0));
					    u_xlati1 = int((u_xlat1.x<0.0) ? 0xFFFFFFFFu : uint(0));
					    u_xlati1 = (-u_xlati7) + u_xlati1;
					    u_xlat1.x = float(u_xlati1);
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xxx;
					    u_xlat1.xyz = _WorldSpaceLightPos0.www * (-vs_TEXCOORD3.xyz) + _WorldSpaceLightPos0.xyz;
					    u_xlat19 = dot(u_xlat1.xyz, u_xlat1.xyz);
					    u_xlat19 = inversesqrt(u_xlat19);
					    u_xlat1.xyz = vec3(u_xlat19) * u_xlat1.xyz;
					    u_xlat2.xyz = u_xlat2.xyz * vec3(u_xlat18) + u_xlat1.xyz;
					    u_xlat18 = dot(u_xlat2.xyz, u_xlat2.xyz);
					    u_xlat18 = inversesqrt(u_xlat18);
					    u_xlat2.xyz = vec3(u_xlat18) * u_xlat2.xyz;
					    u_xlat0.w = dot(u_xlat0.xyz, u_xlat2.xyz);
					    u_xlat1.w = dot(u_xlat1.xyz, u_xlat2.xyz);
					    u_xlat1.x = dot(u_xlat0.xyz, u_xlat1.xyz);
					    u_xlat0.x = dot(u_xlat0.xyz, u_xlat3.xyz);
					    u_xlat0.yz = max(u_xlat1.xw, vec2(0.0, 0.0));
					    u_xlat0.xw = max(u_xlat0.xw, vec2(0.0, 0.0));
					    u_xlat1.x = log2(u_xlat0.w);
					    u_xlat18 = u_xlat0.w * u_xlat0.w;
					    u_xlat1.x = u_xlat1.x * 9.99999975e-05;
					    u_xlat1.x = exp2(u_xlat1.x);
					    u_xlat7.x = u_xlat0.x * 0.202115417 + 0.797884583;
					    u_xlat13 = u_xlat0.y * 0.202115417 + 0.797884583;
					    u_xlat7.x = u_xlat13 * u_xlat7.x + 9.99999975e-06;
					    u_xlat1.y = float(1.0) / u_xlat7.x;
					    u_xlat1.xy = u_xlat1.xy * vec2(0.318325758, 0.25);
					    u_xlat7.x = u_xlat0.y * u_xlat1.y;
					    u_xlat1.x = u_xlat1.x * u_xlat7.x;
					    u_xlat1.x = u_xlat1.x * 0.616850257;
					    u_xlat7.x = dot(vs_TEXCOORD7.xyz, vs_TEXCOORD7.xyz);
					    u_xlat2 = texture(_LightTexture0, u_xlat7.xx);
					    u_xlat7.xyz = u_xlat2.xxx * _LightColor0.xyz;
					    u_xlat2.xyz = vec3(u_xlat18) * u_xlat7.xyz;
					    u_xlat2.xyz = u_xlat1.xxx * u_xlat2.xyz;
					    u_xlat2.xyz = u_xlat2.xyz * _LightColor0.xyz;
					    u_xlat0.xw = (-u_xlat0.xz) + vec2(1.00001001, 1.0);
					    u_xlat1.x = u_xlat0.w * u_xlat0.w;
					    u_xlat1.x = u_xlat1.x * u_xlat1.x;
					    u_xlat18 = u_xlat0.w * u_xlat1.x;
					    u_xlat3.xy = vs_TEXCOORD0.xy * _MainTexture_ST.xy + _MainTexture_ST.zw;
					    u_xlat3 = texture(_MainTexture, u_xlat3.xy);
					    u_xlat3.xyz = _Color.xyz * u_xlat3.xyz + vec3(vec3(_Shadows, _Shadows, _Shadows));
					    u_xlat3.xyz = u_xlat3.xyz + vec3(-1.0, -1.0, -1.0);
					    u_xlat3.xyz = clamp(u_xlat3.xyz, 0.0, 1.0);
					    u_xlat4.xyz = u_xlat3.xyz + vec3(-0.220916301, -0.220916301, -0.220916301);
					    u_xlat5.xy = vs_TEXCOORD0.xy * _Specular_ST.xy + _Specular_ST.zw;
					    u_xlat5 = texture(_Specular, u_xlat5.xy);
					    u_xlat1.x = u_xlat5.x * 0.449999988;
					    u_xlat20 = (-u_xlat5.x) * 0.350587666 + 0.779083729;
					    u_xlat3.xyz = vec3(u_xlat20) * u_xlat3.xyz;
					    u_xlat4.xyz = u_xlat1.xxx * u_xlat4.xyz + vec3(0.220916301, 0.220916301, 0.220916301);
					    u_xlat5.xyz = (-u_xlat4.xyz) + vec3(1.0, 1.0, 1.0);
					    u_xlat4.xyz = u_xlat5.xyz * vec3(u_xlat18) + u_xlat4.xyz;
					    u_xlat2.xyz = u_xlat2.xyz * u_xlat4.xyz;
					    u_xlat18 = u_xlat0.x * u_xlat0.x;
					    u_xlat18 = u_xlat18 * u_xlat18;
					    u_xlat0.x = u_xlat18 * u_xlat0.x;
					    u_xlat18 = u_xlat0.z + u_xlat0.z;
					    u_xlat12 = u_xlat18 * u_xlat0.z + -0.5;
					    u_xlat0.x = u_xlat12 * u_xlat0.x + 1.0;
					    u_xlat18 = (-u_xlat0.y) + 1.00001001;
					    u_xlat1.x = u_xlat18 * u_xlat18;
					    u_xlat1.x = u_xlat1.x * u_xlat1.x;
					    u_xlat18 = u_xlat18 * u_xlat1.x;
					    u_xlat12 = u_xlat12 * u_xlat18 + 1.0;
					    u_xlat0.x = u_xlat0.x * u_xlat12;
					    u_xlat0.x = u_xlat0.y * u_xlat0.x;
					    u_xlat0.xyz = u_xlat7.xyz * u_xlat0.xxx;
					    SV_Target0.xyz = u_xlat0.xyz * u_xlat3.xyz + u_xlat2.xyz;
					    SV_Target0.w = 0.0;
					    return;
					}"
				}
				SubProgram "d3d11 " {
					Keywords { "DIRECTIONAL" "DIRLIGHTMAP_SEPARATE" "LIGHTMAP_OFF" "DYNAMICLIGHTMAP_OFF" }
					"ps_4_0
					
					#version 330
					#extension GL_ARB_explicit_attrib_location : require
					#extension GL_ARB_explicit_uniform_location : require
					
					#define HLSLCC_ENABLE_UNIFORM_BUFFERS 1
					#if HLSLCC_ENABLE_UNIFORM_BUFFERS
					#define UNITY_UNIFORM
					#else
					#define UNITY_UNIFORM uniform
					#endif
					#define UNITY_SUPPORTS_UNIFORM_LOCATION 1
					#if UNITY_SUPPORTS_UNIFORM_LOCATION
					#define UNITY_LOCATION(x) layout(location = x)
					#define UNITY_BINDING(x) layout(binding = x, std140)
					#else
					#define UNITY_LOCATION(x)
					#define UNITY_BINDING(x) layout(std140)
					#endif
					layout(std140) uniform PGlobals {
						vec4 unused_0_0[2];
						vec4 _LightColor0;
						vec4 unused_0_2;
						vec4 _MainTexture_ST;
						vec4 _Specular_ST;
						vec4 _NormalMap_ST;
						vec4 _Color;
						vec4 unused_0_7;
						float _NormalSharpness;
						float _Shadows;
					};
					layout(std140) uniform UnityPerCamera {
						vec4 unused_1_0[4];
						vec3 _WorldSpaceCameraPos;
						vec4 unused_1_2[4];
					};
					layout(std140) uniform UnityLighting {
						vec4 _WorldSpaceLightPos0;
						vec4 unused_2_1[47];
					};
					uniform  sampler2D _NormalMap;
					uniform  sampler2D _MainTexture;
					uniform  sampler2D _Specular;
					in  vec2 vs_TEXCOORD0;
					in  vec4 vs_TEXCOORD3;
					in  vec3 vs_TEXCOORD4;
					in  vec3 vs_TEXCOORD5;
					in  vec3 vs_TEXCOORD6;
					layout(location = 0) out vec4 SV_Target0;
					vec4 u_xlat0;
					vec4 u_xlat1;
					int u_xlati1;
					vec4 u_xlat2;
					vec3 u_xlat3;
					vec4 u_xlat4;
					vec3 u_xlat6;
					int u_xlati6;
					float u_xlat10;
					float u_xlat15;
					float u_xlat16;
					float u_xlat17;
					void main()
					{
					    u_xlat0.xy = vs_TEXCOORD0.xy * _NormalMap_ST.xy + _NormalMap_ST.zw;
					    u_xlat0 = texture(_NormalMap, u_xlat0.xy);
					    u_xlat0.x = u_xlat0.w * u_xlat0.x;
					    u_xlat0.xy = u_xlat0.xy * vec2(2.0, 2.0) + vec2(-1.0, -1.0);
					    u_xlat15 = dot(u_xlat0.xy, u_xlat0.xy);
					    u_xlat15 = min(u_xlat15, 1.0);
					    u_xlat15 = (-u_xlat15) + 1.0;
					    u_xlat0.z = sqrt(u_xlat15);
					    u_xlat15 = (-_NormalSharpness) + 1.0;
					    u_xlat0.xyz = u_xlat0.xyz / vec3(u_xlat15);
					    u_xlat0.xyz = clamp(u_xlat0.xyz, 0.0, 1.0);
					    u_xlat1.xyz = u_xlat0.yyy * vs_TEXCOORD6.xyz;
					    u_xlat0.xyw = u_xlat0.xxx * vs_TEXCOORD5.xyz + u_xlat1.xyz;
					    u_xlat1.x = dot(vs_TEXCOORD4.xyz, vs_TEXCOORD4.xyz);
					    u_xlat1.x = inversesqrt(u_xlat1.x);
					    u_xlat1.xyz = u_xlat1.xxx * vs_TEXCOORD4.xyz;
					    u_xlat0.xyz = u_xlat0.zzz * u_xlat1.xyz + u_xlat0.xyw;
					    u_xlat15 = dot(u_xlat0.xyz, u_xlat0.xyz);
					    u_xlat15 = inversesqrt(u_xlat15);
					    u_xlat0.xyz = vec3(u_xlat15) * u_xlat0.xyz;
					    u_xlat2.xyz = (-vs_TEXCOORD3.xyz) + _WorldSpaceCameraPos.xyz;
					    u_xlat15 = dot(u_xlat2.xyz, u_xlat2.xyz);
					    u_xlat15 = inversesqrt(u_xlat15);
					    u_xlat3.xyz = vec3(u_xlat15) * u_xlat2.xyz;
					    u_xlat1.x = dot(u_xlat3.xyz, u_xlat1.xyz);
					    u_xlati6 = int((0.0<u_xlat1.x) ? 0xFFFFFFFFu : uint(0));
					    u_xlati1 = int((u_xlat1.x<0.0) ? 0xFFFFFFFFu : uint(0));
					    u_xlati1 = (-u_xlati6) + u_xlati1;
					    u_xlat1.x = float(u_xlati1);
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xxx;
					    u_xlat1.xyz = _WorldSpaceLightPos0.www * (-vs_TEXCOORD3.xyz) + _WorldSpaceLightPos0.xyz;
					    u_xlat16 = dot(u_xlat1.xyz, u_xlat1.xyz);
					    u_xlat16 = inversesqrt(u_xlat16);
					    u_xlat1.xyz = vec3(u_xlat16) * u_xlat1.xyz;
					    u_xlat2.xyz = u_xlat2.xyz * vec3(u_xlat15) + u_xlat1.xyz;
					    u_xlat15 = dot(u_xlat2.xyz, u_xlat2.xyz);
					    u_xlat15 = inversesqrt(u_xlat15);
					    u_xlat2.xyz = vec3(u_xlat15) * u_xlat2.xyz;
					    u_xlat0.w = dot(u_xlat0.xyz, u_xlat2.xyz);
					    u_xlat1.w = dot(u_xlat1.xyz, u_xlat2.xyz);
					    u_xlat1.x = dot(u_xlat0.xyz, u_xlat1.xyz);
					    u_xlat0.x = dot(u_xlat0.xyz, u_xlat3.xyz);
					    u_xlat0.yz = max(u_xlat1.xw, vec2(0.0, 0.0));
					    u_xlat0.xw = max(u_xlat0.xw, vec2(0.0, 0.0));
					    u_xlat1.x = log2(u_xlat0.w);
					    u_xlat15 = u_xlat0.w * u_xlat0.w;
					    u_xlat6.xyz = vec3(u_xlat15) * _LightColor0.xyz;
					    u_xlat15 = u_xlat1.x * 9.99999975e-05;
					    u_xlat15 = exp2(u_xlat15);
					    u_xlat15 = u_xlat15 * 0.318325758;
					    u_xlat1.x = u_xlat0.x * 0.202115417 + 0.797884583;
					    u_xlat2.x = u_xlat0.y * 0.202115417 + 0.797884583;
					    u_xlat1.x = u_xlat2.x * u_xlat1.x + 9.99999975e-06;
					    u_xlat1.x = float(1.0) / u_xlat1.x;
					    u_xlat1.x = u_xlat1.x * 0.25;
					    u_xlat1.x = u_xlat0.y * u_xlat1.x;
					    u_xlat15 = u_xlat15 * u_xlat1.x;
					    u_xlat15 = u_xlat15 * 0.616850257;
					    u_xlat1.xyz = vec3(u_xlat15) * u_xlat6.xyz;
					    u_xlat1.xyz = u_xlat1.xyz * _LightColor0.xyz;
					    u_xlat0.xw = (-u_xlat0.xz) + vec2(1.00001001, 1.0);
					    u_xlat16 = u_xlat0.w * u_xlat0.w;
					    u_xlat16 = u_xlat16 * u_xlat16;
					    u_xlat15 = u_xlat0.w * u_xlat16;
					    u_xlat2.xy = vs_TEXCOORD0.xy * _MainTexture_ST.xy + _MainTexture_ST.zw;
					    u_xlat2 = texture(_MainTexture, u_xlat2.xy);
					    u_xlat2.xyz = _Color.xyz * u_xlat2.xyz + vec3(vec3(_Shadows, _Shadows, _Shadows));
					    u_xlat2.xyz = u_xlat2.xyz + vec3(-1.0, -1.0, -1.0);
					    u_xlat2.xyz = clamp(u_xlat2.xyz, 0.0, 1.0);
					    u_xlat3.xyz = u_xlat2.xyz + vec3(-0.220916301, -0.220916301, -0.220916301);
					    u_xlat4.xy = vs_TEXCOORD0.xy * _Specular_ST.xy + _Specular_ST.zw;
					    u_xlat4 = texture(_Specular, u_xlat4.xy);
					    u_xlat16 = u_xlat4.x * 0.449999988;
					    u_xlat17 = (-u_xlat4.x) * 0.350587666 + 0.779083729;
					    u_xlat2.xyz = vec3(u_xlat17) * u_xlat2.xyz;
					    u_xlat3.xyz = vec3(u_xlat16) * u_xlat3.xyz + vec3(0.220916301, 0.220916301, 0.220916301);
					    u_xlat4.xyz = (-u_xlat3.xyz) + vec3(1.0, 1.0, 1.0);
					    u_xlat3.xyz = u_xlat4.xyz * vec3(u_xlat15) + u_xlat3.xyz;
					    u_xlat1.xyz = u_xlat1.xyz * u_xlat3.xyz;
					    u_xlat15 = u_xlat0.x * u_xlat0.x;
					    u_xlat15 = u_xlat15 * u_xlat15;
					    u_xlat0.x = u_xlat15 * u_xlat0.x;
					    u_xlat15 = u_xlat0.z + u_xlat0.z;
					    u_xlat10 = u_xlat15 * u_xlat0.z + -0.5;
					    u_xlat0.x = u_xlat10 * u_xlat0.x + 1.0;
					    u_xlat15 = (-u_xlat0.y) + 1.00001001;
					    u_xlat16 = u_xlat15 * u_xlat15;
					    u_xlat16 = u_xlat16 * u_xlat16;
					    u_xlat15 = u_xlat15 * u_xlat16;
					    u_xlat10 = u_xlat10 * u_xlat15 + 1.0;
					    u_xlat0.x = u_xlat0.x * u_xlat10;
					    u_xlat0.x = u_xlat0.y * u_xlat0.x;
					    u_xlat0.xyz = u_xlat0.xxx * _LightColor0.xyz;
					    SV_Target0.xyz = u_xlat0.xyz * u_xlat2.xyz + u_xlat1.xyz;
					    SV_Target0.w = 0.0;
					    return;
					}"
				}
				SubProgram "d3d11 " {
					Keywords { "SPOT" "DIRLIGHTMAP_SEPARATE" "LIGHTMAP_OFF" "DYNAMICLIGHTMAP_OFF" }
					"ps_4_0
					
					#version 330
					#extension GL_ARB_explicit_attrib_location : require
					#extension GL_ARB_explicit_uniform_location : require
					
					#define HLSLCC_ENABLE_UNIFORM_BUFFERS 1
					#if HLSLCC_ENABLE_UNIFORM_BUFFERS
					#define UNITY_UNIFORM
					#else
					#define UNITY_UNIFORM uniform
					#endif
					#define UNITY_SUPPORTS_UNIFORM_LOCATION 1
					#if UNITY_SUPPORTS_UNIFORM_LOCATION
					#define UNITY_LOCATION(x) layout(location = x)
					#define UNITY_BINDING(x) layout(binding = x, std140)
					#else
					#define UNITY_LOCATION(x)
					#define UNITY_BINDING(x) layout(std140)
					#endif
					layout(std140) uniform PGlobals {
						vec4 unused_0_0[6];
						vec4 _LightColor0;
						vec4 unused_0_2;
						vec4 _MainTexture_ST;
						vec4 _Specular_ST;
						vec4 _NormalMap_ST;
						vec4 _Color;
						vec4 unused_0_7;
						float _NormalSharpness;
						float _Shadows;
					};
					layout(std140) uniform UnityPerCamera {
						vec4 unused_1_0[4];
						vec3 _WorldSpaceCameraPos;
						vec4 unused_1_2[4];
					};
					layout(std140) uniform UnityLighting {
						vec4 _WorldSpaceLightPos0;
						vec4 unused_2_1[47];
					};
					uniform  sampler2D _NormalMap;
					uniform  sampler2D _LightTexture0;
					uniform  sampler2D _LightTextureB0;
					uniform  sampler2D _MainTexture;
					uniform  sampler2D _Specular;
					in  vec2 vs_TEXCOORD0;
					in  vec4 vs_TEXCOORD3;
					in  vec3 vs_TEXCOORD4;
					in  vec3 vs_TEXCOORD5;
					in  vec3 vs_TEXCOORD6;
					in  vec4 vs_TEXCOORD7;
					layout(location = 0) out vec4 SV_Target0;
					vec4 u_xlat0;
					vec4 u_xlat1;
					int u_xlati1;
					vec4 u_xlat2;
					vec4 u_xlat3;
					vec3 u_xlat4;
					vec4 u_xlat5;
					vec3 u_xlat7;
					int u_xlati7;
					bool u_xlatb7;
					float u_xlat12;
					float u_xlat13;
					float u_xlat18;
					float u_xlat19;
					float u_xlat20;
					void main()
					{
					    u_xlat0.xy = vs_TEXCOORD0.xy * _NormalMap_ST.xy + _NormalMap_ST.zw;
					    u_xlat0 = texture(_NormalMap, u_xlat0.xy);
					    u_xlat0.x = u_xlat0.w * u_xlat0.x;
					    u_xlat0.xy = u_xlat0.xy * vec2(2.0, 2.0) + vec2(-1.0, -1.0);
					    u_xlat18 = dot(u_xlat0.xy, u_xlat0.xy);
					    u_xlat18 = min(u_xlat18, 1.0);
					    u_xlat18 = (-u_xlat18) + 1.0;
					    u_xlat0.z = sqrt(u_xlat18);
					    u_xlat18 = (-_NormalSharpness) + 1.0;
					    u_xlat0.xyz = u_xlat0.xyz / vec3(u_xlat18);
					    u_xlat0.xyz = clamp(u_xlat0.xyz, 0.0, 1.0);
					    u_xlat1.xyz = u_xlat0.yyy * vs_TEXCOORD6.xyz;
					    u_xlat0.xyw = u_xlat0.xxx * vs_TEXCOORD5.xyz + u_xlat1.xyz;
					    u_xlat1.x = dot(vs_TEXCOORD4.xyz, vs_TEXCOORD4.xyz);
					    u_xlat1.x = inversesqrt(u_xlat1.x);
					    u_xlat1.xyz = u_xlat1.xxx * vs_TEXCOORD4.xyz;
					    u_xlat0.xyz = u_xlat0.zzz * u_xlat1.xyz + u_xlat0.xyw;
					    u_xlat18 = dot(u_xlat0.xyz, u_xlat0.xyz);
					    u_xlat18 = inversesqrt(u_xlat18);
					    u_xlat0.xyz = vec3(u_xlat18) * u_xlat0.xyz;
					    u_xlat2.xyz = (-vs_TEXCOORD3.xyz) + _WorldSpaceCameraPos.xyz;
					    u_xlat18 = dot(u_xlat2.xyz, u_xlat2.xyz);
					    u_xlat18 = inversesqrt(u_xlat18);
					    u_xlat3.xyz = vec3(u_xlat18) * u_xlat2.xyz;
					    u_xlat1.x = dot(u_xlat3.xyz, u_xlat1.xyz);
					    u_xlati7 = int((0.0<u_xlat1.x) ? 0xFFFFFFFFu : uint(0));
					    u_xlati1 = int((u_xlat1.x<0.0) ? 0xFFFFFFFFu : uint(0));
					    u_xlati1 = (-u_xlati7) + u_xlati1;
					    u_xlat1.x = float(u_xlati1);
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xxx;
					    u_xlat1.xyz = _WorldSpaceLightPos0.www * (-vs_TEXCOORD3.xyz) + _WorldSpaceLightPos0.xyz;
					    u_xlat19 = dot(u_xlat1.xyz, u_xlat1.xyz);
					    u_xlat19 = inversesqrt(u_xlat19);
					    u_xlat1.xyz = vec3(u_xlat19) * u_xlat1.xyz;
					    u_xlat2.xyz = u_xlat2.xyz * vec3(u_xlat18) + u_xlat1.xyz;
					    u_xlat18 = dot(u_xlat2.xyz, u_xlat2.xyz);
					    u_xlat18 = inversesqrt(u_xlat18);
					    u_xlat2.xyz = vec3(u_xlat18) * u_xlat2.xyz;
					    u_xlat0.w = dot(u_xlat0.xyz, u_xlat2.xyz);
					    u_xlat1.w = dot(u_xlat1.xyz, u_xlat2.xyz);
					    u_xlat1.x = dot(u_xlat0.xyz, u_xlat1.xyz);
					    u_xlat0.x = dot(u_xlat0.xyz, u_xlat3.xyz);
					    u_xlat0.yz = max(u_xlat1.xw, vec2(0.0, 0.0));
					    u_xlat0.xw = max(u_xlat0.xw, vec2(0.0, 0.0));
					    u_xlat1.x = log2(u_xlat0.w);
					    u_xlat18 = u_xlat0.w * u_xlat0.w;
					    u_xlat1.x = u_xlat1.x * 9.99999975e-05;
					    u_xlat1.x = exp2(u_xlat1.x);
					    u_xlat7.x = u_xlat0.x * 0.202115417 + 0.797884583;
					    u_xlat13 = u_xlat0.y * 0.202115417 + 0.797884583;
					    u_xlat7.x = u_xlat13 * u_xlat7.x + 9.99999975e-06;
					    u_xlat1.y = float(1.0) / u_xlat7.x;
					    u_xlat1.xy = u_xlat1.xy * vec2(0.318325758, 0.25);
					    u_xlat7.x = u_xlat0.y * u_xlat1.y;
					    u_xlat1.x = u_xlat1.x * u_xlat7.x;
					    u_xlat1.x = u_xlat1.x * 0.616850257;
					    u_xlat7.xy = vs_TEXCOORD7.xy / vs_TEXCOORD7.ww;
					    u_xlat7.xy = u_xlat7.xy + vec2(0.5, 0.5);
					    u_xlat2 = texture(_LightTexture0, u_xlat7.xy);
					    u_xlatb7 = 0.0<vs_TEXCOORD7.z;
					    u_xlat7.x = u_xlatb7 ? 1.0 : float(0.0);
					    u_xlat7.x = u_xlat2.w * u_xlat7.x;
					    u_xlat13 = dot(vs_TEXCOORD7.xyz, vs_TEXCOORD7.xyz);
					    u_xlat2 = texture(_LightTextureB0, vec2(u_xlat13));
					    u_xlat7.x = u_xlat7.x * u_xlat2.x;
					    u_xlat7.xyz = u_xlat7.xxx * _LightColor0.xyz;
					    u_xlat2.xyz = vec3(u_xlat18) * u_xlat7.xyz;
					    u_xlat2.xyz = u_xlat1.xxx * u_xlat2.xyz;
					    u_xlat2.xyz = u_xlat2.xyz * _LightColor0.xyz;
					    u_xlat0.xw = (-u_xlat0.xz) + vec2(1.00001001, 1.0);
					    u_xlat1.x = u_xlat0.w * u_xlat0.w;
					    u_xlat1.x = u_xlat1.x * u_xlat1.x;
					    u_xlat18 = u_xlat0.w * u_xlat1.x;
					    u_xlat3.xy = vs_TEXCOORD0.xy * _MainTexture_ST.xy + _MainTexture_ST.zw;
					    u_xlat3 = texture(_MainTexture, u_xlat3.xy);
					    u_xlat3.xyz = _Color.xyz * u_xlat3.xyz + vec3(vec3(_Shadows, _Shadows, _Shadows));
					    u_xlat3.xyz = u_xlat3.xyz + vec3(-1.0, -1.0, -1.0);
					    u_xlat3.xyz = clamp(u_xlat3.xyz, 0.0, 1.0);
					    u_xlat4.xyz = u_xlat3.xyz + vec3(-0.220916301, -0.220916301, -0.220916301);
					    u_xlat5.xy = vs_TEXCOORD0.xy * _Specular_ST.xy + _Specular_ST.zw;
					    u_xlat5 = texture(_Specular, u_xlat5.xy);
					    u_xlat1.x = u_xlat5.x * 0.449999988;
					    u_xlat20 = (-u_xlat5.x) * 0.350587666 + 0.779083729;
					    u_xlat3.xyz = vec3(u_xlat20) * u_xlat3.xyz;
					    u_xlat4.xyz = u_xlat1.xxx * u_xlat4.xyz + vec3(0.220916301, 0.220916301, 0.220916301);
					    u_xlat5.xyz = (-u_xlat4.xyz) + vec3(1.0, 1.0, 1.0);
					    u_xlat4.xyz = u_xlat5.xyz * vec3(u_xlat18) + u_xlat4.xyz;
					    u_xlat2.xyz = u_xlat2.xyz * u_xlat4.xyz;
					    u_xlat18 = u_xlat0.x * u_xlat0.x;
					    u_xlat18 = u_xlat18 * u_xlat18;
					    u_xlat0.x = u_xlat18 * u_xlat0.x;
					    u_xlat18 = u_xlat0.z + u_xlat0.z;
					    u_xlat12 = u_xlat18 * u_xlat0.z + -0.5;
					    u_xlat0.x = u_xlat12 * u_xlat0.x + 1.0;
					    u_xlat18 = (-u_xlat0.y) + 1.00001001;
					    u_xlat1.x = u_xlat18 * u_xlat18;
					    u_xlat1.x = u_xlat1.x * u_xlat1.x;
					    u_xlat18 = u_xlat18 * u_xlat1.x;
					    u_xlat12 = u_xlat12 * u_xlat18 + 1.0;
					    u_xlat0.x = u_xlat0.x * u_xlat12;
					    u_xlat0.x = u_xlat0.y * u_xlat0.x;
					    u_xlat0.xyz = u_xlat7.xyz * u_xlat0.xxx;
					    SV_Target0.xyz = u_xlat0.xyz * u_xlat3.xyz + u_xlat2.xyz;
					    SV_Target0.w = 0.0;
					    return;
					}"
				}
				SubProgram "d3d11 " {
					Keywords { "POINT_COOKIE" "DIRLIGHTMAP_SEPARATE" "LIGHTMAP_OFF" "DYNAMICLIGHTMAP_OFF" }
					"ps_4_0
					
					#version 330
					#extension GL_ARB_explicit_attrib_location : require
					#extension GL_ARB_explicit_uniform_location : require
					
					#define HLSLCC_ENABLE_UNIFORM_BUFFERS 1
					#if HLSLCC_ENABLE_UNIFORM_BUFFERS
					#define UNITY_UNIFORM
					#else
					#define UNITY_UNIFORM uniform
					#endif
					#define UNITY_SUPPORTS_UNIFORM_LOCATION 1
					#if UNITY_SUPPORTS_UNIFORM_LOCATION
					#define UNITY_LOCATION(x) layout(location = x)
					#define UNITY_BINDING(x) layout(binding = x, std140)
					#else
					#define UNITY_LOCATION(x)
					#define UNITY_BINDING(x) layout(std140)
					#endif
					layout(std140) uniform PGlobals {
						vec4 unused_0_0[6];
						vec4 _LightColor0;
						vec4 unused_0_2;
						vec4 _MainTexture_ST;
						vec4 _Specular_ST;
						vec4 _NormalMap_ST;
						vec4 _Color;
						vec4 unused_0_7;
						float _NormalSharpness;
						float _Shadows;
					};
					layout(std140) uniform UnityPerCamera {
						vec4 unused_1_0[4];
						vec3 _WorldSpaceCameraPos;
						vec4 unused_1_2[4];
					};
					layout(std140) uniform UnityLighting {
						vec4 _WorldSpaceLightPos0;
						vec4 unused_2_1[47];
					};
					uniform  sampler2D _NormalMap;
					uniform  sampler2D _LightTextureB0;
					uniform  samplerCube _LightTexture0;
					uniform  sampler2D _MainTexture;
					uniform  sampler2D _Specular;
					in  vec2 vs_TEXCOORD0;
					in  vec4 vs_TEXCOORD3;
					in  vec3 vs_TEXCOORD4;
					in  vec3 vs_TEXCOORD5;
					in  vec3 vs_TEXCOORD6;
					in  vec3 vs_TEXCOORD7;
					layout(location = 0) out vec4 SV_Target0;
					vec4 u_xlat0;
					vec4 u_xlat1;
					int u_xlati1;
					vec4 u_xlat2;
					vec4 u_xlat3;
					vec3 u_xlat4;
					vec4 u_xlat5;
					vec3 u_xlat7;
					int u_xlati7;
					float u_xlat12;
					float u_xlat13;
					float u_xlat18;
					float u_xlat19;
					float u_xlat20;
					void main()
					{
					    u_xlat0.xy = vs_TEXCOORD0.xy * _NormalMap_ST.xy + _NormalMap_ST.zw;
					    u_xlat0 = texture(_NormalMap, u_xlat0.xy);
					    u_xlat0.x = u_xlat0.w * u_xlat0.x;
					    u_xlat0.xy = u_xlat0.xy * vec2(2.0, 2.0) + vec2(-1.0, -1.0);
					    u_xlat18 = dot(u_xlat0.xy, u_xlat0.xy);
					    u_xlat18 = min(u_xlat18, 1.0);
					    u_xlat18 = (-u_xlat18) + 1.0;
					    u_xlat0.z = sqrt(u_xlat18);
					    u_xlat18 = (-_NormalSharpness) + 1.0;
					    u_xlat0.xyz = u_xlat0.xyz / vec3(u_xlat18);
					    u_xlat0.xyz = clamp(u_xlat0.xyz, 0.0, 1.0);
					    u_xlat1.xyz = u_xlat0.yyy * vs_TEXCOORD6.xyz;
					    u_xlat0.xyw = u_xlat0.xxx * vs_TEXCOORD5.xyz + u_xlat1.xyz;
					    u_xlat1.x = dot(vs_TEXCOORD4.xyz, vs_TEXCOORD4.xyz);
					    u_xlat1.x = inversesqrt(u_xlat1.x);
					    u_xlat1.xyz = u_xlat1.xxx * vs_TEXCOORD4.xyz;
					    u_xlat0.xyz = u_xlat0.zzz * u_xlat1.xyz + u_xlat0.xyw;
					    u_xlat18 = dot(u_xlat0.xyz, u_xlat0.xyz);
					    u_xlat18 = inversesqrt(u_xlat18);
					    u_xlat0.xyz = vec3(u_xlat18) * u_xlat0.xyz;
					    u_xlat2.xyz = (-vs_TEXCOORD3.xyz) + _WorldSpaceCameraPos.xyz;
					    u_xlat18 = dot(u_xlat2.xyz, u_xlat2.xyz);
					    u_xlat18 = inversesqrt(u_xlat18);
					    u_xlat3.xyz = vec3(u_xlat18) * u_xlat2.xyz;
					    u_xlat1.x = dot(u_xlat3.xyz, u_xlat1.xyz);
					    u_xlati7 = int((0.0<u_xlat1.x) ? 0xFFFFFFFFu : uint(0));
					    u_xlati1 = int((u_xlat1.x<0.0) ? 0xFFFFFFFFu : uint(0));
					    u_xlati1 = (-u_xlati7) + u_xlati1;
					    u_xlat1.x = float(u_xlati1);
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xxx;
					    u_xlat1.xyz = _WorldSpaceLightPos0.www * (-vs_TEXCOORD3.xyz) + _WorldSpaceLightPos0.xyz;
					    u_xlat19 = dot(u_xlat1.xyz, u_xlat1.xyz);
					    u_xlat19 = inversesqrt(u_xlat19);
					    u_xlat1.xyz = vec3(u_xlat19) * u_xlat1.xyz;
					    u_xlat2.xyz = u_xlat2.xyz * vec3(u_xlat18) + u_xlat1.xyz;
					    u_xlat18 = dot(u_xlat2.xyz, u_xlat2.xyz);
					    u_xlat18 = inversesqrt(u_xlat18);
					    u_xlat2.xyz = vec3(u_xlat18) * u_xlat2.xyz;
					    u_xlat0.w = dot(u_xlat0.xyz, u_xlat2.xyz);
					    u_xlat1.w = dot(u_xlat1.xyz, u_xlat2.xyz);
					    u_xlat1.x = dot(u_xlat0.xyz, u_xlat1.xyz);
					    u_xlat0.x = dot(u_xlat0.xyz, u_xlat3.xyz);
					    u_xlat0.yz = max(u_xlat1.xw, vec2(0.0, 0.0));
					    u_xlat0.xw = max(u_xlat0.xw, vec2(0.0, 0.0));
					    u_xlat1.x = log2(u_xlat0.w);
					    u_xlat18 = u_xlat0.w * u_xlat0.w;
					    u_xlat1.x = u_xlat1.x * 9.99999975e-05;
					    u_xlat1.x = exp2(u_xlat1.x);
					    u_xlat7.x = u_xlat0.x * 0.202115417 + 0.797884583;
					    u_xlat13 = u_xlat0.y * 0.202115417 + 0.797884583;
					    u_xlat7.x = u_xlat13 * u_xlat7.x + 9.99999975e-06;
					    u_xlat1.y = float(1.0) / u_xlat7.x;
					    u_xlat1.xy = u_xlat1.xy * vec2(0.318325758, 0.25);
					    u_xlat7.x = u_xlat0.y * u_xlat1.y;
					    u_xlat1.x = u_xlat1.x * u_xlat7.x;
					    u_xlat1.x = u_xlat1.x * 0.616850257;
					    u_xlat7.x = dot(vs_TEXCOORD7.xyz, vs_TEXCOORD7.xyz);
					    u_xlat2 = texture(_LightTextureB0, u_xlat7.xx);
					    u_xlat3 = texture(_LightTexture0, vs_TEXCOORD7.xyz);
					    u_xlat7.x = u_xlat2.x * u_xlat3.w;
					    u_xlat7.xyz = u_xlat7.xxx * _LightColor0.xyz;
					    u_xlat2.xyz = vec3(u_xlat18) * u_xlat7.xyz;
					    u_xlat2.xyz = u_xlat1.xxx * u_xlat2.xyz;
					    u_xlat2.xyz = u_xlat2.xyz * _LightColor0.xyz;
					    u_xlat0.xw = (-u_xlat0.xz) + vec2(1.00001001, 1.0);
					    u_xlat1.x = u_xlat0.w * u_xlat0.w;
					    u_xlat1.x = u_xlat1.x * u_xlat1.x;
					    u_xlat18 = u_xlat0.w * u_xlat1.x;
					    u_xlat3.xy = vs_TEXCOORD0.xy * _MainTexture_ST.xy + _MainTexture_ST.zw;
					    u_xlat3 = texture(_MainTexture, u_xlat3.xy);
					    u_xlat3.xyz = _Color.xyz * u_xlat3.xyz + vec3(vec3(_Shadows, _Shadows, _Shadows));
					    u_xlat3.xyz = u_xlat3.xyz + vec3(-1.0, -1.0, -1.0);
					    u_xlat3.xyz = clamp(u_xlat3.xyz, 0.0, 1.0);
					    u_xlat4.xyz = u_xlat3.xyz + vec3(-0.220916301, -0.220916301, -0.220916301);
					    u_xlat5.xy = vs_TEXCOORD0.xy * _Specular_ST.xy + _Specular_ST.zw;
					    u_xlat5 = texture(_Specular, u_xlat5.xy);
					    u_xlat1.x = u_xlat5.x * 0.449999988;
					    u_xlat20 = (-u_xlat5.x) * 0.350587666 + 0.779083729;
					    u_xlat3.xyz = vec3(u_xlat20) * u_xlat3.xyz;
					    u_xlat4.xyz = u_xlat1.xxx * u_xlat4.xyz + vec3(0.220916301, 0.220916301, 0.220916301);
					    u_xlat5.xyz = (-u_xlat4.xyz) + vec3(1.0, 1.0, 1.0);
					    u_xlat4.xyz = u_xlat5.xyz * vec3(u_xlat18) + u_xlat4.xyz;
					    u_xlat2.xyz = u_xlat2.xyz * u_xlat4.xyz;
					    u_xlat18 = u_xlat0.x * u_xlat0.x;
					    u_xlat18 = u_xlat18 * u_xlat18;
					    u_xlat0.x = u_xlat18 * u_xlat0.x;
					    u_xlat18 = u_xlat0.z + u_xlat0.z;
					    u_xlat12 = u_xlat18 * u_xlat0.z + -0.5;
					    u_xlat0.x = u_xlat12 * u_xlat0.x + 1.0;
					    u_xlat18 = (-u_xlat0.y) + 1.00001001;
					    u_xlat1.x = u_xlat18 * u_xlat18;
					    u_xlat1.x = u_xlat1.x * u_xlat1.x;
					    u_xlat18 = u_xlat18 * u_xlat1.x;
					    u_xlat12 = u_xlat12 * u_xlat18 + 1.0;
					    u_xlat0.x = u_xlat0.x * u_xlat12;
					    u_xlat0.x = u_xlat0.y * u_xlat0.x;
					    u_xlat0.xyz = u_xlat7.xyz * u_xlat0.xxx;
					    SV_Target0.xyz = u_xlat0.xyz * u_xlat3.xyz + u_xlat2.xyz;
					    SV_Target0.w = 0.0;
					    return;
					}"
				}
				SubProgram "d3d11 " {
					Keywords { "DIRECTIONAL_COOKIE" "DIRLIGHTMAP_SEPARATE" "LIGHTMAP_OFF" "DYNAMICLIGHTMAP_OFF" }
					"ps_4_0
					
					#version 330
					#extension GL_ARB_explicit_attrib_location : require
					#extension GL_ARB_explicit_uniform_location : require
					
					#define HLSLCC_ENABLE_UNIFORM_BUFFERS 1
					#if HLSLCC_ENABLE_UNIFORM_BUFFERS
					#define UNITY_UNIFORM
					#else
					#define UNITY_UNIFORM uniform
					#endif
					#define UNITY_SUPPORTS_UNIFORM_LOCATION 1
					#if UNITY_SUPPORTS_UNIFORM_LOCATION
					#define UNITY_LOCATION(x) layout(location = x)
					#define UNITY_BINDING(x) layout(binding = x, std140)
					#else
					#define UNITY_LOCATION(x)
					#define UNITY_BINDING(x) layout(std140)
					#endif
					layout(std140) uniform PGlobals {
						vec4 unused_0_0[6];
						vec4 _LightColor0;
						vec4 unused_0_2;
						vec4 _MainTexture_ST;
						vec4 _Specular_ST;
						vec4 _NormalMap_ST;
						vec4 _Color;
						vec4 unused_0_7;
						float _NormalSharpness;
						float _Shadows;
					};
					layout(std140) uniform UnityPerCamera {
						vec4 unused_1_0[4];
						vec3 _WorldSpaceCameraPos;
						vec4 unused_1_2[4];
					};
					layout(std140) uniform UnityLighting {
						vec4 _WorldSpaceLightPos0;
						vec4 unused_2_1[47];
					};
					uniform  sampler2D _NormalMap;
					uniform  sampler2D _LightTexture0;
					uniform  sampler2D _MainTexture;
					uniform  sampler2D _Specular;
					in  vec2 vs_TEXCOORD0;
					in  vec2 vs_TEXCOORD7;
					in  vec4 vs_TEXCOORD3;
					in  vec3 vs_TEXCOORD4;
					in  vec3 vs_TEXCOORD5;
					in  vec3 vs_TEXCOORD6;
					layout(location = 0) out vec4 SV_Target0;
					vec4 u_xlat0;
					vec4 u_xlat1;
					int u_xlati1;
					vec4 u_xlat2;
					vec4 u_xlat3;
					vec3 u_xlat4;
					vec4 u_xlat5;
					vec3 u_xlat7;
					int u_xlati7;
					float u_xlat12;
					float u_xlat13;
					float u_xlat18;
					float u_xlat19;
					float u_xlat20;
					void main()
					{
					    u_xlat0.xy = vs_TEXCOORD0.xy * _NormalMap_ST.xy + _NormalMap_ST.zw;
					    u_xlat0 = texture(_NormalMap, u_xlat0.xy);
					    u_xlat0.x = u_xlat0.w * u_xlat0.x;
					    u_xlat0.xy = u_xlat0.xy * vec2(2.0, 2.0) + vec2(-1.0, -1.0);
					    u_xlat18 = dot(u_xlat0.xy, u_xlat0.xy);
					    u_xlat18 = min(u_xlat18, 1.0);
					    u_xlat18 = (-u_xlat18) + 1.0;
					    u_xlat0.z = sqrt(u_xlat18);
					    u_xlat18 = (-_NormalSharpness) + 1.0;
					    u_xlat0.xyz = u_xlat0.xyz / vec3(u_xlat18);
					    u_xlat0.xyz = clamp(u_xlat0.xyz, 0.0, 1.0);
					    u_xlat1.xyz = u_xlat0.yyy * vs_TEXCOORD6.xyz;
					    u_xlat0.xyw = u_xlat0.xxx * vs_TEXCOORD5.xyz + u_xlat1.xyz;
					    u_xlat1.x = dot(vs_TEXCOORD4.xyz, vs_TEXCOORD4.xyz);
					    u_xlat1.x = inversesqrt(u_xlat1.x);
					    u_xlat1.xyz = u_xlat1.xxx * vs_TEXCOORD4.xyz;
					    u_xlat0.xyz = u_xlat0.zzz * u_xlat1.xyz + u_xlat0.xyw;
					    u_xlat18 = dot(u_xlat0.xyz, u_xlat0.xyz);
					    u_xlat18 = inversesqrt(u_xlat18);
					    u_xlat0.xyz = vec3(u_xlat18) * u_xlat0.xyz;
					    u_xlat2.xyz = (-vs_TEXCOORD3.xyz) + _WorldSpaceCameraPos.xyz;
					    u_xlat18 = dot(u_xlat2.xyz, u_xlat2.xyz);
					    u_xlat18 = inversesqrt(u_xlat18);
					    u_xlat3.xyz = vec3(u_xlat18) * u_xlat2.xyz;
					    u_xlat1.x = dot(u_xlat3.xyz, u_xlat1.xyz);
					    u_xlati7 = int((0.0<u_xlat1.x) ? 0xFFFFFFFFu : uint(0));
					    u_xlati1 = int((u_xlat1.x<0.0) ? 0xFFFFFFFFu : uint(0));
					    u_xlati1 = (-u_xlati7) + u_xlati1;
					    u_xlat1.x = float(u_xlati1);
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xxx;
					    u_xlat1.xyz = _WorldSpaceLightPos0.www * (-vs_TEXCOORD3.xyz) + _WorldSpaceLightPos0.xyz;
					    u_xlat19 = dot(u_xlat1.xyz, u_xlat1.xyz);
					    u_xlat19 = inversesqrt(u_xlat19);
					    u_xlat1.xyz = vec3(u_xlat19) * u_xlat1.xyz;
					    u_xlat2.xyz = u_xlat2.xyz * vec3(u_xlat18) + u_xlat1.xyz;
					    u_xlat18 = dot(u_xlat2.xyz, u_xlat2.xyz);
					    u_xlat18 = inversesqrt(u_xlat18);
					    u_xlat2.xyz = vec3(u_xlat18) * u_xlat2.xyz;
					    u_xlat0.w = dot(u_xlat0.xyz, u_xlat2.xyz);
					    u_xlat1.w = dot(u_xlat1.xyz, u_xlat2.xyz);
					    u_xlat1.x = dot(u_xlat0.xyz, u_xlat1.xyz);
					    u_xlat0.x = dot(u_xlat0.xyz, u_xlat3.xyz);
					    u_xlat0.yz = max(u_xlat1.xw, vec2(0.0, 0.0));
					    u_xlat0.xw = max(u_xlat0.xw, vec2(0.0, 0.0));
					    u_xlat1.x = log2(u_xlat0.w);
					    u_xlat18 = u_xlat0.w * u_xlat0.w;
					    u_xlat1.x = u_xlat1.x * 9.99999975e-05;
					    u_xlat1.x = exp2(u_xlat1.x);
					    u_xlat7.x = u_xlat0.x * 0.202115417 + 0.797884583;
					    u_xlat13 = u_xlat0.y * 0.202115417 + 0.797884583;
					    u_xlat7.x = u_xlat13 * u_xlat7.x + 9.99999975e-06;
					    u_xlat1.y = float(1.0) / u_xlat7.x;
					    u_xlat1.xy = u_xlat1.xy * vec2(0.318325758, 0.25);
					    u_xlat7.x = u_xlat0.y * u_xlat1.y;
					    u_xlat1.x = u_xlat1.x * u_xlat7.x;
					    u_xlat1.x = u_xlat1.x * 0.616850257;
					    u_xlat2 = texture(_LightTexture0, vs_TEXCOORD7.xy);
					    u_xlat7.xyz = u_xlat2.www * _LightColor0.xyz;
					    u_xlat2.xyz = vec3(u_xlat18) * u_xlat7.xyz;
					    u_xlat2.xyz = u_xlat1.xxx * u_xlat2.xyz;
					    u_xlat2.xyz = u_xlat2.xyz * _LightColor0.xyz;
					    u_xlat0.xw = (-u_xlat0.xz) + vec2(1.00001001, 1.0);
					    u_xlat1.x = u_xlat0.w * u_xlat0.w;
					    u_xlat1.x = u_xlat1.x * u_xlat1.x;
					    u_xlat18 = u_xlat0.w * u_xlat1.x;
					    u_xlat3.xy = vs_TEXCOORD0.xy * _MainTexture_ST.xy + _MainTexture_ST.zw;
					    u_xlat3 = texture(_MainTexture, u_xlat3.xy);
					    u_xlat3.xyz = _Color.xyz * u_xlat3.xyz + vec3(vec3(_Shadows, _Shadows, _Shadows));
					    u_xlat3.xyz = u_xlat3.xyz + vec3(-1.0, -1.0, -1.0);
					    u_xlat3.xyz = clamp(u_xlat3.xyz, 0.0, 1.0);
					    u_xlat4.xyz = u_xlat3.xyz + vec3(-0.220916301, -0.220916301, -0.220916301);
					    u_xlat5.xy = vs_TEXCOORD0.xy * _Specular_ST.xy + _Specular_ST.zw;
					    u_xlat5 = texture(_Specular, u_xlat5.xy);
					    u_xlat1.x = u_xlat5.x * 0.449999988;
					    u_xlat20 = (-u_xlat5.x) * 0.350587666 + 0.779083729;
					    u_xlat3.xyz = vec3(u_xlat20) * u_xlat3.xyz;
					    u_xlat4.xyz = u_xlat1.xxx * u_xlat4.xyz + vec3(0.220916301, 0.220916301, 0.220916301);
					    u_xlat5.xyz = (-u_xlat4.xyz) + vec3(1.0, 1.0, 1.0);
					    u_xlat4.xyz = u_xlat5.xyz * vec3(u_xlat18) + u_xlat4.xyz;
					    u_xlat2.xyz = u_xlat2.xyz * u_xlat4.xyz;
					    u_xlat18 = u_xlat0.x * u_xlat0.x;
					    u_xlat18 = u_xlat18 * u_xlat18;
					    u_xlat0.x = u_xlat18 * u_xlat0.x;
					    u_xlat18 = u_xlat0.z + u_xlat0.z;
					    u_xlat12 = u_xlat18 * u_xlat0.z + -0.5;
					    u_xlat0.x = u_xlat12 * u_xlat0.x + 1.0;
					    u_xlat18 = (-u_xlat0.y) + 1.00001001;
					    u_xlat1.x = u_xlat18 * u_xlat18;
					    u_xlat1.x = u_xlat1.x * u_xlat1.x;
					    u_xlat18 = u_xlat18 * u_xlat1.x;
					    u_xlat12 = u_xlat12 * u_xlat18 + 1.0;
					    u_xlat0.x = u_xlat0.x * u_xlat12;
					    u_xlat0.x = u_xlat0.y * u_xlat0.x;
					    u_xlat0.xyz = u_xlat7.xyz * u_xlat0.xxx;
					    SV_Target0.xyz = u_xlat0.xyz * u_xlat3.xyz + u_xlat2.xyz;
					    SV_Target0.w = 0.0;
					    return;
					}"
				}
				SubProgram "d3d11 " {
					Keywords { "SPOT" "SHADOWS_DEPTH" "DIRLIGHTMAP_SEPARATE" "LIGHTMAP_OFF" "DYNAMICLIGHTMAP_OFF" }
					"ps_4_0
					
					#version 330
					#extension GL_ARB_explicit_attrib_location : require
					#extension GL_ARB_explicit_uniform_location : require
					
					#define HLSLCC_ENABLE_UNIFORM_BUFFERS 1
					#if HLSLCC_ENABLE_UNIFORM_BUFFERS
					#define UNITY_UNIFORM
					#else
					#define UNITY_UNIFORM uniform
					#endif
					#define UNITY_SUPPORTS_UNIFORM_LOCATION 1
					#if UNITY_SUPPORTS_UNIFORM_LOCATION
					#define UNITY_LOCATION(x) layout(location = x)
					#define UNITY_BINDING(x) layout(binding = x, std140)
					#else
					#define UNITY_LOCATION(x)
					#define UNITY_BINDING(x) layout(std140)
					#endif
					layout(std140) uniform PGlobals {
						vec4 unused_0_0[6];
						vec4 _LightColor0;
						vec4 unused_0_2;
						vec4 _MainTexture_ST;
						vec4 _Specular_ST;
						vec4 _NormalMap_ST;
						vec4 _Color;
						vec4 unused_0_7;
						float _NormalSharpness;
						float _Shadows;
					};
					layout(std140) uniform UnityPerCamera {
						vec4 unused_1_0[4];
						vec3 _WorldSpaceCameraPos;
						vec4 unused_1_2[4];
					};
					layout(std140) uniform UnityLighting {
						vec4 _WorldSpaceLightPos0;
						vec4 unused_2_1[47];
					};
					layout(std140) uniform UnityShadows {
						vec4 unused_3_0[24];
						vec4 _LightShadowData;
						vec4 unused_3_2;
					};
					uniform  sampler2D _NormalMap;
					uniform  sampler2D _LightTexture0;
					uniform  sampler2D _LightTextureB0;
					uniform  sampler2D _MainTexture;
					uniform  sampler2D _Specular;
					uniform  sampler2D _ShadowMapTexture;
					uniform  sampler2DShadow hlslcc_zcmp_ShadowMapTexture;
					in  vec2 vs_TEXCOORD0;
					in  vec4 vs_TEXCOORD3;
					in  vec3 vs_TEXCOORD4;
					in  vec3 vs_TEXCOORD5;
					in  vec3 vs_TEXCOORD6;
					in  vec4 vs_TEXCOORD7;
					in  vec4 vs_TEXCOORD8;
					layout(location = 0) out vec4 SV_Target0;
					vec4 u_xlat0;
					vec4 u_xlat1;
					int u_xlati1;
					vec4 u_xlat2;
					vec4 u_xlat3;
					vec3 u_xlat4;
					vec4 u_xlat5;
					vec3 u_xlat7;
					int u_xlati7;
					bool u_xlatb7;
					float u_xlat12;
					float u_xlat13;
					float u_xlat18;
					float u_xlat19;
					float u_xlat20;
					void main()
					{
					    u_xlat0.xy = vs_TEXCOORD0.xy * _NormalMap_ST.xy + _NormalMap_ST.zw;
					    u_xlat0 = texture(_NormalMap, u_xlat0.xy);
					    u_xlat0.x = u_xlat0.w * u_xlat0.x;
					    u_xlat0.xy = u_xlat0.xy * vec2(2.0, 2.0) + vec2(-1.0, -1.0);
					    u_xlat18 = dot(u_xlat0.xy, u_xlat0.xy);
					    u_xlat18 = min(u_xlat18, 1.0);
					    u_xlat18 = (-u_xlat18) + 1.0;
					    u_xlat0.z = sqrt(u_xlat18);
					    u_xlat18 = (-_NormalSharpness) + 1.0;
					    u_xlat0.xyz = u_xlat0.xyz / vec3(u_xlat18);
					    u_xlat0.xyz = clamp(u_xlat0.xyz, 0.0, 1.0);
					    u_xlat1.xyz = u_xlat0.yyy * vs_TEXCOORD6.xyz;
					    u_xlat0.xyw = u_xlat0.xxx * vs_TEXCOORD5.xyz + u_xlat1.xyz;
					    u_xlat1.x = dot(vs_TEXCOORD4.xyz, vs_TEXCOORD4.xyz);
					    u_xlat1.x = inversesqrt(u_xlat1.x);
					    u_xlat1.xyz = u_xlat1.xxx * vs_TEXCOORD4.xyz;
					    u_xlat0.xyz = u_xlat0.zzz * u_xlat1.xyz + u_xlat0.xyw;
					    u_xlat18 = dot(u_xlat0.xyz, u_xlat0.xyz);
					    u_xlat18 = inversesqrt(u_xlat18);
					    u_xlat0.xyz = vec3(u_xlat18) * u_xlat0.xyz;
					    u_xlat2.xyz = (-vs_TEXCOORD3.xyz) + _WorldSpaceCameraPos.xyz;
					    u_xlat18 = dot(u_xlat2.xyz, u_xlat2.xyz);
					    u_xlat18 = inversesqrt(u_xlat18);
					    u_xlat3.xyz = vec3(u_xlat18) * u_xlat2.xyz;
					    u_xlat1.x = dot(u_xlat3.xyz, u_xlat1.xyz);
					    u_xlati7 = int((0.0<u_xlat1.x) ? 0xFFFFFFFFu : uint(0));
					    u_xlati1 = int((u_xlat1.x<0.0) ? 0xFFFFFFFFu : uint(0));
					    u_xlati1 = (-u_xlati7) + u_xlati1;
					    u_xlat1.x = float(u_xlati1);
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xxx;
					    u_xlat1.xyz = _WorldSpaceLightPos0.www * (-vs_TEXCOORD3.xyz) + _WorldSpaceLightPos0.xyz;
					    u_xlat19 = dot(u_xlat1.xyz, u_xlat1.xyz);
					    u_xlat19 = inversesqrt(u_xlat19);
					    u_xlat1.xyz = vec3(u_xlat19) * u_xlat1.xyz;
					    u_xlat2.xyz = u_xlat2.xyz * vec3(u_xlat18) + u_xlat1.xyz;
					    u_xlat18 = dot(u_xlat2.xyz, u_xlat2.xyz);
					    u_xlat18 = inversesqrt(u_xlat18);
					    u_xlat2.xyz = vec3(u_xlat18) * u_xlat2.xyz;
					    u_xlat0.w = dot(u_xlat0.xyz, u_xlat2.xyz);
					    u_xlat1.w = dot(u_xlat1.xyz, u_xlat2.xyz);
					    u_xlat1.x = dot(u_xlat0.xyz, u_xlat1.xyz);
					    u_xlat0.x = dot(u_xlat0.xyz, u_xlat3.xyz);
					    u_xlat0.yz = max(u_xlat1.xw, vec2(0.0, 0.0));
					    u_xlat0.xw = max(u_xlat0.xw, vec2(0.0, 0.0));
					    u_xlat1.x = log2(u_xlat0.w);
					    u_xlat18 = u_xlat0.w * u_xlat0.w;
					    u_xlat1.x = u_xlat1.x * 9.99999975e-05;
					    u_xlat1.x = exp2(u_xlat1.x);
					    u_xlat7.x = u_xlat0.x * 0.202115417 + 0.797884583;
					    u_xlat13 = u_xlat0.y * 0.202115417 + 0.797884583;
					    u_xlat7.x = u_xlat13 * u_xlat7.x + 9.99999975e-06;
					    u_xlat1.y = float(1.0) / u_xlat7.x;
					    u_xlat1.xy = u_xlat1.xy * vec2(0.318325758, 0.25);
					    u_xlat7.x = u_xlat0.y * u_xlat1.y;
					    u_xlat1.x = u_xlat1.x * u_xlat7.x;
					    u_xlat1.x = u_xlat1.x * 0.616850257;
					    u_xlat7.xy = vs_TEXCOORD7.xy / vs_TEXCOORD7.ww;
					    u_xlat7.xy = u_xlat7.xy + vec2(0.5, 0.5);
					    u_xlat2 = texture(_LightTexture0, u_xlat7.xy);
					    u_xlatb7 = 0.0<vs_TEXCOORD7.z;
					    u_xlat7.x = u_xlatb7 ? 1.0 : float(0.0);
					    u_xlat7.x = u_xlat2.w * u_xlat7.x;
					    u_xlat13 = dot(vs_TEXCOORD7.xyz, vs_TEXCOORD7.xyz);
					    u_xlat2 = texture(_LightTextureB0, vec2(u_xlat13));
					    u_xlat7.x = u_xlat7.x * u_xlat2.x;
					    u_xlat2.xyz = vs_TEXCOORD8.xyz / vs_TEXCOORD8.www;
					    vec3 txVec0 = vec3(u_xlat2.xy,u_xlat2.z);
					    u_xlat13 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec0, 0.0);
					    u_xlat19 = (-_LightShadowData.x) + 1.0;
					    u_xlat13 = u_xlat13 * u_xlat19 + _LightShadowData.x;
					    u_xlat7.x = u_xlat13 * u_xlat7.x;
					    u_xlat7.xyz = u_xlat7.xxx * _LightColor0.xyz;
					    u_xlat2.xyz = vec3(u_xlat18) * u_xlat7.xyz;
					    u_xlat2.xyz = u_xlat1.xxx * u_xlat2.xyz;
					    u_xlat2.xyz = u_xlat2.xyz * _LightColor0.xyz;
					    u_xlat0.xw = (-u_xlat0.xz) + vec2(1.00001001, 1.0);
					    u_xlat1.x = u_xlat0.w * u_xlat0.w;
					    u_xlat1.x = u_xlat1.x * u_xlat1.x;
					    u_xlat18 = u_xlat0.w * u_xlat1.x;
					    u_xlat3.xy = vs_TEXCOORD0.xy * _MainTexture_ST.xy + _MainTexture_ST.zw;
					    u_xlat3 = texture(_MainTexture, u_xlat3.xy);
					    u_xlat3.xyz = _Color.xyz * u_xlat3.xyz + vec3(vec3(_Shadows, _Shadows, _Shadows));
					    u_xlat3.xyz = u_xlat3.xyz + vec3(-1.0, -1.0, -1.0);
					    u_xlat3.xyz = clamp(u_xlat3.xyz, 0.0, 1.0);
					    u_xlat4.xyz = u_xlat3.xyz + vec3(-0.220916301, -0.220916301, -0.220916301);
					    u_xlat5.xy = vs_TEXCOORD0.xy * _Specular_ST.xy + _Specular_ST.zw;
					    u_xlat5 = texture(_Specular, u_xlat5.xy);
					    u_xlat1.x = u_xlat5.x * 0.449999988;
					    u_xlat20 = (-u_xlat5.x) * 0.350587666 + 0.779083729;
					    u_xlat3.xyz = vec3(u_xlat20) * u_xlat3.xyz;
					    u_xlat4.xyz = u_xlat1.xxx * u_xlat4.xyz + vec3(0.220916301, 0.220916301, 0.220916301);
					    u_xlat5.xyz = (-u_xlat4.xyz) + vec3(1.0, 1.0, 1.0);
					    u_xlat4.xyz = u_xlat5.xyz * vec3(u_xlat18) + u_xlat4.xyz;
					    u_xlat2.xyz = u_xlat2.xyz * u_xlat4.xyz;
					    u_xlat18 = u_xlat0.x * u_xlat0.x;
					    u_xlat18 = u_xlat18 * u_xlat18;
					    u_xlat0.x = u_xlat18 * u_xlat0.x;
					    u_xlat18 = u_xlat0.z + u_xlat0.z;
					    u_xlat12 = u_xlat18 * u_xlat0.z + -0.5;
					    u_xlat0.x = u_xlat12 * u_xlat0.x + 1.0;
					    u_xlat18 = (-u_xlat0.y) + 1.00001001;
					    u_xlat1.x = u_xlat18 * u_xlat18;
					    u_xlat1.x = u_xlat1.x * u_xlat1.x;
					    u_xlat18 = u_xlat18 * u_xlat1.x;
					    u_xlat12 = u_xlat12 * u_xlat18 + 1.0;
					    u_xlat0.x = u_xlat0.x * u_xlat12;
					    u_xlat0.x = u_xlat0.y * u_xlat0.x;
					    u_xlat0.xyz = u_xlat7.xyz * u_xlat0.xxx;
					    SV_Target0.xyz = u_xlat0.xyz * u_xlat3.xyz + u_xlat2.xyz;
					    SV_Target0.w = 0.0;
					    return;
					}"
				}
				SubProgram "d3d11 " {
					Keywords { "SPOT" "SHADOWS_DEPTH" "SHADOWS_SOFT" "DIRLIGHTMAP_SEPARATE" "LIGHTMAP_OFF" "DYNAMICLIGHTMAP_OFF" }
					"ps_4_0
					
					#version 330
					#extension GL_ARB_explicit_attrib_location : require
					#extension GL_ARB_explicit_uniform_location : require
					
					#define HLSLCC_ENABLE_UNIFORM_BUFFERS 1
					#if HLSLCC_ENABLE_UNIFORM_BUFFERS
					#define UNITY_UNIFORM
					#else
					#define UNITY_UNIFORM uniform
					#endif
					#define UNITY_SUPPORTS_UNIFORM_LOCATION 1
					#if UNITY_SUPPORTS_UNIFORM_LOCATION
					#define UNITY_LOCATION(x) layout(location = x)
					#define UNITY_BINDING(x) layout(binding = x, std140)
					#else
					#define UNITY_LOCATION(x)
					#define UNITY_BINDING(x) layout(std140)
					#endif
					layout(std140) uniform PGlobals {
						vec4 unused_0_0[6];
						vec4 _ShadowMapTexture_TexelSize;
						vec4 unused_0_2[4];
						vec4 _LightColor0;
						vec4 unused_0_4;
						vec4 _MainTexture_ST;
						vec4 _Specular_ST;
						vec4 _NormalMap_ST;
						vec4 _Color;
						vec4 unused_0_9;
						float _NormalSharpness;
						float _Shadows;
					};
					layout(std140) uniform UnityPerCamera {
						vec4 unused_1_0[4];
						vec3 _WorldSpaceCameraPos;
						vec4 unused_1_2[4];
					};
					layout(std140) uniform UnityLighting {
						vec4 _WorldSpaceLightPos0;
						vec4 unused_2_1[47];
					};
					layout(std140) uniform UnityShadows {
						vec4 unused_3_0[24];
						vec4 _LightShadowData;
						vec4 unused_3_2;
					};
					uniform  sampler2D _NormalMap;
					uniform  sampler2D _LightTexture0;
					uniform  sampler2D _LightTextureB0;
					uniform  sampler2D _MainTexture;
					uniform  sampler2D _Specular;
					uniform  sampler2D _ShadowMapTexture;
					uniform  sampler2DShadow hlslcc_zcmp_ShadowMapTexture;
					in  vec2 vs_TEXCOORD0;
					in  vec4 vs_TEXCOORD3;
					in  vec3 vs_TEXCOORD4;
					in  vec3 vs_TEXCOORD5;
					in  vec3 vs_TEXCOORD6;
					in  vec4 vs_TEXCOORD7;
					in  vec4 vs_TEXCOORD8;
					layout(location = 0) out vec4 SV_Target0;
					vec3 u_xlat0;
					vec4 u_xlat1;
					vec4 u_xlat2;
					int u_xlati2;
					vec4 u_xlat3;
					vec4 u_xlat4;
					vec4 u_xlat5;
					vec2 u_xlat6;
					bool u_xlatb6;
					float u_xlat7;
					float u_xlat12;
					vec2 u_xlat13;
					float u_xlat18;
					float u_xlat19;
					int u_xlati19;
					float u_xlat20;
					void main()
					{
					    u_xlat0.xyz = vs_TEXCOORD8.xyz / vs_TEXCOORD8.www;
					    u_xlat1.xy = u_xlat0.xy * _ShadowMapTexture_TexelSize.zw + vec2(0.5, 0.5);
					    u_xlat1.xy = floor(u_xlat1.xy);
					    u_xlat0.xy = u_xlat0.xy * _ShadowMapTexture_TexelSize.zw + (-u_xlat1.xy);
					    u_xlat13.xy = (-u_xlat0.xy) + vec2(1.0, 1.0);
					    u_xlat2.xy = min(u_xlat0.xy, vec2(0.0, 0.0));
					    u_xlat2.xy = (-u_xlat2.xy) * u_xlat2.xy + u_xlat13.xy;
					    u_xlat3.y = u_xlat2.x;
					    u_xlat13.xy = max(u_xlat0.xy, vec2(0.0, 0.0));
					    u_xlat4 = u_xlat0.xxyy + vec4(0.5, 1.0, 0.5, 1.0);
					    u_xlat2.xz = (-u_xlat13.xy) * u_xlat13.xy + u_xlat4.yw;
					    u_xlat13.xy = u_xlat4.xz * u_xlat4.xz;
					    u_xlat3.z = u_xlat2.x;
					    u_xlat0.xy = u_xlat13.xy * vec2(0.5, 0.5) + (-u_xlat0.xy);
					    u_xlat3.x = u_xlat0.x;
					    u_xlat2.x = u_xlat0.y;
					    u_xlat3.w = u_xlat13.x;
					    u_xlat2.w = u_xlat13.y;
					    u_xlat2 = u_xlat2 * vec4(0.444440007, 0.444440007, 0.444440007, 0.222220004);
					    u_xlat3 = u_xlat3 * vec4(0.444440007, 0.444440007, 0.444440007, 0.222220004);
					    u_xlat4 = u_xlat3.ywyw + u_xlat3.xzxz;
					    u_xlat0.xy = u_xlat3.yw / u_xlat4.zw;
					    u_xlat0.xy = u_xlat0.xy + vec2(-1.5, 0.5);
					    u_xlat3.xy = u_xlat0.xy * _ShadowMapTexture_TexelSize.xx;
					    u_xlat5 = u_xlat2.yyww + u_xlat2.xxzz;
					    u_xlat0.xy = u_xlat2.yw / u_xlat5.yw;
					    u_xlat2 = u_xlat4 * u_xlat5;
					    u_xlat0.xy = u_xlat0.xy + vec2(-1.5, 0.5);
					    u_xlat3.zw = u_xlat0.xy * _ShadowMapTexture_TexelSize.yy;
					    u_xlat4 = u_xlat1.xyxy * _ShadowMapTexture_TexelSize.xyxy + u_xlat3.xzyz;
					    u_xlat1 = u_xlat1.xyxy * _ShadowMapTexture_TexelSize.xyxy + u_xlat3.xwyw;
					    vec3 txVec0 = vec3(u_xlat4.xy,u_xlat0.z);
					    u_xlat0.x = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec0, 0.0);
					    vec3 txVec1 = vec3(u_xlat4.zw,u_xlat0.z);
					    u_xlat6.x = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec1, 0.0);
					    u_xlat6.x = u_xlat6.x * u_xlat2.y;
					    u_xlat0.x = u_xlat2.x * u_xlat0.x + u_xlat6.x;
					    vec3 txVec2 = vec3(u_xlat1.xy,u_xlat0.z);
					    u_xlat6.x = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec2, 0.0);
					    vec3 txVec3 = vec3(u_xlat1.zw,u_xlat0.z);
					    u_xlat12 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec3, 0.0);
					    u_xlat0.x = u_xlat2.z * u_xlat6.x + u_xlat0.x;
					    u_xlat0.x = u_xlat2.w * u_xlat12 + u_xlat0.x;
					    u_xlat6.x = (-_LightShadowData.x) + 1.0;
					    u_xlat0.x = u_xlat0.x * u_xlat6.x + _LightShadowData.x;
					    u_xlat6.xy = vs_TEXCOORD7.xy / vs_TEXCOORD7.ww;
					    u_xlat6.xy = u_xlat6.xy + vec2(0.5, 0.5);
					    u_xlat1 = texture(_LightTexture0, u_xlat6.xy);
					    u_xlatb6 = 0.0<vs_TEXCOORD7.z;
					    u_xlat6.x = u_xlatb6 ? 1.0 : float(0.0);
					    u_xlat6.x = u_xlat1.w * u_xlat6.x;
					    u_xlat12 = dot(vs_TEXCOORD7.xyz, vs_TEXCOORD7.xyz);
					    u_xlat1 = texture(_LightTextureB0, vec2(u_xlat12));
					    u_xlat6.x = u_xlat6.x * u_xlat1.x;
					    u_xlat0.x = u_xlat0.x * u_xlat6.x;
					    u_xlat0.xyz = u_xlat0.xxx * _LightColor0.xyz;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _NormalMap_ST.xy + _NormalMap_ST.zw;
					    u_xlat1 = texture(_NormalMap, u_xlat1.xy);
					    u_xlat1.x = u_xlat1.w * u_xlat1.x;
					    u_xlat1.xy = u_xlat1.xy * vec2(2.0, 2.0) + vec2(-1.0, -1.0);
					    u_xlat18 = dot(u_xlat1.xy, u_xlat1.xy);
					    u_xlat18 = min(u_xlat18, 1.0);
					    u_xlat18 = (-u_xlat18) + 1.0;
					    u_xlat1.z = sqrt(u_xlat18);
					    u_xlat18 = (-_NormalSharpness) + 1.0;
					    u_xlat1.xyz = u_xlat1.xyz / vec3(u_xlat18);
					    u_xlat1.xyz = clamp(u_xlat1.xyz, 0.0, 1.0);
					    u_xlat2.xyz = u_xlat1.yyy * vs_TEXCOORD6.xyz;
					    u_xlat1.xyw = u_xlat1.xxx * vs_TEXCOORD5.xyz + u_xlat2.xyz;
					    u_xlat18 = dot(vs_TEXCOORD4.xyz, vs_TEXCOORD4.xyz);
					    u_xlat18 = inversesqrt(u_xlat18);
					    u_xlat2.xyz = vec3(u_xlat18) * vs_TEXCOORD4.xyz;
					    u_xlat1.xyz = u_xlat1.zzz * u_xlat2.xyz + u_xlat1.xyw;
					    u_xlat18 = dot(u_xlat1.xyz, u_xlat1.xyz);
					    u_xlat18 = inversesqrt(u_xlat18);
					    u_xlat1.xyz = vec3(u_xlat18) * u_xlat1.xyz;
					    u_xlat3.xyz = (-vs_TEXCOORD3.xyz) + _WorldSpaceCameraPos.xyz;
					    u_xlat18 = dot(u_xlat3.xyz, u_xlat3.xyz);
					    u_xlat18 = inversesqrt(u_xlat18);
					    u_xlat4.xyz = vec3(u_xlat18) * u_xlat3.xyz;
					    u_xlat19 = dot(u_xlat4.xyz, u_xlat2.xyz);
					    u_xlati2 = int((0.0<u_xlat19) ? 0xFFFFFFFFu : uint(0));
					    u_xlati19 = int((u_xlat19<0.0) ? 0xFFFFFFFFu : uint(0));
					    u_xlati19 = (-u_xlati2) + u_xlati19;
					    u_xlat19 = float(u_xlati19);
					    u_xlat1.xyz = vec3(u_xlat19) * u_xlat1.xyz;
					    u_xlat2.xyz = _WorldSpaceLightPos0.www * (-vs_TEXCOORD3.xyz) + _WorldSpaceLightPos0.xyz;
					    u_xlat19 = dot(u_xlat2.xyz, u_xlat2.xyz);
					    u_xlat19 = inversesqrt(u_xlat19);
					    u_xlat2.xyz = vec3(u_xlat19) * u_xlat2.xyz;
					    u_xlat3.xyz = u_xlat3.xyz * vec3(u_xlat18) + u_xlat2.xyz;
					    u_xlat18 = dot(u_xlat3.xyz, u_xlat3.xyz);
					    u_xlat18 = inversesqrt(u_xlat18);
					    u_xlat3.xyz = vec3(u_xlat18) * u_xlat3.xyz;
					    u_xlat18 = dot(u_xlat1.xyz, u_xlat3.xyz);
					    u_xlat1.w = dot(u_xlat2.xyz, u_xlat3.xyz);
					    u_xlat2.x = dot(u_xlat1.xyz, u_xlat2.xyz);
					    u_xlat1.x = dot(u_xlat1.xyz, u_xlat4.xyz);
					    u_xlat7 = max(u_xlat2.x, 0.0);
					    u_xlat1.xz = max(u_xlat1.xw, vec2(0.0, 0.0));
					    u_xlat18 = max(u_xlat18, 0.0);
					    u_xlat19 = u_xlat18 * u_xlat18;
					    u_xlat18 = log2(u_xlat18);
					    u_xlat18 = u_xlat18 * 9.99999975e-05;
					    u_xlat18 = exp2(u_xlat18);
					    u_xlat18 = u_xlat18 * 0.318325758;
					    u_xlat2.xyz = u_xlat0.xyz * vec3(u_xlat19);
					    u_xlat19 = u_xlat1.x * 0.202115417 + 0.797884583;
					    u_xlat1.x = (-u_xlat1.x) + 1.00001001;
					    u_xlat20 = u_xlat7 * 0.202115417 + 0.797884583;
					    u_xlat19 = u_xlat20 * u_xlat19 + 9.99999975e-06;
					    u_xlat19 = float(1.0) / u_xlat19;
					    u_xlat19 = u_xlat19 * 0.25;
					    u_xlat19 = u_xlat19 * u_xlat7;
					    u_xlat18 = u_xlat18 * u_xlat19;
					    u_xlat18 = u_xlat18 * 0.616850257;
					    u_xlat2.xyz = vec3(u_xlat18) * u_xlat2.xyz;
					    u_xlat2.xyz = u_xlat2.xyz * _LightColor0.xyz;
					    u_xlat18 = (-u_xlat1.z) + 1.0;
					    u_xlat19 = u_xlat18 * u_xlat18;
					    u_xlat19 = u_xlat19 * u_xlat19;
					    u_xlat18 = u_xlat18 * u_xlat19;
					    u_xlat3.xy = vs_TEXCOORD0.xy * _MainTexture_ST.xy + _MainTexture_ST.zw;
					    u_xlat3 = texture(_MainTexture, u_xlat3.xy);
					    u_xlat3.xyz = _Color.xyz * u_xlat3.xyz + vec3(vec3(_Shadows, _Shadows, _Shadows));
					    u_xlat3.xyz = u_xlat3.xyz + vec3(-1.0, -1.0, -1.0);
					    u_xlat3.xyz = clamp(u_xlat3.xyz, 0.0, 1.0);
					    u_xlat4.xyz = u_xlat3.xyz + vec3(-0.220916301, -0.220916301, -0.220916301);
					    u_xlat5.xy = vs_TEXCOORD0.xy * _Specular_ST.xy + _Specular_ST.zw;
					    u_xlat5 = texture(_Specular, u_xlat5.xy);
					    u_xlat19 = u_xlat5.x * 0.449999988;
					    u_xlat20 = (-u_xlat5.x) * 0.350587666 + 0.779083729;
					    u_xlat3.xyz = vec3(u_xlat20) * u_xlat3.xyz;
					    u_xlat4.xyz = vec3(u_xlat19) * u_xlat4.xyz + vec3(0.220916301, 0.220916301, 0.220916301);
					    u_xlat5.xyz = (-u_xlat4.xyz) + vec3(1.0, 1.0, 1.0);
					    u_xlat4.xyz = u_xlat5.xyz * vec3(u_xlat18) + u_xlat4.xyz;
					    u_xlat2.xyz = u_xlat2.xyz * u_xlat4.xyz;
					    u_xlat18 = u_xlat1.x * u_xlat1.x;
					    u_xlat18 = u_xlat18 * u_xlat18;
					    u_xlat18 = u_xlat18 * u_xlat1.x;
					    u_xlat1.x = u_xlat1.z + u_xlat1.z;
					    u_xlat1.x = u_xlat1.x * u_xlat1.z + -0.5;
					    u_xlat18 = u_xlat1.x * u_xlat18 + 1.0;
					    u_xlat13.x = (-u_xlat7) + 1.00001001;
					    u_xlat19 = u_xlat13.x * u_xlat13.x;
					    u_xlat19 = u_xlat19 * u_xlat19;
					    u_xlat13.x = u_xlat19 * u_xlat13.x;
					    u_xlat1.x = u_xlat1.x * u_xlat13.x + 1.0;
					    u_xlat18 = u_xlat18 * u_xlat1.x;
					    u_xlat18 = u_xlat7 * u_xlat18;
					    u_xlat0.xyz = u_xlat0.xyz * vec3(u_xlat18);
					    SV_Target0.xyz = u_xlat0.xyz * u_xlat3.xyz + u_xlat2.xyz;
					    SV_Target0.w = 0.0;
					    return;
					}"
				}
				SubProgram "d3d11 " {
					Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "DIRLIGHTMAP_SEPARATE" "LIGHTMAP_OFF" "DYNAMICLIGHTMAP_OFF" }
					"ps_4_0
					
					#version 330
					#extension GL_ARB_explicit_attrib_location : require
					#extension GL_ARB_explicit_uniform_location : require
					
					#define HLSLCC_ENABLE_UNIFORM_BUFFERS 1
					#if HLSLCC_ENABLE_UNIFORM_BUFFERS
					#define UNITY_UNIFORM
					#else
					#define UNITY_UNIFORM uniform
					#endif
					#define UNITY_SUPPORTS_UNIFORM_LOCATION 1
					#if UNITY_SUPPORTS_UNIFORM_LOCATION
					#define UNITY_LOCATION(x) layout(location = x)
					#define UNITY_BINDING(x) layout(binding = x, std140)
					#else
					#define UNITY_LOCATION(x)
					#define UNITY_BINDING(x) layout(std140)
					#endif
					layout(std140) uniform PGlobals {
						vec4 unused_0_0[2];
						vec4 _LightColor0;
						vec4 unused_0_2;
						vec4 _MainTexture_ST;
						vec4 _Specular_ST;
						vec4 _NormalMap_ST;
						vec4 _Color;
						vec4 unused_0_7;
						float _NormalSharpness;
						float _Shadows;
					};
					layout(std140) uniform UnityPerCamera {
						vec4 unused_1_0[4];
						vec3 _WorldSpaceCameraPos;
						vec4 unused_1_2[4];
					};
					layout(std140) uniform UnityLighting {
						vec4 _WorldSpaceLightPos0;
						vec4 unused_2_1[47];
					};
					uniform  sampler2D _NormalMap;
					uniform  sampler2D _ShadowMapTexture;
					uniform  sampler2D _MainTexture;
					uniform  sampler2D _Specular;
					in  vec2 vs_TEXCOORD0;
					in  vec4 vs_TEXCOORD3;
					in  vec3 vs_TEXCOORD4;
					in  vec3 vs_TEXCOORD5;
					in  vec3 vs_TEXCOORD6;
					in  vec4 vs_TEXCOORD8;
					layout(location = 0) out vec4 SV_Target0;
					vec4 u_xlat0;
					vec4 u_xlat1;
					int u_xlati1;
					vec4 u_xlat2;
					vec4 u_xlat3;
					vec3 u_xlat4;
					vec4 u_xlat5;
					vec3 u_xlat7;
					int u_xlati7;
					float u_xlat12;
					float u_xlat13;
					float u_xlat18;
					float u_xlat19;
					float u_xlat20;
					void main()
					{
					    u_xlat0.xy = vs_TEXCOORD0.xy * _NormalMap_ST.xy + _NormalMap_ST.zw;
					    u_xlat0 = texture(_NormalMap, u_xlat0.xy);
					    u_xlat0.x = u_xlat0.w * u_xlat0.x;
					    u_xlat0.xy = u_xlat0.xy * vec2(2.0, 2.0) + vec2(-1.0, -1.0);
					    u_xlat18 = dot(u_xlat0.xy, u_xlat0.xy);
					    u_xlat18 = min(u_xlat18, 1.0);
					    u_xlat18 = (-u_xlat18) + 1.0;
					    u_xlat0.z = sqrt(u_xlat18);
					    u_xlat18 = (-_NormalSharpness) + 1.0;
					    u_xlat0.xyz = u_xlat0.xyz / vec3(u_xlat18);
					    u_xlat0.xyz = clamp(u_xlat0.xyz, 0.0, 1.0);
					    u_xlat1.xyz = u_xlat0.yyy * vs_TEXCOORD6.xyz;
					    u_xlat0.xyw = u_xlat0.xxx * vs_TEXCOORD5.xyz + u_xlat1.xyz;
					    u_xlat1.x = dot(vs_TEXCOORD4.xyz, vs_TEXCOORD4.xyz);
					    u_xlat1.x = inversesqrt(u_xlat1.x);
					    u_xlat1.xyz = u_xlat1.xxx * vs_TEXCOORD4.xyz;
					    u_xlat0.xyz = u_xlat0.zzz * u_xlat1.xyz + u_xlat0.xyw;
					    u_xlat18 = dot(u_xlat0.xyz, u_xlat0.xyz);
					    u_xlat18 = inversesqrt(u_xlat18);
					    u_xlat0.xyz = vec3(u_xlat18) * u_xlat0.xyz;
					    u_xlat2.xyz = (-vs_TEXCOORD3.xyz) + _WorldSpaceCameraPos.xyz;
					    u_xlat18 = dot(u_xlat2.xyz, u_xlat2.xyz);
					    u_xlat18 = inversesqrt(u_xlat18);
					    u_xlat3.xyz = vec3(u_xlat18) * u_xlat2.xyz;
					    u_xlat1.x = dot(u_xlat3.xyz, u_xlat1.xyz);
					    u_xlati7 = int((0.0<u_xlat1.x) ? 0xFFFFFFFFu : uint(0));
					    u_xlati1 = int((u_xlat1.x<0.0) ? 0xFFFFFFFFu : uint(0));
					    u_xlati1 = (-u_xlati7) + u_xlati1;
					    u_xlat1.x = float(u_xlati1);
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xxx;
					    u_xlat1.xyz = _WorldSpaceLightPos0.www * (-vs_TEXCOORD3.xyz) + _WorldSpaceLightPos0.xyz;
					    u_xlat19 = dot(u_xlat1.xyz, u_xlat1.xyz);
					    u_xlat19 = inversesqrt(u_xlat19);
					    u_xlat1.xyz = vec3(u_xlat19) * u_xlat1.xyz;
					    u_xlat2.xyz = u_xlat2.xyz * vec3(u_xlat18) + u_xlat1.xyz;
					    u_xlat18 = dot(u_xlat2.xyz, u_xlat2.xyz);
					    u_xlat18 = inversesqrt(u_xlat18);
					    u_xlat2.xyz = vec3(u_xlat18) * u_xlat2.xyz;
					    u_xlat0.w = dot(u_xlat0.xyz, u_xlat2.xyz);
					    u_xlat1.w = dot(u_xlat1.xyz, u_xlat2.xyz);
					    u_xlat1.x = dot(u_xlat0.xyz, u_xlat1.xyz);
					    u_xlat0.x = dot(u_xlat0.xyz, u_xlat3.xyz);
					    u_xlat0.yz = max(u_xlat1.xw, vec2(0.0, 0.0));
					    u_xlat0.xw = max(u_xlat0.xw, vec2(0.0, 0.0));
					    u_xlat1.x = log2(u_xlat0.w);
					    u_xlat18 = u_xlat0.w * u_xlat0.w;
					    u_xlat1.x = u_xlat1.x * 9.99999975e-05;
					    u_xlat1.x = exp2(u_xlat1.x);
					    u_xlat7.x = u_xlat0.x * 0.202115417 + 0.797884583;
					    u_xlat13 = u_xlat0.y * 0.202115417 + 0.797884583;
					    u_xlat7.x = u_xlat13 * u_xlat7.x + 9.99999975e-06;
					    u_xlat1.y = float(1.0) / u_xlat7.x;
					    u_xlat1.xy = u_xlat1.xy * vec2(0.318325758, 0.25);
					    u_xlat7.x = u_xlat0.y * u_xlat1.y;
					    u_xlat1.x = u_xlat1.x * u_xlat7.x;
					    u_xlat1.x = u_xlat1.x * 0.616850257;
					    u_xlat7.xy = vs_TEXCOORD8.xy / vs_TEXCOORD8.ww;
					    u_xlat2 = texture(_ShadowMapTexture, u_xlat7.xy);
					    u_xlat7.xyz = u_xlat2.xxx * _LightColor0.xyz;
					    u_xlat2.xyz = vec3(u_xlat18) * u_xlat7.xyz;
					    u_xlat2.xyz = u_xlat1.xxx * u_xlat2.xyz;
					    u_xlat2.xyz = u_xlat2.xyz * _LightColor0.xyz;
					    u_xlat0.xw = (-u_xlat0.xz) + vec2(1.00001001, 1.0);
					    u_xlat1.x = u_xlat0.w * u_xlat0.w;
					    u_xlat1.x = u_xlat1.x * u_xlat1.x;
					    u_xlat18 = u_xlat0.w * u_xlat1.x;
					    u_xlat3.xy = vs_TEXCOORD0.xy * _MainTexture_ST.xy + _MainTexture_ST.zw;
					    u_xlat3 = texture(_MainTexture, u_xlat3.xy);
					    u_xlat3.xyz = _Color.xyz * u_xlat3.xyz + vec3(vec3(_Shadows, _Shadows, _Shadows));
					    u_xlat3.xyz = u_xlat3.xyz + vec3(-1.0, -1.0, -1.0);
					    u_xlat3.xyz = clamp(u_xlat3.xyz, 0.0, 1.0);
					    u_xlat4.xyz = u_xlat3.xyz + vec3(-0.220916301, -0.220916301, -0.220916301);
					    u_xlat5.xy = vs_TEXCOORD0.xy * _Specular_ST.xy + _Specular_ST.zw;
					    u_xlat5 = texture(_Specular, u_xlat5.xy);
					    u_xlat1.x = u_xlat5.x * 0.449999988;
					    u_xlat20 = (-u_xlat5.x) * 0.350587666 + 0.779083729;
					    u_xlat3.xyz = vec3(u_xlat20) * u_xlat3.xyz;
					    u_xlat4.xyz = u_xlat1.xxx * u_xlat4.xyz + vec3(0.220916301, 0.220916301, 0.220916301);
					    u_xlat5.xyz = (-u_xlat4.xyz) + vec3(1.0, 1.0, 1.0);
					    u_xlat4.xyz = u_xlat5.xyz * vec3(u_xlat18) + u_xlat4.xyz;
					    u_xlat2.xyz = u_xlat2.xyz * u_xlat4.xyz;
					    u_xlat18 = u_xlat0.x * u_xlat0.x;
					    u_xlat18 = u_xlat18 * u_xlat18;
					    u_xlat0.x = u_xlat18 * u_xlat0.x;
					    u_xlat18 = u_xlat0.z + u_xlat0.z;
					    u_xlat12 = u_xlat18 * u_xlat0.z + -0.5;
					    u_xlat0.x = u_xlat12 * u_xlat0.x + 1.0;
					    u_xlat18 = (-u_xlat0.y) + 1.00001001;
					    u_xlat1.x = u_xlat18 * u_xlat18;
					    u_xlat1.x = u_xlat1.x * u_xlat1.x;
					    u_xlat18 = u_xlat18 * u_xlat1.x;
					    u_xlat12 = u_xlat12 * u_xlat18 + 1.0;
					    u_xlat0.x = u_xlat0.x * u_xlat12;
					    u_xlat0.x = u_xlat0.y * u_xlat0.x;
					    u_xlat0.xyz = u_xlat7.xyz * u_xlat0.xxx;
					    SV_Target0.xyz = u_xlat0.xyz * u_xlat3.xyz + u_xlat2.xyz;
					    SV_Target0.w = 0.0;
					    return;
					}"
				}
				SubProgram "d3d11 " {
					Keywords { "DIRECTIONAL_COOKIE" "SHADOWS_SCREEN" "DIRLIGHTMAP_SEPARATE" "LIGHTMAP_OFF" "DYNAMICLIGHTMAP_OFF" }
					"ps_4_0
					
					#version 330
					#extension GL_ARB_explicit_attrib_location : require
					#extension GL_ARB_explicit_uniform_location : require
					
					#define HLSLCC_ENABLE_UNIFORM_BUFFERS 1
					#if HLSLCC_ENABLE_UNIFORM_BUFFERS
					#define UNITY_UNIFORM
					#else
					#define UNITY_UNIFORM uniform
					#endif
					#define UNITY_SUPPORTS_UNIFORM_LOCATION 1
					#if UNITY_SUPPORTS_UNIFORM_LOCATION
					#define UNITY_LOCATION(x) layout(location = x)
					#define UNITY_BINDING(x) layout(binding = x, std140)
					#else
					#define UNITY_LOCATION(x)
					#define UNITY_BINDING(x) layout(std140)
					#endif
					layout(std140) uniform PGlobals {
						vec4 unused_0_0[6];
						vec4 _LightColor0;
						vec4 unused_0_2;
						vec4 _MainTexture_ST;
						vec4 _Specular_ST;
						vec4 _NormalMap_ST;
						vec4 _Color;
						vec4 unused_0_7;
						float _NormalSharpness;
						float _Shadows;
					};
					layout(std140) uniform UnityPerCamera {
						vec4 unused_1_0[4];
						vec3 _WorldSpaceCameraPos;
						vec4 unused_1_2[4];
					};
					layout(std140) uniform UnityLighting {
						vec4 _WorldSpaceLightPos0;
						vec4 unused_2_1[47];
					};
					uniform  sampler2D _NormalMap;
					uniform  sampler2D _LightTexture0;
					uniform  sampler2D _ShadowMapTexture;
					uniform  sampler2D _MainTexture;
					uniform  sampler2D _Specular;
					in  vec2 vs_TEXCOORD0;
					in  vec2 vs_TEXCOORD7;
					in  vec4 vs_TEXCOORD3;
					in  vec3 vs_TEXCOORD4;
					in  vec3 vs_TEXCOORD5;
					in  vec3 vs_TEXCOORD6;
					in  vec4 vs_TEXCOORD8;
					layout(location = 0) out vec4 SV_Target0;
					vec4 u_xlat0;
					vec4 u_xlat1;
					int u_xlati1;
					vec4 u_xlat2;
					vec4 u_xlat3;
					vec3 u_xlat4;
					vec4 u_xlat5;
					vec3 u_xlat7;
					int u_xlati7;
					float u_xlat12;
					float u_xlat13;
					float u_xlat18;
					float u_xlat19;
					float u_xlat20;
					void main()
					{
					    u_xlat0.xy = vs_TEXCOORD0.xy * _NormalMap_ST.xy + _NormalMap_ST.zw;
					    u_xlat0 = texture(_NormalMap, u_xlat0.xy);
					    u_xlat0.x = u_xlat0.w * u_xlat0.x;
					    u_xlat0.xy = u_xlat0.xy * vec2(2.0, 2.0) + vec2(-1.0, -1.0);
					    u_xlat18 = dot(u_xlat0.xy, u_xlat0.xy);
					    u_xlat18 = min(u_xlat18, 1.0);
					    u_xlat18 = (-u_xlat18) + 1.0;
					    u_xlat0.z = sqrt(u_xlat18);
					    u_xlat18 = (-_NormalSharpness) + 1.0;
					    u_xlat0.xyz = u_xlat0.xyz / vec3(u_xlat18);
					    u_xlat0.xyz = clamp(u_xlat0.xyz, 0.0, 1.0);
					    u_xlat1.xyz = u_xlat0.yyy * vs_TEXCOORD6.xyz;
					    u_xlat0.xyw = u_xlat0.xxx * vs_TEXCOORD5.xyz + u_xlat1.xyz;
					    u_xlat1.x = dot(vs_TEXCOORD4.xyz, vs_TEXCOORD4.xyz);
					    u_xlat1.x = inversesqrt(u_xlat1.x);
					    u_xlat1.xyz = u_xlat1.xxx * vs_TEXCOORD4.xyz;
					    u_xlat0.xyz = u_xlat0.zzz * u_xlat1.xyz + u_xlat0.xyw;
					    u_xlat18 = dot(u_xlat0.xyz, u_xlat0.xyz);
					    u_xlat18 = inversesqrt(u_xlat18);
					    u_xlat0.xyz = vec3(u_xlat18) * u_xlat0.xyz;
					    u_xlat2.xyz = (-vs_TEXCOORD3.xyz) + _WorldSpaceCameraPos.xyz;
					    u_xlat18 = dot(u_xlat2.xyz, u_xlat2.xyz);
					    u_xlat18 = inversesqrt(u_xlat18);
					    u_xlat3.xyz = vec3(u_xlat18) * u_xlat2.xyz;
					    u_xlat1.x = dot(u_xlat3.xyz, u_xlat1.xyz);
					    u_xlati7 = int((0.0<u_xlat1.x) ? 0xFFFFFFFFu : uint(0));
					    u_xlati1 = int((u_xlat1.x<0.0) ? 0xFFFFFFFFu : uint(0));
					    u_xlati1 = (-u_xlati7) + u_xlati1;
					    u_xlat1.x = float(u_xlati1);
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xxx;
					    u_xlat1.xyz = _WorldSpaceLightPos0.www * (-vs_TEXCOORD3.xyz) + _WorldSpaceLightPos0.xyz;
					    u_xlat19 = dot(u_xlat1.xyz, u_xlat1.xyz);
					    u_xlat19 = inversesqrt(u_xlat19);
					    u_xlat1.xyz = vec3(u_xlat19) * u_xlat1.xyz;
					    u_xlat2.xyz = u_xlat2.xyz * vec3(u_xlat18) + u_xlat1.xyz;
					    u_xlat18 = dot(u_xlat2.xyz, u_xlat2.xyz);
					    u_xlat18 = inversesqrt(u_xlat18);
					    u_xlat2.xyz = vec3(u_xlat18) * u_xlat2.xyz;
					    u_xlat0.w = dot(u_xlat0.xyz, u_xlat2.xyz);
					    u_xlat1.w = dot(u_xlat1.xyz, u_xlat2.xyz);
					    u_xlat1.x = dot(u_xlat0.xyz, u_xlat1.xyz);
					    u_xlat0.x = dot(u_xlat0.xyz, u_xlat3.xyz);
					    u_xlat0.yz = max(u_xlat1.xw, vec2(0.0, 0.0));
					    u_xlat0.xw = max(u_xlat0.xw, vec2(0.0, 0.0));
					    u_xlat1.x = log2(u_xlat0.w);
					    u_xlat18 = u_xlat0.w * u_xlat0.w;
					    u_xlat1.x = u_xlat1.x * 9.99999975e-05;
					    u_xlat1.x = exp2(u_xlat1.x);
					    u_xlat7.x = u_xlat0.x * 0.202115417 + 0.797884583;
					    u_xlat13 = u_xlat0.y * 0.202115417 + 0.797884583;
					    u_xlat7.x = u_xlat13 * u_xlat7.x + 9.99999975e-06;
					    u_xlat1.y = float(1.0) / u_xlat7.x;
					    u_xlat1.xy = u_xlat1.xy * vec2(0.318325758, 0.25);
					    u_xlat7.x = u_xlat0.y * u_xlat1.y;
					    u_xlat1.x = u_xlat1.x * u_xlat7.x;
					    u_xlat1.x = u_xlat1.x * 0.616850257;
					    u_xlat7.xy = vs_TEXCOORD8.xy / vs_TEXCOORD8.ww;
					    u_xlat2 = texture(_ShadowMapTexture, u_xlat7.xy);
					    u_xlat3 = texture(_LightTexture0, vs_TEXCOORD7.xy);
					    u_xlat7.x = u_xlat2.x * u_xlat3.w;
					    u_xlat7.xyz = u_xlat7.xxx * _LightColor0.xyz;
					    u_xlat2.xyz = vec3(u_xlat18) * u_xlat7.xyz;
					    u_xlat2.xyz = u_xlat1.xxx * u_xlat2.xyz;
					    u_xlat2.xyz = u_xlat2.xyz * _LightColor0.xyz;
					    u_xlat0.xw = (-u_xlat0.xz) + vec2(1.00001001, 1.0);
					    u_xlat1.x = u_xlat0.w * u_xlat0.w;
					    u_xlat1.x = u_xlat1.x * u_xlat1.x;
					    u_xlat18 = u_xlat0.w * u_xlat1.x;
					    u_xlat3.xy = vs_TEXCOORD0.xy * _MainTexture_ST.xy + _MainTexture_ST.zw;
					    u_xlat3 = texture(_MainTexture, u_xlat3.xy);
					    u_xlat3.xyz = _Color.xyz * u_xlat3.xyz + vec3(vec3(_Shadows, _Shadows, _Shadows));
					    u_xlat3.xyz = u_xlat3.xyz + vec3(-1.0, -1.0, -1.0);
					    u_xlat3.xyz = clamp(u_xlat3.xyz, 0.0, 1.0);
					    u_xlat4.xyz = u_xlat3.xyz + vec3(-0.220916301, -0.220916301, -0.220916301);
					    u_xlat5.xy = vs_TEXCOORD0.xy * _Specular_ST.xy + _Specular_ST.zw;
					    u_xlat5 = texture(_Specular, u_xlat5.xy);
					    u_xlat1.x = u_xlat5.x * 0.449999988;
					    u_xlat20 = (-u_xlat5.x) * 0.350587666 + 0.779083729;
					    u_xlat3.xyz = vec3(u_xlat20) * u_xlat3.xyz;
					    u_xlat4.xyz = u_xlat1.xxx * u_xlat4.xyz + vec3(0.220916301, 0.220916301, 0.220916301);
					    u_xlat5.xyz = (-u_xlat4.xyz) + vec3(1.0, 1.0, 1.0);
					    u_xlat4.xyz = u_xlat5.xyz * vec3(u_xlat18) + u_xlat4.xyz;
					    u_xlat2.xyz = u_xlat2.xyz * u_xlat4.xyz;
					    u_xlat18 = u_xlat0.x * u_xlat0.x;
					    u_xlat18 = u_xlat18 * u_xlat18;
					    u_xlat0.x = u_xlat18 * u_xlat0.x;
					    u_xlat18 = u_xlat0.z + u_xlat0.z;
					    u_xlat12 = u_xlat18 * u_xlat0.z + -0.5;
					    u_xlat0.x = u_xlat12 * u_xlat0.x + 1.0;
					    u_xlat18 = (-u_xlat0.y) + 1.00001001;
					    u_xlat1.x = u_xlat18 * u_xlat18;
					    u_xlat1.x = u_xlat1.x * u_xlat1.x;
					    u_xlat18 = u_xlat18 * u_xlat1.x;
					    u_xlat12 = u_xlat12 * u_xlat18 + 1.0;
					    u_xlat0.x = u_xlat0.x * u_xlat12;
					    u_xlat0.x = u_xlat0.y * u_xlat0.x;
					    u_xlat0.xyz = u_xlat7.xyz * u_xlat0.xxx;
					    SV_Target0.xyz = u_xlat0.xyz * u_xlat3.xyz + u_xlat2.xyz;
					    SV_Target0.w = 0.0;
					    return;
					}"
				}
				SubProgram "d3d11 " {
					Keywords { "POINT" "SHADOWS_CUBE" "DIRLIGHTMAP_SEPARATE" "LIGHTMAP_OFF" "DYNAMICLIGHTMAP_OFF" }
					"ps_4_0
					
					#version 330
					#extension GL_ARB_explicit_attrib_location : require
					#extension GL_ARB_explicit_uniform_location : require
					
					#define HLSLCC_ENABLE_UNIFORM_BUFFERS 1
					#if HLSLCC_ENABLE_UNIFORM_BUFFERS
					#define UNITY_UNIFORM
					#else
					#define UNITY_UNIFORM uniform
					#endif
					#define UNITY_SUPPORTS_UNIFORM_LOCATION 1
					#if UNITY_SUPPORTS_UNIFORM_LOCATION
					#define UNITY_LOCATION(x) layout(location = x)
					#define UNITY_BINDING(x) layout(binding = x, std140)
					#else
					#define UNITY_LOCATION(x)
					#define UNITY_BINDING(x) layout(std140)
					#endif
					layout(std140) uniform PGlobals {
						vec4 unused_0_0[6];
						vec4 _LightColor0;
						vec4 unused_0_2;
						vec4 _MainTexture_ST;
						vec4 _Specular_ST;
						vec4 _NormalMap_ST;
						vec4 _Color;
						vec4 unused_0_7;
						float _NormalSharpness;
						float _Shadows;
					};
					layout(std140) uniform UnityPerCamera {
						vec4 unused_1_0[4];
						vec3 _WorldSpaceCameraPos;
						vec4 unused_1_2[4];
					};
					layout(std140) uniform UnityLighting {
						vec4 _WorldSpaceLightPos0;
						vec4 unused_2_1;
						vec4 _LightProjectionParams;
						vec4 unused_2_3[45];
					};
					layout(std140) uniform UnityShadows {
						vec4 unused_3_0[24];
						vec4 _LightShadowData;
						vec4 unused_3_2;
					};
					uniform  sampler2D _NormalMap;
					uniform  sampler2D _LightTexture0;
					uniform  sampler2D _MainTexture;
					uniform  sampler2D _Specular;
					uniform  samplerCube _ShadowMapTexture;
					uniform  samplerCubeShadow hlslcc_zcmp_ShadowMapTexture;
					in  vec2 vs_TEXCOORD0;
					in  vec4 vs_TEXCOORD3;
					in  vec3 vs_TEXCOORD4;
					in  vec3 vs_TEXCOORD5;
					in  vec3 vs_TEXCOORD6;
					in  vec3 vs_TEXCOORD7;
					in  vec3 vs_TEXCOORD8;
					layout(location = 0) out vec4 SV_Target0;
					vec4 u_xlat0;
					vec4 u_xlat1;
					int u_xlati1;
					vec4 u_xlat2;
					vec4 u_xlat3;
					vec3 u_xlat4;
					vec4 u_xlat5;
					vec3 u_xlat7;
					int u_xlati7;
					float u_xlat12;
					float u_xlat13;
					float u_xlat18;
					float u_xlat19;
					float u_xlat20;
					void main()
					{
					    u_xlat0.xy = vs_TEXCOORD0.xy * _NormalMap_ST.xy + _NormalMap_ST.zw;
					    u_xlat0 = texture(_NormalMap, u_xlat0.xy);
					    u_xlat0.x = u_xlat0.w * u_xlat0.x;
					    u_xlat0.xy = u_xlat0.xy * vec2(2.0, 2.0) + vec2(-1.0, -1.0);
					    u_xlat18 = dot(u_xlat0.xy, u_xlat0.xy);
					    u_xlat18 = min(u_xlat18, 1.0);
					    u_xlat18 = (-u_xlat18) + 1.0;
					    u_xlat0.z = sqrt(u_xlat18);
					    u_xlat18 = (-_NormalSharpness) + 1.0;
					    u_xlat0.xyz = u_xlat0.xyz / vec3(u_xlat18);
					    u_xlat0.xyz = clamp(u_xlat0.xyz, 0.0, 1.0);
					    u_xlat1.xyz = u_xlat0.yyy * vs_TEXCOORD6.xyz;
					    u_xlat0.xyw = u_xlat0.xxx * vs_TEXCOORD5.xyz + u_xlat1.xyz;
					    u_xlat1.x = dot(vs_TEXCOORD4.xyz, vs_TEXCOORD4.xyz);
					    u_xlat1.x = inversesqrt(u_xlat1.x);
					    u_xlat1.xyz = u_xlat1.xxx * vs_TEXCOORD4.xyz;
					    u_xlat0.xyz = u_xlat0.zzz * u_xlat1.xyz + u_xlat0.xyw;
					    u_xlat18 = dot(u_xlat0.xyz, u_xlat0.xyz);
					    u_xlat18 = inversesqrt(u_xlat18);
					    u_xlat0.xyz = vec3(u_xlat18) * u_xlat0.xyz;
					    u_xlat2.xyz = (-vs_TEXCOORD3.xyz) + _WorldSpaceCameraPos.xyz;
					    u_xlat18 = dot(u_xlat2.xyz, u_xlat2.xyz);
					    u_xlat18 = inversesqrt(u_xlat18);
					    u_xlat3.xyz = vec3(u_xlat18) * u_xlat2.xyz;
					    u_xlat1.x = dot(u_xlat3.xyz, u_xlat1.xyz);
					    u_xlati7 = int((0.0<u_xlat1.x) ? 0xFFFFFFFFu : uint(0));
					    u_xlati1 = int((u_xlat1.x<0.0) ? 0xFFFFFFFFu : uint(0));
					    u_xlati1 = (-u_xlati7) + u_xlati1;
					    u_xlat1.x = float(u_xlati1);
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xxx;
					    u_xlat1.xyz = _WorldSpaceLightPos0.www * (-vs_TEXCOORD3.xyz) + _WorldSpaceLightPos0.xyz;
					    u_xlat19 = dot(u_xlat1.xyz, u_xlat1.xyz);
					    u_xlat19 = inversesqrt(u_xlat19);
					    u_xlat1.xyz = vec3(u_xlat19) * u_xlat1.xyz;
					    u_xlat2.xyz = u_xlat2.xyz * vec3(u_xlat18) + u_xlat1.xyz;
					    u_xlat18 = dot(u_xlat2.xyz, u_xlat2.xyz);
					    u_xlat18 = inversesqrt(u_xlat18);
					    u_xlat2.xyz = vec3(u_xlat18) * u_xlat2.xyz;
					    u_xlat0.w = dot(u_xlat0.xyz, u_xlat2.xyz);
					    u_xlat1.w = dot(u_xlat1.xyz, u_xlat2.xyz);
					    u_xlat1.x = dot(u_xlat0.xyz, u_xlat1.xyz);
					    u_xlat0.x = dot(u_xlat0.xyz, u_xlat3.xyz);
					    u_xlat0.yz = max(u_xlat1.xw, vec2(0.0, 0.0));
					    u_xlat0.xw = max(u_xlat0.xw, vec2(0.0, 0.0));
					    u_xlat1.x = log2(u_xlat0.w);
					    u_xlat18 = u_xlat0.w * u_xlat0.w;
					    u_xlat1.x = u_xlat1.x * 9.99999975e-05;
					    u_xlat1.x = exp2(u_xlat1.x);
					    u_xlat7.x = u_xlat0.x * 0.202115417 + 0.797884583;
					    u_xlat13 = u_xlat0.y * 0.202115417 + 0.797884583;
					    u_xlat7.x = u_xlat13 * u_xlat7.x + 9.99999975e-06;
					    u_xlat1.y = float(1.0) / u_xlat7.x;
					    u_xlat1.xy = u_xlat1.xy * vec2(0.318325758, 0.25);
					    u_xlat7.x = u_xlat0.y * u_xlat1.y;
					    u_xlat1.x = u_xlat1.x * u_xlat7.x;
					    u_xlat1.x = u_xlat1.x * 0.616850257;
					    u_xlat7.x = max(abs(vs_TEXCOORD8.y), abs(vs_TEXCOORD8.x));
					    u_xlat7.x = max(u_xlat7.x, abs(vs_TEXCOORD8.z));
					    u_xlat7.x = u_xlat7.x + (-_LightProjectionParams.z);
					    u_xlat7.x = max(u_xlat7.x, 9.99999975e-06);
					    u_xlat7.x = u_xlat7.x * _LightProjectionParams.w;
					    u_xlat7.x = _LightProjectionParams.y / u_xlat7.x;
					    u_xlat7.x = u_xlat7.x + (-_LightProjectionParams.x);
					    u_xlat7.x = (-u_xlat7.x) + 1.0;
					    vec4 txVec0 = vec4(vs_TEXCOORD8.xyz,u_xlat7.x);
					    u_xlat7.x = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec0, 0.0);
					    u_xlat13 = (-_LightShadowData.x) + 1.0;
					    u_xlat7.x = u_xlat7.x * u_xlat13 + _LightShadowData.x;
					    u_xlat13 = dot(vs_TEXCOORD7.xyz, vs_TEXCOORD7.xyz);
					    u_xlat2 = texture(_LightTexture0, vec2(u_xlat13));
					    u_xlat7.x = u_xlat7.x * u_xlat2.x;
					    u_xlat7.xyz = u_xlat7.xxx * _LightColor0.xyz;
					    u_xlat2.xyz = vec3(u_xlat18) * u_xlat7.xyz;
					    u_xlat2.xyz = u_xlat1.xxx * u_xlat2.xyz;
					    u_xlat2.xyz = u_xlat2.xyz * _LightColor0.xyz;
					    u_xlat0.xw = (-u_xlat0.xz) + vec2(1.00001001, 1.0);
					    u_xlat1.x = u_xlat0.w * u_xlat0.w;
					    u_xlat1.x = u_xlat1.x * u_xlat1.x;
					    u_xlat18 = u_xlat0.w * u_xlat1.x;
					    u_xlat3.xy = vs_TEXCOORD0.xy * _MainTexture_ST.xy + _MainTexture_ST.zw;
					    u_xlat3 = texture(_MainTexture, u_xlat3.xy);
					    u_xlat3.xyz = _Color.xyz * u_xlat3.xyz + vec3(vec3(_Shadows, _Shadows, _Shadows));
					    u_xlat3.xyz = u_xlat3.xyz + vec3(-1.0, -1.0, -1.0);
					    u_xlat3.xyz = clamp(u_xlat3.xyz, 0.0, 1.0);
					    u_xlat4.xyz = u_xlat3.xyz + vec3(-0.220916301, -0.220916301, -0.220916301);
					    u_xlat5.xy = vs_TEXCOORD0.xy * _Specular_ST.xy + _Specular_ST.zw;
					    u_xlat5 = texture(_Specular, u_xlat5.xy);
					    u_xlat1.x = u_xlat5.x * 0.449999988;
					    u_xlat20 = (-u_xlat5.x) * 0.350587666 + 0.779083729;
					    u_xlat3.xyz = vec3(u_xlat20) * u_xlat3.xyz;
					    u_xlat4.xyz = u_xlat1.xxx * u_xlat4.xyz + vec3(0.220916301, 0.220916301, 0.220916301);
					    u_xlat5.xyz = (-u_xlat4.xyz) + vec3(1.0, 1.0, 1.0);
					    u_xlat4.xyz = u_xlat5.xyz * vec3(u_xlat18) + u_xlat4.xyz;
					    u_xlat2.xyz = u_xlat2.xyz * u_xlat4.xyz;
					    u_xlat18 = u_xlat0.x * u_xlat0.x;
					    u_xlat18 = u_xlat18 * u_xlat18;
					    u_xlat0.x = u_xlat18 * u_xlat0.x;
					    u_xlat18 = u_xlat0.z + u_xlat0.z;
					    u_xlat12 = u_xlat18 * u_xlat0.z + -0.5;
					    u_xlat0.x = u_xlat12 * u_xlat0.x + 1.0;
					    u_xlat18 = (-u_xlat0.y) + 1.00001001;
					    u_xlat1.x = u_xlat18 * u_xlat18;
					    u_xlat1.x = u_xlat1.x * u_xlat1.x;
					    u_xlat18 = u_xlat18 * u_xlat1.x;
					    u_xlat12 = u_xlat12 * u_xlat18 + 1.0;
					    u_xlat0.x = u_xlat0.x * u_xlat12;
					    u_xlat0.x = u_xlat0.y * u_xlat0.x;
					    u_xlat0.xyz = u_xlat7.xyz * u_xlat0.xxx;
					    SV_Target0.xyz = u_xlat0.xyz * u_xlat3.xyz + u_xlat2.xyz;
					    SV_Target0.w = 0.0;
					    return;
					}"
				}
				SubProgram "d3d11 " {
					Keywords { "POINT" "SHADOWS_CUBE" "SHADOWS_SOFT" "DIRLIGHTMAP_SEPARATE" "LIGHTMAP_OFF" "DYNAMICLIGHTMAP_OFF" }
					"ps_4_0
					
					#version 330
					#extension GL_ARB_explicit_attrib_location : require
					#extension GL_ARB_explicit_uniform_location : require
					
					#define HLSLCC_ENABLE_UNIFORM_BUFFERS 1
					#if HLSLCC_ENABLE_UNIFORM_BUFFERS
					#define UNITY_UNIFORM
					#else
					#define UNITY_UNIFORM uniform
					#endif
					#define UNITY_SUPPORTS_UNIFORM_LOCATION 1
					#if UNITY_SUPPORTS_UNIFORM_LOCATION
					#define UNITY_LOCATION(x) layout(location = x)
					#define UNITY_BINDING(x) layout(binding = x, std140)
					#else
					#define UNITY_LOCATION(x)
					#define UNITY_BINDING(x) layout(std140)
					#endif
					layout(std140) uniform PGlobals {
						vec4 unused_0_0[6];
						vec4 _LightColor0;
						vec4 unused_0_2;
						vec4 _MainTexture_ST;
						vec4 _Specular_ST;
						vec4 _NormalMap_ST;
						vec4 _Color;
						vec4 unused_0_7;
						float _NormalSharpness;
						float _Shadows;
					};
					layout(std140) uniform UnityPerCamera {
						vec4 unused_1_0[4];
						vec3 _WorldSpaceCameraPos;
						vec4 unused_1_2[4];
					};
					layout(std140) uniform UnityLighting {
						vec4 _WorldSpaceLightPos0;
						vec4 unused_2_1;
						vec4 _LightProjectionParams;
						vec4 unused_2_3[45];
					};
					layout(std140) uniform UnityShadows {
						vec4 unused_3_0[24];
						vec4 _LightShadowData;
						vec4 unused_3_2;
					};
					uniform  sampler2D _NormalMap;
					uniform  sampler2D _LightTexture0;
					uniform  sampler2D _MainTexture;
					uniform  sampler2D _Specular;
					uniform  samplerCube _ShadowMapTexture;
					uniform  samplerCubeShadow hlslcc_zcmp_ShadowMapTexture;
					in  vec2 vs_TEXCOORD0;
					in  vec4 vs_TEXCOORD3;
					in  vec3 vs_TEXCOORD4;
					in  vec3 vs_TEXCOORD5;
					in  vec3 vs_TEXCOORD6;
					in  vec3 vs_TEXCOORD7;
					in  vec3 vs_TEXCOORD8;
					layout(location = 0) out vec4 SV_Target0;
					vec4 u_xlat0;
					vec4 u_xlat1;
					int u_xlati1;
					vec4 u_xlat2;
					vec4 u_xlat3;
					vec3 u_xlat4;
					vec4 u_xlat5;
					vec3 u_xlat7;
					int u_xlati7;
					float u_xlat12;
					float u_xlat13;
					float u_xlat18;
					float u_xlat19;
					float u_xlat20;
					void main()
					{
					    u_xlat0.xy = vs_TEXCOORD0.xy * _NormalMap_ST.xy + _NormalMap_ST.zw;
					    u_xlat0 = texture(_NormalMap, u_xlat0.xy);
					    u_xlat0.x = u_xlat0.w * u_xlat0.x;
					    u_xlat0.xy = u_xlat0.xy * vec2(2.0, 2.0) + vec2(-1.0, -1.0);
					    u_xlat18 = dot(u_xlat0.xy, u_xlat0.xy);
					    u_xlat18 = min(u_xlat18, 1.0);
					    u_xlat18 = (-u_xlat18) + 1.0;
					    u_xlat0.z = sqrt(u_xlat18);
					    u_xlat18 = (-_NormalSharpness) + 1.0;
					    u_xlat0.xyz = u_xlat0.xyz / vec3(u_xlat18);
					    u_xlat0.xyz = clamp(u_xlat0.xyz, 0.0, 1.0);
					    u_xlat1.xyz = u_xlat0.yyy * vs_TEXCOORD6.xyz;
					    u_xlat0.xyw = u_xlat0.xxx * vs_TEXCOORD5.xyz + u_xlat1.xyz;
					    u_xlat1.x = dot(vs_TEXCOORD4.xyz, vs_TEXCOORD4.xyz);
					    u_xlat1.x = inversesqrt(u_xlat1.x);
					    u_xlat1.xyz = u_xlat1.xxx * vs_TEXCOORD4.xyz;
					    u_xlat0.xyz = u_xlat0.zzz * u_xlat1.xyz + u_xlat0.xyw;
					    u_xlat18 = dot(u_xlat0.xyz, u_xlat0.xyz);
					    u_xlat18 = inversesqrt(u_xlat18);
					    u_xlat0.xyz = vec3(u_xlat18) * u_xlat0.xyz;
					    u_xlat2.xyz = (-vs_TEXCOORD3.xyz) + _WorldSpaceCameraPos.xyz;
					    u_xlat18 = dot(u_xlat2.xyz, u_xlat2.xyz);
					    u_xlat18 = inversesqrt(u_xlat18);
					    u_xlat3.xyz = vec3(u_xlat18) * u_xlat2.xyz;
					    u_xlat1.x = dot(u_xlat3.xyz, u_xlat1.xyz);
					    u_xlati7 = int((0.0<u_xlat1.x) ? 0xFFFFFFFFu : uint(0));
					    u_xlati1 = int((u_xlat1.x<0.0) ? 0xFFFFFFFFu : uint(0));
					    u_xlati1 = (-u_xlati7) + u_xlati1;
					    u_xlat1.x = float(u_xlati1);
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xxx;
					    u_xlat1.xyz = _WorldSpaceLightPos0.www * (-vs_TEXCOORD3.xyz) + _WorldSpaceLightPos0.xyz;
					    u_xlat19 = dot(u_xlat1.xyz, u_xlat1.xyz);
					    u_xlat19 = inversesqrt(u_xlat19);
					    u_xlat1.xyz = vec3(u_xlat19) * u_xlat1.xyz;
					    u_xlat2.xyz = u_xlat2.xyz * vec3(u_xlat18) + u_xlat1.xyz;
					    u_xlat18 = dot(u_xlat2.xyz, u_xlat2.xyz);
					    u_xlat18 = inversesqrt(u_xlat18);
					    u_xlat2.xyz = vec3(u_xlat18) * u_xlat2.xyz;
					    u_xlat0.w = dot(u_xlat0.xyz, u_xlat2.xyz);
					    u_xlat1.w = dot(u_xlat1.xyz, u_xlat2.xyz);
					    u_xlat1.x = dot(u_xlat0.xyz, u_xlat1.xyz);
					    u_xlat0.x = dot(u_xlat0.xyz, u_xlat3.xyz);
					    u_xlat0.yz = max(u_xlat1.xw, vec2(0.0, 0.0));
					    u_xlat0.xw = max(u_xlat0.xw, vec2(0.0, 0.0));
					    u_xlat1.x = log2(u_xlat0.w);
					    u_xlat18 = u_xlat0.w * u_xlat0.w;
					    u_xlat1.x = u_xlat1.x * 9.99999975e-05;
					    u_xlat1.x = exp2(u_xlat1.x);
					    u_xlat7.x = u_xlat0.x * 0.202115417 + 0.797884583;
					    u_xlat13 = u_xlat0.y * 0.202115417 + 0.797884583;
					    u_xlat7.x = u_xlat13 * u_xlat7.x + 9.99999975e-06;
					    u_xlat1.y = float(1.0) / u_xlat7.x;
					    u_xlat1.xy = u_xlat1.xy * vec2(0.318325758, 0.25);
					    u_xlat7.x = u_xlat0.y * u_xlat1.y;
					    u_xlat1.x = u_xlat1.x * u_xlat7.x;
					    u_xlat1.x = u_xlat1.x * 0.616850257;
					    u_xlat7.x = max(abs(vs_TEXCOORD8.y), abs(vs_TEXCOORD8.x));
					    u_xlat7.x = max(u_xlat7.x, abs(vs_TEXCOORD8.z));
					    u_xlat7.x = u_xlat7.x + (-_LightProjectionParams.z);
					    u_xlat7.x = max(u_xlat7.x, 9.99999975e-06);
					    u_xlat7.x = u_xlat7.x * _LightProjectionParams.w;
					    u_xlat7.x = _LightProjectionParams.y / u_xlat7.x;
					    u_xlat7.x = u_xlat7.x + (-_LightProjectionParams.x);
					    u_xlat7.x = (-u_xlat7.x) + 1.0;
					    u_xlat2.xyz = vs_TEXCOORD8.xyz + vec3(0.0078125, 0.0078125, 0.0078125);
					    vec4 txVec0 = vec4(u_xlat2.xyz,u_xlat7.x);
					    u_xlat2.x = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec0, 0.0);
					    u_xlat3.xyz = vs_TEXCOORD8.xyz + vec3(-0.0078125, -0.0078125, 0.0078125);
					    vec4 txVec1 = vec4(u_xlat3.xyz,u_xlat7.x);
					    u_xlat2.y = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec1, 0.0);
					    u_xlat3.xyz = vs_TEXCOORD8.xyz + vec3(-0.0078125, 0.0078125, -0.0078125);
					    vec4 txVec2 = vec4(u_xlat3.xyz,u_xlat7.x);
					    u_xlat2.z = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec2, 0.0);
					    u_xlat3.xyz = vs_TEXCOORD8.xyz + vec3(0.0078125, -0.0078125, -0.0078125);
					    vec4 txVec3 = vec4(u_xlat3.xyz,u_xlat7.x);
					    u_xlat2.w = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec3, 0.0);
					    u_xlat7.x = dot(u_xlat2, vec4(0.25, 0.25, 0.25, 0.25));
					    u_xlat13 = (-_LightShadowData.x) + 1.0;
					    u_xlat7.x = u_xlat7.x * u_xlat13 + _LightShadowData.x;
					    u_xlat13 = dot(vs_TEXCOORD7.xyz, vs_TEXCOORD7.xyz);
					    u_xlat2 = texture(_LightTexture0, vec2(u_xlat13));
					    u_xlat7.x = u_xlat7.x * u_xlat2.x;
					    u_xlat7.xyz = u_xlat7.xxx * _LightColor0.xyz;
					    u_xlat2.xyz = vec3(u_xlat18) * u_xlat7.xyz;
					    u_xlat2.xyz = u_xlat1.xxx * u_xlat2.xyz;
					    u_xlat2.xyz = u_xlat2.xyz * _LightColor0.xyz;
					    u_xlat0.xw = (-u_xlat0.xz) + vec2(1.00001001, 1.0);
					    u_xlat1.x = u_xlat0.w * u_xlat0.w;
					    u_xlat1.x = u_xlat1.x * u_xlat1.x;
					    u_xlat18 = u_xlat0.w * u_xlat1.x;
					    u_xlat3.xy = vs_TEXCOORD0.xy * _MainTexture_ST.xy + _MainTexture_ST.zw;
					    u_xlat3 = texture(_MainTexture, u_xlat3.xy);
					    u_xlat3.xyz = _Color.xyz * u_xlat3.xyz + vec3(vec3(_Shadows, _Shadows, _Shadows));
					    u_xlat3.xyz = u_xlat3.xyz + vec3(-1.0, -1.0, -1.0);
					    u_xlat3.xyz = clamp(u_xlat3.xyz, 0.0, 1.0);
					    u_xlat4.xyz = u_xlat3.xyz + vec3(-0.220916301, -0.220916301, -0.220916301);
					    u_xlat5.xy = vs_TEXCOORD0.xy * _Specular_ST.xy + _Specular_ST.zw;
					    u_xlat5 = texture(_Specular, u_xlat5.xy);
					    u_xlat1.x = u_xlat5.x * 0.449999988;
					    u_xlat20 = (-u_xlat5.x) * 0.350587666 + 0.779083729;
					    u_xlat3.xyz = vec3(u_xlat20) * u_xlat3.xyz;
					    u_xlat4.xyz = u_xlat1.xxx * u_xlat4.xyz + vec3(0.220916301, 0.220916301, 0.220916301);
					    u_xlat5.xyz = (-u_xlat4.xyz) + vec3(1.0, 1.0, 1.0);
					    u_xlat4.xyz = u_xlat5.xyz * vec3(u_xlat18) + u_xlat4.xyz;
					    u_xlat2.xyz = u_xlat2.xyz * u_xlat4.xyz;
					    u_xlat18 = u_xlat0.x * u_xlat0.x;
					    u_xlat18 = u_xlat18 * u_xlat18;
					    u_xlat0.x = u_xlat18 * u_xlat0.x;
					    u_xlat18 = u_xlat0.z + u_xlat0.z;
					    u_xlat12 = u_xlat18 * u_xlat0.z + -0.5;
					    u_xlat0.x = u_xlat12 * u_xlat0.x + 1.0;
					    u_xlat18 = (-u_xlat0.y) + 1.00001001;
					    u_xlat1.x = u_xlat18 * u_xlat18;
					    u_xlat1.x = u_xlat1.x * u_xlat1.x;
					    u_xlat18 = u_xlat18 * u_xlat1.x;
					    u_xlat12 = u_xlat12 * u_xlat18 + 1.0;
					    u_xlat0.x = u_xlat0.x * u_xlat12;
					    u_xlat0.x = u_xlat0.y * u_xlat0.x;
					    u_xlat0.xyz = u_xlat7.xyz * u_xlat0.xxx;
					    SV_Target0.xyz = u_xlat0.xyz * u_xlat3.xyz + u_xlat2.xyz;
					    SV_Target0.w = 0.0;
					    return;
					}"
				}
				SubProgram "d3d11 " {
					Keywords { "POINT_COOKIE" "SHADOWS_CUBE" "DIRLIGHTMAP_SEPARATE" "LIGHTMAP_OFF" "DYNAMICLIGHTMAP_OFF" }
					"ps_4_0
					
					#version 330
					#extension GL_ARB_explicit_attrib_location : require
					#extension GL_ARB_explicit_uniform_location : require
					
					#define HLSLCC_ENABLE_UNIFORM_BUFFERS 1
					#if HLSLCC_ENABLE_UNIFORM_BUFFERS
					#define UNITY_UNIFORM
					#else
					#define UNITY_UNIFORM uniform
					#endif
					#define UNITY_SUPPORTS_UNIFORM_LOCATION 1
					#if UNITY_SUPPORTS_UNIFORM_LOCATION
					#define UNITY_LOCATION(x) layout(location = x)
					#define UNITY_BINDING(x) layout(binding = x, std140)
					#else
					#define UNITY_LOCATION(x)
					#define UNITY_BINDING(x) layout(std140)
					#endif
					layout(std140) uniform PGlobals {
						vec4 unused_0_0[6];
						vec4 _LightColor0;
						vec4 unused_0_2;
						vec4 _MainTexture_ST;
						vec4 _Specular_ST;
						vec4 _NormalMap_ST;
						vec4 _Color;
						vec4 unused_0_7;
						float _NormalSharpness;
						float _Shadows;
					};
					layout(std140) uniform UnityPerCamera {
						vec4 unused_1_0[4];
						vec3 _WorldSpaceCameraPos;
						vec4 unused_1_2[4];
					};
					layout(std140) uniform UnityLighting {
						vec4 _WorldSpaceLightPos0;
						vec4 unused_2_1;
						vec4 _LightProjectionParams;
						vec4 unused_2_3[45];
					};
					layout(std140) uniform UnityShadows {
						vec4 unused_3_0[24];
						vec4 _LightShadowData;
						vec4 unused_3_2;
					};
					uniform  sampler2D _NormalMap;
					uniform  sampler2D _LightTextureB0;
					uniform  samplerCube _LightTexture0;
					uniform  sampler2D _MainTexture;
					uniform  sampler2D _Specular;
					uniform  samplerCube _ShadowMapTexture;
					uniform  samplerCubeShadow hlslcc_zcmp_ShadowMapTexture;
					in  vec2 vs_TEXCOORD0;
					in  vec4 vs_TEXCOORD3;
					in  vec3 vs_TEXCOORD4;
					in  vec3 vs_TEXCOORD5;
					in  vec3 vs_TEXCOORD6;
					in  vec3 vs_TEXCOORD7;
					in  vec3 vs_TEXCOORD8;
					layout(location = 0) out vec4 SV_Target0;
					vec4 u_xlat0;
					vec4 u_xlat1;
					int u_xlati1;
					vec4 u_xlat2;
					vec4 u_xlat3;
					vec3 u_xlat4;
					vec4 u_xlat5;
					vec3 u_xlat7;
					int u_xlati7;
					float u_xlat12;
					float u_xlat13;
					float u_xlat18;
					float u_xlat19;
					float u_xlat20;
					void main()
					{
					    u_xlat0.xy = vs_TEXCOORD0.xy * _NormalMap_ST.xy + _NormalMap_ST.zw;
					    u_xlat0 = texture(_NormalMap, u_xlat0.xy);
					    u_xlat0.x = u_xlat0.w * u_xlat0.x;
					    u_xlat0.xy = u_xlat0.xy * vec2(2.0, 2.0) + vec2(-1.0, -1.0);
					    u_xlat18 = dot(u_xlat0.xy, u_xlat0.xy);
					    u_xlat18 = min(u_xlat18, 1.0);
					    u_xlat18 = (-u_xlat18) + 1.0;
					    u_xlat0.z = sqrt(u_xlat18);
					    u_xlat18 = (-_NormalSharpness) + 1.0;
					    u_xlat0.xyz = u_xlat0.xyz / vec3(u_xlat18);
					    u_xlat0.xyz = clamp(u_xlat0.xyz, 0.0, 1.0);
					    u_xlat1.xyz = u_xlat0.yyy * vs_TEXCOORD6.xyz;
					    u_xlat0.xyw = u_xlat0.xxx * vs_TEXCOORD5.xyz + u_xlat1.xyz;
					    u_xlat1.x = dot(vs_TEXCOORD4.xyz, vs_TEXCOORD4.xyz);
					    u_xlat1.x = inversesqrt(u_xlat1.x);
					    u_xlat1.xyz = u_xlat1.xxx * vs_TEXCOORD4.xyz;
					    u_xlat0.xyz = u_xlat0.zzz * u_xlat1.xyz + u_xlat0.xyw;
					    u_xlat18 = dot(u_xlat0.xyz, u_xlat0.xyz);
					    u_xlat18 = inversesqrt(u_xlat18);
					    u_xlat0.xyz = vec3(u_xlat18) * u_xlat0.xyz;
					    u_xlat2.xyz = (-vs_TEXCOORD3.xyz) + _WorldSpaceCameraPos.xyz;
					    u_xlat18 = dot(u_xlat2.xyz, u_xlat2.xyz);
					    u_xlat18 = inversesqrt(u_xlat18);
					    u_xlat3.xyz = vec3(u_xlat18) * u_xlat2.xyz;
					    u_xlat1.x = dot(u_xlat3.xyz, u_xlat1.xyz);
					    u_xlati7 = int((0.0<u_xlat1.x) ? 0xFFFFFFFFu : uint(0));
					    u_xlati1 = int((u_xlat1.x<0.0) ? 0xFFFFFFFFu : uint(0));
					    u_xlati1 = (-u_xlati7) + u_xlati1;
					    u_xlat1.x = float(u_xlati1);
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xxx;
					    u_xlat1.xyz = _WorldSpaceLightPos0.www * (-vs_TEXCOORD3.xyz) + _WorldSpaceLightPos0.xyz;
					    u_xlat19 = dot(u_xlat1.xyz, u_xlat1.xyz);
					    u_xlat19 = inversesqrt(u_xlat19);
					    u_xlat1.xyz = vec3(u_xlat19) * u_xlat1.xyz;
					    u_xlat2.xyz = u_xlat2.xyz * vec3(u_xlat18) + u_xlat1.xyz;
					    u_xlat18 = dot(u_xlat2.xyz, u_xlat2.xyz);
					    u_xlat18 = inversesqrt(u_xlat18);
					    u_xlat2.xyz = vec3(u_xlat18) * u_xlat2.xyz;
					    u_xlat0.w = dot(u_xlat0.xyz, u_xlat2.xyz);
					    u_xlat1.w = dot(u_xlat1.xyz, u_xlat2.xyz);
					    u_xlat1.x = dot(u_xlat0.xyz, u_xlat1.xyz);
					    u_xlat0.x = dot(u_xlat0.xyz, u_xlat3.xyz);
					    u_xlat0.yz = max(u_xlat1.xw, vec2(0.0, 0.0));
					    u_xlat0.xw = max(u_xlat0.xw, vec2(0.0, 0.0));
					    u_xlat1.x = log2(u_xlat0.w);
					    u_xlat18 = u_xlat0.w * u_xlat0.w;
					    u_xlat1.x = u_xlat1.x * 9.99999975e-05;
					    u_xlat1.x = exp2(u_xlat1.x);
					    u_xlat7.x = u_xlat0.x * 0.202115417 + 0.797884583;
					    u_xlat13 = u_xlat0.y * 0.202115417 + 0.797884583;
					    u_xlat7.x = u_xlat13 * u_xlat7.x + 9.99999975e-06;
					    u_xlat1.y = float(1.0) / u_xlat7.x;
					    u_xlat1.xy = u_xlat1.xy * vec2(0.318325758, 0.25);
					    u_xlat7.x = u_xlat0.y * u_xlat1.y;
					    u_xlat1.x = u_xlat1.x * u_xlat7.x;
					    u_xlat1.x = u_xlat1.x * 0.616850257;
					    u_xlat7.x = max(abs(vs_TEXCOORD8.y), abs(vs_TEXCOORD8.x));
					    u_xlat7.x = max(u_xlat7.x, abs(vs_TEXCOORD8.z));
					    u_xlat7.x = u_xlat7.x + (-_LightProjectionParams.z);
					    u_xlat7.x = max(u_xlat7.x, 9.99999975e-06);
					    u_xlat7.x = u_xlat7.x * _LightProjectionParams.w;
					    u_xlat7.x = _LightProjectionParams.y / u_xlat7.x;
					    u_xlat7.x = u_xlat7.x + (-_LightProjectionParams.x);
					    u_xlat7.x = (-u_xlat7.x) + 1.0;
					    vec4 txVec0 = vec4(vs_TEXCOORD8.xyz,u_xlat7.x);
					    u_xlat7.x = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec0, 0.0);
					    u_xlat13 = (-_LightShadowData.x) + 1.0;
					    u_xlat7.x = u_xlat7.x * u_xlat13 + _LightShadowData.x;
					    u_xlat13 = dot(vs_TEXCOORD7.xyz, vs_TEXCOORD7.xyz);
					    u_xlat2 = texture(_LightTextureB0, vec2(u_xlat13));
					    u_xlat3 = texture(_LightTexture0, vs_TEXCOORD7.xyz);
					    u_xlat13 = u_xlat2.x * u_xlat3.w;
					    u_xlat7.x = u_xlat7.x * u_xlat13;
					    u_xlat7.xyz = u_xlat7.xxx * _LightColor0.xyz;
					    u_xlat2.xyz = vec3(u_xlat18) * u_xlat7.xyz;
					    u_xlat2.xyz = u_xlat1.xxx * u_xlat2.xyz;
					    u_xlat2.xyz = u_xlat2.xyz * _LightColor0.xyz;
					    u_xlat0.xw = (-u_xlat0.xz) + vec2(1.00001001, 1.0);
					    u_xlat1.x = u_xlat0.w * u_xlat0.w;
					    u_xlat1.x = u_xlat1.x * u_xlat1.x;
					    u_xlat18 = u_xlat0.w * u_xlat1.x;
					    u_xlat3.xy = vs_TEXCOORD0.xy * _MainTexture_ST.xy + _MainTexture_ST.zw;
					    u_xlat3 = texture(_MainTexture, u_xlat3.xy);
					    u_xlat3.xyz = _Color.xyz * u_xlat3.xyz + vec3(vec3(_Shadows, _Shadows, _Shadows));
					    u_xlat3.xyz = u_xlat3.xyz + vec3(-1.0, -1.0, -1.0);
					    u_xlat3.xyz = clamp(u_xlat3.xyz, 0.0, 1.0);
					    u_xlat4.xyz = u_xlat3.xyz + vec3(-0.220916301, -0.220916301, -0.220916301);
					    u_xlat5.xy = vs_TEXCOORD0.xy * _Specular_ST.xy + _Specular_ST.zw;
					    u_xlat5 = texture(_Specular, u_xlat5.xy);
					    u_xlat1.x = u_xlat5.x * 0.449999988;
					    u_xlat20 = (-u_xlat5.x) * 0.350587666 + 0.779083729;
					    u_xlat3.xyz = vec3(u_xlat20) * u_xlat3.xyz;
					    u_xlat4.xyz = u_xlat1.xxx * u_xlat4.xyz + vec3(0.220916301, 0.220916301, 0.220916301);
					    u_xlat5.xyz = (-u_xlat4.xyz) + vec3(1.0, 1.0, 1.0);
					    u_xlat4.xyz = u_xlat5.xyz * vec3(u_xlat18) + u_xlat4.xyz;
					    u_xlat2.xyz = u_xlat2.xyz * u_xlat4.xyz;
					    u_xlat18 = u_xlat0.x * u_xlat0.x;
					    u_xlat18 = u_xlat18 * u_xlat18;
					    u_xlat0.x = u_xlat18 * u_xlat0.x;
					    u_xlat18 = u_xlat0.z + u_xlat0.z;
					    u_xlat12 = u_xlat18 * u_xlat0.z + -0.5;
					    u_xlat0.x = u_xlat12 * u_xlat0.x + 1.0;
					    u_xlat18 = (-u_xlat0.y) + 1.00001001;
					    u_xlat1.x = u_xlat18 * u_xlat18;
					    u_xlat1.x = u_xlat1.x * u_xlat1.x;
					    u_xlat18 = u_xlat18 * u_xlat1.x;
					    u_xlat12 = u_xlat12 * u_xlat18 + 1.0;
					    u_xlat0.x = u_xlat0.x * u_xlat12;
					    u_xlat0.x = u_xlat0.y * u_xlat0.x;
					    u_xlat0.xyz = u_xlat7.xyz * u_xlat0.xxx;
					    SV_Target0.xyz = u_xlat0.xyz * u_xlat3.xyz + u_xlat2.xyz;
					    SV_Target0.w = 0.0;
					    return;
					}"
				}
				SubProgram "d3d11 " {
					Keywords { "POINT_COOKIE" "SHADOWS_CUBE" "SHADOWS_SOFT" "DIRLIGHTMAP_SEPARATE" "LIGHTMAP_OFF" "DYNAMICLIGHTMAP_OFF" }
					"ps_4_0
					
					#version 330
					#extension GL_ARB_explicit_attrib_location : require
					#extension GL_ARB_explicit_uniform_location : require
					
					#define HLSLCC_ENABLE_UNIFORM_BUFFERS 1
					#if HLSLCC_ENABLE_UNIFORM_BUFFERS
					#define UNITY_UNIFORM
					#else
					#define UNITY_UNIFORM uniform
					#endif
					#define UNITY_SUPPORTS_UNIFORM_LOCATION 1
					#if UNITY_SUPPORTS_UNIFORM_LOCATION
					#define UNITY_LOCATION(x) layout(location = x)
					#define UNITY_BINDING(x) layout(binding = x, std140)
					#else
					#define UNITY_LOCATION(x)
					#define UNITY_BINDING(x) layout(std140)
					#endif
					layout(std140) uniform PGlobals {
						vec4 unused_0_0[6];
						vec4 _LightColor0;
						vec4 unused_0_2;
						vec4 _MainTexture_ST;
						vec4 _Specular_ST;
						vec4 _NormalMap_ST;
						vec4 _Color;
						vec4 unused_0_7;
						float _NormalSharpness;
						float _Shadows;
					};
					layout(std140) uniform UnityPerCamera {
						vec4 unused_1_0[4];
						vec3 _WorldSpaceCameraPos;
						vec4 unused_1_2[4];
					};
					layout(std140) uniform UnityLighting {
						vec4 _WorldSpaceLightPos0;
						vec4 unused_2_1;
						vec4 _LightProjectionParams;
						vec4 unused_2_3[45];
					};
					layout(std140) uniform UnityShadows {
						vec4 unused_3_0[24];
						vec4 _LightShadowData;
						vec4 unused_3_2;
					};
					uniform  sampler2D _NormalMap;
					uniform  sampler2D _LightTextureB0;
					uniform  samplerCube _LightTexture0;
					uniform  sampler2D _MainTexture;
					uniform  sampler2D _Specular;
					uniform  samplerCube _ShadowMapTexture;
					uniform  samplerCubeShadow hlslcc_zcmp_ShadowMapTexture;
					in  vec2 vs_TEXCOORD0;
					in  vec4 vs_TEXCOORD3;
					in  vec3 vs_TEXCOORD4;
					in  vec3 vs_TEXCOORD5;
					in  vec3 vs_TEXCOORD6;
					in  vec3 vs_TEXCOORD7;
					in  vec3 vs_TEXCOORD8;
					layout(location = 0) out vec4 SV_Target0;
					vec4 u_xlat0;
					vec4 u_xlat1;
					int u_xlati1;
					vec4 u_xlat2;
					vec4 u_xlat3;
					vec3 u_xlat4;
					vec4 u_xlat5;
					vec3 u_xlat7;
					int u_xlati7;
					float u_xlat12;
					float u_xlat13;
					float u_xlat18;
					float u_xlat19;
					float u_xlat20;
					void main()
					{
					    u_xlat0.xy = vs_TEXCOORD0.xy * _NormalMap_ST.xy + _NormalMap_ST.zw;
					    u_xlat0 = texture(_NormalMap, u_xlat0.xy);
					    u_xlat0.x = u_xlat0.w * u_xlat0.x;
					    u_xlat0.xy = u_xlat0.xy * vec2(2.0, 2.0) + vec2(-1.0, -1.0);
					    u_xlat18 = dot(u_xlat0.xy, u_xlat0.xy);
					    u_xlat18 = min(u_xlat18, 1.0);
					    u_xlat18 = (-u_xlat18) + 1.0;
					    u_xlat0.z = sqrt(u_xlat18);
					    u_xlat18 = (-_NormalSharpness) + 1.0;
					    u_xlat0.xyz = u_xlat0.xyz / vec3(u_xlat18);
					    u_xlat0.xyz = clamp(u_xlat0.xyz, 0.0, 1.0);
					    u_xlat1.xyz = u_xlat0.yyy * vs_TEXCOORD6.xyz;
					    u_xlat0.xyw = u_xlat0.xxx * vs_TEXCOORD5.xyz + u_xlat1.xyz;
					    u_xlat1.x = dot(vs_TEXCOORD4.xyz, vs_TEXCOORD4.xyz);
					    u_xlat1.x = inversesqrt(u_xlat1.x);
					    u_xlat1.xyz = u_xlat1.xxx * vs_TEXCOORD4.xyz;
					    u_xlat0.xyz = u_xlat0.zzz * u_xlat1.xyz + u_xlat0.xyw;
					    u_xlat18 = dot(u_xlat0.xyz, u_xlat0.xyz);
					    u_xlat18 = inversesqrt(u_xlat18);
					    u_xlat0.xyz = vec3(u_xlat18) * u_xlat0.xyz;
					    u_xlat2.xyz = (-vs_TEXCOORD3.xyz) + _WorldSpaceCameraPos.xyz;
					    u_xlat18 = dot(u_xlat2.xyz, u_xlat2.xyz);
					    u_xlat18 = inversesqrt(u_xlat18);
					    u_xlat3.xyz = vec3(u_xlat18) * u_xlat2.xyz;
					    u_xlat1.x = dot(u_xlat3.xyz, u_xlat1.xyz);
					    u_xlati7 = int((0.0<u_xlat1.x) ? 0xFFFFFFFFu : uint(0));
					    u_xlati1 = int((u_xlat1.x<0.0) ? 0xFFFFFFFFu : uint(0));
					    u_xlati1 = (-u_xlati7) + u_xlati1;
					    u_xlat1.x = float(u_xlati1);
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xxx;
					    u_xlat1.xyz = _WorldSpaceLightPos0.www * (-vs_TEXCOORD3.xyz) + _WorldSpaceLightPos0.xyz;
					    u_xlat19 = dot(u_xlat1.xyz, u_xlat1.xyz);
					    u_xlat19 = inversesqrt(u_xlat19);
					    u_xlat1.xyz = vec3(u_xlat19) * u_xlat1.xyz;
					    u_xlat2.xyz = u_xlat2.xyz * vec3(u_xlat18) + u_xlat1.xyz;
					    u_xlat18 = dot(u_xlat2.xyz, u_xlat2.xyz);
					    u_xlat18 = inversesqrt(u_xlat18);
					    u_xlat2.xyz = vec3(u_xlat18) * u_xlat2.xyz;
					    u_xlat0.w = dot(u_xlat0.xyz, u_xlat2.xyz);
					    u_xlat1.w = dot(u_xlat1.xyz, u_xlat2.xyz);
					    u_xlat1.x = dot(u_xlat0.xyz, u_xlat1.xyz);
					    u_xlat0.x = dot(u_xlat0.xyz, u_xlat3.xyz);
					    u_xlat0.yz = max(u_xlat1.xw, vec2(0.0, 0.0));
					    u_xlat0.xw = max(u_xlat0.xw, vec2(0.0, 0.0));
					    u_xlat1.x = log2(u_xlat0.w);
					    u_xlat18 = u_xlat0.w * u_xlat0.w;
					    u_xlat1.x = u_xlat1.x * 9.99999975e-05;
					    u_xlat1.x = exp2(u_xlat1.x);
					    u_xlat7.x = u_xlat0.x * 0.202115417 + 0.797884583;
					    u_xlat13 = u_xlat0.y * 0.202115417 + 0.797884583;
					    u_xlat7.x = u_xlat13 * u_xlat7.x + 9.99999975e-06;
					    u_xlat1.y = float(1.0) / u_xlat7.x;
					    u_xlat1.xy = u_xlat1.xy * vec2(0.318325758, 0.25);
					    u_xlat7.x = u_xlat0.y * u_xlat1.y;
					    u_xlat1.x = u_xlat1.x * u_xlat7.x;
					    u_xlat1.x = u_xlat1.x * 0.616850257;
					    u_xlat7.x = max(abs(vs_TEXCOORD8.y), abs(vs_TEXCOORD8.x));
					    u_xlat7.x = max(u_xlat7.x, abs(vs_TEXCOORD8.z));
					    u_xlat7.x = u_xlat7.x + (-_LightProjectionParams.z);
					    u_xlat7.x = max(u_xlat7.x, 9.99999975e-06);
					    u_xlat7.x = u_xlat7.x * _LightProjectionParams.w;
					    u_xlat7.x = _LightProjectionParams.y / u_xlat7.x;
					    u_xlat7.x = u_xlat7.x + (-_LightProjectionParams.x);
					    u_xlat7.x = (-u_xlat7.x) + 1.0;
					    u_xlat2.xyz = vs_TEXCOORD8.xyz + vec3(0.0078125, 0.0078125, 0.0078125);
					    vec4 txVec0 = vec4(u_xlat2.xyz,u_xlat7.x);
					    u_xlat2.x = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec0, 0.0);
					    u_xlat3.xyz = vs_TEXCOORD8.xyz + vec3(-0.0078125, -0.0078125, 0.0078125);
					    vec4 txVec1 = vec4(u_xlat3.xyz,u_xlat7.x);
					    u_xlat2.y = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec1, 0.0);
					    u_xlat3.xyz = vs_TEXCOORD8.xyz + vec3(-0.0078125, 0.0078125, -0.0078125);
					    vec4 txVec2 = vec4(u_xlat3.xyz,u_xlat7.x);
					    u_xlat2.z = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec2, 0.0);
					    u_xlat3.xyz = vs_TEXCOORD8.xyz + vec3(0.0078125, -0.0078125, -0.0078125);
					    vec4 txVec3 = vec4(u_xlat3.xyz,u_xlat7.x);
					    u_xlat2.w = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec3, 0.0);
					    u_xlat7.x = dot(u_xlat2, vec4(0.25, 0.25, 0.25, 0.25));
					    u_xlat13 = (-_LightShadowData.x) + 1.0;
					    u_xlat7.x = u_xlat7.x * u_xlat13 + _LightShadowData.x;
					    u_xlat13 = dot(vs_TEXCOORD7.xyz, vs_TEXCOORD7.xyz);
					    u_xlat2 = texture(_LightTextureB0, vec2(u_xlat13));
					    u_xlat3 = texture(_LightTexture0, vs_TEXCOORD7.xyz);
					    u_xlat13 = u_xlat2.x * u_xlat3.w;
					    u_xlat7.x = u_xlat7.x * u_xlat13;
					    u_xlat7.xyz = u_xlat7.xxx * _LightColor0.xyz;
					    u_xlat2.xyz = vec3(u_xlat18) * u_xlat7.xyz;
					    u_xlat2.xyz = u_xlat1.xxx * u_xlat2.xyz;
					    u_xlat2.xyz = u_xlat2.xyz * _LightColor0.xyz;
					    u_xlat0.xw = (-u_xlat0.xz) + vec2(1.00001001, 1.0);
					    u_xlat1.x = u_xlat0.w * u_xlat0.w;
					    u_xlat1.x = u_xlat1.x * u_xlat1.x;
					    u_xlat18 = u_xlat0.w * u_xlat1.x;
					    u_xlat3.xy = vs_TEXCOORD0.xy * _MainTexture_ST.xy + _MainTexture_ST.zw;
					    u_xlat3 = texture(_MainTexture, u_xlat3.xy);
					    u_xlat3.xyz = _Color.xyz * u_xlat3.xyz + vec3(vec3(_Shadows, _Shadows, _Shadows));
					    u_xlat3.xyz = u_xlat3.xyz + vec3(-1.0, -1.0, -1.0);
					    u_xlat3.xyz = clamp(u_xlat3.xyz, 0.0, 1.0);
					    u_xlat4.xyz = u_xlat3.xyz + vec3(-0.220916301, -0.220916301, -0.220916301);
					    u_xlat5.xy = vs_TEXCOORD0.xy * _Specular_ST.xy + _Specular_ST.zw;
					    u_xlat5 = texture(_Specular, u_xlat5.xy);
					    u_xlat1.x = u_xlat5.x * 0.449999988;
					    u_xlat20 = (-u_xlat5.x) * 0.350587666 + 0.779083729;
					    u_xlat3.xyz = vec3(u_xlat20) * u_xlat3.xyz;
					    u_xlat4.xyz = u_xlat1.xxx * u_xlat4.xyz + vec3(0.220916301, 0.220916301, 0.220916301);
					    u_xlat5.xyz = (-u_xlat4.xyz) + vec3(1.0, 1.0, 1.0);
					    u_xlat4.xyz = u_xlat5.xyz * vec3(u_xlat18) + u_xlat4.xyz;
					    u_xlat2.xyz = u_xlat2.xyz * u_xlat4.xyz;
					    u_xlat18 = u_xlat0.x * u_xlat0.x;
					    u_xlat18 = u_xlat18 * u_xlat18;
					    u_xlat0.x = u_xlat18 * u_xlat0.x;
					    u_xlat18 = u_xlat0.z + u_xlat0.z;
					    u_xlat12 = u_xlat18 * u_xlat0.z + -0.5;
					    u_xlat0.x = u_xlat12 * u_xlat0.x + 1.0;
					    u_xlat18 = (-u_xlat0.y) + 1.00001001;
					    u_xlat1.x = u_xlat18 * u_xlat18;
					    u_xlat1.x = u_xlat1.x * u_xlat1.x;
					    u_xlat18 = u_xlat18 * u_xlat1.x;
					    u_xlat12 = u_xlat12 * u_xlat18 + 1.0;
					    u_xlat0.x = u_xlat0.x * u_xlat12;
					    u_xlat0.x = u_xlat0.y * u_xlat0.x;
					    u_xlat0.xyz = u_xlat7.xyz * u_xlat0.xxx;
					    SV_Target0.xyz = u_xlat0.xyz * u_xlat3.xyz + u_xlat2.xyz;
					    SV_Target0.w = 0.0;
					    return;
					}"
				}
			}
		}
		Pass {
			Name "ShadowCaster"
			LOD 2
			Tags { "LIGHTMODE" = "SHADOWCASTER" "RenderType" = "Opaque" "SHADOWSUPPORT" = "true" }
			Offset 1, 1
			GpuProgramID 157901
			Program "vp" {
				SubProgram "d3d11 " {
					Keywords { "SHADOWS_DEPTH" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "DYNAMICLIGHTMAP_OFF" }
					"vs_4_0
					
					#version 330
					#extension GL_ARB_explicit_attrib_location : require
					#extension GL_ARB_explicit_uniform_location : require
					
					#define HLSLCC_ENABLE_UNIFORM_BUFFERS 1
					#if HLSLCC_ENABLE_UNIFORM_BUFFERS
					#define UNITY_UNIFORM
					#else
					#define UNITY_UNIFORM uniform
					#endif
					#define UNITY_SUPPORTS_UNIFORM_LOCATION 1
					#if UNITY_SUPPORTS_UNIFORM_LOCATION
					#define UNITY_LOCATION(x) layout(location = x)
					#define UNITY_BINDING(x) layout(binding = x, std140)
					#else
					#define UNITY_LOCATION(x)
					#define UNITY_BINDING(x) layout(std140)
					#endif
					layout(std140) uniform VGlobals {
						vec4 unused_0_0[4];
						vec4 _MainTexture_ST;
						vec4 _Color;
						vec4 _Heightmap_ST;
						float _Bumpiness;
						float _BumpAttune;
					};
					layout(std140) uniform UnityShadows {
						vec4 unused_1_0[5];
						vec4 unity_LightShadowBias;
						vec4 unused_1_2[20];
					};
					layout(std140) uniform UnityPerDraw {
						mat4x4 unity_ObjectToWorld;
						mat4x4 unity_WorldToObject;
						vec4 unused_2_2[2];
					};
					layout(std140) uniform UnityPerFrame {
						vec4 unused_3_0[17];
						mat4x4 unity_MatrixVP;
						vec4 unused_3_2[2];
					};
					uniform  sampler2D _Heightmap;
					uniform  sampler2D _MainTexture;
					in  vec4 in_POSITION0;
					in  vec3 in_NORMAL0;
					in  vec2 in_TEXCOORD0;
					in  vec2 in_TEXCOORD1;
					in  vec2 in_TEXCOORD2;
					out vec2 vs_TEXCOORD1;
					out vec2 vs_TEXCOORD2;
					out vec2 vs_TEXCOORD3;
					out vec4 vs_TEXCOORD4;
					out vec3 vs_TEXCOORD5;
					vec4 u_xlat0;
					vec4 u_xlat1;
					vec4 u_xlat2;
					vec3 u_xlat3;
					float u_xlat8;
					float u_xlat12;
					void main()
					{
					    u_xlat0.xy = in_TEXCOORD0.xy * _MainTexture_ST.xy + _MainTexture_ST.zw;
					    u_xlat0 = textureLod(_MainTexture, u_xlat0.xy, 0.0);
					    u_xlat0.xyz = u_xlat0.xyz * _Color.xyz;
					    u_xlat1.xyz = u_xlat0.xyz * vec3(-1.0, -1.0, 1.0);
					    u_xlat2.xy = in_TEXCOORD0.xy * _Heightmap_ST.xy + _Heightmap_ST.zw;
					    u_xlat2 = textureLod(_Heightmap, u_xlat2.xy, 0.0);
					    u_xlat2.xyz = u_xlat2.xyz * vec3(_Bumpiness);
					    u_xlat2.xyz = clamp(u_xlat2.xyz, 0.0, 1.0);
					    u_xlat3.xyz = u_xlat2.xyz + vec3(0.0, 0.0, 1.0);
					    u_xlat2.xyz = u_xlat2.xyz * in_NORMAL0.xyz;
					    u_xlat12 = dot(u_xlat3.xyz, u_xlat1.xyz);
					    u_xlat1.xyz = vec3(u_xlat12) * u_xlat3.xyz;
					    u_xlat1.xyz = u_xlat1.xyz / u_xlat3.zzz;
					    u_xlat0.xyz = (-u_xlat0.xyz) * vec3(-1.0, -1.0, 1.0) + u_xlat1.xyz;
					    u_xlat0.x = dot(u_xlat0.xyz, vec3(0.300000012, 0.589999974, 0.109999999));
					    u_xlat0.xyz = u_xlat2.xyz * u_xlat0.xxx + (-u_xlat2.xyz);
					    u_xlat0.xyz = vec3(vec3(_BumpAttune, _BumpAttune, _BumpAttune)) * u_xlat0.xyz + u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz + in_POSITION0.xyz;
					    u_xlat1 = u_xlat0.yyyy * unity_ObjectToWorld[1];
					    u_xlat1 = unity_ObjectToWorld[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat0 = unity_ObjectToWorld[2] * u_xlat0.zzzz + u_xlat1;
					    u_xlat1 = u_xlat0 + unity_ObjectToWorld[3];
					    vs_TEXCOORD4 = unity_ObjectToWorld[3] * in_POSITION0.wwww + u_xlat0;
					    u_xlat0 = u_xlat1.yyyy * unity_MatrixVP[1];
					    u_xlat0 = unity_MatrixVP[0] * u_xlat1.xxxx + u_xlat0;
					    u_xlat0 = unity_MatrixVP[2] * u_xlat1.zzzz + u_xlat0;
					    u_xlat0 = unity_MatrixVP[3] * u_xlat1.wwww + u_xlat0;
					    u_xlat1.x = unity_LightShadowBias.x / u_xlat0.w;
					    u_xlat1.x = min(u_xlat1.x, 0.0);
					    u_xlat1.x = max(u_xlat1.x, -1.0);
					    u_xlat8 = u_xlat0.z + u_xlat1.x;
					    u_xlat1.x = min(u_xlat0.w, u_xlat8);
					    gl_Position.xyw = u_xlat0.xyw;
					    u_xlat0.x = (-u_xlat8) + u_xlat1.x;
					    gl_Position.z = unity_LightShadowBias.y * u_xlat0.x + u_xlat8;
					    vs_TEXCOORD1.xy = in_TEXCOORD0.xy;
					    vs_TEXCOORD2.xy = in_TEXCOORD1.xy;
					    vs_TEXCOORD3.xy = in_TEXCOORD2.xy;
					    u_xlat0.x = dot(in_NORMAL0.xyz, unity_WorldToObject[0].xyz);
					    u_xlat0.y = dot(in_NORMAL0.xyz, unity_WorldToObject[1].xyz);
					    u_xlat0.z = dot(in_NORMAL0.xyz, unity_WorldToObject[2].xyz);
					    u_xlat12 = dot(u_xlat0.xyz, u_xlat0.xyz);
					    u_xlat12 = inversesqrt(u_xlat12);
					    vs_TEXCOORD5.xyz = vec3(u_xlat12) * u_xlat0.xyz;
					    return;
					}"
				}
				SubProgram "d3d11 " {
					Keywords { "SHADOWS_CUBE" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "DYNAMICLIGHTMAP_OFF" }
					"vs_4_0
					
					#version 330
					#extension GL_ARB_explicit_attrib_location : require
					#extension GL_ARB_explicit_uniform_location : require
					
					#define HLSLCC_ENABLE_UNIFORM_BUFFERS 1
					#if HLSLCC_ENABLE_UNIFORM_BUFFERS
					#define UNITY_UNIFORM
					#else
					#define UNITY_UNIFORM uniform
					#endif
					#define UNITY_SUPPORTS_UNIFORM_LOCATION 1
					#if UNITY_SUPPORTS_UNIFORM_LOCATION
					#define UNITY_LOCATION(x) layout(location = x)
					#define UNITY_BINDING(x) layout(binding = x, std140)
					#else
					#define UNITY_LOCATION(x)
					#define UNITY_BINDING(x) layout(std140)
					#endif
					layout(std140) uniform VGlobals {
						vec4 unused_0_0[4];
						vec4 _MainTexture_ST;
						vec4 _Color;
						vec4 _Heightmap_ST;
						float _Bumpiness;
						float _BumpAttune;
					};
					layout(std140) uniform UnityShadows {
						vec4 unused_1_0[5];
						vec4 unity_LightShadowBias;
						vec4 unused_1_2[20];
					};
					layout(std140) uniform UnityPerDraw {
						mat4x4 unity_ObjectToWorld;
						mat4x4 unity_WorldToObject;
						vec4 unused_2_2[2];
					};
					layout(std140) uniform UnityPerFrame {
						vec4 unused_3_0[17];
						mat4x4 unity_MatrixVP;
						vec4 unused_3_2[2];
					};
					uniform  sampler2D _Heightmap;
					uniform  sampler2D _MainTexture;
					in  vec4 in_POSITION0;
					in  vec3 in_NORMAL0;
					in  vec2 in_TEXCOORD0;
					in  vec2 in_TEXCOORD1;
					in  vec2 in_TEXCOORD2;
					out vec2 vs_TEXCOORD1;
					out vec2 vs_TEXCOORD2;
					out vec2 vs_TEXCOORD3;
					out vec4 vs_TEXCOORD4;
					out vec3 vs_TEXCOORD5;
					vec4 u_xlat0;
					vec4 u_xlat1;
					vec4 u_xlat2;
					vec3 u_xlat3;
					float u_xlat12;
					void main()
					{
					    u_xlat0.xy = in_TEXCOORD0.xy * _MainTexture_ST.xy + _MainTexture_ST.zw;
					    u_xlat0 = textureLod(_MainTexture, u_xlat0.xy, 0.0);
					    u_xlat0.xyz = u_xlat0.xyz * _Color.xyz;
					    u_xlat1.xyz = u_xlat0.xyz * vec3(-1.0, -1.0, 1.0);
					    u_xlat2.xy = in_TEXCOORD0.xy * _Heightmap_ST.xy + _Heightmap_ST.zw;
					    u_xlat2 = textureLod(_Heightmap, u_xlat2.xy, 0.0);
					    u_xlat2.xyz = u_xlat2.xyz * vec3(_Bumpiness);
					    u_xlat2.xyz = clamp(u_xlat2.xyz, 0.0, 1.0);
					    u_xlat3.xyz = u_xlat2.xyz + vec3(0.0, 0.0, 1.0);
					    u_xlat2.xyz = u_xlat2.xyz * in_NORMAL0.xyz;
					    u_xlat12 = dot(u_xlat3.xyz, u_xlat1.xyz);
					    u_xlat1.xyz = vec3(u_xlat12) * u_xlat3.xyz;
					    u_xlat1.xyz = u_xlat1.xyz / u_xlat3.zzz;
					    u_xlat0.xyz = (-u_xlat0.xyz) * vec3(-1.0, -1.0, 1.0) + u_xlat1.xyz;
					    u_xlat0.x = dot(u_xlat0.xyz, vec3(0.300000012, 0.589999974, 0.109999999));
					    u_xlat0.xyz = u_xlat2.xyz * u_xlat0.xxx + (-u_xlat2.xyz);
					    u_xlat0.xyz = vec3(vec3(_BumpAttune, _BumpAttune, _BumpAttune)) * u_xlat0.xyz + u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz + in_POSITION0.xyz;
					    u_xlat1 = u_xlat0.yyyy * unity_ObjectToWorld[1];
					    u_xlat1 = unity_ObjectToWorld[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat0 = unity_ObjectToWorld[2] * u_xlat0.zzzz + u_xlat1;
					    u_xlat1 = u_xlat0 + unity_ObjectToWorld[3];
					    vs_TEXCOORD4 = unity_ObjectToWorld[3] * in_POSITION0.wwww + u_xlat0;
					    u_xlat0 = u_xlat1.yyyy * unity_MatrixVP[1];
					    u_xlat0 = unity_MatrixVP[0] * u_xlat1.xxxx + u_xlat0;
					    u_xlat0 = unity_MatrixVP[2] * u_xlat1.zzzz + u_xlat0;
					    u_xlat0 = unity_MatrixVP[3] * u_xlat1.wwww + u_xlat0;
					    u_xlat1.x = min(u_xlat0.w, u_xlat0.z);
					    u_xlat1.x = (-u_xlat0.z) + u_xlat1.x;
					    gl_Position.z = unity_LightShadowBias.y * u_xlat1.x + u_xlat0.z;
					    gl_Position.xyw = u_xlat0.xyw;
					    vs_TEXCOORD1.xy = in_TEXCOORD0.xy;
					    vs_TEXCOORD2.xy = in_TEXCOORD1.xy;
					    vs_TEXCOORD3.xy = in_TEXCOORD2.xy;
					    u_xlat0.x = dot(in_NORMAL0.xyz, unity_WorldToObject[0].xyz);
					    u_xlat0.y = dot(in_NORMAL0.xyz, unity_WorldToObject[1].xyz);
					    u_xlat0.z = dot(in_NORMAL0.xyz, unity_WorldToObject[2].xyz);
					    u_xlat12 = dot(u_xlat0.xyz, u_xlat0.xyz);
					    u_xlat12 = inversesqrt(u_xlat12);
					    vs_TEXCOORD5.xyz = vec3(u_xlat12) * u_xlat0.xyz;
					    return;
					}"
				}
				SubProgram "d3d11 " {
					Keywords { "SHADOWS_DEPTH" "DIRLIGHTMAP_COMBINED" "LIGHTMAP_OFF" "DYNAMICLIGHTMAP_OFF" }
					"vs_4_0
					
					#version 330
					#extension GL_ARB_explicit_attrib_location : require
					#extension GL_ARB_explicit_uniform_location : require
					
					#define HLSLCC_ENABLE_UNIFORM_BUFFERS 1
					#if HLSLCC_ENABLE_UNIFORM_BUFFERS
					#define UNITY_UNIFORM
					#else
					#define UNITY_UNIFORM uniform
					#endif
					#define UNITY_SUPPORTS_UNIFORM_LOCATION 1
					#if UNITY_SUPPORTS_UNIFORM_LOCATION
					#define UNITY_LOCATION(x) layout(location = x)
					#define UNITY_BINDING(x) layout(binding = x, std140)
					#else
					#define UNITY_LOCATION(x)
					#define UNITY_BINDING(x) layout(std140)
					#endif
					layout(std140) uniform VGlobals {
						vec4 unused_0_0[4];
						vec4 _MainTexture_ST;
						vec4 _Color;
						vec4 _Heightmap_ST;
						float _Bumpiness;
						float _BumpAttune;
					};
					layout(std140) uniform UnityShadows {
						vec4 unused_1_0[5];
						vec4 unity_LightShadowBias;
						vec4 unused_1_2[20];
					};
					layout(std140) uniform UnityPerDraw {
						mat4x4 unity_ObjectToWorld;
						mat4x4 unity_WorldToObject;
						vec4 unused_2_2[2];
					};
					layout(std140) uniform UnityPerFrame {
						vec4 unused_3_0[17];
						mat4x4 unity_MatrixVP;
						vec4 unused_3_2[2];
					};
					uniform  sampler2D _Heightmap;
					uniform  sampler2D _MainTexture;
					in  vec4 in_POSITION0;
					in  vec3 in_NORMAL0;
					in  vec2 in_TEXCOORD0;
					in  vec2 in_TEXCOORD1;
					in  vec2 in_TEXCOORD2;
					out vec2 vs_TEXCOORD1;
					out vec2 vs_TEXCOORD2;
					out vec2 vs_TEXCOORD3;
					out vec4 vs_TEXCOORD4;
					out vec3 vs_TEXCOORD5;
					vec4 u_xlat0;
					vec4 u_xlat1;
					vec4 u_xlat2;
					vec3 u_xlat3;
					float u_xlat8;
					float u_xlat12;
					void main()
					{
					    u_xlat0.xy = in_TEXCOORD0.xy * _MainTexture_ST.xy + _MainTexture_ST.zw;
					    u_xlat0 = textureLod(_MainTexture, u_xlat0.xy, 0.0);
					    u_xlat0.xyz = u_xlat0.xyz * _Color.xyz;
					    u_xlat1.xyz = u_xlat0.xyz * vec3(-1.0, -1.0, 1.0);
					    u_xlat2.xy = in_TEXCOORD0.xy * _Heightmap_ST.xy + _Heightmap_ST.zw;
					    u_xlat2 = textureLod(_Heightmap, u_xlat2.xy, 0.0);
					    u_xlat2.xyz = u_xlat2.xyz * vec3(_Bumpiness);
					    u_xlat2.xyz = clamp(u_xlat2.xyz, 0.0, 1.0);
					    u_xlat3.xyz = u_xlat2.xyz + vec3(0.0, 0.0, 1.0);
					    u_xlat2.xyz = u_xlat2.xyz * in_NORMAL0.xyz;
					    u_xlat12 = dot(u_xlat3.xyz, u_xlat1.xyz);
					    u_xlat1.xyz = vec3(u_xlat12) * u_xlat3.xyz;
					    u_xlat1.xyz = u_xlat1.xyz / u_xlat3.zzz;
					    u_xlat0.xyz = (-u_xlat0.xyz) * vec3(-1.0, -1.0, 1.0) + u_xlat1.xyz;
					    u_xlat0.x = dot(u_xlat0.xyz, vec3(0.300000012, 0.589999974, 0.109999999));
					    u_xlat0.xyz = u_xlat2.xyz * u_xlat0.xxx + (-u_xlat2.xyz);
					    u_xlat0.xyz = vec3(vec3(_BumpAttune, _BumpAttune, _BumpAttune)) * u_xlat0.xyz + u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz + in_POSITION0.xyz;
					    u_xlat1 = u_xlat0.yyyy * unity_ObjectToWorld[1];
					    u_xlat1 = unity_ObjectToWorld[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat0 = unity_ObjectToWorld[2] * u_xlat0.zzzz + u_xlat1;
					    u_xlat1 = u_xlat0 + unity_ObjectToWorld[3];
					    vs_TEXCOORD4 = unity_ObjectToWorld[3] * in_POSITION0.wwww + u_xlat0;
					    u_xlat0 = u_xlat1.yyyy * unity_MatrixVP[1];
					    u_xlat0 = unity_MatrixVP[0] * u_xlat1.xxxx + u_xlat0;
					    u_xlat0 = unity_MatrixVP[2] * u_xlat1.zzzz + u_xlat0;
					    u_xlat0 = unity_MatrixVP[3] * u_xlat1.wwww + u_xlat0;
					    u_xlat1.x = unity_LightShadowBias.x / u_xlat0.w;
					    u_xlat1.x = min(u_xlat1.x, 0.0);
					    u_xlat1.x = max(u_xlat1.x, -1.0);
					    u_xlat8 = u_xlat0.z + u_xlat1.x;
					    u_xlat1.x = min(u_xlat0.w, u_xlat8);
					    gl_Position.xyw = u_xlat0.xyw;
					    u_xlat0.x = (-u_xlat8) + u_xlat1.x;
					    gl_Position.z = unity_LightShadowBias.y * u_xlat0.x + u_xlat8;
					    vs_TEXCOORD1.xy = in_TEXCOORD0.xy;
					    vs_TEXCOORD2.xy = in_TEXCOORD1.xy;
					    vs_TEXCOORD3.xy = in_TEXCOORD2.xy;
					    u_xlat0.x = dot(in_NORMAL0.xyz, unity_WorldToObject[0].xyz);
					    u_xlat0.y = dot(in_NORMAL0.xyz, unity_WorldToObject[1].xyz);
					    u_xlat0.z = dot(in_NORMAL0.xyz, unity_WorldToObject[2].xyz);
					    u_xlat12 = dot(u_xlat0.xyz, u_xlat0.xyz);
					    u_xlat12 = inversesqrt(u_xlat12);
					    vs_TEXCOORD5.xyz = vec3(u_xlat12) * u_xlat0.xyz;
					    return;
					}"
				}
				SubProgram "d3d11 " {
					Keywords { "SHADOWS_CUBE" "DIRLIGHTMAP_COMBINED" "LIGHTMAP_OFF" "DYNAMICLIGHTMAP_OFF" }
					"vs_4_0
					
					#version 330
					#extension GL_ARB_explicit_attrib_location : require
					#extension GL_ARB_explicit_uniform_location : require
					
					#define HLSLCC_ENABLE_UNIFORM_BUFFERS 1
					#if HLSLCC_ENABLE_UNIFORM_BUFFERS
					#define UNITY_UNIFORM
					#else
					#define UNITY_UNIFORM uniform
					#endif
					#define UNITY_SUPPORTS_UNIFORM_LOCATION 1
					#if UNITY_SUPPORTS_UNIFORM_LOCATION
					#define UNITY_LOCATION(x) layout(location = x)
					#define UNITY_BINDING(x) layout(binding = x, std140)
					#else
					#define UNITY_LOCATION(x)
					#define UNITY_BINDING(x) layout(std140)
					#endif
					layout(std140) uniform VGlobals {
						vec4 unused_0_0[4];
						vec4 _MainTexture_ST;
						vec4 _Color;
						vec4 _Heightmap_ST;
						float _Bumpiness;
						float _BumpAttune;
					};
					layout(std140) uniform UnityShadows {
						vec4 unused_1_0[5];
						vec4 unity_LightShadowBias;
						vec4 unused_1_2[20];
					};
					layout(std140) uniform UnityPerDraw {
						mat4x4 unity_ObjectToWorld;
						mat4x4 unity_WorldToObject;
						vec4 unused_2_2[2];
					};
					layout(std140) uniform UnityPerFrame {
						vec4 unused_3_0[17];
						mat4x4 unity_MatrixVP;
						vec4 unused_3_2[2];
					};
					uniform  sampler2D _Heightmap;
					uniform  sampler2D _MainTexture;
					in  vec4 in_POSITION0;
					in  vec3 in_NORMAL0;
					in  vec2 in_TEXCOORD0;
					in  vec2 in_TEXCOORD1;
					in  vec2 in_TEXCOORD2;
					out vec2 vs_TEXCOORD1;
					out vec2 vs_TEXCOORD2;
					out vec2 vs_TEXCOORD3;
					out vec4 vs_TEXCOORD4;
					out vec3 vs_TEXCOORD5;
					vec4 u_xlat0;
					vec4 u_xlat1;
					vec4 u_xlat2;
					vec3 u_xlat3;
					float u_xlat12;
					void main()
					{
					    u_xlat0.xy = in_TEXCOORD0.xy * _MainTexture_ST.xy + _MainTexture_ST.zw;
					    u_xlat0 = textureLod(_MainTexture, u_xlat0.xy, 0.0);
					    u_xlat0.xyz = u_xlat0.xyz * _Color.xyz;
					    u_xlat1.xyz = u_xlat0.xyz * vec3(-1.0, -1.0, 1.0);
					    u_xlat2.xy = in_TEXCOORD0.xy * _Heightmap_ST.xy + _Heightmap_ST.zw;
					    u_xlat2 = textureLod(_Heightmap, u_xlat2.xy, 0.0);
					    u_xlat2.xyz = u_xlat2.xyz * vec3(_Bumpiness);
					    u_xlat2.xyz = clamp(u_xlat2.xyz, 0.0, 1.0);
					    u_xlat3.xyz = u_xlat2.xyz + vec3(0.0, 0.0, 1.0);
					    u_xlat2.xyz = u_xlat2.xyz * in_NORMAL0.xyz;
					    u_xlat12 = dot(u_xlat3.xyz, u_xlat1.xyz);
					    u_xlat1.xyz = vec3(u_xlat12) * u_xlat3.xyz;
					    u_xlat1.xyz = u_xlat1.xyz / u_xlat3.zzz;
					    u_xlat0.xyz = (-u_xlat0.xyz) * vec3(-1.0, -1.0, 1.0) + u_xlat1.xyz;
					    u_xlat0.x = dot(u_xlat0.xyz, vec3(0.300000012, 0.589999974, 0.109999999));
					    u_xlat0.xyz = u_xlat2.xyz * u_xlat0.xxx + (-u_xlat2.xyz);
					    u_xlat0.xyz = vec3(vec3(_BumpAttune, _BumpAttune, _BumpAttune)) * u_xlat0.xyz + u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz + in_POSITION0.xyz;
					    u_xlat1 = u_xlat0.yyyy * unity_ObjectToWorld[1];
					    u_xlat1 = unity_ObjectToWorld[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat0 = unity_ObjectToWorld[2] * u_xlat0.zzzz + u_xlat1;
					    u_xlat1 = u_xlat0 + unity_ObjectToWorld[3];
					    vs_TEXCOORD4 = unity_ObjectToWorld[3] * in_POSITION0.wwww + u_xlat0;
					    u_xlat0 = u_xlat1.yyyy * unity_MatrixVP[1];
					    u_xlat0 = unity_MatrixVP[0] * u_xlat1.xxxx + u_xlat0;
					    u_xlat0 = unity_MatrixVP[2] * u_xlat1.zzzz + u_xlat0;
					    u_xlat0 = unity_MatrixVP[3] * u_xlat1.wwww + u_xlat0;
					    u_xlat1.x = min(u_xlat0.w, u_xlat0.z);
					    u_xlat1.x = (-u_xlat0.z) + u_xlat1.x;
					    gl_Position.z = unity_LightShadowBias.y * u_xlat1.x + u_xlat0.z;
					    gl_Position.xyw = u_xlat0.xyw;
					    vs_TEXCOORD1.xy = in_TEXCOORD0.xy;
					    vs_TEXCOORD2.xy = in_TEXCOORD1.xy;
					    vs_TEXCOORD3.xy = in_TEXCOORD2.xy;
					    u_xlat0.x = dot(in_NORMAL0.xyz, unity_WorldToObject[0].xyz);
					    u_xlat0.y = dot(in_NORMAL0.xyz, unity_WorldToObject[1].xyz);
					    u_xlat0.z = dot(in_NORMAL0.xyz, unity_WorldToObject[2].xyz);
					    u_xlat12 = dot(u_xlat0.xyz, u_xlat0.xyz);
					    u_xlat12 = inversesqrt(u_xlat12);
					    vs_TEXCOORD5.xyz = vec3(u_xlat12) * u_xlat0.xyz;
					    return;
					}"
				}
				SubProgram "d3d11 " {
					Keywords { "SHADOWS_DEPTH" "DIRLIGHTMAP_SEPARATE" "LIGHTMAP_OFF" "DYNAMICLIGHTMAP_OFF" }
					"vs_4_0
					
					#version 330
					#extension GL_ARB_explicit_attrib_location : require
					#extension GL_ARB_explicit_uniform_location : require
					
					#define HLSLCC_ENABLE_UNIFORM_BUFFERS 1
					#if HLSLCC_ENABLE_UNIFORM_BUFFERS
					#define UNITY_UNIFORM
					#else
					#define UNITY_UNIFORM uniform
					#endif
					#define UNITY_SUPPORTS_UNIFORM_LOCATION 1
					#if UNITY_SUPPORTS_UNIFORM_LOCATION
					#define UNITY_LOCATION(x) layout(location = x)
					#define UNITY_BINDING(x) layout(binding = x, std140)
					#else
					#define UNITY_LOCATION(x)
					#define UNITY_BINDING(x) layout(std140)
					#endif
					layout(std140) uniform VGlobals {
						vec4 unused_0_0[4];
						vec4 _MainTexture_ST;
						vec4 _Color;
						vec4 _Heightmap_ST;
						float _Bumpiness;
						float _BumpAttune;
					};
					layout(std140) uniform UnityShadows {
						vec4 unused_1_0[5];
						vec4 unity_LightShadowBias;
						vec4 unused_1_2[20];
					};
					layout(std140) uniform UnityPerDraw {
						mat4x4 unity_ObjectToWorld;
						mat4x4 unity_WorldToObject;
						vec4 unused_2_2[2];
					};
					layout(std140) uniform UnityPerFrame {
						vec4 unused_3_0[17];
						mat4x4 unity_MatrixVP;
						vec4 unused_3_2[2];
					};
					uniform  sampler2D _Heightmap;
					uniform  sampler2D _MainTexture;
					in  vec4 in_POSITION0;
					in  vec3 in_NORMAL0;
					in  vec2 in_TEXCOORD0;
					in  vec2 in_TEXCOORD1;
					in  vec2 in_TEXCOORD2;
					out vec2 vs_TEXCOORD1;
					out vec2 vs_TEXCOORD2;
					out vec2 vs_TEXCOORD3;
					out vec4 vs_TEXCOORD4;
					out vec3 vs_TEXCOORD5;
					vec4 u_xlat0;
					vec4 u_xlat1;
					vec4 u_xlat2;
					vec3 u_xlat3;
					float u_xlat8;
					float u_xlat12;
					void main()
					{
					    u_xlat0.xy = in_TEXCOORD0.xy * _MainTexture_ST.xy + _MainTexture_ST.zw;
					    u_xlat0 = textureLod(_MainTexture, u_xlat0.xy, 0.0);
					    u_xlat0.xyz = u_xlat0.xyz * _Color.xyz;
					    u_xlat1.xyz = u_xlat0.xyz * vec3(-1.0, -1.0, 1.0);
					    u_xlat2.xy = in_TEXCOORD0.xy * _Heightmap_ST.xy + _Heightmap_ST.zw;
					    u_xlat2 = textureLod(_Heightmap, u_xlat2.xy, 0.0);
					    u_xlat2.xyz = u_xlat2.xyz * vec3(_Bumpiness);
					    u_xlat2.xyz = clamp(u_xlat2.xyz, 0.0, 1.0);
					    u_xlat3.xyz = u_xlat2.xyz + vec3(0.0, 0.0, 1.0);
					    u_xlat2.xyz = u_xlat2.xyz * in_NORMAL0.xyz;
					    u_xlat12 = dot(u_xlat3.xyz, u_xlat1.xyz);
					    u_xlat1.xyz = vec3(u_xlat12) * u_xlat3.xyz;
					    u_xlat1.xyz = u_xlat1.xyz / u_xlat3.zzz;
					    u_xlat0.xyz = (-u_xlat0.xyz) * vec3(-1.0, -1.0, 1.0) + u_xlat1.xyz;
					    u_xlat0.x = dot(u_xlat0.xyz, vec3(0.300000012, 0.589999974, 0.109999999));
					    u_xlat0.xyz = u_xlat2.xyz * u_xlat0.xxx + (-u_xlat2.xyz);
					    u_xlat0.xyz = vec3(vec3(_BumpAttune, _BumpAttune, _BumpAttune)) * u_xlat0.xyz + u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz + in_POSITION0.xyz;
					    u_xlat1 = u_xlat0.yyyy * unity_ObjectToWorld[1];
					    u_xlat1 = unity_ObjectToWorld[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat0 = unity_ObjectToWorld[2] * u_xlat0.zzzz + u_xlat1;
					    u_xlat1 = u_xlat0 + unity_ObjectToWorld[3];
					    vs_TEXCOORD4 = unity_ObjectToWorld[3] * in_POSITION0.wwww + u_xlat0;
					    u_xlat0 = u_xlat1.yyyy * unity_MatrixVP[1];
					    u_xlat0 = unity_MatrixVP[0] * u_xlat1.xxxx + u_xlat0;
					    u_xlat0 = unity_MatrixVP[2] * u_xlat1.zzzz + u_xlat0;
					    u_xlat0 = unity_MatrixVP[3] * u_xlat1.wwww + u_xlat0;
					    u_xlat1.x = unity_LightShadowBias.x / u_xlat0.w;
					    u_xlat1.x = min(u_xlat1.x, 0.0);
					    u_xlat1.x = max(u_xlat1.x, -1.0);
					    u_xlat8 = u_xlat0.z + u_xlat1.x;
					    u_xlat1.x = min(u_xlat0.w, u_xlat8);
					    gl_Position.xyw = u_xlat0.xyw;
					    u_xlat0.x = (-u_xlat8) + u_xlat1.x;
					    gl_Position.z = unity_LightShadowBias.y * u_xlat0.x + u_xlat8;
					    vs_TEXCOORD1.xy = in_TEXCOORD0.xy;
					    vs_TEXCOORD2.xy = in_TEXCOORD1.xy;
					    vs_TEXCOORD3.xy = in_TEXCOORD2.xy;
					    u_xlat0.x = dot(in_NORMAL0.xyz, unity_WorldToObject[0].xyz);
					    u_xlat0.y = dot(in_NORMAL0.xyz, unity_WorldToObject[1].xyz);
					    u_xlat0.z = dot(in_NORMAL0.xyz, unity_WorldToObject[2].xyz);
					    u_xlat12 = dot(u_xlat0.xyz, u_xlat0.xyz);
					    u_xlat12 = inversesqrt(u_xlat12);
					    vs_TEXCOORD5.xyz = vec3(u_xlat12) * u_xlat0.xyz;
					    return;
					}"
				}
				SubProgram "d3d11 " {
					Keywords { "SHADOWS_CUBE" "DIRLIGHTMAP_SEPARATE" "LIGHTMAP_OFF" "DYNAMICLIGHTMAP_OFF" }
					"vs_4_0
					
					#version 330
					#extension GL_ARB_explicit_attrib_location : require
					#extension GL_ARB_explicit_uniform_location : require
					
					#define HLSLCC_ENABLE_UNIFORM_BUFFERS 1
					#if HLSLCC_ENABLE_UNIFORM_BUFFERS
					#define UNITY_UNIFORM
					#else
					#define UNITY_UNIFORM uniform
					#endif
					#define UNITY_SUPPORTS_UNIFORM_LOCATION 1
					#if UNITY_SUPPORTS_UNIFORM_LOCATION
					#define UNITY_LOCATION(x) layout(location = x)
					#define UNITY_BINDING(x) layout(binding = x, std140)
					#else
					#define UNITY_LOCATION(x)
					#define UNITY_BINDING(x) layout(std140)
					#endif
					layout(std140) uniform VGlobals {
						vec4 unused_0_0[4];
						vec4 _MainTexture_ST;
						vec4 _Color;
						vec4 _Heightmap_ST;
						float _Bumpiness;
						float _BumpAttune;
					};
					layout(std140) uniform UnityShadows {
						vec4 unused_1_0[5];
						vec4 unity_LightShadowBias;
						vec4 unused_1_2[20];
					};
					layout(std140) uniform UnityPerDraw {
						mat4x4 unity_ObjectToWorld;
						mat4x4 unity_WorldToObject;
						vec4 unused_2_2[2];
					};
					layout(std140) uniform UnityPerFrame {
						vec4 unused_3_0[17];
						mat4x4 unity_MatrixVP;
						vec4 unused_3_2[2];
					};
					uniform  sampler2D _Heightmap;
					uniform  sampler2D _MainTexture;
					in  vec4 in_POSITION0;
					in  vec3 in_NORMAL0;
					in  vec2 in_TEXCOORD0;
					in  vec2 in_TEXCOORD1;
					in  vec2 in_TEXCOORD2;
					out vec2 vs_TEXCOORD1;
					out vec2 vs_TEXCOORD2;
					out vec2 vs_TEXCOORD3;
					out vec4 vs_TEXCOORD4;
					out vec3 vs_TEXCOORD5;
					vec4 u_xlat0;
					vec4 u_xlat1;
					vec4 u_xlat2;
					vec3 u_xlat3;
					float u_xlat12;
					void main()
					{
					    u_xlat0.xy = in_TEXCOORD0.xy * _MainTexture_ST.xy + _MainTexture_ST.zw;
					    u_xlat0 = textureLod(_MainTexture, u_xlat0.xy, 0.0);
					    u_xlat0.xyz = u_xlat0.xyz * _Color.xyz;
					    u_xlat1.xyz = u_xlat0.xyz * vec3(-1.0, -1.0, 1.0);
					    u_xlat2.xy = in_TEXCOORD0.xy * _Heightmap_ST.xy + _Heightmap_ST.zw;
					    u_xlat2 = textureLod(_Heightmap, u_xlat2.xy, 0.0);
					    u_xlat2.xyz = u_xlat2.xyz * vec3(_Bumpiness);
					    u_xlat2.xyz = clamp(u_xlat2.xyz, 0.0, 1.0);
					    u_xlat3.xyz = u_xlat2.xyz + vec3(0.0, 0.0, 1.0);
					    u_xlat2.xyz = u_xlat2.xyz * in_NORMAL0.xyz;
					    u_xlat12 = dot(u_xlat3.xyz, u_xlat1.xyz);
					    u_xlat1.xyz = vec3(u_xlat12) * u_xlat3.xyz;
					    u_xlat1.xyz = u_xlat1.xyz / u_xlat3.zzz;
					    u_xlat0.xyz = (-u_xlat0.xyz) * vec3(-1.0, -1.0, 1.0) + u_xlat1.xyz;
					    u_xlat0.x = dot(u_xlat0.xyz, vec3(0.300000012, 0.589999974, 0.109999999));
					    u_xlat0.xyz = u_xlat2.xyz * u_xlat0.xxx + (-u_xlat2.xyz);
					    u_xlat0.xyz = vec3(vec3(_BumpAttune, _BumpAttune, _BumpAttune)) * u_xlat0.xyz + u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz + in_POSITION0.xyz;
					    u_xlat1 = u_xlat0.yyyy * unity_ObjectToWorld[1];
					    u_xlat1 = unity_ObjectToWorld[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat0 = unity_ObjectToWorld[2] * u_xlat0.zzzz + u_xlat1;
					    u_xlat1 = u_xlat0 + unity_ObjectToWorld[3];
					    vs_TEXCOORD4 = unity_ObjectToWorld[3] * in_POSITION0.wwww + u_xlat0;
					    u_xlat0 = u_xlat1.yyyy * unity_MatrixVP[1];
					    u_xlat0 = unity_MatrixVP[0] * u_xlat1.xxxx + u_xlat0;
					    u_xlat0 = unity_MatrixVP[2] * u_xlat1.zzzz + u_xlat0;
					    u_xlat0 = unity_MatrixVP[3] * u_xlat1.wwww + u_xlat0;
					    u_xlat1.x = min(u_xlat0.w, u_xlat0.z);
					    u_xlat1.x = (-u_xlat0.z) + u_xlat1.x;
					    gl_Position.z = unity_LightShadowBias.y * u_xlat1.x + u_xlat0.z;
					    gl_Position.xyw = u_xlat0.xyw;
					    vs_TEXCOORD1.xy = in_TEXCOORD0.xy;
					    vs_TEXCOORD2.xy = in_TEXCOORD1.xy;
					    vs_TEXCOORD3.xy = in_TEXCOORD2.xy;
					    u_xlat0.x = dot(in_NORMAL0.xyz, unity_WorldToObject[0].xyz);
					    u_xlat0.y = dot(in_NORMAL0.xyz, unity_WorldToObject[1].xyz);
					    u_xlat0.z = dot(in_NORMAL0.xyz, unity_WorldToObject[2].xyz);
					    u_xlat12 = dot(u_xlat0.xyz, u_xlat0.xyz);
					    u_xlat12 = inversesqrt(u_xlat12);
					    vs_TEXCOORD5.xyz = vec3(u_xlat12) * u_xlat0.xyz;
					    return;
					}"
				}
			}
			Program "fp" {
				SubProgram "d3d11 " {
					Keywords { "SHADOWS_DEPTH" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "DYNAMICLIGHTMAP_OFF" }
					"ps_4_0
					
					#version 330
					#extension GL_ARB_explicit_attrib_location : require
					#extension GL_ARB_explicit_uniform_location : require
					
					layout(location = 0) out vec4 SV_Target0;
					void main()
					{
					    SV_Target0 = vec4(0.0, 0.0, 0.0, 0.0);
					    return;
					}"
				}
				SubProgram "d3d11 " {
					Keywords { "SHADOWS_CUBE" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "DYNAMICLIGHTMAP_OFF" }
					"ps_4_0
					
					#version 330
					#extension GL_ARB_explicit_attrib_location : require
					#extension GL_ARB_explicit_uniform_location : require
					
					layout(location = 0) out vec4 SV_Target0;
					void main()
					{
					    SV_Target0 = vec4(0.0, 0.0, 0.0, 0.0);
					    return;
					}"
				}
				SubProgram "d3d11 " {
					Keywords { "SHADOWS_DEPTH" "DIRLIGHTMAP_COMBINED" "LIGHTMAP_OFF" "DYNAMICLIGHTMAP_OFF" }
					"ps_4_0
					
					#version 330
					#extension GL_ARB_explicit_attrib_location : require
					#extension GL_ARB_explicit_uniform_location : require
					
					layout(location = 0) out vec4 SV_Target0;
					void main()
					{
					    SV_Target0 = vec4(0.0, 0.0, 0.0, 0.0);
					    return;
					}"
				}
				SubProgram "d3d11 " {
					Keywords { "SHADOWS_CUBE" "DIRLIGHTMAP_COMBINED" "LIGHTMAP_OFF" "DYNAMICLIGHTMAP_OFF" }
					"ps_4_0
					
					#version 330
					#extension GL_ARB_explicit_attrib_location : require
					#extension GL_ARB_explicit_uniform_location : require
					
					layout(location = 0) out vec4 SV_Target0;
					void main()
					{
					    SV_Target0 = vec4(0.0, 0.0, 0.0, 0.0);
					    return;
					}"
				}
				SubProgram "d3d11 " {
					Keywords { "SHADOWS_DEPTH" "DIRLIGHTMAP_SEPARATE" "LIGHTMAP_OFF" "DYNAMICLIGHTMAP_OFF" }
					"ps_4_0
					
					#version 330
					#extension GL_ARB_explicit_attrib_location : require
					#extension GL_ARB_explicit_uniform_location : require
					
					layout(location = 0) out vec4 SV_Target0;
					void main()
					{
					    SV_Target0 = vec4(0.0, 0.0, 0.0, 0.0);
					    return;
					}"
				}
				SubProgram "d3d11 " {
					Keywords { "SHADOWS_CUBE" "DIRLIGHTMAP_SEPARATE" "LIGHTMAP_OFF" "DYNAMICLIGHTMAP_OFF" }
					"ps_4_0
					
					#version 330
					#extension GL_ARB_explicit_attrib_location : require
					#extension GL_ARB_explicit_uniform_location : require
					
					layout(location = 0) out vec4 SV_Target0;
					void main()
					{
					    SV_Target0 = vec4(0.0, 0.0, 0.0, 0.0);
					    return;
					}"
				}
			}
		}
		Pass {
			Name "Meta"
			LOD 2
			Tags { "LIGHTMODE" = "META" "RenderType" = "Opaque" "SHADOWSUPPORT" = "true" }
			Cull Off
			GpuProgramID 249642
			Program "vp" {
				SubProgram "d3d11 " {
					Keywords { "SHADOWS_DEPTH" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "DYNAMICLIGHTMAP_OFF" }
					"vs_4_0
					
					#version 330
					#extension GL_ARB_explicit_attrib_location : require
					#extension GL_ARB_explicit_uniform_location : require
					
					#define HLSLCC_ENABLE_UNIFORM_BUFFERS 1
					#if HLSLCC_ENABLE_UNIFORM_BUFFERS
					#define UNITY_UNIFORM
					#else
					#define UNITY_UNIFORM uniform
					#endif
					#define UNITY_SUPPORTS_UNIFORM_LOCATION 1
					#if UNITY_SUPPORTS_UNIFORM_LOCATION
					#define UNITY_LOCATION(x) layout(location = x)
					#define UNITY_BINDING(x) layout(binding = x, std140)
					#else
					#define UNITY_LOCATION(x)
					#define UNITY_BINDING(x) layout(std140)
					#endif
					layout(std140) uniform VGlobals {
						vec4 unused_0_0[5];
						vec4 _MainTexture_ST;
						vec4 unused_0_2;
						vec4 _Color;
						vec4 _Heightmap_ST;
						float _Bumpiness;
						float _BumpAttune;
					};
					layout(std140) uniform UnityPerDraw {
						mat4x4 unity_ObjectToWorld;
						mat4x4 unity_WorldToObject;
						vec4 unused_1_2[2];
					};
					layout(std140) uniform UnityPerFrame {
						vec4 unused_2_0[17];
						mat4x4 unity_MatrixVP;
						vec4 unused_2_2[2];
					};
					layout(std140) uniform UnityLightmaps {
						vec4 unity_LightmapST;
						vec4 unity_DynamicLightmapST;
					};
					layout(std140) uniform UnityMetaPass {
						bvec4 unity_MetaVertexControl;
						vec4 unused_4_1[2];
					};
					uniform  sampler2D _Heightmap;
					uniform  sampler2D _MainTexture;
					in  vec4 in_POSITION0;
					in  vec3 in_NORMAL0;
					in  vec2 in_TEXCOORD0;
					in  vec2 in_TEXCOORD1;
					in  vec2 in_TEXCOORD2;
					out vec2 vs_TEXCOORD0;
					out vec2 vs_TEXCOORD1;
					out vec2 vs_TEXCOORD2;
					out vec4 vs_TEXCOORD3;
					out vec3 vs_TEXCOORD4;
					vec4 u_xlat0;
					vec4 u_xlat1;
					vec4 u_xlat2;
					vec3 u_xlat3;
					float u_xlat12;
					bool u_xlatb12;
					void main()
					{
					    u_xlat0.xy = in_TEXCOORD0.xy * _MainTexture_ST.xy + _MainTexture_ST.zw;
					    u_xlat0 = textureLod(_MainTexture, u_xlat0.xy, 0.0);
					    u_xlat0.xyz = u_xlat0.xyz * _Color.xyz;
					    u_xlat1.xyz = u_xlat0.xyz * vec3(-1.0, -1.0, 1.0);
					    u_xlat2.xy = in_TEXCOORD0.xy * _Heightmap_ST.xy + _Heightmap_ST.zw;
					    u_xlat2 = textureLod(_Heightmap, u_xlat2.xy, 0.0);
					    u_xlat2.xyz = u_xlat2.xyz * vec3(_Bumpiness);
					    u_xlat2.xyz = clamp(u_xlat2.xyz, 0.0, 1.0);
					    u_xlat3.xyz = u_xlat2.xyz + vec3(0.0, 0.0, 1.0);
					    u_xlat2.xyz = u_xlat2.xyz * in_NORMAL0.xyz;
					    u_xlat12 = dot(u_xlat3.xyz, u_xlat1.xyz);
					    u_xlat1.xyz = vec3(u_xlat12) * u_xlat3.xyz;
					    u_xlat1.xyz = u_xlat1.xyz / u_xlat3.zzz;
					    u_xlat0.xyz = (-u_xlat0.xyz) * vec3(-1.0, -1.0, 1.0) + u_xlat1.xyz;
					    u_xlat0.x = dot(u_xlat0.xyz, vec3(0.300000012, 0.589999974, 0.109999999));
					    u_xlat0.xyz = u_xlat2.xyz * u_xlat0.xxx + (-u_xlat2.xyz);
					    u_xlat0.xyz = vec3(vec3(_BumpAttune, _BumpAttune, _BumpAttune)) * u_xlat0.xyz + u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz + in_POSITION0.xyz;
					    u_xlatb12 = 0.0<u_xlat0.z;
					    u_xlat1.z = u_xlatb12 ? 9.99999975e-05 : float(0.0);
					    u_xlat1.xy = in_TEXCOORD1.xy * unity_LightmapST.xy + unity_LightmapST.zw;
					    u_xlat1.xyz = (unity_MetaVertexControl.x) ? u_xlat1.xyz : u_xlat0.xyz;
					    u_xlatb12 = 0.0<u_xlat1.z;
					    u_xlat2.z = u_xlatb12 ? 9.99999975e-05 : float(0.0);
					    u_xlat2.xy = in_TEXCOORD2.xy * unity_DynamicLightmapST.xy + unity_DynamicLightmapST.zw;
					    u_xlat1.xyz = (unity_MetaVertexControl.y) ? u_xlat2.xyz : u_xlat1.xyz;
					    u_xlat2 = u_xlat1.yyyy * unity_MatrixVP[1];
					    u_xlat2 = unity_MatrixVP[0] * u_xlat1.xxxx + u_xlat2;
					    u_xlat1 = unity_MatrixVP[2] * u_xlat1.zzzz + u_xlat2;
					    gl_Position = u_xlat1 + unity_MatrixVP[3];
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
					    vs_TEXCOORD1.xy = in_TEXCOORD1.xy;
					    vs_TEXCOORD2.xy = in_TEXCOORD2.xy;
					    u_xlat1 = u_xlat0.yyyy * unity_ObjectToWorld[1];
					    u_xlat1 = unity_ObjectToWorld[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat0 = unity_ObjectToWorld[2] * u_xlat0.zzzz + u_xlat1;
					    vs_TEXCOORD3 = unity_ObjectToWorld[3] * in_POSITION0.wwww + u_xlat0;
					    u_xlat0.x = dot(in_NORMAL0.xyz, unity_WorldToObject[0].xyz);
					    u_xlat0.y = dot(in_NORMAL0.xyz, unity_WorldToObject[1].xyz);
					    u_xlat0.z = dot(in_NORMAL0.xyz, unity_WorldToObject[2].xyz);
					    u_xlat12 = dot(u_xlat0.xyz, u_xlat0.xyz);
					    u_xlat12 = inversesqrt(u_xlat12);
					    vs_TEXCOORD4.xyz = vec3(u_xlat12) * u_xlat0.xyz;
					    return;
					}"
				}
				SubProgram "d3d11 " {
					Keywords { "SHADOWS_CUBE" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "DYNAMICLIGHTMAP_OFF" }
					"vs_4_0
					
					#version 330
					#extension GL_ARB_explicit_attrib_location : require
					#extension GL_ARB_explicit_uniform_location : require
					
					#define HLSLCC_ENABLE_UNIFORM_BUFFERS 1
					#if HLSLCC_ENABLE_UNIFORM_BUFFERS
					#define UNITY_UNIFORM
					#else
					#define UNITY_UNIFORM uniform
					#endif
					#define UNITY_SUPPORTS_UNIFORM_LOCATION 1
					#if UNITY_SUPPORTS_UNIFORM_LOCATION
					#define UNITY_LOCATION(x) layout(location = x)
					#define UNITY_BINDING(x) layout(binding = x, std140)
					#else
					#define UNITY_LOCATION(x)
					#define UNITY_BINDING(x) layout(std140)
					#endif
					layout(std140) uniform VGlobals {
						vec4 unused_0_0[5];
						vec4 _MainTexture_ST;
						vec4 unused_0_2;
						vec4 _Color;
						vec4 _Heightmap_ST;
						float _Bumpiness;
						float _BumpAttune;
					};
					layout(std140) uniform UnityPerDraw {
						mat4x4 unity_ObjectToWorld;
						mat4x4 unity_WorldToObject;
						vec4 unused_1_2[2];
					};
					layout(std140) uniform UnityPerFrame {
						vec4 unused_2_0[17];
						mat4x4 unity_MatrixVP;
						vec4 unused_2_2[2];
					};
					layout(std140) uniform UnityLightmaps {
						vec4 unity_LightmapST;
						vec4 unity_DynamicLightmapST;
					};
					layout(std140) uniform UnityMetaPass {
						bvec4 unity_MetaVertexControl;
						vec4 unused_4_1[2];
					};
					uniform  sampler2D _Heightmap;
					uniform  sampler2D _MainTexture;
					in  vec4 in_POSITION0;
					in  vec3 in_NORMAL0;
					in  vec2 in_TEXCOORD0;
					in  vec2 in_TEXCOORD1;
					in  vec2 in_TEXCOORD2;
					out vec2 vs_TEXCOORD0;
					out vec2 vs_TEXCOORD1;
					out vec2 vs_TEXCOORD2;
					out vec4 vs_TEXCOORD3;
					out vec3 vs_TEXCOORD4;
					vec4 u_xlat0;
					vec4 u_xlat1;
					vec4 u_xlat2;
					vec3 u_xlat3;
					float u_xlat12;
					bool u_xlatb12;
					void main()
					{
					    u_xlat0.xy = in_TEXCOORD0.xy * _MainTexture_ST.xy + _MainTexture_ST.zw;
					    u_xlat0 = textureLod(_MainTexture, u_xlat0.xy, 0.0);
					    u_xlat0.xyz = u_xlat0.xyz * _Color.xyz;
					    u_xlat1.xyz = u_xlat0.xyz * vec3(-1.0, -1.0, 1.0);
					    u_xlat2.xy = in_TEXCOORD0.xy * _Heightmap_ST.xy + _Heightmap_ST.zw;
					    u_xlat2 = textureLod(_Heightmap, u_xlat2.xy, 0.0);
					    u_xlat2.xyz = u_xlat2.xyz * vec3(_Bumpiness);
					    u_xlat2.xyz = clamp(u_xlat2.xyz, 0.0, 1.0);
					    u_xlat3.xyz = u_xlat2.xyz + vec3(0.0, 0.0, 1.0);
					    u_xlat2.xyz = u_xlat2.xyz * in_NORMAL0.xyz;
					    u_xlat12 = dot(u_xlat3.xyz, u_xlat1.xyz);
					    u_xlat1.xyz = vec3(u_xlat12) * u_xlat3.xyz;
					    u_xlat1.xyz = u_xlat1.xyz / u_xlat3.zzz;
					    u_xlat0.xyz = (-u_xlat0.xyz) * vec3(-1.0, -1.0, 1.0) + u_xlat1.xyz;
					    u_xlat0.x = dot(u_xlat0.xyz, vec3(0.300000012, 0.589999974, 0.109999999));
					    u_xlat0.xyz = u_xlat2.xyz * u_xlat0.xxx + (-u_xlat2.xyz);
					    u_xlat0.xyz = vec3(vec3(_BumpAttune, _BumpAttune, _BumpAttune)) * u_xlat0.xyz + u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz + in_POSITION0.xyz;
					    u_xlatb12 = 0.0<u_xlat0.z;
					    u_xlat1.z = u_xlatb12 ? 9.99999975e-05 : float(0.0);
					    u_xlat1.xy = in_TEXCOORD1.xy * unity_LightmapST.xy + unity_LightmapST.zw;
					    u_xlat1.xyz = (unity_MetaVertexControl.x) ? u_xlat1.xyz : u_xlat0.xyz;
					    u_xlatb12 = 0.0<u_xlat1.z;
					    u_xlat2.z = u_xlatb12 ? 9.99999975e-05 : float(0.0);
					    u_xlat2.xy = in_TEXCOORD2.xy * unity_DynamicLightmapST.xy + unity_DynamicLightmapST.zw;
					    u_xlat1.xyz = (unity_MetaVertexControl.y) ? u_xlat2.xyz : u_xlat1.xyz;
					    u_xlat2 = u_xlat1.yyyy * unity_MatrixVP[1];
					    u_xlat2 = unity_MatrixVP[0] * u_xlat1.xxxx + u_xlat2;
					    u_xlat1 = unity_MatrixVP[2] * u_xlat1.zzzz + u_xlat2;
					    gl_Position = u_xlat1 + unity_MatrixVP[3];
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
					    vs_TEXCOORD1.xy = in_TEXCOORD1.xy;
					    vs_TEXCOORD2.xy = in_TEXCOORD2.xy;
					    u_xlat1 = u_xlat0.yyyy * unity_ObjectToWorld[1];
					    u_xlat1 = unity_ObjectToWorld[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat0 = unity_ObjectToWorld[2] * u_xlat0.zzzz + u_xlat1;
					    vs_TEXCOORD3 = unity_ObjectToWorld[3] * in_POSITION0.wwww + u_xlat0;
					    u_xlat0.x = dot(in_NORMAL0.xyz, unity_WorldToObject[0].xyz);
					    u_xlat0.y = dot(in_NORMAL0.xyz, unity_WorldToObject[1].xyz);
					    u_xlat0.z = dot(in_NORMAL0.xyz, unity_WorldToObject[2].xyz);
					    u_xlat12 = dot(u_xlat0.xyz, u_xlat0.xyz);
					    u_xlat12 = inversesqrt(u_xlat12);
					    vs_TEXCOORD4.xyz = vec3(u_xlat12) * u_xlat0.xyz;
					    return;
					}"
				}
				SubProgram "d3d11 " {
					Keywords { "SHADOWS_DEPTH" "DIRLIGHTMAP_COMBINED" "LIGHTMAP_OFF" "DYNAMICLIGHTMAP_OFF" }
					"vs_4_0
					
					#version 330
					#extension GL_ARB_explicit_attrib_location : require
					#extension GL_ARB_explicit_uniform_location : require
					
					#define HLSLCC_ENABLE_UNIFORM_BUFFERS 1
					#if HLSLCC_ENABLE_UNIFORM_BUFFERS
					#define UNITY_UNIFORM
					#else
					#define UNITY_UNIFORM uniform
					#endif
					#define UNITY_SUPPORTS_UNIFORM_LOCATION 1
					#if UNITY_SUPPORTS_UNIFORM_LOCATION
					#define UNITY_LOCATION(x) layout(location = x)
					#define UNITY_BINDING(x) layout(binding = x, std140)
					#else
					#define UNITY_LOCATION(x)
					#define UNITY_BINDING(x) layout(std140)
					#endif
					layout(std140) uniform VGlobals {
						vec4 unused_0_0[5];
						vec4 _MainTexture_ST;
						vec4 unused_0_2;
						vec4 _Color;
						vec4 _Heightmap_ST;
						float _Bumpiness;
						float _BumpAttune;
					};
					layout(std140) uniform UnityPerDraw {
						mat4x4 unity_ObjectToWorld;
						mat4x4 unity_WorldToObject;
						vec4 unused_1_2[2];
					};
					layout(std140) uniform UnityPerFrame {
						vec4 unused_2_0[17];
						mat4x4 unity_MatrixVP;
						vec4 unused_2_2[2];
					};
					layout(std140) uniform UnityLightmaps {
						vec4 unity_LightmapST;
						vec4 unity_DynamicLightmapST;
					};
					layout(std140) uniform UnityMetaPass {
						bvec4 unity_MetaVertexControl;
						vec4 unused_4_1[2];
					};
					uniform  sampler2D _Heightmap;
					uniform  sampler2D _MainTexture;
					in  vec4 in_POSITION0;
					in  vec3 in_NORMAL0;
					in  vec2 in_TEXCOORD0;
					in  vec2 in_TEXCOORD1;
					in  vec2 in_TEXCOORD2;
					out vec2 vs_TEXCOORD0;
					out vec2 vs_TEXCOORD1;
					out vec2 vs_TEXCOORD2;
					out vec4 vs_TEXCOORD3;
					out vec3 vs_TEXCOORD4;
					vec4 u_xlat0;
					vec4 u_xlat1;
					vec4 u_xlat2;
					vec3 u_xlat3;
					float u_xlat12;
					bool u_xlatb12;
					void main()
					{
					    u_xlat0.xy = in_TEXCOORD0.xy * _MainTexture_ST.xy + _MainTexture_ST.zw;
					    u_xlat0 = textureLod(_MainTexture, u_xlat0.xy, 0.0);
					    u_xlat0.xyz = u_xlat0.xyz * _Color.xyz;
					    u_xlat1.xyz = u_xlat0.xyz * vec3(-1.0, -1.0, 1.0);
					    u_xlat2.xy = in_TEXCOORD0.xy * _Heightmap_ST.xy + _Heightmap_ST.zw;
					    u_xlat2 = textureLod(_Heightmap, u_xlat2.xy, 0.0);
					    u_xlat2.xyz = u_xlat2.xyz * vec3(_Bumpiness);
					    u_xlat2.xyz = clamp(u_xlat2.xyz, 0.0, 1.0);
					    u_xlat3.xyz = u_xlat2.xyz + vec3(0.0, 0.0, 1.0);
					    u_xlat2.xyz = u_xlat2.xyz * in_NORMAL0.xyz;
					    u_xlat12 = dot(u_xlat3.xyz, u_xlat1.xyz);
					    u_xlat1.xyz = vec3(u_xlat12) * u_xlat3.xyz;
					    u_xlat1.xyz = u_xlat1.xyz / u_xlat3.zzz;
					    u_xlat0.xyz = (-u_xlat0.xyz) * vec3(-1.0, -1.0, 1.0) + u_xlat1.xyz;
					    u_xlat0.x = dot(u_xlat0.xyz, vec3(0.300000012, 0.589999974, 0.109999999));
					    u_xlat0.xyz = u_xlat2.xyz * u_xlat0.xxx + (-u_xlat2.xyz);
					    u_xlat0.xyz = vec3(vec3(_BumpAttune, _BumpAttune, _BumpAttune)) * u_xlat0.xyz + u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz + in_POSITION0.xyz;
					    u_xlatb12 = 0.0<u_xlat0.z;
					    u_xlat1.z = u_xlatb12 ? 9.99999975e-05 : float(0.0);
					    u_xlat1.xy = in_TEXCOORD1.xy * unity_LightmapST.xy + unity_LightmapST.zw;
					    u_xlat1.xyz = (unity_MetaVertexControl.x) ? u_xlat1.xyz : u_xlat0.xyz;
					    u_xlatb12 = 0.0<u_xlat1.z;
					    u_xlat2.z = u_xlatb12 ? 9.99999975e-05 : float(0.0);
					    u_xlat2.xy = in_TEXCOORD2.xy * unity_DynamicLightmapST.xy + unity_DynamicLightmapST.zw;
					    u_xlat1.xyz = (unity_MetaVertexControl.y) ? u_xlat2.xyz : u_xlat1.xyz;
					    u_xlat2 = u_xlat1.yyyy * unity_MatrixVP[1];
					    u_xlat2 = unity_MatrixVP[0] * u_xlat1.xxxx + u_xlat2;
					    u_xlat1 = unity_MatrixVP[2] * u_xlat1.zzzz + u_xlat2;
					    gl_Position = u_xlat1 + unity_MatrixVP[3];
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
					    vs_TEXCOORD1.xy = in_TEXCOORD1.xy;
					    vs_TEXCOORD2.xy = in_TEXCOORD2.xy;
					    u_xlat1 = u_xlat0.yyyy * unity_ObjectToWorld[1];
					    u_xlat1 = unity_ObjectToWorld[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat0 = unity_ObjectToWorld[2] * u_xlat0.zzzz + u_xlat1;
					    vs_TEXCOORD3 = unity_ObjectToWorld[3] * in_POSITION0.wwww + u_xlat0;
					    u_xlat0.x = dot(in_NORMAL0.xyz, unity_WorldToObject[0].xyz);
					    u_xlat0.y = dot(in_NORMAL0.xyz, unity_WorldToObject[1].xyz);
					    u_xlat0.z = dot(in_NORMAL0.xyz, unity_WorldToObject[2].xyz);
					    u_xlat12 = dot(u_xlat0.xyz, u_xlat0.xyz);
					    u_xlat12 = inversesqrt(u_xlat12);
					    vs_TEXCOORD4.xyz = vec3(u_xlat12) * u_xlat0.xyz;
					    return;
					}"
				}
				SubProgram "d3d11 " {
					Keywords { "SHADOWS_CUBE" "DIRLIGHTMAP_COMBINED" "LIGHTMAP_OFF" "DYNAMICLIGHTMAP_OFF" }
					"vs_4_0
					
					#version 330
					#extension GL_ARB_explicit_attrib_location : require
					#extension GL_ARB_explicit_uniform_location : require
					
					#define HLSLCC_ENABLE_UNIFORM_BUFFERS 1
					#if HLSLCC_ENABLE_UNIFORM_BUFFERS
					#define UNITY_UNIFORM
					#else
					#define UNITY_UNIFORM uniform
					#endif
					#define UNITY_SUPPORTS_UNIFORM_LOCATION 1
					#if UNITY_SUPPORTS_UNIFORM_LOCATION
					#define UNITY_LOCATION(x) layout(location = x)
					#define UNITY_BINDING(x) layout(binding = x, std140)
					#else
					#define UNITY_LOCATION(x)
					#define UNITY_BINDING(x) layout(std140)
					#endif
					layout(std140) uniform VGlobals {
						vec4 unused_0_0[5];
						vec4 _MainTexture_ST;
						vec4 unused_0_2;
						vec4 _Color;
						vec4 _Heightmap_ST;
						float _Bumpiness;
						float _BumpAttune;
					};
					layout(std140) uniform UnityPerDraw {
						mat4x4 unity_ObjectToWorld;
						mat4x4 unity_WorldToObject;
						vec4 unused_1_2[2];
					};
					layout(std140) uniform UnityPerFrame {
						vec4 unused_2_0[17];
						mat4x4 unity_MatrixVP;
						vec4 unused_2_2[2];
					};
					layout(std140) uniform UnityLightmaps {
						vec4 unity_LightmapST;
						vec4 unity_DynamicLightmapST;
					};
					layout(std140) uniform UnityMetaPass {
						bvec4 unity_MetaVertexControl;
						vec4 unused_4_1[2];
					};
					uniform  sampler2D _Heightmap;
					uniform  sampler2D _MainTexture;
					in  vec4 in_POSITION0;
					in  vec3 in_NORMAL0;
					in  vec2 in_TEXCOORD0;
					in  vec2 in_TEXCOORD1;
					in  vec2 in_TEXCOORD2;
					out vec2 vs_TEXCOORD0;
					out vec2 vs_TEXCOORD1;
					out vec2 vs_TEXCOORD2;
					out vec4 vs_TEXCOORD3;
					out vec3 vs_TEXCOORD4;
					vec4 u_xlat0;
					vec4 u_xlat1;
					vec4 u_xlat2;
					vec3 u_xlat3;
					float u_xlat12;
					bool u_xlatb12;
					void main()
					{
					    u_xlat0.xy = in_TEXCOORD0.xy * _MainTexture_ST.xy + _MainTexture_ST.zw;
					    u_xlat0 = textureLod(_MainTexture, u_xlat0.xy, 0.0);
					    u_xlat0.xyz = u_xlat0.xyz * _Color.xyz;
					    u_xlat1.xyz = u_xlat0.xyz * vec3(-1.0, -1.0, 1.0);
					    u_xlat2.xy = in_TEXCOORD0.xy * _Heightmap_ST.xy + _Heightmap_ST.zw;
					    u_xlat2 = textureLod(_Heightmap, u_xlat2.xy, 0.0);
					    u_xlat2.xyz = u_xlat2.xyz * vec3(_Bumpiness);
					    u_xlat2.xyz = clamp(u_xlat2.xyz, 0.0, 1.0);
					    u_xlat3.xyz = u_xlat2.xyz + vec3(0.0, 0.0, 1.0);
					    u_xlat2.xyz = u_xlat2.xyz * in_NORMAL0.xyz;
					    u_xlat12 = dot(u_xlat3.xyz, u_xlat1.xyz);
					    u_xlat1.xyz = vec3(u_xlat12) * u_xlat3.xyz;
					    u_xlat1.xyz = u_xlat1.xyz / u_xlat3.zzz;
					    u_xlat0.xyz = (-u_xlat0.xyz) * vec3(-1.0, -1.0, 1.0) + u_xlat1.xyz;
					    u_xlat0.x = dot(u_xlat0.xyz, vec3(0.300000012, 0.589999974, 0.109999999));
					    u_xlat0.xyz = u_xlat2.xyz * u_xlat0.xxx + (-u_xlat2.xyz);
					    u_xlat0.xyz = vec3(vec3(_BumpAttune, _BumpAttune, _BumpAttune)) * u_xlat0.xyz + u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz + in_POSITION0.xyz;
					    u_xlatb12 = 0.0<u_xlat0.z;
					    u_xlat1.z = u_xlatb12 ? 9.99999975e-05 : float(0.0);
					    u_xlat1.xy = in_TEXCOORD1.xy * unity_LightmapST.xy + unity_LightmapST.zw;
					    u_xlat1.xyz = (unity_MetaVertexControl.x) ? u_xlat1.xyz : u_xlat0.xyz;
					    u_xlatb12 = 0.0<u_xlat1.z;
					    u_xlat2.z = u_xlatb12 ? 9.99999975e-05 : float(0.0);
					    u_xlat2.xy = in_TEXCOORD2.xy * unity_DynamicLightmapST.xy + unity_DynamicLightmapST.zw;
					    u_xlat1.xyz = (unity_MetaVertexControl.y) ? u_xlat2.xyz : u_xlat1.xyz;
					    u_xlat2 = u_xlat1.yyyy * unity_MatrixVP[1];
					    u_xlat2 = unity_MatrixVP[0] * u_xlat1.xxxx + u_xlat2;
					    u_xlat1 = unity_MatrixVP[2] * u_xlat1.zzzz + u_xlat2;
					    gl_Position = u_xlat1 + unity_MatrixVP[3];
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
					    vs_TEXCOORD1.xy = in_TEXCOORD1.xy;
					    vs_TEXCOORD2.xy = in_TEXCOORD2.xy;
					    u_xlat1 = u_xlat0.yyyy * unity_ObjectToWorld[1];
					    u_xlat1 = unity_ObjectToWorld[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat0 = unity_ObjectToWorld[2] * u_xlat0.zzzz + u_xlat1;
					    vs_TEXCOORD3 = unity_ObjectToWorld[3] * in_POSITION0.wwww + u_xlat0;
					    u_xlat0.x = dot(in_NORMAL0.xyz, unity_WorldToObject[0].xyz);
					    u_xlat0.y = dot(in_NORMAL0.xyz, unity_WorldToObject[1].xyz);
					    u_xlat0.z = dot(in_NORMAL0.xyz, unity_WorldToObject[2].xyz);
					    u_xlat12 = dot(u_xlat0.xyz, u_xlat0.xyz);
					    u_xlat12 = inversesqrt(u_xlat12);
					    vs_TEXCOORD4.xyz = vec3(u_xlat12) * u_xlat0.xyz;
					    return;
					}"
				}
				SubProgram "d3d11 " {
					Keywords { "SHADOWS_DEPTH" "DIRLIGHTMAP_SEPARATE" "LIGHTMAP_OFF" "DYNAMICLIGHTMAP_OFF" }
					"vs_4_0
					
					#version 330
					#extension GL_ARB_explicit_attrib_location : require
					#extension GL_ARB_explicit_uniform_location : require
					
					#define HLSLCC_ENABLE_UNIFORM_BUFFERS 1
					#if HLSLCC_ENABLE_UNIFORM_BUFFERS
					#define UNITY_UNIFORM
					#else
					#define UNITY_UNIFORM uniform
					#endif
					#define UNITY_SUPPORTS_UNIFORM_LOCATION 1
					#if UNITY_SUPPORTS_UNIFORM_LOCATION
					#define UNITY_LOCATION(x) layout(location = x)
					#define UNITY_BINDING(x) layout(binding = x, std140)
					#else
					#define UNITY_LOCATION(x)
					#define UNITY_BINDING(x) layout(std140)
					#endif
					layout(std140) uniform VGlobals {
						vec4 unused_0_0[5];
						vec4 _MainTexture_ST;
						vec4 unused_0_2;
						vec4 _Color;
						vec4 _Heightmap_ST;
						float _Bumpiness;
						float _BumpAttune;
					};
					layout(std140) uniform UnityPerDraw {
						mat4x4 unity_ObjectToWorld;
						mat4x4 unity_WorldToObject;
						vec4 unused_1_2[2];
					};
					layout(std140) uniform UnityPerFrame {
						vec4 unused_2_0[17];
						mat4x4 unity_MatrixVP;
						vec4 unused_2_2[2];
					};
					layout(std140) uniform UnityLightmaps {
						vec4 unity_LightmapST;
						vec4 unity_DynamicLightmapST;
					};
					layout(std140) uniform UnityMetaPass {
						bvec4 unity_MetaVertexControl;
						vec4 unused_4_1[2];
					};
					uniform  sampler2D _Heightmap;
					uniform  sampler2D _MainTexture;
					in  vec4 in_POSITION0;
					in  vec3 in_NORMAL0;
					in  vec2 in_TEXCOORD0;
					in  vec2 in_TEXCOORD1;
					in  vec2 in_TEXCOORD2;
					out vec2 vs_TEXCOORD0;
					out vec2 vs_TEXCOORD1;
					out vec2 vs_TEXCOORD2;
					out vec4 vs_TEXCOORD3;
					out vec3 vs_TEXCOORD4;
					vec4 u_xlat0;
					vec4 u_xlat1;
					vec4 u_xlat2;
					vec3 u_xlat3;
					float u_xlat12;
					bool u_xlatb12;
					void main()
					{
					    u_xlat0.xy = in_TEXCOORD0.xy * _MainTexture_ST.xy + _MainTexture_ST.zw;
					    u_xlat0 = textureLod(_MainTexture, u_xlat0.xy, 0.0);
					    u_xlat0.xyz = u_xlat0.xyz * _Color.xyz;
					    u_xlat1.xyz = u_xlat0.xyz * vec3(-1.0, -1.0, 1.0);
					    u_xlat2.xy = in_TEXCOORD0.xy * _Heightmap_ST.xy + _Heightmap_ST.zw;
					    u_xlat2 = textureLod(_Heightmap, u_xlat2.xy, 0.0);
					    u_xlat2.xyz = u_xlat2.xyz * vec3(_Bumpiness);
					    u_xlat2.xyz = clamp(u_xlat2.xyz, 0.0, 1.0);
					    u_xlat3.xyz = u_xlat2.xyz + vec3(0.0, 0.0, 1.0);
					    u_xlat2.xyz = u_xlat2.xyz * in_NORMAL0.xyz;
					    u_xlat12 = dot(u_xlat3.xyz, u_xlat1.xyz);
					    u_xlat1.xyz = vec3(u_xlat12) * u_xlat3.xyz;
					    u_xlat1.xyz = u_xlat1.xyz / u_xlat3.zzz;
					    u_xlat0.xyz = (-u_xlat0.xyz) * vec3(-1.0, -1.0, 1.0) + u_xlat1.xyz;
					    u_xlat0.x = dot(u_xlat0.xyz, vec3(0.300000012, 0.589999974, 0.109999999));
					    u_xlat0.xyz = u_xlat2.xyz * u_xlat0.xxx + (-u_xlat2.xyz);
					    u_xlat0.xyz = vec3(vec3(_BumpAttune, _BumpAttune, _BumpAttune)) * u_xlat0.xyz + u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz + in_POSITION0.xyz;
					    u_xlatb12 = 0.0<u_xlat0.z;
					    u_xlat1.z = u_xlatb12 ? 9.99999975e-05 : float(0.0);
					    u_xlat1.xy = in_TEXCOORD1.xy * unity_LightmapST.xy + unity_LightmapST.zw;
					    u_xlat1.xyz = (unity_MetaVertexControl.x) ? u_xlat1.xyz : u_xlat0.xyz;
					    u_xlatb12 = 0.0<u_xlat1.z;
					    u_xlat2.z = u_xlatb12 ? 9.99999975e-05 : float(0.0);
					    u_xlat2.xy = in_TEXCOORD2.xy * unity_DynamicLightmapST.xy + unity_DynamicLightmapST.zw;
					    u_xlat1.xyz = (unity_MetaVertexControl.y) ? u_xlat2.xyz : u_xlat1.xyz;
					    u_xlat2 = u_xlat1.yyyy * unity_MatrixVP[1];
					    u_xlat2 = unity_MatrixVP[0] * u_xlat1.xxxx + u_xlat2;
					    u_xlat1 = unity_MatrixVP[2] * u_xlat1.zzzz + u_xlat2;
					    gl_Position = u_xlat1 + unity_MatrixVP[3];
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
					    vs_TEXCOORD1.xy = in_TEXCOORD1.xy;
					    vs_TEXCOORD2.xy = in_TEXCOORD2.xy;
					    u_xlat1 = u_xlat0.yyyy * unity_ObjectToWorld[1];
					    u_xlat1 = unity_ObjectToWorld[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat0 = unity_ObjectToWorld[2] * u_xlat0.zzzz + u_xlat1;
					    vs_TEXCOORD3 = unity_ObjectToWorld[3] * in_POSITION0.wwww + u_xlat0;
					    u_xlat0.x = dot(in_NORMAL0.xyz, unity_WorldToObject[0].xyz);
					    u_xlat0.y = dot(in_NORMAL0.xyz, unity_WorldToObject[1].xyz);
					    u_xlat0.z = dot(in_NORMAL0.xyz, unity_WorldToObject[2].xyz);
					    u_xlat12 = dot(u_xlat0.xyz, u_xlat0.xyz);
					    u_xlat12 = inversesqrt(u_xlat12);
					    vs_TEXCOORD4.xyz = vec3(u_xlat12) * u_xlat0.xyz;
					    return;
					}"
				}
				SubProgram "d3d11 " {
					Keywords { "SHADOWS_CUBE" "DIRLIGHTMAP_SEPARATE" "LIGHTMAP_OFF" "DYNAMICLIGHTMAP_OFF" }
					"vs_4_0
					
					#version 330
					#extension GL_ARB_explicit_attrib_location : require
					#extension GL_ARB_explicit_uniform_location : require
					
					#define HLSLCC_ENABLE_UNIFORM_BUFFERS 1
					#if HLSLCC_ENABLE_UNIFORM_BUFFERS
					#define UNITY_UNIFORM
					#else
					#define UNITY_UNIFORM uniform
					#endif
					#define UNITY_SUPPORTS_UNIFORM_LOCATION 1
					#if UNITY_SUPPORTS_UNIFORM_LOCATION
					#define UNITY_LOCATION(x) layout(location = x)
					#define UNITY_BINDING(x) layout(binding = x, std140)
					#else
					#define UNITY_LOCATION(x)
					#define UNITY_BINDING(x) layout(std140)
					#endif
					layout(std140) uniform VGlobals {
						vec4 unused_0_0[5];
						vec4 _MainTexture_ST;
						vec4 unused_0_2;
						vec4 _Color;
						vec4 _Heightmap_ST;
						float _Bumpiness;
						float _BumpAttune;
					};
					layout(std140) uniform UnityPerDraw {
						mat4x4 unity_ObjectToWorld;
						mat4x4 unity_WorldToObject;
						vec4 unused_1_2[2];
					};
					layout(std140) uniform UnityPerFrame {
						vec4 unused_2_0[17];
						mat4x4 unity_MatrixVP;
						vec4 unused_2_2[2];
					};
					layout(std140) uniform UnityLightmaps {
						vec4 unity_LightmapST;
						vec4 unity_DynamicLightmapST;
					};
					layout(std140) uniform UnityMetaPass {
						bvec4 unity_MetaVertexControl;
						vec4 unused_4_1[2];
					};
					uniform  sampler2D _Heightmap;
					uniform  sampler2D _MainTexture;
					in  vec4 in_POSITION0;
					in  vec3 in_NORMAL0;
					in  vec2 in_TEXCOORD0;
					in  vec2 in_TEXCOORD1;
					in  vec2 in_TEXCOORD2;
					out vec2 vs_TEXCOORD0;
					out vec2 vs_TEXCOORD1;
					out vec2 vs_TEXCOORD2;
					out vec4 vs_TEXCOORD3;
					out vec3 vs_TEXCOORD4;
					vec4 u_xlat0;
					vec4 u_xlat1;
					vec4 u_xlat2;
					vec3 u_xlat3;
					float u_xlat12;
					bool u_xlatb12;
					void main()
					{
					    u_xlat0.xy = in_TEXCOORD0.xy * _MainTexture_ST.xy + _MainTexture_ST.zw;
					    u_xlat0 = textureLod(_MainTexture, u_xlat0.xy, 0.0);
					    u_xlat0.xyz = u_xlat0.xyz * _Color.xyz;
					    u_xlat1.xyz = u_xlat0.xyz * vec3(-1.0, -1.0, 1.0);
					    u_xlat2.xy = in_TEXCOORD0.xy * _Heightmap_ST.xy + _Heightmap_ST.zw;
					    u_xlat2 = textureLod(_Heightmap, u_xlat2.xy, 0.0);
					    u_xlat2.xyz = u_xlat2.xyz * vec3(_Bumpiness);
					    u_xlat2.xyz = clamp(u_xlat2.xyz, 0.0, 1.0);
					    u_xlat3.xyz = u_xlat2.xyz + vec3(0.0, 0.0, 1.0);
					    u_xlat2.xyz = u_xlat2.xyz * in_NORMAL0.xyz;
					    u_xlat12 = dot(u_xlat3.xyz, u_xlat1.xyz);
					    u_xlat1.xyz = vec3(u_xlat12) * u_xlat3.xyz;
					    u_xlat1.xyz = u_xlat1.xyz / u_xlat3.zzz;
					    u_xlat0.xyz = (-u_xlat0.xyz) * vec3(-1.0, -1.0, 1.0) + u_xlat1.xyz;
					    u_xlat0.x = dot(u_xlat0.xyz, vec3(0.300000012, 0.589999974, 0.109999999));
					    u_xlat0.xyz = u_xlat2.xyz * u_xlat0.xxx + (-u_xlat2.xyz);
					    u_xlat0.xyz = vec3(vec3(_BumpAttune, _BumpAttune, _BumpAttune)) * u_xlat0.xyz + u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz + in_POSITION0.xyz;
					    u_xlatb12 = 0.0<u_xlat0.z;
					    u_xlat1.z = u_xlatb12 ? 9.99999975e-05 : float(0.0);
					    u_xlat1.xy = in_TEXCOORD1.xy * unity_LightmapST.xy + unity_LightmapST.zw;
					    u_xlat1.xyz = (unity_MetaVertexControl.x) ? u_xlat1.xyz : u_xlat0.xyz;
					    u_xlatb12 = 0.0<u_xlat1.z;
					    u_xlat2.z = u_xlatb12 ? 9.99999975e-05 : float(0.0);
					    u_xlat2.xy = in_TEXCOORD2.xy * unity_DynamicLightmapST.xy + unity_DynamicLightmapST.zw;
					    u_xlat1.xyz = (unity_MetaVertexControl.y) ? u_xlat2.xyz : u_xlat1.xyz;
					    u_xlat2 = u_xlat1.yyyy * unity_MatrixVP[1];
					    u_xlat2 = unity_MatrixVP[0] * u_xlat1.xxxx + u_xlat2;
					    u_xlat1 = unity_MatrixVP[2] * u_xlat1.zzzz + u_xlat2;
					    gl_Position = u_xlat1 + unity_MatrixVP[3];
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
					    vs_TEXCOORD1.xy = in_TEXCOORD1.xy;
					    vs_TEXCOORD2.xy = in_TEXCOORD2.xy;
					    u_xlat1 = u_xlat0.yyyy * unity_ObjectToWorld[1];
					    u_xlat1 = unity_ObjectToWorld[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat0 = unity_ObjectToWorld[2] * u_xlat0.zzzz + u_xlat1;
					    vs_TEXCOORD3 = unity_ObjectToWorld[3] * in_POSITION0.wwww + u_xlat0;
					    u_xlat0.x = dot(in_NORMAL0.xyz, unity_WorldToObject[0].xyz);
					    u_xlat0.y = dot(in_NORMAL0.xyz, unity_WorldToObject[1].xyz);
					    u_xlat0.z = dot(in_NORMAL0.xyz, unity_WorldToObject[2].xyz);
					    u_xlat12 = dot(u_xlat0.xyz, u_xlat0.xyz);
					    u_xlat12 = inversesqrt(u_xlat12);
					    vs_TEXCOORD4.xyz = vec3(u_xlat12) * u_xlat0.xyz;
					    return;
					}"
				}
			}
			Program "fp" {
				SubProgram "d3d11 " {
					Keywords { "SHADOWS_DEPTH" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "DYNAMICLIGHTMAP_OFF" }
					"ps_4_0
					
					#version 330
					#extension GL_ARB_explicit_attrib_location : require
					#extension GL_ARB_explicit_uniform_location : require
					
					#define HLSLCC_ENABLE_UNIFORM_BUFFERS 1
					#if HLSLCC_ENABLE_UNIFORM_BUFFERS
					#define UNITY_UNIFORM
					#else
					#define UNITY_UNIFORM uniform
					#endif
					#define UNITY_SUPPORTS_UNIFORM_LOCATION 1
					#if UNITY_SUPPORTS_UNIFORM_LOCATION
					#define UNITY_LOCATION(x) layout(location = x)
					#define UNITY_BINDING(x) layout(binding = x, std140)
					#else
					#define UNITY_LOCATION(x)
					#define UNITY_BINDING(x) layout(std140)
					#endif
					layout(std140) uniform PGlobals {
						vec4 unused_0_0[4];
						float unity_OneOverOutputBoost;
						float unity_MaxOutputValue;
						vec4 _MainTexture_ST;
						vec4 _Specular_ST;
						vec4 _Color;
						vec4 unused_0_6;
						float _Shadows;
					};
					layout(std140) uniform UnityMetaPass {
						vec4 unused_1_0;
						bvec4 unity_MetaFragmentControl;
						vec4 unused_1_2;
					};
					uniform  sampler2D _MainTexture;
					uniform  sampler2D _Specular;
					in  vec2 vs_TEXCOORD0;
					layout(location = 0) out vec4 SV_Target0;
					vec4 u_xlat0;
					vec3 u_xlat1;
					vec4 u_xlat2;
					float u_xlat9;
					float u_xlat10;
					void main()
					{
					    u_xlat0.xy = vs_TEXCOORD0.xy * _MainTexture_ST.xy + _MainTexture_ST.zw;
					    u_xlat0 = texture(_MainTexture, u_xlat0.xy);
					    u_xlat0.xyz = _Color.xyz * u_xlat0.xyz + vec3(vec3(_Shadows, _Shadows, _Shadows));
					    u_xlat0.xyz = u_xlat0.xyz + vec3(-1.0, -1.0, -1.0);
					    u_xlat0.xyz = clamp(u_xlat0.xyz, 0.0, 1.0);
					    u_xlat1.xyz = u_xlat0.xyz + vec3(-0.220916301, -0.220916301, -0.220916301);
					    u_xlat2.xy = vs_TEXCOORD0.xy * _Specular_ST.xy + _Specular_ST.zw;
					    u_xlat2 = texture(_Specular, u_xlat2.xy);
					    u_xlat9 = u_xlat2.x * 0.449999988;
					    u_xlat10 = (-u_xlat2.x) * 0.350587666 + 0.779083729;
					    u_xlat1.xyz = vec3(u_xlat9) * u_xlat1.xyz + vec3(0.220916301, 0.220916301, 0.220916301);
					    u_xlat1.xyz = u_xlat1.xyz * vec3(0.5, 0.5, 0.5);
					    u_xlat0.xyz = u_xlat0.xyz * vec3(u_xlat10) + u_xlat1.xyz;
					    u_xlat0.xyz = log2(u_xlat0.xyz);
					    u_xlat9 = unity_OneOverOutputBoost;
					    u_xlat9 = clamp(u_xlat9, 0.0, 1.0);
					    u_xlat0.xyz = u_xlat0.xyz * vec3(u_xlat9);
					    u_xlat0.xyz = exp2(u_xlat0.xyz);
					    u_xlat0.xyz = min(u_xlat0.xyz, vec3(vec3(unity_MaxOutputValue, unity_MaxOutputValue, unity_MaxOutputValue)));
					    u_xlat0.w = 1.0;
					    u_xlat0 = (unity_MetaFragmentControl.x) ? u_xlat0 : vec4(0.0, 0.0, 0.0, 0.0);
					    SV_Target0 = (unity_MetaFragmentControl.y) ? vec4(0.0, 0.0, 0.0, 1.0) : u_xlat0;
					    return;
					}"
				}
				SubProgram "d3d11 " {
					Keywords { "SHADOWS_CUBE" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "DYNAMICLIGHTMAP_OFF" }
					"ps_4_0
					
					#version 330
					#extension GL_ARB_explicit_attrib_location : require
					#extension GL_ARB_explicit_uniform_location : require
					
					#define HLSLCC_ENABLE_UNIFORM_BUFFERS 1
					#if HLSLCC_ENABLE_UNIFORM_BUFFERS
					#define UNITY_UNIFORM
					#else
					#define UNITY_UNIFORM uniform
					#endif
					#define UNITY_SUPPORTS_UNIFORM_LOCATION 1
					#if UNITY_SUPPORTS_UNIFORM_LOCATION
					#define UNITY_LOCATION(x) layout(location = x)
					#define UNITY_BINDING(x) layout(binding = x, std140)
					#else
					#define UNITY_LOCATION(x)
					#define UNITY_BINDING(x) layout(std140)
					#endif
					layout(std140) uniform PGlobals {
						vec4 unused_0_0[4];
						float unity_OneOverOutputBoost;
						float unity_MaxOutputValue;
						vec4 _MainTexture_ST;
						vec4 _Specular_ST;
						vec4 _Color;
						vec4 unused_0_6;
						float _Shadows;
					};
					layout(std140) uniform UnityMetaPass {
						vec4 unused_1_0;
						bvec4 unity_MetaFragmentControl;
						vec4 unused_1_2;
					};
					uniform  sampler2D _MainTexture;
					uniform  sampler2D _Specular;
					in  vec2 vs_TEXCOORD0;
					layout(location = 0) out vec4 SV_Target0;
					vec4 u_xlat0;
					vec3 u_xlat1;
					vec4 u_xlat2;
					float u_xlat9;
					float u_xlat10;
					void main()
					{
					    u_xlat0.xy = vs_TEXCOORD0.xy * _MainTexture_ST.xy + _MainTexture_ST.zw;
					    u_xlat0 = texture(_MainTexture, u_xlat0.xy);
					    u_xlat0.xyz = _Color.xyz * u_xlat0.xyz + vec3(vec3(_Shadows, _Shadows, _Shadows));
					    u_xlat0.xyz = u_xlat0.xyz + vec3(-1.0, -1.0, -1.0);
					    u_xlat0.xyz = clamp(u_xlat0.xyz, 0.0, 1.0);
					    u_xlat1.xyz = u_xlat0.xyz + vec3(-0.220916301, -0.220916301, -0.220916301);
					    u_xlat2.xy = vs_TEXCOORD0.xy * _Specular_ST.xy + _Specular_ST.zw;
					    u_xlat2 = texture(_Specular, u_xlat2.xy);
					    u_xlat9 = u_xlat2.x * 0.449999988;
					    u_xlat10 = (-u_xlat2.x) * 0.350587666 + 0.779083729;
					    u_xlat1.xyz = vec3(u_xlat9) * u_xlat1.xyz + vec3(0.220916301, 0.220916301, 0.220916301);
					    u_xlat1.xyz = u_xlat1.xyz * vec3(0.5, 0.5, 0.5);
					    u_xlat0.xyz = u_xlat0.xyz * vec3(u_xlat10) + u_xlat1.xyz;
					    u_xlat0.xyz = log2(u_xlat0.xyz);
					    u_xlat9 = unity_OneOverOutputBoost;
					    u_xlat9 = clamp(u_xlat9, 0.0, 1.0);
					    u_xlat0.xyz = u_xlat0.xyz * vec3(u_xlat9);
					    u_xlat0.xyz = exp2(u_xlat0.xyz);
					    u_xlat0.xyz = min(u_xlat0.xyz, vec3(vec3(unity_MaxOutputValue, unity_MaxOutputValue, unity_MaxOutputValue)));
					    u_xlat0.w = 1.0;
					    u_xlat0 = (unity_MetaFragmentControl.x) ? u_xlat0 : vec4(0.0, 0.0, 0.0, 0.0);
					    SV_Target0 = (unity_MetaFragmentControl.y) ? vec4(0.0, 0.0, 0.0, 1.0) : u_xlat0;
					    return;
					}"
				}
				SubProgram "d3d11 " {
					Keywords { "SHADOWS_DEPTH" "DIRLIGHTMAP_COMBINED" "LIGHTMAP_OFF" "DYNAMICLIGHTMAP_OFF" }
					"ps_4_0
					
					#version 330
					#extension GL_ARB_explicit_attrib_location : require
					#extension GL_ARB_explicit_uniform_location : require
					
					#define HLSLCC_ENABLE_UNIFORM_BUFFERS 1
					#if HLSLCC_ENABLE_UNIFORM_BUFFERS
					#define UNITY_UNIFORM
					#else
					#define UNITY_UNIFORM uniform
					#endif
					#define UNITY_SUPPORTS_UNIFORM_LOCATION 1
					#if UNITY_SUPPORTS_UNIFORM_LOCATION
					#define UNITY_LOCATION(x) layout(location = x)
					#define UNITY_BINDING(x) layout(binding = x, std140)
					#else
					#define UNITY_LOCATION(x)
					#define UNITY_BINDING(x) layout(std140)
					#endif
					layout(std140) uniform PGlobals {
						vec4 unused_0_0[4];
						float unity_OneOverOutputBoost;
						float unity_MaxOutputValue;
						vec4 _MainTexture_ST;
						vec4 _Specular_ST;
						vec4 _Color;
						vec4 unused_0_6;
						float _Shadows;
					};
					layout(std140) uniform UnityMetaPass {
						vec4 unused_1_0;
						bvec4 unity_MetaFragmentControl;
						vec4 unused_1_2;
					};
					uniform  sampler2D _MainTexture;
					uniform  sampler2D _Specular;
					in  vec2 vs_TEXCOORD0;
					layout(location = 0) out vec4 SV_Target0;
					vec4 u_xlat0;
					vec3 u_xlat1;
					vec4 u_xlat2;
					float u_xlat9;
					float u_xlat10;
					void main()
					{
					    u_xlat0.xy = vs_TEXCOORD0.xy * _MainTexture_ST.xy + _MainTexture_ST.zw;
					    u_xlat0 = texture(_MainTexture, u_xlat0.xy);
					    u_xlat0.xyz = _Color.xyz * u_xlat0.xyz + vec3(vec3(_Shadows, _Shadows, _Shadows));
					    u_xlat0.xyz = u_xlat0.xyz + vec3(-1.0, -1.0, -1.0);
					    u_xlat0.xyz = clamp(u_xlat0.xyz, 0.0, 1.0);
					    u_xlat1.xyz = u_xlat0.xyz + vec3(-0.220916301, -0.220916301, -0.220916301);
					    u_xlat2.xy = vs_TEXCOORD0.xy * _Specular_ST.xy + _Specular_ST.zw;
					    u_xlat2 = texture(_Specular, u_xlat2.xy);
					    u_xlat9 = u_xlat2.x * 0.449999988;
					    u_xlat10 = (-u_xlat2.x) * 0.350587666 + 0.779083729;
					    u_xlat1.xyz = vec3(u_xlat9) * u_xlat1.xyz + vec3(0.220916301, 0.220916301, 0.220916301);
					    u_xlat1.xyz = u_xlat1.xyz * vec3(0.5, 0.5, 0.5);
					    u_xlat0.xyz = u_xlat0.xyz * vec3(u_xlat10) + u_xlat1.xyz;
					    u_xlat0.xyz = log2(u_xlat0.xyz);
					    u_xlat9 = unity_OneOverOutputBoost;
					    u_xlat9 = clamp(u_xlat9, 0.0, 1.0);
					    u_xlat0.xyz = u_xlat0.xyz * vec3(u_xlat9);
					    u_xlat0.xyz = exp2(u_xlat0.xyz);
					    u_xlat0.xyz = min(u_xlat0.xyz, vec3(vec3(unity_MaxOutputValue, unity_MaxOutputValue, unity_MaxOutputValue)));
					    u_xlat0.w = 1.0;
					    u_xlat0 = (unity_MetaFragmentControl.x) ? u_xlat0 : vec4(0.0, 0.0, 0.0, 0.0);
					    SV_Target0 = (unity_MetaFragmentControl.y) ? vec4(0.0, 0.0, 0.0, 1.0) : u_xlat0;
					    return;
					}"
				}
				SubProgram "d3d11 " {
					Keywords { "SHADOWS_CUBE" "DIRLIGHTMAP_COMBINED" "LIGHTMAP_OFF" "DYNAMICLIGHTMAP_OFF" }
					"ps_4_0
					
					#version 330
					#extension GL_ARB_explicit_attrib_location : require
					#extension GL_ARB_explicit_uniform_location : require
					
					#define HLSLCC_ENABLE_UNIFORM_BUFFERS 1
					#if HLSLCC_ENABLE_UNIFORM_BUFFERS
					#define UNITY_UNIFORM
					#else
					#define UNITY_UNIFORM uniform
					#endif
					#define UNITY_SUPPORTS_UNIFORM_LOCATION 1
					#if UNITY_SUPPORTS_UNIFORM_LOCATION
					#define UNITY_LOCATION(x) layout(location = x)
					#define UNITY_BINDING(x) layout(binding = x, std140)
					#else
					#define UNITY_LOCATION(x)
					#define UNITY_BINDING(x) layout(std140)
					#endif
					layout(std140) uniform PGlobals {
						vec4 unused_0_0[4];
						float unity_OneOverOutputBoost;
						float unity_MaxOutputValue;
						vec4 _MainTexture_ST;
						vec4 _Specular_ST;
						vec4 _Color;
						vec4 unused_0_6;
						float _Shadows;
					};
					layout(std140) uniform UnityMetaPass {
						vec4 unused_1_0;
						bvec4 unity_MetaFragmentControl;
						vec4 unused_1_2;
					};
					uniform  sampler2D _MainTexture;
					uniform  sampler2D _Specular;
					in  vec2 vs_TEXCOORD0;
					layout(location = 0) out vec4 SV_Target0;
					vec4 u_xlat0;
					vec3 u_xlat1;
					vec4 u_xlat2;
					float u_xlat9;
					float u_xlat10;
					void main()
					{
					    u_xlat0.xy = vs_TEXCOORD0.xy * _MainTexture_ST.xy + _MainTexture_ST.zw;
					    u_xlat0 = texture(_MainTexture, u_xlat0.xy);
					    u_xlat0.xyz = _Color.xyz * u_xlat0.xyz + vec3(vec3(_Shadows, _Shadows, _Shadows));
					    u_xlat0.xyz = u_xlat0.xyz + vec3(-1.0, -1.0, -1.0);
					    u_xlat0.xyz = clamp(u_xlat0.xyz, 0.0, 1.0);
					    u_xlat1.xyz = u_xlat0.xyz + vec3(-0.220916301, -0.220916301, -0.220916301);
					    u_xlat2.xy = vs_TEXCOORD0.xy * _Specular_ST.xy + _Specular_ST.zw;
					    u_xlat2 = texture(_Specular, u_xlat2.xy);
					    u_xlat9 = u_xlat2.x * 0.449999988;
					    u_xlat10 = (-u_xlat2.x) * 0.350587666 + 0.779083729;
					    u_xlat1.xyz = vec3(u_xlat9) * u_xlat1.xyz + vec3(0.220916301, 0.220916301, 0.220916301);
					    u_xlat1.xyz = u_xlat1.xyz * vec3(0.5, 0.5, 0.5);
					    u_xlat0.xyz = u_xlat0.xyz * vec3(u_xlat10) + u_xlat1.xyz;
					    u_xlat0.xyz = log2(u_xlat0.xyz);
					    u_xlat9 = unity_OneOverOutputBoost;
					    u_xlat9 = clamp(u_xlat9, 0.0, 1.0);
					    u_xlat0.xyz = u_xlat0.xyz * vec3(u_xlat9);
					    u_xlat0.xyz = exp2(u_xlat0.xyz);
					    u_xlat0.xyz = min(u_xlat0.xyz, vec3(vec3(unity_MaxOutputValue, unity_MaxOutputValue, unity_MaxOutputValue)));
					    u_xlat0.w = 1.0;
					    u_xlat0 = (unity_MetaFragmentControl.x) ? u_xlat0 : vec4(0.0, 0.0, 0.0, 0.0);
					    SV_Target0 = (unity_MetaFragmentControl.y) ? vec4(0.0, 0.0, 0.0, 1.0) : u_xlat0;
					    return;
					}"
				}
				SubProgram "d3d11 " {
					Keywords { "SHADOWS_DEPTH" "DIRLIGHTMAP_SEPARATE" "LIGHTMAP_OFF" "DYNAMICLIGHTMAP_OFF" }
					"ps_4_0
					
					#version 330
					#extension GL_ARB_explicit_attrib_location : require
					#extension GL_ARB_explicit_uniform_location : require
					
					#define HLSLCC_ENABLE_UNIFORM_BUFFERS 1
					#if HLSLCC_ENABLE_UNIFORM_BUFFERS
					#define UNITY_UNIFORM
					#else
					#define UNITY_UNIFORM uniform
					#endif
					#define UNITY_SUPPORTS_UNIFORM_LOCATION 1
					#if UNITY_SUPPORTS_UNIFORM_LOCATION
					#define UNITY_LOCATION(x) layout(location = x)
					#define UNITY_BINDING(x) layout(binding = x, std140)
					#else
					#define UNITY_LOCATION(x)
					#define UNITY_BINDING(x) layout(std140)
					#endif
					layout(std140) uniform PGlobals {
						vec4 unused_0_0[4];
						float unity_OneOverOutputBoost;
						float unity_MaxOutputValue;
						vec4 _MainTexture_ST;
						vec4 _Specular_ST;
						vec4 _Color;
						vec4 unused_0_6;
						float _Shadows;
					};
					layout(std140) uniform UnityMetaPass {
						vec4 unused_1_0;
						bvec4 unity_MetaFragmentControl;
						vec4 unused_1_2;
					};
					uniform  sampler2D _MainTexture;
					uniform  sampler2D _Specular;
					in  vec2 vs_TEXCOORD0;
					layout(location = 0) out vec4 SV_Target0;
					vec4 u_xlat0;
					vec3 u_xlat1;
					vec4 u_xlat2;
					float u_xlat9;
					float u_xlat10;
					void main()
					{
					    u_xlat0.xy = vs_TEXCOORD0.xy * _MainTexture_ST.xy + _MainTexture_ST.zw;
					    u_xlat0 = texture(_MainTexture, u_xlat0.xy);
					    u_xlat0.xyz = _Color.xyz * u_xlat0.xyz + vec3(vec3(_Shadows, _Shadows, _Shadows));
					    u_xlat0.xyz = u_xlat0.xyz + vec3(-1.0, -1.0, -1.0);
					    u_xlat0.xyz = clamp(u_xlat0.xyz, 0.0, 1.0);
					    u_xlat1.xyz = u_xlat0.xyz + vec3(-0.220916301, -0.220916301, -0.220916301);
					    u_xlat2.xy = vs_TEXCOORD0.xy * _Specular_ST.xy + _Specular_ST.zw;
					    u_xlat2 = texture(_Specular, u_xlat2.xy);
					    u_xlat9 = u_xlat2.x * 0.449999988;
					    u_xlat10 = (-u_xlat2.x) * 0.350587666 + 0.779083729;
					    u_xlat1.xyz = vec3(u_xlat9) * u_xlat1.xyz + vec3(0.220916301, 0.220916301, 0.220916301);
					    u_xlat1.xyz = u_xlat1.xyz * vec3(0.5, 0.5, 0.5);
					    u_xlat0.xyz = u_xlat0.xyz * vec3(u_xlat10) + u_xlat1.xyz;
					    u_xlat0.xyz = log2(u_xlat0.xyz);
					    u_xlat9 = unity_OneOverOutputBoost;
					    u_xlat9 = clamp(u_xlat9, 0.0, 1.0);
					    u_xlat0.xyz = u_xlat0.xyz * vec3(u_xlat9);
					    u_xlat0.xyz = exp2(u_xlat0.xyz);
					    u_xlat0.xyz = min(u_xlat0.xyz, vec3(vec3(unity_MaxOutputValue, unity_MaxOutputValue, unity_MaxOutputValue)));
					    u_xlat0.w = 1.0;
					    u_xlat0 = (unity_MetaFragmentControl.x) ? u_xlat0 : vec4(0.0, 0.0, 0.0, 0.0);
					    SV_Target0 = (unity_MetaFragmentControl.y) ? vec4(0.0, 0.0, 0.0, 1.0) : u_xlat0;
					    return;
					}"
				}
				SubProgram "d3d11 " {
					Keywords { "SHADOWS_CUBE" "DIRLIGHTMAP_SEPARATE" "LIGHTMAP_OFF" "DYNAMICLIGHTMAP_OFF" }
					"ps_4_0
					
					#version 330
					#extension GL_ARB_explicit_attrib_location : require
					#extension GL_ARB_explicit_uniform_location : require
					
					#define HLSLCC_ENABLE_UNIFORM_BUFFERS 1
					#if HLSLCC_ENABLE_UNIFORM_BUFFERS
					#define UNITY_UNIFORM
					#else
					#define UNITY_UNIFORM uniform
					#endif
					#define UNITY_SUPPORTS_UNIFORM_LOCATION 1
					#if UNITY_SUPPORTS_UNIFORM_LOCATION
					#define UNITY_LOCATION(x) layout(location = x)
					#define UNITY_BINDING(x) layout(binding = x, std140)
					#else
					#define UNITY_LOCATION(x)
					#define UNITY_BINDING(x) layout(std140)
					#endif
					layout(std140) uniform PGlobals {
						vec4 unused_0_0[4];
						float unity_OneOverOutputBoost;
						float unity_MaxOutputValue;
						vec4 _MainTexture_ST;
						vec4 _Specular_ST;
						vec4 _Color;
						vec4 unused_0_6;
						float _Shadows;
					};
					layout(std140) uniform UnityMetaPass {
						vec4 unused_1_0;
						bvec4 unity_MetaFragmentControl;
						vec4 unused_1_2;
					};
					uniform  sampler2D _MainTexture;
					uniform  sampler2D _Specular;
					in  vec2 vs_TEXCOORD0;
					layout(location = 0) out vec4 SV_Target0;
					vec4 u_xlat0;
					vec3 u_xlat1;
					vec4 u_xlat2;
					float u_xlat9;
					float u_xlat10;
					void main()
					{
					    u_xlat0.xy = vs_TEXCOORD0.xy * _MainTexture_ST.xy + _MainTexture_ST.zw;
					    u_xlat0 = texture(_MainTexture, u_xlat0.xy);
					    u_xlat0.xyz = _Color.xyz * u_xlat0.xyz + vec3(vec3(_Shadows, _Shadows, _Shadows));
					    u_xlat0.xyz = u_xlat0.xyz + vec3(-1.0, -1.0, -1.0);
					    u_xlat0.xyz = clamp(u_xlat0.xyz, 0.0, 1.0);
					    u_xlat1.xyz = u_xlat0.xyz + vec3(-0.220916301, -0.220916301, -0.220916301);
					    u_xlat2.xy = vs_TEXCOORD0.xy * _Specular_ST.xy + _Specular_ST.zw;
					    u_xlat2 = texture(_Specular, u_xlat2.xy);
					    u_xlat9 = u_xlat2.x * 0.449999988;
					    u_xlat10 = (-u_xlat2.x) * 0.350587666 + 0.779083729;
					    u_xlat1.xyz = vec3(u_xlat9) * u_xlat1.xyz + vec3(0.220916301, 0.220916301, 0.220916301);
					    u_xlat1.xyz = u_xlat1.xyz * vec3(0.5, 0.5, 0.5);
					    u_xlat0.xyz = u_xlat0.xyz * vec3(u_xlat10) + u_xlat1.xyz;
					    u_xlat0.xyz = log2(u_xlat0.xyz);
					    u_xlat9 = unity_OneOverOutputBoost;
					    u_xlat9 = clamp(u_xlat9, 0.0, 1.0);
					    u_xlat0.xyz = u_xlat0.xyz * vec3(u_xlat9);
					    u_xlat0.xyz = exp2(u_xlat0.xyz);
					    u_xlat0.xyz = min(u_xlat0.xyz, vec3(vec3(unity_MaxOutputValue, unity_MaxOutputValue, unity_MaxOutputValue)));
					    u_xlat0.w = 1.0;
					    u_xlat0 = (unity_MetaFragmentControl.x) ? u_xlat0 : vec4(0.0, 0.0, 0.0, 0.0);
					    SV_Target0 = (unity_MetaFragmentControl.y) ? vec4(0.0, 0.0, 0.0, 1.0) : u_xlat0;
					    return;
					}"
				}
			}
		}
	}
	Fallback "Diffuse"
}