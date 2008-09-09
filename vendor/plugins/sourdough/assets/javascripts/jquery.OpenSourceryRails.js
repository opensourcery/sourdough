// Rails specific Jquery overrides

jQuery.ajaxSetup({ 
    'beforeSend': function(xhr) {xhr.setRequestHeader("Accept",
      "text/javascript")} 
    })  

