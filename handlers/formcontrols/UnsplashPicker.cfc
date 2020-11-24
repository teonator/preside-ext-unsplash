component {

	property name="unsplashApiWrapper" inject="UnsplashApiWrapper";

	public string function gallery( event, rc, prc, args={} ) {
		event.setXFrameOptionsHeader( "" );

		event.setLayout( "adminModalDialog" );
		event.setView( "formcontrols/unsplashPicker/gallery" );
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