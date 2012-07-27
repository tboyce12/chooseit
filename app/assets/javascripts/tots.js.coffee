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
aMoreHref = ''
bMoreHref = ''
OnLoad = () ->
	gReady = true
google.setOnLoadCallback(OnLoad);
google.load('search', '1');

# Timer function
delay = (ms, func) -> setTimeout func, ms

# JQuery init objects
$ ->
	# Reset border when text is changed
	$('#a_image_text,#b_image_text').keyup -> chooseit_changed(this)
	
	# If browse, upload image then display it
	$('#upload_a_image,#upload_b_image').change -> browse_changed(this)
	
	# Display next result each time google button is clicked
	$('#a_google_button,#b_google_button').click (e) ->
		choice = if this.id == 'a_google_button' then 'a' else 'b'
		if choice == 'a' then a_google_clicked() else b_google_clicked()
	# Detect google field keypresses
	$('#a_google_field,#b_google_field').keyup (e) ->
		choice = if this.id == 'a_google_field' then 'a' else 'b'
		# On ENTER, display result
		if e.which == 13
			if choice == 'a' then setTimeout(a_google_clicked, 0)
			else setTimeout(b_google_clicked, 0)
		# On other keys, perform a new search
		else
			if choice == 'a' then setTimeout(a_google_changed, 0)
			else setTimeout(b_google_changed, 0)
	# Initially hide more results links
	# $('#a_more_results,#b_more_results').hide()
	
	# If URL, display image
	$('#a_url_field,#b_url_field').change -> url_changed(this)
	
	# Submit when button clicked
	$('#submit_button').click -> submit_clicked(this)
	
	# Resize images
	# $('#a_resize,#b_resize,img.resize').load -> resize_img(this)
	
	# Click row in index table
	$('tr.index_tot').click -> tr_clicked(this)
	
	# Apply watermarks
	$('#a_image_text,#b_image_text').watermark('Enter a title or description...')
	$('#a_google_field,#b_google_field').watermark('Search')
	$('#a_url_field,#b_url_field').watermark('Paste image URL')

chooseit_changed = (elem) ->
	choice = if $(elem).attr('id') == 'a_image_text' then 'a' else 'b'
	$("##{choice}_image_text").css('border', '2px solid white')

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
	imageSearch.setResultSetSize(8)
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
			aMoreHref = imageSearch.cursor.moreResultsUrl
		else
			bResults = myResults
			bIndex = 0
			bMoreHref = imageSearch.cursor.moreResultsUrl
		
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
		# On first result, display link for all results
		if aIndex == 0
			div = $('#a_more_results')
			div.empty()
			div.append("<a target='_blank' href='#{aMoreHref}'>Click to view all results</a>")
		result = aResults[aIndex]
		aIndex++
		if aIndex >= aResults.length then aIndex = 0
	else
		return if bResults.length == 0
		# On first result, display link for all results
		if bIndex == 0
			div = $('#b_more_results')
			div.empty()
			div.append("<a target='_blank' href='#{bMoreHref}'>Click to view all results</a>")
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
	$("##{choice}_more_results").empty()

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
	$("##{choice}_more_results").empty()
	# Clear URL field
	$("##{choice}_url_field").val('')

# Validate form, then submit if passed
submit_clicked = (elem) ->
	aText = $('#a_image_text')
	bText = $('#b_image_text')
	errors = new Array()
	if aText.val() == ''
		errors.push 'Left item needs a title or description<br/>'
		aText.css('border-color','red')
	if bText.val() == ''
		errors.push 'Right item needs a title or description<br/>'
		bText.css('border-color','red')
	if errors.length == 0 
		$('#tot_form').submit()
	else
		div = $('#new-tot-errors')
		div.empty()
		div.css('border','3px solid #ffff00')
		div.css('background-color','#666600')
		div.css('margin','auto')
		div.css('padding','5px')
		div.width(300)
		for error in errors
			div.append error


# INDEX
tr_clicked = (elem) ->
	id = elem.id
	window.location.href = "/tots/#{id}"
