using UnityEngine;

namespace TMPro.Examples
{
	public class TMP_TextInfoDebugTool : MonoBehaviour
	{
		public bool ShowCharacters;
		public bool ShowWords;
		public bool ShowLinks;
		public bool ShowLines;
		public bool ShowMeshBounds;
		public bool ShowTextBounds;
		[TextAreaAttribute]
		public string ObjectStats;
	}
}
