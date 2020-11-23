component {

	public void function configure( bundle ) {
		bundle.addAsset( id="vuejs",    url="https://cdn.jsdelivr.net/npm/vue@2.6.12/dist/vue.js"    );
		bundle.addAsset( id="axios",    url="https://cdn.jsdelivr.net/npm/axios/dist/axios.min.js"   );
		bundle.addAsset( id="tailwind", url="https://unpkg.com/tailwindcss@^2/dist/tailwind.min.css" );

		bundle.addAsset( id="appCSS", path="/css/app.css" );
		bundle.addAsset( id="appJS", path="/js/app.js" );

		bundle.asset( "appJS" ).dependsOn( "vuejs", "axios" );
	}

}