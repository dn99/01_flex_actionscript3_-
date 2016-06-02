package com.euc.flash.data.vo
{
	import flash.utils.ByteArray;
	
	[Bindable]
	[RemoteClass(alias="com.euc.sf.domain.flash.FileVO")]
	public class FileVO
	{
		public var dataFLA:ByteArray;				// 플래시 FLA ByteArray
		public var dataSWF:ByteArray;				// 플래시 SWF ByteArray
		public var nameFLA:String = "";				// 플래시 FLA 네임
		public var nameSWF:String = "";				// 플래시 SWF 네임
		public var sizeSWF:int = 0;					// 플래시 SWF 사이즈
	}
}