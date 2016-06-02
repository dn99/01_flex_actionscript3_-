package com.euc.flash.model
{
	import com.euc.flash.data.vo.BasicBase;
	import com.euc.flash.data.vo.BasicVO;
	import com.euc.flash.data.vo.FileVO;
	import com.euc.flash.data.vo.ImageBase;
	import com.euc.flash.data.vo.ImageVO;
	import com.euc.flash.data.vo.MovieBase;
	import com.euc.flash.data.vo.MovieVO;
	import com.euc.flash.data.vo.PropBase;
	import com.euc.flash.data.vo.PropVO;
	import com.euc.flash.events.ConvertEvent;
	import com.euc.flash.manager.DataManager;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import mx.rpc.xml.Schema;
	import mx.rpc.xml.SchemaManager;
	import mx.rpc.xml.SchemaTypeRegistry;
	import mx.rpc.xml.XMLDecoder;
	import mx.rpc.xml.XMLEncoder;
	import mx.utils.ObjectUtil;
	
	public class ConvertibleModel extends EventDispatcher
	{
		private var _xmlURL:String;					// XML URL
		private var _xml:XML;						// XML
		private var _xmlLocal:XML;					// LOCAL XML
		
		private var _isLoadXML:Boolean;				// XML URL을 이용하는지 여부
		private var _isToXML:Boolean;				// VO to XML 인지 여부
		
		private var _schema:Schema;					// XML 스키마
		private var _schemaManager:SchemaManager;	// XML 스키마 매니저
		
		private var _dataManager:DataManager = DataManager.getInstance();
		
		// 플래시 데이타 처리 XML 스키마
		private var _schemaXML:XML = 
			<xsd:schema xmlns:xsd="http://www.w3.org/2001/XMLSchema">
				<xsd:element name="flashData">
					<xsd:complexType >
						<xsd:sequence >
							<xsd:element name="basicVO" type="basicVO"/>
							<xsd:element name="fileVO" type="fileVO"/>
							<xsd:element minOccurs="0" maxOccurs="unbounded" name="imageVO" type="imageVO"/>
							<xsd:element minOccurs="0" maxOccurs="unbounded" name="movieVO" type="movieVO"/>
							<xsd:element minOccurs="0" maxOccurs="unbounded" name="propVO" type="propVO"/>
						</xsd:sequence>
					</xsd:complexType>
				</xsd:element>
				<xsd:complexType name="basicVO">
					<xsd:sequence>
						<xsd:element name="cateServiceType" type="xsd:string" />
						<xsd:element name="cateUseInfo" type="xsd:string" />
						<xsd:element name="compDescription" type="xsd:string" />
						<xsd:element name="compImageName" type="xsd:string" />
						<xsd:element name="extension" type="xsd:string" />
						<xsd:element name="infoDescription" type="xsd:string" />
						<xsd:element name="infoTitle" type="xsd:string" />
						<xsd:element name="stageAlpha" type="xsd:string" />
						<xsd:element name="stageColor" type="xsd:integer" />
						<xsd:element name="subType" type="xsd:string" />
						<xsd:element name="swfHeight" type="xsd:integer" />
						<xsd:element name="swfWidth" type="xsd:integer" />
						<xsd:element name="titleEN" type="xsd:string" />
						<xsd:element name="titleKO" type="xsd:string" />
					</xsd:sequence>
				</xsd:complexType>
				<xsd:complexType name="fileVO">
					<xsd:sequence>
						<xsd:element name="nameFLA" type="xsd:string" />
						<xsd:element name="nameSWF" type="xsd:string" />
						<xsd:element name="sizeSWF" type="xsd:integer" />
					</xsd:sequence>
				</xsd:complexType>
				<xsd:complexType name="imageVO">
					<xsd:sequence>
						<xsd:element name="extension" type="xsd:string" />
						<xsd:element name="imageIndex" type="xsd:integer" />
						<xsd:element name="imageName" type="xsd:string" />
						<xsd:element name="imagePath" type="xsd:string" />
						<xsd:element name="linkPath" type="xsd:string" />
						<xsd:element name="linkTarget" type="xsd:string" />
					</xsd:sequence>
				</xsd:complexType>
				<xsd:complexType name="movieVO">
					<xsd:sequence>
						<xsd:element name="extension" type="xsd:string" />
						<xsd:element name="linkPath" type="xsd:string" />
						<xsd:element name="linkTarget" type="xsd:string" />
						<xsd:element name="movieHeight" type="xsd:integer" />
						<xsd:element name="movieThumbnailPath" type="xsd:string" />
						<xsd:element name="movieWidth" type="xsd:integer" />
						<xsd:element name="movieIndex" type="xsd:integer" />
						<xsd:element name="movieName" type="xsd:string" />
						<xsd:element name="moviePath" type="xsd:string" />
					</xsd:sequence>
				</xsd:complexType>
				<xsd:complexType name="propVO">
					<xsd:sequence>
						<xsd:element name="propFormat" type="xsd:string" />
						<xsd:element name="propIndex" type="xsd:integer" />
						<xsd:element name="propName" type="xsd:string" />
						<xsd:element name="varName" type="xsd:string" />
						<xsd:element name="varOption" type="xsd:string" />
						<xsd:element name="varType" type="xsd:string" />
						<xsd:element name="varValue" type="xsd:string" />
					</xsd:sequence>
				</xsd:complexType>
			</xsd:schema>;
		
		// 로컬 XML 처리 XML 스키마
		private var _schemaLocalXML:XML = 
			<xsd:schema xmlns:xsd="http://www.w3.org/2001/XMLSchema">
				<xsd:element name="flashData">
					<xsd:complexType >
						<xsd:sequence >
							<xsd:element name="basicVO" type="basicVO"/>
							<xsd:element minOccurs="0" maxOccurs="unbounded" name="imageVO" type="imageVO"/>
							<xsd:element minOccurs="0" maxOccurs="unbounded" name="movieVO" type="movieVO"/>
							<xsd:element minOccurs="0" maxOccurs="unbounded" name="propVO" type="propVO"/>
						</xsd:sequence>
					</xsd:complexType>
				</xsd:element>
				<xsd:complexType name="basicVO">
					<xsd:sequence>
						<xsd:element name="swfWidth" type="xsd:integer" />
						<xsd:element name="swfHeight" type="xsd:integer" />
						<xsd:element name="stageColor" type="xsd:integer" />
						<xsd:element name="stageAlpha" type="xsd:string" />
					</xsd:sequence>
				</xsd:complexType>
				<xsd:complexType name="imageVO">
					<xsd:sequence>
						<xsd:element name="imagePath" type="xsd:string" />
						<xsd:element name="linkPath" type="xsd:string" />
						<xsd:element name="linkTarget" type="xsd:string" />
					</xsd:sequence>
				</xsd:complexType>
				<xsd:complexType name="movieVO">
					<xsd:sequence>
						<xsd:element name="moviePath" type="xsd:string" />
						<xsd:element name="movieWidth" type="xsd:integer" />
						<xsd:element name="movieHeight" type="xsd:integer" />
						<xsd:element name="linkPath" type="xsd:string" />
						<xsd:element name="linkTarget" type="xsd:string" />
					</xsd:sequence>
				</xsd:complexType>
				<xsd:complexType name="propVO">
					<xsd:sequence>
						<xsd:element name="propName" type="xsd:string" />
						<xsd:element name="varName" type="xsd:string" />
						<xsd:element name="varType" type="xsd:string" />
						<xsd:element name="varValue" type="xsd:string" />
					</xsd:sequence>
				</xsd:complexType>
			</xsd:schema>;
		
		/**
		 *  Constructor.
		 */ 
		public function ConvertibleModel() {}
		
		/**
		 *  XML URL 을 통해 VO 에 매핑 
		 * 	@param xmlURL XML URL
		 */
		public function setLoadXMLToVO( xmlURL:String ):void
		{
			_xmlURL = xmlURL;
			_isLoadXML = true;
			
			initXMLSchema();
		}
		
		/**
		 *  XML 을 통해 VO 에 매핑
		 *  @param xml XML
		 */ 
		public function setXMLToVO( xml:XML ):void
		{
			_xml = xml;
			_isToXML = false;
			
			initXMLSchema();
		}
		
		/**
		 *  LOCAL XML 을 통해 VO 에 매핑
		 *  @param xmlLocal LOCAL XML
		 */ 
		public function setLocalXMLToVO( xmlLocal:XML ):void
		{
			_xmlLocal = xmlLocal;
			
			initXMLSchema( true );
		}
		
		/**
		 *  VO 를 XML 로 처리
		 */ 
		public function setVOToXML():void
		{
			_isToXML = true;
			
			initXMLSchema();
		}
		
		/**
		 *  initialize 스키마
		 *  @param isLocal LOCAL XML 인지 여부
		 */ 
		private function initXMLSchema( isLocal:Boolean=false ):void
		{
			if ( isLocal )
			{
				_schema = new Schema( _schemaLocalXML );
				setLocalXMLSchema();
			}
			else
			{
				_schema = new Schema( _schemaXML );
				setXMLSchema();
			}
		}
		
		/**
		 *  스키마 셋팅, 로컬 XML
		 */ 
		private function setLocalXMLSchema():void
		{
			_schemaManager = new SchemaManager();
			_schemaManager.addSchema( _schema );
			
			var schemaURI:String = _schema.targetNamespace.uri;
			var basicQName:QName = new QName( schemaURI, DataManager.BASIC );
			var imageQName:QName = new QName( schemaURI, DataManager.IMAGE );
			var movieQName:QName = new QName( schemaURI, DataManager.MOVIE );
			var propQName:QName = new QName( schemaURI, DataManager.PROP );
			
			var schemaTypeRegistry:SchemaTypeRegistry = SchemaTypeRegistry.getInstance();
			schemaTypeRegistry.registerClass( basicQName, BasicBase );
			schemaTypeRegistry.registerClass( imageQName, ImageBase );
			schemaTypeRegistry.registerClass( movieQName, MovieBase );
			schemaTypeRegistry.registerClass( propQName, PropBase );
			
			decodeLocalXML();
		}
		
		/**
		 *  스키마 셋팅
		 */ 
		private function setXMLSchema():void
		{
			_schemaManager = new SchemaManager();
			_schemaManager.addSchema( _schema );
			
			var schemaURI:String = _schema.targetNamespace.uri;
			var basicQName:QName = new QName( schemaURI, DataManager.BASIC );
			var fileQName:QName = new QName( schemaURI, DataManager.FILE );
			var imageQName:QName = new QName( schemaURI, DataManager.IMAGE );
			var movieQName:QName = new QName( schemaURI, DataManager.MOVIE );
			var propQName:QName = new QName( schemaURI, DataManager.PROP );
			
			var schemaTypeRegistry:SchemaTypeRegistry = SchemaTypeRegistry.getInstance();
			schemaTypeRegistry.registerClass( basicQName, BasicVO );
			schemaTypeRegistry.registerClass( fileQName, FileVO );
			schemaTypeRegistry.registerClass( imageQName, ImageVO );
			schemaTypeRegistry.registerClass( movieQName, MovieVO );
			schemaTypeRegistry.registerClass( propQName, PropVO );
			
			_dataManager.isExternal = true;
			_dataManager.isInitSkip = true;
			
			if ( _isLoadXML ) 	 loadXML();
			else if ( _isToXML ) encodeXML();
			else 				 decodeXML();
		}
		
		/**
		 *  XML 로드, xmlURL 일 경우
		 */ 
		private function loadXML():void
		{
			var request:URLRequest = new URLRequest();
			request.url = _xmlURL;
			
			var xmlLoader:URLLoader = new URLLoader();
			xmlLoader.addEventListener ( Event.COMPLETE, xmlLoader_completeHandler );
			xmlLoader.addEventListener( IOErrorEvent.IO_ERROR, xmlLoader_faultHandler );
			
			xmlLoader.load( request );
		}
		
		/**
		 *  XML 을 VO 로 매핑
		 */ 
		private function decodeXML():void
		{
			trace( "-------------- setXMLToVO --------------" );
			
			var schemaURI:String = _schema.targetNamespace.uri;
			var qName:QName = new QName( schemaURI, DataManager.DATA );
			
			var xmlDecoder:XMLDecoder = new XMLDecoder();
			xmlDecoder.schemaManager = _schemaManager;
			
			var result:* = xmlDecoder.decode( _xml, qName );
			
			_dataManager.flashData.basicVO = result[ DataManager.BASIC ] as BasicVO;
			_dataManager.flashData.fileVO = result[ DataManager.FILE ] as FileVO;
			_dataManager.flashData.imageVO = result[ DataManager.IMAGE ];
			_dataManager.flashData.movieVO = result[ DataManager.MOVIE ];
			_dataManager.flashData.propVO = result[ DataManager.PROP ];
			
			dispatchEvent( new ConvertEvent( ConvertEvent.XML_TO_VO_COMPLETE ) ); 
		}
		
		/**
		 *  VO 를 XML 로 처리
		 */ 
		private function encodeXML():void
		{
			trace("-------------- getVOToXML --------------");
			
			var schemaURI:String = _schema.targetNamespace.uri;
			var qName:QName = new QName( schemaURI, DataManager.DATA );
			
			var xmlEncoder:XMLEncoder = xmlEncoder = new XMLEncoder();
			xmlEncoder.schemaManager = _schemaManager;
			
			var xmlList:XMLList = xmlEncoder.encode( _dataManager.flashData, qName );
			_xml = XML( xmlList );
			
			dispatchEvent( new ConvertEvent( ConvertEvent.VO_TO_XML_COMPLETE, _xml ) );
		}
		
		/**
		 *  LOCAL XML 을 VO 로 매핑
		 */ 
		private function decodeLocalXML():void
		{
			trace( "-------------- setXMLToBase --------------" );
			
			var schemaURI:String = _schema.targetNamespace.uri;
			var qName:QName = new QName( schemaURI, DataManager.DATA );
			
			var xmlDecoder:XMLDecoder = new XMLDecoder();
			xmlDecoder.schemaManager = _schemaManager;
			
			var result:* = xmlDecoder.decode( _xmlLocal, qName );
			
			var name:String = "";
			var obj:Object = null;
			var objInfo:Object = null;
			
			objInfo = ObjectUtil.getClassInfo( result[ DataManager.BASIC ] );
			for each ( name in objInfo.properties ) 
			{
				_dataManager.flashData.basicVO[ name ] = result[ DataManager.BASIC ][ name ];
			}
			
			if ( !_dataManager.isExternal && !_dataManager.isInitSkip ) 
			{
				var imageVO:ImageVO = null;
				for each ( obj in result[ DataManager.IMAGE ] )
				{
					imageVO = new ImageVO();
					objInfo = ObjectUtil.getClassInfo( obj );
					for each ( name in objInfo.properties ) 
					{
						imageVO[ name ] = obj[ name ];
					}
					_dataManager.flashData.imageVO.push( imageVO );
				}
				
				var movieVO:MovieVO = null;
				for each ( obj in result[ DataManager.MOVIE ] )
				{
					movieVO = new MovieVO();
					objInfo = ObjectUtil.getClassInfo( obj );
					for each ( name in objInfo.properties ) 
					{
						movieVO[ name ] = obj[ name ];
					}
					_dataManager.flashData.movieVO.push( movieVO );
				}
			}
			
			_dataManager.setTempPropVO();
			_dataManager.initializePropVO();
			
			var indexNum:int = 0;
			var propVO:PropVO = null;
			for each ( obj in result[ DataManager.PROP ] )
			{
				propVO = new PropVO();
				objInfo = ObjectUtil.getClassInfo( obj );
				for each ( name in objInfo.properties ) 
				{
					propVO[ name ] = obj[ name ];
				}
				propVO = getExistPropVO( propVO );
				propVO.propIndex = indexNum;
				
				indexNum++;
				
				_dataManager.flashData.propVO.push( propVO );
			}
			
			function getExistPropVO( propVO:PropVO ):PropVO 
			{
				for each ( var tempPropVO:PropVO in _dataManager.tempData.propVO )
				{
					if ( tempPropVO.varName == propVO.varName )
					{
						propVO.propName = tempPropVO.propName;
						propVO.varName = tempPropVO.varName;
						propVO.varType = tempPropVO.varType;
						propVO.varValue = tempPropVO.varValue;
						
						propVO.propFormat = tempPropVO.propFormat;
						propVO.varOption = tempPropVO.varOption;
					}
				}
				
				return propVO;
			}
			
			dispatchEvent( new ConvertEvent( ConvertEvent.XML_TO_VO_COMPLETE ) );
		}
		
		/**
		 *  EventHandler
		 * 	XML 로드 완료
		 */ 
		private function xmlLoader_completeHandler( event:Event ):void
		{
			_xml = XML( event.target.data );
			decodeXML();
		}
		
		/**
		 *  EventHandler
		 *  XML 로드 실패
		 */ 
		private function xmlLoader_faultHandler( event:IOErrorEvent ):void
		{
			trace( "xmlLoader_faultHandler ", event );
		}
	}
}