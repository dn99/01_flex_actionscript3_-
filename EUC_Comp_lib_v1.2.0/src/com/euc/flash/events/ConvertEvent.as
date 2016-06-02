package com.euc.flash.events
{
	import flash.events.Event;

	public class ConvertEvent extends Event
	{
		public static const XML_TO_VO_COMPLETE:String = "xmlToVoComplete";
		public static const VO_TO_XML_COMPLETE:String = "voToXmlComplete";
		public static const XML_TO_VO_EXTERNAL:String = "xmlToVoExternal";
		public static const VO_TO_XML_EXTERNAL:String = "voToXmlExternal";
		
		public var data:*;
		
		/**
		 *  Constructor.
		 */
		public function ConvertEvent( type:String, data:*=null, bubbles:Boolean=false, cancelable:Boolean=false )
		{
			super( type, bubbles, cancelable );
			
			this.data = data;
		}
		
		/**
		 *  override clone.
		 */ 
		override public function clone():Event
		{
			return new ConvertEvent( type, data, bubbles, cancelable );
		}
		
		/**
		 *  override toString.
		 */
		override public function toString():String 
		{
			return formatToString( "ConvertEvent", "type", "bubbles","cancelable", "eventPhase", 
		                           "data", "target", "currentTarget" );
		}
	}
}