package com.euc.flash.net
{
	import com.euc.flash.events.FileLoadDataEvent;
	import com.euc.flash.utils.DisplayObjectUtil;
	
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.DataEvent;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.FileFilter;
	import flash.net.FileReference;
	import flash.net.FileReferenceList;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	import flash.utils.ByteArray;
	
	public class FileLoadData extends EventDispatcher
	{
		public static const TYPE_ALL:String = "typeAll";
		public static const TYPE_IMAGE:String = "typeImage";
		public static const TYPE_FLA:String = "typeFLA";
		public static const TYPE_SWF:String = "typeSWF";
		public static const TYPE_COMPRESS:String = "typeCompress";
		
		private var _fileReferenceList:FileReferenceList;
		private var _fileReference:FileReference;
		private var _loader:Loader;
		
		private var _loaders:Array = [];        	// loader 멀티
		private var _loaderInfos:Array = [];        // loaderInfo 멀티
		private var _fileReferences:Array = [];  	// fileReference 멀티
		private var _valueArr:Array = [];           // byteArray or file path 멀티
		
		private var _pendingCount:int;           	// 멀티 카운트
		private var _pendingTotal:int;			 	// 멀티 토탈 카운트
		
		private var _isMulti:Boolean;				// 멀티 데이타 여부
		private var _isStep:Boolean;				// 멀티 데이타를 순차적으로 처리할지 여부
		private var _isData:Boolean;				// 데이타를 인자로 로더를 처리할지 여부
		
		private var _isUpLoad:Boolean;				// 업로드 여부
		private var _fileType:String;				// 선택 파일 타입 
		private var _requestURL:String;				// 로더 request URL
		
		/**
		 * Constructor.
		 */ 
		public function FileLoadData()
		{
			super();
		}
		
		/**
		 *  로더 파일 레퍼런스 초기화
		 *  @param fileType 파일 타입, 디폴트 FileLoadData.TYPE_ALL
		 * 	@param isMulti 복수개의 파일인지 여부
		 */ 
		public function loadReference( fileType:String="typeAll", isMulti:Boolean=false ):void
		{
			initFileLoadData();
			
			_isUpLoad = false;
			_fileType = fileType;
			_isMulti = isMulti;
			
			if ( _isMulti ) 
			{
				_fileReferenceList = new FileReferenceList();
				initEventListner( _fileReferenceList );
			}
			else            
			{
				_fileReference = new FileReference();
				initEventListner( _fileReference );
			}
        	
        	initFileFilterBrowse();
		}
		
		/**
		 *  업로더 파일 레퍼런스 초기화
		 * 	@param requestURL URL 정보
		 *  @param fileType 파일 타입, 디폴트 FileLoadData.TYPE_ALL
		 */ 
		public function upLoadReference( requestURL:String, fileType:String="typeAll" ):void
		{
			_isUpLoad = true;
			_fileType = fileType;
			_requestURL = requestURL;
			
			_fileReference = new FileReference();
			
			initEventListner( _fileReference );
			initFileFilterBrowse();
		}
		
		/**
		 *  파일 레퍼런스 최초 이벤트 리스너 등록
		 *  @param target 이벤트 객체
		 */ 
		private function initEventListner( target:IEventDispatcher ):void
		{
			target.addEventListener( Event.SELECT, onSelectHandler );
        	target.addEventListener( Event.CANCEL, onCancelHandler );
		}
		
		/**
		 *  파일 레퍼런스 파일 타입 및 브라우져 설정
		 */ 
		private function initFileFilterBrowse():void
		{
			var fileFilter:Array = getFileFilter();
        	if ( _isMulti ) _fileReferenceList.browse( fileFilter );
        	else 			_fileReference.browse( fileFilter );
		}
		
		/**
		 *  파일 레퍼런스 파일 타입 설정
		 *  @return Array
		 */ 
		private function getFileFilter():Array
		{
			var paramFirst:String = "";
			var paramSecond:String = "";
	
			switch ( _fileType )
			{
				case FileLoadData.TYPE_ALL :
													paramFirst = "All (*.*)";
													paramSecond = "*.*";
													break;
				case FileLoadData.TYPE_IMAGE :
													paramFirst = "Images (*.jpg, *.jpeg, *.gif, *.png)";
													paramSecond = "*.jpg;*.jpeg;*.gif;*.png";
													break;
				case FileLoadData.TYPE_FLA :
													paramFirst = "Flash (*.fla)";
													paramSecond = "*.fla";
													break;
				case FileLoadData.TYPE_SWF :
													paramFirst = "Flash (*.swf)";
													paramSecond = "*.swf";
													break;
				case FileLoadData.TYPE_COMPRESS :
													paramFirst = "Compress (*.zip, *.egg, *.alz, *.tar, *.tbz, *.tgz, *.lzh, *.jar)";
													paramSecond = "*.zip;*.egg;*.alz;*.tar;*.tbz;*.tgz;*.lzh;*.jar";
													break;
			}
			
			var fileFilter:FileFilter = new FileFilter( paramFirst, paramSecond );
			var filterSet:Array = [ fileFilter ];
			
			return filterSet;
		}
		
		/**
		 *  EventHandler
		 *  파일 선택시 
		 */ 
		private function onSelectHandler( event:Event ):void
		{
			var e:Event = new FileLoadDataEvent( FileLoadDataEvent.FILE_SELECT );
			dispatchEvent( e );
			
			if ( _isUpLoad ) // 업로드 인지 여부
			{
				var request:URLRequest = new URLRequest();
				request.url = _requestURL;

				_fileReference.upload( request );
				initFileEventListener( _fileReference );
			}
			else
			{
				if ( _isMulti ) // 멀티 파일 처리 인지 여부
				{
			       _pendingTotal = _fileReferenceList.fileList.length;
			       
			        for each ( var file:FileReference in _fileReferenceList.fileList ) 
			        {
			        	// 멀티 일 경우 파일 렌퍼런스 객체들을 순차적으로 루프 돌며 로컬 로더하는 메서드 호출
						addPendingFileReference( file );
			        }
				}
				else
				{
					// 단일 일 경우 바로 로컬 로더 호출
					_fileReference.load();
			       initFileEventListener( _fileReference );
				}
			}
		}
		
		/**
		 *  복수개 파일 레퍼런스 인 경우 로컬 로더 호출
		 *  @param file 파일 레퍼런스
		 */ 
		private function addPendingFileReference( file:FileReference ):void 
	    {
	    	file.load();
	        initFileEventListener( file );
	    }
		
		/**
		 *  파일 선택시 파일 레퍼런스 이벤트 리스너 등록 
		 *  @param target 이벤트 객체
		 */ 
		private function initFileEventListener( target:IEventDispatcher ):void
		{
			if ( _isUpLoad ) target.addEventListener( DataEvent.UPLOAD_COMPLETE_DATA, onUploadCompleteHandler );
			else             target.addEventListener( Event.COMPLETE, onCompleteHandler );
			
			target.addEventListener( IOErrorEvent.IO_ERROR, onErrorHandler );
		    target.addEventListener( SecurityErrorEvent.SECURITY_ERROR, onErrorHandler );
		}
		
		/**
		 *  파일 로더 데이타, 단일 파일 일 경우
		 *  @param isData ByteArray를 로드할지 URL을 로드할지 여부
		 *  @param value ByteArray 또는 URL
		 */ 
		public function loadData( isData:Boolean, value:* ):void
		{
			if ( !value ) return;
			
			_isData = isData;
			
			_loader = new Loader();
			_loader.contentLoaderInfo.addEventListener( Event.COMPLETE, onLoadCompleteHandler );
			_loader.contentLoaderInfo.addEventListener( IOErrorEvent.IO_ERROR, onErrorHandler );
			_loader.contentLoaderInfo.addEventListener( SecurityErrorEvent.SECURITY_ERROR, onErrorHandler );
			
			if ( _isData )
			{
				_loader.loadBytes( value as ByteArray );
			}
			else
			{
				var request:URLRequest = new URLRequest();
				request.url = value;
				
				var context:LoaderContext = new LoaderContext();
				context.checkPolicyFile = true;
				
				_loader.load( request, context );
			}
		}
		
		/**
		 *  파일 데이타 로더 - 멀티 파일 일 경우, 로드가 완료된 순서로 담아 준다.
		 *  @param isData ByteArray를 로드할지 URL을 로드할지 여부
		 *  @param value ByteArray 또는 URL 복수개 배열
		 */ 
		public function loadMultiData( isData:Boolean, valueArr:Array ):void
		{
			initFileLoadData();
			
			_pendingTotal = valueArr.length;
			_valueArr = valueArr;
			_isData = isData;
			_isMulti = true;
			

			var request:URLRequest = null;
			var i:int = 0;
			
			// 멀티 개수만큼 로더 등록
			if ( _isData )
			{
				for ( i=0; i<_pendingTotal; i++ )
				{
					_loaders[i] = new Loader();
					_loaders[i].contentLoaderInfo.addEventListener( Event.COMPLETE, onLoadCompleteHandler );
					_loaders[i].contentLoaderInfo.addEventListener( IOErrorEvent.IO_ERROR, onErrorHandler );
					_loaders[i].contentLoaderInfo.addEventListener( SecurityErrorEvent.SECURITY_ERROR, onErrorHandler );
					
					Loader( _loaders[i] ).loadBytes( valueArr[i] );
				}
			}
			else
			{
				for ( i=0; i<_pendingTotal; i++ )
				{
					request = new URLRequest();
					request.url = valueArr[i];
					
					_loaders[i] = new Loader();
					_loaders[i].contentLoaderInfo.addEventListener( Event.COMPLETE, onLoadCompleteHandler );
					_loaders[i].contentLoaderInfo.addEventListener( IOErrorEvent.IO_ERROR, onErrorHandler );
					_loaders[i].contentLoaderInfo.addEventListener( SecurityErrorEvent.SECURITY_ERROR, onErrorHandler );
					
					Loader( _loaders[i] ).load( request );
				}
			}
		}
		
		/**
		 *  파일 데이타 로더 - 멀티 파일 일 경우, 들어온 데이타 배열 순서대로 담아 준다.
		 *  @param isData ByteArray를 로드할지 URL을 로드할지 여부
		 *  @param value ByteArray 또는 URL 복수개 배열
		 */ 
		public function loadMultiStepData( isData:Boolean, valueArr:Array ):void
		{
			initFileLoadData();
			
			_pendingTotal = valueArr.length;
			_valueArr = valueArr;
			_isData = isData;
			_isMulti = true;
			_isStep = true;
			
			// 첫번째 데이타 부터 로더 등록
			loadData( _isData, valueArr[ _pendingCount ] );
		}
		
		/**
		 *  모든 속성 및 객체 초기화
		 */ 
		private function initFileLoadData():void
		{
			_fileReference = null;
			_fileReferenceList = null;
			_loader = null;
			
			_loaders = [];
			_loaderInfos = [];
			_fileReferences = [];
			_valueArr = [];
			
			_isStep = false;
			_isMulti = false;
			_isData = false;
			
			_pendingCount = 0;
			_pendingTotal = 0;
		}
		
		/**
		 *  EventHandler
		 *  파일 선택 취소
		 */ 
		private function onCancelHandler( event:Event ):void
		{
			initFileLoadData();
		}
		
		/**
		 *  EventHandler
		 *  로더 파일 레퍼런스 완료
		 */ 
		private function onCompleteHandler( event:Event ):void
		{
			var data:* = null;
			
			if ( _isMulti )
			{
				var file:FileReference = FileReference( event.target );
				
				_pendingCount++;
				_fileReferences.push( file );
				
				// 멀티 일 경우 멀티 카운트와 현재 카운트를 비교하여 같은 경우에만 이벤트에 파일 레퍼런스 데이타 담아 전송
				if ( _pendingCount != _pendingTotal ) return;
				
				data = _fileReferences;
			}
			else
			{
				// 단일 일 경우 바로 이벤트에 파일 레퍼런스 데이타 담아 전송
				data = _fileReference;
			}
			
			var e:Event = new FileLoadDataEvent( FileLoadDataEvent.FILE_COMPLETE, data );
			dispatchEvent( e );
		}
		
		/**
		 *  EventHandler
		 *  파일 로더 완료  
		 */
		private function onLoadCompleteHandler( event:Event ):void
		{
			var data:* = null;
			
			if ( _isMulti )
			{
				// 멀티 파일이며 순차적으로 처리 일 경우
				_loaderInfos.push( event.target ); 
				
				_pendingCount++;
				
				// 멀티 일 경우 멀티 카운트와 현재 카운트를 비교하여 같은 경우에만 이벤트에 로더 데이타 담아 전송
				if ( _pendingCount != _pendingTotal ) 
				{
					// 멀티 파일이며 순차적으로 처리 일 경우 순차적으로 로더 등록
					if ( _isStep ) loadData( _isData, _valueArr[ _pendingCount ] );
//					trace( _pendingCount, _valueArr[ _pendingCount ] );
					return;
				}
				
				data = _loaderInfos;
			}
			else
			{
				// 단일 일 경우 바로 이벤트에 로더 데이타 담아 전송
				data = LoaderInfo( event.target );
			}

			var e:Event = new FileLoadDataEvent( FileLoadDataEvent.LOADER_COMPLETE, data );
			dispatchEvent( e );
		}
		
		/**
		 *  EventHandler
		 *  업로드 파일 레퍼런스 완료
		 */ 
		private function onUploadCompleteHandler( event:DataEvent ):void
		{
			var fileSavePath:String = event.data.toString();
			var e:Event = new FileLoadDataEvent( FileLoadDataEvent.UPLOAD_COMPLETE, fileSavePath );
			dispatchEvent( e );
		}
		
		/**
		 *  EventHandler
		 *  모든 오류 처리  
		 */
		private function onErrorHandler( event:ErrorEvent ):void
		{
			trace("Error Message : ", event.type );
			
			var e:Event = new FileLoadDataEvent( FileLoadDataEvent.ERROR_DATA );
			dispatchEvent( e );
		}
	}
}