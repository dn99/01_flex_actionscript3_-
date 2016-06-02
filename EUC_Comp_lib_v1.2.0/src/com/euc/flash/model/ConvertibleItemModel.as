package com.euc.flash.model
{
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

	public class ConvertibleItemModel extends EventDispatcher
	{
		private var _xml:XML;						// XML
		private var _vo:*;							// VO
		
		private var _isToXML:Boolean;				// VO to XML 인지 여부
		
		private var _schema:Schema;					// XML 스키마
		private var _schemaManager:SchemaManager;	// XML 스키마 매니저
		
		private var _dataManager:DataManager = DataManager.getInstance();
		
		private var _schemaXML:XML = 
			<xsd:schema xmlns:xsd="http://www.w3.org/2001/XMLSchema">
				<xsd:element name="propData">
					<xsd:complexType >
						<xsd:sequence >
							<xsd:element minOccurs="0" maxOccurs="unbounded" name="propVO" type="propVO"/>
						</xsd:sequence>
					</xsd:complexType>
				</xsd:element>
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
		
		public function ConvertibleItemModel() {}
		
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
		 *  VO 를 XML 로 처리
		 */ 
		public function setVOToXML( vo:Array ):void
		{
			_vo = vo;
			_isToXML = true;
			
			initXMLSchema();
		}
		
		/**
		 *  initialize 스키마
		 *  @param isLocal LOCAL XML 인지 여부
		 */ 
		private function initXMLSchema():void
		{
			_schema = new Schema( _schemaXML );
			setXMLSchema();
		}
		
		/**
		 *  스키마 셋팅
		 */ 
		private function setXMLSchema():void
		{
			_schemaManager = new SchemaManager();
			_schemaManager.addSchema( _schema );
			
			var schemaURI:String = _schema.targetNamespace.uri;
			var propQName:QName = new QName( schemaURI, DataManager.PROP );
			
			var schemaTypeRegistry:SchemaTypeRegistry = SchemaTypeRegistry.getInstance();
			schemaTypeRegistry.registerClass( propQName, PropVO );
			
			if ( _isToXML ) encodeXML();
			else 			decodeXML();
		}
		
		/**
		 *  XML 을 VO 로 매핑
		 */ 
		private function decodeXML():void
		{
			trace( "-------------- setXMLToVO --------------" );
			
			var schemaURI:String = _schema.targetNamespace.uri;
			var qName:QName = new QName( schemaURI, DataManager.PROP_DATA );
			
			var xmlDecoder:XMLDecoder = new XMLDecoder();
			xmlDecoder.schemaManager = _schemaManager;
			
			var result:* = xmlDecoder.decode( _xml, qName );
			var propData:Array = result as Array;
			
			var e:ConvertEvent = new ConvertEvent( ConvertEvent.XML_TO_VO_COMPLETE, propData );
			dispatchEvent( e );
		}
		
		/**
		 *  VO 를 XML 로 처리
		 */ 
		private function encodeXML():void
		{
			trace("-------------- getVOToXML --------------");
			
			var schemaURI:String = _schema.targetNamespace.uri;
			var qName:QName = new QName( schemaURI, DataManager.PROP_DATA );
			
			var xmlEncoder:XMLEncoder = xmlEncoder = new XMLEncoder();
			xmlEncoder.schemaManager = _schemaManager;
			
			var xmlList:XMLList = xmlEncoder.encode( _vo, qName );
			var propXML:XML = XML( xmlList );
			
			var e:ConvertEvent = new ConvertEvent( ConvertEvent.VO_TO_XML_COMPLETE, propXML );
			dispatchEvent( e );
		}
	}
}