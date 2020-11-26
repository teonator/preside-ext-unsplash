component {

	public void function configure( bundle ) {
		bundle.addAsset( id="vuejs"   , url="https://cdn.jsdelivr.net/npm/vue@2.6.12/dist/vue.js"    );
		bundle.addAsset( id="axios"   , url="https://cdn.jsdelivr.net/npm/axios/dist/axios.min.js"   );
		bundle.addAsset( id="tailwind", url="https://unpkg.com/tailwindcss@^2/dist/tailwind.min.css" );

		bundle.addAsset( id="unsplashStyle"      , path="/css/app.css" );
		bundle.addAsset( id="unsplashFormControl", path="/js/index.js" );
		bundle.addAsset( id="unsplashGallery"    , path="/js/gallery.js" );

		bundle.asset( "unsplashFormControl" ).dependsOn( "vuejs", "axios" );
		bundle.asset( "unsplashGallery" ).dependsOn( "vuejs", "axios" );
	}

}