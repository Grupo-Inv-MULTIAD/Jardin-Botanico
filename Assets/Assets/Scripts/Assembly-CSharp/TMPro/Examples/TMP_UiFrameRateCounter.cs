using UnityEngine;

namespace TMPro.Examples
{
	public class TMP_UiFrameRateCounter : MonoBehaviour
	{
		public enum FpsCounterAnchorPositions
		{
			TopLeft = 0,
			BottomLeft = 1,
			TopRight = 2,
			BottomRight = 3,
		}

		public float UpdateInterval;
		public FpsCounterAnchorPositions AnchorPosition;
	}
}
