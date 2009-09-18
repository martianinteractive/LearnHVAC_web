package tests
{
	import mx.rpc.remoting.RemoteObject;
 	import mx.controls.Alert;
    import mx.rpc.events.ResultEvent
    import mx.rpc.events.FaultEvent
    
	public class StringTest
	{
		private var summaryObj:Array;
		private var remoteObject:RemoteObject;
		private var application:Object;
		
		private var testString:String = "Olá fazendo teste de ão é tõa ê";
		//private var testString:String = "WebORB Rocks";
		
		public function StringTest(application:Object)
		{
			this.summaryObj = new Array();
			this.application = application;
			remoteObject = new RemoteObject();
   			remoteObject.destination = "StringsTest";
   			remoteObject.addEventListener("fault", onFault);
   			
   			remoteObject.echoString.addEventListener("result", echoString_Result);
   			remoteObject.echoNullString.addEventListener("result", echoNullString_Result);
   			remoteObject.echoStringBuilder.addEventListener("result", echoStringBuilder_Result);
   			remoteObject.echoNullStringBuilder.addEventListener("result", echoNullStringBuilder_Result);
		}
		
		public function onFault (event:FaultEvent):void 
        {
            Alert.show(event.fault.faultString, 'Error');
        }
        
		public function runStringTests():void
		{
			summaryObj = new Array();
			remoteObject.echoString( testString );
			remoteObject.echoNullString( null );
			remoteObject.echoStringBuilder( testString );
			remoteObject.echoNullStringBuilder( null );
		}
		
	function echoString_Result( event:ResultEvent )
	{
		if( event.result == testString )
		  summaryObj.push( "success: strings test - echoString: " + event.result.toString() );
		else
  		  summaryObj.push( "failure: strings test - echoString" );
	}
	
	function echoNullString_Result( event:ResultEvent )
	{
		if( event.result == null )
		  summaryObj.push( "success: strings test - echoNullString" );
		else
  		  summaryObj.push( "failure: strings test - echoNullString" );		
	}
	
	function echoStringBuilder_Result( event:ResultEvent )
	{
		if( event.result == testString )
		  summaryObj.push( "success: strings test - echoStringBuilder" );
		else
  		  summaryObj.push( "failure: strings test - echoStringBuilder" );		
	}	
	
	function echoNullStringBuilder_Result( event:ResultEvent )
	{
		if( event.result == null )
		  summaryObj.push( "success: strings test - echoNullStringBuilder" );
		else
  		  summaryObj.push( "failure: strings test - echoNullStringBuilder" );
  		  
  		application.setSummary( summaryObj );		
	}
	}
}