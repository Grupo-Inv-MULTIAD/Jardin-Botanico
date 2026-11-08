using UnityEngine;

namespace UnityStandardAssets._2D
{
	public class Camera2DFollow : MonoBehaviour
	{
		public Transform target;
		public float damping;
		public float lookAheadFactor;
		public float lookAheadReturnSpeed;
		public float lookAheadMoveThreshold;
	}
}
