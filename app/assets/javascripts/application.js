// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require_tree .

$(function() {
  $("#article_published_on").datepicker();
});


function admin_approve(id) {
  $.get("/admin_approve_event/"+id, { id: id },
   function(data){
    $('#approve'+id).html('');
   });
}

//'displayFormat' : '#input/#max | #words words'
			var info;
			$(document).ready(function(){
				var options2 = {
						'maxCharacterSize': 55,
						'originalStyle': 'originalTextareaInfo',
						'warningStyle' : 'warningTextareaInfo',
						'warningNumber': 40,
						'displayFormat' : 'character limit: #input/#max'
				};
				$('#event_description').textareaCount(options2);

			});
