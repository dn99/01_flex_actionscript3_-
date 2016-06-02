package com.euc.flash.manager
{
	import com.euc.flash.events.FontLoadEvent;
	import com.euc.flash.fonts.FontLoader;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLRequest;
	import flash.text.Font;
	import flash.utils.ByteArray;

	public class FontLoadManager extends EventDispatcher
	{
		private static var _instance:FontLoadManager;
		
		private var _fontLoader:FontLoader;
		
		private var _fontTotal:int;
		private var _fontCount:int;
		
		public var fontList:Array = [];
		public var fontNameList:Array = [];
		
		public function FontLoadManager( secure:PrivateClass ) {}
		
		public static function getInstance():FontLoadManager
		{
			if( !_instance ) _instance = new FontLoadManager( new PrivateClass() );
			
			return _instance;
		}
		
		public function load( fontURLList:Array ):void
		{
			_fontTotal += fontURLList.length;
			
			_fontLoader = null;
			var request:URLRequest = null;
			for each ( var fontURL:String in fontURLList )
			{
				_fontLoader = new FontLoader();
				_fontLoader.addEventListener( Event.COMPLETE, onFontLoadCompleteHandler );
				_fontLoader.addEventListener( HTTPStatusEvent.HTTP_STATUS, onFontLoadHTTPErroreHandler );
				_fontLoader.addEventListener( IOErrorEvent.IO_ERROR, onFontLoadIOErroreHandler );
				_fontLoader.addEventListener( SecurityErrorEvent.SECURITY_ERROR, onFontLoadSecurityErroreHandler );
				
				request = new URLRequest( fontURL );
				_fontLoader.load( request );
			}
		}
		
		public function loadBytes( fontBytesList:Array ):void
		{
			_fontTotal += fontBytesList.length;
			
			_fontLoader = null;
			var request:URLRequest = null;
			for each ( var bytes:ByteArray in fontBytesList )
			{
				_fontLoader = new FontLoader();
				_fontLoader.addEventListener( Event.COMPLETE, onFontLoadCompleteHandler );
				_fontLoader.addEventListener( HTTPStatusEvent.HTTP_STATUS, onFontLoadHTTPErroreHandler );
				_fontLoader.addEventListener( IOErrorEvent.IO_ERROR, onFontLoadIOErroreHandler );
				_fontLoader.addEventListener( SecurityErrorEvent.SECURITY_ERROR, onFontLoadSecurityErroreHandler );
				
				_fontLoader.loadBytes( bytes );
			}
		}
		
		private function dispatchFontLoadEvent( isComplete:Boolean ):void
		{
			var e:FontLoadEvent = null;
			if ( isComplete ) e = new FontLoadEvent( FontLoadEvent.LOAD_COMPLETE, fontNameList );
			else			  e = new FontLoadEvent( FontLoadEvent.LOAD_ERROR );
			
			dispatchEvent( e );
		}
		
		private function onFontLoadCompleteHandler( event:Event ):void
		{
			_fontCount++;
			
			var fonts:Array = event.target.fonts;
			if ( _fontCount != _fontTotal ) 
			{
				fontList = fontList.concat( fonts );
				return;	
			}
			
			for each ( var font:Font in fontList )
			{
				fontNameList.push( font.fontName );
			}
			
			_fontCount = 0;
			_fontTotal = 0;
			dispatchFontLoadEvent( true );
		}
		
		private function onFontLoadHTTPErroreHandler( event:HTTPStatusEvent ):void
		{
			trace( "FONT LOAD HTTP STATUS ERROR " );
			dispatchFontLoadEvent( false );
		}
		
		private function onFontLoadIOErroreHandler( event:IOErrorEvent ):void
		{
			trace( "FONT LOAD IO ERROR " );
			dispatchFontLoadEvent( false );
		}
		
		private function onFontLoadSecurityErroreHandler( event:SecurityErrorEvent ):void
		{
			trace( "FONT LOAD SECURITY ERROR " );
			dispatchFontLoadEvent( false );
		}
	}
}

class PrivateClass 
{
	public function PrivateClass() {}
}