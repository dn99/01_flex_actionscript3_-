package com.euc.flash.utils
{
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	public class TextUtil
	{
		public static function getTextField( text:String, isEmebed:Boolean=false, 
											 selectable:Boolean=false, mouseEnabled:Boolean=false ):TextField
		{
			var textField:TextField = new TextField();
			
			textField.selectable = selectable;
			textField.mouseEnabled = mouseEnabled;
			textField.autoSize = TextFieldAutoSize.LEFT;
			textField.text = text;
			
			if ( isEmebed )
			{
				textField.embedFonts = true;
				textField.antiAliasType = AntiAliasType.ADVANCED;
			}
			
			return textField;
		}
		
		public static function getTextForamt( fontName:String, fontSize:Object, 
									   		  fontColor:Object, fontSpacing:Object=null ):TextFormat 
		{
			var textFormat:TextFormat = new TextFormat();
			
			textFormat.font = fontName;
			textFormat.size = fontSize;
			textFormat.color = fontColor;
			
			if ( fontSpacing ) textFormat.letterSpacing = fontSpacing;
			
			return textFormat;
		}
	}
}