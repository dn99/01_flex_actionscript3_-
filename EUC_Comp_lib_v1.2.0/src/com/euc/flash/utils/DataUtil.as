package com.euc.flash.utils
{
	import flash.utils.ByteArray;
	
	import mx.collections.ArrayCollection;
	import mx.collections.Sort;
	import mx.collections.SortField;
	
	/**
	 *  DataUtil
	 */ 
	public class DataUtil
	{
		/**
		 *  필드명에 따른 소트 반환
		 *  @param fieldName 소트할 필드명.
		 *  @param descending 역순여부, default false.
		 *  @return Sort
		 */ 		
		public static function getSortArrange( fieldName:String, descending:Boolean=false ):Sort
		{
			var sort:Sort = new Sort();
			var sortField:SortField = new SortField();
			sortField.name = fieldName;
			sortField.descending = descending;
			
			sort.fields = [sortField];
			
			return sort;
		}
		
		/**
		 *  멀티 필드의 값들에 따라 정렬된 데이타 반환
		 *  @param orginData 정렬할 오리지널 데이타.
		 *  @param keyFieldArr 멀티 필드 배열.
		 *  @param keyValueArr 멀티 필드 값 배열.
		 *  @param isEqual 같은 데이타 인지 여부.
		 *  @return ArrayCollection
		 */ 
		public static function getFilterMultiData( orginData:ArrayCollection, keyFieldArr:Array, keyValueArr:Array, isEqual:Boolean ):ArrayCollection
		{
			var data:ArrayCollection = orginData;
			
			var len:int = keyFieldArr.length;
			for ( var i:int=0; i<len; i++ )
			{
				data = DataUtil.getFilterData( data, keyFieldArr[i], keyValueArr[i], isEqual );
			}
			
			return data;
		}
		
		/**
		 *  필드의 값에 따라 정렬된 데이타 반환
		 *  @param orginData 정렬할 오리지널 데이타.
		 *  @param keyField  필드.
		 *  @param keyValue 필드 값.
		 *  @param isEqual 같은 데이타 인지 여부.
		 *  @return ArrayCollection
		 */ 
		public static function getFilterData( orginData:ArrayCollection, keyField:String, keyValue:Object, isEqual:Boolean ):ArrayCollection
		{
			var data:ArrayCollection = new ArrayCollection();
			
			if ( keyValue == "" || keyValue == null )
			{
				if ( isEqual ) data = orginData;

				return data;
			}
			
			for each ( var item:Object in orginData )
			{
				if ( isEqual && item[keyField] != keyValue ) continue;
				if ( !isEqual && item[keyField] == keyValue ) continue;
				data.addItem( item );
			}

			return data;
		}
		
		/**
		 *  멀티 필드의 값과 같은 필드 값이 있는지 여부 반환
		 *  @param data 비교 대상 데이타.
		 *  @param keyFieldArr 멀티 필드 배열.
		 *  @param keyValueArr 멀티 필드 값 배열.
		 *  @return Boolean
		 */ 
		public static function isContainMultiData( data:ArrayCollection, keyFieldArr:Array, keyValueArr:Array ):Boolean
		{
			var isContain:Boolean = false;
			
			var len:int = keyFieldArr.length;
			for ( var i:int=0; i<len; i++ )
			{
				isContain = DataUtil.isContainData( data, keyFieldArr[i], keyValueArr[i] );

				if ( !isContain ) return isContain;
			}
			
			return isContain;
		}
		
		/**
		 *  필드의 값과 같은 필드 값이 있는지 여부 반환
		 *  @param data 비교 대상 데이타.
		 *  @param keyField 필드.
		 *  @param keyValue 필드 값.
		 *  @return Boolean
		 */ 
		public static function isContainData( data:ArrayCollection, keyField:String, keyValue:Object):Boolean
		{
			if ( keyValue == "" || keyValue == null )
			{
				return true;
			}
			
			for each ( var item:Object in data )
			{
				if ( item[ keyField ] == keyValue ) return true;
			}
			
			return false;
		}
		
		/**
		 *  배열 Deep 복사
		 *  @param originArr 정렬할 오리지널 배열.
		 *  @return Array
		 */ 
		public static function cloneArray( originArr:Array ):Array
		{
			var arr:Array = [];
			for each ( var item:* in originArr )
			{
				arr.push( item );
			}
			
			return arr;
		}
		
		/**
		 *  두개의 배열을 비교하여 매치하는 지 여부 반환
		 *  @param source 소스 배열
		 *  @param target 비교 대상 배열
		 */ 
		public static function matchArr( source:Array, target:Array ):Boolean
		{
			if ( source.length != target.length ) return false;
			
			return source.every( function( e:*, i:int, a:Array ):Boolean {
									 return e == target[i];
								 } );
		}
		
		/**
		 *  오브제트 복사
		 *  @param value 카피할 대상 오브젝트.
		 *  @return Object
		 */
		public static function clone( value:Object ):Object
	    {
	        var buffer:ByteArray = new ByteArray();
	        buffer.writeObject(value);
	        buffer.position = 0;
	        var result:Object = buffer.readObject();
	        
	        return result;
	    }
	}
}