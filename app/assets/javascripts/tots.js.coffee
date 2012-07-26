# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
imageSearch = null
delay = (ms, func) -> setTimeout func, ms
$ ->
	# Populate google field when text is changed
	$('#a_image_text,#b_image_text').change -> chooseit_changed(this)
	
	# If browse, upload image then display it
	$('#upload_a_image,#upload_b_image').change -> browse_changed(this)
	
	# If google, search for image then display it
	$('#a_google_field,#b_google_field').change -> google_changed(this)
	# Get next result each time button is clicked
	$('#a_google_button,#b_google_button').click -> google_clicked(this)
	
	# If URL, display image
	$('#a_url_field,#b_url_field').change -> url_changed(this)
	
	# Submit when button clicked
	$('#submit_button').click -> submit_clicked(this)
	
	# Resize images
	# $('#a_resize,#b_resize,img.resize').load -> resize_img(this)

chooseit_changed = (elem) ->
	choice = if $(elem).attr('id') == 'a_image_text' then 'a' else 'b'

browse_changed = (elem) ->
	# Determine choice
	choice = if $(elem).attr('id') == 'upload_a_image' then 'a' else 'b'
	# Clear other fields
	choose_by_file(choice)
	# Get file data from elem
	data = new FormData()
	jQuery.each($(elem)[0].files, (i, file) ->
		data.append('file_'+i, file)
	)
	# AJAX file to server
	$.ajax({
		url:'/temp_files',
		data:data,
		cache:false,
		contentType:false,
		headers:{
			chooseit_choice:choice
		}
		processData:false,
		type:'POST',
		success:ajax_success,
		error:ajax_failure
	})
	
ajax_success = (result,status,xhr) ->
	result = jQuery.parseJSON(result)
	image_upload_success(result.url, result.choice)
ajax_failure = (xhr,status,error) ->
	alert "AJAX error:\n" + error

# TempFile upload done, create new img tag in div
image_upload_success = (url, choice) ->
	if choice == 'a'
		$('#a_image_preview').empty()
		$('#a_image_preview').append('<img src="'+url+'" alt="preview" />')
	else
		$('#b_image_preview').empty()
		$('#b_image_preview').append('<img src="'+url+'" alt="preview" />')

# Display image for the new URL
url_changed = (elem) ->
	# Determine choice (a or b)
	choice = if $(elem).attr('id') == 'a_url_field' then 'a' else 'b'
	# Get the new URL
	url = $("##{choice}_url_field").val()
	# Display new image
	display_image(url, choice)
	# Clear browse input
	choose_by_url(choice)

google_changed = (elem) ->
	return if !gReady
	# Determine choice and query
	choice = if $(elem).attr('id') == 'a_google_field' then 'a' else 'b'
	query = $(elem).val()
	# Perform google image search
	imageSearch = new google.search.ImageSearch()
	imageSearch.setSearchCompleteCallback(null, searchComplete, [choice])
	imageSearch.execute(query)
	# google.search.Search.getBranding('branding')

# Set the URL field for a completed image search
searchComplete = (choice) ->
	if (imageSearch.results && imageSearch.results.length > 0)
		# Get result URL
		result = imageSearch.results[0]
		# Only use first result for now
		url = result.url
		tbUrl = result.tbUrl
		# Display URL
		choose_by_google(choice)
		display_image(url, choice, tbUrl)
		
google_clicked = (elem) ->
	choice = if $(elem).attr('id') == 'a_google_button' then 'a' else 'b'

# Display specified image by URL and choice
display_image = (url, choice, backupUrl) ->
	# Empty div containing image
	div = $("##{choice}_image_preview")
	div.empty()
	# Create img tag with src=url, append to div
	img = document.createElement('img')
	img.src = url
	div.append(img)
	# Fallback to thumb if image fails to load
	$("##{choice}_url_field").val(url)
	$(img).error -> fix_url(img, choice, url, backupUrl)
	
# cleanup_image = (img, choice, url, backupUrl) ->
# 	# alert "image:#{img}, choice:#{choice}, url:#{url}, backupUrl:#{backupUrl}"
# 	# resize_img(img)
# 	url = fix_url(img, url, backupUrl) # Use backup if necessary
# 	# Fill in URL field
# 	$("##{choice}_url_field").val(url)

fix_url = (img, choice, url, backupUrl) ->
	# width = $(img).width()
	# 	height = $(img).height()
	# 	if width == 0 && height == 0
	return if !backupUrl
	alert 'using backup URL'
	img.src = backupUrl
	$("##{choice}_url_field").val(backupUrl)
	
# resize_img = (img) ->
# 	width = $(img).width()
# 	height = $(img).height()
# 	if width > 300 || height > 300
# 		if width >= height
# 			$(img).width('300px')
# 		else
# 			$(img).height('300px')

# Clear all but URL field
choose_by_url = (choice) ->
	# Clear file field
	$("#upload_#{choice}_image").replaceWith("<input type='file' id='upload_#{choice}_image' />")
	$('#upload_a_image,#upload_b_image').change -> browse_changed(this)
	# Clear google field
	$("##{choice}_google_field").val('')

# Clear all but google field
choose_by_google = (choice) ->
	#Clear file field
	$("#upload_#{choice}_image").replaceWith("<input type='file' id='upload_#{choice}_image' />")
	$('#upload_a_image,#upload_b_image').change -> browse_changed(this)
	#Clear URL field
	$("##{choice}_url_field").val('')

# Clear all but file field
choose_by_file = (choice) ->
	# Clear google field
	$("##{choice}_google_field").val('')
	# Clear URL field
	$("##{choice}_url_field").val('')

submit_clicked = (elem) ->
	$('#tot_form').submit()

