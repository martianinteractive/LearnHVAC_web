//= require jquery.min
//= require jquery-ui
//= require jquery_ujs
//= require jquery.dataTables.min
//= require jquery.tablesorter
//= require jquery.fcbkcomplete.min
//= require prettify
//= require bootstrap-twipsy
//= require bootstrap-alerts
//= require bootstrap-dropdown
//= require bootstrap-modal
//= require bootstrap-popover
//= require bootstrap-scrollspy
//= require bootstrap-tabs
//= require picnet.table.filter.min

$(function () { prettyPrint() });

$(document).ready(function() {

  popoverSettings = {};
  $('a[rel="popover"]').popover(popoverSettings);

  $('.flash.alert-message').delay(3000).slideUp();

  $('#filterbutton').click(function() {
    $('#filter_panel').toggle();
  });

  $('#sortTableExample').tableFilter();

  // table sort example
  // ==================
  var table = $('#sortTableExample');
  if ( 0 < table.length ) {
    table.tablesorter( { sortList: [[ 1, 0 ]] } );
  }

  // add on logic
  // ============
  $('.add-on :checkbox').click(function () {
    if ($(this).attr('checked')) {
      $(this).parents('.add-on').addClass('active')
    } else {
      $(this).parents('.add-on').removeClass('active')
    }
  })

  // Copy code blocks in docs
  $(".copy-code").focus(function () {
    var el = this;
    // push select to event loop for chrome :{o
    setTimeout(function () { $(el).select(); }, 0);
  });


  // POSITION STATIC TWIPSIES
  // ========================
  $(window).bind( 'load resize', function () {
    $(".twipsies a").each(function () {
       $(this)
        .twipsy({
          live: false
        , placement: $(this).attr('title')
        , trigger: 'manual'
        , offset: 2
        })
        .twipsy('show')
      })
  })
});

$(document).scroll(function(){

  var tableThead = $("#sortTableExample thead");
  if ( 0 < tableThead.length ) {
      var delta = $(window).scrollTop() - tableThead.offset().top + 38;
      if(delta > 0)
      {
          translate($("#sortTableExample th"),0,delta-2);
      }
      else
      {
          translate($("#sortTableExample th"),0,0);
      }
  }
});

function translate(element, x, y)
{
    var translation = "translate(" + x + "px," + y + "px)"

    element.css({
        "transform": translation,
        "-ms-transform": translation,
        "-webkit-transform": translation,
        "-o-transform": translation,
        "-moz-transform": translation
    });
}
