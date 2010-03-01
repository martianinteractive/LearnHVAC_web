package tests
{
	import mx.rpc.remoting.RemoteObject;
 	import mx.controls.Alert;
    import mx.rpc.events.ResultEvent
    import mx.rpc.events.FaultEvent

    import mx.controls.List;

	public class ArrayOfPrimitivesTest
	{
		private var summaryObj:Array;
		private var remotePrimitiveTest:RemoteObject;
		private var application:Object;
		private var arrayObj:Array;
		
		public function ArrayOfPrimitivesTest(application:Object)
		{
			this.summaryObj = new Array();
			this.application = application;
			remotePrimitiveTest = new RemoteObject();
   			remotePrimitiveTest.destination = "PrimitiveArrayTest";
   			remotePrimitiveTest.addEventListener("fault", onFault);
   			
   			remotePrimitiveTest.echoIntArray.addEventListener("result", echoIntArray_Result);
   			remotePrimitiveTest.echoLongArray.addEventListener("result", echoLongArray_Result);
   			remotePrimitiveTest.echoShortArray.addEventListener("result", echoShortArray_Result);
   			remotePrimitiveTest.echoDoubleArray.addEventListener("result", echoDoubleArray_Result);
   			remotePrimitiveTest.echoByteArray.addEventListener("result", echoByteArray_Result);
   			remotePrimitiveTest.echoBooleanArray.addEventListener("result", echoBooleanArray_Result);
   			remotePrimitiveTest.echoFloatArray.addEventListener("result", echoFloatArray_Result);
   			remotePrimitiveTest.echoEmptyArray.addEventListener("result", echoEmptyArray_Result);
   			remotePrimitiveTest.echoNullArray.addEventListener("result", echoNullArray_Result);
		}
		
		public function onFault (event:FaultEvent):void 
        {
            Alert.show(event.fault.faultString, 'Error');
        }
        
        public function runPrimitiveArraysTests():void
		{
			summaryObj = new Array();
			
			arrayObj = ComplexType.getArray( 2 );
			remotePrimitiveTest.echoIntArray( arrayObj );
			remotePrimitiveTest.echoLongArray( arrayObj );
			remotePrimitiveTest.echoShortArray( arrayObj );
			remotePrimitiveTest.echoDoubleArray( arrayObj );
			remotePrimitiveTest.echoByteArray( arrayObj );	
			remotePrimitiveTest.echoBooleanArray( arrayObj ); 
			remotePrimitiveTest.echoFloatArray( arrayObj );
			remotePrimitiveTest.echoEmptyArray( new Array() );
			remotePrimitiveTest.echoNullArray( null );
		}
		
	function echoIntArray_Result( event:ResultEvent )
	{
		testArray(event, "echoIntArray");
		/*
		var resultArray:Array = Array(event.result);
		var outcome:Boolean = resultArray.length == arrayObj.length;
		
		if( !outcome )
		{
		  summaryObj.push( "failure: primitive array test - echoIntArray, arrays different length" );
		  return;
		}
		
		for( var i:Number = 0; i < resultArray.length; i++ )
		{
			if( resultArray[i] != arrayObj[i] )
				outcome = false;
		}
		
		if( outcome )
		  summaryObj.push( "success: primitive array test - echoIntArray" );
		else
  		  summaryObj.push( "failure: primitive array test - echoIntArray" );
  		  
  		*/
	}
	
	function echoLongArray_Result( event:ResultEvent )
	{
		testArray(event, "echoLongArray");
		/*
		if( ObjectComparator.equals( event.result, arrayObj  ) )
		  summaryObj.push( "success: primitive array test - echoLongArray" );
		else
  		  summaryObj.push( "failure: primitive array test - echoLongArray" );	
  		  */	
	}
	
	function echoShortArray_Result( event:ResultEvent )
	{
		testArray(event, "echoShortArray");
		/*
		if( ObjectComparator.equals( event.result, arrayObj  ) )
		  summaryObj.push( "success: primitive array test - echoShortArray" );
		else
  		  summaryObj.push( "failure: primitive array test - echoShortArray" );		
  		  */
	}
	
	function echoDoubleArray_Result( event:ResultEvent )
	{
		testArray(event, "echoDoubleArray");
		/*
		if( ObjectComparator.equals( event.result, arrayObj  ) )
		  summaryObj.push( "success: primitive array test - echoDoubleArray" );
		else
  		  summaryObj.push( "failure: primitive array test - echoDoubleArray" );		
  		  */
	}
	
	function echoByteArray_Result( event:ResultEvent )
	{
		testArray(event, "echoByteArray");
		/*
		if( ObjectComparator.equals( event.result, arrayObj  ) )
		  summaryObj.push( "success: primitive array test - echoByteArray" );
		else
  		  summaryObj.push( "failure: primitive array test - echoByteArray" );	
  		  */	
	}
	
	function echoBooleanArray_Result( event:ResultEvent )
	{
		testArray(event, "echoBooleanArray");
		/*
		if( event.result.length == arrayObj.length )
		  summaryObj.push( "success: primitive array test - echoBooleanArray" );
		else
  		  summaryObj.push( "failure: primitive array test - echoBooleanArray" );	
  		  */	
	}
	
	function echoFloatArray_Result( event:ResultEvent )
	{
		testArray(event, "echoFloatArray");
		/*
		if( ObjectComparator.equals( event.result, arrayObj  ) )
		  summaryObj.push( "success: primitive array test - echoFloatArray" );
		else
  		  summaryObj.push( "failure: primitive array test - echoFloatArray" );		
  		  */
	}
	
	function echoEmptyArray_Result( event:ResultEvent )
	{
		var resultArray:Array = event.result as Array;
		
		if( resultArray.length == 0 )
		  summaryObj.push( "success: primitive array test - echoEmptyArray" );
		else
  		  summaryObj.push( "failure: primitive array test - echoEmptyArray" );		
	
	}
	
	function echoNullArray_Result( event:ResultEvent )
	{
		if( event.result == null )
		  summaryObj.push( "success: primitive array test - echoNullArray" );
		else
  		  summaryObj.push( "failure: primitive array test - echoNullArray" );
  		  
  	    application.setSummary( summaryObj );		
	}
	
	public function testArray( event:ResultEvent, test:String ):void
	{
		var resultArray:Array = event.result as Array;
		var outcome:Boolean = resultArray.length == arrayObj.length;
		
		if( !outcome )
		{
		  summaryObj.push( "failure: " + test + ", arrays different length, sent: " + arrayObj.length.toString() + " received: " + resultArray.length.toString() );
		  return;
		}
		
		for( var i:Number = 0; i < resultArray.length; i++ )
		{
			if( resultArray[i] != arrayObj[i] )
				outcome = false;
		}
		
		if( outcome )
		  summaryObj.push( "success: primitive array test - " + test  );
		else
  		  summaryObj.push( "failure: primitive array test - " + test );
	}
	
	}
}