package com.euc.flash.manager
{
	import com.euc.flash.FlashMovie;
	import com.euc.flash.FlashProxy;
	import com.euc.flash.IFlashMovie;
	import com.euc.flash.IFlashProxy;
	import com.euc.flash.data.FlashData;
	import com.euc.flash.data.LoadData;
	import com.euc.flash.data.vo.BasicVO;
	import com.euc.flash.data.vo.FileVO;
	import com.euc.flash.data.vo.PropVO;
	import com.euc.flash.utils.DataUtil;
	import com.euc.flash.utils.ObjectInfoUtil;
	
	import mx.utils.ObjectUtil;
	
	public class DataManager
	{
		// 플래시 CP 속성 포멧 종류
		public static var PROP_FORMAT:Array = [
			{label:"TextInput",     	value:"mx.controls.TextInput"}, 
			{label:"ComboBox",      	value:"mx.controls.ComboBox"}, 
			{label:"ColorPicker",   	value:"mx.controls.ColorPicker"}, 
			{label:"Slider",        	value:"mx.controls.HSlider"},
			{label:"NumericStepper",    value:"mx.controls.NumericStepper"},
			{label:"FontSelector",    	value:"com.euc.sf.service.editor.controls.FontSelector"},
			{label:"TreeArea",    		value:"com.euc.sf.service.editor.controls.TreeArea"}
		];
		
		public static const DATA:String = "flashData";
		public static const BASIC:String = "basicVO";
		public static const FILE:String = "fileVO";
		public static const IMAGE:String = "imageVO";
		public static const MOVIE:String = "movieVO";
		public static const PROP:String = "propVO";
		
		public static const PROP_DATA:String = "propData";
		
		private static var _instance:DataManager;
		
		[Bindable] public var flashData:FlashData = new FlashData();	// 플래시 데이타
		[Bindable] public var loadData:LoadData = new LoadData();		// 플래시 무비 데이타
		[Bindable] public var tempData:FlashData = new FlashData();		// 임시 저장 플래시 데이타
		
		public var isExternal:Boolean;	// 외부 실행 여부
		public var isInitSkip:Boolean;	// 최초 초기화 스킵 여부
		
		public var serverHost:String;	// 서버 호스트 정보
		public var eucFonts:Array;		// 폰트 리스트 정보
		
		/**
		 *  Constructor.
		 */ 
		public function DataManager( secure:PrivateClass ) {}

		/**
		 *  get Instance
		 */ 
		public static function getInstance():DataManager
		{
			if( _instance == null ) 
				_instance = new DataManager( new PrivateClass() );
			
			return _instance;
		}
		
		/**
		 *  remove Instance
		 */ 
		public static function removeInstance():void
		{
			_instance = null;
		}
		
		/**
		 *  FlashMovie의 Proxy 반환
		 */ 
		public function getFlashProxy():IFlashProxy
		{
			var flashProxy:IFlashProxy = null;
			var flashMovie:IFlashMovie = loadData.flashMovie;
			
			if ( flashMovie ) flashProxy = new FlashProxy( flashMovie );
			
			return flashProxy;
		}
		
		/**
		 *  initialize FlashData
		 */ 
		public function initializeFlashData():void
		{
			initializeBasicVO();
			initializeFileVO();
			initializeImageVO();
			initializeMovieVO();
			initializePropVO();
			
			flashData = new FlashData();
		}
		
		/**
		 *  initialize LoadData
		 */
		public function initializeLoadData():void
		{
			loadData = new LoadData();
		}
		
		/**
		 *  initialize BasicVO
		 */
		public function initializeBasicVO():void
		{
			flashData.basicVO = new BasicVO();
		}
		
		/**
		 *  initialize FileVO
		 */
		public function initializeFileVO():void
		{
			flashData.fileVO = new FileVO();
		}
		
		/**
		 *  initialize ImageVO
		 */
		public function initializeImageVO():void
		{
			flashData.imageVO = [];
		}
		
		/**
		 *  initialize MovieVO
		 */
		public function initializeMovieVO():void
		{
			flashData.movieVO = [];
		}
		
		/**
		 *  initialize PropVO
		 */
		public function initializePropVO():void
		{
			flashData.propVO = [];
		}
		
		/**
		 *  set BasicVO
		 */
		public function setFlashData():void
		{
			setBasicVO();
			setFileVO();
			setImageVO();
			setMovieVO();
			setPropVO();
		}
		
		/**
		 *  set BasicVO
		 */
		public function setBasicVO():void
		{
			flashData.basicVO = ObjectInfoUtil.clone( tempData.basicVO ) as BasicVO;
		}
		
		/**
		 *  set FileVO
		 */
		public function setFileVO():void
		{
			flashData.fileVO = ObjectInfoUtil.clone( tempData.fileVO ) as FileVO;
		}
		
		/**
		 *  set ImageVO
		 */
		public function setImageVO():void
		{
			flashData.imageVO = DataUtil.cloneArray( tempData.imageVO );
		}
		
		/**
		 *  set MovieVO
		 */
		public function setMovieVO():void
		{
			flashData.movieVO = DataUtil.cloneArray( tempData.movieVO );
		}
		
		/**
		 *  set PropVO
		 */
		public function setPropVO():void
		{
			flashData.propVO = DataUtil.cloneArray( tempData.propVO );
		}
		
		/**
		 *  set TempData
		 */ 
		public function setTempData():void
		{
			setTempBasicVO();
			setTempFileVO();
			setTempImageVO();
			setTempMovieVO();
			setTempPropVO();
		}
		
		/**
		 *  set TempBasicVO
		 */
		public function setTempBasicVO():void
		{
			tempData.basicVO = ObjectInfoUtil.clone( flashData.basicVO ) as BasicVO;
		}
		
		/**
		 *  set TempFileVO
		 */
		public function setTempFileVO():void
		{
			tempData.fileVO = ObjectInfoUtil.clone( flashData.fileVO ) as FileVO;
		}
		
		/**
		 *  set TempImageVO
		 */
		public function setTempImageVO():void
		{
			tempData.imageVO = DataUtil.cloneArray( flashData.imageVO );
		}
		
		/**
		 *  set TempMovieVO
		 */
		public function setTempMovieVO():void
		{
			tempData.movieVO = DataUtil.cloneArray( flashData.movieVO );
		}
		
		/**
		 *  set TempPropVO
		 */
		public function setTempPropVO():void
		{
			tempData.propVO = DataUtil.cloneArray( flashData.propVO );
		}
		
		/**
		 *  initialize TempData
		 */ 
		public function initializeTempData():void
		{
			tempData = new FlashData();
		}
		
		public function changePropVO( varName:String, varValue:* ):void
		{
			for each ( var prop:PropVO in flashData.propVO )
			{
				if ( prop.varName == varName ) 
				{
					prop.varValue = varValue;
					break;
				}
			}
		}
		
		public function initializePropValue( propFormat:String ):void
		{
			for each ( var prop:PropVO in flashData.propVO )
			{
				if ( prop.propFormat == propFormat )
				{
					prop.varValue = "";
					break;
				}
			}
		}
	}
}

class PrivateClass 
{
	public function PrivateClass() {}
}