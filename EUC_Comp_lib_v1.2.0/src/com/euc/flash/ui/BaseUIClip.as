package com.euc.flash.ui
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.utils.getQualifiedClassName;
	
	import mx.flash.UIMovieClip;

	[Event(name="creationComplete",type="flash.events.Event")]

	public class BaseUIClip extends UIMovieClip implements IManageable, IResizable
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
		public function BaseUIClip()
		{
			init();
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
		 *  init
		 */
		public function init():void
		{
			className = getQualifiedClassName( this ).split('::').pop();
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
			
			setActualSize( w, h );
		}
	}
}