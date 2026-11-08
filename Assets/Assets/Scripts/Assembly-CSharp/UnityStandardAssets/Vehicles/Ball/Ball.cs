using UnityEngine;

namespace UnityStandardAssets.Vehicles.Ball
{
	public class Ball : MonoBehaviour
	{
		[SerializeField]
		private float m_MovePower;
		[SerializeField]
		private bool m_UseTorque;
		[SerializeField]
		private float m_MaxAngularVelocity;
		[SerializeField]
		private float m_JumpPower;
	}
}
