package weborb.tests
{
	[RemoteClass(alias="weborb.tests.Employee")]
	public class Employee
	{
		private var name:String;
		
		public function Employee()
		{
		}
		
		public function get employeeName():String
		{	
			return name;
		}
		
		public function set employeeName(name:String):void
		{	
			this.name = name;
		}
	}
}