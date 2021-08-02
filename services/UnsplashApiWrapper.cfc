/**
 * @singleton      true
 * @presideService true
 */
component {

	public any function init() {
		return this;
	}

	public any function call(
		  required string uri
		,          string method = "GET"
		,          struct params = {}
		,          string body   = ""
	) {
		var apiUrl       = "https://api.unsplash.com/" & arguments.uri
		var apiResult    = structNew();
		var apiAccessKey = $getPresideSetting( "unsplash", "accessKey", "" );
		var apiParams    = "";

		try {
			if ( !apiAccessKey.len() ) {
				throw( "Unsplash API key is required", "unsplash.api.key.invalid" );
			}

			for ( var key in arguments.params ) {
				apiParams = listAppend( apiParams, "#key#=#arguments.params[ key ]#", "&" );
			}

			if ( apiParams.len() ) {
				apiUrl = "#apiUrl#?#apiParams#";
			}

			http url=apiUrl method=arguments.method result="apiResult" timeout=30 {
				httpparam type="header" name="Authorization" value="Client-ID #apiAccessKey#";

				if ( len( trim( arguments.body ) ) ) {
					httpparam type="body" value=arguments.body;
				}
			}
		} catch( any e ) {
			$raiseError( e );
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

			var deserializedResult = deserializeJson( content );

			if ( isArray( deserializedResult ) ) {
				processedResult = deserializedResult;
			} else {
				processedResult = deserializedResult.results;
			}
		} catch( any e ) {
			$raiseError( e );
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