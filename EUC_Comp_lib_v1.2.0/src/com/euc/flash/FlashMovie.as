package com.euc.flash
{
	import com.euc.flash.data.FlashData;
	import com.euc.flash.data.vo.ImageVO;
	import com.euc.flash.data.vo.MovieVO;
	import com.euc.flash.data.vo.PropVO;
	import com.euc.flash.events.ConvertEvent;
	import com.euc.flash.events.FileLoadDataEvent;
	import com.euc.flash.events.FlashMovieEvent;
	import com.euc.flash.events.FontLoadEvent;
	import com.euc.flash.events.ModelChangeEvent;
	import com.euc.flash.manager.DataManager;
	import com.euc.flash.manager.DataModelManager;
	import com.euc.flash.manager.FontLoadManager;
	import com.euc.flash.model.ConvertibleModel;
	import com.euc.flash.net.FileLoadData;
	import com.euc.flash.ui.BaseClip;
	import com.euc.flash.utils.DisplayObjectUtil;
	import com.euc.flash.utils.ObjectInfoUtil;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.LoaderInfo;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.system.Security;
	import flash.text.Font;
	import flash.utils.getDefinitionByName;
	
	import mx.utils.ObjectUtil;
	
	public class FlashMovie extends BaseClip implements IFlashMovie
	{
		public const SUB_TYPE_NORMAL:String = "1";			// 일반 플래시
		public const SUB_TYPE_SKIN:String = "2";			// 스킨 플래시
		public const SUB_TYPE_MULTI:String = "3";			// 멀티미디어 플래시
		
		// 폰트 SWF경로
		private var _fontURLList:Array;						// 폰트 URL 리스트
		
		private var _dataModelManager:DataModelManager; 	// 테이타 모델 매니저
		private var _dataManager:DataManager;				// 테이타 매니저
		private var _fontLoadManager:FontLoadManager;
		private var _convertibleModel:ConvertibleModel; 	// XML-VO 간 데이타 모델
		
		private var _flashData:FlashData;					// 플래시 데이타
		private var _variableVO:Object = {}; 				// 속성 ValueObject
		private var _bitmapList:Array = [];					// 이미지 비트맵 배열
		private var _moviePathList:Array = [];				// 동영상 패스 배열
		private var _fontNameList:Array;
		
		private var _maskArea:Sprite;						// 마스크 영역
		private var _stageArea:Sprite;						// 스테이지 영역
		private var _contentArea:Sprite;					// 컨텐츠 영역

		private var _useFont:Boolean; 						// 폰트 사용 유무
		
		private var _moviePath:String;						// 스킨모드 동영상 패스
		private var _movieWidth:int;						// 스킨모드 동영상 가로
		private var _movieHeight:int;						// 스킨모드 동영상 세로
		
		/**
		 *  @private
		 *  플래시 서브타입.
		 */
		private var _subType:String; 
		/**
		 *  플래시 서브타입.
		 */
		public function get subType():String
		{
			return _subType;
		}
		/**
		 *  @private
		 */
		public function set subType( value:String ):void
		{
			_subType = value;
		}
		
		/**
		 *  @private
		 *  사용자 등록 XML.
		 */
		private var _xml:XML; 
		/**
		 *  사용자 등록 XML.
		 */
		public function get xml():XML
		{
			return _xml;
		}
		/**
		 *  @private
		 */
		public function set xml( value:XML ):void
		{
			_xml = value;
			setLocalXMLToVO();
		}
		
		/**
		 *  @private
		 *  폰트 변수명.
		 */
		private var _fontVarNames:Array; 
		/**
		 *  @private
		 */
		public function set fontVarNames( value:Array ):void
		{
			_fontVarNames = value;
			_useFont = true;
		}
		
		/**
		 *  @private
		 *  텍스트.
		 */
		private var _textVarNames:Array; 
		/**
		 *  @private
		 */
		public function set textVarNames( value:Array ):void
		{
			_textVarNames = value;
			_useFont = true;
		}
		
		/**
		 *  @private
		 *  폰트.
		 */
		private var _fonts:Array; 
		/**
		 *  @private
		 */
		public function set fonts( value:Array ):void
		{
			_fonts = value;
			setFonts();
		}
		
		/**
		 *  Constructor.
		 */ 
		public function FlashMovie()
		{
			initFlash();
		}
		
		/**
		 *  initialize Flash
		 */ 
		private function initFlash():void
		{
			trace( "---------------------------->>> FLASH INIT Start ");
			
			initProperties();
			initReference();
			initEventListener();
			initParameters();
			initElements();
		}
		
		/**
		 *  initialize Properties
		 */ 
		private function initProperties():void
		{
			Security.allowDomain("*");
			debugEnabled = true;
			
			if ( !stage ) return;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
		}
		
		/**
		 *  initialize Reference
		 */ 
		private function initReference():void
		{
			_dataManager = DataManager.getInstance();
			_dataModelManager = DataModelManager.getInstance();
			_fontLoadManager = FontLoadManager.getInstance();
			_convertibleModel = new ConvertibleModel();
			
			_flashData = _dataManager.flashData;
		}
		
		/**
		 *  initialize EventListener
		 */ 
		private function initEventListener():void
		{
			_dataModelManager.addEventListener( ModelChangeEvent.PROPERTY_CHANGED, onDataModelChangeHandler );
			_convertibleModel.addEventListener( ConvertEvent.XML_TO_VO_COMPLETE, onXMLtoVOCompleteHandler );
		}
		
		/**
		 *  initialize Parameters
		 */ 
		private function initParameters():void
		{
			for ( var name:String in loaderInfo.parameters )
			{
				trace( "EXTERNAL PARAMETERS --> ", loaderInfo.parameters[ name ] );
			}
			
			if ( loaderInfo.parameters.seq ) 	setLoadXMLToVO( unescape( loaderInfo.parameters.seq ) );
			if ( loaderInfo.parameters.xmlURL ) setLoadXMLToVO( loaderInfo.parameters.xmlURL );
			if ( loaderInfo.parameters.xmlStr ) setXMLToVO( new XML( loaderInfo.parameters.xmlStr ) );
			if ( loaderInfo.parameters.xml ) 	setXMLToVO( loaderInfo.parameters.xml );
			
			if ( loaderInfo.parameters.moviePath )   _moviePath = loaderInfo.parameters.moviePath;
			if ( loaderInfo.parameters.movieWidth )  _movieWidth = loaderInfo.parameters.movieWidth;
			if ( loaderInfo.parameters.movieHeight ) _movieHeight = loaderInfo.parameters.movieHeight;
		}
		
		/**
		 *  initialize Elements
		 */ 
		private function initElements():void
		{
			_stageArea = new Sprite();
			addChildAt( _stageArea, 0 );
			
			_contentArea = new Sprite();
			addChildAt( _contentArea, 1 );
			
			_maskArea = new Sprite();
			addChild( _maskArea );
			
			mask = _maskArea;
		}
		
		/**
		 *  폰트 바이트 로드 등록
		 */ 
		private function setFonts():void
		{
			_fontLoadManager.addEventListener( FontLoadEvent.LOAD_COMPLETE, onFontLoadCompleteHandler );
			_fontLoadManager.loadBytes( _fonts );
		}
		
		/**
		 *  set Local XML to VO
		 *  플래시를 에디터 연동없이 로컬에서 실행시킬 경우 해당
		 */ 
		private function setLocalXMLToVO():void
		{
			if ( _dataManager.isInitSkip ) return;
			
			trace( "------------------>> setLocalXMLToVO " );
			_convertibleModel.setLocalXMLToVO( xml );
		}
		
		/**
		 *  set XML to VO
		 * 	@param xml XML.
		 */ 
		private function setXMLToVO( xml:XML ):void
		{
			trace( "------------------>> setXMLToVO ", xml );
			_convertibleModel.setXMLToVO( xml );
		}
		
		/**
		 *  set XML URL to VO
		 * 	@param xmlURL XML URL.
		 */
		private function setLoadXMLToVO( xmlURL:String ):void
		{
			trace( "------------------>> setLoadXMLToVO ", xmlURL );
			_convertibleModel.setLoadXMLToVO( xmlURL );
		}
		
		/**
		 *  무료폰트 설정
		 */ 
		private function setEUCFonts():void
		{
			trace( "FONT VAR NAMES : ", _fontVarNames );
			
			// 플래시 개발자가 무료폰트 사용을 하는 경우  _fontVarNames에 값을 넣어주게 된다.
			if ( !_fontVarNames ) return;
			
			_fontURLList = [];
			
			for each ( var fontVarName:String in _fontVarNames )
			{
				setFontURLList( fontVarName );
			}
			
			_fontLoadManager.addEventListener( FontLoadEvent.LOAD_COMPLETE, onFontLoadCompleteHandler );
			_fontLoadManager.load( _fontURLList );
			
			function setFontURLList( fontVarName:String ):void
			{
				var fontURL:String = "";
				for each ( var fontObj:Object in _dataManager.eucFonts )
				{
					if ( fontObj.fontName == _variableVO[ fontVarName ] )
					{
						fontURL = _dataManager.serverHost;
						fontURL += fontObj.fontURL;
						
						_fontURLList.push( fontURL );
						break;
					}
				}
			}
			
		}
		
		/**
		 *  플래시 데이타 바인딩 셋팅
		 */
		private function setBindFlashData():void
		{
			var classReference:Class = null;
			var varName:String = "";
			var varValue:* = null;
			var imageCount:int = 0;
			var movieCount:int = 0;
			
			// 속성 정보 바인딩
			for each ( var prop:PropVO in _flashData.propVO )
			{
				classReference = getDefinitionByName( prop.varType ) as Class;
				
				varName = prop.varName;
				varValue = prop.varValue;
				
				if ( prop.propFormat == DataManager.PROP_FORMAT[6].value )
				{
					trace("------------- TreeArea --------------");
					trace("varName : ", prop.varName);
					trace(prop.varValue);
					trace("------------- TreeArea --------------");
					var xmlList:XMLList = XML( prop.varValue ).children();
					varValue = getXMLData( xmlList );
				}
				else
				{
					varValue = classReference( prop.varValue );
				}
				
				_variableVO[ varName ] = varValue;
				
				setBindProperty( varName, varValue );
			}
			
			// 추가 속성값 매핑 - 플래시 가로/세로 사이즈
			_variableVO[ "swfWidth" ] = _flashData.basicVO.swfWidth;
			_variableVO[ "swfHeight" ] = _flashData.basicVO.swfHeight;
			
			// 추가 속성값 매핑 - 외부에서 넘겨준 무비 사이즈가 존재하는 경우 - 스킨모드
			if ( _movieWidth )  _variableVO[ "movieWidth" ] = _movieWidth;
			if ( _movieHeight ) _variableVO[ "movieHeight" ] = _movieHeight;
			
			setEUCFonts();
			
			_bitmapList = [];
			_moviePathList = [];
			
			// 이미지 정보 바인딩
			for each ( var image:ImageVO in _flashData.imageVO )
			{
				if ( image.imageIndex ) varName = "_bitmap" + image.imageIndex;
				else					varName = "_bitmap" + imageCount;
				
				varValue = image.imageBitmap;
				imageCount++;
				
				if ( varValue ) _bitmapList.push( varValue );
				setBindProperty( varName, varValue );
			}
			
			// 동영상 패스 정보 바인딩
			for each ( var movie:MovieVO in _flashData.movieVO )
			{
				if ( movie.movieIndex ) varName = "_moviePath" + movie.movieIndex;
				else					varName = "_moviePath" + movieCount;
				
				varValue = movie.moviePath;
				movieCount++;
				
				if ( varValue ) _moviePathList.push( varValue );
				setBindProperty( varName, varValue );
			}
			
			setStageArea();
			
			trace( "----------------> acceptChangedData <-----------------");
			try
			{
				// 시간차 플래시 오류 예방
				acceptChangedData( _contentArea, _flashData, _variableVO, _bitmapList, _moviePathList );
			}
			catch ( error:Error ) {}
		}
		
		/**
		 *  스테이지 배경 설정
		 *  @param stageColor 스테이지 배경컬러.
		 *  @param stageAlpha 스테이지 투명도.
		 *  @param stageImage 스테이지 이미지.
		 */ 
		private function setStageArea():void
		{
			trace( "----------------> setStageArea <-----------------");
			destroyInstance( _contentArea );
			DisplayObjectUtil.removeAllChildren( _contentArea );
			
			var swfWidth:int = _flashData.basicVO.swfWidth;
			var swfHeight:int = _flashData.basicVO.swfHeight;
			var stageColor:uint = _flashData.basicVO.stageColor;
			var stageAlpha:Number = _flashData.basicVO.stageAlpha;
			
			trace( "FlashClip SWF SIZE : ", swfWidth, swfHeight );
			
			DisplayObjectUtil.fillRect( _stageArea, swfWidth, swfHeight, stageColor, stageAlpha );
			DisplayObjectUtil.fillRect( _maskArea, swfWidth, swfHeight, stageColor );
		}
		
		/**
		 *  포멧형이 서브타입(TreeArea)인 경우 해당 varValue 정보(XML의 문자열)를 통해 데이타 목록으로 반환 
		 */ 
		private function getXMLData( xmlList:XMLList ):Array
		{
			var xmlData:Array = [];
			var obj:Object = null;
			var xml:XML = null;
			var xmlChild:XMLList = null;
			for ( var node:String in xmlList )
			{
				xml = xmlList[node];
				xmlChild = XMLList( xml.children().toXMLString() );
				obj = {};
				obj.label = xml.@label;
				obj.value = getNodeData( xml.@value );
				obj.child = getXMLData( xmlChild );
				
				xmlData.push( obj );
			}
			
			return xmlData;
		}
		
		/**
		 *  서브타입(TreeArea)의 각 서브속성들의 값을 추출하여 오브젝트로 반환
		 */ 
		private function getNodeData( xmlStr:String ):Object
		{
			var obj:Object = {};
			var xml:XML = new XML(xmlStr);
			var xmlList:XMLList = xml.children();
			for ( var node:String in xmlList )
			{
				obj = getNodeObj( xmlList[node], obj );
			}
			
			return obj;
		}
		
		/**
		 *  서브타입(TreeArea)의 속성값의 xml 노드에서 key-value 형태의 오브젝트 추출하여 반환
		 */ 
		private function getNodeObj( xml:XML, obj:Object ):Object
		{
			var tempObj:Object = {};
			var xmlList:XMLList = xml.children();
			for ( var node:String in xmlList )
			{
				if ( xmlList[node].localName() == "varName" )
				{
					tempObj.key = xmlList[node];
					continue;
				}
				if ( xmlList[node].localName() == "varValue" )
				{
					tempObj.value = xmlList[node];
					continue;
				}
			}
			obj[tempObj.key] = tempObj.value;
			
			return obj;
		}
		
		/**
		 *  바인딩 속성값 설정
		 */ 
		private function setBindProperty( property:String, value:* ):void
		{
			_dataModelManager.setBindProperty( property, value );
		}
		
		/**
		 *  바인딩 속성값 반환
		 */ 
		private function getBindProperty( property:String ):*
		{
			return _dataModelManager.getBindProperty( property );
		}
		
		/**
		 *  EventHandler 
		 *  XML to VO
		 * 	@param xmlURL XML URL.
		 */
		private function onXMLtoVOCompleteHandler( event:ConvertEvent ):void
		{
			trace( "------------------>> FLASH XML TO VO COMPLETE ", " | BITMAP TOTAL : ", _bitmapList.length );
			
			var imageCount:int = 0;
			var imageTotalCount:int = _flashData.imageVO.length;

			_flashData.basicVO.subType = subType;
			
			for each ( var image:ImageVO in _flashData.imageVO )
			{
				if ( image.imageBitmap ) _bitmapList.push( image.imageBitmap );
			}
			
			for each ( var movie:MovieVO in _flashData.movieVO )
			{
				if ( _moviePath ) // 외부에서 넘겨준 무비패스가 존재하는 경우 - 스킨모드
				{
					trace( "SKIN MODE PATH : ", _moviePath );
					trace( "SKIN MODE SIZE : ", _movieWidth, _movieHeight );
					movie.moviePath = _moviePath;
					movie.movieWidth = _movieWidth;
					movie.movieHeight = _movieHeight;
				}
				
				if ( movie.moviePath ) _moviePathList.push( movie.moviePath );
			}
			
			if ( imageTotalCount == 0 )
			{
				trace( "-------------> 이미지 VO가 존재하지 않는 경우 ");
				setBindFlashData();
			}
			else if ( _bitmapList.length == 0 )
			{
				
				trace( "-------------> 이미지를 path를 통해 로드하는 경우 ");
				loadImageData();
			}
			else
			{
				trace( "-------------> 이미지를 Array에 Bitmap 담아 받은 경우 ");
				setImageData();
			}
			
			function setImageData():void
			{
				var i:int = 0;
				for each ( var bitmap:Bitmap in _bitmapList )
				{
					ImageVO( _flashData.imageVO[ i ] ).imageBitmap = bitmap;
					i++;
				}
				setBindFlashData();
			}
			
			function loadImageData():void
			{
				var imagePathArr:Array = [];
				for each ( var image:ImageVO in _flashData.imageVO )
				{
					imagePathArr.push( image.imagePath );
				}
				
				var fileLoadData:FileLoadData = new FileLoadData();
				fileLoadData.addEventListener( FileLoadDataEvent.LOADER_COMPLETE, fileLoadData_completeHandler );
				fileLoadData.addEventListener( FileLoadDataEvent.ERROR_DATA, fileLoadData_errorHandler );
				fileLoadData.loadMultiStepData( false, imagePathArr );
				
				function fileLoadData_completeHandler( event:FileLoadDataEvent ):void
				{
					trace( "-------------> Image Load Success ");
					
					var bitmap:Bitmap = null;
					var tempbitmapArr:Array = [];
					var loaderInfoArr:Array = event.data as Array;
					for each ( var loaderInfo:LoaderInfo in loaderInfoArr )
					{
						bitmap = loaderInfo.content as Bitmap;
						tempbitmapArr.push( bitmap );
					}
					_bitmapList = tempbitmapArr;
					
					setImageData();
				}
				
				function fileLoadData_errorHandler( event:FileLoadDataEvent ):void
				{
					trace( "-------------> Image Load Fail ");
					_dataManager.initializeImageVO();
					setBindFlashData();
				}
			}
		}
		
		/**
		 *  EventHandler 
		 *  변화된  바인딩 속성 정보 전달
		 */ 
		private function onDataModelChangeHandler( event:ModelChangeEvent ):void
		{
			_dataModelManager.removeEventListener( ModelChangeEvent.PROPERTY_CHANGED, onDataModelChangeHandler );
			
			if ( event.oldValue == undefined ) return;
			
			var isExistProperty:Boolean = ObjectInfoUtil.hasExistName( _variableVO, event.property );
			if ( isExistProperty ) _variableVO[ event.property ] = event.newValue;
			
			trace( "----------------> acceptChangedDataModel <-----------------");
			acceptChangedDataModel( event.property, event.oldValue, event.newValue );
		}
		
		/**
		 *  EventHandler 
		 *  폰트 로드 완료 및 폰트 등록
		 */ 
		private function onFontLoadCompleteHandler( event:FontLoadEvent ):void
		{
			_fontLoadManager.removeEventListener( FontLoadEvent.LOAD_COMPLETE, onFontLoadCompleteHandler );
			_fontNameList = getFontNameList();
			
			trace( "----------------> acceptFontNameList <-----------------");
			acceptFlashMessage( "Get FontNameList Now!!!" );
			acceptFontNameList( _fontNameList );
		}
		
		
		//////////////////////////////// FLASH PUBLIC METHOD /////////////////////////////////	
		
		/**
		 *  폰트 전체 목록 리스트 반환
		 *  @return Array.
		 */ 
		public function getFontNameList():Array
		{
			var fontNameList:Array = [];
			
			var fontList:Array = Font.enumerateFonts( false ).sort();
			var len:int = fontList.length
			for each ( var font:Font in fontList )
			{	
				if ( font.fontName == "ygo350" ) continue;
				if ( font.fontName == "RixGoEB EB" ) continue;
				
				fontNameList.push( font.fontName );
				trace( "[FONT] Register Font Name : ", font.fontName );
			}
			
			return fontNameList;
		}
		
		/**
		 *  플래시 속성값 변화 피드백
		 */ 
		public function sendChangedVarValue():void 
		{
			for ( var varName:String in _variableVO )
			{
				_dataManager.changePropVO( varName, _variableVO[varName] );
			}
			
			var e:FlashMovieEvent = new FlashMovieEvent( FlashMovieEvent.VAR_VALUE_SEND );
			dispatchEvent( e );
		}
		
		/**
		 *  플래시에서 사용된 모든 인스턴스 제거
		 */ 
		public function destroyInstance( parent:Sprite ):void
		{
			trace( "FLASH destroy parent : ", parent, parent.numChildren );
			
			if ( !parent || parent.numChildren == 0 ) return;
			
			var count:int = 0;
			var destroyTarget:DisplayObject;
			var len:int = parent.numChildren;
			
			for ( var i:int=0; i<len; i++ )
			{
				destroyTarget = parent.getChildAt( i );
				
				if ( destroyTarget is Sprite )
				{
					destroyInstance( destroyTarget as Sprite );
				}
				
				if ( destroyTarget is Bitmap ) trace("-> FLASH Bitmap ", destroyTarget);
				else trace("-----> FLASH destroyTarget ", typeof( destroyTarget ), destroyTarget);
				destroyTarget = null;
			}
		}
		
		//////////////////////////////// EXTERNAL CONNECTOR /////////////////////////////////		
		
		public function get flash():FlashMovie
		{
			return this;
		}
		
		/**
		 * 	Interface 구현
		 *  플래시 호출 매서드 : 데이타 변화시 호출
		 */
		public function callFlashSetData():void
		{
			trace( "----------------> callFlashSetData <-----------------" );
			setBindFlashData();
		}
		
		/**
		 *  Interface 구현
		 *  플래시 호출 매서드 : 데이타 XML 정보 전달 및 호출
		 * 	@param xml XML 데이타.
		 */
		public function callFlashPushXML( xml:XML ):void
		{
			trace( "-----------> callFlashPushXML <------------" );
			setXMLToVO( xml );
		}
		
		/**
		 *  Interface 구현
		 *  플래시 호출 매서드 : 데이타 XML URL 전달 및 호출
		 * 	@param xmlURL XML URL.
		 */
		public function callFlashPushLoadXML( xmlURL:String ):void
		{
			trace( "-----------> callFlashPushLoadXML <------------" );
			setLoadXMLToVO( xmlURL );
		}
		
		/**
		 *  Interface 구현
		 *  플래시 호출 매서드 : 비트맵 배열 전달 및 호출
		 * 	@param bitmapList 비트맵 배열.
		 */
		public function callFlashPushBitmapList( bitmapList:Array ):void
		{
			_bitmapList = bitmapList;
		}
		
		/**
		 *  Interface 구현
		 *  플래시 호출 매서드 : 동영상 패스 배열 전달 및 호출
		 * 	@param bitmapList 동영상 패스 배열.
		 */
		public function callFlashPushMoviePathList( moviePathList:Array ):void
		{
			_moviePathList = moviePathList;
		}
		
		/**
		 *  Interface 구현
		 *  플래시 호출 매서드 : 플래시 무비 플레이
		 */
		public function callFlashPlay():void
		{
			trace( "-----------> callFlashPlay <------------" );
			acceptFlashPlay();
		}
		
		/**
		 *  Interface 구현
		 *  플래시 호출 매서드 : 플래시 무비 스톱
		 */
		public function callFlashStop():void
		{
			trace( "-----------> callFlashStop <------------" );
			acceptFlashStop();
		}
		
		/**
		 *  Interface 구현
		 *  플래시 호출 매서드 : 플래시 무비 종료
		 */ 
		public function callFlashDestroy():void
		{
			trace( "-----------> callFlashDestroy <------------" );
			_dataManager.initializeFlashData();
			
			try
			{
				acceptFlashDestroy();
				destroyInstance( _contentArea );
			}
			catch ( error:Error ) {}
		}
		
		public function returnFlashMessage():String
		{
			return "Send Flash Message is Success !"
		}
		
		public function returnUseFont():Boolean
		{
			return _useFont;
		}
		
		public function returnFontNameList():Array
		{
			return _fontNameList;
		}
		
		public function returnFontVarNameList():Array
		{
			return _fontVarNames;
		}
		
		public function returnTextVarNameList():Array
		{
			return _textVarNames;
		}
		
		
		//////////////////////////////// FLASH CONNECTOR ///////////////////////////////////		
		
		/**
		 *  필수 사용자 구현 메서드 : 데이타 변화시 변화된 데이타 전달 및 호출
		 * 	@param contentArea 플래시 컨텐츠 영역.
		 * 	@param flashData 플래시데이타 ValueObject, BasicVO, FileVO, ImageVO, PropVO 포함.
		 * 	@param variableVO 속성 ValueObject, 속성 이름 및 값.
		 * 	@param bitmapList 이미지 비트맵 정보를 담은 배열.
		 * 	@param moviePathList 동영상 URL 정보를 담은 배열.
		 */
		public function acceptChangedData( contentArea:Sprite, flashData:FlashData, variableVO:Object, bitmapList:Array, moviePathList:Array ):void {}
		
		/**
		 *  필수 사용자 구현 메서드 : 플래시 무비 플레이 호출
		 */ 
		public function acceptFlashPlay():void {}
		
		/**
		 *  필수 사용자 구현 메서드 : 플래시 무비 스톱 호출
		 */
		public function acceptFlashStop():void {}
		
		/**
		 *  필수 사용자 구현 메서드 : 플래시 무비 종료
		 */
		public function acceptFlashDestroy():void {}
		
		/**
		 *  선택 사용자 구현 메서드 : 데이타 변화시 변화된 바인딩 속성 정보 전달 및 호출
		 * 	@param property 변화된 속성명.
		 * 	@param oldValue 변화되기 전 속성값.
		 * 	@param newValue 변화된 이후 속성값.
		 */
		public function acceptChangedDataModel( property:String, oldValue:*, newValue:* ):void {}
		
		/**
		 *  선택 사용자 구현 메서드 : 폰트 네임 배열 전달 및 호출
		 *  @param fontNameList 폰트 네임 배열.
		 */ 
		public function acceptFontNameList( fontNameList:Array ):void {}
		
		/**
		 *  선택 사용자 구현 메서드 : 출력될 플래시 메세지
		 *  @param message 메세지.
		 */ 
		public function acceptFlashMessage( message:String ):void {}
	}
}