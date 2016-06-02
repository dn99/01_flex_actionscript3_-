package com.euc.flash.ui
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.utils.getQualifiedClassName;
	
	[Event(name="creationComplete",type="flash.events.Event")]

	public class BaseClip extends MovieClip implements IManageable, IResizable
	{
		public static const EVENT_CREATION_COMPLETE:String = "creationComplete";
		
		public var debugEnabled:Boolean;
		public var className:String;

		/**
		 *  setter
		 *  children
		 */ 
		public function set children( value:Array ):void 
		{
			for each( var obj:* in value ) 
			{
				var child:DisplayObject = obj as DisplayObject;
				if( child ) 
				{
					addChild( child );					
					try 
					{ 
						this[child['id']] = child; 
					} 
					catch (e:Error) {}
				} 
			}
			
			dispatchEvent( new Event( EVENT_CREATION_COMPLETE, true ) );
		}
		
		/**
		 *  Constructor
		 */ 
		public function BaseClip()
		{
			className = getQualifiedClassName( this ).split('::').pop();
		}
		
		/**
		 *  override enabled
		 */ 
		override public function set enabled( isEnabled:Boolean ):void 
		{
			super.enabled = isEnabled;
			mouseEnabled = isEnabled;
		}

		/**
		 *  override toString()
		 */ 
		override public function toString():String
		{
			return "[" + className+ ":" + name + "]";
		}

		/**
		 *  implements IManageable
		 *  addChildren
		 */ 
		public function addChildren():void 
		{
			
		}

		/**
		 *  implements IManageable
		 *  removeAllChildren
		 */
		public function removeAllChildren():void
		{
			var len:int = numChildren;
			for ( var i:int=0; i<len; i++ )
			{
				removeChildAt( 0 );
			}
		}
		
		/**
		 *  implements IManageable
		 *  debug message
		 */ 
		public function debug( message:* ):void 
		{
			if( debugEnabled ) trace( className + ' ' + message );
		}
		
		/**
		 *  implements IResizable
		 *  setSize
		 */ 
		public function setSize( w:Number, h:Number ):void 
		{
			width = w;
			height = h;
		}
	}
}