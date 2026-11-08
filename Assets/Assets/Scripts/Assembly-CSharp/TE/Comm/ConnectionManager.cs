using System;

namespace TE.Comm
{
	public class ConnectionManager
	{
		public ConnectionManager(IComm connection, IReceiver onMsgRecieved, Action<ConnectionManager, Exception> generalExceptionAction, Action<ConnectionManager, Msg.DecodeResult, string> onParseError, Action<ConnectionManager> connectionClosed, Action<ConnectionManager, byte[]> byteMsgRecieved)
		{
		}

	}
}
