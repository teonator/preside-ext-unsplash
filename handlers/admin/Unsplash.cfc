component {

	public void function index( event, rc, prc, args={} ) {
		var photos  = arrayNew();
		var keyword = rc.keyword ?: "";
		var page    = rc.page    ?: 1;
		var uri     = keyword.len() ? "search/photos" : "photos";

		photos = call(
			  uri    = uri
			, params = {
				  query    = keyword
				, page     = page
				, per_page = 12
			}
		);

		event.renderData( type="JSON", data=photos );
	}

	public string function gallery( event, rc, prc, args={} ) {
		event.setXFrameOptionsHeader( "" );

		event.setLayout( "adminModalDialog" );
		event.setView( "admin/unsplash/gallery" );
	}

	public any function call(
		  required string uri
		,          string method = "GET"
		,          struct params = {}
		,          string body   = ""
	) {
		var apiUrl       = "https://api.unsplash.com/" & arguments.uri
		var apiResult    = structNew();
		var apiAccessKey = getSystemSetting( "unsplash", "accessKey" );
		var apiParams    = "";

		for ( var key in arguments.params ) {
			apiParams = listAppend( apiParams, "#key#=#arguments.params[ key ]#", "&" );
		}

		if ( apiParams.len() ) {
			apiUrl = "#apiUrl#?#apiParams#";
		}

		try {
			http url=apiUrl method=arguments.method result="apiResult" timeout=30 {
				httpparam type="header" name="Authorization" value="Client-ID #apiAccessKey#";
				// httpparam type="header" name="Content-Type"  value="application/json";

				// for ( var key in arguments.params ) {
				// 	httpparam type=paramType name=key value=arguments.params[ key ];
				// }

				if ( len( trim( arguments.body ) ) ) {
					httpparam type="body" value=arguments.body;
				}
			}
		} catch( any e ) {
			// $raiseError( e );
			writeDump( e );
		}

		return _processResult( result=apiResult );
	}

	private any function _processResult( required struct result ) {
		var processedResult = structNew();
		var content         = result.fileContent ?: "";

		try {
			if( !isJson( content ) ) {
				var errorDetail = result.errordetail ?: "";

				throw( "Unexpected response from API call: #errorDetail#", "unsplash.api.bad.response", content );
			}

			// if( code < 200 && code > 299 ) {

			// }

			var deserializedResult = deserializeJson( content );

			if ( isArray( deserializedResult ) ) {
				processedResult = deserializedResult;
			} else {
				processedResult = deserializedResult.results;
			}
		} catch( any e ) {
			// $raiseError( e );
			writeDump( e );
		}

		return _formatResult( processedResult );
	}

	private array function _formatResult( required array result ) {
		var formattedResult = arrayNew();

		for ( var row in result ) {
			formattedResult.append( {
				  id          = row.id
				, description = row.description ?: ( row.alt_description ?: "" )
				, author      = row.user.name
				, username    = row.user.username
				, image       = row.urls.regular
				, link        = row.links.html
				, download    = row.links.download
			} );
		}

		return formattedResult;
	}

}