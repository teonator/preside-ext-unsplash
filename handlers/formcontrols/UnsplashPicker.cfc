component {

	property name="unsplashApiWrapper"  inject="UnsplashApiWrapper";
	property name="assetManagerService" inject="AssetManagerService";

	public string function index( event, rc, prc, args={} ) {
		args.inputName        = args.name         ?: "";
		args.inputId          = args.id           ?: "";
		args.selectedPhotoUrl = "";

		args.defaultValue = args.defaultValue ?: "";
		args.inputValue   = event.getValue( name=args.inputName, defaultValue=args.defaultValue );
		if ( not isSimpleValue( args.inputValue ) ) {
			args.inputValue = "";
		}
		args.inputValue = htmlEditFormat( args.inputValue );

		var asset = assetManagerService.getAsset( id=args.inputValue );
		if ( asset.recordCount ) {
			args.selectedPhotoUrl = asset.asset_url;
		}

		return renderView( view="formcontrols/unsplashPicker/index", args=args );
	}

	public string function gallery( event, rc, prc, args={} ) {
		event.setXFrameOptionsHeader( "" );

		event.setLayout( "adminModalDialog" );
		event.setView( "formcontrols/unsplashPicker/gallery" );
	}

	public void function ajaxImport( event, rc, prc, args={} ) {
		var photoUrl = rc.photoUrl ?: "";
		var assetId  = "";

		try {
			cfhttp( method="GET", url=photoUrl, result="result" );

			assetId = assetManagerService.addAsset(
				  fileBinary = result.fileContent
				, fileName   = createUUID() & ".jpg"
				, folder     = ""
			);
		} catch( any e ) {
			logError( e );
		}

		event.renderData( type="JSON", data={ id=assetId } );
	}

	public void function ajaxPhotos( event, rc, prc ) {
		var photos  = arrayNew();
		var keyword = rc.keyword ?: "";
		var page    = rc.page    ?: 1;
		var uri     = keyword.len() ? "search/photos" : "photos";

		photos = unsplashApiWrapper.call(
			  uri    = uri
			, params = {
				  query    = keyword
				, page     = page
				, per_page = 12
			}
		);

		event.renderData( type="JSON", data=photos );
	}

}