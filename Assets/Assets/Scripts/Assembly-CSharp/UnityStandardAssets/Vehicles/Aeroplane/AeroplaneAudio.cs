using UnityEngine;
using System;

namespace UnityStandardAssets.Vehicles.Aeroplane
{
	public class AeroplaneAudio : MonoBehaviour
	{
		[Serializable]
		public class AdvancedSetttings
		{
			public float engineMinDistance;
			public float engineMaxDistance;
			public float engineDopplerLevel;
			public float engineMasterVolume;
			public float windMinDistance;
			public float windMaxDistance;
			public float windDopplerLevel;
			public float windMasterVolume;
		}

		[SerializeField]
		private AudioClip m_EngineSound;
		[SerializeField]
		private float m_EngineMinThrottlePitch;
		[SerializeField]
		private float m_EngineMaxThrottlePitch;
		[SerializeField]
		private float m_EngineFwdSpeedMultiplier;
		[SerializeField]
		private AudioClip m_WindSound;
		[SerializeField]
		private float m_WindBasePitch;
		[SerializeField]
		private float m_WindSpeedPitchFactor;
		[SerializeField]
		private float m_WindMaxSpeedVolume;
		[SerializeField]
		private AdvancedSetttings m_AdvancedSetttings;
	}
}
