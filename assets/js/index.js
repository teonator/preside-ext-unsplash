var app = new Vue( {
	  el: "#app"
	, data: {
		  selectedPhotoUrl    : cfrequest.selectedPhotoUrl
		, [cfrequest.inputId] : cfrequest.inputValue
		, iframe              : null
	}
	, methods: {
		openModal: function( event ) {
			var self = this;

			var modal = new PresideIframeModal(
				  cfrequest.unsplashiFrameUrl
				, "100%"
				, "100%"
				, {
					onLoad: function( iframe ) {
						self.iframe = iframe;
					}
				}
				, {
					  title      : "Unsplash"
					, className  : "full-screen-dialog"
					, buttons  : {
						  cancel: {
							  label    : "Cancel"
							, className: "btn-default"
						}
						, ok    : {
							  label    : "Ok"
							, className: "btn-primary"
							, callback : function() {
								axios
									.get(
										  cfrequest.unsplashAjaxImportUrl
										, {
											params: {
											  photoUrl: self.iframe.gallery.$data.selectedPhotoUrl
										}
									} )
									.then(function( response ) {
										self.selectedPhotoUrl = self.iframe.gallery.$data.selectedPhotoUrl;
										self[cfrequest.inputId] = response.data.id;

										modal.close();
									})
									.catch(function( error ) {
										console.log( error );
									})
								;

								return false;
							}
						}
					}
				} )
			;

			modal.open();
		}
		, removePhoto: function( event ) {
			this.selectedPhotoUrl   = "";
			this[cfrequest.inputId] = "";
		}
	}
} );