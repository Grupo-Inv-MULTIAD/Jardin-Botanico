using System;
using Ideum.Logging;

namespace TE
{
	[Serializable]
	public class TangibleEnginePropertiesData
	{
		public enum Modes
		{
			Simulator = 0,
			Service = 1,
		}

		public Modes Mode;
		public Log.Levels LogLevels;
		public int PortNumber;
	}
}
