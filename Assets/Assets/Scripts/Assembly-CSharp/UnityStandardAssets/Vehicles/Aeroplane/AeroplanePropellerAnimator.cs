using UnityEngine;

namespace UnityStandardAssets.Vehicles.Aeroplane
{
	public class AeroplanePropellerAnimator : MonoBehaviour
	{
		[SerializeField]
		private Transform m_PropellorModel;
		[SerializeField]
		private Transform m_PropellorBlur;
		[SerializeField]
		private Texture2D[] m_PropellorBlurTextures;
		[SerializeField]
		private float m_ThrottleBlurStart;
		[SerializeField]
		private float m_ThrottleBlurEnd;
		[SerializeField]
		private float m_MaxRpm;
	}
}
