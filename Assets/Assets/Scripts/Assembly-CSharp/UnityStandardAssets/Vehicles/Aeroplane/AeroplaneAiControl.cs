using UnityEngine;

namespace UnityStandardAssets.Vehicles.Aeroplane
{
	public class AeroplaneAiControl : MonoBehaviour
	{
		[SerializeField]
		private float m_RollSensitivity;
		[SerializeField]
		private float m_PitchSensitivity;
		[SerializeField]
		private float m_LateralWanderDistance;
		[SerializeField]
		private float m_LateralWanderSpeed;
		[SerializeField]
		private float m_MaxClimbAngle;
		[SerializeField]
		private float m_MaxRollAngle;
		[SerializeField]
		private float m_SpeedEffect;
		[SerializeField]
		private float m_TakeoffHeight;
		[SerializeField]
		private Transform m_Target;
	}
}
