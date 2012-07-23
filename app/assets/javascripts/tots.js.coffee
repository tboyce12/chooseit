# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
$ ->
	$('#upload_a_image').change ->
		data = new FormData()
		jQuery.each($('#upload_a_image')[0].files, (i, file) ->
			data.append('file_'+i, file)
		)
		$.ajax({
			url:'/temp_files',
			data:data,
			cache:false,
			contentType:false,
			processData:false,
			type:'POST',
			success:(result,status,xhr)->
				image_upload_success(result, "a")
		})
	
	$('#upload_b_image').change ->
		data = new FormData()
		jQuery.each($('#upload_b_image')[0].files, (i, file) ->
			data.append('file_'+i, file)
		)
		$.ajax({
			url:'/temp_files',
			data:data,
			cache:false,
			contentType:false,
			processData:false,
			type:'POST',
			success:(result,status,xhr)->
				image_upload_success(result, "b")
		})
		
	image_upload_success = (url, choice) ->
		if choice == 'a'
			$('#a_image_preview').empty()
			$('#a_image_preview').append('<img src="'+url+'" alt="preview" />')
		else
			$('#b_image_preview').empty()
			$('#b_image_preview').append('<img src="'+url+'" alt="preview" />')
	
	$('#upload_a_image').hide()
	$('#a_image_preview').click ->
		$('#upload_a_image').click()
	
	$('#upload_b_image').hide()
	$('#b_image_preview').click ->
		$('#upload_b_image').click()
	
