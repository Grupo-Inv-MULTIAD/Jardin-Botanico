using UnityEngine;

namespace TMPro.Examples
{
	public class TMP_ExampleScript_01 : MonoBehaviour
	{
		public enum objectType
		{
			TextMeshPro = 0,
			TextMeshProUGUI = 1,
		}

		public objectType ObjectType;
		public bool isStatic;
	}
}
