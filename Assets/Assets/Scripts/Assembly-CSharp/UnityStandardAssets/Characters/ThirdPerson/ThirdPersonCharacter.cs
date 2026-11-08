using UnityEngine;

namespace UnityStandardAssets.Characters.ThirdPerson
{
	public class ThirdPersonCharacter : MonoBehaviour
	{
		[SerializeField]
		private float m_MovingTurnSpeed;
		[SerializeField]
		private float m_StationaryTurnSpeed;
		[SerializeField]
		private float m_JumpPower;
		[SerializeField]
		private float m_GravityMultiplier;
		[SerializeField]
		private float m_RunCycleLegOffset;
		[SerializeField]
		private float m_MoveSpeedMultiplier;
		[SerializeField]
		private float m_AnimSpeedMultiplier;
		[SerializeField]
		private float m_GroundCheckDistance;
	}
}
