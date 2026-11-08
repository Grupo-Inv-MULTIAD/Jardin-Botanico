using UnityEngine;

namespace UnityStandardAssets.Vehicles.Car
{
	public class CarController : MonoBehaviour
	{
		[SerializeField]
		private CarDriveType m_CarDriveType;
		[SerializeField]
		private WheelCollider[] m_WheelColliders;
		[SerializeField]
		private GameObject[] m_WheelMeshes;
		[SerializeField]
		private WheelEffects[] m_WheelEffects;
		[SerializeField]
		private Vector3 m_CentreOfMassOffset;
		[SerializeField]
		private float m_MaximumSteerAngle;
		[SerializeField]
		private float m_SteerHelper;
		[SerializeField]
		private float m_TractionControl;
		[SerializeField]
		private float m_FullTorqueOverAllWheels;
		[SerializeField]
		private float m_ReverseTorque;
		[SerializeField]
		private float m_MaxHandbrakeTorque;
		[SerializeField]
		private float m_Downforce;
		[SerializeField]
		private SpeedType m_SpeedType;
		[SerializeField]
		private float m_Topspeed;
		[SerializeField]
		private float m_RevRangeBoundary;
		[SerializeField]
		private float m_SlipLimit;
		[SerializeField]
		private float m_BrakeTorque;
	}
}
