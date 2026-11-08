using UnityEngine;
using System;
using UnityEngine.UI;
using UnityEngine.EventSystems;

namespace UnityStandardAssets.SceneUtils
{
	public class ParticleSceneControls : MonoBehaviour
	{
		[Serializable]
		public class DemoParticleSystem
		{
			public Transform transform;
			public ParticleSceneControls.Mode mode;
			public ParticleSceneControls.AlignMode align;
			public int maxCount;
			public float minDist;
			public int camOffset;
			public string instructionText;
		}

		[Serializable]
		public class DemoParticleSystemList
		{
			public ParticleSceneControls.DemoParticleSystem[] items;
		}

		public enum Mode
		{
			Activate = 0,
			Instantiate = 1,
			Trail = 2,
		}

		public enum AlignMode
		{
			Normal = 0,
			Up = 1,
		}

		public DemoParticleSystemList demoParticles;
		public float spawnOffset;
		public float multiply;
		public bool clearOnChange;
		public Text titleText;
		public Transform sceneCamera;
		public Text instructionText;
		public Button previousButton;
		public Button nextButton;
		public GraphicRaycaster graphicRaycaster;
		public EventSystem eventSystem;
	}
}
