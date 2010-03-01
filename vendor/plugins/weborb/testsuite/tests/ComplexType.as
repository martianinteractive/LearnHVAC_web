package tests
{
	import weborb.tests.Employee;
	
	public class ComplexType
	{
	public var number : Number;
	public var date : Date;
	public var str : String;
	public var array : Array;
	public var complexArray : Array;
	public var map : Object;
	public var complexType : ComplexType;
		
	  // primitive fields
	  public var intField;
	  public var floatField;
	  public var longField;
	  public var shortField;
	  public var byteField;
	  public var doubleField;
	
	  // primitive wrappers fields
	  public var intWrapperField;
	  public var floatWrapperField;
	  public var longWrapperField;
	  public var shortWrapperField;
	  public var byteWrapperField;
	  public var doubleWrapperField;
	
	  // string
	  public var stringField;
	  public var stringBufferField;
	
	  // arrays of primitives
	  public var intArrayField;
	  public var shortArrayField;
	  public var longArrayField;
	  public var byteArrayField;
	  public var doubleArrayField;
	  public var floatArrayField;
	
	  // arrays of wrappers
	  public var intWrapperArrayField;
	  public var shortWrapperArrayField;
	  public var longWrapperArrayField;
	  public var byteWrapperArrayField;
	  public var doubleWrapperArrayField;
	  public var floatWrapperArrayField;
	
	  // collections
	  public var collectionField;
	  public var abstractCollectionField;
	  public var listCollectionField;
	  public var abstractListField;
	  public var abstractSequentialListField;
	  public var stackField;
	  public var vectorField;
	  public var linkedLIstField;
	  public var arrayListField;
	  public var setField;
	  public var sortedSetField;
	  public var abstractSetField;
	  public var treeSetField;
	  public var mapSetField;
	  public var abstractMapField;
	  public var propertiesField;
	  public var treeMapField;	
	
	function ComplexType( depth : Number )
	{
		this.number = depth;
		this.date = new Date( 2004 - depth );
		this.str = depth + " ";
		this.array = getArray( depth );
		this.complexArray = getComplexArray( depth );
		this.map = getMap( depth );
		
	  // primitive fields
  	    intField = depth;
	    floatField = depth;
	    longField = depth;
	    shortField = depth;
	    byteField = depth;
	    doubleField = depth;
	
	  // primitive wrappers fields
	    intWrapperField = depth;
	    floatWrapperField = depth;
	    longWrapperField = depth;
	    shortWrapperField = depth;
	    byteWrapperField = depth;
	    doubleWrapperField = depth;
	
	  // string
	    stringField = depth + "";
	    stringBufferField = depth + "";
	
	  // arrays of primitives
	    intArrayField = this.array;
	    shortArrayField = this.array;
	    longArrayField = this.array;
	    byteArrayField = this.array;
	    doubleArrayField = this.array;
	    floatArrayField = this.array;
	
	  // arrays of wrappers
	    intWrapperArrayField = this.array;
	    shortWrapperArrayField = this.array;
	    longWrapperArrayField = this.array;
	    byteWrapperArrayField = this.array;
	    doubleWrapperArrayField = this.array;
	    floatWrapperArrayField = this.array;
	
	  // collections
	    collectionField = this.array;
	    abstractCollectionField = this.array;
	    listCollectionField = this.array;
	    abstractListField = this.array;
	    abstractSequentialListField = this.array;
	    stackField = this.array;
	    vectorField = this.array;
	    linkedLIstField = this.array;
	    arrayListField = this.array;
	    setField = this.array;
	    sortedSetField = this.array;
	    abstractSetField = this.array;
	    treeSetField = this.array;
	    mapSetField = this.map;
	    abstractMapField = this.map;
	    propertiesField = this.map;
	    treeMapField = this.map	;
		
		if( depth > 0 )
		  this.complexType = getComplexType( depth - 1 );
	}
	
	function equals( compType : Object ) : Boolean
	{
		if( compType.number == number &&
		   compType.date.getTime() == date.getTime() &&
		   compType.str == str &&
		   ObjectComparator.equals( compType.array, array ) &&
		   ObjectComparator.equals( compType.complexArray, complexArray ) &&
		   ObjectComparator.equals( compType.map, map ) &&
		   ObjectComparator.equals( complexType, compType.complexType ) &&
		   compType.intField == intField &&
		   compType.floatField == floatField &&
		   compType.longField == longField &&
		   compType.shortField == shortField &&
		   compType.byteField == byteField &&
		   compType.doubleField == doubleField &&
		   compType.intWrapperField == intWrapperField &&
		   compType.floatWrapperField == floatWrapperField &&
		   compType.longWrapperField == longWrapperField &&
		   compType.shortWrapperField == shortWrapperField &&
		   compType.byteWrapperField == byteWrapperField &&
		   compType.doubleWrapperField == doubleWrapperField &&
		   compType.stringField == stringField &&
		   compType.stringBufferField == stringBufferField &&
		   ObjectComparator.equals( compType.intArrayField, intArrayField ) &&
		   ObjectComparator.equals( compType.shortArrayField, shortArrayField ) &&
		   ObjectComparator.equals( compType.longArrayField, longArrayField ) &&
		   ObjectComparator.equals( compType.byteArrayField, byteArrayField ) &&
		   ObjectComparator.equals( compType.doubleArrayField, doubleArrayField ) &&
		   ObjectComparator.equals( compType.floatArrayField, floatArrayField ) &&
		   ObjectComparator.equals( compType.intWrapperArrayField, intWrapperArrayField ) &&
   		   ObjectComparator.equals( compType.shortWrapperArrayField, shortWrapperArrayField ) &&
   		   ObjectComparator.equals( compType.longWrapperArrayField, longWrapperArrayField ) &&
   		   ObjectComparator.equals( compType.byteWrapperArrayField, byteWrapperArrayField ) &&
   		   ObjectComparator.equals( compType.doubleWrapperArrayField, doubleWrapperArrayField ) &&
   		   ObjectComparator.equals( compType.collectionField, collectionField ) &&
   		   ObjectComparator.equals( compType.abstractCollectionField, abstractCollectionField ) &&
   		   ObjectComparator.equals( compType.listCollectionField, listCollectionField ) &&
   		   ObjectComparator.equals( compType.abstractListField, abstractListField ) &&
   		   compType.stackField.length == stackField.length &&
   		   ObjectComparator.equals( compType.vectorField, vectorField ) &&
   		   ObjectComparator.equals( compType.linkedLIstField, linkedLIstField ) &&
   		   ObjectComparator.equals( compType.arrayListField, arrayListField )  &&
   		   compType.setField.length == setField.length  &&
		   compType.sortedSetField.length == sortedSetField.length &&
		   compType.treeSetField.length == treeSetField.length &&				   
   		   ObjectComparator.equals( compType.mapSetField, mapSetField ) &&
   		   ObjectComparator.equals( compType.propertiesField, propertiesField ) &&
   		   ObjectComparator.equals( compType.treeMapField, treeMapField )) 
		return true;
	else
		return false;
	}
	
	static function getComplexType( i )
	{
		if( Cache.complexTypes[ i ] == undefined )
			Cache.complexTypes[ i ] = new ComplexType( i );

		return Cache.complexTypes[ i ];		  
	}
	
	static function getArray( size )
	{
		var array = new Array();
		
		for( var i = 0; i < size; i++ )
		  array.push( i );
		  
		return array;
	}
	
	static function getComplexArray( size )
	{
		if( Cache.complexArrays[ size ] != undefined )
		  return Cache.complexArrays[ size ];
		  
		var complexArray = new Array();
		
		for( var i = 0; i < size; i++ )
		{
			if( i % 2 == 0 )
			  complexArray.push( i + " string object" );
			else if( i % 3 == 0 )
			  complexArray.push( getMap( i ) );
			else if( i % 5 == 0 )
			  complexArray.push( getArray( i ) );
			else
			  complexArray.push( getComplexType( i ) );	
		}
		
		Cache.complexArrays[ size ] = complexArray;
		return complexArray;
	}
	
	static function getMap( size )
	{
		if( Cache.maps[ size ] != undefined )
		  return Cache.maps[ size ];
		
		var map = new Object();
		
		for( var i = 0; i < size ; i++ )
		{
		  
			if( i % 2 == 0 )
				map[ i + "item" ] = i + " string object";	
			else if( i % 3 == 0 )
				map[ i + "item" ] = getMap( i );	
			else if( i % 5 == 0 )
				map[ i + "item" ] = getArray( i );			
			else
			  map[ i + "item" ] = getComplexType( i );
		  
		}
		Cache.maps[ size ] = map;
		return map;
	}
	
	static function getArrayOfObject( depth : Number, object )
	{
		var array = new Array();
		
		for( var i = 0; i < depth; i++ )
		{
			array.push( object );
		}
		
		return array;
	}
	
	static function get2DimArrayOfObject( depth : Number, object )
	{
		var array = [depth];
		
		for( var i = 0; i < depth; i++ )
		{
			array[ i ] = [];
			
		  for( var j = 0; j < depth; j++ )
		  {
		    array[ i ][ j ] = object;
		  }
		}
			
		return array;
	}	
	
	static function get3DimArrayOfObject( depth : Number, object )
	{
		var array = [depth];
		
		for( var i = 0; i < depth; i++ )
		{
			array[ i ] = [];
			
		  for( var j = 0; j < depth; j++ )
		  {
			  array[ i ][ j ] = [];
			  
			  for( var q = 0; q < depth; q++ )		  
				   array[ i ][ j ][ q ] = object;
		  }
		}
			
		return array;
	}
	}
}