package com.euc.flash.data.vo
{
	import flash.display.Bitmap;
	import flash.utils.ByteArray;
	
	[Bindable]
	[RemoteClass(alias="com.euc.sf.domain.flash.ImageVO")]
	public class ImageVO
	{
		public var imageIndex:int = 0;				// 이미지 인덱스
		public var imageBitmap:Bitmap;				// 이미지 비트맵 
		public var imageData:ByteArray;				// 이미지 ByteArray
		public var imageName:String = "";			// 이미지 네임
		
		public var imagePath:String = "";			// 이미지 패스 정보
		public var linkTarget:String = "";			// 링크 타겟 정보
		public var linkPath:String = "";			// 링크 주소 정보 
		
		public var extension:String = "";			// 이미지 확장자 네임
	}
}