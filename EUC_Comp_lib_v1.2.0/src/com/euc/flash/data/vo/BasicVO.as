package com.euc.flash.data.vo
{
	import flash.utils.ByteArray;
	
	[Bindable]
	[RemoteClass(alias="com.euc.sf.domain.flash.BasicVO")]
	public class BasicVO
	{
		public var titleKO:String = "";				// 컴포넌트 한글 타이틀
		public var titleEN:String = "";				// 컴포넌트 영문 타이틀
		public var cateServiceType:String = "";		// 카테고리 서비스 타입
		public var cateUseInfo:String = "";			// 카테고리 사용 용도
		public var compDescription:String = "";		// 컴포넌트 설명
		public var compImageData:ByteArray;			// 컴포넌트 대표 이미지
		public var compImageName:String = "";		// 컴포넌트 대표 이미지 네임
		public var extension:String = "";			// 컴포넌트 대표 이미지 확장자 네임
		public var infoDescription:String = "";		// 사용자 컴포넌트 설명	
		public var infoTitle:String = "";			// 사용자 컴포넌트 타이틀
		
		public var swfWidth:int = 0;				// 플래시 width
		public var swfHeight:int = 0;				// 플래시 height
		public var stageColor:uint = 0;				// 배경 컬러
		public var stageAlpha:Number = 0.0;			// 배경 투명도
		public var subType:String = "";				// 서브 타입
		public var fontVO:Array = [];				// 사용 폰트 정보
	}
}