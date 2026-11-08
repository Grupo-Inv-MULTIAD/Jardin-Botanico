using UnityEngine;
using UnityEngine.UI;

namespace TE.Sim
{
	public class SimulatedTangible : MonoBehaviour
	{
		public SimulatedTangibleRotationHandle rotateHandle;
		public Color SelectedButtonColor;
		public Color UnselectedButtonColor;
		public Color SelectedTextColor;
		public Color UnselectedTextColor;
		public Graphic OnButtonBg;
		public Graphic OffButtonBg;
		public Graphic OnLabel;
		public Graphic OffLabel;
		public Text PatternText;
	}
}
