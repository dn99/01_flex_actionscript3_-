package com.euc.flash.events
{
	import flash.events.Event;

	public class FlashMovieEvent extends Event
	{
		public static const VAR_VALUE_SEND:String = "varValueSend";
		public static const MESSAGE_RETURN:String = "messageReturn";
		
		public var data:*;
		
		/**
		 *  Constructor.
		 */
		public function FlashMovieEvent( type:String, data:*=null, bubbles:Boolean=false, cancelable:Boolean=false )
		{
			super( type, bubbles, cancelable );
			
			this.data = data;
		}
		
		/**
		 *  override clone.
		 */ 
		override public function clone():Event
		{
			return new FlashMovieEvent( type, data, bubbles, cancelable );
		}
		
		/**
		 *  override toString.
		 */
		override public function toString():String 
		{
			return formatToString( "FlashMovieEvent", "type", "bubbles","cancelable", "eventPhase", 
		                           "data", "target", "currentTarget" );
		}
	}
}