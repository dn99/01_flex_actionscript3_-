package com.euc.flash.utils
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filters.ColorMatrixFilter;
	import flash.geom.ColorTransform;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.net.registerClassAlias;
	import flash.system.Capabilities;
	import flash.utils.ByteArray;
	
	import mx.utils.ObjectUtil;
	
	public class DisplayObjectUtil
	{
		/**
		 *  모든 자식 객체 제거
		 *  @param 자식을 담은 부모 컨테이너.
		 */ 
		public static function removeAllChildren( target:DisplayObjectContainer ):void
		{
			var len:int = target.numChildren;
			for ( var i:int=0; i<len; i++ )
			{
				target.removeChildAt( 0 );
			}
		}
		
		/**
		 *  가운데 위치 정렬
		 *  @param parent 부모 객체.
		 *  @param target 가운데 위치할 자식 객체.
		 */ 
		public static function setPosCenter(parent:DisplayObject, target:DisplayObject):void
		{
			target.x = Math.round( parent.width / 2 ) - Math.round( target.width / 2 );
			target.y = Math.round( parent.height / 2 ) - Math.round( target.height / 2 );
		}
		
		/**
		 *  가운데 위치 좌표
		 *  @param parent 부모 객체.
		 *  @param targetSize 자식 객체 사이즈.
		 *  @return int.
		 */ 
		public static function getCoordinateCenter(parentSize:int, targetSize:int):int
		{
			return Math.round( parentSize / 2 ) - Math.round( targetSize / 2 );
		}
		
		/**
		 *  컬러 변화 셋팅
		 *  @param target 컬러 변화줄 타겟 객체.
		 *  @param color 컬러.
		 */ 
		public static function setColorTransform( target:DisplayObject, color:uint ):void
		{
			var colorTransform:ColorTransform = new ColorTransform();
			colorTransform.color = color;
			
			target.transform.colorTransform = colorTransform;
		}
		
		/**
		 *  색으로 채운  각진 사각 영역 생성
		 *  @param target 영역 생성해줄 객체.
		 *  @param width 사각 영역 width.
		 *  @param height 사각 영역 height.
		 *  @param color 사각 영역 컬러, 디폴트 0xFFFFFF.
		 *  @param alpha 사각 영역 투명도, 디폴트 1.
		 */ 
		public static function fillRect( target:Sprite, width:int, height:int, color:uint=0xFFFFFF, alpha:Number=1, 
										 isBorder:Boolean=false, borderThickness:int=1, borderColor:uint=0x000000, borderAlpha:Number=1  ):void
		{
			target.graphics.clear();
			
			if (isBorder) 
			{
				target.graphics.lineStyle( borderThickness, borderColor, borderAlpha );
			}
			
			target.graphics.beginFill( color, alpha );
			target.graphics.drawRect( 0, 0, width, height );
			target.graphics.endFill();
		}
		
		/**
		 *  색으로 채운 라운드 진 사각 영역 생성
		 *  @param target 영역 생성해줄 객체.
		 *  @param width 사각 영역 width.
		 *  @param height 사각 영역 height.
		 *  @param ellipse 라운드 수치.
		 *  @param color 사각 영역 컬러, 디폴트 0xFFFFFF.
		 *  @param alpha 사각 영역 투명도, 디폴트 1.
		 *  @param isBorder 테두리 유무, 디폴트 테두리없음.
		 *  @param borderThickness 테두리 굵기, 디폴트 1.
		 *  @param borderColor 테두리 색상, 디폴트 0x000000.
		 *  @param borderAlpha 테두리 투명도, 디폴트 1.
		 */
		public static function fillRoundRect( target:Sprite, width:int, height:int, ellipse:Number, color:uint=0xFFFFFF, alpha:Number=1, 
											  isBorder:Boolean=false, borderThickness:int=1, borderColor:uint=0x000000, borderAlpha:Number=1 ):void
		{
			target.graphics.clear();
			
			if (isBorder) 
			{
				target.graphics.lineStyle( borderThickness, borderColor, borderAlpha );
			}
			
			target.graphics.beginFill( color, alpha );
			target.graphics.drawRoundRect( 0, 0, width, height, ellipse, ellipse );
			target.graphics.endFill();
		}
		
		/**
		 *  색으로 채운 원 영역 생성
		 *  @param target 영역 생성해줄 객체.
		 *  @param x 원 중심점의 x좌표.
		 *  @param y 원 중심점의 x좌표.
		 *  @param radius 원 영역의 반지름.
		 *  @param color 영역 컬러, 디폴트 0xFFFFFF.
		 *  @param alpha 영역 투명도, 디폴트 1.
		 *  @param isBorder 테두리 유무, 디폴트 테두리없음.
		 *  @param borderThickness 테두리 굵기, 디폴트 1.
		 *  @param borderColor 테두리 색상, 디폴트 0x000000.
		 *  @param borderAlpha 테두리 투명도, 디폴트 1.
		 */
		public static function fillCircle( target:Sprite, x:int=0, y:int=0, radius:Number=100, color:uint=0xFFFFFF, alpha:Number=1, 
											  isBorder:Boolean=false, borderThickness:int=1, borderColor:uint=0x000000, borderAlpha:Number=1 ):void
		{
			target.graphics.clear();
			
			if (isBorder) 
			{
				target.graphics.lineStyle( borderThickness, borderColor, borderAlpha );
			}
			
			target.graphics.beginFill( color, alpha );
			target.graphics.drawCircle( x, y, radius );
			target.graphics.endFill();
		}
		
		/**
		 *  이미지로 채운 각진 사각 영역 생성
		 *  @param target 영역 생성해줄 객체.
		 *  @param width 사각 영역 width.
		 *  @param height 사각 영역 height.
		 *  @param bitmapData 채워질 이미지 BitmapData.
		 */
		public static function fillBitmapRect( target:Sprite, width:int, height:int, bitmapData:BitmapData ):void
		{
			target.graphics.clear();

			target.graphics.beginBitmapFill( bitmapData );
			target.graphics.drawRect( 0, 0, width, height );
			target.graphics.endFill();
		}
		
		/**
		 *  ByteArray 를 Bitmap 으로 전환하여 전달
		 *  @param byteArray 전환할 ByteArray.
		 *  @param callBackFun Bitmap으로 전환된 데이타를 전달 받을 함수.
		 */ 
		public static function setByteArrayToBitmap( byteArray:ByteArray, callBackFun:Function ):void
		{
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener( Event.COMPLETE, completeLoadHandler );
			
			try 
			{
				loader.loadBytes( byteArray );
			}
			catch ( error:Error ) 
			{
				trace( "error : ", error.message );
			}
			
			function completeLoadHandler( event:Event=null ):void
			{
				var bitmap:Bitmap = Bitmap( loader.content );
				
				callBackFun( bitmap );
			}
		}
		
		/**
		 *  링크 설정
		 *  @param url 링크 URL.
		 *  @param window, _self, _blank.
		 */
		public static function setNavigateURL( url:String, window:String ):void
		{
			if ( url.indexOf( "http://" ) == -1 ) url = "http://" + url;
			var request:URLRequest = new URLRequest( url );
			navigateToURL( request, window );
		}
		
		/**
		 *  컬러 톤 변화 
		 *  @param target 대상 객체.
		 *  @param isMonoTon 흑백인지 여부.
		 */ 
		public static function setColorTon( target:DisplayObject, isMonoTon:Boolean ):void
		{
			var amount:int = isMonoTon ? 0 : 1;
			
			var colorFilter:ColorMatrixFilter = new ColorMatrixFilter();
			var redIdentity:Array = [1, 0, 0, 0, 0];
			var greenIdentity:Array = [0, 1, 0, 0, 0];
			var blueIdentity:Array = [0, 0, 1, 0, 0];
			var alphaIdentity:Array = [0, 0, 0, 1, 0];
			var grayluma:Array = [.3, .59, .11, 0, 0];
			
			var colmatrix:Array = [];
			colmatrix = colmatrix.concat( interpolateArrays( grayluma, redIdentity, amount ) );
			colmatrix = colmatrix.concat( interpolateArrays( grayluma, greenIdentity, amount ) );
			colmatrix = colmatrix.concat( interpolateArrays( grayluma, blueIdentity, amount ) );
			colmatrix = colmatrix.concat( alphaIdentity );
			
			colorFilter.matrix = colmatrix;
			
			target.filters = [colorFilter];
		}
		
		/**
		 *  두개의 배열을 비교하여 해당 수치 만큼 합쳐 반환
		 *  @param arry1 대상 배열1.
		 *  @param arry2 대상 배열2.
		 *  @param amount 수치.
		 *  @return Array.
		 */ 
		private static function interpolateArrays(arry1:Array, arry2:Array, amount:int ):Array
		{
			var result:Array = ( arry1.length>=arry2.length ) ? arry1.slice() : arry2.slice();
			var i:int = result.length;
			while ( i-- ) 
			{
				result[i] = arry1[i] + ( arry2[i] - arry1[i] ) * amount;
			}
			
			return result;
		}
		
		/**
		 *  디스플레이 오브젝트 복사
		 *  @param idName 등록할 ID.
		 *  @param className 등록될 Class.
		 *  @param target 복사할 타겟 오브젝트.
		 *  @param targetBitmap 복사할 타겟 비트맵.
		 *  @param propObj 복사할 오브젝트 속성, default null.
		 * 
		 *  @return Object
		 */
		public static function cloneDisplayObject(idName:String, className:Class, target:DisplayObject, targetBitmap:Bitmap, propObj:Object = null):Object
		{
			registerClassAlias( idName, className );
			
			var dataClone:Object = ObjectUtil.copy( target );
			var bitmapClone:Bitmap = cloneBitmap( targetBitmap );
			
			var cloneObj:Object = {};
			cloneObj.dataClone = dataClone;
			cloneObj.bitmapClone = bitmapClone;
			cloneObj.propClone = propObj;
			
			return cloneObj;
		}
		
		/**
		 *  화면 객체 비트맵화 복사
		 *  @param target 타겟 오브젝트.
		 * 
		 *  @return Bitmap
		 */
		public static function cloneBitmap(target:DisplayObject):Bitmap
		{
			var data:BitmapData = new BitmapData(target.width, target.height, true, 0);
			data.draw(target);
			
			var bitmap:Bitmap = new Bitmap(data);
			
			return bitmap;
		}
		
		/**
		 *  화면 객체 복사
		 *  @param target 타겟 오브젝트.
		 *  @param autoAdd 타겟 오브젝트 하위 오브젝트 자동 add 여부, default false.
		 * 
		 *  @return DisplayObject
		 */
		public static function duplicateDisplayObject(target:DisplayObject, autoAdd:Boolean = false):DisplayObject {
			// create duplicate
			var targetClass:Class = Object(target).constructor;
			var duplicate:DisplayObject = new targetClass();
			
			// duplicate properties
			duplicate.transform = target.transform;
			duplicate.filters = target.filters;
			duplicate.cacheAsBitmap = target.cacheAsBitmap;
			duplicate.opaqueBackground = target.opaqueBackground;
			
			if (target.scale9Grid) 
			{
				var rect:Rectangle = target.scale9Grid;
				duplicate.scale9Grid = rect;
			}
			
			if (autoAdd && target.parent) 
			{
				target.parent.addChild(duplicate);
			}
			
			return duplicate;
		}

	}
}