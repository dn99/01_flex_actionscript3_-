package com.euc.flash
{
	public interface IFlashProxy extends IFlashMovie
	{
		/**
		 * 	Interface 구현
		 *  플래시 호출 매서드 : 데이타 변화시 호출
		 */
		function callFlashSetData():void;
		
		/**
		 *  Interface 구현
		 *  플래시 호출 매서드 : 데이타 XML 정보 전달 및 호출
		 * 	@param xml XML.
		 */
		function callFlashPushXML( xml:XML ):void;
		
		/**
		 *  Interface 구현
		 *  플래시 호출 매서드 : 데이타 XML URL 전달 및 호출
		 * 	@param xmlURL XML URL.
		 */
		function callFlashPushLoadXML( xmlURL:String ):void;
		
		/**
		 *  Interface 구현
		 *  플래시 호출 매서드 : 비트맵 배열 전달 및 호출
		 * 	@param bitmapList 비트맵 배열.
		 */
		function callFlashPushBitmapList( bitmapList:Array ):void;
		
		/**
		 *  Interface 구현
		 *  플래시 호출 매서드 : 동영상 패스 배열 전달 및 호출
		 * 	@param bitmapList 동영상 패스 배열.
		 */
		function callFlashPushMoviePathList( moviePathList:Array ):void
		
		/**
		 *  Interface 구현
		 *  플래시 호출 매서드 : 플래시 무비 플레이
		 */
		function callFlashPlay():void;
		
		/**
		 *  Interface 구현
		 *  플래시 호출 매서드 : 플래시 무비 스톱
		 */
		function callFlashStop():void;
		
		/**
		 *  Interface 구현
		 *  플래시 호출 매서드 : 플래시 무비 종료
		 */
		function callFlashDestroy():void;
		
		/**
		 *  Interface 구현
		 *  플래시 반환 매서드 : 플래시 메세지 정보
		 */
		function returnFlashMessage():String;
		
		/**
		 *  Interface 구현
		 *  플래시 반환 매서드 : 폰트 사용 여부
		 */
		function returnUseFont():Boolean;
		
		/**
		 *  Interface 구현
		 *  플래시 반환 매서드 : 폰트 정보
		 */
		function returnFontNameList():Array;
		
		/**
		 *  Interface 구현
		 *  플래시 반환 매서드 : 폰트 변수 정보
		 */
		function returnFontVarNameList():Array;
		
		/**
		 *  Interface 구현
		 *  플래시 반환 매서드 : 텍스트 변수 정보
		 */
		function returnTextVarNameList():Array;
	}
}