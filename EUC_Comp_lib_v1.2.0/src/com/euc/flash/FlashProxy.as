package com.euc.flash
{
	public class FlashProxy implements IFlashProxy
	{
		private var _flashMovie:FlashMovie;
		
		public function FlashProxy( flashMovie:IFlashMovie )
		{
			_flashMovie = flashMovie.flash;
		}
		
		public function get flash():FlashMovie
		{
			return _flashMovie;
		}
		
		public function callFlashSetData():void
		{
			_flashMovie.callFlashSetData();
		}
		
		public function callFlashPushXML( xml:XML ):void
		{
			_flashMovie.callFlashPushXML( xml );
		}
		
		public function callFlashPushLoadXML( xmlURL:String ):void
		{
			_flashMovie.callFlashPushLoadXML( xmlURL );
		}
		
		public function callFlashPushBitmapList( bitmapList:Array ):void
		{
			_flashMovie.callFlashPushBitmapList( bitmapList );
		}
		
		public function callFlashPushMoviePathList( moviePathList:Array ):void
		{
			_flashMovie.callFlashPushMoviePathList( moviePathList );
		}
		
		public function callFlashPlay():void
		{
			_flashMovie.callFlashPlay();
		}
		
		public function callFlashStop():void
		{
			_flashMovie.callFlashStop();
		}
		
		public function callFlashDestroy():void
		{
			_flashMovie.callFlashDestroy();
		}
		
		public function returnFlashMessage():String
		{
			return _flashMovie.returnFlashMessage();
		}
		
		public function returnUseFont():Boolean
		{
			return _flashMovie.returnUseFont();
		}
		
		public function returnFontNameList():Array
		{
			return _flashMovie.returnFontNameList();
		}
		
		public function returnFontVarNameList():Array
		{
			return _flashMovie.returnFontVarNameList();
		}
		
		public function returnTextVarNameList():Array
		{
			return _flashMovie.returnTextVarNameList();
		}
	}
}