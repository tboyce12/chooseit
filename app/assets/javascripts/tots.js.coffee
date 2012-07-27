# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

# Load google image search API
gReady = false
imageSearch = null
aResults = []
bResults = []
aIndex = 0
bIndex = 0
OnLoad = () ->
	gReady = true
google.setOnLoadCallback(OnLoad);
google.load('search', '1');

# Timer function
delay = (ms, func) -> setTimeout func, ms

# JQuery init objects
$ ->
	# Populate google field when text is changed
	$('#a_image_text,#b_image_text').change -> chooseit_changed(this)
	
	# If browse, upload image then display it
	$('#upload_a_image,#upload_b_image').change -> browse_changed(this)
	
	# If google, search for image then display it
	# $('#a_google_field,#b_google_field').keydown -> google_changed(this)
	# Get next result each time button is clicked
	$('#a_google_button,#b_google_button').click (e) ->
		choice = if this.id == 'a_google_button' then 'a' else 'b'
		if choice == 'a' then a_google_clicked() else b_google_clicked()
	# Pressing ENTER should also work
	$('#a_google_field,#b_google_field').keyup (e) ->
		choice = if this.id == 'a_google_field' then 'a' else 'b'
		# if e.which == 13 then setTimeout("google_clicked('#{choice}');", 3000)
		if e.which == 13
			if choice == 'a' then setTimeout(a_google_clicked, 0)
			else setTimeout(b_google_clicked, 0)
		else
			if choice == 'a' then setTimeout(a_google_changed, 0)
			else setTimeout(b_google_changed, 0)
	
	# If URL, display image
	$('#a_url_field,#b_url_field').change -> url_changed(this)
	
	# Submit when button clicked
	$('#submit_button').click -> submit_clicked(this)
	
	# Resize images
	# $('#a_resize,#b_resize,img.resize').load -> resize_img(this)
	
	# Click row in index table
	$('tr.index_tot').click -> tr_clicked(this)

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

a_google_changed = () -> google_changed($('#a_google_field'))
b_google_changed = () -> google_changed($('#b_google_field'))
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

# Load results
# Set the URL field for a completed image search
searchComplete = (choice) ->
	if (imageSearch.results && imageSearch.results.length > 0)
		# Build myResults array
		myResults = new Array()
		for result in imageSearch.results
			myResult = {'url':result.url, 'tbUrl':result.tbUrl}
			myResults.push myResult
		# Save myResults in aResults or bResults, reset index
		if choice == 'a'
			aResults = myResults
			aIndex = 0
		else
			bResults = myResults
			bIndex = 0
		
		# # Get result URL
		# 		result = imageSearch.results[0]
		# 		# Only use first result for now
		# 		url = result.url
		# 		tbUrl = result.tbUrl
		# 		# Display URL
		# 		choose_by_google(choice)
		# 		display_image(url, choice, tbUrl)

a_google_clicked = () -> google_clicked('a')
b_google_clicked = () -> google_clicked('b')
google_clicked = (choice) ->
	# choice = null
	# 	if $(elem).attr('id') == 'a_google_button' || $(elem).attr('id') == 'a_google_field'
	# 		choice = 'a'
	# 	else
	# 		choice = 'b'
	# choice = if $(elem).attr('id') == 'a_google_button' then 'a' else 'b'
	# Get result, cycle index
	result = null
	if choice == 'a'
		return if aResults.length == 0
		result = aResults[aIndex]
		aIndex++
		if aIndex >= aResults.length then aIndex = 0
	else
		return if bResults.length == 0
		result = bResults[bIndex]
		bIndex++
		if bIndex >= bResults.length then bIndex = 0
	# Display result
	choose_by_google(choice)
	display_image(result['url'], choice, result['tbUrl'])

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
	$("#upload_#{choice}_image").replaceWith("<input type='file' id='upload_#{choice}_image' name='tot[#{choice}_image]' />")
	$('#upload_a_image,#upload_b_image').change -> browse_changed(this)
	# Clear google field
	$("##{choice}_google_field").val('')

# Clear all but google field
choose_by_google = (choice) ->
	#Clear file field
	$("#upload_#{choice}_image").replaceWith("<input type='file' id='upload_#{choice}_image' name='tot[#{choice}_image]' />")
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


# INDEX
tr_clicked = (elem) ->
	id = elem.id
	window.location.href = "/tots/#{id}"
