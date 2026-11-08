using UnityEngine;

namespace TMPro.Examples
{
	public class TMPro_InstructionOverlay : MonoBehaviour
	{
		public enum FpsCounterAnchorPositions
		{
			TopLeft = 0,
			BottomLeft = 1,
			TopRight = 2,
			BottomRight = 3,
		}

		public FpsCounterAnchorPositions AnchorPosition;
	}
}
