package com.euc.flash.data.vo
{
	import flash.display.Bitmap;
	import flash.utils.ByteArray;
	
	[Bindable]
	[RemoteClass(alias="com.euc.sf.domain.flash.MovieVO")]
	public class MovieVO
	{
		public var extension:String = "";			// 동영상 확장자 네임
		public var linkPath:String = "";			// 링크 주소 정보 
		public var linkTarget:String = "";			// 링크 타겟 정보
		public var movieHeight:int = 0;				// 동영상 세로 사이즈
		public var movieThumbnailPath:String = "";	// 동영상 썸네일 패스 정보
		public var movieWidth:int = 0;				// 동영상 가로 사이즈
		public var movieIndex:int = 0;				// 동영상 인덱스
		public var movieData:ByteArray;				// 동영상 ByteArray
		public var movieName:String = "";			// 동영상 네임
		public var moviePath:String = "";			// 동영상 패스 정보
	}
}