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
//= require toastr/toastr.min.js
//= require materialize/vanillatree.js
//= require materialize/vendors.min.js
//= require materialize/app.min.js
//= require materialize/hoe.js
// require wysihtml5/lib/js/wysihtml5-0.3.0.js
// require wysihtml5/src/bootstrap-wysihtml5.js
// require daterangepicker/daterangepicker.js
// require multiselect/js/jquery.multi-select.js
// require uikit/js/addons/autocomplete.js
// require tagsinput/bootstrap-tagsinput.min.js
//= require_self


    var treeView = document.getElementsByClassName("treeview"),
    tree = new VanillaTree( treeView, {
    });



    tree.add({
      label: 'Konica Minolta',
      // id: 'a',
      id: 'KonicaMinolta',
      opened: true
    });

    tree.add({
      label: 'UAE',
      parent: 'KonicaMinolta',
      // id: 'a.a',
      id: 'KM-UAE',
      opened: true,
      selected: true
    });

        tree.add({
          label: 'Dubai',
          parent: 'KM-UAE',
          // id: 'a.a',
          id: 'KM-Dubai',
          opened: true,
          selected: false
        });
            tree.add({
              label: 'Juma Al Majid',
              parent: 'KM-Dubai'
            });
            tree.add({
              label: 'ACS',
              parent: 'KM-Dubai'
            });


            tree.add({
              label: 'Abu Dhabi',
              parent: 'KM-UAE',
              // id: 'a.a',
              id: 'KM-AbuDhabi',
              opened: true,
              selected: false
            });
                tree.add({
                  label: 'Al Mulla Group',
                  parent: 'KM-AbuDhabi'
                });
                tree.add({
                  label: 'MHD',
                  parent: 'KM-AbuDhabi'
                });


            tree.add({
              label: 'Sharjah',
              parent: 'KM-UAE',
              // id: 'a.a',
              id: 'KM-Sharjah',
              opened: true,
              selected: false
            });
                tree.add({
                  label: 'HCL',
                  parent: 'KM-Sharjah'
                });
                tree.add({
                  label: 'A&P',
                  parent: 'KM-Sharjah'
                });





      tree.add({
      label: 'Saudi Arabia',
      parent: 'KonicaMinolta',
      // id: 'a.a',
      id: 'KM-SaudiArabia',
      opened: true,
      selected: false
    });


        tree.add({
          label: 'Riyadh',
          parent: 'KM-SaudiArabia',
          // id: 'a.a',
          id: 'KM-Riyadh',
          opened: true,
          selected: false
        });
        
        tree.add({
          label: 'ABC',
          parent: 'KM-Riyadh'
        });


        tree.add({
          label: 'Jeddah',
          parent: 'KM-SaudiArabia',
          // id: 'a.a',
          id: 'KM-Jeddah',
          opened: true,
          selected: false
        });
        
        tree.add({
          label: 'XYC',
          parent: 'KM-Jeddah'
        });
       


            


    // // -----------------------------



    treeView.addEventListener('vtree-open', function(evt) {
      info.innerHTML = evt.detail.id + ' is opened';
    });

    treeView.addEventListener('vtree-close', function(evt) {
      info.innerHTML = evt.detail.id + ' is closed';
    });

    treeView.addEventListener('vtree-select', function(evt) {
      info.innerHTML = evt.detail.id + ' is selected';
    });
