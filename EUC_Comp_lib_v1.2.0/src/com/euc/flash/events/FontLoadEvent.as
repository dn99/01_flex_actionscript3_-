package com.euc.flash.events
{
	import flash.events.Event;

	public class FontLoadEvent extends Event
	{
		public static const LOAD_COMPLETE:String = "loadComplete";
		public static const LOAD_ERROR:String = "loadError";
		
		public var fontNameList:Array;
		
		/**
		 *  Constructor.
		 */
		public function FontLoadEvent( type:String, fontNameList:Array=null, bubbles:Boolean=false, cancelable:Boolean=false )
		{
			super( type, bubbles, cancelable );
			
			this.fontNameList = fontNameList;
		}
		
		/**
		 *  override clone.
		 */ 
		override public function clone():Event
		{
			return new FontLoadEvent( type, fontNameList, bubbles, cancelable );
		}
		
		/**
		 *  override toString.
		 */
		override public function toString():String 
		{
			return formatToString( "FontLoadEvent", "type", "bubbles","cancelable", "eventPhase", 
		                           "data", "target", "currentTarget" );
		}
	}
}