package com.euc.flash.utils
{
	public class FontUtil
	{
		public static const HANGUL:String 			  = "U+AC00-U+D7A3";  // 한글
		public static const NUMBER_CHARS:String       = "U+0030-U+0039";  // 숫자
		public static const UPPERCASE_A_TO_Z:String   = "U+0041-U+005A";  // 영어 대문자
		public static const LOWERCASE_A_TO_Z:String   = "U+0061-U+007A";  // 영어 소문자 
		public static const PERIOD:String             = "U+002E-U+002F";  // Period [., /]
		public static const PUNCTUATION:String        = "U+005B-U+0060";  // Punctuation and 심볼  
		public static const PUNCTUATION_NUMBER:String = "U+0020-U+0040";  // Punctuation, 숫자, 심볼
		
		public static const STANDARD_HANGUL:String    = LOWERCASE_A_TO_Z + ", " + 
														UPPERCASE_A_TO_Z + ", " + 
														HANGUL + ", " + 
														NUMBER_CHARS + ", " + 
														PERIOD;
	}
}