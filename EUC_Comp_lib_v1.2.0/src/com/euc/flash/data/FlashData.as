package com.euc.flash.data
{
	import com.euc.flash.data.vo.BasicVO;
	import com.euc.flash.data.vo.FileVO;

	[Bindable]
	[RemoteClass(alias="com.euc.sf.domain.flash.FlashData")]
	public class FlashData
	{
		public var basicVO:BasicVO = new BasicVO();		// 기본 정보 VO
		public var fileVO:FileVO = new FileVO();		// 파일 정보 VO
		public var imageVO:Array = [];					// 이미지 정보 VO 배열
		public var movieVO:Array = [];					// 동영상 정보 VO 배열
		public var propVO:Array = [];					// 속성 정보 VO 배열
	}
}