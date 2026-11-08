using UnityEngine;

namespace UnityStandardAssets._2D
{
	public class PlatformerCharacter2D : MonoBehaviour
	{
		[SerializeField]
		private float m_MaxSpeed;
		[SerializeField]
		private float m_JumpForce;
		[SerializeField]
		private float m_CrouchSpeed;
		[SerializeField]
		private bool m_AirControl;
		[SerializeField]
		private LayerMask m_WhatIsGround;
	}
}
