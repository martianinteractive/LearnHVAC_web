package tests
{
	import mx.rpc.remoting.RemoteObject;
 	import mx.controls.Alert;
    import mx.rpc.events.ResultEvent;
    import mx.rpc.events.FaultEvent;

	public class MultipleArgsTest
	{
		private var summaryObj:Array;
		private var remoteObject:RemoteObject;
		private var application:Object;
		private var TEST_SIZE:Number = 2;
		
		public function MultipleArgsTest(application:Object)
		{
			this.summaryObj = new Array();
			this.application = application;
			remoteObject = new RemoteObject();
   			remoteObject.destination = "MultipleArgsTest";
   			remoteObject.addEventListener("fault", onFault);
   			
   			remoteObject.echoInts.addEventListener("result", echoInts_Result);
   			remoteObject.echoShorts.addEventListener("result", echoShorts_Result);
   			remoteObject.echoIntLongs.addEventListener("result", echoIntLongs_Result);
   			remoteObject.echoIntString.addEventListener("result", echoIntString_Result);
   			remoteObject.echoIntNullString.addEventListener("result", echoIntNullString_Result);
   			remoteObject.echoCharString.addEventListener("result", echoCharString_Result);
   			remoteObject.echoStringBuilderDouble.addEventListener("result", echoStringBuilderDouble_Result);
   			remoteObject.echoNullStringBuilderDouble.addEventListener("result", echoNullStringBuilderDouble_Result);
   			remoteObject.echoLotsOfArgs.addEventListener("result", echoLotsOfArgs_Result);
		}
		
		public function onFault (event:FaultEvent):void 
        {
            Alert.show(event.fault.faultString, 'Error');
        }
        
		public function runMultipleArgsTests():void
		{
			summaryObj = new Array();
			remoteObject.echoInts( 21, 0, -12312, 11111111 );
			remoteObject.echoShorts( 2, 222, -201 );
			remoteObject.echoIntLongs( 21, 21 );
			
			remoteObject.echoIntString( 21, "foobar" );
			remoteObject.echoIntNullString( 21, null );
			remoteObject.echoCharString( 'a', "s" );	
			remoteObject.echoStringBuilderDouble( "flashorb rocks", 21 );
			remoteObject.echoNullStringBuilderDouble( null, 21 );
			
			
			var compArray:Array = ComplexType.getComplexArray( TEST_SIZE );
			
			remoteObject.echoLotsOfArgs( ComplexType.getArray( TEST_SIZE ),
						    compArray,
							ComplexType.getMap( TEST_SIZE ),
							new ComplexType( TEST_SIZE ),
							21,
							"21", 
							null, 
							new Date( 2004, 1, 1, 1, 1, 1, 1 ), 
							'a' );
			
		}	
		
	public function echoInts_Result( event:ResultEvent ):void
	{
		if( event.result[ 0 ] == 21 &&
		    event.result[ 1 ] == 0 &&
			event.result[ 2 ] == -12312 &&
			event.result[ 3 ] == 11111111 )
		 summaryObj.push( "success: multiple args test - echoInts" );
		else
		 summaryObj.push( "failure: multiple args test - echoInts" );		
	}
		
	function echoShorts_Result( event:ResultEvent )
	{
		if( event.result[ 0 ] == 2 &&
		    event.result[ 1 ] == 222 &&
			event.result[ 2 ] == -201 )
		 summaryObj.push( "success: multiple args test - echoShorts" );
		else
		 summaryObj.push( "failure: multiple args test - echoShorts" );		
	}
	
	function echoIntLongs_Result( event:ResultEvent )
	{
		if( event.result[ 0 ] == 21 &&
		    event.result[ 1 ] == 21 )
		 summaryObj.push( "success: multiple args test - echoIntLongs" );
		else
		 summaryObj.push( "failure: multiple args test - echoIntLongs" );		
	}
	
	function echoIntString_Result( event:ResultEvent )
	{
		if( event.result[ 0 ] == 21 &&
		    event.result[ 1 ] == "foobar" )
		 summaryObj.push( "success: multiple args test - echoIntString" );
		else
		 summaryObj.push( "failure: multiple args test - echoIntString" );				
	}
	
	public function echoIntNullString_Result( event:ResultEvent ):void
	{
		if( event.result[ 0 ] == 21 &&
		    event.result[ 1 ] == null )
		 summaryObj.push( "success: multiple args test - echoIntNullString" );
		else
		 summaryObj.push( "failure: multiple args test - echoIntNullString" );			
	}
	
	public function echoCharString_Result( event:ResultEvent ):void
	{
		if( event.result[ 0 ] == 'a' &&
		    event.result[ 1 ] == "s" )
		 summaryObj.push( "success: multiple args test - echoCharString" );
		else
		 summaryObj.push( "failure: multiple args test - echoCharString" );				
	}
	
	public function echoStringBuilderDouble_Result( event:ResultEvent ):void
	{
		if( event.result[ 0 ] == "flashorb rocks" &&
		    event.result[ 1 ] == 21 )
		 summaryObj.push( "success: multiple args test - echoStringBuilderDouble" );
		else
		 summaryObj.push( "failure: multiple args test - echoStringBuilderDouble" );				
	}
	
	public function echoNullStringBuilderDouble_Result( event:ResultEvent ):void
	{
		if( event.result[ 0 ] == null &&
		    event.result[ 1 ] == 21 )
		 summaryObj.push( "success: multiple args test - echoNullStringBuilderDouble" );
		else
		 summaryObj.push( "failure: multiple args test - echoNullStringBuilderDouble" );				
		 
	 application.setSummary( summaryObj );	
	}
	
	public function echoLotsOfArgs_Result( event:ResultEvent ):void
	{
		if( ObjectComparator.equals( ComplexType.getArray( TEST_SIZE ), event.result[ 0 ] ) &&
		    ObjectComparator.equals( ComplexType.getComplexArray( TEST_SIZE ), event.result[ 1 ] ) &&
			ObjectComparator.equals( ComplexType.getMap( TEST_SIZE ), event.result[ 2 ] ) &&
			ObjectComparator.equals( new ComplexType( TEST_SIZE ), event.result[ 3 ]  ) &&
			event.result[ 4 ] == 21 &&
			event.result[ 5 ] == "21" &&
			event.result[ 6 ] == null &&			
			event.result[ 7 ].getTime() == new Date( 2004, 1, 1, 1, 1, 1, 1 ).getTime() &&
			event.result[ 8 ] == 'a' )			
		 summaryObj.push( "success: multiple args test - echoLotsOfArgs" );
		else
		 summaryObj.push( "failure: multiple args test - echoLotsOfArgs" );	
		 
	 application.setSummary( summaryObj );			
	}
	}
}