using UnityEngine;

namespace TMPro.Examples
{
	public class ObjectSpin : MonoBehaviour
	{
		public enum MotionType
		{
			Rotation = 0,
			BackAndForth = 1,
			Translation = 2,
		}

		public float SpinSpeed;
		public int RotationRange;
		public MotionType Motion;
	}
}
