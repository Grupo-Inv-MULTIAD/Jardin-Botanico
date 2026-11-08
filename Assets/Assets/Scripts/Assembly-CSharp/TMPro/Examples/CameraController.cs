using UnityEngine;

namespace TMPro.Examples
{
	public class CameraController : MonoBehaviour
	{
		public enum CameraModes
		{
			Follow = 0,
			Isometric = 1,
			Free = 2,
		}

		public Transform CameraTarget;
		public float FollowDistance;
		public float MaxFollowDistance;
		public float MinFollowDistance;
		public float ElevationAngle;
		public float MaxElevationAngle;
		public float MinElevationAngle;
		public float OrbitalAngle;
		public CameraModes CameraMode;
		public bool MovementSmoothing;
		public bool RotationSmoothing;
		public float MovementSmoothingValue;
		public float RotationSmoothingValue;
		public float MoveSensitivity;
	}
}
