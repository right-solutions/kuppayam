// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require kuppayam/utilities.js
//= require bootstrap.min.js
//= require moment.min.js
//= require TweenMax.min.js
//= require resizeable.js
//= require joinable.js
//= require xenon-api.js
//= require xenon-toggles.js
//= require xenon-custom.js
//= require wysihtml5/lib/js/wysihtml5-0.3.0.js
//= require wysihtml5/src/bootstrap-wysihtml5.js
//= require toastr/toastr.min.js
//= require daterangepicker/daterangepicker.js
//= require multiselect/js/jquery.multi-select.js
//= require uikit/js/addons/autocomplete.js
//= require tagsinput/bootstrap-tagsinput.min.js
//= require_self

if ( $(window).width() > 739) {      
  //Add your javascript for large screens here 
} 
else {
  //Add your javascript for small screens here 

  // This is to fix the dropdown-issue on lower screens
  // This issue is happeneing dueto the class collapsed which is required for large resolutions only
  // Hence we are removing it at the run time.
  $(".sidebar-menu").first().removeClass("collapsed")
}

