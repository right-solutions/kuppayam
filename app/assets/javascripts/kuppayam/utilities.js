// loadANewPage will accept a url and will load a new page
// It can be tuned to show a lightbox showing a loading, please wait message.
function loadANewPage(url){
  // showLightBoxLoading();
  window.location.href=url;
}

// sendAjaxRequest is used to send an xml http request using javascript to a url using a method / get, put, post, delete
function sendAjaxRequest(url, mType){
  methodType = mType || "GET";
  jQuery.ajax({type: methodType, dataType:"script", url:url});
}

var genericModalId = "div_modal_generic";
var largeModalId = "div_modal_large";
var messageModalId = "div_modal_message";

// Call this function by passing  model Id, heading and a bodyContent.
// it will pop up bootstrap 3 modal.
function showGenericModal(heading, bodyContent){
  $('#' + genericModalId + ' .modal-header .modal-title').text(heading);
  $('#' + genericModalId + ' div.modal-body-main').html(bodyContent);
  $('#' + genericModalId).modal({show: true, backdrop: 'static', keyboard: false});
}

// Call this function by passing  model Id, heading and a bodyContent.
// it will pop up bootstrap 3 modal.
function showLargeModal(heading, bodyContent){
  $('#' + largeModalId + ' .modal-header .modal-title').text(heading);
  $('#' + largeModalId + ' div.modal-body-main').html(bodyContent);
  $('#' + largeModalId).modal({show: true, backdrop: 'static', keyboard: false});
}

// Call this function by passing  heading and a message.
// it will pop up bootstrap 3 modal which shows the heading and message as content body.
function showMessageModal(heading, message, modalId){
  if(modalId==null){
    var modalId = messageModalId;
  }
  var bodyContent = "<p>"+ message +"</p>";
  //$('#' + modalId + ' .modal-body').html("<p>"+ message +"</p>");
  $('#' + modalId + ' .modal-header h4.modal-title').text(heading);
  $('#' + modalId + ' div.modal-body').html(bodyContent);
  $('#' + modalId).modal({show: true, backdrop: 'static', keyboard: false});
  //$('#' + modalId + ' .modal-footer button.btn-primary').button('reset');
}

function closeGenericModal(modalId){
  $('#' + genericModalId).modal('hide');  
}

function closeLargeModal(modalId){
  $('#' + largeModalId).modal('hide');  
}

function closeMessageModal(modalId){
  $('#' + messageModalId).modal('hide');  
}

// function initPopovers(){
//   $('[data-toggle="popover"]').popover()
// }
// initPopovers();

// function initTooltip(){
//   $('[data-toggle="tooltip"]').tooltip()
// }
// initTooltip();
