package tests
{
	import mx.rpc.remoting.RemoteObject;
 	import mx.controls.Alert;
    import mx.rpc.events.ResultEvent
    import mx.rpc.events.FaultEvent

	public class PrimitiveTest
	{
		private var summaryObj:Array;
		private var remotePrimitiveTest:RemoteObject;
		private var application:Object;
		
		public function PrimitiveTest(summaryObj:Array, application:Object)
		{
			this.summaryObj = summaryObj;
			this.application = application;
			remotePrimitiveTest = new RemoteObject();
   			remotePrimitiveTest.destination = "PrimitiveTest";
   			remotePrimitiveTest.addEventListener("fault", onFault);
   			
   			remotePrimitiveTest.echoInt.addEventListener("result", echoInt_Result);
   			remotePrimitiveTest.echoLong.addEventListener("result", echoLong_Result);
   			remotePrimitiveTest.echoShort.addEventListener("result", echoShort_Result);
   			remotePrimitiveTest.echoByte.addEventListener("result", echoByte_Result);
   			remotePrimitiveTest.echoDouble.addEventListener("result", echoDouble_Result);
   			remotePrimitiveTest.echoChar.addEventListener("result", echoChar_Result);
   			remotePrimitiveTest.echoBoolean.addEventListener("result", echoBoolean_Result);
   			remotePrimitiveTest.echoDate.addEventListener("result", echoDate_Result);
   			remotePrimitiveTest.echoNull.addEventListener("result", echoNull_Result);
		}
		
		public function onFault (event:FaultEvent):void 
        {
            Alert.show(event.fault.faultString, 'Error');
        }
        
		public function runPrimitiveTests():void
		{
			summaryObj = new Array();
			remotePrimitiveTest.echoInt( 7 );
			remotePrimitiveTest.echoLong( 7777777 );
			remotePrimitiveTest.echoShort( 7 );
			remotePrimitiveTest.echoByte( 7 );
			remotePrimitiveTest.echoDouble( 7777.7777 );
			remotePrimitiveTest.echoChar( 'a' );
			remotePrimitiveTest.echoBoolean( true );
			remotePrimitiveTest.echoDate( new Date( 2004, 1, 1, 1, 1, 1, 1  ) );
			remotePrimitiveTest.echoNull( null );
		}
		
	function echoInt_Result( event:ResultEvent )
	{
		if( event.result == 7 )
		  summaryObj.push( "success: primitives test - echoInt" );
		else
  		  summaryObj.push( "failure: primitives test - echoInt" );
	}
	
	function echoLong_Result( event:ResultEvent )
	{
		if( event.result == 7777777 )
		  summaryObj.push( "success: primitives test - echoLong" );
		else
  		  summaryObj.push( "failure: primitives test - echoLong" );		
	}
	
	function echoShort_Result( event:ResultEvent )
	{
		if( event.result == 7 )
		  summaryObj.push( "success: primitives test - echoShort" );
		else
  		  summaryObj.push( "failure: primitives test - echoShort" );		
	}
	
	function echoByte_Result( event:ResultEvent )
	{
		if( event.result == 7 )
		  summaryObj.push( "success: primitives test - echoByte" );
		else
  		  summaryObj.push( "failure: primitives test - echoByte" );		
	}
	
	function echoDouble_Result( event:ResultEvent )
	{
		if( event.result == 7777.7777 )
		  summaryObj.push( "success: primitives test - echoDouble" );
		else
  		  summaryObj.push( "failure: primitives test - echoDouble" );		
		
	}
	
	function echoChar_Result( event:ResultEvent )
	{
		if( event.result == 'a' )
		  summaryObj.push( "success: primitives test - echoChar" );
		else
  		  summaryObj.push( "failure: primitives test - echoChar" );		
	}
	
	function echoBoolean_Result( event:ResultEvent )
	{
		if( event.result )
		  summaryObj.push( "success: primitives test - echoBoolean" );
		else
  		  summaryObj.push( "failure: primitives test - echoBoolean" );		
	}
	
	function echoDate_Result( event:ResultEvent )
	{
		var dateObj = new Date( 2004, 1, 1, 1, 1, 1, 1 );
		trace( event.result.getTime() );
		trace( dateObj.getTime() );
		
		
		if( event.result.getTime() == dateObj.getTime() )
		  summaryObj.push( "success: primitives test - echoDate" );
		else
  		  summaryObj.push( "failure: primitives test - echoDate" );		
		
	}
	
	function echoNull_Result( event:ResultEvent )
	{
		if( event.result == null )
		  summaryObj.push( "success: primitives test - echoNull" );
		else
  		  summaryObj.push( "failure: primitives test - echoNull" );	
  		  
  		application.setSummary( summaryObj );
	}
	}
}