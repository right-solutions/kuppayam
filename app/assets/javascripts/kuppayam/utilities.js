// loadANewPage will accept a url and will load a new page
// It can be tuned to show a lightbox showing a loading, please wait message.
function loadANewPage(url){
  window.location.href=url;
}

// sendAjaxRequest is used to send an xml http request using javascript to a url using a method / get, put, post, delete
function sendAjaxRequest(url, mType){
  methodType = mType || "GET";
  jQuery.ajax({type: methodType, dataType:"script", url:url});
}

var imageUploadModalId = "div_modal_image_upload";
var genericModalId = "div_modal_generic";
var largeModalId = "div_modal_large";
var messageModalId = "div_modal_message";

// Call this function by passing  model Id, heading and a bodyContent.
// it will pop up bootstrap 3 modal.
function showImageUploadModal(heading, bodyContent, showHeading){
  $('#' + imageUploadModalId + ' .modal-header .modal-title').text(heading);
  $('#' + imageUploadModalId + ' div.modal-body-main').html(bodyContent);
  $('#' + imageUploadModalId).modal({show: true, backdrop: 'static', keyboard: false});
  
  if(showHeading){
    $('#' + imageUploadModalId + ' .modal-header').show();
  }
  else {
    $('#' + imageUploadModalId + ' .modal-header').hide();
  }

  setTimeout(function() {
    $('#' + imageUploadModalId).modal('handleUpdate'); //Update backdrop on modal show
    $('#' + imageUploadModalId).scrollTop(0); //reset modal to top position
  }, 1000);
}

// Call this function by passing  model Id, heading and a bodyContent.
// it will pop up bootstrap 3 modal.
function showGenericModal(heading, bodyContent, showHeading){
  $('#' + genericModalId + ' .modal-header .modal-title').text(heading);
  $('#' + genericModalId + ' div.modal-body-main').html(bodyContent);
  $('#' + genericModalId).modal({show: true, backdrop: 'static', keyboard: false});
  
  if(showHeading){
    $('#' + genericModalId + ' .modal-header').show();
  }
  else {
    $('#' + genericModalId + ' .modal-header').hide();
  }

  setTimeout(function() {
    $('#' + genericModalId).modal('handleUpdate'); //Update backdrop on modal show
    $('#' + genericModalId).scrollTop(0); //reset modal to top position
  }, 1000);
}

// Call this function by passing  model Id, heading and a bodyContent.
// it will pop up bootstrap 3 modal.
function showLargeModal(heading, bodyContent, showHeading){
  $('#' + largeModalId + ' .modal-header .modal-title').text(heading);
  $('#' + largeModalId + ' div.modal-body-main').html(bodyContent);
  $('#' + largeModalId).modal({show: true, backdrop: 'static', keyboard: false});
  
  if(showHeading){
    $('#' + largeModalId + ' .modal-header').show();
  }
  else {
    $('#' + largeModalId + ' .modal-header').hide();
  }

  setTimeout(function() {
    $('#' + largeModalId).modal('handleUpdate'); //Update backdrop on modal show
    $('#' + largeModalId).scrollTop(0); //reset modal to top position
  }, 1000);
}

// Call this function by passing  heading and a message.
// it will pop up bootstrap 3 modal which shows the heading and message as content body.
function showMessageModal(heading, message, modalId){
  if(modalId==null){
    var modalId = messageModalId;
  }
  var bodyContent = "<p>"+ message +"</p>";
  //$('#' + modalId + ' .modal-body').html("<p>"+ message +"</p>");
  $('#' + modalId + ' .modal-header .modal-title').text(heading);
  $('#' + modalId + ' div.modal-body').html(bodyContent);
  $('#' + modalId).modal({show: true, backdrop: 'static', keyboard: false});
  //$('#' + modalId + ' .modal-footer button.btn-primary').button('reset');
  setTimeout(function() {
    $('#' + modalId).modal('handleUpdate'); //Update backdrop on modal show
    $('#' + modalId).scrollTop(0); //reset modal to top position
  }, 1000);
}

function closeImageUploadModal(modalId){
  $('#' + imageUploadModalId).modal('hide');  

  showAndHideModals();
}


function closeGenericModal(modalId){
  $('#' + genericModalId).modal('hide');  

  showAndHideModals();
}

function closeLargeModal(modalId){
  $('#' + largeModalId).modal('hide');
}

function closeMessageModal(modalId){
  $('#' + messageModalId).modal('hide');  

  showAndHideModals();
}

function showAndHideModals(){
  // Just hide and show other modals as there could 
  // be a problem with scrolling due to overlapping 
  // of 2 or more modals
  if( ($('#' + largeModalId).data('bs.modal') || {}).isShown == true ) {
    $('#' + largeModalId).modal('hide'); 
    $('#' + largeModalId).modal('show'); 
  }

  if( ($('#' + genericModalId).data('bs.modal') || {}).isShown == true ) {
    $('#' + genericModalId).modal('hide'); 
    $('#' + genericModalId).modal('show'); 
  }
}

function notifySuccess(title, message){
  var opts = {
    "closeButton": true,
    "debug": false,
    "positionClass": "toast-bottom-right",
    "onclick": null,
    "showDuration": "300",
    "hideDuration": "1000",
    "timeOut": "5000",
    "extendedTimeOut": "1000",
    "showEasing": "swing",
    "hideEasing": "linear",
    "showMethod": "fadeIn",
    "hideMethod": "fadeOut"
  };
  
  toastr.success(message, title, opts);
}

function notifyError(title, message){
  var opts = {
    "closeButton": true,
    "debug": false,
    "positionClass": "toast-bottom-right",
    "onclick": null,
    "showDuration": "300",
    "hideDuration": "1000",
    "timeOut": "5000",
    "extendedTimeOut": "1000",
    "showEasing": "swing",
    "hideEasing": "linear",
    "showMethod": "fadeIn",
    "hideMethod": "fadeOut"
  };
  
  toastr.error(message, title, opts);
}

function notifyInfo(title, message){
  var opts = {
    "closeButton": true,
    "debug": false,
    "positionClass": "toast-bottom-right",
    "onclick": null,
    "showDuration": "300",
    "hideDuration": "1000",
    "timeOut": "5000",
    "extendedTimeOut": "1000",
    "showEasing": "swing",
    "hideEasing": "linear",
    "showMethod": "fadeIn",
    "hideMethod": "fadeOut"
  };
  
  toastr.info(message, title, opts);
}

function convertToSlug(Text)
{
  return Text
    .toLowerCase()
    .replace(/[^\w ]+/g,'')
    .replace(/ +/g,'-')
    ;
}
