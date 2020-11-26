<cfscript>
	event.includeData( { unsplashiFrameUrl=event.buildLink( linkTo="formcontrols.unsplashPicker.ajaxPhotos" ) } );

	event
		.include( "vuejs" )
		.include( "axios" )
		.include( "tailwind" )
		.include( "unsplashStyle" )
		.include( "unsplashGallery" )
	;
</cfscript>

<cfoutput>
	<div id="gallery">
		<div v-cloak>
			<input v-model.lazy.trim="keyword" type="text" id="keyword" name="keyword" value="" placeholder="Search photos" class="form-control">

			<div v-if="photos.length > 0">
				<div class="grid max-w-full mx-auto py-6">
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

				<div class="text-center text-xl">
					<a v-on:click.prevent="loadPhotos( keyword, ++page )" href="##">Show more</a>
				</div>
			</div>

			<div v-else>
				<p v-if="isLoading" class="text-xl text-center py-6">Loading photos...</p>
				<p v-else class="text-xl text-center py-6">No photos found for "{{ keyword }}".</p>
			</div>
		</div>
	</div>

</cfoutput>