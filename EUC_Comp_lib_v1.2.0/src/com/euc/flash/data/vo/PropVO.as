package com.euc.flash.data.vo
{
	[Bindable]
	[RemoteClass(alias="com.euc.sf.domain.flash.PropVO")]
	public class PropVO
	{
		public var propIndex:int = 0;				// 속성 인덱스
		public var propName:String = "";			// 속성 네임
		public var propFormat:String = "";			// 속성 포멧 타입
		
		public var varName:String = "";				// 변수 네임
		public var varType:String = "";				// 변수 타입
		public var varValue:String = "";			// 변수 값
		
		public var varOption:String = "";			// 변수 속성 포멧 타입 옵션
	}
}