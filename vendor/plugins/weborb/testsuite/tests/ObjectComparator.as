package tests
{
	public class ObjectComparator
	{
	
	public static function equals( obj1, obj2 ) : Boolean
	{
		if( (obj1 == undefined || obj1 == null) &&
			(obj2 == undefined || obj2 == null) )
		  return true;
		  
		if( typeof( obj1 ) == "Number" && typeof( obj2 ) == "Number" )
			return obj1 == obj2
		    
		if( typeof( obj1 ) == "function" && 
		    typeof( obj2 ) == "function" &&
			obj1.toString() == obj2.toString() )
			return true;
		
		/*
		if( typeof( obj1.equals ) == "function" )			 
		  return obj1.equals( obj2 );
		*/
			
		if( typeof( obj1 ) != typeof( obj2 ) )
		{
			trace( "object types do not match." );
			trace( "object1 type " + typeof( obj1 ) );			
			trace( "object2 type " + typeof( obj2 ) );						
			trace( "" );
    		return false;
		}

		// array check
		//if( obj1.length != null && 
		//   typeof( obj1.pop ) == "function" &&
		//   obj2.length != null &&
		//   typeof( obj2.pop ) == "function" )
		
		if( typeof( obj1 ) == "Array" && typeof( obj2 ) == "Array" )
		{
			// if the length of the arrays is different, the objects are not equal
			if( obj1.length != obj2.length )
			{
 			  trace( "object1 and object2 are arrays of different lengths" );
			  return false;
			}
			else
			{
		      // iterate over the array elements and recurse this function for each element
			  for( var i = 0; i < obj1.length; i++ )
			    if( !equals( obj1[ i ], obj2[ i ] ) )
				{
	 			  trace( "elements at index " + i + " in the object1 and object2 arrays do not match" );					
	 			  trace( "object1 value - " + obj1[ i ] );
	 			  trace( "object2 value - " + obj2[ i ] );				  
				  return false;
				}
			  
			  return true;
			}
		}										  
		
		for( var name:String in obj1 )
		{
			if( obj2[ name ] == undefined && obj1[ name ] != undefined )
			{
				trace( "object2 does not have field from object1. field name " + name );				
				return false;
			}
	
			if( !( equals( obj1[ name ], obj2[ name ] ) ) )
			{
				trace( "values assigned to the field " + name + " do not match" );								
				trace( "value in object1 - " + obj1[ name ] );				
				trace( "value in object2 - " + obj2[ name ] );								
				trace( "" );
				return false;
			}
		}
		
		
		// if it is not an object or array, use basic equality operator
		if( typeof( obj1 ) != "object" )
		{
			if( obj1 == obj2 )
			  return true;
			else
			{
				trace( "object1 and object2 are non-equal object references" );
				return false;
			}
		}
		else
		{
			return true;
		}
	}
	}
}