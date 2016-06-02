package com.euc.flash.manager
{
	import com.euc.flash.model.BindableModel;
	
	public class DataModelManager extends BindableModel
	{
		private static var _instance:DataModelManager;
		
		private var _property:String;			// 속성 네임
		private var _properties:Array = [];		// 속성 정보 배열
		
		public function DataModelManager( secure:PrivateClass ) {}

		public static function getInstance():DataModelManager
		{
			if( _instance == null ) 
				_instance = new DataModelManager( new PrivateClass() );
			
			return _instance;
		}
		
		public function removeInstance():void
		{
			_instance = null;
		}
		
		/**
		 *  속성 바인딩
		 * 	@param property 속성 네임
		 * 	@param value 속성 값
		 */ 
		public function setBindProperty( property:String, value:* ):void
		{
			_properties.push( property );
			_property = property;
			
			setProperty = value;
		}
		
		/**
		 *  속성 바인딩 추출
		 *  @param property 속성 네임
		 *  @return *
		 */ 
		public function getBindProperty( property:String ):*
		{
			_property = property;
			
			return getProperty;
		}
		
		/**
		 *  속성 추출
		 *  @return *
		 */ 
		private function get getProperty():*
		{
			return get( _property );
		}
		
		/**
		 *  속성 셋팅
		 *  @param value 속성값
		 */ 
		private function set setProperty( value:* ):void
		{
			set( _property, value );
		}
	}
}

class PrivateClass 
{
	public function PrivateClass() {}
}
