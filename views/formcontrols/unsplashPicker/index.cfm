<cfscript>
	inputName        = args.name         ?: "";
	inputId          = args.id           ?: "";
	inputClass       = args.class        ?: "";

	inputPlaceholder = args.placeholder  ?: "";
	inputPlaceholder = htmlEditFormat( translateResource( uri=inputPlaceholder, defaultValue=inputPlaceholder ) );

	defaultValue = args.defaultValue ?: "";
	inputValue   = event.getValue( name=inputName, defaultValue=defaultValue );
	if ( not isSimpleValue( inputValue ) ) {
		inputValue = "";
	}
	inputValue = htmlEditFormat( inputValue );

	iFrameUrl = event.buildAdminLink( linkTo="admin.unsplash.gallery" );

	event
		.include( "vuejs" )
		.include( "tailwind" )
		.include( "appJS" )
	;
</cfscript>

<cfsavecontent variable="js">
var app = new Vue({
	  el: "#app"
	, data: {
		  selectedPhotoUrl : ""
		, iframe           : null
	}
	, methods: {
		openModal: function( event ) {
			var self = this;

			new PresideIframeModal(
				  "http://127.0.0.1:41200/formcontrols/unsplashPicker/gallery/"
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
								self.selectedPhotoUrl = self.iframe.app.$data.selectedPhotoUrl;
							}
						}
					}
				} )
				.open()
			;
		}
		, removePhoto: function( event ) {
			this.selectedPhotoUrl = "";
		}
	}
});
</cfsavecontent>

<cfset event.includeInlineJs(js)>

<cfoutput>
	<div id="app">
		<div v-on:click.prevent.self="openModal" class="h-60 w-2/3 rounded-md bg-gray-100 cursor-pointer flex justify-center relative">
			<div v-if="selectedPhotoUrl" class="absolute top-4 right-4">
				<div v-on:click="removePhoto" class="rounded-full h-12 w-12 flex items-center justify-center bg-red-500">
					<span class="fa fa-times text-white"></span>
				</div>
			</div>

			<img v-if="selectedPhotoUrl" v-bind:src="selectedPhotoUrl" class="object-cover h-full w-full rounded-md mb-6 bg-gray-300 cursor-default">

			<div v-else class="self-center text-xl">Select a photo</div>
		</div>
	</div>
</cfoutput>



