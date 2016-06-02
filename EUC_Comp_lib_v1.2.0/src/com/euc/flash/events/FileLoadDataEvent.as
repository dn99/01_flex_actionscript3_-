package com.euc.flash.events
{
	import flash.events.Event;
	
	public class FileLoadDataEvent extends Event
	{
		public static const FILE_SELECT:String = "fileSelect";
		public static const FILE_COMPLETE:String = "fileComplete";
		public static const LOADER_COMPLETE:String = "loaderComplete";
		public static const UPLOAD_COMPLETE:String = "uploadComplete";
		public static const ERROR_DATA:String = "errorData";
		public static const LIMIT_OUT:String = "limitOut";
		
		public var data:*;
		
		/**
		 *  Constructor.
		 */
		public function FileLoadDataEvent( type:String, data:*=null, bubbles:Boolean=false, cancelable:Boolean=false )
		{
			super( type, bubbles, cancelable );
			
			this.data = data;
		}
		
		/**
		 *  override clone.
		 */ 
		override public function clone():Event
		{
			return new FileLoadDataEvent( type, data, bubbles, cancelable );
		}
		
		/**
		 *  override toString.
		 */
		override public function toString():String 
		{
			return formatToString( "FileLoadDataEvent", "type", "bubbles","cancelable", "eventPhase", 
		                           "data", "target", "currentTarget" );
		}

	}
}