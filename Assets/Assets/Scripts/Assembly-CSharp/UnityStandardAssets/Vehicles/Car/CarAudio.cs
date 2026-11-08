using UnityEngine;

namespace UnityStandardAssets.Vehicles.Car
{
	public class CarAudio : MonoBehaviour
	{
		public enum EngineAudioOptions
		{
			Simple = 0,
			FourChannel = 1,
		}

		public EngineAudioOptions engineSoundStyle;
		public AudioClip lowAccelClip;
		public AudioClip lowDecelClip;
		public AudioClip highAccelClip;
		public AudioClip highDecelClip;
		public float pitchMultiplier;
		public float lowPitchMin;
		public float lowPitchMax;
		public float highPitchMultiplier;
		public float maxRolloffDistance;
		public float dopplerLevel;
		public bool useDoppler;
	}
}
