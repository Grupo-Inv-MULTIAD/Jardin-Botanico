using UnityEngine;

namespace UnityStandardAssets.Vehicles.Aeroplane
{
	public class AeroplaneController : MonoBehaviour
	{
		[SerializeField]
		private float m_MaxEnginePower;
		[SerializeField]
		private float m_Lift;
		[SerializeField]
		private float m_ZeroLiftSpeed;
		[SerializeField]
		private float m_RollEffect;
		[SerializeField]
		private float m_PitchEffect;
		[SerializeField]
		private float m_YawEffect;
		[SerializeField]
		private float m_BankedTurnEffect;
		[SerializeField]
		private float m_AerodynamicEffect;
		[SerializeField]
		private float m_AutoTurnPitch;
		[SerializeField]
		private float m_AutoRollLevel;
		[SerializeField]
		private float m_AutoPitchLevel;
		[SerializeField]
		private float m_AirBrakesEffect;
		[SerializeField]
		private float m_ThrottleChangeSpeed;
		[SerializeField]
		private float m_DragIncreaseFactor;
	}
}
