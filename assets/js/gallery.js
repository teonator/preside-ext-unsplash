var gallery = new Vue( {
	  el: '#gallery'
	, data: {
		  keyword         : ""
		, selectedPhotoId : ""
		, selectedPhotoUrl: ""
		, isLoading       : false
		, isImporting     : false
		, page            : 1
		, photos          : []
	}
	, watch: {
		keyword: function( newValue, oldValue ) {
			if ( oldValue !== newValue ) {
				this.photos = [];
			}

			this.loadPhotos( newValue );
		}
	}
	, methods: {
		  selectPhoto: function( event ) {
			this.selectedPhotoId  = event.target.id;
			this.selectedPhotoUrl = event.target.src;
		}
		, loadPhotos: function( keyword="", page=1 ) {
			let self = this;

			self.isLoading = true;

			axios
				.get(
					  cfrequest.unsplashiFrameUrl
					, {
						params: {
						  keyword: keyword
						, page: page
					}
				} )
				.then(function( response ) {
					self.isLoading = false;
					self.photos    = self.photos.concat( response.data );
				})
				.catch(function( error ) {
					console.log( error );
				})
			;
		}
	}
	, filters: {
		link: function( value ) {
			return "https://unsplash.com/@" + value;
		}
	}
	, mounted: function() {
		this.loadPhotos();
	}
} );