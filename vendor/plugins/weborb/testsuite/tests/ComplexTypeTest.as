package tests
{
	import mx.rpc.remoting.RemoteObject;
 	import mx.controls.Alert;
    import mx.rpc.events.ResultEvent;
    import mx.rpc.events.FaultEvent;
    
    import weborb.tests.Employee;
    
	public class ComplexTypeTest
	{
		private var summaryObj:Array;
		private var complexType:ComplexType;
		private var remoteObject:RemoteObject;
		private var application:Object;
		
		private var testString:String = "Joe Orbman";
		
		public function ComplexTypeTest(application:Object)
		{
			this.summaryObj = new Array();
			this.application = application;
			remoteObject = new RemoteObject();
   			remoteObject.destination = "ComplexTypesTest";
   			remoteObject.addEventListener("fault", onFault);
   			
   			//remoteObject.echoComplexType.addEventListener("result", echoComplexType_Result);
   			//remoteObject.echoNullComplexType.addEventListener("result", echoNullComplexType_Result);
   			remoteObject.getEmployee.addEventListener("result", getEmployee_Result);
   			remoteObject.setEmployee.addEventListener("result", setEmployee_Result);
		}
		
		public function onFault (event:FaultEvent):void 
        {
            Alert.show(event.fault.faultString, 'Error');
        }
        
		// ***************** named type declaration *************************

		public function runComplexTypeTests():void
		{
			summaryObj = new Array();
			complexType = new ComplexType( 2 );
			remoteObject.echoComplexType( complexType );
			remoteObject.echoNullComplexType( null );
			remoteObject.getEmployee( testString );
			var emp = new Employee();
			emp.employeeName = testString;
			remoteObject.setEmployee( emp );
		}
		
	function echoComplexType_Result( event:ResultEvent )
	{
		//if( ObjectComparator.equals( event.result, complexType ) )
		if( complexType.equals( event.result ) )
		  summaryObj.push( "success: complex type test - echoComplexType" );
		else
  		  summaryObj.push( "failure: complex type test - echoComplexType" );
  		  
  		application.setSummary( summaryObj );	
	}
	
	function echoNullComplexType_Result( event:ResultEvent )
	{
		if( event.result == null )
		  summaryObj.push( "success: complex type test - echoNullComplexType" );
		else
  		  summaryObj.push( "failure: complex type test - echoNullComplexType" );		
	}
	
	public function getEmployee_Result( event:ResultEvent ):void
	{
		//Alert.show(event.result.toString(), 'Debug');
		var employee:Employee = Employee(event.result);
		
		//if( event.result.employeeName == testString )
		if( employee.employeeName == testString )
		  summaryObj.push( "success: complex type test - getEmployee" );
		else
  		  summaryObj.push( "failure: complex type test - getEmployee" );	
  		  
	  application.setSummary( summaryObj );	
	}	
	
	function setEmployee_Result( event:ResultEvent )
	{
		if( event.result )
		  summaryObj.push( "success: complex type test - setEmployee" );
		else
  		  summaryObj.push( "failure: complex type test - setEmployee" );
  		  
  		application.setSummary( summaryObj );		
	}
	}
}		