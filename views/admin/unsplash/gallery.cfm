<cfscript>
	event
		.include( "vuejs" )
		.include( "axios" )
		.include( "tailwind" )
		.include( "appCSS" )
		.include( "appJS" )
	;
</cfscript>

<cfsavecontent variable="js">
var app = new Vue({
	  el: '#app'
	, data: {
		  keyword         : ''
		, selectedPhotoId : ''
		, selectedPhotoUrl: ''
		, isLoading       : false
		, photos          : []
	}
	, watch: {
		keyword: function( newValue, oldValue) {
			this.loadPhotos( newValue );
		}
	}
	, methods: {
		  selectPhoto: function( event ) {
			this.selectedPhotoId = event.target.id;
			this.selectedPhotoUrl = event.target.src;
		}
		, loadPhotos: function( keyword="", page=1 ) {
			let self = this;

			self.isLoading = true;

			axios
				.get( "http://127.0.0.1:41200/admin/unsplash/", {
					params: {
						  keyword: keyword
						, page: page
					}
				} )
				.then(function( response ) {
					self.isLoading = false;
					self.photos    = response.data;
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
});
</cfsavecontent>

<cfset event.includeInlineJs(js)>

<cfoutput>
	<div id="app">
		<div v-cloak>
			<input v-model.lazy.trim="keyword" type="text" id="keyword" name="keyword" value="" placeholder="Search photos" class="form-control" tabindex="#getNextTabIndex()#">

			<div v-if="photos.length > 0" class="grid max-w-full mx-auto py-6">
				<div v-for="( photo, key, index ) in photos" :key="photo.id" class="relative">
					<div v-cloak v-if="selectedPhotoId === photo.id" class="absolute top-4 right-4">
						<div class="rounded-full h-12 w-12 flex items-center justify-center bg-green-500">
	  						<span class="fa fa-check text-white"></span>
						</div>
					</div>

					<img v-bind:id="photo.id" v-bind:src="photo.image" v-on:click.prevent="selectPhoto" class="object-cover h-48 w-full rounded-md cursor-pointer bg-gray-100">

					<h5 class="text-base truncate align-middle m-0 p-0">
						<span>
							by <a v-bind:href="photo.username | link" class="leading-9 no-underline" target="_blank">{{ photo.author }}</a>
						</span>
					</h5>
				</div>
			</div>

			<div v-else>
				<p v-if="isLoading" class="text-xl text-center py-6">Loading photos...</p>
				<p v-else class="text-xl text-center py-6">No photos found for "{{ keyword }}".</p>
			</div>

			<button v-on:click.prevent="">Show more</button>
		</div>
	</div>
</cfoutput>