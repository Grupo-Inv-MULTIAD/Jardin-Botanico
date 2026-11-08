namespace TE.Comm
{
	public class Msg
	{
		public enum MsgTypes
		{
			None = 0,
			Init = 1,
			Patterns = 2,
			Update = 3,
			Error = 4,
		}

		public enum DecodeResult
		{
			Decoded = 0,
			InvalidType = 1,
			MalformedData = 2,
		}

		public MsgTypes Type;
		public bool Status;
		public string DebugText;
		public uint Id;
	}
}
