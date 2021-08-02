<cfscript>
	event.includeData( {
		  inputId               = args.inputId
		, inputValue            = args.inputValue
		, selectedPhotoUrl      = args.selectedPhotoUrl
		, unsplashiFrameUrl     = event.buildLink( linkTo="formcontrols.unsplashPicker.gallery"   )
		, unsplashAjaxImportUrl = event.buildLink( linkTo="formcontrols.unsplashPicker.ajaxImport" )
	} );

	event
		.include( "vuejs" )
		.include( "tailwind" )
		.include( "unsplashStyle" )
		.include( "unsplashFormControl" )
	;
</cfscript>

<cfoutput>
	<div id="app">
		<input v-model="#args.inputId#" type="hidden" id="#args.inputId#" name="#args.inputName#">

		<div v-on:click.prevent.self="openModal" class="h-60 w-2/3 rounded-md bg-gray-100 cursor-pointer flex justify-center relative">
			<div v-if="selectedPhotoUrl" class="absolute top-4 right-4">
				<div v-on:click="removePhoto" class="rounded-full h-12 w-12 flex items-center justify-center bg-red-500">
					<span class="fa fa-times text-white"></span>
				</div>
			</div>

			<img
				v-if="selectedPhotoUrl"
				v-bind:src="selectedPhotoUrl"
				class="object-cover h-full w-full rounded-md mb-6 bg-gray-300 cursor-default">

			<div v-else class="self-center text-xl">Select a photo</div>
		</div>
	</div>
</cfoutput>



